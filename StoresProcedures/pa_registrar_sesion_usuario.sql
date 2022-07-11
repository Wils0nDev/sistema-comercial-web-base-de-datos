
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_registrar_sesion_usuario' AND type = 'P')
	DROP PROCEDURE pa_registrar_sesion_usuario
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 03/06/2019  
-- Sistema: ws_wa_DistribuidoraVDC
-- Modulo: General
-- Descripción: Registro sesion de usuario
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_registrar_sesion_usuario
(
	@p_codUsu INT,			-- Usuario
	@p_tipoLog SMALLINT,			-- tipo de logueo
	@p_fecha_ini DATETIME, -- Fecha de inicio
	@p_fecha_fin DATETIME = NULL, -- Fecha de fin
	@p_usuario VARCHAR(20)		-- Usuario

)		
AS
	BEGIN
		DECLARE @codigo INT; -- Codigo 
		DECLARE @mensaje VARCHAR(100); -- mensaje
		DECLARE @g_const_2000 SMALLINT; -- valor 2000
		DECLARE @ntra INT; --Numero de transaccion
		

		SET @mensaje = '';
		SET @g_const_2000  = 2000;
		SET @ntra = 0;
		
		INSERT INTO tblLogueoUsu(codUsuario, FechaIngreso, FechaSalida, tipoLogueo, usuario)
		VALUES(@p_codUsu,@p_fecha_ini,@p_fecha_fin,@p_tipoLog,@p_usuario)
		
		SET @ntra = SCOPE_IDENTITY()		
		SET @mensaje = 'CONSULTA EXITOSA'


		SELECT @ntra as 'ntra', @g_const_2000 as 'codigo', @mensaje as 'mensaje'
			

	END	
GO

-- exec pa_registrar_sesion_usuario 1,2,'2020-22-12',NULL,'1'