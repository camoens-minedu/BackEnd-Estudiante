namespace MINEDU.IEST.Estudiante.Inf_Utils.Dtos
{
    public class ErrorValidation
    {
        public string Message { get; set; }
        public List<DetailsErrorValidation> DetailsErrors { get; set; }

    }

    public class DetailsErrorValidation
    {
        public string Field { get; set; }
        public IEnumerable<string> ErrorMessage { get; set; }

    }
}
