
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_detalle_precio_x_producto' AND type = 'P')
	DROP PROCEDURE pa_listar_detalle_precio_x_producto
GO
----------------------------------------------------------------------------------
-- Author: Luis Llatas IDE-SOLUTION
-- Created: 10/02/2020  
-- Sistema: WEB / Mantenedor Precio
-- Descripción: Listar Detalle Precio por Producto
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE pa_listar_detalle_precio_x_producto
(@codProducto VARCHAR(10)
)
AS
BEGIN
SET NOCOUNT ON

DECLARE @const_0 tinyint 
DECLARE @const_1 tinyint
DECLARE @prefi_7 tinyint

SET @const_0 = 0
SET @const_1 = 1
SET @prefi_7 = 7
--pasar a tabla temporal resultado de store de conceptos 

SELECT correlativo,descripcion 
INTO #tmpConcepto 
FROM fu_buscar_conceptos_generales (@prefi_7)


SELECT con.correlativo as correlativo,con.descripcion as descripcion, 
( CASE WHEN (SELECT precioVenta FROM tblPrecio WHERE tblPrecio.codProducto = @codProducto AND tblPrecio.tipoListaPrecio = con.correlativo AND tblPrecio.marcaBaja = 0) IS NULL
       THEN ''
       ELSE (SELECT precioVenta FROM tblPrecio WHERE tblPrecio.codProducto = @codProducto AND tblPrecio.tipoListaPrecio = con.correlativo AND tblPrecio.marcaBaja = 0) END )
       AS precioVenta
     
FROM #tmpConcepto AS con 
LEFT JOIN tblPrecio AS pre
ON con.correlativo = pre.tipoListaPrecio AND pre.codProducto = @codProducto
WHERE con.correlativo <> @const_0 AND (pre.marcaBaja = 0 OR pre.marcabaja IS NULL);

DROP TABLE #tmpConcepto

END