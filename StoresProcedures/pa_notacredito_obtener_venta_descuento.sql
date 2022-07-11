
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_notacredito_obtener_venta_descuento' AND type = 'P')
DROP PROCEDURE pa_notacredito_obtener_venta_descuento
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 23/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: obtener detalle venta x descuentos
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_notacredito_obtener_venta_descuento
(
	@p_codigo INT				--codigo de venta
)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		SELECT codDescuento, itemVenta, importe
		FROM tblVentaDescuento
		WHERE codVenta = @p_codigo AND marcaBaja = 0
		ORDER BY itemVenta ASC;
	
	END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER() as codDescuento, 'Error en pa_notacredito_obtener_venta_descuento ' + ERROR_MESSAGE() as msje, 0 as importe
	END CATCH
END
GO