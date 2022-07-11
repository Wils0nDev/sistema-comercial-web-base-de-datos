
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_promociones_venta' AND type = 'P')
	DROP PROCEDURE pa_listar_promociones_venta
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 26/03/2020  
-- Sistema: VirgenCarmenMantenedor
-- Descripción: Listar promociones de una venta
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_promociones_venta		
(
	@p_codVenta INT  -- Codigo de venta
)
AS
	BEGIN
		
		SET NOCOUNT ON;  
		
		SELECT DISTINCT vp.codVenta,vp.codPromocion,pr.descripcion
		FROM tblVentaPromocion vp 
		INNER JOIN tblPromociones pr on vp.codPromocion = pr.ntraPromocion
		WHERE vp.codVenta = @p_codVenta
		
		
		

	END	
GO

--exec pa_listar_promociones_venta 51

 