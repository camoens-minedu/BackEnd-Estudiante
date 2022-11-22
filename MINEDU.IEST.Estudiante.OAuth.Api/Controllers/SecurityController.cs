using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MINEDU.IEST.Estudiante.Inf_Utils.Constants;
using MINEDU.IEST.Estudiante.Inf_Utils.Helpers;
using MINEDU.IEST.Estudiante.Manager.InformacionPersonal;
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
        private readonly IPersonalManager _personalManager;

        public SecurityController(ISecurityApiManager securityManager, ILogger<SecurityController> logger, IHttpContextAccessor httpContextAccessor, IPersonalManager personalManager)
        {
            _securityManager = securityManager;
            _logger = logger;
            _httpContextAccessor = httpContextAccessor;
            _personalManager = personalManager;
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

        [HttpGet("change-password/{idPersona}/{oldClave}/{newClave}")]
        public async Task<IActionResult> GetChangePassword(int idPersona, string oldClave, string newClave)
        {
            var query = await _securityManager.GetChangePassword(idPersona, oldClave, newClave);

            if (!query)
            {
                ModelState.AddModelError("*", "No se pudo cambiar la contraseña");
                return UnprocessableEntity(ExtensionTools.Validaciones(ModelState));
            }

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
        [HttpGet("{idPersona:int}")]
        public async Task<IActionResult> GetPersonaById(int idPersona)
        {
            if (idPersona == 0) ModelState.AddModelError("*", "Persona no encontrada");

            if (!ModelState.IsValid)
            {
                return UnprocessableEntity(ExtensionTools.Validaciones(ModelState));
            }

            var query = await _personalManager.GetPersonaForConfirm(idPersona);

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

        [AllowAnonymous]
        [HttpGet("{email}/{codigo}")]
        public async Task<IActionResult> GetForgotPassword(string email, string codigo)
        {
            var query = await _securityManager.GetForgotPassword(email, codigo);

            if (query.ID_PERSONA == 0)
            {
                ModelState.AddModelError("idPersona", "No se encuentró el alumno.");
                return UnprocessableEntity(ExtensionTools.Validaciones(ModelState));

            }

            return Ok(query);
        }

    }
}
