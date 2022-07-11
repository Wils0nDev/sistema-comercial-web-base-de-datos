
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_precios_x_productos' AND type = 'P')
	DROP PROCEDURE pa_listar_precios_x_productos
GO
----------------------------------------------------------------------------------
-- Author: Luis Llatas IDE-SOLUTION
-- Created: 10/02/2020  
-- Sistema: WEB / Mantenedor Precios
-- Descripci�n: Listar precios por productos
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_precios_x_productos
(@codProveedor INT, @codFabricante INT, 
 @codCategoria INT, @codSubcategoria INT,
 @descripcion VARCHAR(200))		
AS
  SET NOCOUNT ON
--OBTENIENDO TODOS LOS ELEMENTOS: (1 FILTRO)
--1.Obtener todos los datos (sin filtrado) 
IF (@codProveedor = 0 AND @codFabricante = 0 AND 
    @codCategoria = 0 AND @codSubcategoria = 0 AND 
    @descripcion = '')
 BEGIN
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios
 END

--**************************************
----------------------------------- 
--DE 1 ELEMENTO - INICIO: (5 FILTROS)
------------------------------------
--{Proveedor}
-- Filtrado s�lo por c�digo de Proveedor (filtro independiente)
IF (@codProveedor <> 0 AND @codFabricante = 0 AND 
    @codCategoria = 0  AND @codSubcategoria = 0 AND 
    @descripcion = '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE codProveedor = @codProveedor
   END     

-- {Fabricante}
-- Filtrado s�lo por c�digo de Fabricante (filtro independiente)
IF (@codFabricante <> 0 AND @codProveedor = 0 AND 
    @codCategoria = 0   AND @codSubcategoria = 0 AND 
    @descripcion = '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE codFabricante = @codFabricante 
   END

-- {Categor�a}
-- Filtrado s�lo por c�digo de Categoria (Subcategoria todos)
IF (@codProveedor = 0 AND @codFabricante = 0 AND 
    @codCategoria <> 0 AND @codSubcategoria = 0 AND 
    @descripcion = '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE codCategoria = @codCategoria     
   END

-- {Subcategor�a}
-- Filtrado s�lo por c�digo de Categoria y Subcategoria
IF (@codCategoria <> 0 AND @codSubcategoria <> 0 AND
    @codProveedor = 0 AND @codFabricante = 0  AND
    @descripcion = '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE 
   codCategoria = @codCategoria AND 
   codSubcategoria = @codSubcategoria  
   END

-- {Producto}   
-- Filtrado s�lo por producto (Puede ser por c�digo � descripci�n)
IF (@descripcion != '' AND @codProveedor = 0 AND
    @codFabricante = 0 AND @codCategoria = 0 AND 
    @codSubcategoria = 0 
    )
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE 
   ((codProducto LIKE '%'+@descripcion+'%') OR (descProducto LIKE '%'+@descripcion+'%'))   
   END

----------------------------   
-- DE 1 ELEMENTO - FIN
----------------------------
--**************************************

----------------------------
-- DE 2 ELEMENTOS - INICIO: (9 FILTROS)
----------------------------
-- {Categoria,Fabricante}
-- Filtrado s�lo por c�digo de Fabricante y c�digo de Categoria (Subcategoria: Todos)
IF (@codFabricante <> 0 AND @codCategoria <> 0 AND 
    @codSubcategoria = 0 AND @codProveedor = 0 AND 
    @descripcion = '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE codFabricante = @codFabricante AND codCategoria = @codCategoria    
   END
  
--{Categoria,Proveedor}
-- Filtrado s�lo por c�digo de Proveedor y c�digo de Categoria (Subcategoria: Todos)
IF (@codProveedor <> 0 AND @codCategoria <> 0 AND
    @codFabricante = 0 AND @codSubcategoria = 0 AND 
    @descripcion = '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE codProveedor = @codProveedor AND codCategoria = @codCategoria    
   END

--{Categoria,Producto}
-- Filtrado s�lo por c�digo de Categoria (Subcategoria: Todos) y c�digo de Producto 
IF (@codProveedor = 0 AND @codCategoria <> 0 AND
    @codFabricante = 0 AND @codSubcategoria = 0 AND 
    @descripcion != '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE codCategoria = @codCategoria AND  
        ((codProducto LIKE '%'+@descripcion+'%') OR (descProducto LIKE '%'+@descripcion+'%'))    
   END

-- {Subcategoria,Fabricante}
-- Filtrado s�lo por c�digo de Fabricante, c�digo de Categoria y c�digo de Subcategoria
IF (@codFabricante <> 0 AND @codCategoria <> 0 AND 
    @codSubcategoria <> 0 AND @codProveedor = 0 AND 
    @descripcion = '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE codFabricante = @codFabricante AND codCategoria = @codCategoria
   AND codSubcategoria = @codSubcategoria  
   END

-- {Subcategoria,Proveedor}
-- Filtrado s�lo por c�digo de Proveedor, c�digo de Categoria y c�digo de Subcategoria
IF (@codProveedor <> 0 AND @codCategoria <> 0 AND 
    @codSubcategoria <> 0 AND @codFabricante = 0 AND 
    @descripcion = '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios 
   WHERE codProveedor = @codProveedor 
     AND codCategoria = @codCategoria
     AND codSubcategoria = @codSubcategoria
   END

-- {Subcategoria,Producto}
-- Filtrado s�lo por c�digo de Categoria y Subcategoria y Producto 
IF (@codProveedor = 0 AND @codCategoria <> 0 AND
    @codFabricante = 0 AND @codSubcategoria <> 0 AND 
    @descripcion != '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE codCategoria = @codCategoria AND codSubcategoria = @codSubcategoria AND  
        ((codProducto LIKE '%'+@descripcion+'%') OR (descProducto LIKE '%'+@descripcion+'%'))    
   END   

-- {Fabricante,Proveedor}
-- Filtrado s�lo por c�digo de Proveedor y c�digo de Fabricante
IF (@codProveedor <> 0 AND @codFabricante <> 0 AND 
    @codCategoria = 0  AND @codSubcategoria = 0 AND 
    @descripcion = '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE codProveedor = @codProveedor AND codFabricante = @codFabricante    
   END

-- {Fabricante,Producto}
-- Filtrado s�lo por C�digo de Fabricante y (C�digo de Producto y Descripci�n de Producto)
IF (@codFabricante <> 0 AND @descripcion != '' AND 
     @codProveedor = 0 AND @codCategoria = 0 AND
     @codSubcategoria = 0)
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE codFabricante = @codFabricante 
   AND ((codProducto LIKE '%'+@descripcion+'%') OR (descProducto LIKE '%'+@descripcion+'%'))
   END

-- {Proveedor,Producto}
-- Filtrado s�lo por C�digo de Proveedor y (C�digo de Producto y Descripci�n de Producto)
IF (@codProveedor <> 0 AND @descripcion != '' AND
     @codFabricante = 0 AND @codCategoria = 0 AND
     @codSubcategoria = 0)
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE 
   codProveedor = @codProveedor 
   AND ((codProducto LIKE '%'+@descripcion+'%') OR (descProducto LIKE '%'+@descripcion+'%'))
   END
-------------------------
-- DE 2 ELEMENTOS - FIN
-------------------------
--**************************************

----------------------------
-- DE 3 ELEMENTOS - INICIO: (8 FILTROS)
----------------------------
-- {Categoria,Fabricante,Proveedor}
-- Filtrado s�lo por C�digo de Proveedor, C�digo de Fabricante y C�digo de Categor�a (Subcategoria: Todos).
IF (@codProveedor <> 0 AND @codFabricante <> 0 AND @codCategoria <> 0 AND
     @codSubcategoria = 0 AND @descripcion = '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE 
   codProveedor = @codProveedor AND
   codFabricante = @codFabricante AND
   codCategoria = @codCategoria
   END 

-- {Categoria,Proveedor,Producto}
-- Filtrado s�lo por C�digo de Categoria (Subcategoria: Todos), C�digo de Proveedor y Producto (C�digo � Descripci�n).
IF (@codProveedor <> 0 AND @codFabricante = 0 AND @codCategoria <> 0 AND
     @codSubcategoria = 0 AND @descripcion != '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE 
   codProveedor = @codProveedor AND
   codCategoria = @codCategoria AND
   ((codProducto LIKE '%'+@descripcion+'%') OR (descProducto LIKE '%'+@descripcion+'%'))
   END

-- {Subcategoria,Fabricante,Proveedor}
-- Filtrado s�lo por C�digo de Subcategoria (Por tanto debe haber elegido una Categor�a), Fabricante y Proveedor
IF (@codProveedor <> 0 AND @codFabricante <> 0 AND 
    @codCategoria <> 0 AND @codSubcategoria <> 0 AND 
    @descripcion = '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE codProveedor = @codProveedor AND codFabricante = @codFabricante AND 
                               codCategoria = @codCategoria AND codSubcategoria = @codSubcategoria 
   END 

-- {Subcategoria,Proveedor,Producto} 
-- Filtrado s�lo por C�digo de Subcategoria (Por tanto debe haber elegido una Categor�a), C�digo de Proveedor y Producto (C�digo � Descripci�n).
IF (@codProveedor <> 0 AND @codFabricante = 0 AND @codCategoria <> 0 AND
     @codSubcategoria <> 0 AND @descripcion != '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE 
   codProveedor = @codProveedor AND
   codCategoria = @codCategoria AND
   codSubcategoria = @codSubcategoria AND
   ((codProducto LIKE '%'+@descripcion+'%') OR (descProducto LIKE '%'+@descripcion+'%'))
   END

-- {Fabricante,Proveedor,Producto}
-- Filtrado s�lo por C�digo de Fabricante, C�digo de Proveedor y Producto (C�digo o Descripcion).
IF (@codProveedor <> 0 AND @codFabricante <> 0 AND @codCategoria = 0 AND
     @codSubcategoria = 0 AND @descripcion != '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE 
   codProveedor = @codProveedor AND
   codFabricante = @codFabricante AND
   ((codProducto LIKE '%'+@descripcion+'%') OR (descProducto LIKE '%'+@descripcion+'%'))
   END

-- {Categor�a,Fabricante,Producto}
-- Filtrado s�lo por C�digo de Categor�a (Subcategoria: Todos), C�digo de Fabricante y Producto (C�digo o Descripcion).
IF (@codProveedor = 0 AND @codFabricante <> 0 AND @codCategoria <> 0 AND
     @codSubcategoria = 0 AND @descripcion != '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE 
   codFabricante = @codFabricante AND
   codCategoria = @codCategoria AND
   ((codProducto LIKE '%'+@descripcion+'%') OR (descProducto LIKE '%'+@descripcion+'%'))
   END

-- {Categor�a,Subcategor�a,Producto}
-- Filtrado s�lo por C�digo de Categor�a y C�digo de Subcategor�a, y Producto (C�digo o Descripcion).
IF (@codProveedor = 0 AND @codFabricante = 0 AND @codCategoria <> 0 AND
     @codSubcategoria <> 0 AND @descripcion != '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE 
   codCategoria = @codCategoria AND
   codSubcategoria = @codSubcategoria AND
   ((codProducto LIKE '%'+@descripcion+'%') OR (descProducto LIKE '%'+@descripcion+'%'))
   END

-- {Subcategr�a,Fabricante,Producto}
-- Filtrado s�lo por C�digo de Subcategor�a (Por tanto debe haber elegido una Categor�a) y Fabricante y Producto (C�digo o Descripcion).
IF (@codProveedor = 0 AND @codFabricante <> 0 AND @codCategoria <> 0 AND
     @codSubcategoria <> 0 AND @descripcion != '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE 
   codFabricante = @codFabricante AND
   codCategoria = @codCategoria AND
   codSubcategoria = @codSubcategoria AND
   ((codProducto LIKE '%'+@descripcion+'%') OR (descProducto LIKE '%'+@descripcion+'%'))
   END

----------------------------
-- DE 3 ELEMENTOS - FIN 
----------------------------
--**************************************

----------------------------
-- DE 4 ELEMENTOS - INICIO: (2 FILTROS)
----------------------------
--**************************************

-- {Categor�a,Fabricante,Proveedor,Producto}
-- Filtrado s�lo por C�digo de Categor�a (Subcategoria: Todos) y Fabricante y Proveedor y Producto (C�digo o Descripcion).
 IF (@codProveedor <> 0 AND @codFabricante <> 0 AND @codCategoria <> 0 AND
     @codSubcategoria = 0 AND @descripcion != '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE 
   codFabricante = @codFabricante AND
   codProveedor = @codProveedor AND
   codCategoria = @codCategoria AND
   ((codProducto LIKE '%'+@descripcion+'%') OR (descProducto LIKE '%'+@descripcion+'%'))
   END

-- {Subcategor�a,Fabricante,Proveedor,Producto}
-- Filtrado s�lo por Subcategor�a (Por tanto debe haber elegido una Categor�a) y Fabricante y Proveedor y Producto (C�digo de Producto � Descripci�n)
 IF (@codProveedor <> 0 AND @codFabricante <> 0 AND @codCategoria <> 0 AND
     @codSubcategoria <> 0 AND @descripcion != '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE 
   codFabricante = @codFabricante AND
   codProveedor = @codProveedor AND
   codCategoria = @codCategoria AND
   codSubcategoria = @codSubcategoria AND   
   ((codProducto LIKE '%'+@descripcion+'%') OR (descProducto LIKE '%'+@descripcion+'%'))
   END
   
----------------------------
-- DE 4 ELEMENTOS - FIN
----------------------------
--************************************** 

--NOTA:  SE UTILIZ� AN�LISIS COMBINATORIO PARA HALLAR TODOS LOS POSIBLES CASO A FILTRAR.     
		
GO