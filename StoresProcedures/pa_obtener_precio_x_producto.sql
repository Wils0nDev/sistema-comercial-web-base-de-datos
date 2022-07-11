
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_obtener_precio_x_producto' AND type = 'P')
	DROP PROCEDURE pa_obtener_precio_x_producto
GO
----------------------------------------------------------------------------------
-- Author: Luis Llatas IDE-SOLUTION
-- Created: 10/02/2020  
-- Sistema: WEB / Mantenedor Precios
-- Descripción: Obtener precios por producto
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

CREATE PROCEDURE pa_obtener_precio_x_producto
(@codProducto VARCHAR(10),
 @tipoListaPrecio TINYINT,
 @codProveedoor INT
)
AS
 DECLARE @cont  INT
 DECLARE @valor INT

SELECT @cont = COUNT(precioVenta) 
 FROM tblPrecio WHERE codProducto = @codProducto
 AND tipoListaPrecio = @tipoListaPrecio AND marcaBaja = 0

IF @tipoListaPrecio != 1
  BEGIN
	IF @cont = 0 
	  BEGIN
	    SET @valor = -1
	    SELECT @valor AS precioVenta
	  END
	ELSE
	  BEGIN
	     SELECT precioVenta FROM tblPrecio 
	     WHERE codProducto = @codProducto AND tipoListaPrecio = @tipoListaPrecio AND 
	     marcaBaja = 0  
	  END
  END
ELSE 
  BEGIN
	  SELECT tblPrecio.precioVenta AS precioVenta
    FROM tblPrecio WHERE codProducto = @codProducto
    AND tipoListaPrecio = 1  AND marcaBaja = 0 -- Se obtiene el PRECIO COSTO (que debera estar registrado siempre con tipo UNO(01))
  END  

GO