﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MINEDU.IEST.Estudiante.Contexto.Data.SecurityApi;
using MINEDU.IEST.Estudiante.Entity.SecurityApi;
using System;
using System.Collections.Generic;

namespace MINEDU.IEST.Estudiante.Contexto.Data.SecurityApi.Configurations
{
    public partial class UserClaimConfiguration : IEntityTypeConfiguration<UserClaim>
    {
        public void Configure(EntityTypeBuilder<UserClaim> entity)
        {
            entity.ToTable("UserClaims", "Security");

            entity.HasIndex(e => e.UserId, "IX_UserClaims_UserId");

            entity.Property(e => e.UserId).IsRequired();

            entity.HasOne(d => d.User)
                .WithMany(p => p.UserClaims)
                .HasForeignKey(d => d.UserId);

            OnConfigurePartial(entity);
        }

        partial void OnConfigurePartial(EntityTypeBuilder<UserClaim> entity);
    }
}
