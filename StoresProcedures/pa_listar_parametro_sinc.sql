
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_parametro_sinc' AND type = 'P')
	DROP PROCEDURE pa_listar_parametro_sinc
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 06/02/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Traer lista de parametros
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_parametro_sinc		
AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
		
		SET @g_const_0 = 0

		SET NOCOUNT ON;  
		SELECT  codParametro, tipo, valorEntero1, valorEntero2, valorCaneda1, valorCaneda2, valorMoneda1, 
						valorMoneda2, valorFloat1, valorFloat2, valorFecha1, valorFecha2
		FROM tblDetalleParametro where marcaBaja = @g_const_0

	END	
GO

--exec pa_listar_parametro_sinc

 