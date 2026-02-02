using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
/// <summary>                 
/// Summary description for ContentService
/// </summary>
[WebService(Namespace = "auth")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[ScriptService]
public class ContentService : WebService
{
    private readonly string connStr =
       ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string HelloWorld()
    {
        return "Hello World";
    }

}
