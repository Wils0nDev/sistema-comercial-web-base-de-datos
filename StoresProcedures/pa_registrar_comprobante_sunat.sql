
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_registrar_comprobante_sunat' AND type = 'P')
	DROP PROCEDURE pa_registrar_comprobante_sunat
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 20/02/2020  
-- Sistema: DistribuidoraVDC
-- Descripción: Registro de comprobante sunat 
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_registrar_comprobante_sunat
(
	@p_codTransaccion INT,			-- Codigo de transaccion
	@p_codModulo SMALLINT,			-- Codigo de modulo 
	@p_tipDocSunat SMALLINT,			-- ipo de documento de sunat (Ventas, NC)
	@p_tipDocVenta SMALLINT,			-- Documento de venta (boleta/factura/Parcial/Total)
	@p_tramEntrada VARCHAR(MAX), -- trama de entrada
	@p_estado SMALLINT,			-- estado
	@p_usuario VARCHAR(20), -- usuario
	@p_ip VARCHAR(20), -- ip
	@p_mac VARCHAR(20) -- MAC

)		
AS
	BEGIN
		DECLARE @ntra INT;						--numero de transaccion

		SET @ntra = 0;
		
		INSERT INTO tblComprobSunat(codTransaccion, codModulo, tipDocSunat, tipDocVenta, tramEntrada, estado,usuario, ip, mac)
		VALUES(@p_codTransaccion,@p_codModulo,@p_tipDocSunat,@p_tipDocVenta,@p_tramEntrada,@p_estado,@p_usuario,@p_ip,@p_mac)
		
		SET @ntra = (SELECT @@IDENTITY);
		
		SELECT @ntra as 'codigo'
			

	END	
GO

-- exec pa_registrar_comprobante_sunat 148,1,1,1,'entrada',1,'1','',''

