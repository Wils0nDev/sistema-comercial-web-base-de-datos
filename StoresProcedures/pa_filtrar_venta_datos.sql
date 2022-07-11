
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_filtrar_venta_datos' AND type = 'P')
	DROP PROCEDURE pa_filtrar_venta_datos
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 05/03/2020  
-- Sistema: VirgenCarmenMantenedor
-- Descripción: Filtrar venta por codigo
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_filtrar_venta_datos	
(
	@p_ntraVenta INT -- Codigo de venta
)	
AS
	BEGIN
		
		SET NOCOUNT ON;  
		SELECT ntraVenta,serie,nroDocumento, codVendedor,vendedor,codCliente,identificacion, cliente,codUbigeo,tipoVenta, tVenta, tDoc, 
		estPre, fechaPago, fechaTransaccion, importeRecargo, IGV, importeTotal,tipoMoneda,moneda,ntraSucursal,sucursal,
		tipoDocumentoVenta,codPuntoEntrega,direccion,ruta,tipoPersona
						 from v_lista_ventas where ntraVenta = @p_ntraVenta
		

	END	
GO

--exec pa_filtrar_venta_datos 52

 