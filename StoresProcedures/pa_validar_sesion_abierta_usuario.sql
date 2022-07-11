
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_validar_sesion_abierta_usuario' AND type = 'P')
	DROP PROCEDURE pa_validar_sesion_abierta_usuario
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 03/06/2019  
-- Sistema: ws_wa_DistribuidoraVDC
-- Modulo: General
-- Descripción: Validar sesion de usuario
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_validar_sesion_abierta_usuario
(
	@p_codUsu INT			-- Usuario

)		
AS
	BEGIN
		DECLARE @mensaje VARCHAR(100); -- mensaje
		DECLARE @g_const_0 SMALLINT; -- Constante 0
		DECLARE @contador SMALLINT; -- Contador de sesiones
		

		SET @mensaje = '';
		SET @contador = 0;
		SET @g_const_0 = 0;
		
		SELECT @contador = COUNT(ntraLogueo) FROM tblLogueoUsu WHERE codUsuario = @p_codUsu AND FechaSalida IS NULL AND marcabaja = @g_const_0
		SET @mensaje = 'CONSULTA EXITOSA'

		SELECT @contador as 'contador', @mensaje as 'mensaje'
			

	END	
GO

-- exec pa_validar_sesion_abierta_usuario 1