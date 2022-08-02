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
    public partial class documentos_dre_archivosConfiguration : IEntityTypeConfiguration<documentos_dre_archivos>
    {
        public void Configure(EntityTypeBuilder<documentos_dre_archivos> entity)
        {
            entity.HasKey(e => e.ID_DOCUMENTOS_DRE_ARCHIVOS)
                .HasName("PK__document__16EA6783F51F5505");

            entity.ToTable("documentos_dre_archivos", "transaccional");

            entity.Property(e => e.ESTADO).HasDefaultValueSql("((1))");

            entity.Property(e => e.FECHA_CREACION).HasColumnType("datetime");

            entity.Property(e => e.FECHA_MODIFICACION).HasColumnType("datetime");

            entity.Property(e => e.NOMBRE_ARCHIVO).IsUnicode(false);

            entity.Property(e => e.NOMBRE_DOCUMENTO).IsUnicode(false);

            entity.Property(e => e.RUTA_ARCHIVO).IsUnicode(false);

            entity.HasOne(d => d.ID_DOCUMENTOS_DRENavigation)
                .WithMany(p => p.documentos_dre_archivos)
                .HasForeignKey(d => d.ID_DOCUMENTOS_DRE)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__documento__ID_DO__4E0988E7");

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<documentos_dre_archivos> entity);
    }
}
