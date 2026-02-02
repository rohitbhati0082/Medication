using System;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Web;
using System.Web.UI;

public class BasePage : Page
{
    protected string UserId;
    protected string Role;

    protected override void OnInit(EventArgs e)
    {
        base.OnInit(e);

        var cookie = Request.Cookies["jwt"];
        try
        {
            if (cookie ==null)
            {
                Response.Redirect("~/ContentManager/Default.aspx");
            }
            var token = cookie.Value;
            if (string.IsNullOrEmpty(token))
                Response.Redirect("~/ContentManager/Default.aspx");
            var jwt = new JwtSecurityTokenHandler().ReadJwtToken(token);
            UserId = jwt.Claims.First(x => x.Type == "UserId").Value;
            Role = jwt.Claims.First(x => x.Type == ClaimTypes.Role).Value;

        }
        catch
        {
            Response.Redirect("~/ContentManager/Default.aspx");
        }
    }

    protected void RequireRole(params string[] roles)
    {
        if (!roles.Contains(Role))
            Response.Redirect("~/ContentManager/Default.aspx");
    }
}
