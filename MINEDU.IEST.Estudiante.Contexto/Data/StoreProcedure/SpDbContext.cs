// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable disable
using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using MINEDU.IEST.Estudiante.Entity.StoreProcedure;

namespace MINEDU.IEST.Estudiante.Contexto.Data.StoreProcedure
{
    public partial class SpDbContext : DbContext
    {
        public SpDbContext()
        {
        }

        public SpDbContext(DbContextOptions<SpDbContext> options)
            : base(options)
        {
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.UseCollation("Latin1_General_CS_AS");

            OnModelCreatingGeneratedProcedures(modelBuilder);
            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}