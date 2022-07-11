
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'v_preventa_listar_productos' AND type = 'V')
	DROP VIEW v_preventa_listar_productos
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 11/03/2020
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripcion: Buscar productos preventa
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE VIEW v_preventa_listar_productos
AS
SELECT DISTINCT CONCAT(pro.codProducto, ' - ', pro.descripcion ) AS 'concatenado', 
pro.codProducto AS 'codProducto', pro.descripcion AS 'descripcion'
FROM tblProducto pro INNER JOIN tblInventario inv ON inv.codProducto = pro.codProducto
WHERE inv.stock > 0 and pro.marcaBaja = 0 and inv.marcaBaja = 0
