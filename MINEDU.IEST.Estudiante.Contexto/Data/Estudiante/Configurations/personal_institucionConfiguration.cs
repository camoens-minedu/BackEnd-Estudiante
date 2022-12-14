// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MINEDU.IEST.Estudiante.Entity;

#nullable disable

namespace MINEDU.IEST.Estudiante.Contexto.Data.Estudiante.Configurations
{
    public partial class personal_institucionConfiguration : IEntityTypeConfiguration<personal_institucion>
    {
        public void Configure(EntityTypeBuilder<personal_institucion> entity)
        {
            entity.HasKey(e => e.ID_PERSONAL_INSTITUCION)
                .HasName("PK_PERSONAL_INSTITUCION")
                .IsClustered(false);

            entity.ToTable("personal_institucion", "maestro");

            entity.HasIndex(e => new { e.ID_PERSONAL_INSTITUCION, e.ES_ACTIVO }, "IDX_PERSONAL_INSTITUCION1");

            entity.HasIndex(e => e.ID_PERIODOS_LECTIVOS_POR_INSTITUCION, "IDX_PERSONAL_INSTITUCION_PERIODOLECTIVO");

            entity.Property(e => e.FECHA_CREACION).HasColumnType("datetime");

            entity.Property(e => e.FECHA_MODIFICACION).HasColumnType("datetime");

            entity.Property(e => e.USUARIO_CREACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_MODIFICACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.HasOne(d => d.ID_PERIODOS_LECTIVOS_POR_INSTITUCIONNavigation)
                .WithMany(p => p.personal_institucion)
                .HasForeignKey(d => d.ID_PERIODOS_LECTIVOS_POR_INSTITUCION)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_PERSONAL_RELATIONS_PERIODOS");

            entity.HasOne(d => d.ID_PERSONA_INSTITUCIONNavigation)
                .WithMany(p => p.personal_institucion)
                .HasForeignKey(d => d.ID_PERSONA_INSTITUCION)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_PERSONAL_FK_PERSON_PERSONA_");

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<personal_institucion> entity);
    }
}
