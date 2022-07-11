
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_registrar_login_fallido' AND type = 'P')
	DROP PROCEDURE pa_registrar_login_fallido
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 20/02/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Registro login fallido
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_registrar_login_fallido
(
	@p_codUsu INT,			-- Usuario
	@p_cantFall SMALLINT,			-- tipo de logueo
	@p_fecha DATETIME, -- Fecha de inicio
	@p_ip VARCHAR(20), -- ip
	@p_mac VARCHAR(20) -- MAC

)		
AS
	BEGIN
		DECLARE @codigo INT; -- Codigo 
		DECLARE @mensaje VARCHAR(100); -- mensaje
		DECLARE @g_const_2000 SMALLINT; -- valor 2000
		DECLARE @g_const_0 SMALLINT; -- Constante 0
		

		SET @mensaje = 'CONSULTA EXITOSA';
		SET @g_const_2000  = 2000;
		SET @g_const_0 = 0;
		
		DELETE tblLoginFallido WHERE codUsuario = @p_codUsu AND marcaBaja = @g_const_0;

		INSERT INTO tblLoginFallido(codUsuario, cantFallido, FechaRegistro, usuario,ip,mac)
		VALUES(@p_codUsu,@p_cantFall,@p_fecha,@p_codUsu,@p_ip,@p_mac)
		
		SELECT @g_const_2000 as 'codigo', @mensaje as 'mensaje'
			

	END	
GO

-- exec pa_registrar_login_fallido 1,1,'2020-22-12','172.18.1.184','AD:20:CD:29'

