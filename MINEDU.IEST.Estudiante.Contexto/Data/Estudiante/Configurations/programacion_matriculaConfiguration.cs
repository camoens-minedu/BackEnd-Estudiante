// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MINEDU.IEST.Estudiante.Entity;

#nullable disable

namespace MINEDU.IEST.Estudiante.Contexto.Data.Estudiante.Configurations
{
    public partial class programacion_matriculaConfiguration : IEntityTypeConfiguration<programacion_matricula>
    {
        public void Configure(EntityTypeBuilder<programacion_matricula> entity)
        {
            entity.HasKey(e => e.ID_PROGRAMACION_MATRICULA)
                .HasName("PK_PROGRAMACION_MATRICULA")
                .IsClustered(false);

            entity.ToTable("programacion_matricula", "transaccional");

            entity.Property(e => e.FECHA_CREACION).HasColumnType("datetime");

            entity.Property(e => e.FECHA_FIN).HasColumnType("datetime");

            entity.Property(e => e.FECHA_INICIO).HasColumnType("datetime");

            entity.Property(e => e.FECHA_MODIFICACION).HasColumnType("datetime");

            entity.Property(e => e.USUARIO_CREACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_MODIFICACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.HasOne(d => d.ID_PERIODOS_LECTIVOS_POR_INSTITUCIONNavigation)
                .WithMany(p => p.programacion_matricula)
                .HasForeignKey(d => d.ID_PERIODOS_LECTIVOS_POR_INSTITUCION)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_PROGRAMA_FK_PERIOD_PERIODOS");

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<programacion_matricula> entity);
    }
}
