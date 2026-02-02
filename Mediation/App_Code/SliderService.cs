using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Runtime.Caching;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

[WebService(Namespace = "http://cms/")]
[ScriptService]
public class SliderService : WebService
{
    string connStr = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
    ObjectCache cache = MemoryCache.Default;
    const string CACHE_KEY = "SLIDER_LIST";

    // ================= GET =================
    [WebMethod]
    [ScriptMethod(ResponseFormat = System.Web.Script.Services.ResponseFormat.Json)]
    public string GetSliders()
    {
        if (cache[CACHE_KEY] != null)
            return cache[CACHE_KEY].ToString();

        var list = new List<object>();

        using (SqlConnection con = new SqlConnection(connStr))
        using (SqlCommand cmd = new SqlCommand("SELECT * FROM CMS_HomeSliders ORDER BY DisplayOrder", con))
        {
            con.Open();
            SqlDataReader dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                list.Add(new
                {
                    SliderId = dr["SliderId"],
                    ImagePath = dr["ImagePath"]
                });
            }
        }

        string json = JsonHelper.ToJson(ApiResponse<object>.Ok(list));
        cache.Set(CACHE_KEY, json, DateTimeOffset.Now.AddMinutes(30));
        return json;
    }

    // ================= UPLOAD FILE =================
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public void UploadSliderFile()
    {
        HttpContext.Current.Response.ContentType = "application/json";
        HttpContext context = HttpContext.Current;

        try
        {
            if (context.Request.Files.Count == 0)
            {
                HttpContext.Current.Response.Write(JsonHelper.ToJson(ApiResponse<object>.Fail("No file uploaded")));
                return; // stop execution without Response.End()
            }

            HttpPostedFile file = context.Request.Files["sliderImage"];
            if (file == null || file.ContentLength == 0)
            {
                HttpContext.Current.Response.Write(JsonHelper.ToJson(ApiResponse<object>.Fail("Invalid file")));
                return;
            }

            string uploadsFolder = context.Server.MapPath("~/Uploads/Slider/");
            if (!Directory.Exists(uploadsFolder)) Directory.CreateDirectory(uploadsFolder);

            string fileName = Guid.NewGuid().ToString() + "_" + Path.GetFileName(file.FileName);
            string filePath = Path.Combine(uploadsFolder, fileName);
            file.SaveAs(filePath);

            string imagePath = "/Uploads/Slider/" + fileName;

            // Save to DB
            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(
                "INSERT INTO CMS_HomeSliders (ImagePath, DisplayOrder) VALUES (@P, (SELECT ISNULL(MAX(DisplayOrder),0)+1 FROM CMS_HomeSliders))", con))
            {
                cmd.Parameters.AddWithValue("@P", imagePath);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            cache.Remove(CACHE_KEY);
            HttpContext.Current.Response.Write(JsonHelper.ToJson(ApiResponse<object>.Ok(null, "Slider uploaded successfully!")));
            return;
        }
        catch (Exception ex)
        {
            HttpContext.Current.Response.Write(JsonHelper.ToJson(ApiResponse<object>.Fail(ex.Message)));
            return;
        }
    }


    // ================= DELETE =================
    [WebMethod]
    [ScriptMethod(ResponseFormat = System.Web.Script.Services.ResponseFormat.Json)]
    public string DeleteSlider(int sliderId)
    {
        using (SqlConnection con = new SqlConnection(connStr))
        using (SqlCommand cmd = new SqlCommand(
            "DELETE FROM CMS_HomeSliders WHERE SliderId=@ID", con))
        {
            cmd.Parameters.AddWithValue("@ID", sliderId);
            con.Open();
            cmd.ExecuteNonQuery();
        }

        cache.Remove(CACHE_KEY);
        return JsonHelper.ToJson(ApiResponse<object>.Ok(null, "Deleted"));
    }

    // ================= REORDER =================
    [WebMethod]
    [ScriptMethod(ResponseFormat = System.Web.Script.Services.ResponseFormat.Json)]
    public string UpdateSliderOrder(List<OrderItem> order)
    {
        using (SqlConnection con = new SqlConnection(connStr))
        {
            con.Open();
            foreach (var o in order)
            {
                using (SqlCommand cmd = new SqlCommand("UPDATE CMS_HomeSliders SET DisplayOrder=@O WHERE SliderId=@ID", con))
                {
                    cmd.Parameters.AddWithValue("@ID", o.SliderId);
                    cmd.Parameters.AddWithValue("@O", o.Order);
                    cmd.ExecuteNonQuery();
                }
            }
        }

        cache.Remove(CACHE_KEY);
        return JsonHelper.ToJson(ApiResponse<object>.Ok(null, "Order updated"));
    }

    public class OrderItem
    {
        public int SliderId { get; set; }
        public int Order { get; set; }
    }
}
