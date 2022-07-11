USE DB_virgendelcarmen
GO
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_notacredito_impresion_detalle_venta_nc' AND type = 'P')
DROP PROCEDURE pa_notacredito_impresion_detalle_venta_nc
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 23/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: obtener datos de detalle venta negativo
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_notacredito_impresion_detalle_venta_nc
(
	@p_codNotaCredito INT	--codigo nota credito
)
AS
BEGIN
	SET NOCOUNT ON;
	--DATOS VENTA
	DECLARE @codVentaNega INT;

	--DATOS DETALLE VENTA:
	DECLARE @itemVenta INT;
	DECLARE @codProducto VARCHAR(20);
	DECLARE @descProducto VARCHAR(150);
	DECLARE @cantidad INT;
	DECLARE @descUnidad VARCHAR(100);
	DECLARE @precioVenta MONEY;
	DECLARE @tipoProducto INT;
	DECLARE @descTipoProducto VARCHAR(100);
	DECLARE @subTotal MONEY;

	CREATE TABLE #temporal
	(itemVenta INT,
	codProducto VARCHAR(20),
	descProducto VARCHAR(150),
	cantidad INT,
	descUnidad VARCHAR(100),
	precioVenta MONEY,
	descTipoProducto VARCHAR(100),
	subTotal MONEY);

	SET @codVentaNega = 0;
	SET @itemVenta = 0;
	SET @codProducto = '';
	SET @descProducto = '';
	SET @cantidad = 0;
	SET @descUnidad= '';
	SET @precioVenta = 0;
	SET @tipoProducto = 0;
	SET @descTipoProducto = '';
	SET @subTotal = 0;


	BEGIN TRY
		--DATOS VENTA:
		SELECT @codVentaNega = codVentaNega
		FROM tblNotaCredito 
		WHERE ntraNotaCredito = @p_codNotaCredito AND marcaBaja = 0;

		--DATOS DETALLE VENTA:
		DECLARE cur_stock CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
		SELECT dv.itemVenta, dv.codProducto, p.descripcion, dv.cantidadPresentacion, c.descripcion, 
		(dv.precioVenta * -1), dv.TipoProducto, (dv.cantidadUnidadBase * dv.precioVenta * -1)
		FROM tblDetalleVenta dv INNER JOIN tblProducto p ON p.codProducto = dv.codProducto
		INNER JOIN tblConcepto c ON c.correlativo = dv.codPresentacion
		WHERE dv.codVenta = @codVentaNega AND c.codConcepto = 12
		ORDER BY dv.itemVenta ASC;

		OPEN cur_stock;  
		FETCH NEXT FROM cur_stock INTO @itemVenta, @codProducto, @descProducto, @cantidad, @descUnidad, @precioVenta, 
		@tipoProducto, @subTotal
		WHILE @@FETCH_STATUS = 0
			BEGIN
				SELECT  @descTipoProducto = descripcion FROM tblConcepto 
				WHERE codConcepto = 22 AND correlativo = @tipoProducto AND marcaBaja = 0;

				INSERT INTO #temporal
				SELECT @itemVenta as itemVenta, @codProducto as codProducto, @descProducto as descProducto, 
				@cantidad as cantidad, @descUnidad as descUnidad, @precioVenta as precioVenta, 
				@descTipoProducto as descTipoProducto, @subTotal as subTotal
				
				FETCH NEXT FROM cur_stock INTO 
				@itemVenta, @codProducto, @descProducto, @cantidad, @descUnidad, @precioVenta, 
				@tipoProducto, @subTotal
			END
		CLOSE cur_stock;
		DEALLOCATE cur_stock;

		SELECT * FROM #temporal;

	END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER() as itemVenta, '' as codProducto, 'Error en pa_notacredito_impresion_detalle_venta_nc ' + ERROR_MESSAGE() as descProducto, 
		0 as cantidad, '' as descUnidad, 0 as precioVenta, 
		'' as descTipoProducto, 0 as subTotal

	END CATCH
END
GO