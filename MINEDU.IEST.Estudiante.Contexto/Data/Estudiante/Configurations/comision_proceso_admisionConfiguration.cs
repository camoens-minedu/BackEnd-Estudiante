// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MINEDU.IEST.Estudiante.Entity;

#nullable disable

namespace MINEDU.IEST.Estudiante.Contexto.Data.Estudiante.Configurations
{
    public partial class comision_proceso_admisionConfiguration : IEntityTypeConfiguration<comision_proceso_admision>
    {
        public void Configure(EntityTypeBuilder<comision_proceso_admision> entity)
        {
            entity.HasKey(e => e.ID_COMISION_PROCESO_ADMISION)
                .HasName("PK_COMISION_PROCESO_ADMISION")
                .IsClustered(false);

            entity.ToTable("comision_proceso_admision", "transaccional");

            entity.Property(e => e.FECHA_CREACION).HasColumnType("datetime");

            entity.Property(e => e.FECHA_MODIFICACION).HasColumnType("datetime");

            entity.Property(e => e.USUARIO_CREACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_MODIFICACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.HasOne(d => d.ID_PERSONAL_INSTITUCIONNavigation)
                .WithMany(p => p.comision_proceso_admision)
                .HasForeignKey(d => d.ID_PERSONAL_INSTITUCION)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_COMISION_FK_PERSON_PERSONAL");

            entity.HasOne(d => d.ID_PROCESO_ADMISION_PERIODONavigation)
                .WithMany(p => p.comision_proceso_admision)
                .HasForeignKey(d => d.ID_PROCESO_ADMISION_PERIODO)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_COMISION_RELATIONS_PROCESO_");

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<comision_proceso_admision> entity);
    }
}
