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
    public partial class PromotorConfiguration : IEntityTypeConfiguration<Promotor>
    {
        public void Configure(EntityTypeBuilder<Promotor> entity)
        {
            entity.HasKey(e => e.IdPromotor);

            entity.ToTable("promotor");

            entity.Property(e => e.IdPromotor).HasColumnName("ID_PROMOTOR");

            entity.Property(e => e.Estado)
                .HasColumnName("ESTADO")
                .HasDefaultValueSql("((1))");

            entity.Property(e => e.FechaFin)
                .HasColumnType("date")
                .HasColumnName("FECHA_FIN");

            entity.Property(e => e.FechaInicio)
                .HasColumnType("date")
                .HasColumnName("FECHA_INICIO");

            entity.Property(e => e.FechaInsercion)
                .HasColumnType("datetime")
                .HasColumnName("FECHA_INSERCION")
                .HasDefaultValueSql("(sysdatetime())");

            entity.Property(e => e.FechaModificacion)
                .HasColumnType("datetime")
                .HasColumnName("FECHA_MODIFICACION");

            entity.Property(e => e.IdDocumentoRespuesta).HasColumnName("ID_DOCUMENTO_RESPUESTA");

            entity.Property(e => e.IdInstitucion).HasColumnName("ID_INSTITUCION");

            entity.Property(e => e.IdPersona).HasColumnName("ID_PERSONA");

            entity.Property(e => e.UsuarioInsercion).HasColumnName("USUARIO_INSERCION");

            entity.Property(e => e.UsuarioModificacion).HasColumnName("USUARIO_MODIFICACION");

            entity.Property(e => e.Vigente).HasColumnName("VIGENTE");

            entity.HasOne(d => d.IdInstitucionNavigation)
                .WithMany(p => p.Promotors)
                .HasForeignKey(d => d.IdInstitucion)
                .HasConstraintName("FK_promotor_institucion");

            entity.HasOne(d => d.IdPersonaNavigation)
                .WithMany(p => p.Promotors)
                .HasForeignKey(d => d.IdPersona)
                .HasConstraintName("FK_promotor_persona");

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<Promotor> entity);
    }
}
