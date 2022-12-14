// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MINEDU.IEST.Estudiante.Entity;

#nullable disable

namespace MINEDU.IEST.Estudiante.Contexto.Data.Estudiante.Configurations
{
    public partial class plan_estudioConfiguration : IEntityTypeConfiguration<plan_estudio>
    {
        public void Configure(EntityTypeBuilder<plan_estudio> entity)
        {
            entity.HasKey(e => e.ID_PLAN_ESTUDIO)
                .HasName("PK_PLAN_ESTUDIO")
                .IsClustered(false);

            entity.ToTable("plan_estudio", "transaccional");

            entity.HasIndex(e => new { e.ID_CARRERAS_POR_INSTITUCION, e.ES_ACTIVO, e.ID_PLAN_ESTUDIO }, "IDX_PLAN_ESTUDIO1");

            entity.Property(e => e.CODIGO_PLAN_ESTUDIOS)
                .HasMaxLength(16)
                .IsUnicode(false);

            entity.Property(e => e.FECHA_CREACION).HasColumnType("datetime");

            entity.Property(e => e.FECHA_MODIFICACION).HasColumnType("datetime");

            entity.Property(e => e.NOMBRE_PLAN_ESTUDIOS)
                .HasMaxLength(150)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_CREACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_MODIFICACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.HasOne(d => d.ID_CARRERAS_POR_INSTITUCIONNavigation)
                .WithMany(p => p.plan_estudio)
                .HasForeignKey(d => d.ID_CARRERAS_POR_INSTITUCION)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_PLAN_EST_FK_CARRER_CARRERAS");

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<plan_estudio> entity);
    }
}
