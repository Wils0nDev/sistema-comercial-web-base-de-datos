IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_buscar_credenciales_usuario' AND type = 'P')
	DROP PROCEDURE pa_buscar_credenciales_usuario
GO
----------------------------------------------------------------------------------
-- Author: Jeffrey Garcia
-- Created: 21/04/2020
-- Sistema: WEB/LOGIN
-- Descripcion: buscar credenciales de usuario
-- Log Modificaciones:
-- 
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_buscar_credenciales_usuario]
(
	@p_usuario		VARCHAR(20),            -- nombre de usuario
	@p_password		VARCHAR(50) = NULL,     -- password
    @p_intentos     TINYINT = NULL,         -- Numero de intento de ingreso 
    @p_flag         TINYINT,				-- tipo de operacion (1: login , 2: recuperacion contraseña)
    @p_sucursal     INTEGER 				-- Codigo de sucursal
	                 
)
AS
CREATE TABLE  #tmpUser  ( 
    codusuario INTEGER,
    usuario varchar(20),                    
    [password] VARCHAR(MAX),
    codpersona INTEGER ,
    perfil VARCHAR(20),
	nombreCompleto VARCHAR(80) ,
    estadoUsuario VARCHAR(30),
    estadoPersona TINYINT,
    correo VARCHAR(30),
    sucursal INTEGER,
	telefono VARCHAR(15) )

    DECLARE @count smallint

    DECLARE  @codUsuario INTEGER                -- CODIGO DE USUARIO
    DECLARE @usuario varchar(20)            -- NOMBRE DE USUARIO    
    DECLARE @password VARCHAR(MAX)          -- PASSWORD
    DECLARE @codpersona INTEGER             -- CODIGO DE PERSONA
    DECLARE @perfil VARCHAR(20)             -- PERFIL DEL USUARIO
	DECLARE @nombreCompleto VARCHAR(80)     -- NOMBRES COMPLETOS 
    DECLARE @estadoUsuario VARCHAR(30)      -- ESTADO DE USUARIO
    DECLARE @estadoPersona TINYINT          -- ESTADO DE LA PERSONA    
    DECLARE @correo VARCHAR(30)             -- CORREO   
    DECLARE @sucursal INTEGER                   -- SUCURSAL
    DECLARE @telefono VARCHAR(15)			-- TELEFONO
	DECLARE @ip VARCHAR(20)                 -- IP 
	DECLARE @MAC VARCHAR(20)                -- MAC
	DECLARE @fecha DATETIME                 -- FECHA DE PROCESO
    DECLARE @keyLogin VARCHAR(50)           -- CLAVE DE ENCRIPTACION    

    --CODIGO DE MENSAJES
    DECLARE @g_cont_500 SMALLINT            -- CONSTANTE 500    
    DECLARE @g_cont_501 SMALLINT            -- CONSTANTE 501             
    DECLARE @g_cont_502 SMALLINT            -- CONSTANTE 502
    DECLARE @g_cont_503 SMALLINT            -- CONSTANTE 503
    DECLARE @g_cont_504 SMALLINT            -- CONSTANTE 504
    DECLARE @g_cont_505 SMALLINT            -- CONSTANTE 505
    DECLARE @g_cont_506 SMALLINT            -- CONSTANTE 506
    DECLARE @g_cont_507 SMALLINT            -- CONSTANTE 507

    --DESCRIPCION DE CODIGO DE MENSAJES
    DECLARE @g_cont_M500 VARCHAR(70)        -- DESCRIPCION DE MENSAJE 500
    DECLARE @g_cont_M501 VARCHAR(70)        -- DESCRIPCION DE MENSAJE 501
    DECLARE @g_cont_M502 VARCHAR(70)        -- DESCRIPCION DE MENSAJE 502
    DECLARE @g_cont_M503 VARCHAR(70)        -- DESCRIPCION DE MENSAJE 503
    DECLARE @g_cont_M504  varchar(70)       -- DESCRIPCION DE MENSAJE 504
    DECLARE @g_cont_M506  varchar(70)       -- DESCRIPCION DE MENSAJE 506
    DECLARE @g_cont_M507  varchar(70)       -- DESCRIPCION DE MENSAJE 507
    DECLARE @g_const_0 TINYINT              -- CONSTANTE 0
BEGIN 
	SET NOCOUNT ON;
   
	BEGIN TRY
	--CODIGO DE MENSAJES
    SET @g_cont_500 = 500
    SET @g_cont_501 = 501
    SET @g_cont_502 = 502 
    SET @g_cont_503 = 503
    SET @g_cont_504 = 504
    SET @g_cont_505 = 505
    SET @g_cont_506 = 506
	SET @g_cont_507 = 507
    SET @g_const_0 = 0  
    SET @g_cont_M500 = 'USUARIO NO ENCONTRADO '
    SET @g_cont_M501 = 'LIMITE MAXIMO DE INTENTOS ALCANZADOS'
    SET @g_cont_M502 = 'CONTRASEÑA INCORRECTA ' 
    SET @g_cont_M503 = 'USUARIO NO PUEDE ACCEDER POR ESTAR CON ESTADO: '
    SET @g_cont_M504 = 'LA PERSONA NO PUEDE ACCEDER POR ESTAR CON ESTADO: '
	SET @g_cont_M506 = 'EL USUARIO YA CUENTA CON UNA SESION ACTIVA '
	SET @g_cont_M507 = 'EL USUARIO NO ESTA REGISTRADO EN ESTA SUCURSAL '

	SET  @codUsuario = 0
	SET @usuario = NULL
	SET @password = NULL
	SET @codpersona = 0
	SET @perfil = NULL
	SET @nombreCompleto = NULL
	SET @estadoUsuario = NULL
	SET @estadoPersona = 0
    SET @correo = NULL
    SET @sucursal = 0
	SET @telefono = NULL
	SET @ip =  (SELECT client_net_address FROM sys.dm_exec_connections WHERE session_id = @@SPID); -- ip 
	SET @MAC = (SELECT substring(net_address,1,2)+':'+substring(net_address,3,2)+':'+substring(net_address,5,2)+':'+
				substring(net_address,7,2)+':'+substring(net_address,9,2)+':'+substring(net_address,11,2)	
				from sysprocesses where spid = @@SPID)

	SET  @fecha = (Select CONVERT(datetime,GETDATE(),9) as [MMM DD YYYY hh:mm:ss:mmm(AM/PM)]) 
	SET @keyLogin = 'IdeSolution2020'
	
		BEGIN
			
			INSERT into #tmpUser 
			SELECT * from v_listar_usuario_login where usuario = @p_usuario AND sucural = @p_sucursal

            SET @count =(SELECT count(*) FROM #tmpUser);

            IF @count = 0 
                BEGIN
				    DROP TABLE #tmpUser	
                    select @g_cont_507 as 'respuesta', @g_cont_M507 as 'nombres';
                END
							
			ELSE
                BEGIN
                    
                    IF @p_flag = 1
                        BEGIN                  
                            IF @p_intentos > 3 -- numero de intentos 
                                BEGIN
                                -- se cambia el estado de usuario a bloqueado                                   
                                
                                    UPDATE tblUsuario
                                    SET estado = 3
                                    WHERE users = @p_usuario

                                    INSERT INTO tblLoginFallido(codUsuario, cantFallido, FechaRegistro, usuario,ip,mac)
                                    VALUES(@codUsuario,@p_intentos,@fecha,@codUsuario,@ip,@mac)
            
                                    DROP TABLE #tmpUser
                                    SELECT @g_cont_501 as 'respuesta', @g_cont_M501 as 'nombres';
                        
                                END
                        ELSE
                            BEGIN
                            --VALIDAMOS QUE LA CONTRASEÑA INGRESADA SEA LA CORRECTA

                             SET @count = (SELECT COUNT(*) from #tmpUser 
                             where CAST(DECRYPTBYPASSPHRASE(@keyLogin,[password]) AS VARCHAR(MAX)) = @p_password and sucursal = @p_sucursal);

                                IF @count = 0                                                                      
                                    BEGIN
                                            DROP TABLE #tmpUser
                                            SELECT @g_cont_502 as 'respuesta', @g_cont_M502 as 'nombres';   
                                    END
                                ELSE
                                    BEGIN
                                        
                                        SELECT @codUsuario =codusuario ,@usuario =usuario , 
                                        @password = [password],@codpersona = codpersona,@perfil = perfil,
                                        @nombreCompleto = nombreCompleto, @estadoUsuario = estadoUsuario, 
                                        @estadoPersona = estadoPersona ,@correo = correo, @sucursal = sucursal, @telefono = telefono        
                                        from #tmpUser where CAST(DECRYPTBYPASSPHRASE(@keyLogin,[password]) AS VARCHAR(MAX)) = @p_password

                                        --validamos que le usuario no tenga una sesion activa

                                        SELECT @count = COUNT(ntraLogueo) FROM tblLogueoUsu 
                                        WHERE codUsuario = @codUsuario AND FechaSalida IS NULL AND marcabaja = @g_const_0
                                        
                                        IF @count = 0  -- usuario no tiene sesion activa
                                            BEGIN
                                             IF @estadoUsuario = 'ACTIVO'  -- USUARIO ACTIVO
                                            BEGIN             
                                                IF @estadoPersona = 0     -- PERSONA ACTIVA  
                                                    BEGIN
                                                    
                                                        INSERT INTO tblLogueoUsu(codUsuario, FechaIngreso, FechaSalida, tipoLogueo, usuario)
                                                        VALUES(@codUsuario,@fecha,NULL,1,@codUsuario)
                                                        
                                                        DROP TABLE #tmpUser
                                                        select  @g_cont_505 as 'respuesta',@codUsuario as 'codUsuario',@perfil as 'perfil',@nombreCompleto as 'nombres', @sucursal as 'sucursal',@telefono as'telefono',@codpersona AS 'codPersona';
                                                    END

                                                ELSE                                    
                                                    BEGIN 
                                                        
                                                        INSERT INTO tblLoginFallido(codUsuario, cantFallido, FechaRegistro, usuario,ip,mac)
                                                        VALUES(@codUsuario,@p_intentos,@fecha,@codUsuario,@ip,@mac)

                                                        DROP TABLE #tmpUser
                                                        select @g_cont_504 as 'respuesta', CONCAT(@g_cont_M504,@estadoPersona) as 'nombres';
                                                    END
                                            
                                            END
                                        ELSE
                                            BEGIN
                                                DROP TABLE #tmpUser
                                                INSERT INTO tblLoginFallido(codUsuario, cantFallido, FechaRegistro, usuario,ip,mac)
                                                VALUES(@codUsuario,@p_intentos,@fecha,@codUsuario,@ip,@mac)
                                                
                                                select @g_cont_503 as 'respuesta', CONCAT(@g_cont_M503,@estadoUsuario) as 'nombres';
                                            END    
                                            END
                                        ELSE
                                            BEGIN
                                                SELECT @g_cont_506 as 'respuesta',@g_cont_M506 as 'nombres'
                                            END                                       
                                    END    
                            END

                        END
                    else IF @p_flag = 2
                        BEGIN 
                            SELECT @codUsuario =codusuario ,@usuario =usuario , 
                                    @password = [password],@codpersona = codpersona,@perfil = perfil,
                                    @nombreCompleto = nombreCompleto, @estadoUsuario = estadoUsuario, 
                                    @estadoPersona = estadoPersona ,@correo = correo, @sucursal = sucursal,@telefono = telefono          
                                from #tmpUser where usuario= @p_usuario   

                            IF @correo = null OR @usuario = null   
                                BEGIN 
                                    DROP TABLE #tmpUser
                                    select @g_cont_500 as 'respuesta',@g_cont_M500 as 'nombres';
                                END
                            ELSE
                            BEGIN    
                                IF @estadoUsuario = 'ACTIVO'  -- USUARIO ACTIVO
                                            BEGIN             
                                                IF @estadoPersona = 0     -- PERSONA ACTIVA  
                                                BEGIN
                                                
                                                    INSERT INTO tblLogueoUsu(codUsuario, FechaIngreso, FechaSalida, tipoLogueo, usuario)
                                                    VALUES(@codUsuario,@fecha,NULL,1,@codUsuario)
                                                    
                                                    DROP TABLE #tmpUser
                                                    select  @g_cont_505 as 'respuesta',@correo as 'correo',CAST(DECRYPTBYPASSPHRASE(@keyLogin,@password)AS VARCHAR(MAX)) as 'password', @telefono  as 'telefono' 
                                                END

                                                ELSE                                    
                                                BEGIN 
                                                    
                                                    INSERT INTO tblLoginFallido(codUsuario, cantFallido, FechaRegistro, usuario,ip,mac)
                                                    VALUES(@codUsuario,@p_intentos,@fecha,@codUsuario,@ip,@mac)

                                                    DROP TABLE #tmpUser
                                                    select @g_cont_504 as 'respuesta', CONCAT(@g_cont_M504,@estadoPersona) as 'nombres';
                                                END
                                            
                                            END
                                ELSE
                                        BEGIN
                                            DROP TABLE #tmpUser
                                            INSERT INTO tblLoginFallido(codUsuario, cantFallido, FechaRegistro, usuario,ip,mac)
		                                    VALUES(@codUsuario,@p_intentos,@fecha,@codUsuario,@ip,@mac)
                                            
                                            select @g_cont_503 as 'respuesta', CONCAT(@g_cont_M503,@estadoUsuario) as 'nombres';
                                        END      
                            END                         
                        END
                    END
	    END
	END TRY
	BEGIN CATCH        
	   DROP TABLE #tmpUser
	   SELECT ERROR_NUMBER() as 'respuesta' , 'Error en pa_buscar_credenciales_usuario' + ERROR_MESSAGE() as 'nombres'
	END CATCH
	
END 
