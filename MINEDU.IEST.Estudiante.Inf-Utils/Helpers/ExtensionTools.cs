using Microsoft.AspNetCore.Mvc.ModelBinding;
using MINEDU.IEST.Estudiante.Inf_Utils.Constants;
using MINEDU.IEST.Estudiante.Inf_Utils.Dtos;

namespace MINEDU.IEST.Estudiante.Inf_Utils.Helpers
{
    public class ExtensionTools
    {
        public static ErrorValidation Validaciones(ModelStateDictionary modelState)
        {
            var err = new ErrorValidation { Message = ConstValidation.messageValidacion, DetailsErrors = new List<DetailsErrorValidation>() };
            foreach (var item in modelState.Where(p => p.Value.Errors.Count() > 0).ToList())
            {
                DetailsErrorValidation detail = new DetailsErrorValidation();
                detail.Field = item.Key;
                detail.ErrorMessage = item.Value.Errors.Select(p => p.ErrorMessage).ToArray();
                err.DetailsErrors.Add(detail);
            }

            return err;
        }
    }
}
