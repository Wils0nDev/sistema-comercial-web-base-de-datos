IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_existe_ruc_cliente' AND type = 'P')
	DROP PROCEDURE pa_existe_ruc_cliente
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 30/01/2020
-- Sistema: Distribuidora Virgende del carmen
-- Descripcion: Verificar si existe cliente por RUC
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_existe_ruc_cliente]	
(
	@p_ruc VARCHAR(11)		-- ruc del cliente
)

AS
	BEGIN
	SET NOCOUNT ON
		DECLARE @val TINYINT		-- Valor de existencia
		DECLARE @flag INT;			-- flag de proceso
		DECLARE @msje VARCHAR(250);	-- mensaje de error
		

		SET @flag = 0;
		SET @msje = 'Exito';
		SET @val = 0;
		
		SELECT @val = COUNT(*) FROM tblCliente INNER JOIN tblPersona ON tblCliente.codPersona = tblPersona.codUbigeo
		WHERE tblPersona.ruc = @p_ruc and tblCliente.marcaBaja = 0

		SELECT @flag as flag , @msje as msje, @val as val


END
