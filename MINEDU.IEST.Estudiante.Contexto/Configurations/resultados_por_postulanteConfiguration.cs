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
    public partial class resultados_por_postulanteConfiguration : IEntityTypeConfiguration<resultados_por_postulante>
    {
        public void Configure(EntityTypeBuilder<resultados_por_postulante> entity)
        {
            entity.HasKey(e => e.ID_RESULTADOS_POR_POSTULANTE)
                .HasName("PK_RESULTADOS_POR_POSTULANTE")
                .IsClustered(false);

            entity.ToTable("resultados_por_postulante", "transaccional");

            entity.Property(e => e.FECHA_CREACION).HasColumnType("datetime");

            entity.Property(e => e.FECHA_MODIFICACION).HasColumnType("datetime");

            entity.Property(e => e.NOTA_RESULTADO).HasColumnType("decimal(10, 2)");

            entity.Property(e => e.USUARIO_CREACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_MODIFICACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.HasOne(d => d.ID_OPCIONES_POR_POSTULANTENavigation)
                .WithMany(p => p.resultados_por_postulante)
                .HasForeignKey(d => d.ID_OPCIONES_POR_POSTULANTE)
                .HasConstraintName("FK_RESULT_POST_FK_OPCION_POST");

            entity.HasOne(d => d.ID_POSTULANTES_POR_MODALIDADNavigation)
                .WithMany(p => p.resultados_por_postulante)
                .HasForeignKey(d => d.ID_POSTULANTES_POR_MODALIDAD)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_RESULTAD_RELATIONS_POSTULAN");

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<resultados_por_postulante> entity);
    }
}
