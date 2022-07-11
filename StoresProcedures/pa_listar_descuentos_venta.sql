
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_descuentos_venta' AND type = 'P')
	DROP PROCEDURE pa_listar_descuentos_venta
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 26/03/2020  
-- Sistema: VirgenCarmenMantenedor
-- Descripción: Listar descuentos de una venta
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_descuentos_venta		
(
	@p_codVenta INT  -- Codigo de venta
)
AS
	BEGIN
		
		SET NOCOUNT ON;  
		
		SELECT DISTINCT vp.codVenta,vp.codDescuento,pr.descripcion
		FROM tblVentaDescuento vp 
		INNER JOIN tblDescuentos pr on vp.codDescuento = pr.ntraDescuento
		WHERE vp.codVenta = @p_codVenta
		
		
		

	END	
GO

--exec pa_listar_descuentos_venta 39

 