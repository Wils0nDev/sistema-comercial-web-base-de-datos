
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_preventa_buscar_producto' AND type = 'P')
DROP PROCEDURE pa_preventa_buscar_producto
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 09/03/2020
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripcion: Buscar producto preventa
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_preventa_buscar_producto
(
	@p_cadena VARCHAR(50)			--cadena
)
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		SELECT codProducto, descripcion
		FROM v_preventa_listar_productos
		WHERE concatenado LIKE '%'+ RTRIM(LTRIM(@p_cadena)) + '%'
	
	END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER() as 'codProducto', 'Error en pa_preventa_buscar_producto ' + ERROR_MESSAGE() as 'descripcion'
	END CATCH
END
GO