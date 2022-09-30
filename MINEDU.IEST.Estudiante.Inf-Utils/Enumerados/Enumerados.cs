namespace MINEDU.IEST.Estudiante.Inf_Utils.Enumerados
{
    public enum EnumeradoCabecera
    {

        TIPO_ESTADO_REGISTRO = 1,
        TIPO_GESTION = 2,
        TIPO_ESTADO_PERIODO_LECTIVO_INSTITUCION = 3,
        TIPO_AULA = 4,
        TIPO_TURNO = 5,
        TIPO_PROCESO = 6,
        TIPO_RESOLUCION = 7,
        TIPO_MODALIDAD = 8,
        TIPO_DOCUMENTO = 9,
        TIPO_PERSONAL = 10,
        TIPO_ESTADO_CIVIL = 11,
        TIPO_SEXO = 12,
        TIPO_INSTITUCION = 13,
        TIPO_GRADO_PROFESIONAL = 14,
        TIPO_ROL = 15,
        TIPO_CONTRATO = 16,
        TIPO_PISO = 17,
        TIPO_CARGO = 18,
        TIPO_META = 19,
        TIPO_ESTADO_POSTULANTE = 20,
        LENGUA = 21,
        TIPO_IE_BASICA = 22,
        NIVEL_IE_BASICA = 23,
        TIPO_PAGO = 24,
        TIPO_PARENTEZCO = 25,
        TIPO_DISCAPACIDAD = 26,
        TIPO_ESTADO_RESULTADO = 29,
        TIPO_REGISTRO = 32,
        TIPO_CONVALIDACION = 27,
        TIPO_ESTADO_MODALIDAD = 28,
        TIPO_ITINERARIO = 33,
        ESTADO_PROGRAMA = 34,
        MODALIDAD_ESTUDIO = 37,
        SEMESTRE = 38,
        DIA = 39,
        TIPO_CLASE = 40,
        TIPO_MODULO = 47,
        PROFESIONAL = 48,
        TIPO_LICENCIA = 49,
        ESTADO_UNIDAD_DIDACTICA = 52,
        TIPO_RESULTADO = 54,
        TIPO_SOLICITUD = 55,
        ESTADO_CONVALIDACION = 61,
        TIPO_ESTUDIANTE = 60,
        TIPO_SEDE = 62,
        CIERRE_PROGRAMACION_EVALUACION = 65,
        TIPO_SECCION = 36,
        TIPO_MOTIVO = 41,
        ESTADO_TRASLADO = 46,
        TIPO_PROMOCION = 63,
        TIPO_TRASLADO = 45,
        TIPO_TIEMPO_LICENCIA = 51,
        TIPO_MATRICULA = 58,
        TIPO_PAGO_INSTITUCION = 66
    }


    #region Enumerado - Detalle

    public enum EnumTIPO_ESTADO_REGISTRO
    {
        ACTIVO = 1,
        INACTIVO = 2,
        PENDIENTE = 10076,
        HABILITADO = 10077
    }
    public enum EnumTIPO_GESTION
    {
        PÚBLICO = 10061,
        PRIVADO = 10062,
        PÚBLICO_Y_PRIVADO = 5
    }
    public enum EnumTIPO_ESTADO_PERIODO_LECTIVO_INSTITUCION
    {
        CREADO = 6,
        APERTURADO = 7,
        FINALIZADO = 8
    }
    public enum EnumTIPO_AULA
    {
        AUDITORIO = 9,
        AULA = 10,
        LABORATORIO = 11,
        TALLER = 12,
        OFICINAS_ADMINISTRATIVAS = 236,
        OFICINA_BIENESTAR_SOCIAL = 237,
        TOPICO = 238,
        BIBLIOTECA = 239,
        OTROS = 240,
        DESARROLLO = 189,
        AULA_DE_PRUEBA = 299
    }
    public enum EnumTIPO_TURNO
    {
        MAÑANA = 13,
        TARDE = 14,
        NOCHE = 15
    }
    public enum EnumTIPO_PROCESO
    {
        ADMISIÓN = 16,
        CONVALIDACIÓN = 17,
        LICENCIA = 18,
        MATRÍCULA = 19,
        TRASLADO = 20,
        EVALUACION = 208
    }
    public enum EnumTIPO_RESOLUCION
    {
        AUTORIZACIÓN = 209,
        REVALIDACIÓN = 210,
        LICENCIAMIENTO = 211,
        ACREDITACIÓN = 212,
        META_DE_ATENCIÓN_ANUAL = 21,
        AMPLIACIÓN_DE_META_DE_ATENCIÓN = 22
    }
    public enum EnumTIPO_MODALIDAD
    {
        EXONERADO = 23,
        ORDINARIO = 24,
        EXTRAORDINARIO = 25
    }
    public enum EnumTIPO_DOCUMENTO
    {
        DNI = 26,
        CARNET_DE_EXTRANJERÍA = 27,
        PASAPORTE = 28,
        PTP = 317,
        TEST6 = 316
    }
    public enum EnumTIPO_PERSONAL
    {
        JERÁRQUICO = 29,
        ACADÉMICO = 30,
        ADMINISTRATIVO = 31,
        PRUEBA_1 = 289,
        PRUEBA_2 = 290,
        PRUEBA_3 = 291,
        PRUEBA_4 = 292,
        PRUEBA_5 = 293,
        PRUEBA_6 = 294,
        PRUEBA_7 = 295,
        PRUEBA_8 = 296,
        CIVIL = 304
    }
    public enum EnumTIPO_ESTADO_CIVIL
    {
        SOLTERO = 32,
        CASADO = 33,
        DIVORCIADO = 34,
        VIUDO = 329,
        CONVIVIENTE = 330
    }
    public enum EnumTIPO_SEXO
    {
        MASCULINO = 35,
        FEMENINO = 36
    }
    public enum EnumTIPO_INSTITUCION
    {
        T0 = 38,
        M0 = 39,
        LO = 40
    }
    public enum EnumTIPO_GRADO_PROFESIONAL
    {
        TÉCNICO = 41,
        BACHILLER = 42,
        TITULADO = 43,
        MAESTRÍA = 44,
        DOCTORADO = 45,
        EGRESADO = 298,
        PHD = 305,
        OTROS = 10066
    }
    public enum EnumTIPO_ROL
    {
        ESPECIALISTA_MINEDU = 46,
        DIRECTOR_IEST = 47,
        SECRETARIO_ACADÉMICO = 48,
        DOCENTE = 49,
        JEFE_UNIDAD_ACADEMICA = 218,
        SECRETARIA = 219,
        JEFE_DE_AREA_COORDINADOR = 220,
        JEFE_DE_UNIDAD_ADMINISTRATIVA = 221,
        ADMINISTRADOR = 222,
        PERSONAL_DE_SERVICIO = 223,
        BIBLIOTECARIO = 224,
        AUXILIAR = 225,
        ESPECIALISTA_FUNCIONAL = 10082,
        ESPECIALISTA_DRE = 10083
    }
    public enum EnumTIPO_CONTRATO
    {
        CONTRATADO = 50,
        NOMBRADO = 51,
        TEMPORAL = 297,
        OTRO = 306,
        ENCARGADO = 10067
    }
    public enum EnumTIPO_PISO
    {
        PISO_01 = 52,
        PISO_02 = 53,
        PISO_03 = 54,
        PISO_04 = 55,
        PISO_05 = 56,
        PISO_06 = 57,
        PISO_07 = 58,
        PISO_08 = 59,
        PISO_09 = 60,
        PISO_10 = 61,
        PISO_11 = 340,
        PISO_12 = 341,
        PISO_13 = 342,
        PISO_14 = 343,
        PISO_15 = 344,
        PISO_16 = 345,
        PISO_17 = 346,
        PISO_18 = 347,
        PISO_19 = 348,
        PISO_20 = 349
    }
    public enum EnumTIPO_CARGO
    {
        PRESIDENTE = 62,
        TESORERO = 63,
        SECRETARIO = 64
    }
    public enum EnumTIPO_META
    {
        PORCENTAJE = 65,
        NÚMERO = 66
    }
    public enum EnumTIPO_ESTADO_POSTULANTE
    {
        PENDIENTE = 67,
        COMPLETO = 68
    }
    public enum EnumLENGUA
    {
        ESPAÑOL = 69,
        PORTUGUES = 86,
        INGLES = 301,
        AYMARA = 319,
        ACHUAR = 241,
        AMAHUACA = 242,
        ARABELA = 243,
        ASHANINKA = 244,
        AWAJUN = 245,
        BORA = 246,
        KAPANAWA = 247,
        CASHINAHUA = 248,
        KAWKI = 249,
        CHAMICURO = 250,
        ESE_EJA = 251,
        HARAKBUT = 252,
        IÑAPARI = 253,
        IKITU = 254,
        ISKONAWA = 255,
        JAQARU = 256,
        KAKATAIBO = 257,
        KAKINTE = 258,
        KANDOZI_CHAPRA = 259,
        KUKAMA_KUKAMIRIA = 260,
        MADIJA = 261,
        MALJIKI = 262,
        MATSIGENKA = 263,
        MATSES = 264,
        MUNICHE = 265,
        MURUI_MUINANI = 266,
        MATSIGENKA_MONTETOKUNIRIRA = 267,
        NOMATSIGENGA = 268,
        OCAINA = 269,
        OMAGUA = 270,
        QUECHUA = 271,
        RESIGARO = 272,
        SECOYA = 273,
        SHARANAHUA = 274,
        SHAWI = 275,
        SHIPIBO_KONIBO = 276,
        SHIWILU = 277,
        TAUSHIRO = 278,
        TICUNA = 279,
        URARINA = 280,
        WAMPIS = 281,
        YAGUA = 282,
        YAMINAHUA = 283,
        YANESHA = 284,
        YINE = 285,
        NAHUA = 286,
        SHIPIBO = 216,
        FRANCÉS = 10063,
        CHINO = 10064,
        OTRO = 10065
    }
    public enum EnumTIPO_IE_BASICA
    {
        EBE = 72,
        EBR = 70,
        EBA = 71,
        XYZ = 302
    }
    public enum EnumNIVEL_IE_BASICA
    {
        PRIMARIA = 74,
        SECUNDARIA = 75,
        INICIAL = 73
    }
    public enum EnumTIPO_PAGO
    {
        TESORERIA = 76
    }
    public enum EnumTIPO_PARENTEZCO
    {
        PADRE = 77,
        MADRE = 78,
        OTROS = 318
    }
    public enum EnumTIPO_DISCAPACIDAD
    {
        INTELECTUAL = 81,
        MOTORA = 82,
        SORDOCEGUERA = 84,
        AUDITIVA_HIPOACUSIA = 321,
        AUDITIVA_SORDERA = 322,
        SALUD_MENTAL = 323,
        TRANSTORNO_ESPECTRO_AUTISTA = 324,
        VISUAL_BAJA_VISIÓN = 325,
        VISUAL_CEGUERA = 326,
        ESTUDIANTE_EN_SITUACIÓN_DE_HOSPITALIZACIÓN = 327,
        OTRA_NEE = 328
    }
    public enum EnumTIPO_CONVALIDACION
    {
        POR_TRASLADO_INTERNO = 194,
        POR_TRASLADO_EXTERNO = 197,
        POR_UNIDADES_DIDÁCTICAS = 198,
        POR_SEGUNDA_CARRERA = 199
    }
    public enum EnumTIPO_ESTADO_MODALIDAD
    {
        PENDIENTE = 96,
        EVALUADO = 97
    }
    public enum EnumTIPO_ESTADO_RESULTADO
    {
        PENDIENTE = 87,
        ACEPTADO = 88,
        RECHAZADO = 89,
        APROBADO = 90,
        DESAPROBADO = 91
    }
    public enum EnumTIPO_REGISTRO
    {
        Nuevo_programa_de_estudio = 98,
        Catálogo_nacional_de_la_oferta_formativa = 104
    }
    public enum EnumTIPO_ITINERARIO
    {
        POR_ASIGNATURA = 99,
        TRANSVERSAL = 100,
        MODULAR = 101
    }
    public enum EnumESTADO_PROGRAMA
    {
        AUTORIZADO = 102,
        LICENCIADO = 103
    }
    public enum EnumTIPO_SECCION
    {
        A = 105,
        B = 106,
        C = 107,
        D = 108,
        E = 10068,
        F = 10069,
        M = 400,
        N = 401,
        Ñ = 402,
        O = 403,
        P = 404,
        Q = 405,
        R = 406,
        S = 407,
        T = 408,
        U = 409,
        V = 410,
        W = 411,
        X = 412,
        Y = 413,
        Z = 414,
        G = 10070,
        H = 10071,
        I = 10072,
        J = 10073,
        K = 10074,
        L = 10075
    }
    public enum EnumMODALIDAD_ESTUDIO
    {
        DISTANCIA = 124,
        PRESENCIAL = 109,
        SEMI_PRESENCIAL = 110
    }
    public enum EnumSEMESTRE
    {
        I = 111,
        II = 112,
        III = 113,
        IV = 114,
        V = 115,
        VI = 116,
        VII = 137,
        VIII = 138
    }
    public enum EnumDIA
    {
        Lunes = 117,
        Martes = 118,
        Miércoles = 119,
        Jueves = 120,
        Viernes = 121,
        Sábado = 122,
        Domingo = 123
    }
    public enum EnumTIPO_CLASE
    {
        TEÓRICO_PRÁCTICO = 127,
        TEÓRICO = 125,
        PRÁCTICO = 126
    }
    public enum EnumTIPO_MOTIVO
    {
        RENUNCIA = 128,
        ABANDONO = 129
    }
    public enum EnumTIPO_TRASLADO
    {
        INTERNO = 141,
        EXTERNO = 142
    }
    public enum EnumESTADO_TRASLADO
    {
        SOLICITADO = 143,
        APROBADO = 144,
        RECHAZADO = 145,
        CONVALIDADO = 146,
        TRASLADADO = 147
    }
    public enum EnumTIPO_MODULO
    {
        MODULO_TECNICO_PROFESIONAL = 159,
        MODULOS_TRANSVERSALES = 160,
        MODULO_TECNICO = 169
    }
    public enum EnumTIPO_LICENCIA
    {
        SALUD = 161,
        VIAJE = 162,
        ECONÓMICO = 163,
        OTROS = 164
    }
    public enum EnumTIPO_TIEMPO_LICENCIA
    {
        UN_PERIODO = 165,
        DOS_PERIODOS = 166,
        TRES_PERIODOS = 167,
        CUATRO_PERIODOS = 168
    }
    public enum EnumESTADO_UNIDAD_DIDACTICA
    {
        REGULAR = 170,
        SUBSANACIÓN = 171,
        ADELANTO = 173
    }
    public enum EnumTIPO_RESULTADO
    {
        PENDIENTE_EVALUACIÓN = 213,
        ALCANZÓ_VACANTE = 174,
        NO_ALCANZÓ_VACANTE = 176,
        DESAPROBADO = 177
    }
    public enum EnumTIPO_SOLICITUD
    {
        ENVIADO_RECIBIDO = 180,
        ENVIADO = 178,
        RECIBIDO = 179
    }
    public enum EnumTIPO_MATRICULA
    {
        REGULAR = 185,
        EXTEMPORÁNEA = 188
    }
    public enum EnumTIPO_ESTUDIANTE
    {
        HISTÓRICO = 190,
        BECADO = 191,
        INGRESO_DIRECTO = 192,
        ADMISIÓN = 193
    }
    public enum EnumESTADO_CONVALIDACION
    {
        PENDIENTE = 200,
        CONVALIDADO = 201,
        NO_CONVALIDADO = 202,
        EN_TRASLADO = 333,
        TRASLADADO = 334
    }
    public enum EnumTIPO_SEDE
    {
        PRINCIPAL = 203,
        FILIAL = 204,
        LOCAL = 205
    }
    public enum EnumTIPO_PROMOCION
    {
        SEMESTRAL = 206,
        ANUAL = 207
    }
    public enum EnumCIERRE_PROGRAMACION_EVALUACION
    {
        ABIERTO = 234,
        CERRADO = 235
    }
    public enum EnumTIPO_PAGO_INSTITUCION
    {
        MATRÍCULA = 10078,
        ADMISIÓN = 10079,
        INGRESO = 10080,
        PENSIÓN = 10081
    }
    public enum EnumTIPO_REPORTE_MONITOREO
    {
        REPORTE_DE_PERSONAL = 10085,
        REPORTE_DE_PROGRAMAS_DE_ESTUDIOS = 10086,
        REPORTE_DE_METAS_DE_ATENCIÓN = 10087,
        REPORTE_DE_ADMISIÓN = 10088,
        REPORTE_DE_MATRÍCULA = 10089
    }
    public enum EnumTIPO_DOCENTE_CLASE
    {
        DOCENTE_PRINCIPAL = 390,
        DOCENTE_DE_APOYO = 391
    }
    public enum EnumTIPO_EVALUACION
    {
        EXTRAORDINARIA = 395,
        COMPLEMENTARIA = 396
    }
    #endregion
}
