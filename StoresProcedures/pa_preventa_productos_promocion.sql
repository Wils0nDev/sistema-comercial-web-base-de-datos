
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_preventa_productos_promocion' AND type = 'P')
DROP PROCEDURE pa_preventa_productos_promocion
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 10/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: obtener productos regalo por acceder a promocion
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_preventa_productos_promocion
(
	@p_ntraPromocion INT		--transaccion promocion
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @valorEntero1 INT;
	DECLARE @valorEntero2 INT;
	DECLARE @valorMoneda1 MONEY;
	DECLARE @valorMoneda2 MONEY;
	DECLARE @valorCadena1 VARCHAR(20);
	DECLARE @valorCadena2 VARCHAR(20);
	DECLARE @valorFecha1  VARCHAR(20);
	DECLARE @valorFecha2  VARCHAR(20);

	SET @valorEntero1 = 0;
	SET @valorEntero2 = 0;
	SET @valorMoneda1 = 0;
	SET @valorMoneda2 = 0;
	SET @valorCadena1 = '';
	SET @valorCadena2 = '';
	SET @valorFecha1  = '';
	SET @valorFecha2  = '';
	
	
	BEGIN TRY
		--DECLARE cur_promos CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
		--SELECT valorEntero1, valorEntero2, valorMoneda1, valorMoneda2, valorCadena1, valorCadena2, valorFecha1, valorFecha2 
		--FROM tblDetalleFlagPromocion 
		--WHERE ntraPromocion = @p_ntraPromocion AND flag = 3 
		--AND estado = 1 AND marcaBaja = 0;
		--OPEN cur_promos;  
		--FETCH NEXT FROM cur_promos INTO @valorEntero1, @valorEntero2, @valorMoneda1, @valorMoneda2, @valorCadena1, @valorCadena2, @valorFecha1, @valorFecha2 
		--WHILE @@FETCH_STATUS = 0
		--	BEGIN
		--		SELECT pro.codUnidadBaseventa as codUnidadBase, con.descripcion as descUnidadBase, pro.descripcion as descProducto, alm.descripcion as descAlmacen,
		--		@valorEntero1 as valorEntero1, @valorEntero2 as valorEntero2, @valorMoneda1 as valorMoneda1, @valorMoneda2 as valorMoneda2, 
		--		@valorCadena1 as valorCadena1, @valorCadena2 as valorCadena2, @valorFecha1 as valorFecha1, @valorFecha2 as valorFecha2
		--		FROM tblProducto pro INNER JOIN tblInventario inv ON pro.codProducto = inv.codProducto 
		--		INNER JOIN tblAlmacen alm ON alm.ntraAlmacen = inv.codAlmacen
		--		INNER JOIN tblConcepto con ON pro.codUnidadBaseventa = con.correlativo
		--		WHERE pro.codProducto = @valorCadena1 AND inv.codAlmacen = @valorEntero2 AND con.codConcepto = 12
		--		AND pro.marcaBaja = 0 AND inv.marcaBaja = 0 AND alm.marcaBaja = 0 AND con.marcaBaja = 0;
		--		FETCH NEXT FROM cur_promos INTO @valorEntero1, @valorEntero2, @valorMoneda1, @valorMoneda2, @valorCadena1, @valorCadena2, @valorFecha1, @valorFecha2 ;
		--	END
		--CLOSE cur_promos;  
		--DEALLOCATE cur_promos;
		SELECT pro.codUnidadBaseventa as codUnidadBase, con.descripcion as descUnidadBase, pro.descripcion as descProducto, alm.descripcion as descAlmacen,
		valorEntero1, valorEntero2, valorMoneda1, valorMoneda2, valorCadena1, valorCadena2, valorFecha1, valorFecha2 
		FROM tblProducto pro INNER JOIN tblInventario inv ON pro.codProducto = inv.codProducto 
		INNER JOIN tblAlmacen alm ON alm.ntraAlmacen = inv.codAlmacen
		INNER JOIN tblConcepto con ON pro.codUnidadBaseventa = con.correlativo
		INNER JOIN tblDetalleFlagPromocion det ON det.valorCadena1 = pro.codProducto
		WHERE det.ntraPromocion = @p_ntraPromocion AND inv.codAlmacen = det.valorEntero2 AND con.codConcepto = 12
		AND pro.marcaBaja = 0 AND inv.marcaBaja = 0 AND alm.marcaBaja = 0 AND con.marcaBaja = 0;

	END TRY

	BEGIN CATCH
		SELECT 
		0 as codUnidadBase, '' as descUnidadBase, '' as descproducto, '' as descAlmacen,
		ERROR_NUMBER() as valorEntero1, 0 as valorEntero2, 0 as valorMoneda1, 
		0 as valorMoneda2, 'Error en pa_preventa_productos_promocion ' + ERROR_MESSAGE() as valorCadena1, 
		'' as valorCadena2, '' as valorFecha1, '' as valorFecha2
	END CATCH
END
GO