
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'v_listar_producto' AND type = 'V')
	DROP VIEW v_listar_producto
GO
----------------------------------------------------------------------------------
-- Author: Dany Gelacio - IDE-SOLUTION
-- Created:  31/03/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen.
-- Modulo : Mantenedor de producto
-- Descripción: Vista listar producto
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE VIEW v_listar_producto
AS
SELECT p.codProducto, c.descripcion AS categoria, s.descripcion as subcategoria, pr.descripcion AS proveedor, 
f.descripcion AS fabricante, p.descripcion, cp.descripcion as unidadBase, cpt.descripcion AS tipoProducto, CASE p.flagVenta WHEN 1 THEN 'VENTA' ELSE 'AGREGADO'
 END AS flagVenta
 from tblProducto p INNER JOIN tblCategoria c on p.codCategoria=c.ntraCategoria
INNER JOIN tblSubcategoria s on p.codSubcategoria=s.ntraSubcategoria
INNER JOIN tblAbastecimento ab on p.codProducto = ab.codProducto INNER JOIN
tblProveedor pr on pr.ntraProveedor=ab.codProveedor
INNER JOIN tblFabricante f on f.ntraFabricante= p.codFabricante
INNER JOIN tblConcepto cp on cp.correlativo = p.codUnidadBaseventa
INNER JOIN tblConcepto cpt on cpt.correlativo = p.tipoProducto
WHERE (cp.codConcepto = 12) AND (cp.correlativo <> 0)  AND (cpt.codConcepto=23) AND (cpt.correlativo <> 0) 
AND (p.marcaBaja = 0) AND (ab.marcaBaja=0) AND (c.marcaBaja=0) AND (s.marcaBaja=0)
 AND (pr.marcaBaja=0)
GO

