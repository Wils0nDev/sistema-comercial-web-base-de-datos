
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_promociones_desc_sinc' AND type = 'P')
	DROP PROCEDURE pa_listar_promociones_desc_sinc
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Traer lista de promociones 
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_promociones_desc_sinc

AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
		DECLARE @g_const_vacio CHAR(1) -- Constante vacio
		DECLARE @g_const_2000 SMALLINT -- Constante 2000
		DECLARE @g_const_msj VARCHAR(200) -- Mensaje
			
		SET @g_const_vacio = '';
		SET @g_const_0 = 0;
		SET @g_const_2000 = 2000
		SET @g_const_msj = 'Consulta exitosa'

		SET NOCOUNT ON;
		
		SELECT ntraPromocion,descripcion as desc_promo FROM tblPromociones  WHERE marcaBaja = @g_const_0
			

	END	
GO

--exec pa_listar_promociones_desc_sinc 



 