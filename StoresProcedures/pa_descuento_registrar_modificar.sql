IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_descuento_registrar_modificar' AND type = 'P')
	DROP PROCEDURE pa_descuento_registrar_modificar
GO
----------------------------------------------------------------------------------
-- Author: Diego Sanchez IDE-SOLUTION
-- Created: 28/03/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen.
-- Descripción: Registrar y modificar descuento
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_descuento_registrar_modificar]
@proceso int,	-- 1 = Registrar ; 2 = Modificar

@fechaVigenciaI DATE,
@fechaVigenciaF DATE,
@horaI TIME(0),
@horaF TIME(0),
@estado int,

@codTipo_venta int,
@codProducto varchar(10),
@codUnidadBase int,
@codCantidad int,
@tipoCant int,
@codMonto decimal,
@codTipoMonto int,

@codVendedorReg int,
@codCliente_reg int,
@cod_veces_dec int,
@cod_veces_vend int,
@cod_veces_clie int,
@descripcion varchar(250),

@ntraDescuento int

AS
BEGIN
	
	DECLARE @msj VARCHAR(150)
	DECLARE @ntraDescu int
	DECLARE @flag9 int
	DECLARE @flag int
	SET @flag9 = 0
	
	BEGIN TRY
		IF (@proceso = 1)		--REGISTRAR
		BEGIN
			BEGIN TRANSACTION
				--CABECERA DE DESCUENTOS
				BEGIN
					INSERT INTO tblDescuentos(descripcion, fechaInicial, fechaFin, horaInicial, horaFin, tipoDescuento, estado, usuario)
					VALUES(@descripcion, @fechaVigenciaI,@fechaVigenciaF,@horaI,@horaF, 1, @estado,'EAY');
				END
				BEGIN
					SET @ntraDescu = (SELECT @@IDENTITY);
				END

				--Flag 1
				BEGIN
					INSERT INTO tblDetalleDescuentos(ntraDescuento, flag, descripcion, valorInicial, valorFinal, detalle, estado, usuario)
					VALUES(@ntraDescu, 1,'PRODUCTO CON DESCUENTO', @codProducto, '', 0, 1,'EAY');
				END

				--Flag 2
				BEGIN
					INSERT INTO tblDetalleDescuentos(ntraDescuento, flag, descripcion, valorInicial, valorFinal, detalle, estado, usuario)
					VALUES(@ntraDescu, 2,'CANTIDAD O IMPORTE DEL PRODUCTO CON DESCUENTO', CONVERT(VARCHAR,@codCantidad), CONVERT(VARCHAR,@tipoCant), 0, 1,'EAY');
				END

				--Flag 3
				BEGIN
					INSERT INTO tblDetalleDescuentos(ntraDescuento, flag, descripcion, valorInicial, valorFinal, detalle, estado, usuario)
					VALUES(@ntraDescu, 3,'VALOR A DESCONTAR', CONVERT(VARCHAR,@codMonto), CONVERT(VARCHAR,@codTipoMonto), 0, 1,'EAY');
				END

				--Flag 4
				IF @codVendedorReg != 0
				BEGIN
					INSERT INTO tblDetalleDescuentos(ntraDescuento, flag, descripcion, valorInicial, valorFinal, detalle, estado, usuario)
					VALUES(@ntraDescu, 4,'VENDEDOR APLICA A DESCUENTO', CONVERT(VARCHAR,@codVendedorReg), '', 0, 1,'EAY'); 
				END

				--Flag 5
				IF @codCliente_reg != 0
				BEGIN
					INSERT INTO tblDetalleDescuentos(ntraDescuento, flag, descripcion, valorInicial, valorFinal, detalle, estado, usuario)
					VALUES(@ntraDescu, 5,'CLIENTE APLICA A DESCUENTO', CONVERT(VARCHAR,@codCliente_reg), '', 0, 1,'EAY'); 
				END

				--Flag 6
				IF @cod_veces_dec != 0
				BEGIN
					INSERT INTO tblDetalleDescuentos(ntraDescuento, flag, descripcion, valorInicial, valorFinal, detalle, estado, usuario)
					VALUES(@ntraDescu, 6,'VECES QUE SE PUEDE USAR EL DESCUENTO', CONVERT(VARCHAR,@cod_veces_dec), '', 0, 1,'EAY'); 
				END

				--Flag 7
				IF @cod_veces_vend != 0
				BEGIN
					INSERT INTO tblDetalleDescuentos(ntraDescuento, flag, descripcion, valorInicial, valorFinal, detalle, estado, usuario)
					VALUES(@ntraDescu, 7,'VECES QUE VENDEDOR PUEDE USAR EL DESCUENTO', CONVERT(VARCHAR,@cod_veces_vend), '', 0, 1,'EAY'); 
				END

				--Flag 8
				IF @cod_veces_clie != 0
				BEGIN
					INSERT INTO tblDetalleDescuentos(ntraDescuento, flag, descripcion, valorInicial, valorFinal, detalle, estado, usuario)
					VALUES(@ntraDescu, 8,'VECES QUE CLIENTE PUEDE USAR EL DESCUENTO', CONVERT(VARCHAR,@cod_veces_clie), '', 0, 1,'EAY'); 
				END

				--Flag 9
				IF @flag9 != 0
				BEGIN
					INSERT INTO tblDetalleDescuentos(ntraDescuento, flag, descripcion, valorInicial, valorFinal, detalle, estado, usuario)
					VALUES(@ntraDescu, 9,'IMPORTE MINIMO PARA OBTENER DESCUENTO', '', '', 0, 1,'EAY');
				END

				--Flag 10
				IF @codTipo_venta != 0
				BEGIN
					INSERT INTO tblDetalleDescuentos(ntraDescuento, flag, descripcion, valorInicial, valorFinal, detalle, estado, usuario)
					VALUES(@ntraDescu, 10,'DESCUENTO PARA VENTA AL CONTADO O CREDITO', CONVERT(VARCHAR,@codTipo_venta), '', 0, 1,'EAY'); 
				END

				SET @msj = 'Se registro correctamente';
				SET @flag = 0;
			COMMIT TRANSACTION

			SELECT @flag as flag, @msj as mensaje, @ntraDescu as ntraDescuento

		END
		
		IF (@proceso = 2)		--Actualizar
		BEGIN
			BEGIN TRANSACTION
				SET @ntraDescu = @ntraDescuento;
					BEGIN
				--Actualizar el descuento
				update tblDescuentos set descripcion = @descripcion, fechaInicial = @fechaVigenciaI, fechaFin = @fechaVigenciaF, 
				horaInicial=@horaI, horaFin=@horaF, tipoDescuento=1,estado = @estado, usuario = 'EAY'
				where ntraDescuento = @ntraDescu;
					END
					BEGIN
				--Dar de baja al detalle de un descuento
				DELETE FROM tblDetalleDescuentos WHERE ntraDescuento = @ntraDescu AND marcaBaja = 0;
					END
				--Insertar el nuevo detalle del descuento
				--Flag 1
				BEGIN
					INSERT INTO tblDetalleDescuentos(ntraDescuento, flag, descripcion, valorInicial, valorFinal, detalle, estado, usuario)
					VALUES(@ntraDescu, 1,'PRODUCTO CON DESCUENTO', @codProducto, '', 0, 1,'EAY');
				END

				--Flag 2
				BEGIN
					INSERT INTO tblDetalleDescuentos(ntraDescuento, flag, descripcion, valorInicial, valorFinal, detalle, estado, usuario)
					VALUES(@ntraDescu, 2,'CANTIDAD O IMPORTE DEL PRODUCTO CON DESCUENTO', CONVERT(VARCHAR,@codCantidad), CONVERT(VARCHAR,@tipoCant), 0, 1,'EAY');
				END

				--Flag 3
				BEGIN
					INSERT INTO tblDetalleDescuentos(ntraDescuento, flag, descripcion, valorInicial, valorFinal, detalle, estado, usuario)
					VALUES(@ntraDescu, 3,'VALOR A DESCONTAR', CONVERT(VARCHAR,@codMonto), CONVERT(VARCHAR,@codTipoMonto), 0, 1,'EAY');
				END

				--Flag 4
				IF @codVendedorReg != 0
				BEGIN
					INSERT INTO tblDetalleDescuentos(ntraDescuento, flag, descripcion, valorInicial, valorFinal, detalle, estado, usuario)
					VALUES(@ntraDescu, 4,'VENDEDOR APLICA A DESCUENTO', CONVERT(VARCHAR,@codVendedorReg), '', 0, 1,'EAY'); 
				END

				--Flag 5
				IF @codCliente_reg != 0
				BEGIN
					INSERT INTO tblDetalleDescuentos(ntraDescuento, flag, descripcion, valorInicial, valorFinal, detalle, estado, usuario)
					VALUES(@ntraDescu, 5,'CLIENTE APLICA A DESCUENTO', CONVERT(VARCHAR,@codCliente_reg), '', 0, 1,'EAY'); 
				END

				--Flag 6
				IF @cod_veces_dec != 0
				BEGIN
					INSERT INTO tblDetalleDescuentos(ntraDescuento, flag, descripcion, valorInicial, valorFinal, detalle, estado, usuario)
					VALUES(@ntraDescu, 6,'VECES QUE SE PUEDE USAR EL DESCUENTO', CONVERT(VARCHAR,@cod_veces_dec), '', 0, 1,'EAY'); 
				END

				--Flag 7
				IF @cod_veces_vend != 0
				BEGIN
					INSERT INTO tblDetalleDescuentos(ntraDescuento, flag, descripcion, valorInicial, valorFinal, detalle, estado, usuario)
					VALUES(@ntraDescu, 7,'VECES QUE VENDEDOR PUEDE USAR EL DESCUENTO', CONVERT(VARCHAR,@cod_veces_vend), '', 0, 1,'EAY'); 
				END

				--Flag 8
				IF @cod_veces_clie != 0
				BEGIN
					INSERT INTO tblDetalleDescuentos(ntraDescuento, flag, descripcion, valorInicial, valorFinal, detalle, estado, usuario)
					VALUES(@ntraDescu, 8,'VECES QUE CLIENTE PUEDE USAR EL DESCUENTO', CONVERT(VARCHAR,@cod_veces_clie), '', 0, 1,'EAY'); 
				END

				--Flag 9
				IF @flag9 != 0
				BEGIN
					INSERT INTO tblDetalleDescuentos(ntraDescuento, flag, descripcion, valorInicial, valorFinal, detalle, estado, usuario)
					VALUES(@ntraDescu, 9,'IMPORTE MINIMO PARA OBTENER DESCUENTO', '', '', 0, 1,'EAY');
				END

				--Flag 10
				IF @codTipo_venta != 0
				BEGIN
					INSERT INTO tblDetalleDescuentos(ntraDescuento, flag, descripcion, valorInicial, valorFinal, detalle, estado, usuario)
					VALUES(@ntraDescu, 10,'DESCUENTO PARA VENTA AL CONTADO O CREDITO', CONVERT(VARCHAR,@codTipo_venta), '', 0, 1,'EAY'); 
				END

				SET @msj = 'Se actualizo correctamente ';
				SET @flag = 1
			COMMIT TRANSACTION
			SELECT @flag as flag, @msj as mensaje, @ntraDescu as ntraDescuento
		END
		
	END TRY

	BEGIN CATCH
		IF (XACT_STATE()) <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END
		SET @flag = ERROR_NUMBER();
		SET @msj = 'Error en pa_registrar_modificar_preventa ' + ERROR_MESSAGE();
		SELECT @flag as flag , @msj as mensaje, @ntraDescu as ntraDescuento
	END CATCH
END