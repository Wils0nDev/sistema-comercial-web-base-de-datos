IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_descuento_activar_desactivar' AND type = 'P')
	DROP PROCEDURE pa_descuento_activar_desactivar
GO
----------------------------------------------------------------------------------
-- Author: Diego Sanchez IDE-SOLUTION
-- Created: 30/03/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen.
-- Descripción: Cambiar estado del descuento
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_descuento_activar_desactivar]
@idDescuento int,
@estado int
AS
BEGIN
	DECLARE @msj VARCHAR(150)
	DECLARE @ntraDescu int
	DECLARE @flag int

	set @ntraDescu = @idDescuento;

	BEGIN TRY
		BEGIN TRANSACTION
			UPDATE tblDescuentos SET estado = @estado WHERE ntraDescuento = @idDescuento;
			SET @msj = 'Se actualizo el estado del descuento';
			SET @flag = 0;
		COMMIT TRANSACTION
		SELECT @flag as flag, @msj as mensaje, @ntraDescu as ntraDescuento
	END TRY
	BEGIN CATCH
		IF (XACT_STATE()) <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END
		SET @flag = ERROR_NUMBER();
		SET @msj = 'Error en pa_registrar_modificar_preventa ' + ERROR_MESSAGE();
		SELECT @flag as flag , @msj as mensaje, @ntraDescu as ntraDescuento
	END CATCH
END