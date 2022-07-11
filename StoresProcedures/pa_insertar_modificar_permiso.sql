
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_insertar_modificar_permiso' AND type = 'P')
	DROP PROCEDURE pa_insertar_modificar_permiso
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------------------
-- Author: Jeffrey Garcia
-- Created: 24/04/2020
-- Sistema: WEB/PERMISOS DE USAURIO
-- Descripcion: insertar y modificar los permisos pro perfil
-- Log Modificaciones:
-- 
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_insertar_modificar_permiso]
(
	@p_list             XML,               -- XML DE PEMISOS
    @p_flag            TINYINT             -- tipo de operacion (1: insertar , 2: modificar )
)
AS
  
    DECLARE @codResponsable INT
	DECLARE @codPermiOpera INT
    DECLARE @opcion     INT
    DECLARE @codMenu   INT
    DECLARE @codigo  TINYINT               -- CODIGO DE VALIDACION
    DECLARE @ip      VARCHAR(20)    
    DECLARE @mac     VARCHAR(20)
    DECLARE @fecha    DATE
    DECLARE @hora     TIME   
    --CODIGO DE MENSAJES
    DECLARE @g_const_500 SMALLINT          -- CONSTANTE 500   
    DECLARE @g_const_505 SMALLINT          -- CONSTANTE 505
    --DESCRIPCION DE CODIGO DE MENSAJES  

BEGIN 
	SET NOCOUNT ON;
   
	BEGIN TRY
    SET @codResponsable = 0
    SET @opcion       = 0
    SET @codMenu       = 0         
	SET @codPermiOpera = 0
    SET @codigo = 0
	--CODIGO DE MENSAJES
    SET @g_const_500 = 500
    SET @g_const_505 = 505
          
	
	SET @ip =  (SELECT client_net_address FROM sys.dm_exec_connections WHERE session_id = @@SPID); -- ip 
	SET @mac = (SELECT substring(net_address,1,2)+':'+substring(net_address,3,2)+':'+substring(net_address,5,2)+':'+
				substring(net_address,7,2)+':'+substring(net_address,9,2)+':'+substring(net_address,11,2)	
				from sysprocesses where spid = @@SPID)

	SET  @fecha = (Select CONVERT(date,GETDATE(),9)) 
    SET  @hora = (Select CONVERT(TIME,GETDATE(),7)) 
	
		BEGIN
			IF @p_flag = 1
                BEGIN
                        DECLARE cur CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
								SELECT cast(colx.query('data(codPermiso)') as VARCHAR), cast(colx.query('data(codResponsable)') as VARCHAR)
                                ,cast(colx.query('data(opcion)') as VARCHAR)
								FROM @p_list.nodes('ArrayOfCENPermiso/CENPermiso') AS Tabx(Colx)              
								OPEN cur;  
								FETCH NEXT FROM cur INTO @codMenu, @codResponsable,@opcion
								WHILE @@FETCH_STATUS = 0
									BEGIN
									
                                        SET  @codigo = (SELECT COUNT(codPermiOpera) from tblPermiOpera 
                                        where codResponsable = @codResponsable 
                                        AND opcion=@opcion 
                                        AND codMenu = @codMenu
                                        AND marcaBaja = 0)

										 --paso 1: validar que dicho permiso no este registrado
                                        IF @codigo > 0
                                            BEGIN
                                                SELECT @g_const_500 as 'codigo'
                                            END
                                        ELSE
                                            BEGIN     
                                        -- paso 2: insertar el nuevo permiso si no esta registrado                    
                                                INSERT INTO tblPermiOpera
                                                (codResponsable,opcion,codMenu,marcaBaja,fechaProceso,horaProceso,usuario,ip,mac)
                                                VALUES (@codResponsable,@opcion,@codMenu,0,@fecha,@hora,'EAY',@ip,@mac)
                                                

                                                select @g_const_505 as'codigo'
                                            END
										
										FETCH NEXT FROM cur INTO @codMenu, @codResponsable,@opcion
		
									END
								CLOSE cur;  
								DEALLOCATE cur; 
                END
            ELSE IF @p_flag = 2
                BEGIN               
					DECLARE cur CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
					SELECT cast(colx.query('data(codPermiso)') as VARCHAR)
					FROM @p_list.nodes('ArrayOfCENPermiso/CENPermiso') AS Tabx(Colx)              
					OPEN cur;  
					FETCH NEXT FROM cur INTO @codPermiOpera
					WHILE @@FETCH_STATUS = 0
                    BEGIN
                        UPDATE tblPermiOpera
                        SET     fechaProceso = @fecha,
                                horaProceso=@hora,
                                ip=@ip,
                                mac=@mac,
								marcaBaja = 9 
                        WHERE codPermiOpera = @codPermiOpera
						FETCH NEXT FROM cur INTO @codPermiOpera
                    
                  END
								CLOSE cur;  
								DEALLOCATE cur; 
                    select @g_const_505 as'codigo'    
                END        
        END
	END TRY
	BEGIN CATCH        
	   SELECT ERROR_NUMBER() as 'codigo' 
	END CATCH
	
END 
