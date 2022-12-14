// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MINEDU.IEST.Estudiante.Contexto.Data.DigePadron;
using MINEDU.IEST.Estudiante.Entity.DigePadron;
using System;
using System.Collections.Generic;

namespace MINEDU.IEST.Estudiante.Contexto.Data.DigePadron.Configurations
{
    public partial class CatalogoOfertaFormativaConfiguration : IEntityTypeConfiguration<CatalogoOfertaFormativa>
    {
        public void Configure(EntityTypeBuilder<CatalogoOfertaFormativa> entity)
        {
            entity.HasKey(e => e.IdCatalogoOfertaFormativa)
                .HasName("PK_CATALOGO_OFERTA_FORMATIVA");

            entity.ToTable("catalogo_oferta_formativa");

            entity.Property(e => e.IdCatalogoOfertaFormativa)
                .ValueGeneratedNever()
                .HasColumnName("ID_CATALOGO_OFERTA_FORMATIVA");

            entity.Property(e => e.CodigoDescripcion)
                .HasMaxLength(6)
                .HasColumnName("CODIGO_DESCRIPCION");

            entity.Property(e => e.CodigoFamiliaProductiva)
                .HasMaxLength(4)
                .HasColumnName("CODIGO_FAMILIA_PRODUCTIVA");

            entity.Property(e => e.CodigoSector)
                .HasMaxLength(2)
                .HasColumnName("CODIGO_SECTOR");

            entity.Property(e => e.Descripcion)
                .HasMaxLength(2000)
                .HasColumnName("DESCRIPCION");

            entity.Property(e => e.Division)
                .HasMaxLength(3)
                .HasColumnName("DIVISION");

            entity.Property(e => e.Estado)
                .HasColumnName("ESTADO")
                .HasDefaultValueSql("((1))");

            entity.Property(e => e.FamiliaProductiva)
                .HasMaxLength(300)
                .HasColumnName("FAMILIA_PRODUCTIVA");

            entity.Property(e => e.FechaInsercion)
                .HasColumnType("datetime")
                .HasColumnName("FECHA_INSERCION")
                .HasDefaultValueSql("(sysdatetime())");

            entity.Property(e => e.FechaModificacion)
                .HasColumnType("datetime")
                .HasColumnName("FECHA_MODIFICACION");

            entity.Property(e => e.NombreSector)
                .HasMaxLength(200)
                .HasColumnName("NOMBRE_SECTOR");

            entity.Property(e => e.UsuarioInsercion).HasColumnName("USUARIO_INSERCION");

            entity.Property(e => e.UsuarioModificacion).HasColumnName("USUARIO_MODIFICACION");

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<CatalogoOfertaFormativa> entity);
    }
}
