
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_registrar_actualizar_precio_x_producto' AND type = 'P')
	DROP PROCEDURE pa_registrar_actualizar_precio_x_producto
GO
----------------------------------------------------------------------------------
-- Author: Luis Llatas IDE-SOLUTION
-- Created: 10/02/2020  
-- Sistema: WEB / Mantenedor Precios
-- Descripción: Registrar Actualizar Precios por Producto
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

CREATE PROCEDURE pa_registrar_actualizar_precio_x_producto
(@codProducto VARCHAR(10),
 @tipoListaPrecio TINYINT,
 @precio MONEY,
 @codProveedor INT,
 @flag TINYINT
)
AS
 --Actualizar sólo en la tabla tblProducto
 IF @flag = 1 
   BEGIN
    UPDATE tblPrecio SET precioVenta = @precio WHERE codProducto = @codProducto AND tipoListaPrecio = 1 
    AND marcaBaja = 0;
   END

 --Actualizar sólo en la tabla tblPrecio
 IF @flag = 2
   BEGIN
    UPDATE tblPrecio SET precioVenta = @precio WHERE codProducto = @codProducto 
    AND tipoListaPrecio = @tipoListaPrecio 
    AND marcaBaja = 0;
   END  

 --Registrar sólo en la tabla tblPrecio
 IF @flag = 3
   BEGIN 
     INSERT INTO tblPrecio (codProducto,tipoListaPrecio,precioVenta,marcaBaja,usuario,ip,mac) 
     VALUES (@codProducto,@tipoListaPrecio,@precio,0,'lllatas','172.19.21.21','ABC-SA-21-SADA')                  
   END

