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
    private string connStr =
        ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

    private ObjectCache cache = MemoryCache.Default;
    private const string CACHE_KEY = "TESTIMONIAL_LIST";

    /* ===================== HELPERS ===================== */

    private string Ok(object data)
    {
        return JsonHelper.ToJson(ApiResponse<object>.Ok(data));
    }

    private string Ok(object data, string msg)
    {
        return JsonHelper.ToJson(ApiResponse<object>.Ok(data, msg));
    }

    private string Fail(string msg)
    {
        return JsonHelper.ToJson(ApiResponse<object>.Fail(msg));
    }

    private void ClearCache()
    {
        cache.Remove(CACHE_KEY);
    }

    /* ===================== GET ===================== */

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetTestimonials()
    {
        if (cache[CACHE_KEY] != null)
            return cache[CACHE_KEY].ToString();

        var list = new List<object>();

        using (SqlConnection con = new SqlConnection(connStr))
        using (SqlCommand cmd = new SqlCommand(@"
            SELECT TestimonialId, Title, Message, AuthorName, Designation
            FROM CMS_Testimonials
            WHERE IsActive=1
            ORDER BY DisplayOrder DESC", con))
        {
            con.Open();
            using (SqlDataReader dr = cmd.ExecuteReader())
            {
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
        }

        string json = Ok(list);
        cache.Set(CACHE_KEY, json, DateTimeOffset.Now.AddMinutes(30));
        return json;
    }

    /* ===================== SAVE ===================== */

    [WebMethod]
    public string SaveTestimonial(
        int testimonialId,
        string title,
        string message,
        string authorName,
        string designation)
    {
        try
        {
            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.Connection = con;

                if (testimonialId == 0)
                {
                    cmd.CommandText = @"
                        INSERT INTO CMS_Testimonials
                        (Title, Message, AuthorName, Designation)
                        VALUES (@T,@M,@A,@D)";
                }
                else
                {
                    cmd.CommandText = @"
                        UPDATE CMS_Testimonials SET
                        Title=@T, Message=@M, AuthorName=@A, Designation=@D
                        WHERE TestimonialId=@Id";
                    cmd.Parameters.AddWithValue("@Id", testimonialId);
                }

                cmd.Parameters.AddWithValue("@T", title);
                cmd.Parameters.AddWithValue("@M", message);
                cmd.Parameters.AddWithValue("@A", authorName);
                cmd.Parameters.AddWithValue("@D", designation);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            ClearCache();
            return Ok(null, "Saved successfully");
        }
        catch (Exception ex)
        {
            return Fail(ex.Message);
        }
    }

    /* ===================== DELETE ===================== */

    [WebMethod]
    public string DeleteTestimonial(int testimonialId)
    {
        try
        {
            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(
                "DELETE FROM CMS_Testimonials WHERE TestimonialId=@Id", con))
            {
                cmd.Parameters.AddWithValue("@Id", testimonialId);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            ClearCache();
            return Ok(null, "Deleted");
        }
        catch (Exception ex)
        {
            return Fail(ex.Message);
        }
    }

    /* ===================== REORDER ===================== */

    [WebMethod]
    public string UpdateOrder(int testimonialId, int order)
    {
        try
        {
            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(
                "UPDATE CMS_Testimonials SET DisplayOrder=@O WHERE TestimonialId=@Id", con))
            {
                cmd.Parameters.AddWithValue("@Id", testimonialId);
                cmd.Parameters.AddWithValue("@O", order);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            ClearCache();
            return Ok(null);
        }
        catch (Exception ex)
        {
            return Fail(ex.Message);
        }
    }
}
