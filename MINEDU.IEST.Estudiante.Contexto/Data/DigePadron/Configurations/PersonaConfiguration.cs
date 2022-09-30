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
    public partial class PersonaConfiguration : IEntityTypeConfiguration<Persona>
    {
        public void Configure(EntityTypeBuilder<Persona> entity)
        {
            entity.HasKey(e => e.IdPersona);

            entity.ToTable("persona");

            entity.Property(e => e.IdPersona).HasColumnName("ID_PERSONA");

            entity.Property(e => e.ApellidoMaterno)
                .HasMaxLength(100)
                .HasColumnName("APELLIDO_MATERNO");

            entity.Property(e => e.ApellidoPaterno)
                .HasMaxLength(100)
                .HasColumnName("APELLIDO_PATERNO");

            entity.Property(e => e.Direccion)
                .HasMaxLength(300)
                .HasColumnName("DIRECCION");

            entity.Property(e => e.DireccionDepartamento)
                .HasMaxLength(2)
                .HasColumnName("DIRECCION_DEPARTAMENTO");

            entity.Property(e => e.DireccionDistrito)
                .HasMaxLength(6)
                .HasColumnName("DIRECCION_DISTRITO");

            entity.Property(e => e.DireccionProvincia)
                .HasMaxLength(4)
                .HasColumnName("DIRECCION_PROVINCIA");

            entity.Property(e => e.Email)
                .HasMaxLength(300)
                .HasColumnName("EMAIL");

            entity.Property(e => e.Estado).HasColumnName("ESTADO");

            entity.Property(e => e.FechaInsercion)
                .HasColumnType("datetime")
                .HasColumnName("FECHA_INSERCION");

            entity.Property(e => e.FechaModificacion)
                .HasColumnType("datetime")
                .HasColumnName("FECHA_MODIFICACION");

            entity.Property(e => e.FechaNacimiento)
                .HasColumnType("datetime")
                .HasColumnName("FECHA_NACIMIENTO");

            entity.Property(e => e.NombreCarnesis)
                .HasMaxLength(250)
                .HasColumnName("NOMBRE_CARNESIS");

            entity.Property(e => e.Nombres)
                .HasMaxLength(200)
                .HasColumnName("NOMBRES");

            entity.Property(e => e.NumeroDocumento)
                .HasMaxLength(11)
                .HasColumnName("NUMERO_DOCUMENTO");

            entity.Property(e => e.PartidaRegistral)
                .HasMaxLength(50)
                .HasColumnName("PARTIDA_REGISTRAL");

            entity.Property(e => e.Sexo).HasColumnName("SEXO");

            entity.Property(e => e.TelefonoCelular)
                .HasMaxLength(30)
                .HasColumnName("TELEFONO_CELULAR");

            entity.Property(e => e.TelefonoFijo)
                .HasMaxLength(30)
                .HasColumnName("TELEFONO_FIJO");

            entity.Property(e => e.TipoDocumento).HasColumnName("TIPO_DOCUMENTO");

            entity.Property(e => e.TipoPersona).HasColumnName("TIPO_PERSONA");

            entity.Property(e => e.UsuarioInsercion).HasColumnName("USUARIO_INSERCION");

            entity.Property(e => e.UsuarioModificacion).HasColumnName("USUARIO_MODIFICACION");

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<Persona> entity);
    }
}