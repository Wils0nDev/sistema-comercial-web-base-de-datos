IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_obtener_parametros_x_flag_sucursal' AND type = 'P')
	DROP PROCEDURE pa_obtener_parametros_x_flag_sucursal
GO
----------------------------------------------------------------------------------
-- Author: WILSON IDE-SOLUTION
-- Created: 02/04/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: obtner parametros por flag y codigo de sucursal
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_obtener_parametros_x_flag_sucursal
(
	@p_flag INT,
	@p_codSucursal INT
)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		IF @p_flag = 1
		BEGIN
			SELECT  tipoCambio  FROM tblParametrosGenerales
			WHERE codSucursal = @p_codSucursal AND marcaBaja = 0;
		END

		IF (@p_flag = 2)
		BEGIN
			SELECT  igv FROM tblParametrosGenerales
			WHERE codSucursal = @p_codSucursal AND marcaBaja = 0;
		END
	
	END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER(), 'Error en pa_obtener_parametros_x_flag_sucursal ' + ERROR_MESSAGE() 
	END CATCH
END
GO
