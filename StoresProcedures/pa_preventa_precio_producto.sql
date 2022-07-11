
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_preventa_precio_producto' AND type = 'P')
DROP PROCEDURE pa_preventa_precio_producto
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 10/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: obtener precio de producto
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_preventa_precio_producto
(
	@p_codProducto VARCHAR(50),		--codigo producto
	@p_tipoListaPrecio INT			--tipo lista precio
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @flag INT;				--flag de proceso
	DECLARE @msje VARCHAR(100);		--mensaje

	SET @flag = 0;
	SET @msje = 'EXITO';
	
	BEGIN TRY
		SELECT pre.precioVenta as 'precioVenta', pro.tipoProducto as 'tipoProducto', @flag as 'flag', @msje as 'msje'
		FROM tblPrecio pre INNER JOIN tblProducto pro ON pre.codProducto = pro.codProducto
		WHERE pre.codProducto = @p_codProducto AND pre.tipoListaPrecio = @p_tipoListaPrecio 
		AND pre.marcaBaja = 0 AND pro.marcaBaja = 0;
	
	END TRY

	BEGIN CATCH
		SET @flag = 1;
		SET @msje = 'Error en pa_preventa_precio_producto ' + ERROR_MESSAGE();
		SELECT ERROR_NUMBER() as 'precioVenta', 0 as 'tipoProducto', @flag as 'flag', @msje as 'msje'
	END CATCH
END
GO