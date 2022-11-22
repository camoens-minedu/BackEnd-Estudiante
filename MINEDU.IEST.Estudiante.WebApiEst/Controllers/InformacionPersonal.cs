using Microsoft.AspNetCore.Mvc;
using MINEDU.IEST.Estudiante.Inf_Utils.Constants;
using MINEDU.IEST.Estudiante.Inf_Utils.Filters;
using MINEDU.IEST.Estudiante.Inf_Utils.Helpers;
using MINEDU.IEST.Estudiante.Manager.InformacionPersonal;
using MINEDU.IEST.Estudiante.ManagerDto.InformacionPersonal;

namespace MINEDU.IEST.Estudiante.WebApiEst.Controllers
{

    [ApiController]
    [ServiceFilter(typeof(ModelValidationAttribute))]
    public class InformacionPersonal : BaseController
    {
        private readonly IPersonalManager _personalManager;
        private readonly ILogger<InformacionPersonal> _logger;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public InformacionPersonal(IPersonalManager personalManager, ILogger<InformacionPersonal> logger, IHttpContextAccessor httpContextAccessor)
        {
            this._personalManager = personalManager;
            this._logger = logger;
            _httpContextAccessor = httpContextAccessor;
        }

        /// <summary>
        /// Muestrar información de la persona - estudiante
        /// </summary>
        /// /// <remarks>
        /// Sample request:
        /// 
        ///     POST api/InformacionPersonal
        ///     {        
        ///       "firstName": "Mike",
        ///       "lastName": "Andrew",
        ///       "emailId": "Mike.Andrew@gmail.com"        
        ///     }
        /// </remarks>
        /// <param name="idPersona"></param>
        /// <returns></returns>
        [HttpGet("{idPersonaInstitucion:int}")]
        public async Task<IActionResult> InformacionPersona(int idPersonaInstitucion)
        {
            try
            {

                if (idPersonaInstitucion == 0) ModelState.AddModelError("idPersonaInstitucion", "No debe ser igual a cero");

                if (!ModelState.IsValid)
                {
                    return UnprocessableEntity(ExtensionTools.Validaciones(ModelState));
                }
                int personId = int.Parse(_httpContextAccessor.HttpContext.User.Claims.FirstOrDefault(c => c.Type == SecurityClaimType.PersonId).Value);


                return Ok(await _personalManager.GetInfoPersonalForEdit(personId, idPersonaInstitucion));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex.Message);
                throw ex;
            }
        }

        [HttpGet("Perfil/{idInstitucion}/{idCarrera}")]
        public async Task<IActionResult> GetPerfilEstudiante(int idInstitucion, int idCarrera)
        {
            try
            {
                var query = await _personalManager.GetEstudiantePerfil(idInstitucion, idCarrera);
                if (query == null)
                {
                    return NotFound("Estudiante no encontrado");
                }
                return Ok(query);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex.Message);
                throw;
            }

        }


        [HttpPost("CreateOrUpdateInformacionPersonal")]
        public async Task<IActionResult> CreateOrUpdateInformacionPersonal(CreateOrUpdatePersonaDto model)
        {
            return Ok(await _personalManager.CreateOrUpdateInformacionPersonal(model));
        }
    }
}
