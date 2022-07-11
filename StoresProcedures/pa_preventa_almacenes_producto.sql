
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_preventa_almacenes_producto' AND type = 'P')
DROP PROCEDURE pa_preventa_almacenes_producto
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 10/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: obtener almacenes de producto
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_preventa_almacenes_producto
(
	@p_codProducto VARCHAR(50)		--codigo producto
)
AS
BEGIN
	SET NOCOUNT ON;
	--DECLARE @flag INT;				--flag de proceso
	--DECLARE @msje VARCHAR(100);		--mensaje
	
	BEGIN TRY
		select alm.ntraAlmacen as 'codAlmacen', alm.descripcion as 'descripcion', inv.stock as 'stock'
		FROM tblAlmacen alm INNER JOIN tblInventario inv ON alm.ntraAlmacen = inv.codAlmacen
		WHERE inv.codProducto = @p_codProducto AND inv.stock > 0
		AND alm.marcaBaja = 0 AND inv.marcaBaja = 0
	
	END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER() as 'codAlmacen', 'Error en pa_preventa_almacenes_producto ' + ERROR_MESSAGE() as 'descripcion', 0 as 'stock'
	END CATCH
END
GO