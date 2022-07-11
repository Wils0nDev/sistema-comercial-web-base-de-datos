
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_actualizar_rutas' AND type = 'P')
	DROP PROCEDURE pa_actualizar_rutas
GO
----------------------------------------------------------------------------------
-- Author: KVASQUEZ IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Actualizar datos de Ruta
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_actualizar_rutas]
(
	@descripcion varchar(100),	--Nombre de la Ruta
	@pseudonimo varchar(100),	--Abreviatura
	@ntraRutas int				--Codigo de la Ruta
)
AS
BEGIN TRY
		BEGIN
		UPDATE tblRutas SET descripcion = @descripcion, pseudonimo = @pseudonimo WHERE ntraRutas = @ntraRutas
		END
END TRY
BEGIN CATCH
		SELECT  
			ERROR_NUMBER() AS NumeroDeError   
            ,ERROR_STATE() AS NumeroDeEstado    
            ,ERROR_LINE() AS  NumeroDeLinea  
            ,ERROR_MESSAGE() AS MensajeDeError;  
			
END CATCH