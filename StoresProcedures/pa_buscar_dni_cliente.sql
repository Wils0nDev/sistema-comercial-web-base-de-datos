
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_buscar_dni_cliente' AND type = 'P')
	DROP PROCEDURE pa_buscar_dni_cliente
GO
----------------------------------------------------------------------------------
-- Author: Jonathan Macalupu S. IDE-SOLUTION
-- Created: 06/01/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen
-- Modulo: General
-- Descripción: Busca si existe el dni del cliente 
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_buscar_dni_cliente]	
(
	@p_dni INT		-- dni del cliente
)

AS
	BEGIN
	SET NOCOUNT ON
		DECLARE @val TINYINT		-- Valor de existencia codigo persona
		DECLARE @flag INT;			-- flag de proceso
		DECLARE @msje VARCHAR(250);	-- mensaje de error
		

		SET @flag = 0;
		SET @msje = 'Exito';
		SET @val = 0;

		BEGIN TRY		

			SELECT @val = COUNT(codPersona)
			FROM tblCliente
			WHERE codPersona = @p_dni AND marcaBaja = 0;

			SELECT @flag as flag , @msje as msje, @val as val

		END TRY
		BEGIN CATCH

			SET @flag = ERROR_NUMBER();
			SET @msje = 'Error en pa_buscar_dni_cliente ' + ERROR_MESSAGE();
			SET @val = 0;
			SELECT @flag as flag , @msje as msje, @val as val

		END CATCH

END
GO