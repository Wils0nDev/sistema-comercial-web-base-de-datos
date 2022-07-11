
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_subcategoria' AND type = 'P')
	DROP PROCEDURE pa_listar_subcategoria
GO
----------------------------------------------------------------------------------
-- Author: Jose Chumioque IDE-SOLUTION
-- Created: 06/01/2020  
-- Sistema: Sistema de Preventas
-- Modulo: General
-- Descripción: Listar subcategorias de Productos
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_subcategoria	
(
@codSubCategoria INT
)
AS
SET NOCOUNT ON

BEGIN
        DECLARE @g_const_0 INT -- valor 0	

BEGIN TRY      
           SET @g_const_0 = 0;
   BEGIN
	 SELECT ntraSubcategoria,descripcion
	 FROM tblSubcategoria WHERE codCategoria =@codSubCategoria AND  marcaBaja = @g_const_0;
   END
END TRY
BEGIN CATCH
           SELECT   
	        ERROR_NUMBER() AS ErrorNumber  
	       ,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
END
GO
