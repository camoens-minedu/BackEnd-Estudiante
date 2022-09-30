using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MINEDU.IEST.Estudiante.Inf_Utils.Constants;
using MINEDU.IEST.Estudiante.Inf_Utils.Helpers;
using MINEDU.IEST.Estudiante.Manager.SecurityApi;

namespace MINEDU.IEST.Estudiante.OAuth.Api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SecurityController : ControllerBase
    {
        private readonly ISecurityApiManager _securityManager;
        private readonly ILogger<SecurityController> _logger;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public SecurityController(ISecurityApiManager securityManager, ILogger<SecurityController> logger, IHttpContextAccessor httpContextAccessor)
        {
            _securityManager = securityManager;
            _logger = logger;
            _httpContextAccessor = httpContextAccessor;
        }

        [HttpGet("getaccess")]
        public async Task<IActionResult> GetUserByUserName()
        {
            int personId = int.Parse(_httpContextAccessor.HttpContext.User.Claims.FirstOrDefault(c => c.Type == SecurityClaimType.PersonId).Value);
            var query = await _securityManager.GetUserByUserName(personId);
            if (query == null)
                return NotFound();

            return Ok(query);
        }

        [AllowAnonymous]
        [HttpGet("{tipoDocumento:int}/{nroDocumento}/{correo}")]
        public async Task<IActionResult> GetPersonaInstitucionValidate(int tipoDocumento, string nroDocumento, string correo)
        {
            var query = await _securityManager.GetPersonaInstitucionValidate(tipoDocumento, nroDocumento, correo);

            if (query.ID_PERSONA == 0)
            {
                ModelState.AddModelError("idPersona", "No se encuentró el alumno.");
                return UnprocessableEntity(ExtensionTools.Validaciones(ModelState));

            }
            return Ok(query);
        }

        [AllowAnonymous]
        [HttpGet("getdocumento")]
        public async Task<IActionResult> GetTipoDocumento() => Ok(await _securityManager.GetTipoDocumento());



    }
}
