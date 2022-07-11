
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_precios_sinc' AND type = 'P')
	DROP PROCEDURE pa_listar_precios_sinc
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Traer lista de precios
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_precios_sinc		
AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
		DECLARE @g_const_7 SMALLINT -- valor 7
		DECLARE @g_const_vacio CHAR(1) -- Constante vacio
		DECLARE @g_const_2000 SMALLINT -- Constante 2000
		DECLARE @g_const_msj VARCHAR(200) -- Mensaje
		
		BEGIN TRY		
			SET @g_const_0 = 0
			SET @g_const_7 = 7
			SET @g_const_2000 = 2000
			SET @g_const_msj = 'Consulta exitosa'
			SET @g_const_vacio = '';

			SET NOCOUNT ON;  
			SELECT ntraPrecio,codProducto,tipoListaPrecio,precioVenta,descripcion 
			, @g_const_2000 AS codigo
			,@g_const_msj as mensaje
			FROM tblPrecio 
			INNER JOIN tblConcepto ON tblPrecio.tipoListaPrecio = tblConcepto.correlativo
			WHERE tblConcepto.codConcepto = @g_const_7 and tblPrecio.marcaBaja = @g_const_0
			
		END TRY
		BEGIN CATCH
			SELECT 
			@g_const_0 as ntraPrecio ,
			@g_const_vacio as codProducto,
			@g_const_0 as tipoListaPrecio,
			@g_const_0 as precioVenta,
			@g_const_vacio as descripcion,
			ERROR_NUMBER() AS correlativo,
			ERROR_MESSAGE() AS descripcion;  


		END CATCH

	END	
GO

--exec pa_listar_precios_sinc

 