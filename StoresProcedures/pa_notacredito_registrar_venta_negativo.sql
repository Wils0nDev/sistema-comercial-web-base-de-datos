IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_notacredito_registrar_venta_negativo' AND type = 'P')
DROP PROCEDURE pa_notacredito_registrar_venta_negativo
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 23/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: registrar venta en negativo para nota de credito
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_notacredito_registrar_venta_negativo
(
	@p_codigo INT,				--codigo de venta
	@p_listaDetalles XML,		--lista de detalle venta
	@p_importe MONEY,			--importe
	@p_usuario VARCHAR(20),					--usuario
	@p_ip VARCHAR(20),						--direccion ip
	@p_mac VARCHAR(20)						--mac
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ntraVN INT;

	--VENTA
	DECLARE @serie varchar(20);
	DECLARE @nroDocumento INT;
	DECLARE @tipoPago SMALLINT;
	DECLARE @codPreventa INT;
	DECLARE @codCliente INT;
	DECLARE @codVendedor INT;
	DECLARE @fechaTransaccion DATE;
	DECLARE @tipoMoneda SMALLINT;
	DECLARE @tipoCambio MONEY;
	DECLARE @estado SMALLINT;
	DECLARE @importeTotal MONEY;
	DECLARE @importeRecargo MONEY;
	DECLARE @tipoVenta SMALLINT;
	DECLARE @codSucursal INT;
	DECLARE @IGV MONEY;
	DECLARE @fechaPago DATE;
	DECLARE @tipoDocVenta tinyint;
	DECLARE @codPuntoEntrega INT;

	--DETALLE
	DECLARE @itemVenta TINYINT; 
	DECLARE @codProducto VARCHAR(10); 
	DECLARE @cantidad INT; 
	DECLARE @cantidad_ub INT; 
	DECLARE @flag_des INT;
	DECLARE @codPresentacion INT;
	DECLARE @codAlmacen INT;
	DECLARE @precioVenta MONEY;
	DECLARE @tipoProducto TINYINT;

	--DESCUENTO
	DECLARE @codDescuento INT;
	DECLARE @importe MONEY;

	--PROMOCION
	DECLARE @flag_pro INT;
	DECLARE @codPromocion INT;
	DECLARE @itemVO TINYINT;

	--PARAMETROS
	DECLARE @por_igv MONEY;
	

	SET @ntraVN = 0;
	SET @itemVenta = 0; 
	SET @codProducto = ''; 
	SET @cantidad = 0; 
	SET @cantidad_ub = 0; 
	SET @flag_des = 0;
	SET @codPresentacion = 0;
	SET @codAlmacen = 0;
	SET @precioVenta = 0;
	SET @tipoProducto = 0;
	SET @codDescuento = 0;
	SET @importe = 0;
	SET @flag_pro = 0;
	SET @codPromocion = 0;
	SET @itemVO = 0;
	SET @por_igv = 0;
	SET @serie = 0;
	SET @nroDocumento = 0;
	SET @tipoPago = 0;
	SET @codPreventa = 0;
	SET @codCliente = 0;
	SET @codVendedor = 0;
	SET @fechaTransaccion = NULL;
	SET @tipoMoneda = 0;
	SET @tipoCambio = 0;
	SET @estado = 0;
	SET @importeTotal = 0;
	SET @importeRecargo = 0;
	SET @tipoVenta = 0;
	SET @codSucursal = 0;
	SET @IGV = 0;
	SET @fechaPago = NULL;
	SET @tipoDocVenta = 0;
	SET @codPuntoEntrega = 0;

	BEGIN TRY
	BEGIN TRANSACTION
		--VENTA
		SELECT @serie = serie, @nroDocumento = nroDocumento, @tipoPago = tipoPago, @codPreventa = codPreventa, 
		@codCliente = codCliente, @codVendedor = codVendedor, @fechaTransaccion = fechaTransaccion, @tipoMoneda = tipoMoneda,
		@tipoCambio = tipoCambio, 
		--@estado = estado, 
		--@importeTotal = importeTotal, 
		--@importeRecargo = importeRecargo, 
		@tipoVenta = tipoVenta, @codSucursal = codSucursal, 
		--@IGV = IGV, 
		@fechaPago = fechaPago, 
		@tipoDocVenta = tipoDocumentoVenta, @codPuntoEntrega = codPuntoEntrega
		FROM tblVenta
		WHERE ntraVenta = @p_codigo AND marcaBaja = 0;

		--PARAMETROS 
		SELECT @por_igv = igv
		FROM tblParametrosGenerales
		WHERE codSucursal = @codSucursal AND marcaBaja = 0;

		SET @importeTotal = @p_importe;
		SET @IGV = ROUND((@importeTotal - (@importeTotal/(@por_igv))),2);
		SET @importeTotal = @importeTotal * -1;
		SET @IGV = @IGV * -1;
		SET @importeRecargo = 0;
		SET @estado = 5 -- VENTA POR REVERSION NC

		INSERT INTO tblVenta(serie, nroDocumento, tipoPago, codPreventa, codCliente, codVendedor, fechaTransaccion, tipoMoneda,
		tipoCambio, estado, importeTotal, importeRecargo, tipoVenta, codSucursal, IGV, fechaPago, tipoDocumentoVenta, 
		codPuntoEntrega, usuario, ip, mac)
		VALUES (@serie, @nroDocumento, @tipoPago, @codPreventa, @codCliente, @codVendedor, @fechaTransaccion, @tipoMoneda,
		@tipoCambio, @estado, @importeTotal, @importeRecargo, @tipoVenta, @codSucursal, @IGV, @fechaPago, @tipoDocVenta,
		@codPuntoEntrega, @p_usuario, @p_ip, @p_mac);

		SET @ntraVN = @@IDENTITY;

		DECLARE cur_detalle CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
		SELECT cast(colx.query('data(itemVenta)') as varchar), cast(colx.query('data(codProducto)') as varchar), 
		cast(colx.query('data(cantidad)') as varchar), cast(colx.query('data(cantidad_ub)') as varchar), 
		cast(colx.query('data(flag_des)') as varchar), cast(colx.query('data(flag_pro)') as varchar)
		FROM @p_listaDetalles.nodes('ArrayOfCENListaDevueltos/CENListaDevueltos') AS Tabx(Colx)              
		OPEN cur_detalle;  
		FETCH NEXT FROM cur_detalle INTO @itemVenta, @codProducto, @cantidad, @cantidad_ub, @flag_des, @flag_pro;
		WHILE @@FETCH_STATUS = 0
			BEGIN
				
				--SET @cantidad = @cantidad * -1;
				--SET @cantidad_ub = @cantidad_ub * -1;

				SELECT @codPresentacion = codPresentacion, @codAlmacen = codAlmacen, 
				@precioVenta = precioVenta, @tipoProducto = TipoProducto
				FROM tblDetalleVenta
				WHERE codVenta = @p_codigo AND itemVenta = @itemVenta AND codProducto = @codProducto AND marcaBaja = 0;
				
				SET @precioVenta = @precioVenta * -1;
				
				INSERT INTO tblDetalleVenta( codVenta, itemVenta, codPresentacion, codProducto, codAlmacen,
				cantidadPresentacion, cantidadUnidadBase, precioVenta, TipoProducto, usuario, ip, mac)
				VALUES( @ntraVN, @itemVenta, @codPresentacion, @codProducto, @codAlmacen, 
				@cantidad, @cantidad_ub, @precioVenta, @tipoProducto, @p_usuario, @p_ip, @p_mac);

				UPDATE tblDetalleVenta SET cantDevNC = cantDevNC + @cantidad
				WHERE codVenta = @p_codigo AND codProducto = @codProducto AND marcaBaja = 0;

				IF(@flag_des = 1)
				BEGIN
					SELECT @codDescuento = codDescuento, @importe = importe
					FROM tblVentaDescuento
					WHERE codVenta = @p_codigo AND itemVenta = @itemVenta AND marcaBaja = 0;

					SET @importe = @importe * -1;

					INSERT INTO tblVentaDescuento (codVenta, codDescuento, itemVenta, importe, usuario, ip, mac)
					VALUES (@ntraVN, @codDescuento, @itemVenta, @importe, @p_usuario, @p_ip, @p_mac);
				END

				IF(@flag_pro = 1)
				BEGIN
					SELECT @codPromocion = codPromocion, @itemVO = itemVenta
					FROM tblVentaPromocion
					WHERE codVenta = @p_codigo AND itemPromocionado = @itemVenta AND marcaBaja = 0;

					INSERT INTO tblVentaPromocion(codVenta, codPromocion, itemVenta, itemPromocionado, usuario, ip, mac)
					VALUES( @ntraVN, @codPromocion, @itemVO, @itemVenta, @p_usuario, @p_ip, @p_mac);
				END
				
				FETCH NEXT FROM cur_detalle INTO @itemVenta, @codProducto, @cantidad, @cantidad_ub, @flag_des, @flag_pro;
			END
		CLOSE cur_detalle;  
		DEALLOCATE cur_detalle;

		SELECT @ntraVN as ntraVN
	COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		IF (XACT_STATE()) <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END
		SELECT ERROR_NUMBER() as ntraVN
	END CATCH
END
GO