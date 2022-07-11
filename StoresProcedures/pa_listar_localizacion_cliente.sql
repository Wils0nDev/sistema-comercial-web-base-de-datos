
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_localizacion_cliente' AND type = 'P')
	DROP PROCEDURE pa_listar_localizacion_cliente
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 05/03/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Listar localizacion por cliente
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_localizacion_cliente	
(
	@p_codPer bigint -- 
)	
AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
		
		SET @g_const_0 = 0
		
		SET NOCOUNT ON;  
		SELECT codPersona,coordenadaX,coordenadaY FROM tblLocalizacion WHERE codPersona = @p_codPer AND marcaBaja = @g_const_0
		
	END	
GO

--exec pa_listar_localizacion_cliente 89123456

 