using Microsoft.Extensions.DependencyInjection;
using MINEDU.IEST.Estudiante.Manager.Maestra;
using MINEDU.IEST.Estudiante.Repository.Maestra;

namespace MINEDU.IEST.Estudiante.Inf_Apis.Extension
{
    public static class ExtensionesApi
    {
        public static void InyectaDependencias(this IServiceCollection services)
        {
            #region Repository
            services.AddTransient<IMaestraRepository, MaestraRepository>();

            #endregion


            #region Manager
            services.AddTransient<IMaestraManager, MaestraManager>();

            #endregion

        }

    }

}
