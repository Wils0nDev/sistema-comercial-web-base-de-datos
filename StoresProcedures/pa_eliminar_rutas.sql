
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_eliminar_rutas' AND type = 'P')
	DROP PROCEDURE pa_eliminar_rutas
GO
----------------------------------------------------------------------------------
-- Author: Kevin V - IDE-SOLUTION
-- Created: 10/03/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Eliminar Rutas
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_eliminar_rutas]
(
	@codRuta INT,				--codigo de la ruta
	@resultado INT OUTPUT		--mensaje
)

AS
	BEGIN
		BEGIN TRY
			UPDATE tblRutas SET marcaBaja = 9  WHERE ntraRutas = @codRuta	
			SELECT @resultado = @codRuta	
		END TRY
		BEGIN CATCH
				SELECT  
					ERROR_NUMBER() AS NumeroDeError   
				   ,ERROR_STATE() AS NumeroDeEstado    
				   ,ERROR_LINE() AS  NumeroDeLinea  
				   ,ERROR_MESSAGE() AS MensajeDeError;  
		END CATCH
END