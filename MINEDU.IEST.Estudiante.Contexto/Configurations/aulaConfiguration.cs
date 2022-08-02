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
    public partial class aulaConfiguration : IEntityTypeConfiguration<aula>
    {
        public void Configure(EntityTypeBuilder<aula> entity)
        {
            entity.HasKey(e => e.ID_AULA)
                .HasName("PK_AULA")
                .IsClustered(false);

            entity.ToTable("aula", "maestro");

            entity.Property(e => e.FECHA_CREACION).HasColumnType("datetime");

            entity.Property(e => e.FECHA_MODIFICACION).HasColumnType("datetime");

            entity.Property(e => e.NOMBRE_AULA)
                .HasMaxLength(50)
                .IsUnicode(false);

            entity.Property(e => e.OBSERVACION_AULA)
                .HasMaxLength(255)
                .IsUnicode(false);

            entity.Property(e => e.UBICACION_AULA)
                .HasMaxLength(150)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_CREACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_MODIFICACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.HasOne(d => d.ID_SEDE_INSTITUCIONNavigation)
                .WithMany(p => p.aula)
                .HasForeignKey(d => d.ID_SEDE_INSTITUCION)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_AULA_FK_SEDE_I_SEDE_INS");

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<aula> entity);
    }
}