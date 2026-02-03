using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Runtime.Caching;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
/// <summary>                 
/// Summary description for ContentService
/// </summary>
[WebService(Namespace = "services")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[ScriptService]
public class ContentService : WebService
{
    private readonly string connStr =
       ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

    ObjectCache cache = MemoryCache.Default;

    /* =========================================================
       GET SERVICES / PRO BONO (CARD VIEW BINDING)
       ========================================================= */

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetServices(string serviceType)
    {
        string cacheKey = "SERVICES_" + serviceType;

        if (cache[cacheKey] != null)
            return cache[cacheKey].ToString();

        var list = new List<object>();

        using (SqlConnection con = new SqlConnection(connStr))
        using (SqlCommand cmd = new SqlCommand(
            @"SELECT ServiceId, Title, ShortDescription,Description, ImageUrl 
                  FROM CMS_Services
                  WHERE Category = @ServiceType
                  ORDER BY ServiceId Asc", con))
        {
            cmd.Parameters.AddWithValue("@ServiceType", serviceType);
            con.Open();

            var dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                list.Add(new
                {
                    ServiceId = dr["ServiceId"],
                    Title = dr["Title"],
                    Description = dr["Description"],
                    ShortDescription = dr["ShortDescription"],
                    ImageUrl = dr["ImageUrl"]
                });
            }
        }

        string json = JsonHelper.ToJson(ApiResponse<object>.Ok(list));
        cache.Set(cacheKey, json, DateTimeOffset.Now.AddMinutes(30));

        return json;
    }

    /* =========================================================
  /* =========================================================
   CREATE SERVICE / PRO BONO (FILE + JSON POST)
   ========================================================= */
    /* =========================================================
    UPLOAD SERVICE IMAGE (FILE ONLY)
    ========================================================= */
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string UploadServiceImage()
    {
        try
        {
            HttpRequest request = HttpContext.Current.Request;

            if (request.Files.Count == 0)
                return JsonHelper.ToJson(ApiResponse<object>.Fail("No file uploaded"));

            HttpPostedFile file = request.Files[0];

            string folder = "~/Uploads/Services/";
            string physicalPath = HttpContext.Current.Server.MapPath(folder);

            if (!Directory.Exists(physicalPath))
                Directory.CreateDirectory(physicalPath);

            string fileName = Guid.NewGuid() + Path.GetExtension(file.FileName);
            string fullPath = Path.Combine(physicalPath, fileName);

            file.SaveAs(fullPath);

            string imageUrl = folder.Replace("~", "") + fileName;

            return JsonHelper.ToJson(ApiResponse<object>.Ok(imageUrl));
        }
        catch (Exception ex)
        {
            return JsonHelper.ToJson(ApiResponse<object>.Fail(ex.Message));
        }
    }
    /* =========================================================
       SAVE SERVICE (JSON POST ONLY)
       ========================================================= */
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SaveService(
        int serviceId,
        string title,
        string description,
        string imageUrl,
        string serviceType)
    {
        try
        {
            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(@"
            INSERT INTO CMS_Services
            (Title, ShortDescription, Description, ImageUrl, Category)
            VALUES (@Title, '', @Desc, @ImageUrl, @Type)", con))
            {
                cmd.Parameters.AddWithValue("@Title", title);
                cmd.Parameters.AddWithValue("@Desc", description);
                cmd.Parameters.AddWithValue("@ImageUrl", imageUrl ?? "");
                cmd.Parameters.AddWithValue("@Type", serviceType);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            cache.Remove("SERVICES_" + serviceType);

            return JsonHelper.ToJson(ApiResponse<object>.Ok("Saved successfully"));
        }
        catch (Exception ex)
        {
            return JsonHelper.ToJson(ApiResponse<object>.Fail(ex.Message));
        }
    }


    /// <summary>
    /// Input model for JSON POST
    /// </summary>
    public class ServiceInput
    {
        public string Title { get; set; }
        public string Description { get; set; }
        public string ServiceType { get; set; } // "SERVICE" or "PROBONO"
    }
    /* =========================================================
       HARD DELETE + IMAGE CLEANUP
       ========================================================= */

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string DeleteServiceHard(int serviceId)
    {
        try
        {
            string ImageUrl = "";
            string serviceType = "";

            // 1. Get image path + service type
            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(
                "SELECT ImageUrl, Category as ServiceType FROM CMS_Services WHERE ServiceId=@ServiceId", con))
            {
                cmd.Parameters.Add("@ServiceId", SqlDbType.Int).Value = serviceId;
                con.Open();

                using (var dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        ImageUrl = dr["ImageUrl"]+"";
                        serviceType = dr["ServiceType"]+"";
                    }
                    else
                    {
                        return JsonHelper.ToJson(ApiResponse<object>.Fail("Service not found"));
                    }
                }
            }

            // 2. Delete image file
            if (!string.IsNullOrEmpty(ImageUrl))
            {
                string fullPath = Server.MapPath(ImageUrl);
                if (File.Exists(fullPath))
                    File.Delete(fullPath);
            }

            // 3. Hard delete record
            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(
                "DELETE FROM CMS_Services WHERE ServiceId=@ServiceId", con))
            {
                cmd.Parameters.Add("@ServiceId", SqlDbType.Int).Value = serviceId;
                con.Open();
                cmd.ExecuteNonQuery();
            }

            // 4. CLEAR CACHE ✅
            if (!string.IsNullOrEmpty(serviceType))
                cache.Remove("SERVICES_" + serviceType);

            return JsonHelper.ToJson(ApiResponse<object>.Ok("Service deleted permanently"));
        }
        catch (Exception ex)
        {
            return JsonHelper.ToJson(ApiResponse<object>.Fail(ex.Message));
        }
    }

}
