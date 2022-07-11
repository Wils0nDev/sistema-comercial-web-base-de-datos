
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_categorias' AND type = 'P')
	DROP PROCEDURE pa_listar_categorias
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 03/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Traer lista de categorias
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_categorias		
AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
		
		BEGIN TRY		
			SET @g_const_0 = 0

			SET NOCOUNT ON;  
			SELECT ntraCategoria,descripcion FROM tblCategoria WHERE marcaBaja = @g_const_0 ORDER BY ntraCategoria 
			
		END TRY
		BEGIN CATCH
			SELECT   
	        ERROR_NUMBER() AS ErrorNumber  
	       ,ERROR_MESSAGE() AS ErrorMessage;  

		END CATCH

	END	
GO

--exec pa_listar_categorias