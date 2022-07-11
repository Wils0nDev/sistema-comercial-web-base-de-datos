IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_actualizar_perfil' AND type = 'P')
	DROP PROCEDURE pa_actualizar_perfil
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------------------
-- Author: Jeffrey Garcia
-- Created: 17/04/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: Actualizar datos de perfil
-- Log Modificaciones:
-- 
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_actualizar_perfil]
(
	@p_nombre		        VARCHAR(20),            -- nombre 
    @p_apellidoPaterno		VARCHAR(20),            -- apellido paterno
    @p_apellidoMaterno		VARCHAR(20),            -- apellio materno
    @p_telefono		        VARCHAR(20),            -- telefono
    @p_correo		        VARCHAR(20),            -- correo
	@p_password		        VARCHAR(30),            -- password
    @p_codPersona           INT   ,                 -- codUPersona
    @p_codUsuario           INT                     -- codUsuario

)
AS
BEGIN
    --CODIGO DE MENSAJES
    DECLARE @g_const_505 SMALLINT                    -- CONSTANTE 500    
    --DESCRIPCION DE CODIGO DE MENSAJES
    DECLARE @g_const_M505 VARCHAR(70)                -- DESCRIPCION DE MENSAJE 500
    
    DECLARE @ip VARCHAR(20)                         -- IP 
	DECLARE @MAC VARCHAR(20)                        -- MAC
	DECLARE @fecha date                             -- FECHA DE PROCESO
    DECLARE @keyLogin VARCHAR(50)                   -- CLAVE DE ENCRIPTACION    
	DECLARE @hora time                              -- hora de proceso
    SET NOCOUNT ON;
   
	BEGIN TRY
	--CODIGO DE MENSAJES
    SET @g_const_505 = 505      
    SET @g_const_M505 = 'DATOS ACTUALIZADOS CORRECTAMENTE'

	SET @ip =  (SELECT client_net_address FROM sys.dm_exec_connections WHERE session_id = @@SPID); -- ip 
	SET @MAC = (SELECT substring(net_address,1,2)+':'+substring(net_address,3,2)+':'+substring(net_address,5,2)+':'+
				substring(net_address,7,2)+':'+substring(net_address,9,2)+':'+substring(net_address,11,2)	
				from sysprocesses where spid = @@SPID)

	SET  @fecha = (Select CONVERT (date, GETDATE())) 
    SET  @hora =   (select CONVERT (time, GETDATE()))
	SET  @keyLogin = 'IdeSolution2020'
	
		BEGIN
			BEGIN TRANSACTION
                UPDATE tblPersona
                SET nombres = @p_nombre, apellidoPaterno = @p_apellidoPaterno,
                apellidoMaterno = @p_apellidoMaterno, telefono = @p_telefono,
                correo=@p_correo,horaProceso = @hora ,fechaProceso = @fecha,ip = @ip,
                mac = @MAC 
                where codPersona = @P_codPersona


                UPDATE tblUsuario
                SET [password] =  CAST(ENCRYPTBYPASSPHRASE(@keyLogin,@p_password) AS VARBINARY(8000)),
                ip = @ip,mac =@MAC,fechaProceso = @fecha,horaProceso = @hora
                WHERE ntraUsuario = @p_codUsuario 

                select @g_const_505  as 'respuesta', @g_const_M505 as 'mensaje'
            COMMIT TRANSACTION        
	    END
	END TRY
	BEGIN CATCH        
       ROLLBACK TRANSACTION
	   SELECT ERROR_NUMBER() as 'respuesta' , 'Error en pa_buscar_credenciales_usuario' + ERROR_MESSAGE() as 'mensaje'
	END CATCH
	
END 
