
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'v_listar_precios' AND type = 'V')
	DROP VIEW v_listar_precios
GO
/****** Object:  View [dbo].[v_listar_precios]    Script Date: 10/02/2020 10:00:00 ******/
----------------------------------------------------------------------------------
-- Author: Luis Llatas IDE-SOLUTION
-- Created: 10/02/2020  
-- Sistema: WEB / Mantenedor Precios
-- Descripción: Vista listar precios
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW v_listar_precios
AS

SELECT tblAbastecimento.codProveedor AS codProveedor,
       (SELECT descripcion from tblProveedor where ntraProveedor = tblAbastecimento.codProveedor AND tblProveedor.marcaBaja = 0) AS descProveedor,
       tblProducto.codFabricante AS codFabricante,
       tblFabricante.descripcion AS descFabricante,
       tblProducto.codCategoria AS codCategoria,
       tblCategoria.descripcion AS descCategoria,
       tblProducto.codSubcategoria AS codSubcategoria,
       tblSubcategoria.descripcion AS descSubcategoria,
       tblProducto.codProducto AS codProducto,
       tblProducto.descripcion AS descProducto,
       ( CASE WHEN (SELECT precioVenta FROM tblPrecio WHERE tblPrecio.codProducto = tblProducto.codProducto AND tblPrecio.tipoListaPrecio = 1 AND tblPrecio.marcaBaja = 0) IS NULL
       THEN ''
       ELSE (SELECT precioVenta FROM tblPrecio WHERE tblPrecio.codProducto = tblProducto.codProducto  AND tblPrecio.tipoListaPrecio = 1 AND tblPrecio.marcaBaja = 0) END )
       AS precioCosto
       
FROM tblProducto 
 INNER JOIN tblCategoria  
   ON tblProducto.codCategoria = tblCategoria.ntraCategoria
 INNER JOIN tblSubcategoria
   ON tblProducto.codSubcategoria = tblSubcategoria.ntraSubcategoria
 INNER JOIN tblAbastecimento
   ON tblProducto.codProducto = tblAbastecimento.codProducto
 INNER JOIN tblFabricante
   ON tblProducto.codFabricante = tblFabricante.ntraFabricante 
 LEFT JOIN tblPrecio
   ON tblProducto.codProducto = tblPrecio.codProducto AND tblPrecio.tipoListaPrecio = 1 -- Tipo de Lista de Precio (Precio Costo => codConcepto = 7, correlativo = 1)
 WHERE tblProducto.marcaBaja       = 0 AND 
       tblCategoria.marcaBaja      = 0 AND
       tblSubcategoria.marcaBaja   = 0 AND 
       tblAbastecimento.marcaBaja  = 0 AND
       tblFabricante.marcaBaja     = 0 
         
GO


