IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_producto_obtener_unidadbase' AND type = 'P')
	DROP PROCEDURE pa_producto_obtener_unidadbase
GO
----------------------------------------------------------------------------------
-- Author: Diego Sanchez IDE-SOLUTION
-- Created: 28/03/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen.
-- Descripción: Obtener la unidad base de un producto
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_producto_obtener_unidadbase]
@codProducto VARCHAR(10)
AS
BEGIN

	SELECT prod.codProducto, codUnidadBaseventa, prePro.descripcion FROM tblProducto prod
	INNER JOIN (select correlativo, descripcion from tblConcepto where codConcepto = 12 and marcaBaja = 0) 
	AS prePro ON prePro.correlativo = prod.codUnidadBaseventa
	WHERE prod.codProducto = @codProducto;

END