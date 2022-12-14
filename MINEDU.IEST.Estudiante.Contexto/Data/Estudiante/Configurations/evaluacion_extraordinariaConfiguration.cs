// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MINEDU.IEST.Estudiante.Entity;

#nullable disable

namespace MINEDU.IEST.Estudiante.Contexto.Data.Estudiante.Configurations
{
    public partial class evaluacion_extraordinariaConfiguration : IEntityTypeConfiguration<evaluacion_extraordinaria>
    {
        public void Configure(EntityTypeBuilder<evaluacion_extraordinaria> entity)
        {
            entity.HasKey(e => e.ID_EVALUACION_EXTRAORDINARIA)
                .HasName("PK_EVALUACION_EXTRAORDINARIA")
                .IsClustered(false);

            entity.ToTable("evaluacion_extraordinaria", "transaccional");

            entity.Property(e => e.ARCHIVO_RD)
                .HasMaxLength(50)
                .IsUnicode(false);

            entity.Property(e => e.ARCHIVO_RUTA)
                .HasMaxLength(255)
                .IsUnicode(false);

            entity.Property(e => e.FECHA_CREACION).HasColumnType("datetime");

            entity.Property(e => e.FECHA_MODIFICACION).HasColumnType("datetime");

            entity.Property(e => e.USUARIO_CREACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_MODIFICACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.HasOne(d => d.ID_ESTUDIANTE_INSTITUCIONNavigation)
                .WithMany(p => p.evaluacion_extraordinaria)
                .HasForeignKey(d => d.ID_ESTUDIANTE_INSTITUCION)
                .HasConstraintName("FK__evaluacio__ID_ES__322C6448");

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<evaluacion_extraordinaria> entity);
    }
}
