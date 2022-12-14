// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MINEDU.IEST.Estudiante.Contexto.Data.DigePadron;
using MINEDU.IEST.Estudiante.Entity.DigePadron;
using System;
using System.Collections.Generic;

namespace MINEDU.IEST.Estudiante.Contexto.Data.DigePadron.Configurations
{
    public partial class UnidadCompetenciumConfiguration : IEntityTypeConfiguration<UnidadCompetencium>
    {
        public void Configure(EntityTypeBuilder<UnidadCompetencium> entity)
        {
            entity.HasKey(e => e.IdUnidadCompetencia)
                .HasName("PK_UNIDAD_COMPETENCIA");

            entity.ToTable("unidad_competencia");

            entity.Property(e => e.IdUnidadCompetencia)
                .ValueGeneratedNever()
                .HasColumnName("ID_UNIDAD_COMPETENCIA");

            entity.Property(e => e.CodigoUnidadCompetencia)
                .HasMaxLength(12)
                .HasColumnName("CODIGO_UNIDAD_COMPETENCIA");

            entity.Property(e => e.Correlativo)
                .HasMaxLength(3)
                .HasColumnName("CORRELATIVO");

            entity.Property(e => e.Descripcion)
                .HasColumnType("text")
                .HasColumnName("DESCRIPCION");

            entity.Property(e => e.Estado)
                .HasColumnName("ESTADO")
                .HasDefaultValueSql("((1))");

            entity.Property(e => e.FechaInsercion)
                .HasColumnType("datetime")
                .HasColumnName("FECHA_INSERCION")
                .HasDefaultValueSql("(sysdatetime())");

            entity.Property(e => e.FechaModificacion)
                .HasColumnType("datetime")
                .HasColumnName("FECHA_MODIFICACION");

            entity.Property(e => e.IdActividadEconomica).HasColumnName("ID_ACTIVIDAD_ECONOMICA");

            entity.Property(e => e.IdCarreraDcb).HasColumnName("ID_CARRERA_DCB");

            entity.Property(e => e.IdFamiliaProductiva).HasColumnName("ID_FAMILIA_PRODUCTIVA");

            entity.Property(e => e.IdSector).HasColumnName("ID_SECTOR");

            entity.Property(e => e.UsuarioInsercion).HasColumnName("USUARIO_INSERCION");

            entity.Property(e => e.UsuarioModificacion).HasColumnName("USUARIO_MODIFICACION");

            entity.HasOne(d => d.IdCarreraDcbNavigation)
                .WithMany(p => p.UnidadCompetencia)
                .HasForeignKey(d => d.IdCarreraDcb)
                .HasConstraintName("FK_UNIDAD_C_REFERENCE_CARRERA_DCB");

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<UnidadCompetencium> entity);
    }
}
