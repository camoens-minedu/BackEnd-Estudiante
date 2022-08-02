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
    public partial class requisitos_por_traslado_institucionConfiguration : IEntityTypeConfiguration<requisitos_por_traslado_institucion>
    {
        public void Configure(EntityTypeBuilder<requisitos_por_traslado_institucion> entity)
        {
            entity.HasKey(e => e.ID_REQUISITOS_POR_TRASLADO_INSTITUCION)
                .HasName("PK_REQUISITOS_POR_TRASLADO_INS")
                .IsClustered(false);

            entity.ToTable("requisitos_por_traslado_institucion", "maestro");

            entity.Property(e => e.FECHA_CREACION).HasColumnType("datetime");

            entity.Property(e => e.FECHA_MODIFICACION).HasColumnType("datetime");

            entity.Property(e => e.USUARIO_CREACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_MODIFICACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.HasOne(d => d.ID_REQUISITONavigation)
                .WithMany(p => p.requisitos_por_traslado_institucion)
                .HasForeignKey(d => d.ID_REQUISITO)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_REQUISIT_RELATIONS_REQUISIT");

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<requisitos_por_traslado_institucion> entity);
    }
}