IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_alta_baja_tipo_mov_caja' AND type = 'P')
	DROP PROCEDURE pa_alta_baja_tipo_mov_caja
GO
----------------------------------------------------------------------------------
-- Author: PEDRO YACILA IDE-SOLUTION
-- Created: 15/04/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripcion: Alta/Baja tipo de movimiento
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_alta_baja_tipo_mov_caja]
(
	@ntraTipoMovimiento int,	--Codigo del tipo de movimiento
	@flag int -- 0 - alta/ 9 - baja
)

AS
	BEGIN
		BEGIN TRY
			UPDATE tblTipoMovimiento SET marcaBaja = @flag  WHERE ntraTipoMovimiento = @ntraTipoMovimiento
		END TRY
		BEGIN CATCH
				SELECT  
					ERROR_NUMBER() AS NumeroDeError   
				   ,ERROR_STATE() AS NumeroDeEstado    
				   ,ERROR_LINE() AS  NumeroDeLinea  
				   ,ERROR_MESSAGE() AS MensajeDeError;  
		END CATCH
END
GO