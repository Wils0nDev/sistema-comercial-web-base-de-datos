
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_conceptos' AND type = 'P')
	DROP PROCEDURE pa_listar_conceptos
GO
----------------------------------------------------------------------------------
-- Author: Luis Llatas IDE-SOLUTION
-- Created: 10/02/2020  
-- Sistema: WEB / Mantenedor Precios
-- Descripción: Listar conceptos
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[pa_listar_conceptos]
(
 @p_pref INT
)	

AS 
  BEGIN
   SET NOCOUNT ON
       DECLARE @corr TINYINT -- correlativo del concepto 
       DECLARE @desc VARCHAR(250) -- descripcion del concepto
	
	 BEGIN TRY		

             SET @corr = 0;
	     SET @desc = '';
			
	     SELECT correlativo,descripcion FROM fu_buscar_conceptos_generales (@p_pref)
             SELECT @corr as 'correlativo', @desc as 'descripcion'

	 END TRY
         BEGIN CATCH
		   
			SET @desc = ERROR_MESSAGE()
			SELECT @corr as 'correlativo', @desc as 'descripcion'

	 END CATCH
END

GO