using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ContentManager_NationalEvent : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        RequireRole("Admin");
    }
}