// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MINEDU.IEST.Estudiante.Entity;

#nullable disable

namespace MINEDU.IEST.Estudiante.Contexto.Data.Estudiante.Configurations
{
    public partial class moduloConfiguration : IEntityTypeConfiguration<modulo>
    {
        public void Configure(EntityTypeBuilder<modulo> entity)
        {
            entity.HasKey(e => e.ID_MODULO)
                .HasName("PK_MODULO")
                .IsClustered(false);

            entity.ToTable("modulo", "transaccional");

            entity.HasIndex(e => e.ES_ACTIVO, "IDX_MODULO1");

            entity.HasIndex(e => new { e.ID_MODULO, e.ID_PLAN_ESTUDIO, e.ES_ACTIVO }, "IDX_MODULO2");

            entity.Property(e => e.CODIGO_MODULO)
                .HasMaxLength(16)
                .IsUnicode(false);

            entity.Property(e => e.FECHA_CREACION).HasColumnType("datetime");

            entity.Property(e => e.FECHA_MODIFICACION).HasColumnType("datetime");

            entity.Property(e => e.HORAS_ME).HasColumnType("decimal(5, 1)");

            entity.Property(e => e.TOTAL_CREDITOS_UD).HasColumnType("decimal(5, 1)");

            entity.Property(e => e.TOTAL_HORAS_UD).HasColumnType("decimal(5, 1)");

            entity.Property(e => e.USUARIO_CREACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_MODIFICACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.HasOne(d => d.ID_PLAN_ESTUDIONavigation)
                .WithMany(p => p.modulo)
                .HasForeignKey(d => d.ID_PLAN_ESTUDIO)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_MODULO_FK_PLAN_E_PLAN_EST");

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<modulo> entity);
    }
}
