IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_productos_sinc' AND type = 'P')
	DROP PROCEDURE pa_listar_productos_sinc
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Traer lista de inventarios
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_productos_sinc	
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

			SELECT codProducto,descripcion,CONCAT(codProducto,@g_const_espacio ,descripcion) as cod_des,codCategoria,
			codUnidadBaseventa,tipoProducto,@g_const_2000 AS codigo,@g_const_msj AS mensaje  FROM tblProducto where marcaBaja = @g_const_0

		END TRY
		BEGIN CATCH
			SELECT
					@g_const_vacio AS codProducto, 
					@g_const_vacio AS descripcion, 
					@g_const_vacio AS cod_des, 
					@g_const_0 AS codCategoria, 
					@g_const_0 AS codUnidadBaseventa,
					@g_const_0 AS tipoProducto, 
					ERROR_NUMBER() AS codigo,
					ERROR_MESSAGE() AS mensaje
					


		END CATCH

	END	
GO

--exec pa_listar_productos_sinc 



 