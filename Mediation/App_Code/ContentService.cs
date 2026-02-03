using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Runtime.Caching;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

[WebService(Namespace = "services")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[ScriptService]
public class ContentService : WebService
{
    private string connStr =
        ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

    private ObjectCache cache = MemoryCache.Default;

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

    private void ClearServiceCache(string serviceType)
    {
        if (!string.IsNullOrEmpty(serviceType))
            cache.Remove("SERVICES_" + serviceType);
    }

    private void DeleteImageIfExists(string imageUrl)
    {
        if (string.IsNullOrEmpty(imageUrl)) return;

        string path = Server.MapPath(imageUrl);
        if (File.Exists(path))
            File.Delete(path);
    }

    private string SaveUploadedImage(string virtualFolder, string prefix)
    {
        HttpRequest req = HttpContext.Current.Request;

        if (req.Files.Count == 0)
            throw new Exception("No file uploaded");

        HttpPostedFile file = req.Files[0];
        string ext = Path.GetExtension(file.FileName);

        string folderPath = Server.MapPath(virtualFolder);
        if (!Directory.Exists(folderPath))
            Directory.CreateDirectory(folderPath);

        string fileName = prefix + Guid.NewGuid().ToString("N") + ext;
        file.SaveAs(Path.Combine(folderPath, fileName));

        return virtualFolder.Replace("~", "") + fileName;
    }

    /* ===================== SERVICES ===================== */

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetServices(string serviceType)
    {
        string cacheKey = "SERVICES_" + serviceType;
        if (cache[cacheKey] != null)
            return cache[cacheKey].ToString();

        var list = new List<object>();

        using (SqlConnection con = new SqlConnection(connStr))
        using (SqlCommand cmd = new SqlCommand(@"
            SELECT ServiceId, Title, ShortDescription, Description, ImageUrl
            FROM CMS_Services
            WHERE Category=@Type
            ORDER BY ServiceId ASC", con))
        {
            cmd.Parameters.AddWithValue("@Type", serviceType);
            con.Open();

            using (SqlDataReader dr = cmd.ExecuteReader())
            {
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
        }

        string json = Ok(list);
        cache.Set(cacheKey, json, DateTimeOffset.Now.AddMinutes(30));
        return json;
    }

    [WebMethod(EnableSession = true)]
    public string UploadServiceImage()
    {
        try
        {
            string url = SaveUploadedImage("~/Uploads/Services/", "");
            return Ok(url);
        }
        catch (Exception ex)
        {
            return Fail(ex.Message);
        }
    }

    [WebMethod(EnableSession = true)]
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
                VALUES (@T,'',@D,@I,@C)", con))
            {
                cmd.Parameters.AddWithValue("@T", title);
                cmd.Parameters.AddWithValue("@D", description);
                cmd.Parameters.AddWithValue("@I", imageUrl ?? "");
                cmd.Parameters.AddWithValue("@C", serviceType);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            ClearServiceCache(serviceType);
            return Ok(null, "Saved successfully");
        }
        catch (Exception ex)
        {
            return Fail(ex.Message);
        }
    }

    [WebMethod]
    public string DeleteServiceHard(int serviceId)
    {
        try
        {
            string imageUrl = "";
            string serviceType = "";

            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(
                "SELECT ImageUrl, Category FROM CMS_Services WHERE ServiceId=@Id", con))
            {
                cmd.Parameters.AddWithValue("@Id", serviceId);
                con.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (!dr.Read())
                        return Fail("Service not found");

                    imageUrl = dr["ImageUrl"].ToString();
                    serviceType = dr["Category"].ToString();
                }
            }

            DeleteImageIfExists(imageUrl);

            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(
                "DELETE FROM CMS_Services WHERE ServiceId=@Id", con))
            {
                cmd.Parameters.AddWithValue("@Id", serviceId);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            ClearServiceCache(serviceType);
            return Ok(null, "Service deleted permanently");
        }
        catch (Exception ex)
        {
            return Fail(ex.Message);
        }
    }

    /* ===================== TEAMS ===================== */

    [WebMethod]
    public string UploadTeamImage()
    {
        try
        {
            string url = SaveUploadedImage("~/Uploads/Teams/", "team_");
            return Ok(url);
        }
        catch (Exception ex)
        {
            return Fail(ex.Message);
        }
    }

    [WebMethod]
    public string SaveTeam(string name, string designation, string imageUrl)
    {
        try
        {
            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(@"
                INSERT INTO CMS_Teams
                (Name, Designation, ImageUrl)
                VALUES (@N,@D,@I)", con))
            {
                cmd.Parameters.AddWithValue("@N", name);
                cmd.Parameters.AddWithValue("@D", designation);
                cmd.Parameters.AddWithValue("@I", imageUrl);
                

                con.Open();
                cmd.ExecuteNonQuery();
            }

            return Ok(null);
        }
        catch (Exception ex)
        {
            return Fail(ex.Message);
        }
    }

    [WebMethod]
    public string GetTeams()
    {
        var list = new List<object>();

        using (SqlConnection con = new SqlConnection(connStr))
        using (SqlCommand cmd = new SqlCommand(@"
            SELECT TeamId, Name, Designation, ImageUrl
            FROM CMS_Teams
            WHERE IsActive=1
            ORDER BY SortOrder", con))
        {
            con.Open();
            using (SqlDataReader dr = cmd.ExecuteReader())
            {
                while (dr.Read())
                {
                    list.Add(new
                    {
                        TeamId = dr["TeamId"],
                        Name = dr["Name"],
                        Designation = dr["Designation"],
                        ImageUrl = dr["ImageUrl"]
                    });
                }
            }
        }

        return Ok(list);
    }

    [WebMethod]
    public string DeleteTeam(int teamId)
    {
        try
        {
            string imageUrl = "";

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                SqlCommand get = new SqlCommand(
                    "SELECT ImageUrl FROM CMS_Teams WHERE TeamId=@Id", con);
                get.Parameters.AddWithValue("@Id", teamId);
                imageUrl = Convert.ToString(get.ExecuteScalar());

                SqlCommand del = new SqlCommand(
                    "DELETE FROM CMS_Teams WHERE TeamId=@Id", con);
                del.Parameters.AddWithValue("@Id", teamId);
                del.ExecuteNonQuery();
            }

            DeleteImageIfExists(imageUrl);
            return Ok(null);
        }
        catch (Exception ex)
        {
            return Fail(ex.Message);
        }
    }
}
