using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;

public static class JsonHelper
{
    public static string ToJson(object obj)
    {
        return JsonConvert.SerializeObject(obj, new JsonSerializerSettings
        {
            ReferenceLoopHandling = ReferenceLoopHandling.Ignore,
            ContractResolver = new CamelCasePropertyNamesContractResolver()
        });
    }
}
