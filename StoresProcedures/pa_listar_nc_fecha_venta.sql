
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_nc_fecha_venta' AND type = 'P')
	DROP PROCEDURE pa_listar_nc_fecha_venta
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: VirgenCarmenMantenedor
-- Descripción: Traer lista fehca de transaccion de NC por venta 
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_nc_fecha_venta
(
	@p_codVenta INT -- Codigo de venta
)
AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
			
		SET @g_const_0 = 0;

		SET NOCOUNT ON;
		SELECT nc.ntraNotaCredito,nc.fecha,(per.apellidoPaterno + ' ' + per.apellidoPaterno + ' ' + per.apellidoMaterno) as 'vendedor' FROM tblNotaCredito nc
		LEFT JOIN tblUsuario usu ON nc.codUsuario = usu.ntraUsuario
		INNER JOIN tblPersona per ON usu.codPersona = per.codPersona
		WHERE nc.codVenta = @p_codVenta AND  nc.marcaBaja = @g_const_0
		
	END	
GO

--exec pa_listar_nc_fecha_venta 50 
