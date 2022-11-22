using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MINEDU.IEST.Estudiante.Entity.Auxiliar;

namespace MINEDU.IEST.Estudiante.Contexto.Data.Auxiliar.Configurations
{
    public partial class UbigeoReniecConfiguration : IEntityTypeConfiguration<UvwUbigeoReniec>
    {
        public void Configure(EntityTypeBuilder<UvwUbigeoReniec> entity)
        {
            entity.HasNoKey();

            entity.ToView("UVW_UBIGEO_RENIEC");

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<UvwUbigeoReniec> entity);
    }
}
