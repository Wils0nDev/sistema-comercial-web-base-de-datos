
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_notacredito_habilita_descuento' AND type = 'P')
DROP PROCEDURE pa_notacredito_habilita_descuento
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 23/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: obtener valores para acceder al descuento
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_notacredito_habilita_descuento
(
	@p_codigo INT					-- codigo promocion
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @tipoDescuento INT;				--tipo descuento
	DECLARE @valorDescuento MONEY;			--valoor descuento

	SET @tipoDescuento = 0;
	SET @valorDescuento = 0;

	BEGIN TRY
		SELECT @valorDescuento = valorInicial, @tipoDescuento = valorFinal
		FROM tblDetalleDescuentos
		WHERE ntraDescuento = @p_codigo AND flag = 3 AND marcaBaja = 0;


		SELECT valorInicial as valor, valorFinal as tipo, @valorDescuento as valorDescuento, @tipoDescuento as tipoDescuento
		FROM tblDetalleDescuentos
		WHERE ntraDescuento = @p_codigo AND flag = 2 AND marcaBaja = 0;
	
	END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER() as valor, 'Error en pa_notacredito_habilita_descuento ' + ERROR_MESSAGE() as tipo, 
		0 as valorDescuento, 0 as tipoDescuento
	END CATCH
END
GO