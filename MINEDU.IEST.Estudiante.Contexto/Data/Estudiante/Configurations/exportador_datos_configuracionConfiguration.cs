// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MINEDU.IEST.Estudiante.Entity;

#nullable disable

namespace MINEDU.IEST.Estudiante.Contexto.Data.Estudiante.Configurations
{
    public partial class exportador_datos_configuracionConfiguration : IEntityTypeConfiguration<exportador_datos_configuracion>
    {
        public void Configure(EntityTypeBuilder<exportador_datos_configuracion> entity)
        {
            entity.HasKey(e => e.ID_EXPORTADOR_DATOS_CONFIGURACION);

            entity.ToTable("exportador_datos_configuracion", "transaccional");

            entity.Property(e => e.FECHA_CREACION).HasColumnType("datetime");

            entity.Property(e => e.FECHA_MODIFICACION).HasColumnType("datetime");

            entity.Property(e => e.NOMBRE_CONFIGURACION)
                .HasMaxLength(100)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_CREACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_MODIFICACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.HasOne(d => d.ID_EXPORTADOR_DATOSNavigation)
                .WithMany(p => p.exportador_datos_configuracion)
                .HasForeignKey(d => d.ID_EXPORTADOR_DATOS)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_exportador_datos_configuracion_exportador_datos");

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<exportador_datos_configuracion> entity);
    }
}
