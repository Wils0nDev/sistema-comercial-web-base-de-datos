IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_actualizar_usuario' AND type = 'P')
	DROP PROCEDURE pa_actualizar_usuario
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------------------
-- Author: Joseph Lenin G. IDE-SOLUTION
-- Sistema: Sistema Distribuidora Virgen del Carmen
-- Modulo: General
-- Descripción: acutalizar usuario
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_actualizar_usuario]	
(
	@p_tipoPersona TINYINT,					
	@p_tipoDocumento TINYINT,
	@p_numDocumento VARCHAR(15),
	@p_codUsuario INTEGER,				
	@p_nombres VARCHAR(30),				
	@p_apePaterno VARCHAR(20),			
	@p_apeMaterno VARCHAR(20),			
	@p_direccion VARCHAR(100),			
	@p_correo VARCHAR(60),				
	@p_telefono VARCHAR(15),
	@p_ubigeo CHAR(6),
	@p_celular CHAR(9),					
	@p_codEstado TINYINT,
	
	 @users  VARCHAR(20),
	 @codPerfil INT,
	 @estado TINYINT , 
	 @marcaBaja TINYINT,
	 @fechaProceso date,
	 @horaProceso time,
	 @codSucursal int ,
	 @password varbinary,
	
	
	@p_usuario VARCHAR(20),				
	@p_ip VARCHAR(20),					
	@p_mac VARCHAR(20)					
)
AS
BEGIN
		SET NOCOUNT ON;
		DECLARE @mensaje VARCHAR(100);		-- mensaje
		DECLARE @flag INT;					--flag de proceso
		DECLARE @codPersona INT;			--codigo de persona
		
		SET @flag = 0;
		SET @mensaje = 'CONSULTA EXITOSA';
		SET @codPersona = 0;
		
		
	BEGIN TRY
		IF (@p_tipoPersona = 1 AND @p_tipoDocumento = 1)
			BEGIN
				SET @codPersona = @p_numDocumento;
			END
			BEGIN TRANSACTION
				INSERT INTO tblPersona (codPersona, tipoPersona, tipoDocumento, numeroDocumento, nombres, apellidoPaterno, 
				apellidoMaterno, direccion, correo, telefono, celular, codUbigeo, marcaBaja, usuario, ip, mac) 
				VALUES(@codPersona, @p_tipoPersona, @p_tipoDocumento, @p_numDocumento, @p_nombres, @p_apePaterno, @p_apeMaterno, 
				@p_direccion, @p_correo, @p_telefono, @p_celular, @p_ubigeo, 0, @p_usuario, @p_ip, @p_mac);

				--INSERT INTO tblLocalizacion(codPersona,coordenadaX,coordenadaY,marcaBaja,usuario,ip,mac) 
				--VALUES(@codPersona,@p_coordenadaX,@p_coordenadaY,0, @p_usuario, @p_ip, @p_mac);

				--INSERT INTO tblUsuario(codPersona,users  , codPerfil, estado, marcaBaja, fechaProceso,horaProceso,horaProceso,password,codSucursal)
				--VALUES (@codPersona, @users  , @codPerfil, @estado, @marcaBaja, @fechaProceso,@horaProceso,@password,@codSucursal);


				COMMIT TRANSACTION
					END TRY
	BEGIN CATCH
		IF (XACT_STATE()) <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END
		SET @flag = ERROR_NUMBER();
		SET @mensaje = 'Error en pa_actualizar_usuario ' + ERROR_MESSAGE();
		SET @codPersona = 0;
		
		SELECT @flag as flag , @mensaje as msje, @codPersona as codPersona
	END CATCH
END
