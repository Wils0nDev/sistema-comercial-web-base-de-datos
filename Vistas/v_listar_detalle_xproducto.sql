IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'v_listar_detalle_xproducto' AND type = 'V')
	DROP VIEW v_listar_detalle_xproducto
GO
----------------------------------------------------------------------------------
-- Author: Dany Gelacio IDE-SOLUTION
-- Created: 31/03/2020 
-- Sistema: Mantenedor Producto
-- Descripción: Vista listar detalle de presentacion de producto
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE VIEW v_listar_detalle_xproducto
AS
	SELECT dp.codProducto, dp.codPresentancion, dp.cantidadUnidadBase
	FROM     dbo.tblDetallePresentacion AS dp INNER JOIN
                  dbo.tblConcepto AS cp ON cp.correlativo = dp.codPresentancion
	WHERE  (cp.codConcepto = 12) AND (cp.marcaBaja = 0)

GO




