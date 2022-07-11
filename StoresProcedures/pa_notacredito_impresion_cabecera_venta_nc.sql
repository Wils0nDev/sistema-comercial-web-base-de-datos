IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_notacredito_impresion_cabecera_venta_nc' AND type = 'P')
DROP PROCEDURE pa_notacredito_impresion_cabecera_venta_nc
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 23/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: obtener datos venta negativo
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_notacredito_impresion_cabecera_venta_nc
(
	@p_codNotaCredito INT	--codigo nota credito
)
AS
BEGIN
	SET NOCOUNT ON;
	--DATOS NC
	DECLARE @serie VARCHAR(20);
	DECLARE @numero INT;
	DECLARE @tipoCambio MONEY;
	DECLARE @fecha DATE;
	DECLARE @tipoNC VARCHAR(50);
	DECLARE @motivoNC VARCHAR(100);
	DECLARE @importe MONEY;
	DECLARE @codVentaNega INT;

	--DATOS VENTA
	DECLARE @serieV VARCHAR(20);
	DECLARE @numeroV INT;
	DECLARE @codCliente INT;
	DECLARE @importeTotalV MONEY;
	DECLARE @importeIgvV MONEY;
	DECLARE @importeSubTotalV MONEY;

	--DATOS CLIENTE
	DECLARE @nombreC VARCHAR(200);
	DECLARE @nroDocumentoC VARCHAR(15);

	SET @serie = '';
	SET @numero = 0;
	SET @tipoCambio = 0;
	SET @fecha = NULL;
	SET @tipoNC = '';
	SET @motivoNC = '';
	SET @importe = 0;
	SET @codVentaNega = 0;
	SET @serieV = '';
	SET @numeroV = 0;
	SET @codCliente = 0;
	SET @importeTotalV = 0;
	SET @importeIgvV = 0;
	SET @importeSubTotalV = 0;
	SET @nombreC = '';
	SET @nroDocumentoC = '';

	BEGIN TRY
		--DATOS NC:
		SELECT @serie = nc.serie, @numero = nc.numero, @tipoCambio = nc.tipoCambio, @fecha = nc.fecha,
		@tipoNC = con.descripcion, @motivoNC = mnc.descripcion, @importe = nc.importe, @codVentaNega = nc.codVentaNega
		FROM tblNotaCredito nc INNER JOIN tblMotivoNotaCredito mnc ON nc.codMotivo = mnc.codigoMotivo
		INNER JOIN tblConcepto con ON con.correlativo = nc.tipo
		WHERE nc.ntraNotaCredito = @p_codNotaCredito AND con.codConcepto = 37 AND nc.marcaBaja = 0 AND mnc.marcaBaja = 0

		--DATOS VENTA
		SELECT @serieV = serie, @numeroV = nroDocumento, @codCliente = codCliente, @importeTotalV = (importeTotal*-1),
		@importeIgvV = (IGV*-1)
		FROM tblVenta 
		WHERE ntraVenta = @codVentaNega AND marcaBaja = 0;
		--SET @importeTotalV = @importeTotalV * -1;
		SET @importeSubTotalV = ROUND((@importeTotalV - @importeIgvV),2);

		--DATOS CLIENTE
		SELECT @nombreC = (CASE WHEN (tipoPersona) = 2 THEN UPPER(razonSocial) ELSE UPPER(apellidoPaterno + ' ' + apellidoMaterno + ' ' + nombres) END),
		@nroDocumentoC = (CASE WHEN (tipoPersona) = 2 THEN UPPER(ruc) ELSE UPPER(numeroDocumento) END)
		FROM tblPersona
		WHERE codPersona = @codCliente AND marcaBaja = 0;

		--DATOS NC
		SELECT @serie as serieNC, @numero as numeroNC, @tipoCambio as tipoCambioNC, @fecha as fechaNC,
		@tipoNC as tipoNC, @motivoNC as motivoNC,
		--DATOS VENTA
		@serieV as serieV, @numeroV as numeroV, @importeTotalV as importeTotalV, @importeIgvV as importeIgvV,
		@importeSubTotalV as importeSubTotalV,
		--DATOS CLIENTE
		@nombreC as nombreC, @nroDocumentoC as nroDocumentoC
	
	END TRY

	BEGIN CATCH
		SELECT '' as serieNC, ERROR_NUMBER() as numeroNC, 0 as tipoCambioNC, '' as fechaNC,
		'' as tipoNC, '' as motivoNC,
		--DATOS VENTA
		'' as serieV, 0 as numeroV, 0 as importeTotalV, 0 as importeIgvV,
		0 as importeSubTotalV,
		--DATOS CLIENTE
		'Error en pa_notacredito_impresion_cabecera_venta_nc ' + ERROR_MESSAGE() as nombreC, '' as nroDocumentoC
	END CATCH
END
GO