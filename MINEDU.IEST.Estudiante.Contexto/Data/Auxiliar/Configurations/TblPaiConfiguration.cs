﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MINEDU.IEST.Estudiante.Entity.Auxiliar;

namespace MINEDU.IEST.Estudiante.Contexto.Data.Auxiliar.Configurations
{
    public partial class TblPaiConfiguration : IEntityTypeConfiguration<PaisAuxiliar>
    {
        public void Configure(EntityTypeBuilder<PaisAuxiliar> entity)
        {
            entity.HasKey(e => new { e.Codigo, e.Codpais, e.Codcontinente });

            entity.ToTable("tbl_pais");

            entity.Property(e => e.Codigo)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("CODIGO");

            entity.Property(e => e.Codpais)
                .HasMaxLength(2)
                .IsUnicode(false)
                .HasColumnName("CODPAIS");

            entity.Property(e => e.Codcontinente)
                .HasMaxLength(2)
                .IsUnicode(false)
                .HasColumnName("CODCONTINENTE");

            entity.Property(e => e.Dsccontinente)
                .IsRequired()
                .HasMaxLength(8)
                .IsUnicode(false)
                .HasColumnName("DSCCONTINENTE");

            entity.Property(e => e.Dscpais)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("DSCPAIS");

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<PaisAuxiliar> entity);
    }
}
