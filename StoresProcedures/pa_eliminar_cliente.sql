
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_eliminar_cliente' AND type = 'P')
	DROP PROCEDURE pa_eliminar_cliente
GO
----------------------------------------------------------------------------------
-- Author: Jonathan Macalupu S. IDE-SOLUTION
-- Created: 20/01/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen
-- Modulo: General
-- Descripción: Eliminar clientes 
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_eliminar_cliente]	
(
	@p_codPersona INT   --Codigo de persona
)

AS
	BEGIN
	SET NOCOUNT ON
		DECLARE @flag INT;						--flag de proceso
		DECLARE @msje VARCHAR(250);				--mensaje de error

		SET @flag = 0;
		SET @msje = 'Exito';

		BEGIN TRY		
			
			BEGIN TRANSACTION 
			
				UPDATE tblCliente SET marcaBaja = 9 WHERE codPersona = @p_codPersona AND marcaBaja = 0

				UPDATE tblPuntoEntrega SET marcaBaja = 9 WHERE codPersona = @p_codPersona AND marcaBaja = 0

			COMMIT TRANSACTION

			SELECT @flag as flag , @msje as msje

		END TRY

			BEGIN CATCH
				IF (XACT_STATE()) <> 0 
			BEGIN
				ROLLBACK TRANSACTION
			END
			SET @flag = ERROR_NUMBER();
			SET @msje = 'Error en pa_eliminar_cliente ' + ERROR_MESSAGE();
			SELECT @flag as flag , @msje as msje

		END CATCH

END
GO