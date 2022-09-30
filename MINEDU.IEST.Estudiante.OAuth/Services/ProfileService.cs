using IdentityServer4.Extensions;
using IdentityServer4.Models;
using IdentityServer4.Services;
using Microsoft.AspNetCore.Identity;
using MINEDU.IEST.Estudiante.Entity.Security;
using MINEDU.IEST.Estudiante.Inf_Utils.Constants;
using System.Collections.Generic;
using System.Security.Claims;
using System.Threading.Tasks;

namespace MINEDU.IEST.Estudiante.OAuth.Services
{
    public class ProfileService : IProfileService
    {
        protected UserManager<ApplicationUser> _userManager;

        public ProfileService(UserManager<ApplicationUser> userManager)
        {
            _userManager = userManager;
        }

        public async Task GetProfileDataAsync(ProfileDataRequestContext context)
        {
            var user = await _userManager.GetUserAsync(context.Subject);
            var claims = new List<Claim>
            {
                //new Claim(SecurityClaimType.PersonId, user.Id.ToString()),
                new Claim(SecurityClaimType.PersonId, user.Id_Persona.ToString()),
            };

            context.IssuedClaims.AddRange(claims);
        }

        public async Task IsActiveAsync(IsActiveContext context)
        {
            //>Processing
            var sub = context.Subject.GetSubjectId();
            var user = await _userManager.FindByIdAsync(sub);
            context.IsActive = user != null;
        }
    }
}
