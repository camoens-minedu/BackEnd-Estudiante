// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MINEDU.IEST.Estudiante.Entity;

#nullable disable

namespace MINEDU.IEST.Estudiante.Contexto.Data.Estudiante.Configurations
{
    public partial class unidad_competenciaConfiguration : IEntityTypeConfiguration<unidad_competencia>
    {
        public void Configure(EntityTypeBuilder<unidad_competencia> entity)
        {
            entity.HasKey(e => e.ID_UNIDAD_COMPETENCIA)
                .HasName("PK_UNIDAD_COMPETENCIA")
                .IsClustered(false);

            entity.ToTable("unidad_competencia", "maestro");

            entity.Property(e => e.CODIGO_UNIDAD_COMPETENCIA)
                .HasMaxLength(5)
                .IsUnicode(false);

            entity.Property(e => e.DESCRIPCION_UNIDAD_COMPETENCIA)
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

            entity.HasOne(d => d.ID_ACTIVIDAD_ECONOMICANavigation)
                .WithMany(p => p.unidad_competencia)
                .HasForeignKey(d => d.ID_ACTIVIDAD_ECONOMICA)
                .HasConstraintName("FK_UNIDAD_C_RELATIONS_ACTIVIDA");

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<unidad_competencia> entity);
    }
}
