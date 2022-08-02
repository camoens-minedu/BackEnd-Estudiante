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
    public partial class tipo_modalidadConfiguration : IEntityTypeConfiguration<tipo_modalidad>
    {
        public void Configure(EntityTypeBuilder<tipo_modalidad> entity)
        {
            entity.HasKey(e => e.ID_TIPO_MODALIDAD)
                .HasName("PK_TIPO_MODALIDAD")
                .IsClustered(false);

            entity.ToTable("tipo_modalidad", "maestro");

            entity.Property(e => e.FECHA_CREACION).HasColumnType("datetime");

            entity.Property(e => e.FECHA_MODIFICACION).HasColumnType("datetime");

            entity.Property(e => e.NOMBRE_TIPO_MODALIDAD)
                .HasMaxLength(150)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_CREACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_MODIFICACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<tipo_modalidad> entity);
    }
}
