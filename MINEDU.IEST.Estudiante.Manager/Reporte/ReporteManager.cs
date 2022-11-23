using AutoMapper;
using iText.IO.Font.Constants;
using iText.IO.Image;
using iText.Kernel.Colors;
using iText.Kernel.Font;
using iText.Kernel.Geom;
using iText.Kernel.Pdf;
using iText.Layout;
using iText.Layout.Element;
using iText.Layout.Properties;
using MINEDU.IEST.Estudiante.Inf_Utils.Dtos;
using MINEDU.IEST.Estudiante.Inf_Utils.Enumerados;
using MINEDU.IEST.Estudiante.Inf_Utils.Helpers.FileManager;
using MINEDU.IEST.Estudiante.Manager.Maestra;
using MINEDU.IEST.Estudiante.Manager.StoreProcedure;
using MINEDU.IEST.Estudiante.ManagerDto.Auxiliar;
using MINEDU.IEST.Estudiante.ManagerDto.Maestra;
using MINEDU.IEST.Estudiante.ManagerDto.Reporte;
using MINEDU.IEST.Estudiante.ManagerDto.Reporte.FichaMatricula;
using MINEDU.IEST.Estudiante.ManagerDto.SecurityApi;
using MINEDU.IEST.Estudiante.ManagerDto.StoreProcedure.Reportes;
using MINEDU.IEST.Estudiante.Repository.UnitOfWork;

namespace MINEDU.IEST.Estudiante.Manager.Reporte
{
    public class ReporteManager : IReporteManager
    {
        private readonly IMapper _mapper;
        private readonly ReporteUnitOfWork _reporteUnitOfWork;
        private readonly IStorageManager _storageManager;
        private readonly InformacionPersonaUnitOfWork _personalUnitOfWork;
        private readonly AuxiliarUnitOfWork _auxiliarUnitOfWork;
        private readonly DigePadronUnitOfWork _digePadronUnitOfWork;
        private readonly IMaestraManager _maestraManager;
        private readonly IStoreProcedureManager _storeProcedureManager;
        private readonly ResourceDto _resourceDto;

        public ReporteManager(IMapper mapper, ReporteUnitOfWork reporteUnitOfWork, IStorageManager storageManager, InformacionPersonaUnitOfWork personalUnitOfWork, AuxiliarUnitOfWork auxiliarUnitOfWork, DigePadronUnitOfWork digePadronUnitOfWork, IMaestraManager maestraManager, IStoreProcedureManager storeProcedureManager, ResourceDto resourceDto)
        {
            this._mapper = mapper;
            this._reporteUnitOfWork = reporteUnitOfWork;
            this._storageManager = storageManager;
            _personalUnitOfWork = personalUnitOfWork;
            _auxiliarUnitOfWork = auxiliarUnitOfWork;
            _digePadronUnitOfWork = digePadronUnitOfWork;
            this._maestraManager = maestraManager;
            this._storeProcedureManager = storeProcedureManager;
            this._resourceDto = resourceDto;
        }

        public async Task<GetPdfDto> GetRepoteFichaByIdMatricula(int idMatricula)
        {
            try
            {
                var query = await _reporteUnitOfWork._reporteRepository.GetReporteFichaById(idMatricula);
                var response = _mapper.Map<GetFichaMatriculaEstudianteDto>(query);
                var path = $"{_resourceDto.Documents}/pdf/FichaMatricula.pdf";
                var pathLogo = $"{_resourceDto.Images}/logo-minedu.png";

                var idInstitucion = query.ID_ESTUDIANTE_INSTITUCIONNavigation.ID_PERSONA_INSTITUCIONNavigation.ID_INSTITUCION;

                var resul = await _personalUnitOfWork._personaRepository.GetListEstudianteInstitucion(query.ID_ESTUDIANTE_INSTITUCIONNavigation.ID_PERSONA_INSTITUCION, query.ID_ESTUDIANTE_INSTITUCION);

                response.carrera = _mapper.Map<GetEstudianteInsitucionApiDto>(resul);

                response.instituto = _mapper.Map<GetAuxInstitucionDto>(await _auxiliarUnitOfWork._auxiliarRepository.GetInstitucion(idInstitucion));

                response.carrera.NombreCarrera = _digePadronUnitOfWork._padronCarrera.GetById(response.carrera.ID_CARRERA).NombreCarrera;

                var ciclos = await GetTipoSemestreAcademico();

                response.DetalleMatriculaCursos.ForEach(p =>
                {
                    var uni = p.programacionClase.listUnidadDidacticasPC.FirstOrDefault().unidadEnfoque.unidadDidactica;
                    uni.texto_SEMESTRE_ACADEMICO = ciclos.FirstOrDefault(s => s.ID_ENUMERADO == uni.ID_SEMESTRE_ACADEMICO).VALOR_ENUMERADO;
                    var profe = _personalUnitOfWork._personaRepository.GetById(p.programacionClase.ID_PERSONAL_INSTITUCION);
                    p.programacionClase.NombreProfesor = $"{profe.APELLIDO_PATERNO_PERSONA} {profe.APELLIDO_MATERNO_PERSONA}, {profe.NOMBRE_PERSONA}";

                });


                await GetPdfFicha(path, pathLogo, response);
                MemoryStream _output = new MemoryStream(System.IO.File.ReadAllBytes(path));
                var pdf64 = _storageManager.GetBase64(_output);
                GetPdfDto data = new GetPdfDto
                {
                    base64 = pdf64
                };
                return data;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public async Task<GetPdfDto> GetRepoteBoletaNotasByEstudiante(int idMatricula, int idPeriodoLectivoByInstitucion)
        {
            try
            {
                GetPdfDto data = new GetPdfDto();

                var query = await _storeProcedureManager.GetBoletasNotas(idMatricula, idPeriodoLectivoByInstitucion);
                if (query.Count > 0)
                {
                    var response = _mapper.Map<List<GetBoletaNotasByMatriculaDto>>(query);
                    var path = $"{_resourceDto.Documents}/pdf/BoletaNotasByMatricula.pdf";
                    var pathLogo = $"{_resourceDto.Images}/logo-minedu.png";


                    await GetPdfBoletaNotasByMatricula(path, pathLogo, response);
                    MemoryStream _output = new MemoryStream(System.IO.File.ReadAllBytes(path));
                    var pdf64 = _storageManager.GetBase64(_output);
                    data.base64 = pdf64;
                }
                else
                {
                    data.base64 = "";
                }

                return data;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public async Task<GetPdfDto> GetReporteHistorialAcademicoByEstudiante(int ID_INSTITUCION, int ID_TIPO_DOCUMENTO, string ID_NUMERO_DOCUMENTO, int ID_SEDE_INSTITUCION, int ID_CARRERA, int ID_PLAN_ESTUDIO, int ID_PERIODO_LECTIVO_INSTITUCION)
        {
            try
            {

                //#region Cabecera

                //var query = await _reporteUnitOfWork._reporteRepository.GetReporteCabeceraByIdEstudianteInstitucion(idEstudiante);

                //var response = _mapper.Map<GetFichaEstudiante_institucionHistorialDto>(query);

                //var idInstitucion = query.ID_PERSONA_INSTITUCIONNavigation.ID_INSTITUCION;

                //var resul = await _personalUnitOfWork._personaRepository.GetListEstudianteInstitucion(query.ID_PERSONA_INSTITUCION, query.ID_ESTUDIANTE_INSTITUCION);

                //response.carrera = _mapper.Map<GetEstudianteInsitucionApiDto>(resul);

                //response.instituto = _mapper.Map<GetAuxInstitucionDto>(await _auxiliarUnitOfWork._auxiliarRepository.GetInstitucion(idInstitucion));

                //response.carrera.NombreCarrera = _digePadronUnitOfWork._padronCarrera.GetById(response.carrera.ID_CARRERA).NombreCarrera;

                //#endregion

                var responseMain = new GetHistorialCabecera();

                var listHistorial = await _storeProcedureManager.GetHistorialAcademico(ID_INSTITUCION, ID_TIPO_DOCUMENTO, ID_NUMERO_DOCUMENTO, ID_SEDE_INSTITUCION, ID_CARRERA, ID_PLAN_ESTUDIO, ID_PERIODO_LECTIVO_INSTITUCION);
                var mapListaHistorial = _mapper.Map<List<GetHistorialAcademicoDto>>(listHistorial);
                var path = $"{_resourceDto.Documents}/pdf/HistorialAcademicoByEstudiante.pdf";
                var pathLogo = $"{_resourceDto.Images}/logo-minedu.png";

                responseMain.DetalleSpHistorial = mapListaHistorial;

                await GetPdfHistorial(path, pathLogo, responseMain);
                MemoryStream _output = new MemoryStream(System.IO.File.ReadAllBytes(path));
                var pdf64 = _storageManager.GetBase64(_output);
                GetPdfDto data = new GetPdfDto
                {
                    base64 = pdf64
                };
                return data;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private async Task GetPdfFicha(string path, string pathLogo, GetFichaMatriculaEstudianteDto data)
        {
            PdfFont fontSubTitle = PdfFontFactory.CreateFont(StandardFonts.HELVETICA);
            PdfFont fontTitle = PdfFontFactory.CreateFont(StandardFonts.HELVETICA);
            PdfFont fontHeaderTable = PdfFontFactory.CreateFont(StandardFonts.HELVETICA);
            PdfFont fontTable = PdfFontFactory.CreateFont(StandardFonts.HELVETICA);
            PdfFont fontTexto = PdfFontFactory.CreateFont(StandardFonts.HELVETICA);
            PdfFont fontMR = PdfFontFactory.CreateFont(StandardFonts.HELVETICA);
            PdfFont fontFirma = PdfFontFactory.CreateFont(StandardFonts.HELVETICA);


            PdfWriter writer = null;

            var cellColor = new DeviceRgb(191, 196, 205);


            using (writer = new PdfWriter(path))
            {
                PdfDocument pdf = new PdfDocument(writer);
                Document doc = new Document(pdf, PageSize.A4, false);

                doc.SetMargins(20, 10, 20, 10);

                #region Logo

                iText.Layout.Element.Image image = new iText.Layout.Element.Image(ImageDataFactory.Create(pathLogo));
                image.GetXObject().GetPdfObject().SetCompressionLevel(CompressionConstants.BEST_COMPRESSION);
                image.ScaleAbsolute(200, 40);
                image.SetFixedPosition(0, 800);

                doc.Add(image);
                doc.Add(new Paragraph(" "));
                doc.Add(new Paragraph(" "));
                doc.Add(new Paragraph(" "));
                #endregion

                #region Titulo de Pagina
                Paragraph title = new Paragraph();
                title.SetFont(fontTitle).SetFontSize(12f).SetFontColor(ColorConstants.BLACK)
                    .SetTextAlignment(iText.Layout.Properties.TextAlignment.CENTER).SetUnderline()
                    .Add("FICHA DE MATRICULA DEL ESTUDIANTE");

                doc.Add(title);
                string mensaje = string.Empty;
                switch (data.ESTADO)
                {
                    case 3: mensaje = "PENDIENTE DE APROBACIÓN"; break;
                    case 1: mensaje = "ACTIVO"; break;
                    case 2: mensaje = "RECHAZADO"; break;
                    default:
                        break;
                }
                Paragraph titleSituacion = new Paragraph();
                titleSituacion.SetFont(fontTitle).SetFontSize(9f).SetFontColor(ColorConstants.BLACK)
                    .SetTextAlignment(iText.Layout.Properties.TextAlignment.CENTER)
                    .Add("[ SITUACION: " + mensaje + " ]");

                doc.Add(titleSituacion);

                doc.Add(new Paragraph(" "));

                #endregion

                #region Cabecera

                float setHeight = 13f;
                float setFontSize = 9f;


                #region Datos de la institucion
                Paragraph subtitleInstitucion = new Paragraph();
                subtitleInstitucion.SetFont(fontSubTitle).SetFontSize(10f).SetFontColor(ColorConstants.BLACK)
                    .SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT).SetUnderline()
                    .Add("I. DATOS DEL INSTITUTO DE EDUCACIÓN SUPERIOR TECNOLÓGICO");
                doc.Add(subtitleInstitucion);

                // Agregamos un parrafo vacio como separacion.
                doc.Add(new Paragraph(" "));

                // Empezamos a crear la tabla, definimos una tabla de 2 columnas
                Table tableInstituto = new Table(iText.Layout.Properties.UnitValue.CreatePercentArray(new float[] { 8, 20, 8, 20 })).UseAllAvailableWidth();

                // Esta es la primera fila
                tableInstituto.AddCell(new Cell().SetBackgroundColor(cellColor).SetHeight(setHeight).SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT).Add(new Paragraph("Nombre del IEST:").SetFont(fontHeaderTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));
                tableInstituto.AddCell(new Cell().SetHeight(setHeight).SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT)
                    .Add(new Paragraph($"{data.instituto.NombreInstitucion}").SetFont(fontTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));


                tableInstituto.AddCell(new Cell().SetBackgroundColor(cellColor).SetHeight(setHeight).SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT).Add(new Paragraph("Carrera:").SetFont(fontHeaderTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));
                tableInstituto.AddCell(new Cell().SetHeight(setHeight).SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT)
                    .Add(new Paragraph($"{data.carrera.NombreCarrera}").SetFont(fontTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));

                tableInstituto.AddCell(new Cell().SetBackgroundColor(cellColor).SetHeight(setHeight).SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT).Add(new Paragraph("Plan de Estudios:").SetFont(fontHeaderTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));
                tableInstituto.AddCell(new Cell().SetHeight(setHeight).SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT)
                    .Add(new Paragraph($"{data.instituto.NombreInstitucion}").SetFont(fontTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));


                tableInstituto.AddCell(new Cell().SetBackgroundColor(cellColor).SetHeight(setHeight).SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT).Add(new Paragraph("Tipo:").SetFont(fontHeaderTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));
                tableInstituto.AddCell(new Cell().SetHeight(setHeight).SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT)
                    .Add(new Paragraph($"{data.instituto.TipoInstitucionNombre}").SetFont(fontTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));


                // Agregamos la tabla al documento
                doc.Add(tableInstituto);
                doc.Add(new Paragraph(" "));

                #endregion

                #region datos del estudiante
                Paragraph subtitle = new Paragraph();
                subtitle.SetFont(fontSubTitle).SetFontSize(10f).SetFontColor(ColorConstants.BLACK)
                    .SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT).SetUnderline()
                    .Add("II. INFORMACIÓN DEL ESTUDIANTE");
                doc.Add(subtitle);

                // Agregamos un parrafo vacio como separacion.
                doc.Add(new Paragraph(" "));

                // Empezamos a crear la tabla, definimos una tabla de 2 columnas
                Table table = new Table(iText.Layout.Properties.UnitValue.CreatePercentArray(new float[] { 10, 20, 10, 20 })).UseAllAvailableWidth();

                // Esta es la primera fila
                table.AddCell(new Cell().SetBackgroundColor(cellColor).SetHeight(setHeight).SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT).Add(new Paragraph("Apellidos y Nombres:").SetFont(fontHeaderTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));
                table.AddCell(new Cell().SetHeight(setHeight).SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT)
                    .Add(new Paragraph($"{data.estudianteInstitucion.personaInstitucion.persona.fullName}").SetFont(fontTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));

                // Esta es la segunda fila .....
                table.AddCell(new Cell().SetBackgroundColor(cellColor).SetHeight(setHeight).SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT).Add(new Paragraph("Nro Doc:").SetFont(fontHeaderTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));
                table.AddCell(new Cell().SetHeight(setHeight).SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT)
                    .Add(new Paragraph($"{data.estudianteInstitucion.personaInstitucion.persona.NUMERO_DOCUMENTO_PERSONA}").SetFont(fontTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));


                // Agregamos la tabla al documento
                doc.Add(table);
                doc.Add(new Paragraph(" "));
                #endregion

                #endregion

                #region Detalle

                Table tableHogar = new Table(UnitValue.CreatePercentArray(new float[] { 1, 10, 5, 1, 1, 10, 4 })).UseAllAvailableWidth().SetVerticalBorderSpacing(5).SetHorizontalBorderSpacing(5);//.SetWidth(iText.Layout.Properties.UnitValue.CreatePercentValue(100));

                tableHogar.AddHeaderCell(new Cell().SetBackgroundColor(cellColor).SetMinHeight(20).SetTextAlignment(TextAlignment.CENTER).Add(new Paragraph("Codigo").SetFont(fontHeaderTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));
                tableHogar.AddHeaderCell(new Cell().SetBackgroundColor(cellColor).SetMinHeight(20).SetTextAlignment(TextAlignment.CENTER).Add(new Paragraph("Curso").SetFont(fontHeaderTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));
                tableHogar.AddHeaderCell(new Cell().SetBackgroundColor(cellColor).SetMinHeight(20).SetTextAlignment(TextAlignment.CENTER).Add(new Paragraph("Aula").SetFont(fontHeaderTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));
                tableHogar.AddHeaderCell(new Cell().SetBackgroundColor(cellColor).SetMinHeight(20).SetTextAlignment(TextAlignment.CENTER).Add(new Paragraph("Cr.").SetFont(fontHeaderTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));
                tableHogar.AddHeaderCell(new Cell().SetBackgroundColor(cellColor).SetMinHeight(20).SetTextAlignment(TextAlignment.CENTER).Add(new Paragraph("Ciclo").SetFont(fontHeaderTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));
                tableHogar.AddHeaderCell(new Cell().SetBackgroundColor(cellColor).SetMinHeight(20).SetTextAlignment(TextAlignment.CENTER).Add(new Paragraph("Docente").SetFont(fontHeaderTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));
                tableHogar.AddHeaderCell(new Cell().SetBackgroundColor(cellColor).SetMinHeight(20).SetTextAlignment(TextAlignment.CENTER).Add(new Paragraph("Horario").SetFont(fontHeaderTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));

                //for....

                foreach (var item in data.DetalleMatriculaCursos)
                {
                    var uni = item.programacionClase.listUnidadDidacticasPC.FirstOrDefault().unidadEnfoque.unidadDidactica;
                    var sesion = item.programacionClase.sesion_programacion_clase;


                    tableHogar.AddCell(new Cell().SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.CENTER).SetVerticalAlignment(VerticalAlignment.MIDDLE)
                         .Add(new Paragraph(uni.CODIGO_UNIDAD_DIDACTICA).SetFont(fontTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));

                    tableHogar.AddCell(new Cell().SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.CENTER).SetVerticalAlignment(VerticalAlignment.MIDDLE)
                         .Add(new Paragraph(uni.NOMBRE_UNIDAD_DIDACTICA).SetFont(fontTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));

                    tableHogar.AddCell(new Cell().SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.CENTER).SetVerticalAlignment(VerticalAlignment.MIDDLE)
                         .Add(new Paragraph(string.Join("-", sesion.Select(p => p.Aula.NOMBRE_AULA))).SetFont(fontTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));

                    tableHogar.AddCell(new Cell().SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.CENTER).SetVerticalAlignment(VerticalAlignment.MIDDLE)
                         .Add(new Paragraph(uni.CREDITOS.ToString()).SetFont(fontTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));

                    tableHogar.AddCell(new Cell().SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.CENTER).SetVerticalAlignment(VerticalAlignment.MIDDLE)
                         .Add(new Paragraph(uni.texto_SEMESTRE_ACADEMICO).SetFont(fontTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));

                    tableHogar.AddCell(new Cell().SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.CENTER).SetVerticalAlignment(VerticalAlignment.MIDDLE)
                         .Add(new Paragraph(item.programacionClase.NombreProfesor).SetFont(fontTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));

                    tableHogar.AddCell(new Cell().SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.CENTER).SetVerticalAlignment(VerticalAlignment.MIDDLE)
                         .Add(new Paragraph(string.Join("/", sesion.Select(p => $"{p.HORA_INICIO}-{p.HORA_FIN}"))).SetFont(fontTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));
                }

                doc.Add(tableHogar);

                doc.Add(new Paragraph(" "));

                #endregion

                #region Numeración de Página
                int numberOfPages = pdf.GetNumberOfPages();
                for (int i = 1; i <= numberOfPages; i++)
                {
                    doc.ShowTextAligned(new Paragraph($"Pag: {i} / {numberOfPages}"),
                        580, 840, i, TextAlignment.RIGHT, VerticalAlignment.TOP, 0).SetFontSize(8f);

                    doc.ShowTextAligned(new Paragraph($"Fecha y Hora de Emisión: {DateTime.Now.ToString("dd/MM/yyyy hh:mm tt")}"),
                       565, 828, i, TextAlignment.RIGHT, VerticalAlignment.TOP, 0).SetFontSize(8f);

                }


                #endregion

                // Ceramos el documento
                doc.Close();

            }
        }

        private async Task GetPdfBoletaNotasByMatricula(string path, string pathLogo, List<GetBoletaNotasByMatriculaDto> data)
        {
            PdfFont fontSubTitle = PdfFontFactory.CreateFont(StandardFonts.HELVETICA);
            PdfFont fontTitle = PdfFontFactory.CreateFont(StandardFonts.HELVETICA);
            PdfFont fontHeaderTable = PdfFontFactory.CreateFont(StandardFonts.HELVETICA);
            PdfFont fontTable = PdfFontFactory.CreateFont(StandardFonts.HELVETICA);
            PdfFont fontTexto = PdfFontFactory.CreateFont(StandardFonts.HELVETICA);
            PdfFont fontMR = PdfFontFactory.CreateFont(StandardFonts.HELVETICA);
            PdfFont fontFirma = PdfFontFactory.CreateFont(StandardFonts.HELVETICA);


            PdfWriter writer = null;

            var cellColor = new DeviceRgb(191, 196, 205);


            using (writer = new PdfWriter(path))
            {
                PdfDocument pdf = new PdfDocument(writer);
                Document doc = new Document(pdf, PageSize.A4, false);

                doc.SetMargins(40, 40, 40, 40);

                #region Logo

                iText.Layout.Element.Image image = new iText.Layout.Element.Image(ImageDataFactory.Create(pathLogo));
                image.GetXObject().GetPdfObject().SetCompressionLevel(CompressionConstants.BEST_COMPRESSION);
                image.ScaleAbsolute(200, 40);
                image.SetFixedPosition(0, 800);

                doc.Add(image);
                doc.Add(new Paragraph(" "));
                doc.Add(new Paragraph(" "));
                doc.Add(new Paragraph(" "));
                #endregion

                #region Titulo de Pagina
                Paragraph title = new Paragraph();
                title.SetFont(fontTitle).SetFontSize(12f).SetFontColor(ColorConstants.BLACK)
                    .SetTextAlignment(iText.Layout.Properties.TextAlignment.CENTER).SetUnderline()
                    .Add("FICHA DE MATRICULA DEL ESTUDIANTE");

                doc.Add(title);

                doc.Add(new Paragraph(" "));

                #endregion

                #region Cabecera

                float setHeight = 13f;
                float setFontSize = 9f;


                #region Datos de la institucion
                var objInstituto = data.FirstOrDefault();

                Paragraph subtitleInstitucion = new Paragraph();
                subtitleInstitucion.SetFont(fontSubTitle).SetFontSize(10f).SetFontColor(ColorConstants.BLACK)
                    .SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT).SetUnderline()
                    .Add("I. DATOS DEL INSTITUTO DE EDUCACIÓN SUPERIOR TECNOLÓGICO");
                doc.Add(subtitleInstitucion);

                // Agregamos un parrafo vacio como separacion.
                doc.Add(new Paragraph(" "));

                // Empezamos a crear la tabla, definimos una tabla de 2 columnas
                Table tableInstituto = new Table(iText.Layout.Properties.UnitValue.CreatePercentArray(new float[] { 8.5f, 20, 8.5f, 20 })).UseAllAvailableWidth();

                // Esta es la primera fila
                tableInstituto.AddCell(new Cell().SetBackgroundColor(cellColor).SetHeight(setHeight).SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT).Add(new Paragraph("Nombre del IEST:").SetFont(fontHeaderTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));
                tableInstituto.AddCell(new Cell().SetHeight(setHeight).SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT)
                    .Add(new Paragraph($"{objInstituto.NOMBRE_INSTITUCION}").SetFont(fontTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));


                tableInstituto.AddCell(new Cell().SetBackgroundColor(cellColor).SetHeight(setHeight).SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT).Add(new Paragraph("Carrera:").SetFont(fontHeaderTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));
                tableInstituto.AddCell(new Cell().SetHeight(setHeight).SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT)
                    .Add(new Paragraph($"{objInstituto.NOMBRE_CARRERA}").SetFont(fontTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));

                tableInstituto.AddCell(new Cell().SetBackgroundColor(cellColor).SetHeight(setHeight).SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT).Add(new Paragraph("Plan de Estudios:").SetFont(fontHeaderTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));
                tableInstituto.AddCell(new Cell().SetHeight(setHeight).SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT)
                    .Add(new Paragraph($"{objInstituto.NOMBRE_PLAN_ESTUDIOS}").SetFont(fontTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));


                tableInstituto.AddCell(new Cell().SetBackgroundColor(cellColor).SetHeight(setHeight).SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT).Add(new Paragraph("Tipo:").SetFont(fontHeaderTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));
                tableInstituto.AddCell(new Cell().SetHeight(setHeight).SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT)
                    .Add(new Paragraph($"{objInstituto.TIPO_GESTION_NOMBRE}").SetFont(fontTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));


                // Agregamos la tabla al documento
                doc.Add(tableInstituto);
                doc.Add(new Paragraph(" "));

                #endregion

                #region datos del estudiante

                var objEstudiante = data.FirstOrDefault();
                Paragraph subtitle = new Paragraph();
                subtitle.SetFont(fontSubTitle).SetFontSize(10f).SetFontColor(ColorConstants.BLACK)
                    .SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT).SetUnderline()
                    .Add("II. INFORMACIÓN DEL ESTUDIANTE");
                doc.Add(subtitle);

                // Agregamos un parrafo vacio como separacion.
                doc.Add(new Paragraph(" "));

                // Empezamos a crear la tabla, definimos una tabla de 2 columnas
                Table table = new Table(iText.Layout.Properties.UnitValue.CreatePercentArray(new float[] { 10, 20, 10, 10 })).UseAllAvailableWidth();

                // Esta es la primera fila
                table.AddCell(new Cell().SetBackgroundColor(cellColor).SetHeight(setHeight).SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT).Add(new Paragraph("Apellidos y Nombres:").SetFont(fontHeaderTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));
                table.AddCell(new Cell().SetHeight(setHeight).SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT)
                    .Add(new Paragraph($"{objEstudiante.ESTUDIANTE}").SetFont(fontTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));

                // Esta es la segunda fila .....
                table.AddCell(new Cell().SetBackgroundColor(cellColor).SetHeight(setHeight).SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT).Add(new Paragraph("Nro Doc:").SetFont(fontHeaderTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));
                table.AddCell(new Cell().SetHeight(setHeight).SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT)
                    .Add(new Paragraph($"{objEstudiante.NUMERO_DOCUMENTO_PERSONA}").SetFont(fontTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));


                // Agregamos la tabla al documento
                doc.Add(table);
                doc.Add(new Paragraph(" "));
                #endregion

                #endregion

                #region Detalle

                Table tableHogar = new Table(UnitValue.CreatePercentArray(new float[] { 2, 15, 5, 5 })).UseAllAvailableWidth().SetVerticalBorderSpacing(5).SetHorizontalBorderSpacing(5);//.SetWidth(iText.Layout.Properties.UnitValue.CreatePercentValue(100));

                tableHogar.AddHeaderCell(new Cell().SetBackgroundColor(cellColor).SetMinHeight(20).SetTextAlignment(TextAlignment.CENTER).Add(new Paragraph("Codigo").SetFont(fontHeaderTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));
                tableHogar.AddHeaderCell(new Cell().SetBackgroundColor(cellColor).SetMinHeight(20).SetTextAlignment(TextAlignment.CENTER).Add(new Paragraph("Curso").SetFont(fontHeaderTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));
                tableHogar.AddHeaderCell(new Cell().SetBackgroundColor(cellColor).SetMinHeight(20).SetTextAlignment(TextAlignment.CENTER).Add(new Paragraph("Ciclo").SetFont(fontHeaderTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));
                tableHogar.AddHeaderCell(new Cell().SetBackgroundColor(cellColor).SetMinHeight(20).SetTextAlignment(TextAlignment.CENTER).Add(new Paragraph("Nota").SetFont(fontHeaderTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));

                //for....

                foreach (var item in data)
                {
                    tableHogar.AddCell(new Cell().SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.CENTER).SetVerticalAlignment(VerticalAlignment.MIDDLE)
                         .Add(new Paragraph(item.CODIGO_MODULAR).SetFont(fontTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));

                    tableHogar.AddCell(new Cell().SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.CENTER).SetVerticalAlignment(VerticalAlignment.MIDDLE)
                         .Add(new Paragraph(item.NOMBRE_UNIDAD_DIDACTICA).SetFont(fontTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));

                    tableHogar.AddCell(new Cell().SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.CENTER).SetVerticalAlignment(VerticalAlignment.MIDDLE)
                        .Add(new Paragraph(item.SEMESTRE_ACADEMICO_UNIDAD_DIDACTICA)).SetTextAlignment(TextAlignment.CENTER)
                        .SetFont(fontTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK));

                    tableHogar.AddCell(new Cell().SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.CENTER).SetVerticalAlignment(VerticalAlignment.MIDDLE)
                         .Add(new Paragraph(item.NOTA.ToString())
                         .SetTextAlignment(TextAlignment.CENTER)
                         .SetFont(fontTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));

                }

                doc.Add(tableHogar);

                doc.Add(new Paragraph(" "));

                #endregion

                #region Numeración de Página
                int numberOfPages = pdf.GetNumberOfPages();
                for (int i = 1; i <= numberOfPages; i++)
                {
                    doc.ShowTextAligned(new Paragraph($"Pag: {i} / {numberOfPages}"),
                        580, 840, i, TextAlignment.RIGHT, VerticalAlignment.TOP, 0).SetFontSize(8f);

                    doc.ShowTextAligned(new Paragraph($"Fecha y Hora de Emisión: {DateTime.Now.ToString("dd/MM/yyyy hh:mm tt")}"),
                       565, 828, i, TextAlignment.RIGHT, VerticalAlignment.TOP, 0).SetFontSize(8f);

                }


                #endregion

                // Ceramos el documento
                doc.Close();

            }
        }

        private async Task GetPdfHistorial(string path, string pathLogo, GetHistorialCabecera data)
        {
            PdfFont fontSubTitle = PdfFontFactory.CreateFont(StandardFonts.HELVETICA);
            PdfFont fontTitle = PdfFontFactory.CreateFont(StandardFonts.HELVETICA);
            PdfFont fontHeaderTable = PdfFontFactory.CreateFont(StandardFonts.HELVETICA);
            PdfFont fontTable = PdfFontFactory.CreateFont(StandardFonts.HELVETICA);
            PdfFont fontTexto = PdfFontFactory.CreateFont(StandardFonts.HELVETICA);
            PdfFont fontMR = PdfFontFactory.CreateFont(StandardFonts.HELVETICA);
            PdfFont fontFirma = PdfFontFactory.CreateFont(StandardFonts.HELVETICA);


            PdfWriter writer = null;

            var cellColor = new DeviceRgb(191, 196, 205);


            using (writer = new PdfWriter(path))
            {
                PdfDocument pdf = new PdfDocument(writer);
                Document doc = new Document(pdf, PageSize.A4, false);

                doc.SetMargins(40, 40, 40, 40);

                #region Logo

                iText.Layout.Element.Image image = new iText.Layout.Element.Image(ImageDataFactory.Create(pathLogo));
                image.GetXObject().GetPdfObject().SetCompressionLevel(CompressionConstants.BEST_COMPRESSION);
                image.ScaleAbsolute(200, 40);
                image.SetFixedPosition(0, 800);

                doc.Add(image);
                doc.Add(new Paragraph(" "));
                doc.Add(new Paragraph(" "));
                doc.Add(new Paragraph(" "));
                #endregion

                #region Foto Estudiante

                iText.Layout.Element.Image imageEstudiante = null;
                if (_resourceDto.IsDev)
                {
                    imageEstudiante = new iText.Layout.Element.Image(ImageDataFactory.Create($"{_resourceDto.Images}/users/6.jpg"));
                }
                else
                {
                    imageEstudiante = new iText.Layout.Element.Image(ImageDataFactory.Create(data.DetalleSpHistorial.FirstOrDefault().FOTO));
                }

                imageEstudiante.GetXObject().GetPdfObject().SetCompressionLevel(CompressionConstants.BEST_COMPRESSION);
                imageEstudiante.ScaleAbsolute(88, 90);
                imageEstudiante.SetFixedPosition(478, 725);
                doc.Add(imageEstudiante);
                #endregion

                #region Titulo de Pagina
                Paragraph title = new Paragraph();
                title.SetFont(fontTitle).SetFontSize(12f).SetFontColor(ColorConstants.BLACK)
                    .SetTextAlignment(iText.Layout.Properties.TextAlignment.CENTER).SetUnderline()
                    .Add("HISTORIAL ACADEMICO DEL ESTUDIANTE");

                doc.Add(title);

                doc.Add(new Paragraph(" "));

                #endregion

                #region Cabecera

                float setHeight = 13f;
                float setFontSize = 9f;


                #region Datos de la institucion
                var datosInstitucion = data.DetalleSpHistorial.FirstOrDefault();

                Paragraph subtitleInstitucion = new Paragraph();
                subtitleInstitucion.SetFont(fontSubTitle).SetFontSize(10f).SetFontColor(ColorConstants.BLACK)
                    .SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT).SetUnderline()
                    .Add("I. DATOS DEL INSTITUTO DE EDUCACIÓN SUPERIOR TECNOLÓGICO");
                doc.Add(subtitleInstitucion);

                // Agregamos un parrafo vacio como separacion.
                doc.Add(new Paragraph(" "));

                // Empezamos a crear la tabla, definimos una tabla de 2 columnas
                Table tableInstituto = new Table(iText.Layout.Properties.UnitValue.CreatePercentArray(new float[] { 8.5f, 20, 8.5f, 20 })).UseAllAvailableWidth();

                // Esta es la primera fila
                tableInstituto.AddCell(new Cell().SetBackgroundColor(cellColor).SetHeight(setHeight).SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT).Add(new Paragraph("Nombre del IEST:").SetFont(fontHeaderTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));
                tableInstituto.AddCell(new Cell().SetHeight(setHeight).SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT)
                    .Add(new Paragraph($"{datosInstitucion.NOMBRE_INSTITUCION}").SetFont(fontTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));


                tableInstituto.AddCell(new Cell().SetBackgroundColor(cellColor).SetHeight(setHeight).SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT).Add(new Paragraph("Carrera:").SetFont(fontHeaderTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));
                tableInstituto.AddCell(new Cell().SetHeight(setHeight).SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT)
                    .Add(new Paragraph($"{datosInstitucion.NOMBRE_CARRERA}").SetFont(fontTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));

                tableInstituto.AddCell(new Cell().SetBackgroundColor(cellColor).SetHeight(setHeight).SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT).Add(new Paragraph("Plan de Estudios:").SetFont(fontHeaderTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));
                tableInstituto.AddCell(new Cell().SetHeight(setHeight).SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT)
                    .Add(new Paragraph($"{datosInstitucion.NOMBRE_PLAN_ESTUDIOS} - {datosInstitucion.NOMBRE_TIPO_ITINERARIO}")
                    .SetFont(fontTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));


                tableInstituto.AddCell(new Cell().SetBackgroundColor(cellColor).SetHeight(setHeight).SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT).Add(new Paragraph("Sede:").SetFont(fontHeaderTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));
                tableInstituto.AddCell(new Cell().SetHeight(setHeight).SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT)
                    .Add(new Paragraph($"{datosInstitucion.NOMBRE_SEDE}").SetFont(fontTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));


                // Agregamos la tabla al documento
                doc.Add(tableInstituto);
                doc.Add(new Paragraph(" "));

                #endregion

                #region datos del estudiante


                Paragraph subtitle = new Paragraph();
                subtitle.SetFont(fontSubTitle).SetFontSize(10f).SetFontColor(ColorConstants.BLACK)
                    .SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT).SetUnderline()
                    .Add("II. INFORMACIÓN DEL ESTUDIANTE");
                doc.Add(subtitle);

                // Agregamos un parrafo vacio como separacion.
                doc.Add(new Paragraph(" "));

                // Empezamos a crear la tabla, definimos una tabla de 2 columnas
                Table table = new Table(iText.Layout.Properties.UnitValue.CreatePercentArray(new float[] { 10, 20, 10, 10 })).UseAllAvailableWidth();

                // Esta es la primera fila
                table.AddCell(new Cell().SetBackgroundColor(cellColor).SetHeight(setHeight).SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT).Add(new Paragraph("Apellidos y Nombres:").SetFont(fontHeaderTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));
                table.AddCell(new Cell().SetHeight(setHeight).SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT)
                    .Add(new Paragraph($"{datosInstitucion.ESTUDIANTE}").SetFont(fontTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));

                // Esta es la segunda fila .....
                table.AddCell(new Cell().SetBackgroundColor(cellColor).SetHeight(setHeight).SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT).Add(new Paragraph("Nro Doc:").SetFont(fontHeaderTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));
                table.AddCell(new Cell().SetHeight(setHeight).SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.LEFT)
                    .Add(new Paragraph($"{datosInstitucion.TIPO_DOCUMENTO_PERSONA} - {datosInstitucion.NUMERO_DOCUMENTO_PERSONA}").SetFont(fontTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));


                // Agregamos la tabla al documento
                doc.Add(table);
                doc.Add(new Paragraph(" "));
                #endregion

                #endregion


                #region Detalle

                var grupoSemestre = data.DetalleSpHistorial.Where(p => p.NOTA != null).GroupBy(f => new
                {
                    semestre = f.CODIGO_PERIODO_LECTIVO
                })
                    .Select(group => new { sem = group.Key.semestre })
                    .Distinct()
                    .ToList();

                int cont = 0;
                var pendientes = data.DetalleSpHistorial.Where(p => p.NOTA == null).ToList();


                foreach (var sem in grupoSemestre)
                {
                    Table tblCabecera = new Table(UnitValue.CreatePercentArray(new float[] { 2, 15, 2, 2, 3 })).UseAllAvailableWidth().SetVerticalBorderSpacing(5).SetHorizontalBorderSpacing(5);//.SetWidth(iText.Layout.Properties.UnitValue.CreatePercentValue(100));
                    tblCabecera.AddHeaderCell(new Cell(1, 5).SetBackgroundColor(cellColor)

                        .SetMinHeight(15)
                        .Add(new Paragraph("PERIODO LECTIVO: " + sem.sem)
                        .SetFont(fontHeaderTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));

                    doc.Add(tblCabecera);

                    doc.Add(new Paragraph(" "));

                    Table tableHogar = new Table(UnitValue.CreatePercentArray(new float[] { 2, 15, 2, 2, 3 })).UseAllAvailableWidth().SetVerticalBorderSpacing(5).SetHorizontalBorderSpacing(5);//.SetWidth(iText.Layout.Properties.UnitValue.CreatePercentValue(100));


                    foreach (var item in data.DetalleSpHistorial.Where(p => p.NOTA != null && p.CODIGO_PERIODO_LECTIVO == sem.sem))
                    {
                        cont++;
                        if (cont == 1)
                        {
                            tableHogar.AddHeaderCell(new Cell().SetBackgroundColor(cellColor).SetMinHeight(20).SetTextAlignment(TextAlignment.CENTER).Add(new Paragraph("Periodo Academico").SetFont(fontHeaderTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));
                            tableHogar.AddHeaderCell(new Cell().SetBackgroundColor(cellColor).SetMinHeight(20).SetTextAlignment(TextAlignment.CENTER).Add(new Paragraph("Unidad Didactica").SetFont(fontHeaderTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));
                            tableHogar.AddHeaderCell(new Cell().SetBackgroundColor(cellColor).SetMinHeight(20).SetTextAlignment(TextAlignment.CENTER).Add(new Paragraph("Horas").SetFont(fontHeaderTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));
                            tableHogar.AddHeaderCell(new Cell().SetBackgroundColor(cellColor).SetMinHeight(20).SetTextAlignment(TextAlignment.CENTER).Add(new Paragraph("Créditos").SetFont(fontHeaderTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));
                            tableHogar.AddHeaderCell(new Cell().SetBackgroundColor(cellColor).SetMinHeight(20).SetTextAlignment(TextAlignment.CENTER).Add(new Paragraph("Nota").SetFont(fontHeaderTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));
                        }


                        tableHogar.AddCell(new Cell().SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.CENTER).SetVerticalAlignment(VerticalAlignment.MIDDLE)
                            .Add(new Paragraph(item.SEMESTRE_ACADEMICO_UD)
                            .SetTextAlignment(TextAlignment.CENTER)
                            .SetFont(fontTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));

                        tableHogar.AddCell(new Cell().SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.CENTER).SetVerticalAlignment(VerticalAlignment.MIDDLE)
                        .Add(new Paragraph(item.NOMBRE_UNIDAD_DIDACTICA)
                        .SetFont(fontTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));

                        tableHogar.AddCell(new Cell().SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.CENTER).SetVerticalAlignment(VerticalAlignment.MIDDLE)
                             .Add(new Paragraph(item.HORAS.ToString())
                        .SetTextAlignment(TextAlignment.CENTER)
                             .SetFont(fontTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));

                        tableHogar.AddCell(new Cell().SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.CENTER).SetVerticalAlignment(VerticalAlignment.MIDDLE)
                             .Add(new Paragraph(item.CREDITOS.ToString()).SetFont(fontTable)
                        .SetTextAlignment(TextAlignment.CENTER)
                             .SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));

                        tableHogar.AddCell(new Cell().SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.CENTER).SetVerticalAlignment(VerticalAlignment.MIDDLE)
                             .Add(new Paragraph(item.NOTA.ToString()).SetFont(fontTable).SetFontSize(setFontSize)
                             .SetTextAlignment(TextAlignment.CENTER)
                             .SetFontColor(ColorConstants.BLACK)));

                    }
                    doc.Add(tableHogar);
                }

                doc.Add(new Paragraph(" "));

                cont = 0;

                if (pendientes.Count > 0)
                {


                    Table tblPendiente = new Table(UnitValue.CreatePercentArray(new float[] { 2, 15, 2, 2, 3 })).UseAllAvailableWidth().SetVerticalBorderSpacing(5).SetHorizontalBorderSpacing(5);//.SetWidth(iText.Layout.Properties.UnitValue.CreatePercentValue(100));
                    tblPendiente.AddHeaderCell(new Cell(1, 5).SetBackgroundColor(cellColor)

                        .SetMinHeight(15).Add(new Paragraph("PENDIENTES")
                        .SetFont(fontHeaderTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));

                    doc.Add(tblPendiente);

                    doc.Add(new Paragraph(" "));


                    Table tableHogar = new Table(UnitValue.CreatePercentArray(new float[] { 2, 15, 2, 2, 3 })).UseAllAvailableWidth().SetVerticalBorderSpacing(5).SetHorizontalBorderSpacing(5);//.SetWidth(iText.Layout.Properties.UnitValue.CreatePercentValue(100));



                    foreach (var item in pendientes)
                    {
                        cont++;
                        if (cont == 1)
                        {
                            tableHogar.AddHeaderCell(new Cell().SetBackgroundColor(cellColor).SetMinHeight(20).SetTextAlignment(TextAlignment.CENTER).Add(new Paragraph("Periodo Academico").SetFont(fontHeaderTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));
                            tableHogar.AddHeaderCell(new Cell().SetBackgroundColor(cellColor).SetMinHeight(20).SetTextAlignment(TextAlignment.CENTER).Add(new Paragraph("Unidad Didactica").SetFont(fontHeaderTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));
                            tableHogar.AddHeaderCell(new Cell().SetBackgroundColor(cellColor).SetMinHeight(20).SetTextAlignment(TextAlignment.CENTER).Add(new Paragraph("Horas").SetFont(fontHeaderTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));
                            tableHogar.AddHeaderCell(new Cell().SetBackgroundColor(cellColor).SetMinHeight(20).SetTextAlignment(TextAlignment.CENTER).Add(new Paragraph("Créditos").SetFont(fontHeaderTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));
                            tableHogar.AddHeaderCell(new Cell().SetBackgroundColor(cellColor).SetMinHeight(20).SetTextAlignment(TextAlignment.CENTER).Add(new Paragraph("Nota").SetFont(fontHeaderTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));
                        }



                        tableHogar.AddCell(new Cell().SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.CENTER).SetVerticalAlignment(VerticalAlignment.MIDDLE)
                       .Add(new Paragraph(item.SEMESTRE_ACADEMICO_UD)
                       .SetTextAlignment(TextAlignment.CENTER)
                       .SetFont(fontTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));

                        tableHogar.AddCell(new Cell().SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.CENTER).SetVerticalAlignment(VerticalAlignment.MIDDLE)
                        .Add(new Paragraph(item.NOMBRE_UNIDAD_DIDACTICA)
                        .SetFont(fontTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));

                        tableHogar.AddCell(new Cell().SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.CENTER).SetVerticalAlignment(VerticalAlignment.MIDDLE)
                             .Add(new Paragraph(item.HORAS.ToString())
                        .SetTextAlignment(TextAlignment.CENTER)
                             .SetFont(fontTable).SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));

                        tableHogar.AddCell(new Cell().SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.CENTER).SetVerticalAlignment(VerticalAlignment.MIDDLE)
                             .Add(new Paragraph(item.CREDITOS.ToString()).SetFont(fontTable)
                        .SetTextAlignment(TextAlignment.CENTER)
                             .SetFontSize(setFontSize).SetFontColor(ColorConstants.BLACK)));

                        tableHogar.AddCell(new Cell().SetHorizontalAlignment(iText.Layout.Properties.HorizontalAlignment.CENTER).SetVerticalAlignment(VerticalAlignment.MIDDLE)
                             .Add(new Paragraph(item.NOTA.ToString()).SetFont(fontTable).SetFontSize(setFontSize)
                             .SetTextAlignment(TextAlignment.CENTER)
                             .SetFontColor(ColorConstants.BLACK)));


                    }

                    doc.Add(tableHogar);

                    doc.Add(new Paragraph(" "));

                }

                #endregion

                #region Numeración de Página
                int numberOfPages = pdf.GetNumberOfPages();
                for (int i = 1; i <= numberOfPages; i++)
                {
                    doc.ShowTextAligned(new Paragraph($"Pag: {i} / {numberOfPages}"),
                        580, 840, i, TextAlignment.RIGHT, VerticalAlignment.TOP, 0).SetFontSize(8f);

                    doc.ShowTextAligned(new Paragraph($"Fecha y Hora de Emisión: {DateTime.Now.ToString("dd/MM/yyyy hh:mm tt")}"),
                       565, 828, i, TextAlignment.RIGHT, VerticalAlignment.TOP, 0).SetFontSize(8f);

                }


                #endregion

                // Ceramos el documento
                doc.Close();

            }
        }

        private async Task<List<GetEnumeradoComboDto>> GetTipoSemestreAcademico()
        {
            List<EnumeradoCabecera> listaMaestra = new List<EnumeradoCabecera>();
            Dictionary<EnumeradoCabecera, List<GetEnumeradoComboDto>> oListaEnumMaestras;

            listaMaestra.Add(EnumeradoCabecera.SEMESTRE);

            oListaEnumMaestras = await _maestraManager.GetListEnumeradoByGrupo(listaMaestra);

            return oListaEnumMaestras[EnumeradoCabecera.SEMESTRE].ToList();

        }


    }
}
