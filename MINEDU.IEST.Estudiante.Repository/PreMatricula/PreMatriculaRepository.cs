using Microsoft.EntityFrameworkCore;
using MINEDU.IEST.Estudiante.Contexto.Data.Estudiante;
using MINEDU.IEST.Estudiante.Entity;
using MINEDU.IEST.Estudiante.Repository.Base;

namespace MINEDU.IEST.Estudiante.Repository.PreMatricula
{
    public class PreMatriculaRepository : GenericRepository<matricula_estudiante>, IPreMatriculaRepository
    {
        private readonly estudianteContext _context;

        public PreMatriculaRepository(estudianteContext context) : base(context)
        {
            this._context = context;
        }

        public async Task<programacion_clase> GetPeriodoAcademicoForMatricula(int idInstitucion)
        {
            var query = _context.programacion_clase
                        .Where(p => p.ESTADO == 1
                        && p.ID_PERIODO_ACADEMICONavigation.ID_PERIODOS_LECTIVOS_POR_INSTITUCIONNavigation.ID_INSTITUCION == idInstitucion)
                        .Select(p => new programacion_clase
                        {
                            ID_PERIODO_ACADEMICO = p.ID_PERIODO_ACADEMICO,
                            ESTADO = p.ESTADO

                        }).Distinct();
            var response = await query.FirstOrDefaultAsync() ?? new programacion_clase();
            return response;

        }


        public async Task<programacion_matricula> GetProgramacionMatriculaByPeriodo(int ID_PERIODOS_LECTIVOS_POR_INSTITUCION)
        {

            var query = _context.programacion_matricula
                        .Where(p => p.ID_PERIODOS_LECTIVOS_POR_INSTITUCION == ID_PERIODOS_LECTIVOS_POR_INSTITUCION
                            && p.FECHA_INICIO.Value.Date <= DateTime.Now.Date
                            && p.FECHA_FIN.Value.Date >= DateTime.Now.Date)
                        .Select(p => new programacion_matricula
                        {
                            ID_PROGRAMACION_MATRICULA = p.ID_PROGRAMACION_MATRICULA,
                            ID_PERIODOS_LECTIVOS_POR_INSTITUCION = p.ID_PERIODOS_LECTIVOS_POR_INSTITUCION,
                            ID_TIPO_MATRICULA = p.ID_TIPO_MATRICULA,
                            FECHA_FIN = p.FECHA_FIN,
                            FECHA_INICIO = p.FECHA_INICIO,
                            ESTADO = p.ESTADO,
                            ES_ACTIVO = p.ES_ACTIVO,
                            CERRADO = p.CERRADO
                        });
            return await query.FirstOrDefaultAsync();
        }


        public async Task<programacion_clase> GetPeriodoLectivoByIdInstituto(int idInstituto)
        {
            var query = _context.programacion_clase
                        .Where(p => p.ID_PERIODO_ACADEMICONavigation.ID_PERIODOS_LECTIVOS_POR_INSTITUCIONNavigation.ID_INSTITUCION == idInstituto
                        && p.ESTADO == 1 && p.ES_ACTIVO)
                        .Select(p => new programacion_clase
                        {
                            ID_PERIODO_ACADEMICO = p.ID_PERIODO_ACADEMICO,
                            ID_PERIODO_ACADEMICONavigation = new periodo_academico
                            {
                                ID_PERIODO_ACADEMICO = p.ID_PERIODO_ACADEMICONavigation.ID_PERIODO_ACADEMICO,
                                ESTADO = p.ESTADO,
                                ID_PERIODOS_LECTIVOS_POR_INSTITUCION = p.ID_PERIODO_ACADEMICONavigation.ID_PERIODOS_LECTIVOS_POR_INSTITUCION,
                                ID_PERIODOS_LECTIVOS_POR_INSTITUCIONNavigation = new periodos_lectivos_por_institucion
                                {
                                    ID_PERIODOS_LECTIVOS_POR_INSTITUCION = p.ID_PERIODO_ACADEMICONavigation.ID_PERIODOS_LECTIVOS_POR_INSTITUCION,
                                    ID_PERIODO_LECTIVO = p.ID_PERIODO_ACADEMICONavigation.ID_PERIODOS_LECTIVOS_POR_INSTITUCIONNavigation.ID_PERIODO_LECTIVO,
                                    ID_PERIODO_LECTIVONavigation = new periodo_lectivo
                                    {
                                        CODIGO_PERIODO_LECTIVO = p.ID_PERIODO_ACADEMICONavigation.ID_PERIODOS_LECTIVOS_POR_INSTITUCIONNavigation.ID_PERIODO_LECTIVONavigation.CODIGO_PERIODO_LECTIVO,
                                    }
                                }
                            }
                        });
            var result = await query.FirstOrDefaultAsync() ?? new programacion_clase
            {
                ID_PERIODO_ACADEMICONavigation = new periodo_academico { ID_PERIODOS_LECTIVOS_POR_INSTITUCIONNavigation = new periodos_lectivos_por_institucion { ID_PERIODO_LECTIVONavigation = new periodo_lectivo() } }
            };

            return result;
        }

    }
}
