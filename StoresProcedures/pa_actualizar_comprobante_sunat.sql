
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_actualizar_comprobante_sunat' AND type = 'P')
	DROP PROCEDURE pa_actualizar_comprobante_sunat
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 20/02/2020  
-- Sistema: DistribuidoraVDC
-- Descripción: Actualizacion de comprobante sunat 
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_actualizar_comprobante_sunat
(
	@p_codTransaccion INT,			-- Codigo de transaccion
	@p_tramSalida VARCHAR(MAX), -- trama de salida
	@p_estado SMALLINT			-- estado
)		
AS
	BEGIN
		DECLARE @ntra INT;						--numero de transaccion

		SET @ntra = 0;
		
		UPDATE tblComprobSunat SET tramSalida = @p_tramSalida, estado = @p_estado WHERE ntraComprob = @p_codTransaccion
			

	END	
GO

-- exec pa_actualizar_comprobante_sunat 1,'salida',1

