IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_notacredito_buscar_ventas' AND type = 'P')
DROP PROCEDURE pa_notacredito_buscar_ventas
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 23/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: buscar ventas
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_notacredito_buscar_ventas
(
	@p_codigo INT = NULL,				--codigo de venta
	@p_serie VARCHAR(20) = NULL,		--serie
	@p_numero INT = NULL,				--numero documento
	@p_fechaInicio DATE = NULL,			--fecha inicio
	@p_fechaFin DATE = NULL,			--fecha fin
	@p_codCliente INT = NULL,			--codigo cliente
	@p_codVendedor INT = NULL			--codigo vendedor
)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		SELECT v.ntraVenta as 'ntraVenta', (CASE WHEN (p.tipoPersona) = 2 THEN UPPER(p.razonSocial) ELSE UPPER(p.apellidoPaterno + ' ' + p.apellidoMaterno + ' ' + p.nombres) END) AS 'nombres'
		FROM tblVenta v INNER JOIN tblPersona p ON v.codCliente = p.codPersona
		WHERE v.estado NOT IN (4,5,6) AND v.marcaBaja = 0 AND p.marcaBaja = 0
		--(SELECT MONTH(GETDATE())) = MONTH(v.fechaTransaccion)
		AND (@p_codigo IS NULL OR @p_codigo = v.ntraVenta)
		AND (@p_serie IS NULL OR @p_serie = v.serie)
		AND (@p_numero IS NULL OR @p_numero = v.nroDocumento)
		AND (@p_fechaInicio IS NULL OR v.fechaTransaccion >= @p_fechaInicio)
		AND (@p_fechaFin IS NULL OR v.fechaTransaccion <= @p_fechaFin)
		AND (@p_codCliente IS NULL OR @p_codCliente = v.codCliente)
		AND (@p_codVendedor IS NULL OR @p_codVendedor = v.codVendedor)
		ORDER BY v.ntraVenta DESC
	
	END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER() as 'ntraVenta', 'Error en pa_notacredito_buscar_ventas ' + ERROR_MESSAGE() as 'nombres'
	END CATCH
END
GO