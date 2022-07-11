
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_conceptos_sinc' AND type = 'P')
	DROP PROCEDURE pa_listar_conceptos_sinc
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Traer lista de conceptos
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_conceptos_sinc		
AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
		
		BEGIN TRY		
			SET @g_const_0 = 0

			SET NOCOUNT ON;  
			SELECT codConcepto,correlativo,descripcion FROM tblConcepto WHERE marcaBaja =  @g_const_0 AND correlativo > @g_const_0
			
		END TRY
		BEGIN CATCH
			SELECT 
			@g_const_0 as codConcepto ,
			ERROR_NUMBER() AS correlativo,
			ERROR_MESSAGE() AS descripcion;  


		END CATCH

	END	
GO

--exec pa_listar_conceptos_sinc

 