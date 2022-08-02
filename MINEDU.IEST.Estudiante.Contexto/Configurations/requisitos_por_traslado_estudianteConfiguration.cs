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
    public partial class requisitos_por_traslado_estudianteConfiguration : IEntityTypeConfiguration<requisitos_por_traslado_estudiante>
    {
        public void Configure(EntityTypeBuilder<requisitos_por_traslado_estudiante> entity)
        {
            entity.HasKey(e => e.ID_REQUISITOS_POR_TRASLADO_ESTUDIANTE)
                .HasName("PK_REQUISITOS_POR_TRASLADO_EST")
                .IsClustered(false);

            entity.ToTable("requisitos_por_traslado_estudiante", "transaccional");

            entity.Property(e => e.FECHA_CREACION).HasColumnType("datetime");

            entity.Property(e => e.FECHA_MODIFICACION).HasColumnType("datetime");

            entity.Property(e => e.USUARIO_CREACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_MODIFICACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.HasOne(d => d.ID_REQUISITOS_POR_TRASLADO_INSTITUCIONNavigation)
                .WithMany(p => p.requisitos_por_traslado_estudiante)
                .HasForeignKey(d => d.ID_REQUISITOS_POR_TRASLADO_INSTITUCION)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_REQUISITOS_POR_TRANSALADO_INTITUCION_ESTUDIANTE");

            entity.HasOne(d => d.ID_TRASLADO_ESTUDIANTENavigation)
                .WithMany(p => p.requisitos_por_traslado_estudiante)
                .HasForeignKey(d => d.ID_TRASLADO_ESTUDIANTE)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_REQUISIT_RELATIONS_TRASLADO");

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<requisitos_por_traslado_estudiante> entity);
    }
}
