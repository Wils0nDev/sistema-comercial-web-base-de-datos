
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_validar_usuario_activo' AND type = 'P')
	DROP PROCEDURE pa_validar_usuario_activo
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Validar usuario activo
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_validar_usuario_activo
(
	@p_codUsu INT			-- Usuario

)			
AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
		DECLARE @g_const_1 SMALLINT -- valor 1
		DECLARE @cont SMALLINT -- Contador de usuario activo
		
		SET @g_const_0 = 0
		SET @g_const_1 = 1
		
		SET NOCOUNT ON;  
		SELECT @cont = COUNT(ntraUsuario) FROM tblUsuario WHERE ntraUsuario = @p_codUsu AND estado = @g_const_1 AND marcaBaja = @g_const_0
		SELECT @cont AS contador

	END	
GO

--exec pa_validar_usuario_activo 1

 