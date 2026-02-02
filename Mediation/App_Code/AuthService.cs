using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

/// <summary>                 
/// Summary description for AuthService
/// </summary>
[WebService(Namespace = "auth")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[ScriptService]
public class AuthService : WebService
{
    private readonly string connStr = 
       ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string Login(string username, string password)
    {
        try
        {
            if (string.IsNullOrWhiteSpace(username) || string.IsNullOrWhiteSpace(password))
                return JsonHelper.ToJson(ApiResponse<object>.Fail("Username and password are required"));

            // ================= EMERGENCY HARD-CODED ADMIN =================
            if (username == "admin" && password == "admin00@4")
            {
                string emergencyToken = JwtTokenHelper.GenerateToken(0, 0, "Admin");
                return JsonHelper.ToJson(ApiResponse<object>.Ok(new { Token = emergencyToken, Role = "Admin" }, "Emergency admin login"));
            }

            // ================= DATABASE LOGIN =================
            string hashedPassword = HashPassword(password);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                // 1. Authenticate User
                int userId = 0;
                string role = "";

                using (SqlCommand cmd = new SqlCommand(
                    @"SELECT UserId, Role FROM CMS_Users 
                   WHERE Username = @U AND PasswordHash = @P AND IsActive = 1", con))
                {
                    cmd.Parameters.AddWithValue("@U", username);
                    cmd.Parameters.AddWithValue("@P", hashedPassword);

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (!dr.Read())
                            return JsonHelper.ToJson(ApiResponse<object>.Fail("Invalid credentials"));

                        userId = Convert.ToInt32(dr["UserId"]);
                        role = dr["Role"].ToString();
                    }
                }

                
                // 3. Generate Token if all checks pass
                string token = JwtTokenHelper.GenerateToken(userId, 0, role);
                return JsonHelper.ToJson(ApiResponse<object>.Ok(new { Token = token, Role = role }, "Login successful"));
            }
        }
        catch (Exception ex)
        {
            return JsonHelper.ToJson(ApiResponse<object>.Fail(ex.Message));
        }
    }
    private string HashPassword(string pwd)
    {
        using (var sha = SHA256.Create())
        {
            byte[] bytes = sha.ComputeHash(Encoding.UTF8.GetBytes(pwd));
            return BitConverter.ToString(bytes).Replace("-", "").ToLower();
        }
    }
}
