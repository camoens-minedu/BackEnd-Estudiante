using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using MINEDU.IEST.Estudiante.Entity.Security;
using MINEDU.IEST.Estudiante.Inf_Utils.Constants;
using System;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;

namespace MINEDU.IEST.Estudiante.OAuth.Infraestructure
{
    public class SecuritySeedData
    {
        public static void Initialize(IServiceProvider services)
        {
            var roleManager = services.GetRequiredService<RoleManager<IdentityRole>>();
            EnsureRolesAsync(roleManager).Wait();

            var userManager = services.GetRequiredService<UserManager<ApplicationUser>>();
            EnsureUsersAsync(userManager).Wait();
        }

        private static async Task EnsureUsersAsync(UserManager<ApplicationUser> userManager)
        {
            var admin = await userManager.Users.Where(x => x.UserName == "admin@todo.local").SingleOrDefaultAsync();
            if (admin == null)
            {
                admin = new ApplicationUser
                {
                    UserName = "admin@todo.local",
                    Email = "admin@todo.local",
                    FirstName = "Israel",
                    LastName = "Lozano",
                    SurName = "Del Castillo"
                };
                await userManager.CreateAsync(admin, "P@ssword1234");
                string emailConfirmationToken = await userManager.GenerateEmailConfirmationTokenAsync(admin);
                await userManager.ConfirmEmailAsync(admin, emailConfirmationToken);
                await userManager.AddToRoleAsync(admin, Roles.Administrator);
                await userManager.AddToRoleAsync(admin, Roles.User);
            }

            var powerUser = await userManager.Users.Where(x => x.UserName == "power.user@todo.local").SingleOrDefaultAsync();
            if (powerUser == null)
            {
                powerUser = new ApplicationUser
                {
                    UserName = "power.user@todo.local",
                    Email = "power.user@todo.local",
                    FirstName = "Power",
                    LastName = "User",
                    SurName = "Test"
                };
                await userManager.CreateAsync(powerUser, "P@ssword1234");
                string emailConfirmationToken = await userManager.GenerateEmailConfirmationTokenAsync(powerUser);
                await userManager.ConfirmEmailAsync(powerUser, emailConfirmationToken);
                await userManager.AddToRoleAsync(powerUser, Roles.PowerUser);
                await userManager.AddToRoleAsync(powerUser, Roles.User);
            }

            var user = await userManager.Users.Where(x => x.UserName == "user@todo.local").SingleOrDefaultAsync();
            if (user == null)
            {
                user = new ApplicationUser
                {
                    UserName = "user@todo.local",
                    Email = "user@todo.local",
                    FirstName = "Usuario",
                    LastName = "Test",
                    SurName = "QA"
                };
                await userManager.CreateAsync(user, "P@ssword1234");
                string emailConfirmationToken = await userManager.GenerateEmailConfirmationTokenAsync(user);
                await userManager.ConfirmEmailAsync(user, emailConfirmationToken);
                await userManager.AddToRoleAsync(user, Roles.User);
            }
        }

        private static async Task EnsureRolesAsync(RoleManager<IdentityRole> roleManager)
        {
            bool alreadyExists = await roleManager.RoleExistsAsync(Roles.Administrator);
            if (!alreadyExists)
            {
                var role = new IdentityRole(Roles.Administrator);
                await roleManager.CreateAsync(role);
                await roleManager.AddClaimAsync(role, new Claim(SecurityClaimType.GrantAccess, GrantAccess.Delete));
                await roleManager.AddClaimAsync(role, new Claim(SecurityClaimType.GrantAccess, GrantAccess.Edit));
            }

            alreadyExists = await roleManager.RoleExistsAsync(Roles.PowerUser);
            if (!alreadyExists)
            {
                var role = await roleManager.CreateAsync(new IdentityRole(Roles.PowerUser));
            }

            alreadyExists = await roleManager.RoleExistsAsync(Roles.User);
            if (!alreadyExists)
            {
                await roleManager.CreateAsync(new IdentityRole(Roles.User));
            }
        }
    }
}
