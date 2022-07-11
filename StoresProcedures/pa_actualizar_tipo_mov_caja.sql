IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_actualizar_tipo_mov_caja' AND type = 'P')
	DROP PROCEDURE pa_actualizar_tipo_mov_caja
GO
----------------------------------------------------------------------------------
-- Author: PEDRO YACILA IDE-SOLUTION
-- Created: 15/04/2020   
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripcion: Actualizar tipo movimiento en caja
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_actualizar_tipo_mov_caja]
(
	@descripcion varchar(250),		--Descripcion del Tipo de Movimiento
	@tipoRegistro TINYINT,		    --Código Tipo de Registro (1 - Entrada/ 2 - Salida)
	@ntraTipoMovimiento int				--Codigo del tipo de movimiento
)
AS
BEGIN TRY
		BEGIN
		UPDATE tblTipoMovimiento SET descripcion = @descripcion, tipoRegistro = @tipoRegistro WHERE ntraTipoMovimiento = @ntraTipoMovimiento
		END
END TRY
BEGIN CATCH
		SELECT  
			ERROR_NUMBER() AS NumeroDeError   
            ,ERROR_STATE() AS NumeroDeEstado    
            ,ERROR_LINE() AS  NumeroDeLinea  
            ,ERROR_MESSAGE() AS MensajeDeError;  
			
END CATCH
GO