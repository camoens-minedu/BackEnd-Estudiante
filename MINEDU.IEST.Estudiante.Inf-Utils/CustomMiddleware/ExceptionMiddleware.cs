using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using MINEDU.IEST.Estudiante.Inf_Utils.Dtos;
using System.Net;

namespace MINEDU.IEST.Estudiante.Inf_Utils.CustomMiddleware
{
    public class ExceptionMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly ILogger _logger;

        public ExceptionMiddleware(RequestDelegate next, ILoggerFactory loggerFactory)
        {
            _logger = loggerFactory.CreateLogger("ExceptionMiddleware");
            _next = next;
        }

        public async Task InvokeAsync(HttpContext httpContext)
        {
            try
            {
                await _next(httpContext);
            }
            catch (AccessViolationException avEx)
            {
                _logger.LogError($"Se ha lanzado una nueva excepción de infracción: {avEx}");
                await HandleExceptionAsync(httpContext, avEx);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Algo salió mal: {ex}");
                await HandleExceptionAsync(httpContext, ex);
            }
        }

        private async Task HandleExceptionAsync(HttpContext context, Exception exception)
        {
            context.Response.ContentType = "application/json";
            context.Response.StatusCode = (int)HttpStatusCode.InternalServerError;

            var message = exception switch
            {
                AccessViolationException => exception.Message,
                _ => $"Error interno del servidor: {exception.Message}"
            };
            await context.Response.WriteAsync(new ErrorDetails()
            {
                StatusCode = context.Response.StatusCode,
                Message = message,
                path = context.Request.Path.ToString(),
                method = context.Request.Method
            }.ToString());
        }
    }
}
