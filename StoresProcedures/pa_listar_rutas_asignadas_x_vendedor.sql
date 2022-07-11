
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_rutas_asignadas_x_vendedor' AND type = 'P')
	DROP PROCEDURE pa_listar_rutas_asignadas_x_vendedor
GO
----------------------------------------------------------------------------------
-- Author: WilSON IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Listar rutas asignadas
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_listar_rutas_asignadas_x_vendedor]   
    @codUsuario integer

	
AS   
BEGIN
    
	SELECT * FROM v_listar_rutas_asignadas_x_vendedor
	WHERE ntraUsuario =  @codUsuario
	ORDER BY ORDEN ASC

END