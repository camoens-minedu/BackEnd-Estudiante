// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MINEDU.IEST.Estudiante.Entity;

#nullable disable

namespace MINEDU.IEST.Estudiante.Contexto.Data.Estudiante.Configurations
{
    public partial class pre_requisitos_por_unidad_didacticaConfiguration : IEntityTypeConfiguration<pre_requisitos_por_unidad_didactica>
    {
        public void Configure(EntityTypeBuilder<pre_requisitos_por_unidad_didactica> entity)
        {
            entity.HasKey(e => e.ID_PRE_REQUISITOS_POR_UNIDAD_DIDACTICA)
                .HasName("PK_PRE_REQUISITOS_POR_UNIDAD_D")
                .IsClustered(false);

            entity.ToTable("pre_requisitos_por_unidad_didactica", "transaccional");

            entity.Property(e => e.FECHA_CREACION).HasColumnType("datetime");

            entity.Property(e => e.FECHA_MODIFICACION).HasColumnType("datetime");

            entity.Property(e => e.USUARIO_CREACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.Property(e => e.USUARIO_MODIFICACION)
                .HasMaxLength(20)
                .IsUnicode(false);

            entity.HasOne(d => d.ID_UNIDAD_DIDACTICANavigation)
                .WithMany(p => p.pre_requisitos_por_unidad_didacticaID_UNIDAD_DIDACTICANavigation)
                .HasForeignKey(d => d.ID_UNIDAD_DIDACTICA)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_UNIDAD_DIDACTICA_PRE_REQUISITOS_POR_UD");

            entity.HasOne(d => d.ID_UNIDAD_DIDACTICA_PRE_REQUISITONavigation)
                .WithMany(p => p.pre_requisitos_por_unidad_didacticaID_UNIDAD_DIDACTICA_PRE_REQUISITONavigation)
                .HasForeignKey(d => d.ID_UNIDAD_DIDACTICA_PRE_REQUISITO)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_UNIDAD_DIDACTICA_PRE_REQUISITOS_POR_UD_2");

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<pre_requisitos_por_unidad_didactica> entity);
    }
}
