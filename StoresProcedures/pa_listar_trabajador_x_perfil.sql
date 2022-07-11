IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_trabajador_x_perfil' AND type = 'P')
	DROP PROCEDURE pa_listar_trabajador_x_perfil
GO
----------------------------------------------------------------------------------
-- Author: Giancarlos Sanginez IDE-SOLUTION
-- Created: 24/04/2020  
-- Sistema: web virgen del Carmen
-- Modulo: RRHH
-- Descripción: Listar trabajador segun perfil
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_trabajador_x_perfil	
(
@codPerfil INT
)
AS
SET NOCOUNT ON

BEGIN
        DECLARE @g_const_0 INT -- valor 0	

BEGIN TRY      
           SET @g_const_0 = 0;
   BEGIN
	 SELECT t.codPersona, CONCAT(p.nombres,' ', p.apellidoPaterno,' ',p.apellidoMaterno) as Trabajador, pe.descripcion as Cargo	
	 FROM tblTrabajador t INNER JOIN tblPersona p on p.codPersona = t.codPersona
	 INNER JOIN tblPerfil pe on pe.codigo = t.cargo
	 WHERE pe.codigo = @codPerfil
   END
END TRY
BEGIN CATCH
           SELECT   
	        ERROR_NUMBER() AS ErrorNumber  
	       ,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
END
GO