using Microsoft.Extensions.DependencyInjection;

namespace MINEDU.IEST.Estudiante.Inf_Utils.Helpers.FileManager
{
    public static class DependencyInjection
    {
        public class FileManagerOptions
        {
            public StorageType Type { get; set; }
        }


        public static IServiceCollection AddStorageManager(this IServiceCollection services, Action<FileManagerOptions> configureOptions)
        {
            var options = new FileManagerOptions();
            configureOptions(options);

            switch (options.Type)
            {
                case StorageType.AzureBlobStorage:
                    services.AddScoped<IStorageManager, AzureBlobStorage>();
                    break;
                default:
                    services.AddScoped<IStorageManager, FileStorage>();
                    break;
            }

            return services;
        }
    }
}
