// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MINEDU.IEST.Estudiante.Entity;

#nullable disable

namespace MINEDU.IEST.Estudiante.Contexto.Data.Estudiante.Configurations
{
    public partial class resoluciones_por_carreras_por_institucionConfiguration : IEntityTypeConfiguration<resoluciones_por_carreras_por_institucion>
    {
        public void Configure(EntityTypeBuilder<resoluciones_por_carreras_por_institucion> entity)
        {
            entity.HasKey(e => e.ID_RESOLUCIONES_POR_CARRERAS_POR_INSTITUCION)
                .IsClustered(false);

            entity.ToTable("resoluciones_por_carreras_por_institucion", "transaccional");

            entity.Property(e => e.FECHA_CREACION).HasColumnType("datetime");

            entity.Property(e => e.FECHA_MODIFICACION).HasColumnType("datetime");

            entity.Property(e => e.USUARIO_CREACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_MODIFICACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.HasOne(d => d.ID_CARRERAS_POR_INSTITUCIONNavigation)
                .WithMany(p => p.resoluciones_por_carreras_por_institucion)
                .HasForeignKey(d => d.ID_CARRERAS_POR_INSTITUCION)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_RESOL_CARR_INST_FK_CARR_INST");

            entity.HasOne(d => d.ID_RESOLUCIONNavigation)
                .WithMany(p => p.resoluciones_por_carreras_por_institucion)
                .HasForeignKey(d => d.ID_RESOLUCION)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_RESOL_CARR_INST_FK_RESOL");

            entity.HasOne(d => d.ID_SEDE_INSTITUCIONNavigation)
                .WithMany(p => p.resoluciones_por_carreras_por_institucion)
                .HasForeignKey(d => d.ID_SEDE_INSTITUCION)
                .HasConstraintName("FK_RESOL_CARR_INST_FK_SEDE_INST");

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<resoluciones_por_carreras_por_institucion> entity);
    }
}
