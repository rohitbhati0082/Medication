using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Runtime.Caching;
using System.Web.Script.Services;
using System.Web.Services;

[WebService(Namespace = "http://cms/")]
[ScriptService]
public class TestimonialService : WebService
{
    string connStr = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
    ObjectCache cache = MemoryCache.Default;
    const string CACHE_KEY = "TESTIMONIAL_LIST";

    // ================= GET (CACHED) =================
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetTestimonials()
    {
        if (cache[CACHE_KEY] != null)
            return cache[CACHE_KEY].ToString();

        var list = new List<object>();

        using (SqlConnection con = new SqlConnection(connStr))
        using (SqlCommand cmd = new SqlCommand(
            @"SELECT * FROM CMS_Testimonials 
              WHERE IsActive = 1 
              ORDER BY 1 desc", con))
        {
            con.Open();
            var dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                list.Add(new
                {
                    TestimonialId = dr["TestimonialId"],
                    Title = dr["Title"],
                    Message = dr["Message"],
                    AuthorName = dr["AuthorName"],
                    Designation = dr["Designation"]
                });
            }
        }

        string json = JsonHelper.ToJson(ApiResponse<object>.Ok(list));
        cache.Set(CACHE_KEY, json, DateTimeOffset.Now.AddMinutes(30));
        return json;
    }

    // ================= ADD / UPDATE =================
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SaveTestimonial(
        int testimonialId,
        string title,
        string message,
        string authorName,
        string designation)
    {
        using (SqlConnection con = new SqlConnection(connStr))
        {
            con.Open();

            SqlCommand cmd;
            if (testimonialId == 0)
            {
                cmd = new SqlCommand(
                    @"INSERT INTO CMS_Testimonials
                      (Title, Message, AuthorName, Designation)
                      VALUES (@T,@M,@A,@D)", con);
            }
            else
            {
                cmd = new SqlCommand(
                    @"UPDATE CMS_Testimonials SET
                      Title=@T, Message=@M, AuthorName=@A, Designation=@D
                      WHERE TestimonialId=@ID", con);
                cmd.Parameters.AddWithValue("@ID", testimonialId);
            }

            cmd.Parameters.AddWithValue("@T", title);
            cmd.Parameters.AddWithValue("@M", message);
            cmd.Parameters.AddWithValue("@A", authorName);
            cmd.Parameters.AddWithValue("@D", designation);
            cmd.ExecuteNonQuery();
        }

        cache.Remove(CACHE_KEY);
        return JsonHelper.ToJson(ApiResponse<object>.Ok(null, "Saved successfully"));
    }

    // ================= DELETE =================
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string DeleteTestimonial(int testimonialId)
    {
        using (SqlConnection con = new SqlConnection(connStr))
        using (SqlCommand cmd = new SqlCommand(
            "DELETE FROM CMS_Testimonials WHERE TestimonialId=@ID", con))
        {
            cmd.Parameters.AddWithValue("@ID", testimonialId);
            con.Open();
            cmd.ExecuteNonQuery();
        }

        cache.Remove(CACHE_KEY);
        return JsonHelper.ToJson(ApiResponse<object>.Ok(null, "Deleted"));
    }

    // ================= REORDER =================
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string UpdateOrder(int testimonialId, int order)
    {
        using (SqlConnection con = new SqlConnection(connStr))
        using (SqlCommand cmd = new SqlCommand(
            "UPDATE CMS_Testimonials SET DisplayOrder=@O WHERE TestimonialId=@ID", con))
        {
            cmd.Parameters.AddWithValue("@ID", testimonialId);
            cmd.Parameters.AddWithValue("@O", order);
            con.Open();
            cmd.ExecuteNonQuery();
        }

        cache.Remove(CACHE_KEY);
        return JsonHelper.ToJson(ApiResponse<object>.Ok(null));
    }
}
