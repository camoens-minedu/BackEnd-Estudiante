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
    public partial class indicadores_logro_por_capacidadConfiguration : IEntityTypeConfiguration<indicadores_logro_por_capacidad>
    {
        public void Configure(EntityTypeBuilder<indicadores_logro_por_capacidad> entity)
        {
            entity.HasKey(e => e.ID_INDICADORES_LOGRO_POR_CAPACIDAD)
                .HasName("PK_INDICADORES_LOGRO_POR_CAPAC")
                .IsClustered(false);

            entity.ToTable("indicadores_logro_por_capacidad", "transaccional");

            entity.Property(e => e.CODIGO_INDICADOR_LOGRO)
                .HasMaxLength(16)
                .IsUnicode(false);

            entity.Property(e => e.DESCRIPCION)
                .HasMaxLength(255)
                .IsUnicode(false);

            entity.Property(e => e.FECHA_CREACION).HasColumnType("datetime");

            entity.Property(e => e.FECHA_MODIFICACION).HasColumnType("datetime");

            entity.Property(e => e.NOMBRE_INDICADOR)
                .HasMaxLength(150)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_CREACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_MODIFICACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.HasOne(d => d.ID_CAPACIDADES_POR_COMPONENTENavigation)
                .WithMany(p => p.indicadores_logro_por_capacidad)
                .HasForeignKey(d => d.ID_CAPACIDADES_POR_COMPONENTE)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_INDICADO_FK_CAPACI_CAPACIDA");

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<indicadores_logro_por_capacidad> entity);
    }
}
