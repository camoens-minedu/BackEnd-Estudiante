using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.Extensions.Logging;
using MINEDU.IEST.Estudiante.Inf_Utils.Helpers;

namespace MINEDU.IEST.Estudiante.Inf_Utils.Filters
{
    public class ModelValidationAttribute : ActionFilterAttribute
    {
        private readonly ILogger _logger;

        public ModelValidationAttribute(ILoggerFactory loggerFactory)
        {
            _logger = loggerFactory.CreateLogger("ModelValidationAttribute");
        }

        public override void OnActionExecuting(ActionExecutingContext context)
        {
            if (!context.ModelState.IsValid)
            {
                //context.Result = new BadRequestObjectResult(context.ModelState); // returns 400 with error
                context.Result = new UnprocessableEntityObjectResult(ExtensionTools.Validaciones(context.ModelState));
            }

            base.OnActionExecuting(context);
        }

        public override void OnActionExecuted(ActionExecutedContext context)
        {
            _logger.LogInformation("OnActionExecuted");
            base.OnActionExecuted(context);
        }

        public override void OnResultExecuting(ResultExecutingContext context)
        {
            _logger.LogInformation("OnResultExecuting");
            base.OnResultExecuting(context);
        }

        public override void OnResultExecuted(ResultExecutedContext context)
        {
            _logger.LogInformation("OnResultExecuted");
            base.OnResultExecuted(context);
        }
    }
}
