// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MINEDU.IEST.Estudiante.Entity;

#nullable disable

namespace MINEDU.IEST.Estudiante.Contexto.Data.Estudiante.Configurations
{
    public partial class carga_masiva_nominas_detalleConfiguration : IEntityTypeConfiguration<carga_masiva_nominas_detalle>
    {
        public void Configure(EntityTypeBuilder<carga_masiva_nominas_detalle> entity)
        {
            entity.HasKey(e => e.ID_CARGA_MASIVA_NOMINA_DETALLE)
                .HasName("PK__carga_ma__8C87E861320501EB");

            entity.ToTable("carga_masiva_nominas_detalle", "transaccional");

            entity.Property(e => e.FECHA_CREACION).HasColumnType("datetime");

            entity.Property(e => e.FECHA_MODIFICACION).HasColumnType("datetime");

            entity.Property(e => e.NOMBRE_UNIDAD_DIDACTICA)
                .HasMaxLength(150)
                .IsUnicode(false);

            entity.Property(e => e.NOTA).HasColumnType("decimal(10, 2)");

            entity.Property(e => e.USUARIO_CREACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_MODIFICACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.HasOne(d => d.ID_CARGA_MASIVA_NOMINANavigation)
                .WithMany(p => p.carga_masiva_nominas_detalle)
                .HasForeignKey(d => d.ID_CARGA_MASIVA_NOMINA)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_CARGA_MASIVA_NOMINAS_DETALLE_CARGA_MASIVA_NOMINAS");

            entity.HasOne(d => d.ID_CARGA_MASIVA_PERSONANavigation)
                .WithMany(p => p.carga_masiva_nominas_detalle)
                .HasForeignKey(d => d.ID_CARGA_MASIVA_PERSONA)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_CARGA_MASIVA_NOMINAS_DETALLE_CARGA_MASIVA_PERSONA");

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<carga_masiva_nominas_detalle> entity);
    }
}
