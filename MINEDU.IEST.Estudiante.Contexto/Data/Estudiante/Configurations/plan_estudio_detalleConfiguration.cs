// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MINEDU.IEST.Estudiante.Entity;

#nullable disable

namespace MINEDU.IEST.Estudiante.Contexto.Data.Estudiante.Configurations
{
    public partial class plan_estudio_detalleConfiguration : IEntityTypeConfiguration<plan_estudio_detalle>
    {
        public void Configure(EntityTypeBuilder<plan_estudio_detalle> entity)
        {
            entity.HasKey(e => e.ID_PLAN_ESTUDIO_DETALLE)
                .IsClustered(false);

            entity.ToTable("plan_estudio_detalle", "transaccional");

            entity.Property(e => e.COLUMNA_L).HasColumnType("decimal(10, 2)");

            entity.Property(e => e.COLUMNA_M).HasColumnType("decimal(10, 2)");

            entity.Property(e => e.COLUMNA_N).HasColumnType("decimal(10, 2)");

            entity.Property(e => e.COLUMNA_O).HasColumnType("decimal(10, 2)");

            entity.Property(e => e.COLUMNA_P).HasColumnType("decimal(10, 2)");

            entity.Property(e => e.DESCRIPCION_CONSOLIDADO)
                .HasMaxLength(255)
                .IsUnicode(false);

            entity.Property(e => e.FECHA_CREACION).HasColumnType("datetime");

            entity.Property(e => e.FECHA_MODIFICACION).HasColumnType("datetime");

            entity.Property(e => e.PERIODO_ACADEMICO_VII).HasColumnType("decimal(5, 1)");

            entity.Property(e => e.PERIODO_ACADEMICO_VIII).HasColumnType("decimal(5, 1)");

            entity.Property(e => e.SUMA_TOTAL_CREDITOS_UD).HasColumnType("decimal(5, 1)");

            entity.Property(e => e.TOTAL_CREDITOS_UD).HasColumnType("decimal(5, 1)");

            entity.Property(e => e.USUARIO_CREACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_MODIFICACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.HasOne(d => d.ID_PLAN_ESTUDIONavigation)
                .WithMany(p => p.plan_estudio_detalle)
                .HasForeignKey(d => d.ID_PLAN_ESTUDIO)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_PLAN_FK_PLAN_DET");

            entity.HasOne(d => d.ID_TIPO_UNIDAD_DIDACTICANavigation)
                .WithMany(p => p.plan_estudio_detalle)
                .HasForeignKey(d => d.ID_TIPO_UNIDAD_DIDACTICA)
                .HasConstraintName("FK_PLAN_FK_TIPO_UD");

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<plan_estudio_detalle> entity);
    }
}
