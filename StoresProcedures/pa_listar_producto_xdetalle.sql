IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_producto_xdetalle' AND type = 'P')
DROP PROCEDURE pa_listar_producto_xdetalle   
GO
----------------------------------------------------------------------------
-- Author: Dany Gelacio IDE-SOLUTION
-- Created: 31/03/2020  
-- Sistema: web virgen del carmen
-- Descripción: Listar producto con detalle
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE pa_listar_producto_xdetalle   
    @codProducto varchar(10)	
AS   
BEGIN
    	  
	SELECT d.codProducto, d.codPresentancion, c.descripcion  , d.cantidadUnidadBase from tblDetallePresentacion d
	INNER JOIN tblConcepto c on c.correlativo = d.codPresentancion
	WHERE (d.codProducto = @codProducto) AND (d.marcaBaja = 0) and (c.codConcepto=12);

END
