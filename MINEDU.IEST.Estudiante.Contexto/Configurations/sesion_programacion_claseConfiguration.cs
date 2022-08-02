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
    public partial class sesion_programacion_claseConfiguration : IEntityTypeConfiguration<sesion_programacion_clase>
    {
        public void Configure(EntityTypeBuilder<sesion_programacion_clase> entity)
        {
            entity.HasKey(e => e.ID_SESION_PROGRAMACION_CLASE)
                .HasName("PK_SESION_PROGRAMACION_CLASE")
                .IsClustered(false);

            entity.ToTable("sesion_programacion_clase", "transaccional");

            entity.Property(e => e.FECHA_CREACION).HasColumnType("datetime");

            entity.Property(e => e.FECHA_MODIFICACION).HasColumnType("datetime");

            entity.Property(e => e.HORA_FIN)
                .HasMaxLength(5)
                .IsUnicode(false);

            entity.Property(e => e.HORA_INICIO)
                .HasMaxLength(5)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_CREACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_MODIFICACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.HasOne(d => d.ID_AULANavigation)
                .WithMany(p => p.sesion_programacion_clase)
                .HasForeignKey(d => d.ID_AULA)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_SESION_P_FK_AULA_S_AULA");

            entity.HasOne(d => d.ID_PROGRAMACION_CLASENavigation)
                .WithMany(p => p.sesion_programacion_clase)
                .HasForeignKey(d => d.ID_PROGRAMACION_CLASE)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_SESION_P_FK_PROGRA_PROGRAMA");

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<sesion_programacion_clase> entity);
    }
}
