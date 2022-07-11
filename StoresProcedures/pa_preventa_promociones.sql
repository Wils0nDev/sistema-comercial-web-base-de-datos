
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_preventa_promociones' AND type = 'P')
DROP PROCEDURE pa_preventa_promociones
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 10/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: obtener promociones vigentes de un producto
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_preventa_promociones
(
	@p_codProducto VARCHAR(15), --codigo de producto
	@p_codCliente INT,			--codigo cliente
	@p_codUsuario INT,			--codigo vendedor
	@p_tipoVenta INT			--tipo venta
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ntraPromocion INT;				--ntra promocion
	DECLARE @descPromocion VARCHAR(200);	--descripcion de promocion
	DECLARE @cont INT;						--contador
	DECLARE @flag INT;						--flag proceso
	DECLARE @valorCadena VARCHAR(50);		--cadena
	DECLARE @valorEntero INT;				--entero
	DECLARE @contador INT;				--entero

	SET @ntraPromocion = 0;
	SET @descPromocion = '';
	SET @cont = 0;
	SET @flag = 0;
	SET @valorCadena = '';
	SET @valorEntero = 0;
	SET @contador = 0;

	BEGIN TRY
		DECLARE cur_promos CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
		SELECT p.ntraPromocion, p.descripcion
		FROM tblPromociones p INNER JOIN tblDetallePromociones dp ON p.ntraPromocion = dp.ntraPromocion
		WHERE (SELECT CONVERT (date, GETDATE(), 5) ) BETWEEN p.fechaInicial AND p.fechaFin 
		AND (select convert(char(8), getdate(), 108) as [hh:mm:ss]) BETWEEN p.horaInicial AND p.horaFin
		AND dp.valorInicial = @p_codProducto
		AND dp.flag = 1 AND p.estado = 1 AND dp.estado = 1 AND p.marcaBaja = 0 AND dp.marcaBaja = 0
		OPEN cur_promos;  
		FETCH NEXT FROM cur_promos INTO @ntraPromocion, @descPromocion
		WHILE @@FETCH_STATUS = 0
			BEGIN
				--FLAG 4 VENDEDOR QUE APLICA A LA PROMOCION
				SET @cont = 0;
				SELECT @cont = COUNT(ntraPromocion) FROM tblDetallePromociones
				WHERE ntraPromocion = @ntraPromocion AND flag = 4 AND estado = 1 AND marcaBaja = 0;
				IF(@cont > 0)
				BEGIN
					SET @valorEntero = 0;
					SELECT @valorEntero = COUNT(valorInicial)
					FROM tblDetallePromociones
					WHERE ntraPromocion = @ntraPromocion AND valorInicial = @p_codUsuario AND flag = 4 AND estado = 1 AND marcaBaja = 0;
					IF(@valorEntero = 0)
					BEGIN
						SET @flag = 1;
					END
				END

				--FLAG 5 CLIENTE QUE APLICA A LA PROMOCION
				IF (@flag = 0)
				BEGIN 
					SET @cont = 0;
					SELECT @cont = COUNT(ntraPromocion) FROM tblDetallePromociones
					WHERE ntraPromocion = @ntraPromocion AND flag = 5 AND estado = 1 AND marcaBaja = 0;
					IF(@cont > 0)
					BEGIN
						SET @valorEntero = 0;
						SELECT @valorEntero = COUNT(valorInicial)
						FROM tblDetallePromociones
						WHERE ntraPromocion = @ntraPromocion AND valorInicial = @p_codCliente AND flag = 5 AND estado = 1 AND marcaBaja = 0;
						IF(@valorEntero = 0)
						BEGIN
							SET @flag = 1;
						END
					END
				END 

				--FLAG 6 VECES QUE SE PUEDE USAR LA PROMOCION
				IF (@flag = 0)
				BEGIN 
					SET @cont = 0;
					SELECT @cont = COUNT(ntraPromocion) FROM tblDetallePromociones
					WHERE ntraPromocion = @ntraPromocion AND flag = 6 AND estado = 1 AND marcaBaja = 0;
					IF(@cont > 0)
					BEGIN
						SET @valorEntero = 0;
						SET @contador = 0;
						SELECT @contador = COUNT(DISTINCT(pro.codPreventa)) 
						FROM tblPreventaPromocion pro INNER JOIN tblPreventa pre ON pro.codPreventa = pre.ntraPreventa
						WHERE pre.estado != 2 AND pro.codPromocion = @ntraPromocion AND pro.marcaBaja = 0 AND pre.marcaBaja = 0;

						SELECT @valorEntero = valorInicial
						FROM tblDetallePromociones
						WHERE ntraPromocion = @ntraPromocion AND flag = 6 AND estado = 1 AND marcaBaja = 0;
						IF(@contador > @valorEntero)
						BEGIN
							SET @flag = 1;
						END
					END
				END

				--FLAG 7 VECES QUE UN VENDEDOR PUEDE USAR LA PROMOCION
				IF (@flag = 0)
				BEGIN 
					SET @cont = 0;
					SELECT @cont = COUNT(ntraPromocion) FROM tblDetallePromociones
					WHERE ntraPromocion = @ntraPromocion AND flag = 7 AND estado = 1 AND marcaBaja = 0;
					IF(@cont > 0)
					BEGIN
						SET @valorEntero = 0;
						SET @contador = 0;
						SELECT @contador = COUNT(DISTINCT(codPreventa))
						FROM tblPreventaPromocion pro INNER JOIN tblPreventa pre ON pro.codPreventa = pre.ntraPreventa
						WHERE pre.estado != 2 AND pro.codPromocion = @ntraPromocion and pre.codUsuario = @p_codUsuario 
						AND pro.marcaBaja = 0 AND pre.marcaBaja = 0;

						SELECT @valorEntero = valorInicial
						FROM tblDetallePromociones
						WHERE ntraPromocion = @ntraPromocion AND flag = 7 AND estado = 1 AND marcaBaja = 0;
						IF(@contador > @valorEntero)
						BEGIN
							SET @flag = 1;
						END
					END
				END

				--FLAG 8 VECES QUE UN CLIENTE PUEDE USAR LA PROMOCION
				IF (@flag = 0)
				BEGIN 
					SET @cont = 0;
					SELECT @cont = COUNT(ntraPromocion) FROM tblDetallePromociones
					WHERE ntraPromocion = @ntraPromocion AND flag = 8 AND estado = 1 AND marcaBaja = 0;
					IF(@cont > 0)
					BEGIN
						SET @valorEntero = 0;
						SET @contador = 0;
						SELECT @contador = COUNT(DISTINCT(codPreventa))
						FROM tblPreventaPromocion pro 
						INNER JOIN tblPreventa pre ON pro.codPreventa = pre.ntraPreventa 
						WHERE pre.estado != 2 AND pro.codPromocion = @ntraPromocion and pre.codCliente = @p_codCliente
						AND pro.marcaBaja = 0 AND pre.marcaBaja = 0;

						SELECT @valorEntero = valorInicial
						FROM tblDetallePromociones
						WHERE ntraPromocion = @ntraPromocion AND flag = 8 AND estado = 1 AND marcaBaja = 0;
						IF(@contador > @valorEntero)
						BEGIN
							SET @flag = 1;
						END
					END
				END

				--FLAG 9 PROMOCION PARA VENTA AL CONTADO O CREDITO
				IF (@flag = 0)
				BEGIN
					SET @cont = 0;
					SELECT @cont = COUNT(ntraPromocion) FROM tblDetallePromociones
					WHERE ntraPromocion = @ntraPromocion AND flag = 9 AND estado = 1 AND marcaBaja = 0;
					IF(@cont > 0)
					BEGIN
						SET @valorEntero = 0;
						SELECT @valorEntero = COUNT(valorInicial)
						FROM tblDetallePromociones
						WHERE ntraPromocion = @ntraPromocion AND valorInicial = @p_tipoVenta AND flag = 9 AND estado = 1 AND marcaBaja = 0;
						IF(@valorEntero = 0)
						BEGIN
							SET @flag = 1;
						END
					END
				END


				IF (@flag = 0)
				BEGIN 
					SELECT @ntraPromocion as ntraPromocion, @descPromocion as descPromocion, valorInicial as valor, valorFinal as tipo
					FROM tblDetallePromociones
					WHERE ntraPromocion = @ntraPromocion AND flag = 2 AND estado = 1 AND marcaBaja = 0;
				END
					

				SET @flag = 0;
				FETCH NEXT FROM cur_promos INTO @ntraPromocion, @descPromocion;
			END
		CLOSE cur_promos;  
		DEALLOCATE cur_promos;
	
	END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER() as 'ntraPromocion', 'Error en pa_preventa_promociones ' + ERROR_MESSAGE() as 'descPromocion', 0 as 'valor', 0 as 'tipo'
	END CATCH
END
GO