using Microsoft.EntityFrameworkCore;
using MINEDU.IEST.Estudiante.Contexto.Data.Estudiante;
using MINEDU.IEST.Estudiante.Entity;
using MINEDU.IEST.Estudiante.Repository.Base;

namespace MINEDU.IEST.Estudiante.Repository.InformacionPersonal
{
    public class InformacionPersonaRepository : GenericRepository<persona>, IInformacionPersonaRepository
    {
        private readonly estudianteContext _context;

        public InformacionPersonaRepository(estudianteContext context) : base(context)
        {
            _context = context;
        }

        public async Task<persona> GetPersonaAlumno(int idPersona, int idPersonaInstitucion)
        {
            var query = _context.persona
                    .Where(p => p.ID_PERSONA == idPersona)
                    .Select(p => new persona
                    {
                        ID_PERSONA = p.ID_PERSONA,
                        ID_TIPO_DOCUMENTO = p.ID_TIPO_DOCUMENTO,
                        NUMERO_DOCUMENTO_PERSONA = p.NUMERO_DOCUMENTO_PERSONA,
                        SEXO_PERSONA = p.SEXO_PERSONA,
                        APELLIDO_PATERNO_PERSONA = p.APELLIDO_PATERNO_PERSONA,
                        APELLIDO_MATERNO_PERSONA = p.APELLIDO_MATERNO_PERSONA,
                        NOMBRE_PERSONA = p.NOMBRE_PERSONA,
                        FECHA_NACIMIENTO_PERSONA = p.FECHA_NACIMIENTO_PERSONA,
                        ID_LENGUA_MATERNA = p.ID_LENGUA_MATERNA,
                        ES_DISCAPACITADO = p.ES_DISCAPACITADO,
                        PAIS_NACIMIENTO = p.PAIS_NACIMIENTO,
                        UBIGEO_NACIMIENTO = p.UBIGEO_NACIMIENTO,
                        persona_institucion = p.persona_institucion.Select(pi => new persona_institucion
                        {
                            ID_PERSONA_INSTITUCION = pi.ID_PERSONA_INSTITUCION,
                            ID_INSTITUCION = pi.ID_INSTITUCION,
                            UBIGEO_PERSONA = pi.UBIGEO_PERSONA,
                            ESTADO_CIVIL = pi.ESTADO_CIVIL,
                            DIRECCION_PERSONA = pi.DIRECCION_PERSONA,
                            CORREO = pi.CORREO,
                            TELEFONO = pi.TELEFONO,
                            CELULAR = pi.CELULAR,
                            CELULAR2 = pi.CELULAR2,
                            ID_TIPO_DISCAPACIDAD = pi.ID_TIPO_DISCAPACIDAD
                        })
                        .Where(p => p.ID_PERSONA_INSTITUCION == idPersonaInstitucion)
                        .ToList(),
                    });
            return await query.FirstOrDefaultAsync();
        }

        public async Task<persona_institucion> GetEstudiantePerfil(int idInstitucion, int idCarrera)
        {
            var query = from pi in _context.persona_institucion
                        join ei in _context.estudiante_institucion on pi.ID_PERSONA_INSTITUCION equals ei.ID_PERSONA_INSTITUCION
                        join cid in _context.carreras_por_institucion_detalle on ei.ID_CARRERAS_POR_INSTITUCION_DETALLE equals cid.ID_CARRERAS_POR_INSTITUCION_DETALLE
                        join carIn in _context.carreras_por_institucion on cid.ID_CARRERAS_POR_INSTITUCION equals carIn.ID_CARRERAS_POR_INSTITUCION
                        join plan in _context.plan_estudio on carIn.ID_CARRERAS_POR_INSTITUCION equals plan.ID_CARRERAS_POR_INSTITUCION
                        join per in _context.persona on pi.ID_PERSONA equals per.ID_PERSONA
                        where ei.ID_PERSONA_INSTITUCION == idInstitucion
                                && ei.ID_CARRERAS_POR_INSTITUCION_DETALLE.Equals(idCarrera)
                                && ei.ESTADO == 1
                                && ei.ES_ACTIVO
                        select new persona_institucion
                        {
                            ID_PERSONA_INSTITUCION = pi.ID_PERSONA_INSTITUCION,
                            ID_PERSONA = pi.ID_PERSONA,
                            ANIO_INICIO = pi.ANIO_INICIO,
                            ANIO_FIN = pi.ANIO_FIN,
                            ESTADO_CIVIL = pi.ESTADO_CIVIL,
                            PAIS_PERSONA = pi.PAIS_PERSONA,
                            UBIGEO_PERSONA = pi.UBIGEO_PERSONA,
                            DIRECCION_PERSONA = pi.DIRECCION_PERSONA,
                            TELEFONO = pi.TELEFONO,
                            CELULAR = pi.CELULAR,
                            CELULAR2 = pi.CELULAR2,
                            CORREO = pi.CORREO,
                            fechaNacimiento = per.FECHA_NACIMIENTO_PERSONA,
                            codigoEstudiante = per.NUMERO_DOCUMENTO_PERSONA,
                            estudiante_institucion = new List<estudiante_institucion>
                            {
                                new estudiante_institucion
                                {
                                    ID_ESTUDIANTE_INSTITUCION = ei.ID_ESTUDIANTE_INSTITUCION,
                                    ID_CARRERAS_POR_INSTITUCION_DETALLE = ei.ID_CARRERAS_POR_INSTITUCION_DETALLE,
                                    ANIO_EGRESO = ei.ANIO_EGRESO,
                                    ID_TIPO_ESTUDIANTE = ei.ID_TIPO_ESTUDIANTE,
                                    ID_TIPO_DOCUMENTO_APODERADO = ei.ID_TIPO_DOCUMENTO_APODERADO,
                                    NOMBRE_APODERADO = ei.NOMBRE_APODERADO,
                                    APELLIDO_APODERADO = ei.APELLIDO_APODERADO,
                                    ARCHIVO_FOTO = ei.ARCHIVO_FOTO,
                                    ARCHIVO_RUTA = ei.ARCHIVO_RUTA,
                                    ID_INSTITUCION_BASICA = ei.ID_INSTITUCION_BASICA,
                                    ESTADO = ei.ESTADO,
                                    ID_SEMESTRE_ACADEMICO = ei.ID_SEMESTRE_ACADEMICO,
                                    ID_INSTITUCION_BASICANavigation = new institucion_basica
                                    {
                                        ID_TIPO_INSTITUCION_BASICA = ei.ID_INSTITUCION_BASICANavigation.ID_TIPO_INSTITUCION_BASICA,
                                        CODIGO_MODULAR_IE_BASICA = ei.ID_INSTITUCION_BASICANavigation.CODIGO_MODULAR_IE_BASICA,
                                        NOMBRE_IE_BASICA = ei.ID_INSTITUCION_BASICANavigation.NOMBRE_IE_BASICA,
                                        DIRECCION_IE_BASICA = ei.ID_INSTITUCION_BASICANavigation.DIRECCION_IE_BASICA,
                                    },
                                    ID_PERIODOS_LECTIVOS_POR_INSTITUCIONNavigation = new periodos_lectivos_por_institucion
                                    {
                                        ID_PERIODOS_LECTIVOS_POR_INSTITUCION = ei.ID_PERIODOS_LECTIVOS_POR_INSTITUCION,
                                        NOMBRE_PERIODO_LECTIVO_INSTITUCION = ei.ID_PERIODOS_LECTIVOS_POR_INSTITUCIONNavigation.NOMBRE_PERIODO_LECTIVO_INSTITUCION,
                                        ID_PERIODO_LECTIVONavigation = new periodo_lectivo
                                        {
                                            ID_PERIODO_LECTIVO =  ei.ID_PERIODOS_LECTIVOS_POR_INSTITUCIONNavigation.ID_PERIODO_LECTIVO,
                                            CODIGO_PERIODO_LECTIVO =  ei.ID_PERIODOS_LECTIVOS_POR_INSTITUCIONNavigation.ID_PERIODO_LECTIVONavigation.CODIGO_PERIODO_LECTIVO
                                        }
                                    },
                                    ID_TURNOS_POR_INSTITUCIONNavigation = new turnos_por_institucion
                                    {
                                        ID_TURNOS_POR_INSTITUCION = ei.ID_TURNOS_POR_INSTITUCIONNavigation.ID_TURNOS_POR_INSTITUCION,
                                        ID_TURNO_EQUIVALENCIA = ei.ID_TURNOS_POR_INSTITUCIONNavigation.ID_TURNO_EQUIVALENCIA,
                                        ID_TURNO_EQUIVALENCIANavigation = new turno_equivalencia
                                        {
                                            COD_TUR = ei.ID_TURNOS_POR_INSTITUCIONNavigation.ID_TURNO_EQUIVALENCIANavigation.COD_TUR,
                                            ID_TURNO = ei.ID_TURNOS_POR_INSTITUCIONNavigation.ID_TURNO_EQUIVALENCIANavigation.ID_TURNO
                                        }
                                    }
                                }
                            },
                            NombrePlanEstudio = plan.NOMBRE_PLAN_ESTUDIOS,
                            IdCarrera = carIn.ID_CARRERA
                        };

            return await query.FirstOrDefaultAsync();



        }

        public async Task<persona> GetPersonaInstitucionValidate(int tipoDocumento, string nroDocumento, string correo)
        {
            var query = _context.persona
                .Where(p => p.ID_TIPO_DOCUMENTO == tipoDocumento
                && p.NUMERO_DOCUMENTO_PERSONA == nroDocumento
                && p.persona_institucion.FirstOrDefault().CORREO.ToUpper() == correo.ToUpper())
                .Select(p => new persona
                {
                    ID_PERSONA = p.ID_PERSONA,
                    ID_TIPO_DOCUMENTO = p.ID_TIPO_DOCUMENTO,
                    NUMERO_DOCUMENTO_PERSONA = p.NUMERO_DOCUMENTO_PERSONA,
                    APELLIDO_PATERNO_PERSONA = p.APELLIDO_PATERNO_PERSONA,
                    APELLIDO_MATERNO_PERSONA = p.APELLIDO_MATERNO_PERSONA,
                    NOMBRE_PERSONA = p.NOMBRE_PERSONA,
                    persona_institucion = p.persona_institucion
                                        .Select(c => new persona_institucion { ID_PERSONA = p.ID_PERSONA, CORREO = c.CORREO }).ToList()
                });

            return await query.FirstOrDefaultAsync() ?? new persona();
        }



        public async Task<List<persona_institucion>> GetPersonaIntitucionLogin(int idPersona)
        {
            var query = _context.persona_institucion
                            .Where(p => p.ID_PERSONA == idPersona)
                            .Select(p => new persona_institucion
                            {
                                ID_PERSONA_INSTITUCION = p.ID_PERSONA_INSTITUCION,
                                ID_PERSONA = p.ID_PERSONA,
                                ID_INSTITUCION = p.ID_INSTITUCION,

                            });
            return await query.ToListAsync();

        }

        public async Task<List<estudiante_institucion>> GetListEstudianteInstitucion(int idInstitucion)
        {
            var query = _context.estudiante_institucion
                        .Where(p => p.ID_PERSONA_INSTITUCION == idInstitucion)
                        .Select(p => new estudiante_institucion
                        {
                            ID_ESTUDIANTE_INSTITUCION = p.ID_ESTUDIANTE_INSTITUCION,
                            ID_PERSONA_INSTITUCION = p.ID_PERSONA_INSTITUCION,
                            ID_CARRERAS_POR_INSTITUCION_DETALLE = p.ID_CARRERAS_POR_INSTITUCION_DETALLE,
                            ID_PLAN_ESTUDIO = p.ID_PLAN_ESTUDIO,
                            ID_SEMESTRE_ACADEMICO = p.ID_SEMESTRE_ACADEMICO,
                            ID_PERIODOS_LECTIVOS_POR_INSTITUCION = p.ID_PERIODOS_LECTIVOS_POR_INSTITUCION,
                            ARCHIVO_FOTO = p.ARCHIVO_FOTO,
                            ARCHIVO_RUTA = p.ARCHIVO_RUTA,
                            ID_CARRERAS_POR_INSTITUCION_DETALLENavigation = new carreras_por_institucion_detalle
                            {
                                ID_CARRERAS_POR_INSTITUCION_DETALLE = p.ID_CARRERAS_POR_INSTITUCION_DETALLE,
                                ID_CARRERAS_POR_INSTITUCIONNavigation = new carreras_por_institucion
                                {
                                    ID_CARRERA = p.ID_CARRERAS_POR_INSTITUCION_DETALLENavigation.ID_CARRERAS_POR_INSTITUCIONNavigation.ID_CARRERA
                                },
                                ID_SEDE_INSTITUCIONNavigation = new sede_institucion
                                {
                                    ID_SEDE_INSTITUCION = p.ID_CARRERAS_POR_INSTITUCION_DETALLENavigation.ID_SEDE_INSTITUCION
                                },
                                ID_SEDE_INSTITUCION = p.ID_CARRERAS_POR_INSTITUCION_DETALLENavigation.ID_SEDE_INSTITUCION,
                            }
                        });

            return await query.ToListAsync();
        }



        public async Task<estudiante_institucion> GetListEstudianteInstitucion(int idInstitucion, int idEstudiante)
        {
            var query = _context.estudiante_institucion
                        .Where(p => p.ID_PERSONA_INSTITUCION == idInstitucion && p.ID_ESTUDIANTE_INSTITUCION == idEstudiante)
                        .Select(p => new estudiante_institucion
                        {
                            ID_ESTUDIANTE_INSTITUCION = p.ID_ESTUDIANTE_INSTITUCION,
                            ID_PERSONA_INSTITUCION = p.ID_PERSONA_INSTITUCION,
                            ID_CARRERAS_POR_INSTITUCION_DETALLE = p.ID_CARRERAS_POR_INSTITUCION_DETALLE,
                            ID_PLAN_ESTUDIO = p.ID_PLAN_ESTUDIO,
                            ID_SEMESTRE_ACADEMICO = p.ID_SEMESTRE_ACADEMICO,
                            ID_PERIODOS_LECTIVOS_POR_INSTITUCION = p.ID_PERIODOS_LECTIVOS_POR_INSTITUCION,
                            ID_CARRERAS_POR_INSTITUCION_DETALLENavigation = new carreras_por_institucion_detalle
                            {
                                ID_CARRERAS_POR_INSTITUCION_DETALLE = p.ID_CARRERAS_POR_INSTITUCION_DETALLE,
                                ID_CARRERAS_POR_INSTITUCIONNavigation = new carreras_por_institucion
                                {
                                    ID_CARRERA = p.ID_CARRERAS_POR_INSTITUCION_DETALLENavigation.ID_CARRERAS_POR_INSTITUCIONNavigation.ID_CARRERA
                                }
                            }
                        });

            return await query.FirstOrDefaultAsync();
        }



        public async Task<string> GetPeriodoLectivoIngreso(int idPeriodoLectivoPorInstitucion)
        {
            var query = _context.periodos_lectivos_por_institucion
                        .Where(c => c.ID_PERIODOS_LECTIVOS_POR_INSTITUCION == idPeriodoLectivoPorInstitucion)
                        .Select(p => new periodos_lectivos_por_institucion
                        {
                            ID_PERIODO_LECTIVO = p.ID_PERIODO_LECTIVO,
                            ID_PERIODO_LECTIVONavigation = p.ID_PERIODO_LECTIVONavigation,
                        });
            return (await query.FirstOrDefaultAsync()).ID_PERIODO_LECTIVONavigation.CODIGO_PERIODO_LECTIVO.ToString();
        }
    }
}
