
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_preventa_parametros' AND type = 'P')
DROP PROCEDURE pa_preventa_parametros
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 10/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: obtener parametros preventa
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_preventa_parametros
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @flag INT;				--flag de proceso
	DECLARE @msje VARCHAR(100);		--mensaje
	DECLARE @porcentajeRecargo MONEY;
	DECLARE @igv MONEY;
	DECLARE @flagRecargo INT;

	SET @flag = 0;
	SET @msje = 'EXITO';
	SET @porcentajeRecargo = 0;
	SET @igv = 0;
	SET @flagRecargo = 0;
	
	
	BEGIN TRY
		
		-- porcentaje recargo
		SELECT @porcentajeRecargo = valorMoneda1 FROM tblDetalleParametro 
		WHERE codParametro = 1 AND marcaBaja = 0;

		-- igv
		SELECT @igv = valorMoneda1 FROM tblDetalleParametro 
		WHERE codParametro = 2 AND marcaBaja = 0;

		-- flag de uso de recargo
		SELECT @flagRecargo = valorEntero1 FROM tblDetalleParametro 
		WHERE codParametro = 3 AND marcaBaja = 0;

		SELECT @porcentajeRecargo as 'porcentajeRecargo', @igv as 'igv', @flagRecargo as 'flagRecargo', @flag as 'flag', @msje as 'msje'
	
	END TRY

	BEGIN CATCH
		SET @flag = 1;
		SET @msje = 'Error en pa_preventa_parametros ' + ERROR_MESSAGE();
		SELECT ERROR_NUMBER() as 'porcentajeRecargo', 0 as 'igv', 0 as 'flagRecargo', @flag as 'flag', @msje as 'msje'
	END CATCH
END
GO