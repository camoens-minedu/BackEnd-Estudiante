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
    public partial class distribucion_evaluacion_admision_detalleConfiguration : IEntityTypeConfiguration<distribucion_evaluacion_admision_detalle>
    {
        public void Configure(EntityTypeBuilder<distribucion_evaluacion_admision_detalle> entity)
        {
            entity.HasKey(e => e.ID_DISTRIBUCION_EVALUACION_ADMISION_DETALLE)
                .HasName("PK_DISTRIBUCION_EVALUACION_ADM")
                .IsClustered(false);

            entity.ToTable("distribucion_evaluacion_admision_detalle", "transaccional");

            entity.Property(e => e.FECHA_CREACION).HasColumnType("datetime");

            entity.Property(e => e.FECHA_MODIFICACION).HasColumnType("datetime");

            entity.Property(e => e.USUARIO_CREACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_MODIFICACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.HasOne(d => d.ID_DISTRIBUCION_EXAMEN_ADMISIONNavigation)
                .WithMany(p => p.distribucion_evaluacion_admision_detalle)
                .HasForeignKey(d => d.ID_DISTRIBUCION_EXAMEN_ADMISION)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_DISTRIBU_RELATIONS_DISTRIBU");

            entity.HasOne(d => d.ID_POSTULANTES_POR_MODALIDADNavigation)
                .WithMany(p => p.distribucion_evaluacion_admision_detalle)
                .HasForeignKey(d => d.ID_POSTULANTES_POR_MODALIDAD)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_DISTRIBU_RELATIONS_POSTULAN");

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<distribucion_evaluacion_admision_detalle> entity);
    }
}