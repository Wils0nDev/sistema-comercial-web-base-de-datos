
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_login_fallido_usuario' AND type = 'P')
	DROP PROCEDURE pa_listar_login_fallido_usuario
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 20/02/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Listar login fallido por usuario
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_login_fallido_usuario
(
	@p_codUsu INT			-- Usuario
)		
AS
	BEGIN
		DECLARE @codigo INT; -- Codigo 
		DECLARE @g_const_0 SMALLINT; -- Constante 0
		
		SET @g_const_0 = 0;
		
		SELECT codUsuario,cantFallido,FechaRegistro 
		FROM tblLoginFallido 
		WHERE codUsuario = @p_codUsu AND marcaBaja = @g_const_0
			

	END	
GO

-- exec pa_listar_login_fallido_usuario 1

