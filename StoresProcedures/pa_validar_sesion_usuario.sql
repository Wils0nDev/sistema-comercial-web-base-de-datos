IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_validar_sesion_usuario' AND type = 'P')
	DROP PROCEDURE pa_validar_sesion_usuario
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 18/02/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Validar sesion de usuario
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_validar_sesion_usuario
(
	@p_usuario VARCHAR(20),			-- Usuario
	@p_contra VARCHAR(30),			-- Contraseña
	@p_sucursal INT,			-- Sucursal
	@p_keyLogin VARCHAR(30),			-- Clave
	@p_tipo SMALLINT, -- tipo de consulta (1: Login, 2: Estado, 3: ntraUsuario)
	@p_ntraUsuario INT
)		
AS
	BEGIN
		DECLARE @codigo INT -- Codigo 
		DECLARE @mensaje VARCHAR(100) -- mensaje
		DECLARE @estado SMALLINT -- estado
		DECLARE @g_const_0 SMALLINT -- valor 0
		DECLARE @g_const_1 SMALLINT -- valor 1
		DECLARE @g_const_2 SMALLINT -- valor 2
		DECLARE @g_const_3 SMALLINT -- valor 3
		DECLARE @g_const_2000 SMALLINT -- valor 2000
		DECLARE @g_const_1000 SMALLINT -- valor 1000
		DECLARE @g_const_3000 SMALLINT -- valor 3000
		
		DECLARE @pass_aux VARBINARY(8000) -- Contraseña 
		DECLARE @clave VARCHAR(200) -- clave
		DECLARE @pass_desc VARCHAR(200) -- clave desencriptada
		DECLARE @ntra INT -- Numero de transaccion
		DECLARE @desc_concepto VARCHAR(250) -- Descripcion de concepto
		
		BEGIN TRY		

			SET @codigo = 0;
			SET @estado = 0;
			SET @mensaje = '';
			SET @g_const_0 = 0;
			SET @g_const_1 = 1;
			SET @g_const_2 = 2;
			SET @g_const_3 = 3;
			SET @g_const_2000  = 2000;
			SET @g_const_1000  = 1000;
			SET @g_const_3000 = 3000;
			SET @pass_desc = '';
			SET @ntra = 0;
			SET @estado = 0;
			SET @desc_concepto = '';
			
			SET NOCOUNT ON;  
			
			IF @p_tipo = @g_const_3				
				BEGIN					
					SELECT @estado = estado , @ntra= ntraUsuario, @pass_aux = password FROM tblUsuario WHERE ntraUsuario = @p_ntraUsuario AND marcaBaja = @g_const_0
				END
			ELSE
				BEGIN
					SELECT @estado = estado , @ntra= ntraUsuario, @pass_aux = password FROM tblUsuario WHERE users = @p_usuario AND codSucursal = @p_sucursal AND marcaBaja = @g_const_0 			
				END
					
			IF @ntra > @g_const_0
				BEGIN
					SELECT @desc_concepto = descripcion FROM tblConcepto WHERE codConcepto = 14 AND correlativo = @estado AND marcaBaja = @g_const_0
				
					SET  @mensaje = 'USUARIO ' + @desc_concepto
					SET @codigo = @g_const_2000;
					
				END
			ELSE
				BEGIN
					SET @mensaje = 'VALIDACION DE USUARIO INCORRECTA'
					SET @codigo = @g_const_1000
					SET @estado = @g_const_1
				END
			
			IF @p_tipo = @g_const_1 AND @ntra > @g_const_0 AND @estado = @g_const_1
				BEGIN
					
					SELECT @estado = estado, @ntra= ntraUsuario, @pass_aux = password FROM tblUsuario WHERE users = @p_usuario AND codSucursal = @p_sucursal AND marcaBaja = @g_const_0 AND estado = @g_const_1

					SELECT @pass_desc = CAST(DECRYPTBYPASSPHRASE(@p_keyLogin,@pass_aux) AS VARCHAR(MAX))

					IF LTRIM(@pass_desc) = LTRIM(@p_contra) COLLATE SQL_Latin1_General_CP1_CS_AS
						BEGIN
							SET  @mensaje = 'VALIDACION DE USUARIO CORRECTA'
							SET @codigo = @g_const_2000
							SET @estado = @g_const_0;
							--SELECT @ntra AS 'ntraUsuario', @codigo as 'codigo', @mensaje as 'mensaje',@estado as 'estado'
						END
					ELSE
						BEGIN
							SET  @mensaje = 'VALIDACION DE USUARIO INCORRECTA'
							SET @codigo = @g_const_1000
							SET @estado = @g_const_1
							--SELECT @g_const_0 AS 'ntraUsuario', @codigo as 'codigo', @mensaje as 'mensaje',@estado as 'estado'
						END
				END
			
				
			SELECT @ntra AS 'ntraUsuario', @codigo as 'codigo', @mensaje as 'mensaje',@estado as 'estado'					
			
			

		END TRY
		BEGIN CATCH
		
			SET @codigo = @g_const_3000
			SET @estado = @g_const_1
			SET @mensaje = ERROR_MESSAGE()

			SELECT @g_const_0 AS 'ntraUsuario', @codigo as 'codigo', @mensaje as 'mensaje',@estado as 'estado'

		END CATCH

	END	
GO

-- EXEC pa_validar_sesion_usuario 'admin','Jjibaja123@',1,'IdeSolution2020',1,0