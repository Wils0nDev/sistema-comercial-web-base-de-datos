
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_ordenar_rutas_asignadas' AND type = 'P')
	DROP PROCEDURE pa_ordenar_rutas_asignadas
GO
----------------------------------------------------------------------------------
-- Author: WilSON IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Ordenar rutas asignadas
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].pa_ordenar_rutas_asignadas
(
	@codUsuario INT,
	@codRuta INT,
	@codOrden INT,
	@resultado INT OUTPUT
)

AS
	BEGIN	  
BEGIN TRY
		UPDATE tblRutasAsignadas SET codOrden = @codOrden WHERE codUsuario = @codUsuario and codRuta = @codRuta
		SELECT @resultado = 0
END TRY
BEGIN CATCH
		SELECT @resultado = 0
		SELECT  
			ERROR_NUMBER() AS NumeroDeError   
            ,ERROR_STATE() AS NumeroDeEstado    
            ,ERROR_LINE() AS  NumeroDeLinea  
            ,ERROR_MESSAGE() AS MensajeDeError;  
END CATCH

END