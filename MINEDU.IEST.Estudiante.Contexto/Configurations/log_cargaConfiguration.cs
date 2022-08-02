﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MINEDU.IEST.Estudiante.Entity;
using System;
using System.Collections.Generic;

#nullable disable

namespace MINEDU.IEST.Estudiante.Entity.Configurations
{
    public partial class log_cargaConfiguration : IEntityTypeConfiguration<log_carga>
    {
        public void Configure(EntityTypeBuilder<log_carga> entity)
        {
            entity.HasKey(e => e.ID_LOG_CARGA);

            entity.ToTable("log_carga", "transaccional");

            entity.Property(e => e.FECHA_CREACION).HasColumnType("datetime");

            entity.Property(e => e.FECHA_FIN_VIGENCIA).HasColumnType("datetime");

            entity.Property(e => e.FECHA_INICIO_VIGENCIA).HasColumnType("datetime");

            entity.Property(e => e.FECHA_MODIFICACION).HasColumnType("datetime");

            entity.Property(e => e.MENSAJE)
                .HasMaxLength(500)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_CREACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_MODIFICACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.HasOne(d => d.ID_DET_ARCHIVONavigation)
                .WithMany(p => p.log_carga)
                .HasForeignKey(d => d.ID_DET_ARCHIVO)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_log_carga_carga_detalle");

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<log_carga> entity);
    }
}