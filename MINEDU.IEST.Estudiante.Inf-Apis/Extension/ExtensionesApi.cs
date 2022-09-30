using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using MINEDU.IEST.Estudiante.Contexto.Data.Audit;
using MINEDU.IEST.Estudiante.Contexto.Data.Auxiliar;
using MINEDU.IEST.Estudiante.Contexto.Data.DigePadron;
using MINEDU.IEST.Estudiante.Contexto.Data.Estudiante;
using MINEDU.IEST.Estudiante.Contexto.Data.Security;
using MINEDU.IEST.Estudiante.Contexto.Data.SecurityApi;
using MINEDU.IEST.Estudiante.Inf_Utils.Helpers.Dapper;
using MINEDU.IEST.Estudiante.Manager.Auxiliar;
using MINEDU.IEST.Estudiante.Manager.InformacionPersonal;
using MINEDU.IEST.Estudiante.Manager.Maestra;
using MINEDU.IEST.Estudiante.Manager.PreMatricula;
using MINEDU.IEST.Estudiante.Manager.SecurityApi;
using MINEDU.IEST.Estudiante.Manager.StoreProcedure;
using MINEDU.IEST.Estudiante.Repository.Audit;
using MINEDU.IEST.Estudiante.Repository.Auxiliar;
using MINEDU.IEST.Estudiante.Repository.DigePadron;
using MINEDU.IEST.Estudiante.Repository.InformacionPersonal;
using MINEDU.IEST.Estudiante.Repository.Maestra;
using MINEDU.IEST.Estudiante.Repository.PreMatricula;
using MINEDU.IEST.Estudiante.Repository.SecurityApi;
using MINEDU.IEST.Estudiante.Repository.StoreProcedure;
using MINEDU.IEST.Estudiante.Repository.UnitOfWork;

namespace MINEDU.IEST.Estudiante.Inf_Apis.Extension
{
    public static class ExtensionesApi
    {

        public class RepositoriesOptions
        {
            public string ConnectionString { get; set; }
        }

        public static IServiceCollection AddRepositories(this IServiceCollection services, Action<RepositoriesOptions> configureOptions)
        {
            var options = new RepositoriesOptions();
            configureOptions(options);

            services.AddScoped<IMaestraRepository, MaestraRepository>();
            services.AddScoped<IInformacionPersonaRepository, InformacionPersonaRepository>();
            services.AddScoped<IPreMatriculaRepository, PreMatriculaRepository>();
            services.AddScoped<IProgramacionMatriculaRepository, ProgramacionMatriculaRepository>();
            services.AddScoped<MaestrasUnitOfWork>();
            services.AddScoped<InformacionPersonaUnitOfWork>();
            services.AddScoped<PreMatriculaUnitOfWork>();

            services.AddDbContext<estudianteContext>(opt =>
            {
                opt.UseSqlServer(options.ConnectionString);
            });

            return services;
        }
        public static IServiceCollection AddRepositorieDigePadron(this IServiceCollection services, Action<RepositoriesOptions> configureOptions)
        {
            var options = new RepositoriesOptions();
            configureOptions(options);

            services.AddScoped<IUbigeoRepository, UbigeoRepository>();
            services.AddScoped<ICarreraPadronRepository, CarreraPadronRepository>();
            services.AddScoped<DigePadronUnitOfWork>();

            services.AddDbContext<digePadronDbContext>(opt =>
            {
                opt.UseSqlServer(options.ConnectionString);
            });

            return services;
        }
        public static IServiceCollection AddSecurity(this IServiceCollection services, Action<RepositoriesOptions> configureOptions)
        {
            var options = new RepositoriesOptions();
            configureOptions(options);

            services.AddScoped<IMaestraRepository, MaestraRepository>();
            services.AddScoped<MaestrasUnitOfWork>();

            services.AddDbContext<SecurityDbContext>(opt =>
            {
                opt.UseSqlServer(options.ConnectionString);
            });

            return services;
        }
        public static IServiceCollection AddManager(this IServiceCollection services)
        {

            services.AddScoped<IMaestraManager, MaestraManager>();
            services.AddScoped<IPersonalManager, PersonalManager>();
            services.AddScoped<IAuxiliarManager, AuxiliarManager>();
            services.AddScoped<IPreMatriculaManager, PreMatriculaManager>();
            services.AddScoped<IStoreProcedureManager, StoreProcedureManager>();
            services.AddScoped<ISecurityApiManager, SecurityApiManager>();

            return services;

        }
        public static IServiceCollection AddAuditoria(this IServiceCollection services, Action<RepositoriesOptions> configureOptions)
        {
            var options = new RepositoriesOptions();
            configureOptions(options);

            services.AddScoped<IAuditLogRepository, AuditLogRepository>();
            services.AddScoped<AuditUnitOfWork>();
            services.AddScoped<AuditDbContext>();

            services.AddDbContext<AuditDbContext>(opt =>
            {
                opt.UseSqlServer(options.ConnectionString);
            });

            return services;

        }
        public static IServiceCollection AddAuxiliar(this IServiceCollection services, Action<RepositoriesOptions> configureOptions)
        {
            var options = new RepositoriesOptions();
            configureOptions(options);

            services.AddScoped<IAuxiliarRepository, AuxiliarRepository>();
            services.AddScoped<AuxiliarUnitOfWork>();

            services.AddDbContext<AuxiliarDbContext>(opt =>
            {
                opt.UseSqlServer(options.ConnectionString);
            });

            return services;
        }
        public static IServiceCollection AddStoreProcedure(this IServiceCollection services, Action<RepositoriesOptions> configureOptions)
        {
            var options = new RepositoriesOptions();
            configureOptions(options);

            services.AddScoped<IStoreProcedureRepository, StoreProcedureRepository>();
            services.AddScoped<IDapper, DataBase>();
            services.AddScoped<StoreProcedureUnitOfWork>();

            services.AddDbContext<estudianteContext>(opt =>
            {
                opt.UseSqlServer(options.ConnectionString);
            });

            return services;
        }
        public static IServiceCollection AddSecurityApi(this IServiceCollection services, Action<RepositoriesOptions> configureOptions)
        {
            var options = new RepositoriesOptions();
            configureOptions(options);

            services.AddScoped<IUserRepository, UserRepository>();
            services.AddScoped<IRoleRepository, RoleRepository>();
            services.AddScoped<SecurityApiUnitOfWork>();
            services.AddScoped<SecurityApiDbContext>();

            services.AddDbContext<SecurityApiDbContext>(opt =>
            {
                opt.UseSqlServer(options.ConnectionString);
            });

            return services;

        }


    }

}
