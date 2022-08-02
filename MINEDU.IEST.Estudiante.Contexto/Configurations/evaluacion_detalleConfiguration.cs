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
    public partial class evaluacion_detalleConfiguration : IEntityTypeConfiguration<evaluacion_detalle>
    {
        public void Configure(EntityTypeBuilder<evaluacion_detalle> entity)
        {
            entity.HasKey(e => e.ID_EVALUACION_DETALLE)
                .HasName("PK_EVALUACION_DETALLE")
                .IsClustered(false);

            entity.ToTable("evaluacion_detalle", "transaccional");

            entity.HasIndex(e => new { e.ID_MATRICULA_ESTUDIANTE, e.ES_ACTIVO }, "IDX_EVALUACION_DETALLE1");

            entity.HasIndex(e => e.ID_EVALUACION, "idx_evaluacion_detalle_evaluacion");

            entity.Property(e => e.FECHA_CREACION).HasColumnType("datetime");

            entity.Property(e => e.FECHA_MODIFICACION).HasColumnType("datetime");

            entity.Property(e => e.NOTA).HasColumnType("decimal(10, 2)");

            entity.Property(e => e.USUARIO_CREACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_MODIFICACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.HasOne(d => d.ID_EVALUACIONNavigation)
                .WithMany(p => p.evaluacion_detalle)
                .HasForeignKey(d => d.ID_EVALUACION)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_EVALUACI_RELATIONS_EVALUACI");

            entity.HasOne(d => d.ID_MATRICULA_ESTUDIANTENavigation)
                .WithMany(p => p.evaluacion_detalle)
                .HasForeignKey(d => d.ID_MATRICULA_ESTUDIANTE)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_EVALU_DET_FK_MATR_EST");

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<evaluacion_detalle> entity);
    }
}
