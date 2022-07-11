IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_notacredito_validar_venta' AND type = 'P')
DROP PROCEDURE pa_notacredito_validar_venta
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 23/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: validar si venta puede aplicar a NC
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_notacredito_validar_venta
(
	@p_codigo INT				--codigo de venta
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @fecha DATETIME;		--fecha de transaccion venta
	DECLARE @fecha_cad VARCHAR(20);	--fecha de transaccion venta cadena
	DECLARE @param_uno SMALLINT;	--parametro 1
	DECLARE @param_dos SMALLINT;	--parametro 2
	DECLARE @msje VARCHAR(200);		--mensaje
	DECLARE @flag SMALLINT;			--flag
	DECLARE @can_dias INT;			--cantidad de dias

	SET @fecha = NULL;
	SET @param_uno = 0;
	SET @param_dos = 0;
	SET @msje = '';
	SET @flag = 0;
	SET @can_dias = 0;
	SET @fecha_cad = '';

	BEGIN TRY
		--fecha de venta
		SELECT @fecha = fechaTransaccion, @fecha_cad = (SELECT CONVERT (VARCHAR(15), fechaTransaccion, 3) as [DD/MM/YY])
		FROM tblVenta
		WHERE ntraVenta = @p_codigo AND marcaBaja = 0;

		--parametros
		SELECT @param_uno = valorEntero1, @param_dos = valorEntero2
		FROM tblDetalleParametro
		WHERE codParametro = 8 AND marcaBaja = 0;

		--cantidad de dias
		SET @can_dias = DATEDIFF(DAY, @fecha, CONVERT(DATE, GETDATE()));

		IF ((SELECT MONTH(GETDATE())) = MONTH(@fecha))
		BEGIN
			IF(@can_dias <= @param_uno)
			BEGIN
				SET @flag = 1;
				SET @msje = 'EXITO';
			END
			ELSE
			BEGIN
				SET @msje = 'FECHA DE VENTA ('+@fecha_cad+') EXCEDE A LOS ' + CONVERT(VARCHAR(15), @param_uno) + ' DIAS PERMITIDOS';
			END
		END
		ELSE
		BEGIN
			IF(@can_dias <= @param_uno)
			BEGIN
				IF( (SELECT DAY(GETDATE())) <= @param_dos )
				BEGIN
					SET @flag = 1;
					SET @msje = 'EXITO';
				END
				ELSE
				BEGIN
					SET @msje = 'FECHA DE VENTA ('+@fecha_cad+') EXCEDE A LOS ' + CONVERT(VARCHAR(15), @param_dos) + ' DIAS PERMITIDOS DE OTRO MES';
				END
			END
			ELSE
			BEGIN
				SET @msje = 'FECHA DE VENTA ('+@fecha_cad+') EXCEDE A LOS ' + CONVERT(VARCHAR(15), @param_uno) + ' DIAS PERMITIDOS';
			END
		END

		SELECT @flag as flag, @msje as msje
	END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER() as flag, 'Error en pa_notacredito_validar_venta ' + ERROR_MESSAGE() as msje
	END CATCH
END
GO