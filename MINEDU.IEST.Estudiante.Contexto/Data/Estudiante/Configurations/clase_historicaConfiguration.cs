// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MINEDU.IEST.Estudiante.Entity;

#nullable disable

namespace MINEDU.IEST.Estudiante.Contexto.Data.Estudiante.Configurations
{
    public partial class clase_historicaConfiguration : IEntityTypeConfiguration<clase_historica>
    {
        public void Configure(EntityTypeBuilder<clase_historica> entity)
        {
            entity.HasKey(e => e.ID_CLASE_HISTORICA)
                .HasName("PK_CLASE_HISTORICA")
                .IsClustered(false);

            entity.ToTable("clase_historica", "maestro");

            entity.Property(e => e.FECHA_CREACION).HasColumnType("datetime");

            entity.Property(e => e.FECHA_MODIFICACION).HasColumnType("datetime");

            entity.Property(e => e.USUARIO_CREACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_MODIFICACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<clase_historica> entity);
    }
}
