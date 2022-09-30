﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MINEDU.IEST.Estudiante.Contexto.Data.DigePadron;
using MINEDU.IEST.Estudiante.Entity.DigePadron;
using System;
using System.Collections.Generic;

namespace MINEDU.IEST.Estudiante.Contexto.Data.DigePadron.Configurations
{
    public partial class SectorConfiguration : IEntityTypeConfiguration<Sector>
    {
        public void Configure(EntityTypeBuilder<Sector> entity)
        {
            entity.HasKey(e => e.IdSector)
                .HasName("PK_SECTOR");

            entity.ToTable("sector");

            entity.Property(e => e.IdSector)
                .ValueGeneratedNever()
                .HasColumnName("ID_SECTOR");

            entity.Property(e => e.CodigoSector)
                .HasMaxLength(1)
                .IsUnicode(false)
                .HasColumnName("CODIGO_SECTOR")
                .IsFixedLength();

            entity.Property(e => e.Descripcion)
                .HasColumnType("text")
                .HasColumnName("DESCRIPCION");

            entity.Property(e => e.Estado)
                .HasColumnName("ESTADO")
                .HasDefaultValueSql("((1))");

            entity.Property(e => e.FechaInsercion)
                .HasColumnType("datetime")
                .HasColumnName("FECHA_INSERCION")
                .HasDefaultValueSql("(sysdatetime())");

            entity.Property(e => e.FechaModificacion)
                .HasColumnType("datetime")
                .HasColumnName("FECHA_MODIFICACION");

            entity.Property(e => e.NombreSector)
                .HasMaxLength(120)
                .HasColumnName("NOMBRE_SECTOR");

            entity.Property(e => e.UsuarioInsercion).HasColumnName("USUARIO_INSERCION");

            entity.Property(e => e.UsuarioModificacion).HasColumnName("USUARIO_MODIFICACION");

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<Sector> entity);
    }
}