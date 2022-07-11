
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_notacredito_obtener_venta_promocion' AND type = 'P')
DROP PROCEDURE pa_notacredito_obtener_venta_promocion
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 23/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: obtener detalle venta x promociones
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_notacredito_obtener_venta_promocion
(
	@p_codigo INT				--codigo de venta
)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		SELECT codPromocion, itemVenta, itemPromocionado
		FROM tblVentaPromocion
		WHERE codVenta = @p_codigo AND marcaBaja = 0
		ORDER BY itemPromocionado ASC;
	
	END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER() as codPromocion, 'Error en pa_notacredito_obtener_venta_promocion ' + ERROR_MESSAGE() as msje, 0 as itemPromocionado
	END CATCH
END
GO