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
    public partial class DocumentoRespuestaDetalleConfiguration : IEntityTypeConfiguration<DocumentoRespuestaDetalle>
    {
        public void Configure(EntityTypeBuilder<DocumentoRespuestaDetalle> entity)
        {
            entity.HasKey(e => e.IdDocumentoRespuestaDetalle);

            entity.ToTable("documento_respuesta_detalle");

            entity.HasIndex(e => new { e.TipoCodigoCarrera, e.Estado }, "IDX_DOCUMENTO_RPTA_DETALLE_DATA_01");

            entity.HasIndex(e => new { e.TipoCodigoCarrera, e.Estado }, "IDX_DOCUMENTO_RPTA_DETALLE_DATA_02");

            entity.Property(e => e.IdDocumentoRespuestaDetalle)
                .ValueGeneratedNever()
                .HasColumnName("ID_DOCUMENTO_RESPUESTA_DETALLE");

            entity.Property(e => e.Creditos)
                .HasMaxLength(10)
                .HasColumnName("CREDITOS");

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

            entity.Property(e => e.Horas)
                .HasMaxLength(10)
                .HasColumnName("HORAS");

            entity.Property(e => e.IdCarrera).HasColumnName("ID_CARRERA");

            entity.Property(e => e.IdDocumentoRespuesta).HasColumnName("ID_DOCUMENTO_RESPUESTA");

            entity.Property(e => e.IdSede).HasColumnName("ID_SEDE");

            entity.Property(e => e.MencionCarrera)
                .HasMaxLength(300)
                .IsUnicode(false)
                .HasColumnName("MENCION_CARRERA");

            entity.Property(e => e.Meta)
                .HasMaxLength(10)
                .HasColumnName("META");

            entity.Property(e => e.TipoCodigoCarrera).HasColumnName("TIPO_CODIGO_CARRERA");

            entity.Property(e => e.TipoTramiteCarrera).HasColumnName("TIPO_TRAMITE_CARRERA");

            entity.Property(e => e.UsuarioInsercion).HasColumnName("USUARIO_INSERCION");

            entity.Property(e => e.UsuarioModificacion).HasColumnName("USUARIO_MODIFICACION");

            entity.HasOne(d => d.IdDocumentoRespuestaNavigation)
                .WithMany(p => p.DocumentoRespuestaDetalles)
                .HasForeignKey(d => d.IdDocumentoRespuesta)
                .HasConstraintName("FK_DOCUMENT_REFERENCE_DOCUMENT");

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<DocumentoRespuestaDetalle> entity);
    }
}