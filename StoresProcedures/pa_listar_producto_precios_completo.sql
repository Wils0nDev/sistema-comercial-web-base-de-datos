
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_producto_precios_completo' AND type = 'P')
	DROP PROCEDURE pa_listar_producto_precios_completo
GO
----------------------------------------------------------------------------------
-- Author: Luis Llatas IDE-SOLUTION
-- Created: 10/02/2020  
-- Sistema: WEB / Mantenedor Precios
-- Descripción: Listar producto precios completo
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

CREATE PROCEDURE pa_listar_producto_precios_completo
AS
SELECT 
DISTINCT tblAbastecimento.codProducto AS codProducto,
       ( CASE WHEN (SELECT tblPrecio.precioVenta FROM tblPrecio WHERE tblPrecio.codProducto = tblAbastecimento.codProducto AND tblPrecio.tipoListaPrecio = 1 AND tblPrecio.marcaBaja = 0) IS NULL
       THEN ''
       ELSE tblPrecio.precioVenta END )
       AS precioVenta,
      ( CASE WHEN (SELECT tblPrecio.tipoListaPrecio FROM tblPrecio WHERE tblPrecio.codProducto = tblAbastecimento.codProducto AND tblPrecio.tipoListaPrecio = 1 AND tblPrecio.marcaBaja = 0) IS NULL
       THEN ''
       ELSE tblPrecio.tipoListaPrecio END )
       AS tipoListaPrecio,
       tblAbastecimento.codProveedor as codProveedor

FROM tblAbastecimento
LEFT JOIN tblPrecio
ON tblPrecio.codProducto = tblAbastecimento.codProducto      
WHERE  
      (tblPrecio.marcaBaja = 0 OR tblPrecio.marcaBaja IS NULL) AND 
      (tblAbastecimento.marcaBaja = 0 OR tblAbastecimento.marcaBaja IS NULL)
ORDER BY tblAbastecimento.codProveedor DESC
  

GO