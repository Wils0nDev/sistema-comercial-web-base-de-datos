IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_lista_comprob_fallidos' AND type = 'P')
	DROP PROCEDURE pa_lista_comprob_fallidos
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 28/04/2020
-- Sistema: Distribuidora Virgende del carmen
-- Descripcion: Lista de comprobantes fallidos enviados a la sunat
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_lista_comprob_fallidos]	
AS
	BEGIN
		SET NOCOUNT ON
		
		SELECT ntraComprob,codTransaccion,codModulo,tipDocSunat,tipDocVenta,tramEntrada 
		FROM tblComprobSunat WHERE estado = 2 and marcaBaja = 0


END

-- exec pa_lista_comprob_fallidos
