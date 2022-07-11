
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_puntos_entregas' AND type = 'P')
	DROP PROCEDURE pa_listar_puntos_entregas
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripci?n: Traer lista puntos de entrega 
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_puntos_entregas	
AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
		DECLARE @g_const_2 SMALLINT -- valor 2
		DECLARE @g_const_vacio CHAR(1) -- Constante vacio
		DECLARE @g_const_2000 SMALLINT -- Constante 2000
		DECLARE @g_const_msj VARCHAR(200) -- Mensaje
		BEGIN TRY		
			
			SET @g_const_vacio = '';
			SET @g_const_0 = 0;
			SET @g_const_2 = 2;
			SET @g_const_2000 = 2000
			SET @g_const_msj = 'Consulta exitosa'

			SET NOCOUNT ON;
			
			

			 SELECT ntraPuntoEntrega,coordenadaX,coordenadaY,tblPuntoEntrega.direccion,referencia,
			 ordenEntrega,tblPuntoEntrega.codPersona
			 ,(CASE   
			      WHEN (tblPersona.tipoPersona) = @g_const_2 THEN tblPersona.ruc ELSE tblPersona.numeroDocumento
			   END ) AS numeroDocumento,tblPersona.tipoPersona as 'tipoDocumento'
			, @g_const_2000 AS codigo
			, @g_const_msj as mensaje 
						FROM tblPuntoEntrega INNER JOIN tblPersona 
						ON tblPuntoEntrega.codPersona = tblPersona.codPersona
						where tblPuntoEntrega.marcaBaja =@g_const_0  
			
			
		END TRY
		BEGIN CATCH
			SELECT
					@g_const_0 AS ntraPuntoEntrega, 
					@g_const_vacio AS coordenadaX, 
					@g_const_vacio AS coordenadaY, 
					@g_const_vacio AS direccion,
					@g_const_vacio AS referencia,
					@g_const_0 AS ordenEntrega, 
					@g_const_0 AS codPersona, 
					@g_const_vacio AS numeroDocumento, 
					@g_const_0 AS tipoDocumento, 
					ERROR_NUMBER() AS codigo,
					ERROR_MESSAGE() AS mensaje
		END CATCH

	END	
GO

--exec pa_listar_puntos_entregas 

