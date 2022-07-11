IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_notacredito_registrar_nc_parcial' AND type = 'P')
DROP PROCEDURE pa_notacredito_registrar_nc_parcial
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 23/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: registrar datos nota de credito parcial
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_notacredito_registrar_nc_parcial
(
	@p_codVenta INT,			--codigo venta
	@p_codVentaNega INT,		--codigo venta con importes negativos
	@p_codMotivo CHAR(2),		--codigo motivo nc
	@p_fecha DATE,				--fecha
	@p_tipo SMALLINT,			--tipo nc
	@p_importe MONEY,			--importe nc
	@p_usuario VARCHAR(20),		--usuario
	@p_ip VARCHAR(20),			--direccion ip
	@p_mac VARCHAR(20),			--mac
	@p_codSucursal INT,			--codigo de sucursal
	@p_codUsuario INT
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @serie varchar(20); -- SERIE
	DECLARE @numero INT; --Numero de documento para la venta
	DECLARE @tipoVenta INT; --tipo de venta 
	DECLARE @flagCxC INT; --flag de cuenta por cobrar
	DECLARE @flagPagos INT; --flag existe transaccion pago
	DECLARE @ntraNC int; --transaccion de NC
	DECLARE @codProducto VARCHAR(20);--codigo de producto
	DECLARE @cantidadUnidadBase SMALLINT; --cantidad productos
	DECLARE @tipoCambio MONEY; --tipo cambio
	DECLARE @flag INT;
	DECLARE @msje VARCHAR(200);

	DECLARE @contador INT;
	DECLARE @entero INT;
	DECLARE @entero2 INT;
	DECLARE @importe MONEY;
	DECLARE @importe2 MONEY;

	DECLARE @codOpe INT;
	DECLARE @codMod SMALLINT;
	DECLARE @prefij INT;
	DECLARE @correl INT;
	DECLARE @import MONEY;
	DECLARE @fechaT DATE;
	DECLARE @horaTr TIME(0);
	DECLARE @fechaC DATE;
	DECLARE @respon VARCHAR(250);
	DECLARE @hora TIME;

	SET @flag = 0;
	SET @msje = 'EXITO';
	SET @contador = 0;
	SET @entero = 0;
	SET @entero2 = 0;
	SET @importe = @p_importe * -1;
	SET @importe2 = 0;

	SET @hora = (select convert(char(8), getdate(), 108) as [hh:mm:ss])
	BEGIN TRY
		BEGIN TRANSACTION

		--NOTA CREDITO
		SELECT @tipoCambio = tipoCambio FROM tblParametrosGenerales WHERE codSucursal = @p_codSucursal AND marcaBaja = 0;

		SET @ntraNC = 0;
		SELECT @numero = correlativoNC, @serie = serieNC FROM tblSerieVenta where codSucursal = @p_codSucursal AND marcaBaja = 0
		SET @numero = @numero + 1;
		INSERT INTO tblNotaCredito (serie, numero, codVenta, codVentaNega, codMotivo, fecha, tipo, importe, tipoCambio, usuario,
		estado, codSucursal, ip, mac, codUsuario)
		VALUES (@serie, @numero, @p_codVenta, @p_codVentaNega, @p_codMotivo, @p_fecha, @p_tipo, @p_importe, @tipoCambio, @p_usuario,
		1, @p_codSucursal, @p_ip, @p_mac, @p_codUsuario);
		SET @ntraNC = @@IDENTITY;

		UPDATE tblSerieVenta SET correlativoNC = @numero WHERE codSucursal = @p_codSucursal AND marcaBaja = 0;

		--TIPO VENTA 1 CONTADO - 2 CREDITO
		SET @tipoVenta = 0;
		SELECT @tipoVenta = tipoVenta
		FROM tblVenta
		WHERE ntraVenta = @p_codVenta AND marcaBaja = 0;
		
		SET @flagCxC = 0;
		SET @flagPagos = 0;

		IF(@tipoVenta = 1) --CONTADO
		BEGIN
			-- VERIFICAR EXISTENCIA CUENTA POR COBRAR CxC
			SET @entero = 0;
			SELECT @entero = COUNT(codOperacion)
			FROM tblCuentaCobro
			WHERE codOperacion = @p_codVenta AND marcaBaja = 0;
			IF(@entero > 0)
				SET @flagCxC = 1;
		END
		ELSE --CREDITO
		BEGIN
			UPDATE tblPrestamo SET importeTotal = importeTotal - @p_importe --, interesTotal = x
			WHERE codVenta = @p_codVenta AND marcaBaja = 0;
			
			SET @entero = 0;
			SELECT @entero = ntraPrestamo FROM tblPrestamo WHERE codVenta = @p_codVenta AND marcaBaja = 0;
			UPDATE tblCronograma SET importe = importe - @p_importe
			WHERE codPrestamo = @entero AND marcaBaja = 0;
		END
		
		IF(@tipoVenta = 2 OR (@tipoVenta = 1 AND @flagCxC = 1) )
		BEGIN
			SET @contador = 0;
			SELECT @contador = COUNT(codVenta) FROM tblTranssaccionesPago 
			WHERE codVenta = @p_codVenta AND marcaBaja = 0;
			IF(@contador > 0)
				SET @flagPagos = 1;
		END

		--(CONTADO Y EXISTE CxC Y EXISTE TRANSACCION PAGO) OR
		--(CONTADO Y NO EXISTE CxC) OR
		--(CREDITO Y EXISTE TRANSACCION PAGO)
		IF((@tipoVenta = 1 AND @flagCxC = 1 AND @flagPagos = 1) OR (@tipoVenta = 1 AND @flagCxC = 0) OR (@tipoVenta = 2 AND @flagPagos = 1))
		BEGIN
			--REGISTRAR CUENTA CORRIENTE
			--obtener codigo cliente
			SET @entero = 0;
			SELECT @entero = codCliente
			FROM tblVenta
			WHERE ntraVenta = @p_codVenta AND marcaBaja = 0;
			--verificar existencia de cc
			SET @contador = 0;
			SELECT @contador = COUNT(codPersona)
			FROM tblCuentaCorriente 
			WHERE codPersona = @entero AND marcaBaja = 0;
			IF(@contador = 0)
			BEGIN
				INSERT INTO tblCuentaCorriente (codPersona, saldoTotal, usuario, ip, mac)
				VALUES (@entero, @p_importe, @p_usuario, @p_ip, @p_mac);
				SET @entero = @@IDENTITY;
				INSERT INTO tblDetalleCuentaCorriente (codCuentaCorriente, codOperacion, codModulo, prefijo, correlativo, importe, 
				usuario, ip, mac)
				VALUES (@entero, @ntraNC, 1, 1, 1, @p_importe, @p_usuario, @p_ip, @p_mac);
			END
			ELSE
			BEGIN
				SET @entero2 = 0;
				SELECT @entero2 = ntraCuentaCorriente
				FROM tblCuentaCorriente
				WHERE codPersona = @entero AND marcaBaja = 0;

				INSERT INTO tblDetalleCuentaCorriente (codCuentaCorriente, codOperacion, codModulo, prefijo, correlativo, importe, 
				usuario, ip, mac)
				VALUES (@entero2, @ntraNC, 1, 1, 1, @p_importe, @p_usuario, @p_ip, @p_mac);

				UPDATE tblCuentaCorriente SET saldoTotal = saldoTotal + @p_importe
				WHERE codPersona = @entero AND marcaBaja = 0;
			END

			--REGISTRAR PAGO NEGATIVO -- FALTA ESTADO EN PAGO EFECTIVO?
			INSERT INTO tblTranssaccionesPago (nroCuota, codVenta, ntraMedioPago, tipoCambio, tipoMoneda, IGV, fechaTransaccion, 
			horaTransaccion ,usuario, estado, ip, mac)
			VALUES (1, @p_codVentaNega, 1, @tipoCambio, 1, 0, @p_fecha, @hora , @p_usuario, 1, @p_ip, @p_mac);
			SET @entero = @@IDENTITY;
			INSERT INTO tblPagoEfectivo (ntraTransaccionPago, importe, vuelto, tipoMoneda, estado, usuario, ip, mac)
			VALUES (@entero, @importe, 0, 1, 1, @p_usuario, @p_ip, @p_mac);

		END

		IF(@tipoVenta = 1 AND @flagCxC = 1)
		BEGIN
			IF(@flagPagos = 1)
			BEGIN
				UPDATE tblCuentaCobro SET importe = importe - @p_importe
				WHERE codOperacion = @p_codVenta AND marcaBaja = 0;
			END
			ELSE
			BEGIN
				IF(@flagPagos = 0)
				BEGIN
					UPDATE tblCuentaCobro SET estado = 3 -- REVERTIDO X NC
					WHERE codOperacion = @p_codVenta AND marcaBaja = 0;
		
					SELECT @codOpe = codOperacion, @codMod = codModulo, @prefij = prefijo, @correl = correlativo,
					@import = importe, @fechaT = fechaTransaccion, @horaTr = horaTransaccion, @fechaC = fechaCobro,
					@respon = responsable
					FROM tblCuentaCobro 
					WHERE codOperacion = @p_codVenta AND marcaBaja = 0;

					SET @import = @import - @p_importe

					INSERT INTO tblCuentaCobro (codOperacion, codModulo, prefijo, correlativo, importe, 
					fechaTransaccion, horaTransaccion, fechaCobro, estado, responsable, usuario, ip, mac)
					VALUES (@codOpe, @codMod, @prefij, @correl, @import, @fechaT, @horaTr, @fechaC, 1, @respon, @p_usuario, @p_ip, @p_mac);
				END
			END
		END

		--ENVIAR STOCK A ALMACEN DE PRODUCTOS DEVUELTOS
		DECLARE cur_stock CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
		SELECT cantidadUnidadBase, codProducto
		FROM tblDetalleVenta WHERE codVenta = @p_codVentaNega AND marcaBaja = 0;
		OPEN cur_stock;  
		FETCH NEXT FROM cur_stock INTO @cantidadUnidadBase, @codProducto
		WHILE @@FETCH_STATUS = 0
			BEGIN
				SET @entero = 0;
				SELECT @entero = COUNT(codProducto) FROM tblInventario 
				WHERE codAlmacen = 2 AND codProducto = @codProducto AND marcaBaja = 0;

				IF(@entero = 0)
				BEGIN
					INSERT INTO tblInventario (codAlmacen, codProducto, stock, usuario, ip, mac, fechaProceso, horaProceso)
					VALUES (2, @codProducto, @cantidadUnidadBase, 'MASTER', @p_ip, @p_mac, (SELECT CONVERT (date, GETDATE(), 5) ), (select convert(char(8), getdate(), 108) as [hh:mm:ss]));
				END
				ELSE
				BEGIN
					UPDATE tblInventario SET stock = stock + @cantidadUnidadBase 
					WHERE codAlmacen = 2 AND codProducto = @codProducto AND marcaBaja = 0;
				END	
				FETCH NEXT FROM cur_stock INTO @cantidadUnidadBase, @codProducto;
			END
		CLOSE cur_stock;
		DEALLOCATE cur_stock;

		SELECT @flag as flag, @ntraNC AS ntraNC, @msje as msje
		COMMIT TRANSACTION
	
	END TRY

	BEGIN CATCH
		IF (XACT_STATE()) <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END
		SET @flag = ERROR_NUMBER();
		SET @msje = 'Error en pa_notacredito_registrar_nc_parcial ' + ERROR_MESSAGE();
		SELECT @flag as flag, 0 AS ntraNC, @msje as msje
	END CATCH
END
GO