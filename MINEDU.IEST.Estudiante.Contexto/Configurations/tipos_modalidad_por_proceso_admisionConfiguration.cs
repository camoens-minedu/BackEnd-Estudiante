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
    public partial class tipos_modalidad_por_proceso_admisionConfiguration : IEntityTypeConfiguration<tipos_modalidad_por_proceso_admision>
    {
        public void Configure(EntityTypeBuilder<tipos_modalidad_por_proceso_admision> entity)
        {
            entity.HasKey(e => e.ID_TIPOS_MODALIDAD_POR_PROCESO_ADMISION)
                .HasName("PK_TIPOS_MODALIDAD_POR_PROCESO")
                .IsClustered(false);

            entity.ToTable("tipos_modalidad_por_proceso_admision", "transaccional");

            entity.Property(e => e.FECHA_CREACION).HasColumnType("datetime");

            entity.Property(e => e.FECHA_MODIFICACION).HasColumnType("datetime");

            entity.Property(e => e.USUARIO_CREACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_MODIFICACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.HasOne(d => d.ID_PROCESO_ADMISION_PERIODONavigation)
                .WithMany(p => p.tipos_modalidad_por_proceso_admision)
                .HasForeignKey(d => d.ID_PROCESO_ADMISION_PERIODO)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_TIPOS_MO_RELATIONS_PROCESO_");

            entity.HasOne(d => d.ID_TIPOS_MODALIDAD_POR_INSTITUCIONNavigation)
                .WithMany(p => p.tipos_modalidad_por_proceso_admision)
                .HasForeignKey(d => d.ID_TIPOS_MODALIDAD_POR_INSTITUCION)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_TIPOS_MO_RELATIONS_TIPOS_MO");

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<tipos_modalidad_por_proceso_admision> entity);
    }
}
