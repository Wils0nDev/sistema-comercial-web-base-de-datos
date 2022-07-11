
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_preventa_presentacion_producto' AND type = 'P')
DROP PROCEDURE pa_preventa_presentacion_producto
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 10/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: obtener presentaciones de producto
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_preventa_presentacion_producto
(
	@p_codProducto VARCHAR(50)		--codigo producto
)
AS
BEGIN
	SET NOCOUNT ON;
	--DECLARE @flag INT;				--flag de proceso
	--DECLARE @msje VARCHAR(100);		--mensaje
	
	BEGIN TRY
		SELECT pre.codPresentancion, con.descripcion, pre.cantidadUnidadBase
		FROM tblDetallePresentacion pre INNER JOIN tblConcepto con ON pre.codPresentancion = con.correlativo
		WHERE con.codConcepto = 12 AND pre.codProducto = @p_codProducto AND pre.marcaBaja = 0 AND con.marcaBaja = 0
		ORDER BY codPresentancion ASC
	
	END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER() as 'codPresentancion', 'Error en pa_preventa_presentacion_producto ' + ERROR_MESSAGE() as 'descripcion', 0 as 'cantidadUnidadBase'
	END CATCH
END
GO