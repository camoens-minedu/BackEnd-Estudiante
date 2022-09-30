﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MINEDU.IEST.Estudiante.Contexto.Data.DigePadron;
using MINEDU.IEST.Estudiante.Entity.DigePadron;
using System;
using System.Collections.Generic;

namespace MINEDU.IEST.Estudiante.Contexto.Data.DigePadron.Configurations
{
    public partial class InstitucionMovimientoConfiguration : IEntityTypeConfiguration<InstitucionMovimiento>
    {
        public void Configure(EntityTypeBuilder<InstitucionMovimiento> entity)
        {
            entity.HasKey(e => e.IdInstitucionMovimiento);

            entity.ToTable("institucion_movimiento");

            entity.Property(e => e.IdInstitucionMovimiento).HasColumnName("ID_INSTITUCION_MOVIMIENTO");

            entity.Property(e => e.Detalle)
                .HasMaxLength(1024)
                .HasColumnName("DETALLE");

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

            entity.Property(e => e.FechaMovimiento)
                .HasColumnType("datetime")
                .HasColumnName("FECHA_MOVIMIENTO");

            entity.Property(e => e.IdDocumentoRespuesta).HasColumnName("ID_DOCUMENTO_RESPUESTA");

            entity.Property(e => e.IdInstitucion).HasColumnName("ID_INSTITUCION");

            entity.Property(e => e.NombreInstitucion)
                .HasMaxLength(150)
                .HasColumnName("NOMBRE_INSTITUCION");

            entity.Property(e => e.Resumen)
                .HasMaxLength(250)
                .HasColumnName("RESUMEN");

            entity.Property(e => e.TieneResolucion).HasColumnName("TIENE_RESOLUCION");

            entity.Property(e => e.TipoMovimiento).HasColumnName("TIPO_MOVIMIENTO");

            entity.Property(e => e.UsuarioInsercion).HasColumnName("USUARIO_INSERCION");

            entity.Property(e => e.UsuarioModificacion).HasColumnName("USUARIO_MODIFICACION");

            entity.HasOne(d => d.IdDocumentoRespuestaNavigation)
                .WithMany(p => p.InstitucionMovimientos)
                .HasForeignKey(d => d.IdDocumentoRespuesta)
                .HasConstraintName("FK_institucion_movimiento_documento_respuesta");

            entity.HasOne(d => d.IdInstitucionNavigation)
                .WithMany(p => p.InstitucionMovimientos)
                .HasForeignKey(d => d.IdInstitucion)
                .HasConstraintName("FK_institucion_movimiento_institucion");

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<InstitucionMovimiento> entity);
    }
}