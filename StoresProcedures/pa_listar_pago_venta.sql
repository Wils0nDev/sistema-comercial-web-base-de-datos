
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_pago_venta' AND type = 'P')
	DROP PROCEDURE pa_listar_pago_venta
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: VirgenCarmenMantenedor
-- Descripción: Traer lista de pago por venta 
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_pago_venta
(
	@p_codVenta INT -- Codigo de venta
)
AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
			
		SET @g_const_0 = 0;

		SET NOCOUNT ON;
		SELECT ntraTransaccionPago,fechaTransaccion,horaTransaccion FROM tblTranssaccionesPago WHERE codVenta = @p_codVenta AND marcaBaja = @g_const_0
		
		
	END	
GO

--exec pa_listar_pago_venta 50 



 