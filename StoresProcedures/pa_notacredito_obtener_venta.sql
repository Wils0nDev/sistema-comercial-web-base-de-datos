
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_notacredito_obtener_venta' AND type = 'P')
DROP PROCEDURE pa_notacredito_obtener_venta
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 23/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: obtener datos de venta por codigo
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_notacredito_obtener_venta
(
	@p_codigo INT				--codigo de venta
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @nomVendedor VARCHAR(100);

	SET @nomVendedor = '';

	BEGIN TRY
		
		SELECT @nomVendedor = UPPER(p.apellidoPaterno + ' ' + p.apellidoMaterno + ' ' + p.nombres)
		FROM tblVenta v INNER JOIN tblUsuario u ON v.codVendedor = u.ntraUsuario
		INNER JOIN tblPersona p ON u.codPersona = p.codPersona
		WHERE v.ntraVenta = @p_codigo AND v.estado != 3 
		AND v.marcaBaja = 0 AND u.marcaBaja = 0 AND p.marcaBaja = 0

		SELECT v.ntraVenta as ntraVenta, 
		(CASE WHEN (p.tipoPersona) = 2 THEN UPPER(p.razonSocial) ELSE UPPER(p.apellidoPaterno + ' ' + p.apellidoMaterno + ' ' + p.nombres) END) AS nomCliente,
		v.tipoCambio, v.serie, v.nroDocumento, @nomVendedor as nomVendedor, v.importeTotal, v.importeRecargo, v.tipoVenta
		FROM tblVenta v INNER JOIN tblPersona p ON v.codCliente = p.codPersona
		WHERE v.ntraVenta = @p_codigo AND v.estado != 3 AND v.marcaBaja = 0 AND p.marcaBaja = 0
		
	END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER() as ntraVenta, 'Error en pa_notacredito_obtener_venta ' + ERROR_MESSAGE() as nomCliente,
		0 as tipoCambio, '' as serie, 0 as nroDocumento, '' as nomVendedor, 0 as tipoVenta
	END CATCH
END
GO