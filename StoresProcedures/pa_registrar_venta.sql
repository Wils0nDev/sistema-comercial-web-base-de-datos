IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_registrar_venta' AND type = 'P')
	DROP PROCEDURE pa_registrar_venta
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 30/01/2020
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripcion: Registrar venta
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_registrar_venta]
(
	-- # @p_serie varchar(20),				-- serie
	-- #@p_nroDocumento INT,			--Numero de documento de venta
	@p_tipoPago SMALLINT,				--Tipo de pago
	@p_codPreventa INT,				--codigo de preventa
	@p_codCliente INT,			--codigo cliente
	@p_codVendedor INT,			--codigo de vendedor
	@p_fechaTransaccion DATE,			--Fecha de transaccion
	@p_tipoMoneda SMALLINT,	--tipo moneda
	@p_tipoVenta SMALLINT,			--Tipo de venta
	@p_tipoCambio SMALLINT,			--Tipo de cambio
	@p_estado SMALLINT,	--Estado
	@p_importeTotal MONEY,		--Importe total
	@p_importeRecargo MONEY,			--Importe recargo
	@p_usuario varchar(20),				--Usuario
	@p_ip varchar(20),					--ip
	@p_mac varchar(20),					--mac
	@p_prestamo XML = NULL,			--lista preventa promocion
	@p_listaCronograma XML = NULL,			--lista preventa descuento
	@p_proceso SMALLINT,
	@p_codSucursal INT,						--codSucursal
	@p_fechaPago DATE,						--Fecha de pago
	@p_prFechaTrans DATETIME,						--Fecha de transaccion
	@p_cuentaCobro XML = NULL, -- Cuenta de pago
	@p_IGV MONEY,		--Importe total
	@p_tipoDocVenta tinyint, --Tipo de documento de venta
	@p_codPuntoEntrega INT, -- Codigo de punto de entrega
	@p_est_reg_cue_cob INT -- Estado para registro de Cuenta de cobro ( 1: si, 0: no)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @p_serie varchar(20); -- SERIE
	DECLARE @p_nroDocumento INT; --Numero de documento para la venta
	
	
	DECLARE @flag INT;						--flag de proceso
	DECLARE @msje VARCHAR(250);				--mensaje de error
	DECLARE @ntra INT;						--numero de transaccion
	DECLARE @ntraPrestamo INT; -- numero de transaccion de prestamo
	-- Prestamo
	DECLARE @pr_importeTotal MONEY;
	DECLARE @pr_interesTotal MONEY;
	DECLARE @pr_plazo INT;
	DECLARE @pr_nroCuotas INT;
	DECLARE @pr_fechaTransaccion DATETIME;
	DECLARE @pr_tipoPrestamo SMALLINT;
	DECLARE @pr_estado SMALLINT;
	-- Cronograma
	DECLARE @cr_fechaPago DATE;
	DECLARE @cr_nroCuota INT;
	DECLARE @cr_importe MONEY;
	DECLARE @cr_estado INT;
	-- Cuenta de cobro
	DECLARE @cu_fechaPago DATE;
	DECLARE @cu_fechaTrans DATE;
	DECLARE @cu_horaTrans varchar(8);
	DECLARE @cu_importe MONEY;
	DECLARE @cu_estado SMALLINT;
	DECLARE @cu_responsable varchar(250);
	-- Detalle de preventa
	DECLARE @dp_itemPreventa tinyint;
	DECLARE @dp_codPresentacion INT;
	DECLARE @dp_codProducto varchar(10);
	DECLARE @dp_codAlmacen INT;
	DECLARE @dp_cantidadPresentacion INT;
	DECLARE @dp_cantidadUnidadBase INT;
	DECLARE @dp_precioVenta MONEY;
	DECLARE @dp_TipoProducto tinyint;
	-- Preventa promocion
	DECLARE @vp_codPromocion INT;
	DECLARE @vp_itemPreventa tinyint;
	DECLARE @vp_itemPromocionado tinyint;
	-- Preventa descuento
	DECLARE @vd_codDescuento INT;
	DECLARE @vd_itemPreventa tinyint;
	DECLARE @vd_importe MONEY;
	
	

	SET @p_serie = '';
	SET @p_nroDocumento = 0;
	

	SET @flag = 0;
	SET @msje = 'Venta registrada con exito';
	SET @ntra = 0;
	SET @ntraPrestamo = 0;
	
	SET @pr_importeTotal = 0;
	SET @pr_interesTotal = 0;
	SET @pr_plazo = 0;
	SET @pr_nroCuotas = 0;
	--SET @pr_fechaTransaccion = GETDATE() ;
	SET @pr_tipoPrestamo = 0;
	
	-- SET @cr_fechaPago DATE;
	SET @cr_nroCuota  = 0;
	SET @cr_importe  = 0;
	SET @cr_estado  = 0;
	
	BEGIN TRY
		IF(@p_proceso = 1)		--proceso registro
		BEGIN
			BEGIN TRANSACTION
			
				-- Buscamos la serie y numero de documento por sucursal
				IF @p_tipoDocVenta = 1
					BEGIN
						-- boleta
						SELECT @p_nroDocumento = correlativoB,@p_serie = serieB FROM tblSerieVenta where codSucursal = @p_codSucursal AND marcaBaja = 0
						SET @p_nroDocumento = @p_nroDocumento + 1
					END	
				
				IF @p_tipoDocVenta = 2
					BEGIN
						-- factura
						SELECT @p_nroDocumento = correlativoF,@p_serie = serieF FROM tblSerieVenta where codSucursal = @p_codSucursal AND marcaBaja = 0
						SET @p_nroDocumento = @p_nroDocumento + 1
					END	
			
				INSERT INTO tblVenta(serie, nroDocumento,tipoPago,codPreventa,codCliente,codVendedor,fechaTransaccion,tipoMoneda,
														tipoCambio,estado,importeTotal,importeRecargo,tipoVenta,codSucursal,IGV,fechaPago,tipoDocumentoVenta,codPuntoEntrega,usuario,ip,mac)
				VALUES (@p_serie, @p_nroDocumento,@p_tipoPago,@p_codPreventa,@p_codCliente,@p_codVendedor,@p_fechaTransaccion,@p_tipoMoneda,
														@p_tipoCambio,@p_estado,@p_importeTotal,@p_importeRecargo,@p_tipoVenta,@p_codSucursal,@p_IGV,@p_fechaPago,@p_tipoDocVenta,@p_codPuntoEntrega,@p_usuario,@p_ip,@p_mac);
				

				SET @ntra = (SELECT @@IDENTITY);
				
				-- Registro de detalle de productos de venta
				
				DECLARE cur_detalle_prev CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
				SELECT itemPreventa, codPresentacion, codProducto, codAlmacen, cantidadPresentacion, cantidadUnidadBase, precioVenta, TipoProducto 
				FROM tblDetallePreventa WHERE codPreventa =  @p_codPreventa AND marcaBaja = 0            
				OPEN cur_detalle_prev;  
				FETCH NEXT FROM cur_detalle_prev INTO @dp_itemPreventa, @dp_codPresentacion, @dp_codProducto, @dp_codAlmacen, @dp_cantidadPresentacion,
																						 @dp_cantidadUnidadBase, @dp_precioVenta, @dp_TipoProducto;
				WHILE @@FETCH_STATUS = 0
					BEGIN
					
						INSERT INTO tblDetalleVenta(codVenta, itemVenta, codPresentacion, codProducto, codAlmacen, cantidadPresentacion, cantidadUnidadBase, precioVenta, TipoProducto, usuario, ip, mac)
						VALUES(@ntra,@dp_itemPreventa,@dp_codPresentacion,@dp_codProducto,@dp_codAlmacen,@dp_cantidadPresentacion,@dp_cantidadUnidadBase,@dp_precioVenta,@dp_TipoProducto,@p_usuario,@p_ip,@p_mac)
						
						FETCH NEXT FROM cur_detalle_prev INTO @dp_itemPreventa, @dp_codPresentacion, @dp_codProducto, @dp_codAlmacen, @dp_cantidadPresentacion,
																						 @dp_cantidadUnidadBase, @dp_precioVenta, @dp_TipoProducto;

					END
				CLOSE cur_detalle_prev;  
				DEALLOCATE cur_detalle_prev; 
				
				-- Registro de promociones venta
				
				DECLARE cur_prev_promo CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
				SELECT codPromocion, itemPreventa, itemPromocionado 
				FROM tblPreventaPromocion WHERE codPreventa =  @p_codPreventa AND marcaBaja = 0            
				OPEN cur_prev_promo;  
				FETCH NEXT FROM cur_prev_promo INTO @vp_codPromocion, @vp_itemPreventa, @vp_itemPromocionado;
				WHILE @@FETCH_STATUS = 0
					BEGIN
						
						INSERT INTO tblVentaPromocion (codVenta, codPromocion, itemVenta, itemPromocionado, usuario, ip, mac)
						VALUES(@ntra,@vp_codPromocion,@vp_itemPreventa,@vp_itemPromocionado,@p_usuario,@p_ip,@p_mac)

						FETCH NEXT FROM cur_prev_promo INTO @vp_codPromocion, @vp_itemPreventa, @vp_itemPromocionado;

					END
				CLOSE cur_prev_promo;  
				DEALLOCATE cur_prev_promo;
				
				-- Registro de descuentos venta
				
				DECLARE cur_prev_desc CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
				SELECT codDescuento, itemPreventa, importe
				FROM tblPreventaDescuento WHERE codPreventa =  @p_codPreventa AND marcaBaja = 0            
				OPEN cur_prev_desc;  
				FETCH NEXT FROM cur_prev_desc INTO @vd_codDescuento, @vd_itemPreventa, @vd_importe;
				WHILE @@FETCH_STATUS = 0
					BEGIN
						 
						 INSERT INTO tblVentaDescuento (codVenta, codDescuento, itemVenta, importe, usuario, ip, mac)
						 VALUES(@ntra,@vd_codDescuento, @vd_itemPreventa, @vd_importe,@p_usuario,@p_ip,@p_mac)

						FETCH NEXT FROM cur_prev_desc INTO @vd_codDescuento, @vd_itemPreventa, @vd_importe;

					END
				CLOSE cur_prev_desc;  
				DEALLOCATE cur_prev_desc;
				
				IF @p_tipoVenta = 2 
					BEGIN
						SET @pr_importeTotal = cast(@p_prestamo.query('data(CENPrestamo/importeTotal)') as varchar)
						SET @pr_interesTotal = cast(@p_prestamo.query('data(CENPrestamo/interesTotal)') as varchar)
						SET @pr_plazo = cast(@p_prestamo.query('data(CENPrestamo/plazo)') as varchar)
						SET @pr_nroCuotas = cast(@p_prestamo.query('data(CENPrestamo/nroCuotas)') as varchar)
						--SET @pr_fechaTransaccion = cast(@p_prestamo.query('data(CENPrestamo/fechaTransaccion)') as varchar)
						SET @pr_tipoPrestamo = cast(@p_prestamo.query('data(CENPrestamo/tipoPrestamo)') as varchar)
						SET @pr_estado = cast(@p_prestamo.query('data(CENPrestamo/estado)') as varchar)
						
						INSERT INTO tblPrestamo (codVenta, importeTotal, interesTotal, plazo, nroCuotas, fechaTransaccion, tipoPrestamo,estado,usuario, ip, mac)
						VALUES(@ntra,@pr_importeTotal,@pr_interesTotal,@pr_plazo,@pr_nroCuotas,@p_prFechaTrans,@pr_tipoPrestamo,@pr_estado,@p_usuario,@p_ip,@p_mac);
						
						SET @ntraPrestamo = (SELECT @@IDENTITY);
						
						-- Registro de cronograma
						
						IF(NOT @p_listaCronograma IS NULL)
						BEGIN
						
								DECLARE cur_detalle CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
								SELECT cast(colx.query('data(fechaPago)') as varchar), cast(colx.query('data(nroCuota)') as varchar), 
								cast(colx.query('data(importe)') as varchar), cast(colx.query('data(estado)') as varchar) 
								FROM @p_listaCronograma.nodes('ArrayOfCENCronograma/CENCronograma') AS Tabx(Colx)              
								OPEN cur_detalle;  
								FETCH NEXT FROM cur_detalle INTO @cr_fechaPago, @cr_nroCuota, @cr_importe, @cr_estado;
								WHILE @@FETCH_STATUS = 0
									BEGIN
									
									
										INSERT INTO tblCronograma(codPrestamo, fechaPago, nroCuota, importe, estado, usuario, ip, mac)
										VALUES(@ntraPrestamo,@cr_fechaPago,@cr_nroCuota,@cr_importe,@cr_estado,@p_usuario,@p_ip,@p_mac)
										
										FETCH NEXT FROM cur_detalle INTO @cr_fechaPago, @cr_nroCuota, @cr_importe, @cr_estado;
		
									END
								CLOSE cur_detalle;  
								DEALLOCATE cur_detalle; 
						END
						
					END
				-- Actualizamos las series
				IF @p_tipoVenta = 1
					BEGIN
						UPDATE tblSerieVenta SET correlativoB = @p_nroDocumento WHERE codSucursal = @p_codSucursal AND marcaBaja = 0
					END
				IF @p_tipoVenta = 2
					BEGIN
						UPDATE tblSerieVenta SET correlativoF = @p_nroDocumento WHERE codSucursal = @p_codSucursal AND marcaBaja = 0
					END
					
				-- Registro pendiente de pago
				IF @p_est_reg_cue_cob = 1
					BEGIN
					
						SET @cu_fechaPago = cast(@p_cuentaCobro.query('data(CEN_CuentaCobro/fechaCobro)') as varchar)
						-- SET @cu_fechaTrans = GETDATE() -- cast(@p_cuentaCobro.query('data(CEN_CuentaCobro/fechaTransaccion)') as varchar)
						SET @cu_horaTrans = cast(@p_cuentaCobro.query('data(CEN_CuentaCobro/horaTransaccion)') as varchar)
						SET @cu_importe = cast(@p_cuentaCobro.query('data(CEN_CuentaCobro/importe)') as varchar)
						SET @cu_estado = cast(@p_cuentaCobro.query('data(CEN_CuentaCobro/estado)') as varchar)
						SET @cu_responsable = cast(@p_cuentaCobro.query('data(CEN_CuentaCobro/responsable)') as varchar)
	
						INSERT INTO tblCuentaCobro (codOperacion, codModulo, prefijo, correlativo, importe, fechaTransaccion, horaTransaccion, fechaCobro, estado, responsable, usuario, ip, mac)
						VALUES(@ntra,1,1,1,@cu_importe,@p_fechaTransaccion,@cu_horaTrans,@cu_fechaPago,@cu_estado,@cu_responsable,@p_usuario,@p_ip,@p_mac)
					END
					
				-- Cambiar estado de la preventa a facturada - estado 3
				UPDATE tblPreventa SET estado = 3 WHERE ntraPreventa = @p_codPreventa
				
				
				
			COMMIT TRANSACTION
		END
	
		SET @msje = CONCAT(@msje, '. Venta nro ', @ntra)
		SELECT @flag as flag , @msje as msje, @ntra as venta,@p_serie as serie,@p_nroDocumento as nroDocumento
	END TRY
	BEGIN CATCH
		IF (XACT_STATE()) <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END
		SET @ntra = 0;
		SET @flag = -1;
		SET @msje = 'Error en pa_registrar_venta ' + ERROR_MESSAGE();
		SELECT @flag as flag , @msje as msje, @ntra as venta,'' as serie,0 as nroDocumento
	END CATCH
END
GO
