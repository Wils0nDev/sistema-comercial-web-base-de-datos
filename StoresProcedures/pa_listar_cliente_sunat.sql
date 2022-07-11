
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_cliente_sunat' AND type = 'P')
	DROP PROCEDURE pa_listar_cliente_sunat
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 05/03/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Traer cliente de base local de sunat
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_cliente_sunat	
(
	@p_ruc bigint -- 
)	
AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
		
		SET @g_const_0 = 0
		
		SET NOCOUNT ON;  
		SELECT RUC,razonSocial,estCont,condDom,ubigeo,tipVia,nomVia,codZona,nomZona,numero,interior,lote,
					departamento,manzana,kilometro FROM tblSUNAT WHERE RUC = @p_ruc
		

	END	
GO

--exec pa_listar_cliente_sunat 20126497467

 