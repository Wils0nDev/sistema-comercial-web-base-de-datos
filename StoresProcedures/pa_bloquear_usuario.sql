
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_bloquear_usuario' AND type = 'P')
	DROP PROCEDURE pa_bloquear_usuario
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 20/02/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Bloquear usuario
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_bloquear_usuario
(
	@p_codUsu INT			-- Usuario

)		
AS
	BEGIN
		DECLARE @codigo INT; -- Codigo 
		DECLARE @mensaje VARCHAR(100); -- mensaje
		DECLARE @g_const_2000 SMALLINT; -- valor 2000
		DECLARE @g_const_0 SMALLINT; -- Constante 0
		DECLARE @g_const_3 SMALLINT; -- Constante 3

		SET @mensaje = 'CONSULTA EXITOSA';
		SET @g_const_2000  = 2000;
		SET @g_const_0 = 0;
		SET @g_const_3 = 3;
		
		UPDATE tblUsuario
		SET estado = @g_const_3
		WHERE ntraUsuario = @p_codUsu AND marcaBaja = @g_const_0
		
		SELECT @g_const_2000 as 'codigo', @mensaje as 'mensaje'
			

	END	
GO

-- exec pa_bloquear_usuario 1

