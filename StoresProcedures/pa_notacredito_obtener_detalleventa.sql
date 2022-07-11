
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_notacredito_obtener_detalleventa' AND type = 'P')
DROP PROCEDURE pa_notacredito_obtener_detalleventa
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 23/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: obtener detalle de venta por codigo
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_notacredito_obtener_detalleventa
(
	@p_codigo INT				--codigo de venta
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @itemVenta TINYINT; 
	DECLARE @codProducto VARCHAR(10); 
	DECLARE @descProducto VARCHAR(200); 
	DECLARE @cantidadPresentacion INT; 
	DECLARE @cantidadUnidadBase INT; 
	DECLARE @precioVenta MONEY; 
	DECLARE @descAlmacen VARCHAR(20); 
	DECLARE @descUnidadBase VARCHAR(250);
	DECLARE @tipoProducto TINYINT; 
	DECLARE @descTipProducto VARCHAR(250); 
	DECLARE @descuento MONEY;
	DECLARE @can_disponible INT;
	DECLARE @can_devueltos INT;
	
	DECLARE @cantidad INT;
	DECLARE @can_dev INT;
	DECLARE @dsct_disponible MONEY;
	DECLARE @importe MONEY;

	SET @itemVenta = 0; 
	SET @codProducto = ''; 
	SET @descProducto = ''; 
	SET @cantidadPresentacion = 0; 
	SET @cantidadUnidadBase = 0; 
	SET @precioVenta = 0; 
	SET @descAlmacen = ''; 
	SET @descUnidadBase = '';
	SET @tipoProducto = 0; 
	SET @descTipProducto = ''; 
	SET @descuento = 0;
	SET @can_disponible = 0;
	SET @can_devueltos = 0;
	SET @dsct_disponible = 0;
	SET @importe = 0;

	CREATE TABLE #temporal
	(itemVenta TINYINT, 
	codProducto VARCHAR(10), 
	descProducto VARCHAR(200), 
	cantidadPresentacion INT, 
	cantidadUnidadBase INT, 
	precioVenta MONEY, 
	descAlmacen VARCHAR(20), 
	descUnidadBase VARCHAR(250),
	tipoProducto TINYINT, 
	descTipProducto VARCHAR(250), 
	descuento MONEY,
	can_disponible INT,
	can_devueltos INT,
	dsct_disponible MONEY);

	BEGIN TRY
		DECLARE cur_stock CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
		SELECT dv.itemVenta, dv.codProducto, pro.descripcion as descProducto, dv.cantidadPresentacion, dv.cantidadUnidadBase,
		dv.precioVenta, alm.descripcion as descAlmacen, con.descripcion as descUnidadBase, dv.TipoProducto as tipoProducto,
		est.descripcion as descTipProducto, ISNULL(dpd.importe,0) as descuento
		FROM tblDetalleVenta dv
		INNER JOIN tblConcepto con ON dv.codPresentacion = con.correlativo
		INNER JOIN tblAlmacen alm ON dv.codAlmacen = alm.ntraAlmacen
		INNER JOIN tblProducto pro ON dv.codProducto = pro.codProducto
		inner join (select correlativo, descripcion from tblConcepto where codConcepto = 22) as est on dv.TipoProducto = est.correlativo
		left join tblVentaDescuento dpd on dpd.codVenta = dv.codVenta and dpd.itemVenta = dv.itemVenta
		WHERE dv.codVenta = @p_codigo AND con.codConcepto = 12
		AND pro.marcaBaja = 0 AND dv.marcaBaja = 0 AND alm.marcaBaja = 0 AND con.marcaBaja = 0
		ORDER BY dv.itemVenta ASC;

		OPEN cur_stock;  
		FETCH NEXT FROM cur_stock INTO @itemVenta, @codProducto, @descProducto, @cantidadPresentacion, @cantidadUnidadBase, @precioVenta, 
		@descAlmacen, @descUnidadBase, @tipoProducto, @descTipProducto, @descuento
		WHILE @@FETCH_STATUS = 0
			BEGIN
				SET @can_dev = 0;
				SELECT @can_dev = SUM(cantidadPresentacion) FROM tblDetalleVenta
				WHERE codVenta IN (SELECT codVentaNega FROM tblNotaCredito WHERE codVenta = @p_codigo AND marcaBaja = 0) 
				AND codProducto = @codProducto AND marcaBaja = 0;

				IF(@can_dev IS NULL)
					SET @can_dev = 0;

				SET @cantidad = 0;
				SET @cantidad = @cantidadPresentacion - @can_dev;

				SET @importe = 0;
				SELECT @importe = SUM(importe) FROM tblVentaDescuento
				WHERE codVenta IN (SELECT codVentaNega FROM tblNotaCredito WHERE codVenta = @p_codigo AND marcaBaja = 0) 
				AND itemVenta = @itemVenta AND marcaBaja = 0;

				IF(@importe IS NULL)
					SET @importe = 0;

				SET @dsct_disponible = @descuento + @importe;

				INSERT INTO #temporal 
				SELECT @itemVenta , @codProducto, @descProducto, @cantidadPresentacion, @cantidadUnidadBase, @precioVenta, 
				@descAlmacen, @descUnidadBase, @tipoProducto, @descTipProducto, @descuento, @cantidad , @can_dev, @dsct_disponible;
				
				FETCH NEXT FROM cur_stock INTO 
				@itemVenta , @codProducto, @descProducto, @cantidadPresentacion, @cantidadUnidadBase, @precioVenta, 
				@descAlmacen, @descUnidadBase, @tipoProducto, @descTipProducto, @descuento
			END
		CLOSE cur_stock;
		DEALLOCATE cur_stock;

		SELECT * FROM #temporal
		--SELECT dv.itemVenta, dv.codProducto, pro.descripcion as descProducto, dv.cantidadPresentacion, dv.cantidadUnidadBase,
		--dv.precioVenta, alm.descripcion as descAlmacen, con.descripcion as descUnidadBase, dv.TipoProducto as tipoProducto,
		--est.descripcion as descTipProducto, ISNULL(dpd.importe,0) as descuento
		--FROM tblDetalleVenta dv
		--INNER JOIN tblConcepto con ON dv.codPresentacion = con.correlativo
		--INNER JOIN tblAlmacen alm ON dv.codAlmacen = alm.ntraAlmacen
		--INNER JOIN tblProducto pro ON dv.codProducto = pro.codProducto
		--inner join (select correlativo, descripcion from tblConcepto where codConcepto = 22) as est on dv.TipoProducto = est.correlativo
		--left join tblVentaDescuento dpd on dpd.codVenta = dv.codVenta and dpd.itemVenta = dv.itemVenta
		--WHERE dv.codVenta = @p_codigo AND con.codConcepto = 12
		--AND pro.marcaBaja = 0 AND dv.marcaBaja = 0 AND alm.marcaBaja = 0 AND con.marcaBaja = 0
		--ORDER BY dv.itemVenta ASC;
		
	END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER() as itemVenta, 'Error en pa_notacredito_obtener_detalleventa ' + ERROR_MESSAGE() as codProducto,
		'' as descProducto, 0 as cantidadPresentacion, 0 as cantidadUnidadBase, 0 as precioVenta, '' as descAlmacen, '' as descUnidadBase,
		0 as tipoProducto, '' as descTipProducto, 0 as descuento, 0 as can_disponible, 0 as can_devueltos
	END CATCH
END
GO