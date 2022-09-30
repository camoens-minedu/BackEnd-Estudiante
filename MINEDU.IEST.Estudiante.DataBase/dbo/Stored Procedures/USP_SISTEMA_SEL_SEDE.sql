--USP_SISTEMA_SEL_SEDE 2027, '4'
CREATE PROCEDURE [dbo].[USP_SISTEMA_SEL_SEDE]
(
       @ID_INSTITUCION INT,
       @COD_TIPO_SEDE varchar(1)
)
AS
BEGIN
DECLARE @COD_SEDE varchar(7)
SET @COD_SEDE=(select mi.CODIGO_MODULAR from db_auxiliar.dbo.UVW_INSTITUCION mi where mi.ID_INSTITUCION = @ID_INSTITUCION)
print @COD_SEDE
SELECT [ID_SEDE]
      ,[COD_SEDE]
      ,[DSC_SEDE]
      ,[COD_TIPO_SEDE]=convert(varchar(2),[COD_TIPO_SEDE])
      ,[DSC_COD_TIPO_SEDE]
  FROM [db_auxiliar].[dbo].[UVW_SEDE]
  where COD_SEDE=@COD_SEDE
       AND COD_TIPO_SEDE=@COD_TIPO_SEDE

  END
GO


