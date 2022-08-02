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
    public partial class periodos_lectivos_por_institucionConfiguration : IEntityTypeConfiguration<periodos_lectivos_por_institucion>
    {
        public void Configure(EntityTypeBuilder<periodos_lectivos_por_institucion> entity)
        {
            entity.HasKey(e => e.ID_PERIODOS_LECTIVOS_POR_INSTITUCION)
                .HasName("PK_PERIODOS_LECTIVOS_POR_INSTI")
                .IsClustered(false);

            entity.ToTable("periodos_lectivos_por_institucion", "transaccional");

            entity.Property(e => e.FECHA_CREACION).HasColumnType("datetime");

            entity.Property(e => e.FECHA_FIN_INSTITUCION).HasColumnType("datetime");

            entity.Property(e => e.FECHA_INICIO_INSTITUCION).HasColumnType("datetime");

            entity.Property(e => e.FECHA_MODIFICACION).HasColumnType("datetime");

            entity.Property(e => e.NOMBRE_PERIODO_LECTIVO_INSTITUCION)
                .HasMaxLength(50)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_CREACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_MODIFICACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.HasOne(d => d.ID_PERIODO_LECTIVONavigation)
                .WithMany(p => p.periodos_lectivos_por_institucion)
                .HasForeignKey(d => d.ID_PERIODO_LECTIVO)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_PERIODOS_RELATIONS_PERIODO_");

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<periodos_lectivos_por_institucion> entity);
    }
}
