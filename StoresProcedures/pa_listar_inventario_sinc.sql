
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_inventario_sinc' AND type = 'P')
	DROP PROCEDURE pa_listar_inventario_sinc
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
CREATE PROCEDURE dbo.pa_listar_inventario_sinc	
AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
		DECLARE @g_const_vacio CHAR(1) -- Constante vacio
		DECLARE @g_const_2000 SMALLINT -- Constante 2000
		DECLARE @g_const_msj VARCHAR(200) -- Mensaje
		DECLARE @g_const_almacen CHAR(5) -- Almacen principal
		BEGIN TRY		
			
			SET @g_const_vacio = '';
			SET @g_const_0 = 0;
			SET @g_const_2000 = 2000
			SET @g_const_msj = 'Consulta exitosa'
			SET @g_const_almacen = 'ALMP'
			SET NOCOUNT ON;

			SELECT ntraInventario,codAlmacen,codProducto,stock,@g_const_2000 as codigo,@g_const_msj as mensaje FROM tblInventario 
			INNER JOIN tblAlmacen ON tblInventario.codAlmacen = tblAlmacen.ntraAlmacen
			where tblInventario.marcaBaja = @g_const_0 AND tblAlmacen.abreviatura = @g_const_almacen

			
		END TRY
		BEGIN CATCH
			SELECT
					@g_const_0 AS ntraInventario, 
					@g_const_0 AS codAlmacen, 
					@g_const_vacio AS codProducto, 
					@g_const_0 AS stock, 
					ERROR_NUMBER() AS codigo,
					ERROR_MESSAGE() AS mensaje
					


		END CATCH

	END	
GO

--exec pa_listar_inventario_sinc 



 