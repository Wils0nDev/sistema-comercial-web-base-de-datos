
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_presentacion_productos_sinc' AND type = 'P')
	DROP PROCEDURE pa_listar_presentacion_productos_sinc
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 15/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Traer lista de presentaciones de producto
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_presentacion_productos_sinc
AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
		DECLARE @g_const_vacio CHAR(1) -- Constante vacio
		DECLARE @g_const_2000 SMALLINT -- Constante 2000
		DECLARE @g_const_msj VARCHAR(200) -- Mensaje
		DECLARE @g_const_espacio CHAR(1) -- espacio
		BEGIN TRY		
			
			SET @g_const_vacio = '';
			SET @g_const_0 = 0;
			SET @g_const_2000 = 2000
			SET @g_const_msj = 'Consulta exitosa'
			SET @g_const_espacio= ' '

			SET NOCOUNT ON;

			SELECT codProducto,codPresentancion,cantidadUnidadBase,@g_const_2000 AS codigo,@g_const_msj AS mensaje FROM tblDetallePresentacion 
			WHERE marcaBaja = @g_const_0 

		END TRY
		BEGIN CATCH
			SELECT
					@g_const_vacio AS codProducto, 
					@g_const_0 AS codPresentancion, 
					@g_const_0 AS cantidadUnidadBase, 
					ERROR_NUMBER() AS codigo,
					ERROR_MESSAGE() AS mensaje
					


		END CATCH

	END	
GO

--exec pa_listar_presentacion_productos_sinc 



 