using System.Text.Json;

namespace MINEDU.IEST.Estudiante.Inf_Utils.Dtos
{
    public class ErrorDetails
    {
        public int StatusCode { get; set; }
        public string Message { get; set; }
        public string path { get; set; }
        public string method { get; set; }
        //public string controller { get; set; }
        //public string action { get; set; }
        public override string ToString()
        {
            return JsonSerializer.Serialize(this);
        }

    }
}
