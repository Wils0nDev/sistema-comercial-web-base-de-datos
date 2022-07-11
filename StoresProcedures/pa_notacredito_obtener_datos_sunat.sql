IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_notacredito_obtener_datos_sunat' AND type = 'P')
DROP PROCEDURE pa_notacredito_obtener_datos_sunat
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 23/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: obtener datos para envio de tramas a sunat
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_notacredito_obtener_datos_sunat
(
	@p_codVenta INT,		--codigo de venta
	@p_codNC INT			--codigo nota credito
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @serieV VARCHAR(20);
	DECLARE @numeroV INT;
	DECLARE @tipoDocV INT;
	DECLARE @tipoDocTriSunat_afec VARCHAR(5);
	DECLARE @totalV MONEY;
	DECLARE @igvV MONEY;
	DECLARE @codCliente INT;
	DECLARE @codPuntoEntrega INT;
	DECLARE @moneda_afec INT;

	DECLARE @nombres VARCHAR(200);
	DECLARE @numDocumento VARCHAR(15);
	DECLARE @tipoDocC INT;
	DECLARE @tipoDocIdeSunat INT;
	DECLARE @direccionC VARCHAR(200);
	DECLARE @total_afec MONEY;
	DECLARE @igv_afec MONEY;
	DECLARE @fecha_afec VARCHAR(50);
	DECLARE @codSucursal  INT;

	--DATOS NC
	DECLARE @codMotivo CHAR(2);
	DECLARE @desMotivo VARCHAR(200);
	DECLARE @serieNC VARCHAR(10);
	DECLARE @correlativo VARCHAR(10);
	DECLARE @fecha VARCHAR(50);
	DECLARE @codVentaN INT;

	--DATOS GENERALES
	DECLARE @tipoDocTriSunat VARCHAR(5);
	DECLARE @tipoMoneda VARCHAR(10);
	DECLARE @ublVersion VARCHAR(10);
	DECLARE @tipAfeIgv VARCHAR(10);
	
		--PRODUCTOS
	DECLARE @mtoBaseIgv MONEY;
	DECLARE @porcentajeIgv MONEY;
	DECLARE @unidad VARCHAR(20);
	DECLARE @cal_igv MONEY;
	DECLARE @igv MONEY;

	DECLARE @rucE VARCHAR(12);
	DECLARE @razonSocialE VARCHAR(200);
	DECLARE @direccionE VARCHAR(200);
	
	
	BEGIN TRY
		--datos de venta afectada
		SELECT @serieV = serie, @numeroV = nroDocumento, @tipoDocV = tipoDocumentoVenta, @codCliente = codCliente,
		@codPuntoEntrega = codPuntoEntrega, @total_afec = importeTotal, @igv_afec = IGV, @fecha_afec = fechaTransaccion,
		@codSucursal = codSucursal, @moneda_afec = tipoMoneda
		FROM tblVenta
		WHERE ntraVenta = @p_codVenta AND marcaBaja = 0;
		SET @fecha_afec = @fecha_afec + 'T00:00:00-05:00'

		--obtener el equivalente del tipo documento venta afectado
		SELECT @tipoDocTriSunat_afec = valorCaneda1
		FROM tblDetalleParametro
		WHERE codParametro = 9 AND valorEntero1 = @tipoDocV AND marcaBaja = 0;

		--obtener datos de cliente
		IF (@tipoDocV = 1)
		BEGIN
			SELECT @nombres = UPPER(apellidoPaterno + ' ' + apellidoMaterno + ' ' + nombres), @numDocumento = numeroDocumento,
			@tipoDocC = tipoDocumento
			FROM tblPersona
			WHERE codPersona = @codCliente AND marcaBaja = 0;

			--obtener equivalente de tipo documento identidad cliente
			SELECT @tipoDocIdeSunat = valorEntero2
			FROM tblDetalleParametro
			WHERE codParametro = 10 AND valorEntero1 = @tipoDocC AND marcaBaja = 0;
		END
		ELSE
		BEGIN
			SELECT @nombres = UPPER(razonSocial), @numDocumento = ruc,
			@tipoDocC = tipoDocumento
			FROM tblPersona
			WHERE codPersona = @codCliente AND marcaBaja = 0;

			--obtener equivalente de tipo documento identidad cliente
			SELECT @tipoDocIdeSunat = valorEntero2
			FROM tblDetalleParametro
			WHERE codParametro = 10 AND valorEntero1 = 3 AND marcaBaja = 0;
		END

		--SELECT @tipoDocC = tipoDocumento
		--FROM tblPersona
		--WHERE codPersona = @codCliente AND marcaBaja = 0;

		--obtener moneda
		SELECT @tipoMoneda = valorCaneda1
		FROM tblDetalleParametro
		WHERE codParametro = 12 AND valorEntero1 = @moneda_afec AND marcaBaja = 0;

		--obtener equivalente de tipo documento identidad cliente
		--SELECT @tipoDocIdeSunat = valorEntero2
		--FROM tblDetalleParametro
		--WHERE codParametro = 10 AND valorEntero1 = @tipoDocC AND marcaBaja = 0;

		-- obtener datos de punto entrega
		SELECT @direccionC = direccion 
		FROM tblPuntoEntrega
		WHERE codPersona = @codCliente AND ntraPuntoEntrega = @codPuntoEntrega AND marcaBaja = 0;

		--datos NC
		IF (@p_codNC != 0)
		BEGIN
			SELECT @codMotivo = codMotivo, @serieNC = serie, @correlativo = numero, @fecha = fecha,
			@codVentaN = codVentaNega
			FROM tblNotaCredito
			WHERE ntraNotaCredito = @p_codNC AND marcaBaja = 0;
			SET @fecha = @fecha + 'T00:00:00-05:00'

			SELECT @desMotivo = descripcion
			FROM tblMotivoNotaCredito
			WHERE codigoMotivo = @codMotivo AND marcaBaja = 0;
		
			SELECT @tipoDocTriSunat = valorCaneda1
			FROM tblDetalleParametro
			WHERE codParametro = 9 AND valorEntero1 = 3 AND marcaBaja = 0;

			SELECT @totalV = (importeTotal*-1), @igvV = (IGV*-1)
			FROM tblVenta
			WHERE ntraVenta = @codVentaN AND marcaBaja = 0;
		END
		ELSE
		BEGIN
			SET @codMotivo = '';
			SET @serieNC = '';
			SET @correlativo = 0;
			SET @fecha = '';
			SET @codVentaN = 0;
			SET @desMotivo = '';
			SET @tipoDocTriSunat = '';
			SET @totalV = 0;
			SET @igvV = 0;
		END

		--DATOS GENERALES:
		SELECT @cal_igv = igv
		FROM tblParametrosGenerales
		WHERE codSucursal = @codSucursal AND marcaBaja = 0;

		SET @tipAfeIgv = '10';
		--SET @tipoMoneda = 'PEN';
		--SET @ublVersion = '2.1';

		SELECT @ublVersion = valorCaneda1
		FROM tblDetalleParametro
		WHERE codParametro = 14 AND valorEntero1 = 1 AND marcaBaja = 0

		--SET @mtoBaseIgv = 100;
		--SET @porcentajeIgv = 18;
		--SET @igv = 18;
		SELECT @igv = valorMoneda1, @mtoBaseIgv = valorMoneda2, @porcentajeIgv = valorFloat1
		FROM tblDetalleParametro
		WHERE codParametro = 15 AND tipo = 1 AND marcaBaja = 0

		--SET @unidad = 'NIU';
		SELECT @unidad = valorCaneda1
		FROM tblDetalleParametro
		WHERE codParametro = 13 AND valorEntero1 = 1 AND marcaBaja = 0

		--SET @rucE = '22166585139';
		--SET @razonSocialE = 'EMPRESA DE EJEMPLO IDE';
		--SET @direccionE = 'SALVAERY 123, AL FRENTE DE SOLIDRIDAD, CHICLAYO';
		SELECT @razonSocialE = razonSocial, @rucE = ruc, @direccionE = direccion
		FROM tblEmpresa 
		WHERE marcaBaja = 0;


		SELECT @tipoDocTriSunat_afec as tipDocAfec, @serieV as serieDocAfec, @numeroV as numeroDocAfec, 
		@total_afec as totalVentaAfec, @igv_afec as igvAfec, @fecha_afec as fechaAfec,

		@codMotivo as codMotivoNC, @desMotivo as desMotivoNC, @tipoDocTriSunat as tipoDocNC, @serieNC as serieNC, 
		@correlativo as correlativoNC, @fecha as fechaEmisionNC,
		@totalV as mtoImpVentaNC, @igvV as mtoIGVNC,

		@tipoDocIdeSunat as tipoDocClient, @numDocumento as numDocCliente, @nombres as rznSocialClient, 
		@direccionC as direccionClient,

		@rucE as rucCompany, @razonSocialE as razonSocialCompany, @direccionE as direccionCompany,

		@tipoMoneda as tipoMoneda, @ublVersion as ublVersion, @mtoBaseIgv as mtoBaseIgv, @porcentajeIgv as porcentajeIgv,
		@unidad as unidad, @cal_igv as cal_igv, @tipAfeIgv as tipAfeIgv, @igv as igv

	END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER() as flag, 'Error en pa_notacredito_obtener_datos_sunat ' + ERROR_MESSAGE() as msje
	END CATCH
END
GO