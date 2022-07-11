
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_registrar_modificar_preventa' AND type = 'P')
DROP PROCEDURE pa_registrar_modificar_preventa
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 30/01/2020
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripcion: Registrar y modificar preventa
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_registrar_modificar_preventa
(
	@p_proceso TINYINT,				--proceso 1:registro 2:modificacion
	@p_ntraPreventa INT,			--ntra preventa
	@p_codCliente INT,				--codigo cliente
	@p_codUsuario INT,				--codigo de usuario
	@p_codPuntoEntrega INT,			--codigo punto de entrega
	@p_tipoMoneda TINYINT,			--moneda
	@p_tipoVenta TINYINT,			--tipo de venta
	@p_tipoDocumentoVenta TINYINT,	--tipo documento venta
	@p_fecha DATE,			--fecha
	@p_fechaEntrega DATE,	--fecha entrega
	@p_fechaPago DATE,		--fecha pago
	@p_flagRecargo TINYINT,			--flag recargo
	@p_recargo MONEY,				--recargo
	@p_igv MONEY,					--igv
	@p_isc MONEY,					--isc
	@p_total MONEY,					--total
	@p_estado TINYINT,				--estado
	@p_origenVenta TINYINT,			--origen venta
	@p_listaDetalles XML,			--lista de detalle de preventa
	@p_listaPreventaPromocion XML = NULL,			--lista preventa promocion
	@p_listaPreventaDescuento XML = NULL,			--lista preventa descuento
	@p_usuario VARCHAR(20),					--usuario
	@p_ip VARCHAR(20),						--direccion ip
	@p_mac VARCHAR(20),						--mac
	@p_horaEntrega TIME(0),				--horaEntrega
	@p_codSucursal INT						--codSucursal
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @flag INT;						--flag de proceso
	DECLARE @msje VARCHAR(250);				--mensaje de error
	DECLARE @ntra INT;						--numero de transaccion
	DECLARE @itemPreventa TINYINT;			--item preventa
	DECLARE @codPresentacion INT;			--codigo presentacion
	DECLARE @codProducto VARCHAR(20);		--codigo producto
	DECLARE @codAlmacen INT;				--codigo almacen
	DECLARE @cantidadPresentacion INT;		--cantidad presentacion
	DECLARE @cantidadUnidadBase INT;		--cantidad unidad base
	DECLARE @precioVenta MONEY;				--precio venta
	DECLARE @tipoProducto TINYINT;			--tipo producto
	
	DECLARE @codPromocion INT;				--codigo de promocion
	DECLARE @itemPromocionado TINYINT;		--item promocionado
	DECLARE @codDescuento INT;				--codigo de descuento
	DECLARE @importe MONEY;					--importe

	SET @flag = 0;
	SET @msje = 'Exito';
	SET @ntra = 0;
	SET @itemPreventa = 0;
	SET @codPresentacion = 0;
	SET @codProducto = '';
	SET @codAlmacen = 0;
	SET @cantidadPresentacion = 0;
	SET @cantidadUnidadBase = 0;
	SET @precioVenta = 0;
	SET @tipoProducto = 0;
	
	SET @codPromocion = 0;
	SET @itemPromocionado = 0;
	SET @codDescuento = 0;
	SET @importe = 0;

	BEGIN TRY
		IF(@p_proceso = 1)		--proceso registro
		BEGIN
			BEGIN TRANSACTION
				INSERT INTO tblPreventa(codCliente, codUsuario, codPuntoEntrega, tipoMoneda, tipoVenta, tipoDocumentoVenta, 
				fecha, fechaEntrega, fechaPago, flagRecargo, recargo, igv, isc, total, estado, marcaBaja, usuario, ip, mac, 
				origenVenta, horaEntrega, codSucursal)
				VALUES (@p_codCliente, @p_codUsuario, @p_codPuntoEntrega, @p_tipoMoneda, @p_tipoVenta, @p_tipoDocumentoVenta, 
				@p_fecha, @p_fechaEntrega, null, @p_flagRecargo, @p_recargo, @p_igv, @p_isc, @p_total, @p_estado, 0, @p_usuario, 
				@p_ip, @p_mac, @p_origenVenta, @p_horaEntrega, @p_codSucursal);
				

				SET @ntra = (SELECT @@IDENTITY);

				DECLARE cur_detalle CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
				SELECT cast(colx.query('data(itemPreventa)') as varchar), cast(colx.query('data(codPresentacion)') as varchar), 
				cast(colx.query('data(codProducto)') as varchar), cast(colx.query('data(codAlmacen)') as varchar), 
				cast(colx.query('data(cantidadPresentacion)') as varchar), cast(colx.query('data(cantidadUnidadBase)') as varchar), 
				cast(colx.query('data(precioVenta)') as varchar), cast(colx.query('data(TipoProducto)') as varchar) 
				FROM @p_listaDetalles.nodes('ArrayOfCEN_Detalle_Preventa/CEN_Detalle_Preventa') AS Tabx(Colx)              
				OPEN cur_detalle;  
				FETCH NEXT FROM cur_detalle INTO @itemPreventa, @codPresentacion, @codProducto, @codAlmacen,
				@cantidadPresentacion, @cantidadUnidadBase, @precioVenta, @tipoProducto;
				WHILE @@FETCH_STATUS = 0
					BEGIN
						INSERT INTO tblDetallePreventa( codPreventa, itemPreventa, codPresentacion, codProducto, codAlmacen,
						cantidadPresentacion, cantidadUnidadBase, precioVenta, TipoProducto, marcaBaja, usuario, ip, mac)
						VALUES( @ntra, @itemPreventa, @codPresentacion, @codProducto, @codAlmacen, @cantidadPresentacion,
						@cantidadUnidadBase, @precioVenta, @tipoProducto, 0, @p_usuario, @p_ip, @p_mac);
						
						--Disminuir stock
						UPDATE tblInventario SET stock = stock - @cantidadUnidadBase 
						WHERE codAlmacen = @codAlmacen AND codProducto = @codProducto AND marcaBaja = 0;

						FETCH NEXT FROM cur_detalle INTO @itemPreventa, @codPresentacion, @codProducto, @codAlmacen,
				@cantidadPresentacion, @cantidadUnidadBase, @precioVenta, @tipoProducto;
					END
				CLOSE cur_detalle;  
				DEALLOCATE cur_detalle;

				--Preventa Promocion
				SET @itemPreventa = 0;
				
				IF(NOT @p_listaPreventaPromocion IS NULL)
				BEGIN
					DECLARE cur_promocion CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
					SELECT cast(colx.query('data(codPromocion)') as varchar), cast(colx.query('data(itemPreventa)') as varchar), 
					cast(colx.query('data(itemPromocionado)') as varchar)
					FROM @p_listaPreventaPromocion.nodes('ArrayOfCEN_Preventa_Promocion/CEN_Preventa_Promocion') AS Tabx(Colx)              
					OPEN cur_promocion;  
					FETCH NEXT FROM cur_promocion INTO @codPromocion, @itemPreventa, @itemPromocionado
					WHILE @@FETCH_STATUS = 0
						BEGIN
							INSERT INTO tblPreventaPromocion(codPreventa, codPromocion, itemPreventa, itemPromocionado, usuario, ip, mac)
							VALUES( @ntra, @codPromocion, @itemPreventa, @itemPromocionado, @p_usuario, @p_ip, @p_mac);
						
							FETCH NEXT FROM cur_promocion INTO @codPromocion, @itemPreventa, @itemPromocionado;
						END
					CLOSE cur_promocion;  
					DEALLOCATE cur_promocion;
				END
				
				--Preventa Descuento
				SET @itemPreventa = 0;
				
				IF(NOT @p_listaPreventaDescuento IS NULL)
				BEGIN
					DECLARE cur_descuento CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
					SELECT cast(colx.query('data(codDescuento)') as varchar), cast(colx.query('data(itemPreventa)') as varchar),
					cast(colx.query('data(importe)') as varchar)
					FROM @p_listaPreventaDescuento.nodes('ArrayOfCEN_Preventa_Descuento/CEN_Preventa_Descuento') AS Tabx(Colx)

					OPEN cur_descuento;  
					FETCH NEXT FROM cur_descuento INTO @codDescuento, @itemPreventa, @importe
					WHILE @@FETCH_STATUS = 0
						BEGIN
							INSERT INTO tblPreventaDescuento(codPreventa, codDescuento, itemPreventa, importe, usuario, ip, mac)
							VALUES( @ntra, @codDescuento, @itemPreventa, @importe, @p_usuario, @p_ip, @p_mac);
						
							FETCH NEXT FROM cur_descuento INTO  @codDescuento, @itemPreventa, @importe;
						END
					CLOSE cur_descuento;  
					DEALLOCATE cur_descuento;
				END
				

			COMMIT TRANSACTION
		END
		ELSE
		BEGIN
			IF(@p_proceso = 2) --proceso modificacion
			BEGIN
				BEGIN TRANSACTION
					--ACTUALIZAR PREVENTA
					UPDATE tblPreventa SET tipoVenta = @p_tipoVenta, tipoDocumentoVenta = @p_tipoDocumentoVenta,
					flagRecargo = @p_flagRecargo, recargo = @p_recargo, fechaEntrega = @p_fechaEntrega,
					igv = @p_igv, total = @p_total, codPuntoEntrega = @p_codPuntoEntrega, horaEntrega = @p_horaEntrega
					WHERE ntraPreventa = @p_ntraPreventa;

					SET @cantidadUnidadBase = 0;
					SET @codAlmacen = 0;
					SET @codProducto = 0;
					--REVERSION DE STOCKS
					DECLARE cur_stock CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
					SELECT cantidadUnidadBase, codAlmacen, codProducto
					FROM tblDetallePreventa WHERE codPreventa = @p_ntraPreventa
					OPEN cur_stock;  
					FETCH NEXT FROM cur_stock INTO @cantidadUnidadBase, @codAlmacen, @codProducto
					WHILE @@FETCH_STATUS = 0
						BEGIN
							UPDATE tblInventario SET stock = stock + @cantidadUnidadBase 
							WHERE codAlmacen = @codAlmacen AND codProducto = @codProducto AND marcaBaja = 0;
						
							FETCH NEXT FROM cur_stock INTO @cantidadUnidadBase, @codAlmacen, @codProducto;
						END
					CLOSE cur_stock;
					DEALLOCATE cur_stock;

					--DAR BAJA A DETALLES, PREVENTA PROMOCION Y PREVENTA DESCUENTO
					DELETE FROM tblPreventaPromocion WHERE codPreventa = @p_ntraPreventa AND marcaBaja = 0;
					DELETE FROM tblPreventaDescuento WHERE codPreventa = @p_ntraPreventa AND marcaBaja = 0;
					DELETE FROM tblDetallePreventa WHERE codPreventa = @p_ntraPreventa AND marcaBaja = 0;
					/*UPDATE tblDetallePreventa SET marcaBaja = 9 WHERE codPreventa = @p_ntraPreventa AND marcaBaja = 0;
					UPDATE tblPreventaPromocion SET marcaBaja = 9 WHERE codPreventa = @p_ntraPreventa AND marcaBaja = 0;
					UPDATE tblPreventaDescuento SET marcaBaja = 9 WHERE codPreventa = @p_ntraPreventa AND marcaBaja = 0;*/

					--DETALLES
					SET @cantidadUnidadBase = 0;
					SET @codAlmacen = 0;
					SET @codProducto = 0;
					DECLARE cur_detalle CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
					SELECT cast(colx.query('data(itemPreventa)') as varchar), cast(colx.query('data(codPresentacion)') as varchar), 
					cast(colx.query('data(codProducto)') as varchar), cast(colx.query('data(codAlmacen)') as varchar), 
					cast(colx.query('data(cantidadPresentacion)') as varchar), cast(colx.query('data(cantidadUnidadBase)') as varchar), 
					cast(colx.query('data(precioVenta)') as varchar), cast(colx.query('data(TipoProducto)') as varchar) 
					FROM @p_listaDetalles.nodes('ArrayOfCEN_Detalle_Preventa/CEN_Detalle_Preventa') AS Tabx(Colx)              
					OPEN cur_detalle;  
					FETCH NEXT FROM cur_detalle INTO @itemPreventa, @codPresentacion, @codProducto, @codAlmacen,
					@cantidadPresentacion, @cantidadUnidadBase, @precioVenta, @tipoProducto;
					WHILE @@FETCH_STATUS = 0
						BEGIN
							INSERT INTO tblDetallePreventa( codPreventa, itemPreventa, codPresentacion, codProducto, codAlmacen,
							cantidadPresentacion, cantidadUnidadBase, precioVenta, TipoProducto, marcaBaja, usuario, ip, mac)
							VALUES( @p_ntraPreventa, @itemPreventa, @codPresentacion, @codProducto, @codAlmacen, @cantidadPresentacion,
							@cantidadUnidadBase, @precioVenta, @tipoProducto, 0, @p_usuario, @p_ip, @p_mac);
						
							--DISMINUIR STOCK
							UPDATE tblInventario SET stock = stock - @cantidadUnidadBase 
							WHERE codAlmacen = @codAlmacen AND codProducto = @codProducto AND marcaBaja = 0;

							FETCH NEXT FROM cur_detalle INTO @itemPreventa, @codPresentacion, @codProducto, @codAlmacen,
						@cantidadPresentacion, @cantidadUnidadBase, @precioVenta, @tipoProducto;
						END
					CLOSE cur_detalle;  
					DEALLOCATE cur_detalle;

					--PREVENTA PROMOCION
					SET @itemPreventa = 0;
					IF(NOT @p_listaPreventaPromocion IS NULL)
					BEGIN
						DECLARE cur_promocion CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
						SELECT cast(colx.query('data(codPromocion)') as varchar), cast(colx.query('data(itemPreventa)') as varchar), 
						cast(colx.query('data(itemPromocionado)') as varchar)
						FROM @p_listaPreventaPromocion.nodes('ArrayOfCEN_Preventa_Promocion/CEN_Preventa_Promocion') AS Tabx(Colx)              
						OPEN cur_promocion;  
						FETCH NEXT FROM cur_promocion INTO @codPromocion, @itemPreventa, @itemPromocionado
						WHILE @@FETCH_STATUS = 0
							BEGIN
								INSERT INTO tblPreventaPromocion(codPreventa, codPromocion, itemPreventa, itemPromocionado, usuario, ip, mac)
								VALUES( @p_ntraPreventa, @codPromocion, @itemPreventa, @itemPromocionado, @p_usuario, @p_ip, @p_mac);
						
								FETCH NEXT FROM cur_promocion INTO @codPromocion, @itemPreventa, @itemPromocionado;
							END
						CLOSE cur_promocion;  
						DEALLOCATE cur_promocion;
					END

					--PREVENTA DESCUENTO
					SET @itemPreventa = 0;
					IF(NOT @p_listaPreventaDescuento IS NULL)
					BEGIN
						DECLARE cur_descuento CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
						SELECT cast(colx.query('data(codDescuento)') as varchar), cast(colx.query('data(itemPreventa)') as varchar),
						cast(colx.query('data(importe)') as varchar)
						FROM @p_listaPreventaDescuento.nodes('ArrayOfCEN_Preventa_Descuento/CEN_Preventa_Descuento') AS Tabx(Colx)

						OPEN cur_descuento;  
						FETCH NEXT FROM cur_descuento INTO @codDescuento, @itemPreventa, @importe
						WHILE @@FETCH_STATUS = 0
							BEGIN
								INSERT INTO tblPreventaDescuento(codPreventa, codDescuento, itemPreventa, importe, usuario, ip, mac)
								VALUES( @p_ntraPreventa, @codDescuento, @itemPreventa, @importe, @p_usuario, @p_ip, @p_mac);
						
								FETCH NEXT FROM cur_descuento INTO  @codDescuento, @itemPreventa, @importe;
							END
						CLOSE cur_descuento;  
						DEALLOCATE cur_descuento;
					END

					SET @ntra = @p_ntraPreventa;
				COMMIT TRANSACTION
			END
		END

		SELECT @flag as flag , @msje as msje, @ntra as ntraPreventa
	END TRY
	BEGIN CATCH
		IF (XACT_STATE()) <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END
		SET @flag = ERROR_NUMBER();
		SET @msje = 'Error en pa_registrar_modificar_preventa ' + ERROR_MESSAGE();
		SELECT @flag as flag , @msje as msje, @ntra as ntraPreventa
	END CATCH
END
GO