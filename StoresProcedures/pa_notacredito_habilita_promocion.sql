
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_notacredito_habilita_promocion' AND type = 'P')
DROP PROCEDURE pa_notacredito_habilita_promocion
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 23/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: obtener valores para acceder a la promocion
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_notacredito_habilita_promocion
(
	@p_codigo INT					-- codigo promocion
)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		SELECT valorInicial as valor, valorFinal as tipo
		FROM tblDetallePromociones
		WHERE ntraPromocion = @p_codigo AND flag = 2 AND marcaBaja = 0;
	
	END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER() as valor, 'Error en pa_notacredito_habilita_promocion ' + ERROR_MESSAGE() as tipo
	END CATCH
END
GO