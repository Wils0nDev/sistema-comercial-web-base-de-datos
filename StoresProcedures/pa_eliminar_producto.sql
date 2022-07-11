
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_eliminar_producto' AND type = 'P')
DROP PROCEDURE pa_eliminar_producto
GO
-----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Autor: Dany Gelacio IDE-SOLUTION
-- Created: 15/03/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen
-- Modulo: General
-- Descripción: Eliminar producto
-----------------------------------------------------------------------------------
CREATE PROCEDURE pa_eliminar_producto	
(
	@codProducto VARCHAR(10),   --Codigo de producto
	@resultado int  OUTPUT
)

AS
	BEGIN
		BEGIN TRY		
			UPDATE tblProducto SET marcaBaja = 9 WHERE codProducto = @codProducto AND marcaBaja = 0

			UPDATE tblDetallePresentacion SET marcaBaja = 9 WHERE codProducto = @codProducto AND marcaBaja = 0

			UPDATE tblAbastecimento set marcaBaja = 9 where codProducto = @codProducto and marcaBaja = 0
				SELECT @resultado = 0
		END TRY
			BEGIN CATCH
				SELECT  
				   ERROR_NUMBER() AS NumeroDeError   
				   ,ERROR_STATE() AS NumeroDeEstado    
				   ,ERROR_LINE() AS  NumeroDeLinea  
				   ,ERROR_MESSAGE() AS MensajeDeError; 

		END CATCH

END

