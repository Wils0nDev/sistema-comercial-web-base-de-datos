
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_sucursales' AND type = 'P')
	DROP PROCEDURE pa_listar_sucursales
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Traer lista de sucursales
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_sucursales		
AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
		
		SET @g_const_0 = 0
		
		SET NOCOUNT ON;  
		SELECT ntraSucursal,descripcion,codUbigeo,factor FROM tblSucursal WHERE marcaBaja =  @g_const_0 
		

	END	
GO

--exec pa_listar_sucursales

 