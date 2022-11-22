using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MINEDU.IEST.Estudiante.ManagerDto.InformacionPersonal
{
    public class CreateOrUpdatePersonaDto
    {
        public int ID_PERSONA { get; set; }
        public int ID_LENGUA_MATERNA { get; set; }
        public bool? ES_DISCAPACITADO { get; set; }
        public string? CORREO { get; set; }
        //public string? UBIGEO_NACIMIENTO { get; set; }
        public string? CELULAR { get; set; }
        public int PAIS_NACIMIENTO { get; set; }
        public string? DIRECCION_PERSONA { get; set; }
        public string UBIGEO_NACIMIENTO { get; set; }
    }
}
