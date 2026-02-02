using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for AuthHelper
/// </summary>

    public static class AuthHelper
    {  
        public static int GetStaffIdFromJwt()
        {
            HttpCookie cookie = HttpContext.Current.Request.Cookies["jwt"];

            if (cookie == null || string.IsNullOrWhiteSpace(cookie.Value))
                throw new Exception("Unauthorized: token missing");

            var handler = new JwtSecurityTokenHandler();
            var token = handler.ReadJwtToken(cookie.Value);

            var staffClaim = token.Claims
                                  .FirstOrDefault(c => c.Type == "UserId");

            if (staffClaim == null)
                throw new Exception("Unauthorized: staffId not found");

            return int.Parse(staffClaim.Value);
        }

        public static int GetUserIdFromJwt()
        {
            HttpCookie cookie = HttpContext.Current.Request.Cookies["jwt"];

            if (cookie == null || string.IsNullOrWhiteSpace(cookie.Value))
                throw new Exception("Unauthorized");

            var handler = new JwtSecurityTokenHandler();
            var token = handler.ReadJwtToken(cookie.Value);

            var userClaim = token.Claims
                                 .FirstOrDefault(c => c.Type == "userId");

            if (userClaim == null)
                throw new Exception("Invalid token");

            return int.Parse(userClaim.Value);
        }

        public static string GetRoleFromJwt()
        {
            HttpCookie cookie = HttpContext.Current.Request.Cookies["jwt"];
            if (cookie == null) return null;

            var token = new JwtSecurityTokenHandler()
                        .ReadJwtToken(cookie.Value);

            return token.Claims
                        .FirstOrDefault(c => c.Type == "http://schemas.microsoft.com/ws/2008/06/identity/claims/role")
                        .Value;
        }
    }

