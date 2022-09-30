CREATE FUNCTION [dbo].[UFN_GenerarCodSolicitud]
( @anio VARCHAR(4) )

RETURNS VARCHAR(9)
as
begin

	DECLARE @Reg int
	DECLARE @CODIGO VARCHAR(9)

	set @Reg = (SELECT COUNT (*) from transaccional.solicitud_carnet)
	if @Reg = 0
		begin
			SET @CODIGO = @anio + '0001'
		end

	else
		begin
			DECLARE @ANIOSOL VARCHAR(4)
			DECLARE @CODSOL INT
			
			set @ANIOSOL = (select top 1 substring(NRO_SOLICITUD,1,4) from transaccional.solicitud_carnet ORDER BY ID_SOLICITUD_CARNET DESC)
			set @CODSOL = (select top 1 substring(NRO_SOLICITUD,5,5) from transaccional.solicitud_carnet ORDER BY ID_SOLICITUD_CARNET DESC)
			
			IF @anio = @ANIOSOL
				BEGIN
					IF  @CODSOL >= 9999
						BEGIN
							DECLARE @CODSOL_5 INT
							SET @CODSOL_5 = @CODSOL + 1
							SET @CODIGO = @anio + RIGHT('00000' + Ltrim(Rtrim(@CODSOL_5)),5)
						END
					ELSE
						BEGIN
							SET @CODSOL =  @CODSOL + 1
							SET @CODIGO = @anio + RIGHT('0000' + Ltrim(Rtrim(@CODSOL)),4)
						END
				END
			ELSE
				BEGIN
					SET @CODIGO = @anio + '0001'
				END			
		END

	RETURN @CODIGO


	
	END