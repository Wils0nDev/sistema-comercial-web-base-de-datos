
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_cerrar_sesion_usuario' AND type = 'P')
	DROP PROCEDURE pa_cerrar_sesion_usuario
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 03/06/2019  
-- Sistema: ws_wa_DistribuidoraVDC
-- Modulo: General
-- Descripción: Cerrar sesion de usuario
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_cerrar_sesion_usuario
(
	@p_codUsu INT,			-- Usuario
	@p_fecha_fin DATETIME -- Fecha de fin

)		
AS
	BEGIN
		DECLARE @mensaje VARCHAR(100); -- mensaje
		DECLARE @g_const_2000 SMALLINT; -- valor 2000
		DECLARE @g_const_0 SMALLINT; -- Constante 0

		SET @mensaje = '';
		SET @g_const_2000  = 2000;
		SET @g_const_0 = 0;
		
		UPDATE tblLogueoUsu
		SET FechaSalida = @p_fecha_fin
		WHERE codUsuario = @p_codUsu AND FechaSalida IS NULL AND marcabaja = @g_const_0
		
		SET @mensaje = 'ACTUALIZACION EXITOSA'

		SELECT @g_const_2000 as 'codigo', @mensaje as 'mensaje'
			

	END	
GO

-- exec pa_cerrar_sesion_usuario 1,'2020-22-12'