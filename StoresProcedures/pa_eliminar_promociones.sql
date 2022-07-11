IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_eliminar_promociones' AND type = 'P')
DROP PROCEDURE pa_eliminar_promociones
GO
----------------------------------------------------------------------------------
-- Author: Kevin V - IDE-SOLUTION
-- Created: 24/03/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Eliminar Promociones
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_eliminar_promociones]
(
	@codProm INT,				--codigo de la promocion
	@resultado INT OUTPUT		--mensaje
)

AS
	BEGIN
		BEGIN TRY
			UPDATE tblPromociones SET estado = 2  WHERE ntraPromocion = @codProm	

			UPDATE tblDetallePromociones set estado = 2 where ntraPromocion = @codProm	
			SELECT @resultado = @codProm
		END TRY
		BEGIN CATCH
				SELECT  
					ERROR_NUMBER() AS NumeroDeError   
				   ,ERROR_STATE() AS NumeroDeEstado    
				   ,ERROR_LINE() AS  NumeroDeLinea  
				   ,ERROR_MESSAGE() AS MensajeDeError;  
		END CATCH
END

