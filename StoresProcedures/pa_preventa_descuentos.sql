
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_preventa_descuentos' AND type = 'P')
DROP PROCEDURE pa_preventa_descuentos
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 10/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: obtener descuentos vigentes de un producto
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_preventa_descuentos
(
	@p_codProducto VARCHAR(15), --codigo de producto
	@p_codCliente INT,			--codigo cliente
	@p_codUsuario INT,			--codigo vendedor
	@p_tipoVenta INT,			--tipo venta
	@p_tipoDescuento INT		--tipo descuento
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ntraDescuento INT;				--ntra promocion
	DECLARE @descDescuento VARCHAR(200);	--descripcion de promocion
	DECLARE @cont INT;						--contador
	DECLARE @flag INT;						--flag proceso
	DECLARE @valorCadena VARCHAR(50);		--cadena
	DECLARE @valorEntero INT;				--entero
	DECLARE @contador INT;				--entero

	DECLARE @tipoDescuento INT;				--tipo descuento
	DECLARE @valorDescuento MONEY;			--valoor descuento

	SET @ntraDescuento = 0;
	SET @descDescuento = '';
	SET @cont = 0;
	SET @flag = 0;
	SET @valorCadena = '';
	SET @valorEntero = 0;
	SET @contador = 0;

	BEGIN TRY
		DECLARE cur_dsctos CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
		SELECT d.ntraDescuento, d.descripcion
		FROM tblDescuentos d INNER JOIN tblDetalleDescuentos dd ON d.ntraDescuento = dd.ntraDescuento
		WHERE (SELECT CONVERT (date, GETDATE(), 5) ) BETWEEN d.fechaInicial AND d.fechaFin 
		AND (select convert(char(8), getdate(), 108) as [hh:mm:ss]) BETWEEN d.horaInicial AND d.horaFin
		AND dd.valorInicial = @p_codProducto
		AND dd.flag = 1 AND d.tipoDescuento = @p_tipoDescuento AND d.estado = 1 AND dd.estado = 1 AND d.marcaBaja = 0 AND dd.marcaBaja = 0
		OPEN cur_dsctos;  
		FETCH NEXT FROM cur_dsctos INTO @ntraDescuento, @descDescuento
		WHILE @@FETCH_STATUS = 0
			BEGIN
				--FLAG 4 VENDEDOR QUE APLICA A LA PROMOCION
				SET @cont = 0;
				SELECT @cont = COUNT(ntraDescuento) FROM tblDetalleDescuentos
				WHERE ntraDescuento = @ntraDescuento AND flag = 4 AND estado = 1 AND marcaBaja = 0;
				IF(@cont > 0)
				BEGIN
					SET @valorEntero = 0;
					SELECT @valorEntero = COUNT(valorInicial)
					FROM tblDetalleDescuentos
					WHERE ntraDescuento = @ntraDescuento AND valorInicial = @p_codUsuario AND flag = 4 AND estado = 1 AND marcaBaja = 0;
					IF(@valorEntero = 0)
					BEGIN
						SET @flag = 1;
					END
				END
				
				--FLAG 5 CLIENTE QUE APLICA A LA PROMOCION
				IF (@flag = 0)
				BEGIN 
					SET @cont = 0;
					SELECT @cont = COUNT(ntraDescuento) FROM tblDetalleDescuentos
					WHERE ntraDescuento = @ntraDescuento AND flag = 5 AND estado = 1 AND marcaBaja = 0;
					IF(@cont > 0)
					BEGIN
						SET @valorEntero = 0;
						SELECT @valorEntero = COUNT(valorInicial)
						FROM tblDetalleDescuentos
						WHERE ntraDescuento = @ntraDescuento AND valorInicial = @p_codCliente AND flag = 5 AND estado = 1 AND marcaBaja = 0;
						IF(@valorEntero = 0)
						BEGIN
							SET @flag = 1;
						END
					END
				END 
				
				--FLAG 6 VECES QUE SE PUEDE USAR EL DESCUENTO
				IF (@flag = 0)
				BEGIN 
					SET @cont = 0;
					SELECT @cont = COUNT(ntraDescuento) FROM tblDetalleDescuentos
					WHERE ntraDescuento = @ntraDescuento AND flag = 6 AND estado = 1 AND marcaBaja = 0;
					IF(@cont > 0)
					BEGIN
						SET @valorEntero = 0;
						SET @contador = 0;
						SELECT @contador = COUNT(DISTINCT(dsc.codPreventa)) 
						FROM tblPreventaDescuento dsc INNER JOIN tblPreventa pre ON dsc.codPreventa = pre.ntraPreventa
						WHERE pre.estado != 2 AND dsc.codDescuento = @ntraDescuento AND dsc.marcaBaja = 0 AND pre.marcaBaja = 0;

						SELECT @valorEntero = valorInicial
						FROM tblDetalleDescuentos
						WHERE ntraDescuento = @ntraDescuento AND flag = 6 AND estado = 1 AND marcaBaja = 0;
						IF(@contador > @valorEntero)
						BEGIN
							SET @flag = 1;
						END
					END
				END
				
				--FLAG 7 VECES QUE UN VENDEDOR PUEDE USAR EL DESCUENTO
				IF (@flag = 0)
				BEGIN 
					SET @cont = 0;
					SELECT @cont = COUNT(ntraDescuento) FROM tblDetalleDescuentos
					WHERE ntraDescuento = @ntraDescuento AND flag = 7 AND estado = 1 AND marcaBaja = 0;
					IF(@cont > 0)
					BEGIN
						SET @valorEntero = 0;
						SET @contador = 0;
						SELECT @contador = COUNT(DISTINCT(codPreventa))
						FROM tblPreventaDescuento dsc INNER JOIN tblPreventa pre ON dsc.codPreventa = pre.ntraPreventa
						WHERE pre.estado != 2 AND dsc.codDescuento = @ntraDescuento and pre.codUsuario = @p_codUsuario 
						AND dsc.marcaBaja = 0 AND pre.marcaBaja = 0;

						SELECT @valorEntero = valorInicial
						FROM tblDetalleDescuentos
						WHERE ntraDescuento = @ntraDescuento AND flag = 7 AND estado = 1 AND marcaBaja = 0;
						IF(@contador > @valorEntero)
						BEGIN
							SET @flag = 1;
						END
					END
				END
				
				--FLAG 8 VECES QUE UN CLIENTE PUEDE USAR EL DESCUENTO
				IF (@flag = 0)
				BEGIN 
					SET @cont = 0;
					SELECT @cont = COUNT(ntraDescuento) FROM tblDetalleDescuentos
					WHERE ntraDescuento = @ntraDescuento AND flag = 8 AND estado = 1 AND marcaBaja = 0;
					IF(@cont > 0)
					BEGIN
						SET @valorEntero = 0;
						SET @contador = 0;
						SELECT @contador = COUNT(DISTINCT(codPreventa))
						FROM tblPreventaDescuento dsc 
						INNER JOIN tblPreventa pre ON dsc.codPreventa = pre.ntraPreventa 
						WHERE pre.estado != 2 AND dsc.codDescuento = @ntraDescuento and pre.codCliente = @p_codCliente
						AND dsc.marcaBaja = 0 AND pre.marcaBaja = 0;

						SELECT @valorEntero = valorInicial
						FROM tblDetalleDescuentos
						WHERE ntraDescuento = @ntraDescuento AND flag = 8 AND estado = 1 AND marcaBaja = 0;
						IF(@contador > @valorEntero)
						BEGIN
							SET @flag = 1;
						END
					END
				END
				
				--FLAG 10 PROMOCION PARA VENTA AL CONTADO O CREDITO
				IF (@flag = 0)
				BEGIN
					SET @cont = 0;
					SELECT @cont = COUNT(ntraDescuento) FROM tblDetalleDescuentos
					WHERE ntraDescuento = @ntraDescuento AND flag = 10 AND estado = 1 AND marcaBaja = 0;
					IF(@cont > 0)
					BEGIN
						SET @valorEntero = 0;
						SELECT @valorEntero = COUNT(valorInicial)
						FROM tblDetalleDescuentos
						WHERE ntraDescuento = @ntraDescuento AND valorInicial = @p_tipoVenta AND flag = 10 AND estado = 1 AND marcaBaja = 0;
						IF(@valorEntero = 0)
						BEGIN
							SET @flag = 1;
						END
					END
				END


				IF (@flag = 0)
				BEGIN
					SELECT @valorDescuento = valorInicial, @tipoDescuento = valorFinal
					FROM tblDetalleDescuentos
					WHERE ntraDescuento = @ntraDescuento AND flag = 3 AND estado = 1 AND marcaBaja = 0;

					SELECT @ntraDescuento as ntraDescuento, @descDescuento as descDescuento, valorInicial as valor, valorFinal as tipo,
					@valorDescuento as valorDescuento, @tipoDescuento as tipoDescuento
					FROM tblDetalleDescuentos
					WHERE ntraDescuento = @ntraDescuento AND flag = 2 AND estado = 1 AND marcaBaja = 0;
				END
					

				SET @flag = 0;
				FETCH NEXT FROM cur_dsctos INTO @ntraDescuento, @descDescuento;
			END
		CLOSE cur_dsctos;  
		DEALLOCATE cur_dsctos;
	
	END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER() as 'ntraDescuento', 'Error en pa_preventa_descuentos ' + ERROR_MESSAGE() as 'descDescuento', 0 as 'valor', 0 as 'tipo',
		0 as 'valorDescuento', 0 as 'tipoDescuento'
	END CATCH
END
GO