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
    public partial class ActividadEconomicaConfiguration : IEntityTypeConfiguration<ActividadEconomica>
    {
        public void Configure(EntityTypeBuilder<ActividadEconomica> entity)
        {
            entity.HasKey(e => e.IdActividadEconomica)
                .HasName("PK_ACTIVIDAD_ECONOMICA");

            entity.ToTable("actividad_economica");

            entity.Property(e => e.IdActividadEconomica)
                .ValueGeneratedNever()
                .HasColumnName("ID_ACTIVIDAD_ECONOMICA");

            entity.Property(e => e.CodigoActividadEconomica)
                .HasMaxLength(5)
                .HasColumnName("CODIGO_ACTIVIDAD_ECONOMICA");

            entity.Property(e => e.CodigoDivision)
                .HasMaxLength(2)
                .HasColumnName("CODIGO_DIVISION");

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

            entity.Property(e => e.IdFamiliaProductiva).HasColumnName("ID_FAMILIA_PRODUCTIVA");

            entity.Property(e => e.UsuarioInsercion).HasColumnName("USUARIO_INSERCION");

            entity.Property(e => e.UsuarioModificacion).HasColumnName("USUARIO_MODIFICACION");

            entity.HasOne(d => d.IdFamiliaProductivaNavigation)
                .WithMany(p => p.ActividadEconomicas)
                .HasForeignKey(d => d.IdFamiliaProductiva)
                .HasConstraintName("FK_ACTIVIDA_REFERENCE_FAMILIA_");

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<ActividadEconomica> entity);
    }
}
