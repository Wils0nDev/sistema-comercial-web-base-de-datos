IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'v_listar_productos' AND type = 'V')
	DROP VIEW v_listar_productos
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------------------
-- Author: Diego Sanchez IDE-SOLUTION
-- Created: 27/03/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen.
-- Descripción: Listar los productos para filtrar por tipo
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE view [dbo].[v_listar_productos]
as
SELECT DISTINCT CONCAT(pro.codProducto, ' - ', pro.descripcion ) AS 'concatenado', 
pro.codProducto AS 'codProducto', pro.descripcion AS 'descripcion', pro.tipoProducto, pro.flagVenta
FROM tblProducto pro
WHERE pro.marcaBaja = 0;

GO