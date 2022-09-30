﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MINEDU.IEST.Estudiante.Entity;

#nullable disable

namespace MINEDU.IEST.Estudiante.Contexto.Data.Estudiante.Configurations
{
    public partial class carga_masiva_nominas_personaConfiguration : IEntityTypeConfiguration<carga_masiva_nominas_persona>
    {
        public void Configure(EntityTypeBuilder<carga_masiva_nominas_persona> entity)
        {
            entity.HasKey(e => e.ID_CARGA_MASIVA_PERSONA)
                .HasName("PK__carga_ma__0EF0992176A175A6");

            entity.ToTable("carga_masiva_nominas_persona", "transaccional");

            entity.Property(e => e.FECHA_CREACION).HasColumnType("datetime");

            entity.Property(e => e.FECHA_MODIFICACION).HasColumnType("datetime");

            entity.Property(e => e.NOMBRE_COMPLETO)
                .HasMaxLength(150)
                .IsUnicode(false);

            entity.Property(e => e.NUMERO_DOCUMENTO)
                .HasMaxLength(16)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_CREACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_MODIFICACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<carga_masiva_nominas_persona> entity);
    }
}