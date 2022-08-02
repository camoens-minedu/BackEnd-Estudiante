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
    public partial class evaluacion_experiencia_formativaConfiguration : IEntityTypeConfiguration<evaluacion_experiencia_formativa>
    {
        public void Configure(EntityTypeBuilder<evaluacion_experiencia_formativa> entity)
        {
            entity.HasKey(e => e.ID_EVALUACION_EXPERIENCIA_FORMATIVA)
                .HasName("PK__evaluaci__DD1479E66A01DE1E");

            entity.ToTable("evaluacion_experiencia_formativa", "transaccional");

            entity.Property(e => e.FECHA_CREACION).HasColumnType("datetime");

            entity.Property(e => e.FECHA_MODIFICACION).HasColumnType("datetime");

            entity.Property(e => e.NOTA).HasColumnType("decimal(10, 2)");

            entity.Property(e => e.USUARIO_CREACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_MODIFICACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.HasOne(d => d.ID_MATRICULA_ESTUDIANTENavigation)
                .WithMany(p => p.evaluacion_experiencia_formativa)
                .HasForeignKey(d => d.ID_MATRICULA_ESTUDIANTE)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_EVALUACION_EF_MATRICULA_ESTUDIANTE");

            entity.HasOne(d => d.ID_UNIDADES_DIDACTICAS_POR_ENFOQUENavigation)
                .WithMany(p => p.evaluacion_experiencia_formativa)
                .HasForeignKey(d => d.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_EVALUACION_EF_UNIDAD_DIDACTICA_POR_ENFOQUE");

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<evaluacion_experiencia_formativa> entity);
    }
}