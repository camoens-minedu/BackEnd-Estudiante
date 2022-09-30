using MINEDU.IEST.Estudiante.Inf_Utils.CustomMiddleware;

namespace MINEDU.IEST.Estudiante.OAuth.Api.Helpers
{
    public static class ExceptionMiddlewareExtensions
    {
        public static void ConfigureCustomExceptionMiddleware(this IApplicationBuilder app)
        {
            app.UseMiddleware<ExceptionMiddleware>();
        }
    }
}
