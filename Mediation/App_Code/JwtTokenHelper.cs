using System;
using System.Configuration;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using Microsoft.IdentityModel.Tokens;
using System.Text;

    public static class JwtTokenHelper
    {
        public static string GenerateToken(int userId, int staffId, string role)
        {
            string secret =
                ConfigurationManager.AppSettings["JwtSecret"];

            int expiryHours =
                int.Parse(ConfigurationManager.AppSettings["JwtExpireHours"]);

            var key = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes(secret));

            var creds = new SigningCredentials(
                key, SecurityAlgorithms.HmacSha256);

            var claims = new[]
            {
                new Claim("UserId", userId.ToString()),
                new Claim("StaffId", staffId.ToString()),
                new Claim(ClaimTypes.Role, role)
            };

            var token = new JwtSecurityToken(
                claims: claims,
                expires: DateTime.UtcNow.AddHours(expiryHours),
                signingCredentials: creds);

            return new JwtSecurityTokenHandler().WriteToken(token);
        }
    }

