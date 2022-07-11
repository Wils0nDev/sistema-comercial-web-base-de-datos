
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_buscar_datos_perfil' AND type = 'P')
	DROP PROCEDURE pa_buscar_datos_perfil
GO
----------------------------------------------------------------------------------
-- Author: JEFFREY GARCIA IDE-SOLUTION
-- Created: 17/04/2020  
-- Sistema: WEB/PERFIL
-- Modulo: General
-- Descripci�n: buscar datos de perfil
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_buscar_datos_perfil
(
	@p_codUsuario INT,			-- codigo de Usuario
	@p_codPersona INT          -- codigo de persona

)		
AS
BEGIN  
    DECLARE @keyLogin VARCHAR(50)                   -- CLAVE DE ENCRIPTACION    
	
    SET NOCOUNT ON;   
	BEGIN TRY	

	SET  @keyLogin = 'IdeSolution2020'

		BEGIN
			
                select  u.users as 'usuario',p.nombres as 'nombres' ,p.apellidoPaterno as 'apellidoPaterno',
                p.apellidoMaterno as 'apellidoMaterno',p.correo as 'correo',p.telefono as 'telefono',
                CAST(DECRYPTBYPASSPHRASE(@keyLogin,u.password) AS VARCHAR(MAX)) as 'password' 
                from tblPersona as p
                inner join tblUsuario as u  on u.codPersona = p.codPersona
                where p.codPersona = @p_codPersona and u.ntraUsuario = @p_codUsuario
                   
	    END
	END TRY
	BEGIN CATCH        
	   SELECT ERROR_NUMBER() as 'respuesta' , 'Error en pa_buscar_datos_perfil ' + ERROR_MESSAGE() as 'mensaje'
	END CATCH
END
GO
