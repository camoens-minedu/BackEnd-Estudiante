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
    public partial class DetallePausaExpedienteConfiguration : IEntityTypeConfiguration<DetallePausaExpediente>
    {
        public void Configure(EntityTypeBuilder<DetallePausaExpediente> entity)
        {
            entity.HasKey(e => e.IdDetallePausaExpediente);

            entity.ToTable("detalle_pausa_expediente");

            entity.Property(e => e.IdDetallePausaExpediente)
                .ValueGeneratedNever()
                .HasColumnName("ID_DETALLE_PAUSA_EXPEDIENTE");

            entity.Property(e => e.Estado)
                .HasColumnName("ESTADO")
                .HasDefaultValueSql("((1))");

            entity.Property(e => e.FechaFin)
                .HasColumnType("date")
                .HasColumnName("FECHA_FIN");

            entity.Property(e => e.FechaInicio)
                .HasColumnType("date")
                .HasColumnName("FECHA_INICIO");

            entity.Property(e => e.FechaInsercion)
                .HasColumnType("datetime")
                .HasColumnName("FECHA_INSERCION")
                .HasDefaultValueSql("(sysdatetime())");

            entity.Property(e => e.FechaModificacion)
                .HasColumnType("datetime")
                .HasColumnName("FECHA_MODIFICACION");

            entity.Property(e => e.IdMovimientoExpediente).HasColumnName("ID_MOVIMIENTO_EXPEDIENTE");

            entity.Property(e => e.UsuarioInsercion).HasColumnName("USUARIO_INSERCION");

            entity.Property(e => e.UsuarioModificacion).HasColumnName("USUARIO_MODIFICACION");

            entity.HasOne(d => d.IdMovimientoExpedienteNavigation)
                .WithMany(p => p.DetallePausaExpedientes)
                .HasForeignKey(d => d.IdMovimientoExpediente)
                .HasConstraintName("FK_detalle_pausa_expediente_movimiento_expediente");

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<DetallePausaExpediente> entity);
    }
}
