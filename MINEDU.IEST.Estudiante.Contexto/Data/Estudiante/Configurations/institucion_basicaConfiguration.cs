// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MINEDU.IEST.Estudiante.Entity;

#nullable disable

namespace MINEDU.IEST.Estudiante.Contexto.Data.Estudiante.Configurations
{
    public partial class institucion_basicaConfiguration : IEntityTypeConfiguration<institucion_basica>
    {
        public void Configure(EntityTypeBuilder<institucion_basica> entity)
        {
            entity.HasKey(e => e.ID_INSTITUCION_BASICA)
                .HasName("PK_INSTITUCION_BASICA")
                .IsClustered(false);

            entity.ToTable("institucion_basica", "maestro");

            entity.HasIndex(e => new { e.ID_INSTITUCION_BASICA, e.ID_PAIS }, "IDX_INSTITUCION_BASICA1");

            entity.Property(e => e.CODIGO_MODULAR_IE_BASICA)
                .HasMaxLength(7)
                .IsUnicode(false);

            entity.Property(e => e.DIRECCION_IE_BASICA)
                .HasMaxLength(255)
                .IsUnicode(false);

            entity.Property(e => e.FECHA_CREACION).HasColumnType("datetime");

            entity.Property(e => e.FECHA_MODIFICACION).HasColumnType("datetime");

            entity.Property(e => e.NOMBRE_IE_BASICA)
                .HasMaxLength(150)
                .IsUnicode(false);

            entity.Property(e => e.UBIGEO_IE_BASICA)
                .HasMaxLength(6)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_CREACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_MODIFICACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<institucion_basica> entity);
    }
}
