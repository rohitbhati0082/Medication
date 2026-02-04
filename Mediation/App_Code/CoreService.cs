using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Runtime.Caching;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

[WebService(Namespace = "services")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[ScriptService]
public class CoreService : WebService
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

    private void DeleteImageIfExists(string fileUrl)
    {
        if (string.IsNullOrEmpty(fileUrl)) return;

        string path = Server.MapPath(fileUrl);
        if (File.Exists(path))
            File.Delete(path);
    }

    private string SaveUploadedFile(string virtualFolder, string prefix)
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

    /* ===================== GET ===================== */

    [WebMethod]
    public string GetEventMediaByCategory(string category)
    {
        try
        {
            var list = new List<object>();

            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(@"
                SELECT
                    Id, Category, Title, Description, MediaType,
                    ImagePath, PdfPath, YoutubeUrl,
                    OrganizerName, OrganizerPhone, OrganizerEmail
                FROM CMS_EventMedia
                WHERE Category = @Category AND IsActive = 1
                ORDER BY CreatedOn DESC", con))
            {
                cmd.Parameters.AddWithValue("@Category", category);
                con.Open();

                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    list.Add(new
                    {
                        Id = Convert.ToInt32(dr["Id"]),
                        Category = dr["Category"].ToString(),
                        Title = dr["Title"].ToString(),
                        Description = dr["Description"] as string,
                        MediaType = dr["MediaType"].ToString(),
                        ImagePath = dr["ImagePath"] as string,
                        PdfPath = dr["PdfPath"] as string,
                        YoutubeUrl = dr["YoutubeUrl"] as string,

                        OrganizerName = dr["OrganizerName"] as string,
                        OrganizerPhone = dr["OrganizerPhone"] as string,
                        OrganizerEmail = dr["OrganizerEmail"] as string
                    });
                }
            }

            return Ok(list);
        }
        catch (Exception ex)
        {
            return Fail(ex.Message);
        }
    }

    /* ===================== INSERT / UPDATE ===================== */

    [WebMethod]
    public string SaveEventMedia(
        int id,
        string category,
        string title,
        string description,
        string mediaType,
        string imagePath,
        string pdfPath,
        string youtubeUrl,
        string organizerName,
        string organizerPhone,
        string organizerEmail)
    {
        try
        {
            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.Connection = con;

                if (id == 0)
                {
                    cmd.CommandText = @"
                        INSERT INTO CMS_EventMedia
                        (
                            Category, Title, Description, MediaType,
                            ImagePath, PdfPath, YoutubeUrl,
                            OrganizerName, OrganizerPhone, OrganizerEmail
                        )
                        VALUES
                        (
                            @Category, @Title, @Description, @MediaType,
                            @ImagePath, @PdfPath, @YoutubeUrl,
                            @OrganizerName, @OrganizerPhone, @OrganizerEmail
                        )";
                }
                else
                {
                    cmd.CommandText = @"
                        UPDATE CMS_EventMedia SET
                            Category        = @Category,
                            Title           = @Title,
                            Description     = @Description,
                            MediaType       = @MediaType,
                            ImagePath       = @ImagePath,
                            PdfPath         = @PdfPath,
                            YoutubeUrl      = @YoutubeUrl,
                            OrganizerName   = @OrganizerName,
                            OrganizerPhone  = @OrganizerPhone,
                            OrganizerEmail  = @OrganizerEmail
                        WHERE Id = @Id";

                    cmd.Parameters.AddWithValue("@Id", id);
                }

                cmd.Parameters.AddWithValue("@Category", category);
                cmd.Parameters.AddWithValue("@Title", title);
                cmd.Parameters.AddWithValue("@Description", (object)description ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@MediaType", mediaType);
                cmd.Parameters.AddWithValue("@ImagePath", (object)imagePath ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@PdfPath", (object)pdfPath ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@YoutubeUrl", (object)youtubeUrl ?? DBNull.Value);

                cmd.Parameters.AddWithValue("@OrganizerName", (object)organizerName ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@OrganizerPhone", (object)organizerPhone ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@OrganizerEmail", (object)organizerEmail ?? DBNull.Value);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            return Ok(null, "Saved successfully");
        }
        catch (Exception ex)
        {
            return Fail(ex.Message);
        }
    }


    /* ===================== DELETE ===================== */

    [WebMethod]
    public string DeleteEventMedia(int id)
    {
        try
        {
            string imagePath = null;
            string pdfPath = null;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                using (SqlCommand cmd = new SqlCommand(
                    "SELECT ImagePath, PdfPath FROM CMS_EventMedia WHERE Id=@Id", con))
                {
                    cmd.Parameters.AddWithValue("@Id", id);
                    SqlDataReader dr = cmd.ExecuteReader();
                    if (dr.Read())
                    {
                        imagePath = dr["ImagePath"] as string;
                        pdfPath = dr["PdfPath"] as string;
                    }
                    dr.Close();
                }

                using (SqlCommand cmd = new SqlCommand(
                    "DELETE FROM CMS_EventMedia WHERE Id=@Id", con))
                {
                    cmd.Parameters.AddWithValue("@Id", id);
                    cmd.ExecuteNonQuery();
                }
            }

            DeleteImageIfExists(imagePath);
            DeleteImageIfExists(pdfPath);

            return Ok(null, "Deleted successfully");
        }
        catch (Exception ex)
        {
            return Fail(ex.Message);
        }
    }

    /* ===================== UPLOADS ===================== */

    [WebMethod]
    public string UploadEventImage()
    {
        try
        {
            string path = SaveUploadedFile("~/uploads/events/", "EVT_");
            return Ok(path);
        }
        catch (Exception ex)
        {
            return Fail(ex.Message);
        }
    }

    [WebMethod]
    public string UploadGalleryImage()
    {
        try
        {
            string path = SaveUploadedFile("~/uploads/gallery/", "GAL_");
            return Ok(path);
        }
        catch (Exception ex)
        {
            return Fail(ex.Message);
        }
    }

    [WebMethod]
    public string UploadPdf()
    {
        try
        {
            string path = SaveUploadedFile("~/uploads/pdfs/", "PDF_");
            return Ok(path);
        }
        catch (Exception ex)
        {
            return Fail(ex.Message);
        }
    }
}
