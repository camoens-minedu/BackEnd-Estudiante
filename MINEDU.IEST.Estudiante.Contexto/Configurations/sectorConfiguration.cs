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
    public partial class sectorConfiguration : IEntityTypeConfiguration<sector>
    {
        public void Configure(EntityTypeBuilder<sector> entity)
        {
            entity.HasKey(e => e.ID_SECTOR)
                .HasName("PK_SECTOR")
                .IsClustered(false);

            entity.ToTable("sector", "maestro");

            entity.Property(e => e.CODIGO_SECTOR)
                .HasMaxLength(5)
                .IsUnicode(false);

            entity.Property(e => e.DESCRIPCION_SECTOR)
                .HasMaxLength(255)
                .IsUnicode(false);

            entity.Property(e => e.FECHA_CREACION).HasColumnType("datetime");

            entity.Property(e => e.FECHA_MODIFICACION).HasColumnType("datetime");

            entity.Property(e => e.NOMBRE_SECTOR)
                .HasMaxLength(50)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_CREACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_MODIFICACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<sector> entity);
    }
}
