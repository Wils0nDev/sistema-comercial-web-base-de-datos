
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_preventa_listar_puntos_entrega' AND type = 'P')
DROP PROCEDURE pa_preventa_listar_puntos_entrega
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 10/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: Listar puntos de entrega de cliente
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_preventa_listar_puntos_entrega
(
	@p_codcliente INT		--codigo de persona
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @flag INT;				--flag de proceso
	DECLARE @msje VARCHAR(100);		--mensaje

	--SET @flag = 0;
	--SET @msje = 'EXITO';
	
	BEGIN TRY
		SELECT ntraPuntoEntrega as 'codPuntoEntrega', direccion as 'descripcion'
		FROM tblPuntoEntrega
		WHERE codPersona = @p_codcliente AND marcaBaja = 0
	
	END TRY

	BEGIN CATCH
		--SET @flag = 0;
		--SET @msje = 'EXITO';
		SELECT ERROR_NUMBER() as 'codPuntoEntrega', 'Error en pa_preventa_listar_puntos_entrega ' + ERROR_MESSAGE() as 'descripcion'
	END CATCH
END
GO