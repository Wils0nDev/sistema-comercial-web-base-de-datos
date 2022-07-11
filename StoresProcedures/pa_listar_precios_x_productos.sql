
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_precios_x_productos' AND type = 'P')
	DROP PROCEDURE pa_listar_precios_x_productos
GO
----------------------------------------------------------------------------------
-- Author: Luis Llatas IDE-SOLUTION
-- Created: 10/02/2020  
-- Sistema: WEB / Mantenedor Precios
-- Descripción: Listar precios por productos
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
-- Filtrado sólo por código de Proveedor (filtro independiente)
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
-- Filtrado sólo por código de Fabricante (filtro independiente)
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

-- {Categoría}
-- Filtrado sólo por código de Categoria (Subcategoria todos)
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

-- {Subcategoría}
-- Filtrado sólo por código de Categoria y Subcategoria
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
-- Filtrado sólo por producto (Puede ser por código ó descripción)
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
-- Filtrado sólo por código de Fabricante y código de Categoria (Subcategoria: Todos)
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
-- Filtrado sólo por código de Proveedor y código de Categoria (Subcategoria: Todos)
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
-- Filtrado sólo por código de Categoria (Subcategoria: Todos) y código de Producto 
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
-- Filtrado sólo por código de Fabricante, código de Categoria y código de Subcategoria
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
-- Filtrado sólo por código de Proveedor, código de Categoria y código de Subcategoria
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
-- Filtrado sólo por código de Categoria y Subcategoria y Producto 
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
-- Filtrado sólo por código de Proveedor y código de Fabricante
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
-- Filtrado sólo por Código de Fabricante y (Código de Producto y Descripción de Producto)
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
-- Filtrado sólo por Código de Proveedor y (Código de Producto y Descripción de Producto)
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
-- Filtrado sólo por Código de Proveedor, Código de Fabricante y Código de Categoría (Subcategoria: Todos).
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
-- Filtrado sólo por Código de Categoria (Subcategoria: Todos), Código de Proveedor y Producto (Código ó Descripción).
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
-- Filtrado sólo por Código de Subcategoria (Por tanto debe haber elegido una Categoría), Fabricante y Proveedor
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
-- Filtrado sólo por Código de Subcategoria (Por tanto debe haber elegido una Categoría), Código de Proveedor y Producto (Código ó Descripción).
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
-- Filtrado sólo por Código de Fabricante, Código de Proveedor y Producto (Código o Descripcion).
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

-- {Categoría,Fabricante,Producto}
-- Filtrado sólo por Código de Categoría (Subcategoria: Todos), Código de Fabricante y Producto (Código o Descripcion).
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

-- {Categoría,Subcategoría,Producto}
-- Filtrado sólo por Código de Categoría y Código de Subcategoría, y Producto (Código o Descripcion).
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

-- {Subcategría,Fabricante,Producto}
-- Filtrado sólo por Código de Subcategoría (Por tanto debe haber elegido una Categoría) y Fabricante y Producto (Código o Descripcion).
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

-- {Categoría,Fabricante,Proveedor,Producto}
-- Filtrado sólo por Código de Categoría (Subcategoria: Todos) y Fabricante y Proveedor y Producto (Código o Descripcion).
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

-- {Subcategoría,Fabricante,Proveedor,Producto}
-- Filtrado sólo por Subcategoría (Por tanto debe haber elegido una Categoría) y Fabricante y Proveedor y Producto (Código de Producto ó Descripción)
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

--NOTA:  SE UTILIZÓ ANÁLISIS COMBINATORIO PARA HALLAR TODOS LOS POSIBLES CASO A FILTRAR.     
		
GO