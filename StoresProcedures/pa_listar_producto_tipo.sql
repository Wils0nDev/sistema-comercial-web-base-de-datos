IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_producto_tipo' AND type = 'P')
	DROP PROCEDURE pa_listar_producto_tipo
GO
----------------------------------------------------------------------------------
-- Author: Diego Sanchez IDE-SOLUTION
-- Created: 27/03/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen.
-- Descripción: Registrar descuento
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_listar_producto_tipo]
	@p_cadena VARCHAR(50),	--cadena
	@p_tipo int -- tipo de producto
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		SELECT codProducto, descripcion
		FROM v_listar_productos
		WHERE tipoProducto = @p_tipo and flagVenta = 1 and concatenado LIKE '%'+ RTRIM(LTRIM(@p_cadena)) + '%'
	
	END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER() as 'codProducto', 'Error en buscar_producto ' + ERROR_MESSAGE() as 'descripcion'
	END CATCH
END