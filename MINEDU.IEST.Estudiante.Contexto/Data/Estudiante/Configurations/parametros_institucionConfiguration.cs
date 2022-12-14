// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MINEDU.IEST.Estudiante.Entity;

#nullable disable

namespace MINEDU.IEST.Estudiante.Contexto.Data.Estudiante.Configurations
{
    public partial class parametros_institucionConfiguration : IEntityTypeConfiguration<parametros_institucion>
    {
        public void Configure(EntityTypeBuilder<parametros_institucion> entity)
        {
            entity.HasKey(e => e.ID_PARAMETROS_INSTITUCION)
                .HasName("PK_PARAMETROS_INSTITUCION")
                .IsClustered(false);

            entity.ToTable("parametros_institucion", "maestro");

            entity.Property(e => e.FECHA_CREACION).HasColumnType("datetime");

            entity.Property(e => e.FECHA_MODIFICACION).HasColumnType("datetime");

            entity.Property(e => e.NOMBRE_PARAMETRO)
                .HasMaxLength(50)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_CREACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_MODIFICACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.Property(e => e.VALOR_PARAMETRO)
                .HasMaxLength(16)
                .IsUnicode(false);

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<parametros_institucion> entity);
    }
}
