
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_fecha_anulacion_venta' AND type = 'P')
	DROP PROCEDURE pa_fecha_anulacion_venta
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 01/04/2020  
-- Sistema: VirgenCarmenMantenedor
-- Descripción: Traer fecha de anulacion de venta
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_fecha_anulacion_venta
(
	@p_codVenta INT -- Codigo de venta
)
AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
			
		SET @g_const_0 = 0;

		SET NOCOUNT ON;
		SELECT ntraVentaAnulada,fecha FROM tblVentasAnuladas WHERE codVenta = @p_codVenta AND marcaBaja = @g_const_0 
		
	END	
GO

--exec pa_fecha_anulacion_venta 50 



 