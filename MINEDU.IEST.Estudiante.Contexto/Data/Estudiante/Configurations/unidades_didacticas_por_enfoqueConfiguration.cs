﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MINEDU.IEST.Estudiante.Entity;

#nullable disable

namespace MINEDU.IEST.Estudiante.Contexto.Data.Estudiante.Configurations
{
    public partial class unidades_didacticas_por_enfoqueConfiguration : IEntityTypeConfiguration<unidades_didacticas_por_enfoque>
    {
        public void Configure(EntityTypeBuilder<unidades_didacticas_por_enfoque> entity)
        {
            entity.HasKey(e => e.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE)
                .HasName("PK_UNIDADES_DIDACTICAS_POR_ENF")
                .IsClustered(false);

            entity.ToTable("unidades_didacticas_por_enfoque", "transaccional");

            entity.HasIndex(e => new { e.ID_UNIDAD_DIDACTICA, e.ES_ACTIVO }, "IDX_UNIDAD_DIDACTICA_ENFOQ1");

            entity.Property(e => e.FECHA_CREACION).HasColumnType("datetime");

            entity.Property(e => e.FECHA_MODIFICACION).HasColumnType("datetime");

            entity.Property(e => e.USUARIO_CREACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_MODIFICACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.HasOne(d => d.ID_ENFOQUES_POR_PLAN_ESTUDIONavigation)
                .WithMany(p => p.unidades_didacticas_por_enfoque)
                .HasForeignKey(d => d.ID_ENFOQUES_POR_PLAN_ESTUDIO)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_UNIDADES_FK_ENFOQU_ENFOQUES");

            entity.HasOne(d => d.ID_TIPO_UNIDAD_DIDACTICANavigation)
                .WithMany(p => p.unidades_didacticas_por_enfoque)
                .HasForeignKey(d => d.ID_TIPO_UNIDAD_DIDACTICA)
                .HasConstraintName("FK_UNIDADES_RELATIONS_TIPO_UNI");

            entity.HasOne(d => d.ID_UNIDAD_DIDACTICANavigation)
                .WithMany(p => p.unidades_didacticas_por_enfoque)
                .HasForeignKey(d => d.ID_UNIDAD_DIDACTICA)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_UNIDADES_RELATIONS_UNIDAD_D");

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<unidades_didacticas_por_enfoque> entity);
    }
}