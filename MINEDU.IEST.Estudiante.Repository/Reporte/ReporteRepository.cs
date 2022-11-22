using Microsoft.EntityFrameworkCore;
using MINEDU.IEST.Estudiante.Contexto.Data.Estudiante;
using MINEDU.IEST.Estudiante.Entity;

namespace MINEDU.IEST.Estudiante.Repository.Reporte
{
    public class ReporteRepository : IReporteRepository
    {
        private readonly estudianteContext _context;
        public ReporteRepository(estudianteContext context)
        {
            _context = context;
        }
        public async Task<matricula_estudiante> GetReporteFichaById(int idMatricula)
        {
            var query = _context.matricula_estudiante
                            .Where(p => p.ID_MATRICULA_ESTUDIANTE == idMatricula)
                            .Select(p => new matricula_estudiante
                            {
                                ID_MATRICULA_ESTUDIANTE = p.ID_MATRICULA_ESTUDIANTE,
                                ID_ESTUDIANTE_INSTITUCION = p.ID_ESTUDIANTE_INSTITUCION,
                                ESTADO = p.ESTADO,
                                ES_ACTIVO = p.ES_ACTIVO,
                                ID_ESTUDIANTE_INSTITUCIONNavigation = new estudiante_institucion
                                {
                                    ID_ESTUDIANTE_INSTITUCION = p.ID_ESTUDIANTE_INSTITUCIONNavigation.ID_ESTUDIANTE_INSTITUCION,
                                    ID_PERSONA_INSTITUCION = p.ID_ESTUDIANTE_INSTITUCIONNavigation.ID_PERSONA_INSTITUCION,
                                    ID_PERSONA_INSTITUCIONNavigation = new persona_institucion
                                    {

                                        ID_PERSONA_INSTITUCION = p.ID_ESTUDIANTE_INSTITUCIONNavigation.ID_PERSONA_INSTITUCIONNavigation.ID_PERSONA_INSTITUCION,
                                        ID_INSTITUCION = p.ID_ESTUDIANTE_INSTITUCIONNavigation.ID_PERSONA_INSTITUCIONNavigation.ID_INSTITUCION,
                                        ID_PERSONANavigation = new persona
                                        {
                                            ID_PERSONA = p.ID_ESTUDIANTE_INSTITUCIONNavigation.ID_PERSONA_INSTITUCIONNavigation.ID_PERSONANavigation.ID_PERSONA,
                                            APELLIDO_PATERNO_PERSONA = p.ID_ESTUDIANTE_INSTITUCIONNavigation.ID_PERSONA_INSTITUCIONNavigation.ID_PERSONANavigation.APELLIDO_PATERNO_PERSONA,
                                            APELLIDO_MATERNO_PERSONA = p.ID_ESTUDIANTE_INSTITUCIONNavigation.ID_PERSONA_INSTITUCIONNavigation.ID_PERSONANavigation.APELLIDO_MATERNO_PERSONA,
                                            NOMBRE_PERSONA = p.ID_ESTUDIANTE_INSTITUCIONNavigation.ID_PERSONA_INSTITUCIONNavigation.ID_PERSONANavigation.NOMBRE_PERSONA,
                                            NUMERO_DOCUMENTO_PERSONA = p.ID_ESTUDIANTE_INSTITUCIONNavigation.ID_PERSONA_INSTITUCIONNavigation.ID_PERSONANavigation.NUMERO_DOCUMENTO_PERSONA
                                        }
                                    }
                                },
                                programacion_clase_por_matricula_estudiante = p.programacion_clase_por_matricula_estudiante.Select(pr => new programacion_clase_por_matricula_estudiante
                                {
                                    ID_MATRICULA_ESTUDIANTE = p.ID_MATRICULA_ESTUDIANTE,
                                    ID_PROGRAMACION_CLASE = pr.ID_PROGRAMACION_CLASE,
                                    ID_ESTADO_UNIDAD_DIDACTICA = pr.ID_ESTADO_UNIDAD_DIDACTICA,
                                    ID_PROGRAMACION_CLASENavigation = new programacion_clase
                                    {
                                        ID_PROGRAMACION_CLASE = pr.ID_PROGRAMACION_CLASENavigation.ID_PROGRAMACION_CLASE,
                                        ID_PERSONAL_INSTITUCION = pr.ID_PROGRAMACION_CLASENavigation.ID_PERSONAL_INSTITUCION,
                                        unidades_didacticas_por_programacion_clase = pr.ID_PROGRAMACION_CLASENavigation.unidades_didacticas_por_programacion_clase.Select(uprg => new unidades_didacticas_por_programacion_clase
                                        {
                                            ID_UNIDADES_DIDACTICAS_POR_PROGRAMACION_CLASE = uprg.ID_UNIDADES_DIDACTICAS_POR_PROGRAMACION_CLASE,
                                            ID_PROGRAMACION_CLASE = pr.ID_PROGRAMACION_CLASE,
                                            ID_UNIDADES_DIDACTICAS_POR_ENFOQUE = uprg.ID_UNIDADES_DIDACTICAS_POR_ENFOQUENavigation.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE,
                                            ID_UNIDADES_DIDACTICAS_POR_ENFOQUENavigation = new unidades_didacticas_por_enfoque
                                            {
                                                ID_UNIDADES_DIDACTICAS_POR_ENFOQUE = uprg.ID_UNIDADES_DIDACTICAS_POR_ENFOQUENavigation.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE,
                                                ID_TIPO_UNIDAD_DIDACTICA = uprg.ID_UNIDADES_DIDACTICAS_POR_ENFOQUENavigation.ID_TIPO_UNIDAD_DIDACTICA,
                                                ID_UNIDAD_DIDACTICA = uprg.ID_UNIDADES_DIDACTICAS_POR_ENFOQUENavigation.ID_UNIDAD_DIDACTICA,
                                                ID_UNIDAD_DIDACTICANavigation = new unidad_didactica
                                                {
                                                    CODIGO_UNIDAD_DIDACTICA = uprg.ID_UNIDADES_DIDACTICAS_POR_ENFOQUENavigation.ID_UNIDAD_DIDACTICANavigation.CODIGO_UNIDAD_DIDACTICA,
                                                    NOMBRE_UNIDAD_DIDACTICA = uprg.ID_UNIDADES_DIDACTICAS_POR_ENFOQUENavigation.ID_UNIDAD_DIDACTICANavigation.NOMBRE_UNIDAD_DIDACTICA,
                                                    ID_SEMESTRE_ACADEMICO = uprg.ID_UNIDADES_DIDACTICAS_POR_ENFOQUENavigation.ID_UNIDAD_DIDACTICANavigation.ID_SEMESTRE_ACADEMICO,
                                                    DESCRIPCION = uprg.ID_UNIDADES_DIDACTICAS_POR_ENFOQUENavigation.ID_UNIDAD_DIDACTICANavigation.DESCRIPCION,
                                                    HORAS = uprg.ID_UNIDADES_DIDACTICAS_POR_ENFOQUENavigation.ID_UNIDAD_DIDACTICANavigation.HORAS,
                                                    CREDITOS = uprg.ID_UNIDADES_DIDACTICAS_POR_ENFOQUENavigation.ID_UNIDAD_DIDACTICANavigation.CREDITOS
                                                }
                                            }
                                        }).ToList(),
                                        sesion_programacion_clase = pr.ID_PROGRAMACION_CLASENavigation.sesion_programacion_clase.Select(se => new sesion_programacion_clase
                                        {
                                            ID_PROGRAMACION_CLASE = se.ID_PROGRAMACION_CLASE,
                                            ID_AULA = se.ID_AULA,
                                            DIA = se.DIA,
                                            HORA_INICIO = se.HORA_INICIO,
                                            HORA_FIN = se.HORA_FIN,
                                            ID_AULANavigation = new aula
                                            {
                                                NOMBRE_AULA = se.ID_AULANavigation.NOMBRE_AULA,
                                                ID_PISO = se.ID_AULANavigation.ID_PISO,
                                                CATEGORIA_AULA = se.ID_AULANavigation.CATEGORIA_AULA,
                                                UBICACION_AULA = se.ID_AULANavigation.UBICACION_AULA,
                                                ID_SEDE_INSTITUCIONNavigation = new sede_institucion
                                                {
                                                    NOMBRE_SEDE = se.ID_AULANavigation.ID_SEDE_INSTITUCIONNavigation.NOMBRE_SEDE,
                                                    CODIGO_SEDE = se.ID_AULANavigation.ID_SEDE_INSTITUCIONNavigation.CODIGO_SEDE,
                                                    DIRECCION_SEDE = se.ID_AULANavigation.ID_SEDE_INSTITUCIONNavigation.DIRECCION_SEDE
                                                }
                                            }
                                        }).ToList()
                                    }
                                }).ToList()
                            });

            return await query.FirstOrDefaultAsync();
        }


        public async Task<estudiante_institucion> GetReporteCabeceraByIdEstudianteInstitucion(int idEstudiante)
        {
            var query = _context.estudiante_institucion
                            .Where(p => p.ID_ESTUDIANTE_INSTITUCION == idEstudiante)
                            .Select(p => new estudiante_institucion
                            {
                                ID_ESTUDIANTE_INSTITUCION = p.ID_ESTUDIANTE_INSTITUCION,
                                ID_PERSONA_INSTITUCION = p.ID_PERSONA_INSTITUCION,
                                ID_PERSONA_INSTITUCIONNavigation = new persona_institucion
                                {

                                    ID_PERSONA_INSTITUCION = p.ID_PERSONA_INSTITUCIONNavigation.ID_PERSONA_INSTITUCION,
                                    ID_INSTITUCION = p.ID_PERSONA_INSTITUCIONNavigation.ID_INSTITUCION,
                                    ID_PERSONANavigation = new persona
                                    {
                                        ID_PERSONA = p.ID_PERSONA_INSTITUCIONNavigation.ID_PERSONANavigation.ID_PERSONA,
                                        APELLIDO_PATERNO_PERSONA = p.ID_PERSONA_INSTITUCIONNavigation.ID_PERSONANavigation.APELLIDO_PATERNO_PERSONA,
                                        APELLIDO_MATERNO_PERSONA = p.ID_PERSONA_INSTITUCIONNavigation.ID_PERSONANavigation.APELLIDO_MATERNO_PERSONA,
                                        NOMBRE_PERSONA = p.ID_PERSONA_INSTITUCIONNavigation.ID_PERSONANavigation.NOMBRE_PERSONA,
                                        NUMERO_DOCUMENTO_PERSONA = p.ID_PERSONA_INSTITUCIONNavigation.ID_PERSONANavigation.NUMERO_DOCUMENTO_PERSONA
                                    }
                                }
                            });

            return await query.FirstOrDefaultAsync();
        }

    }
}
