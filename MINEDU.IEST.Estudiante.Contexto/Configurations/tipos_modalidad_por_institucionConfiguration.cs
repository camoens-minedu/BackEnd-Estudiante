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
    public partial class tipos_modalidad_por_institucionConfiguration : IEntityTypeConfiguration<tipos_modalidad_por_institucion>
    {
        public void Configure(EntityTypeBuilder<tipos_modalidad_por_institucion> entity)
        {
            entity.HasKey(e => e.ID_TIPOS_MODALIDAD_POR_INSTITUCION)
                .HasName("PK_TIPOS_MODALIDAD_POR_INSTITU")
                .IsClustered(false);

            entity.ToTable("tipos_modalidad_por_institucion", "maestro");

            entity.Property(e => e.FECHA_CREACION).HasColumnType("datetime");

            entity.Property(e => e.FECHA_MODIFICACION).HasColumnType("datetime");

            entity.Property(e => e.USUARIO_CREACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_MODIFICACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.HasOne(d => d.ID_TIPO_MODALIDADNavigation)
                .WithMany(p => p.tipos_modalidad_por_institucion)
                .HasForeignKey(d => d.ID_TIPO_MODALIDAD)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_TIPOS_MO_RELATIONS_TIPO_MOD");

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<tipos_modalidad_por_institucion> entity);
    }
}
