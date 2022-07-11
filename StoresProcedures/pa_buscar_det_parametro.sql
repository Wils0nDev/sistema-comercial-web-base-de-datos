
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_buscar_det_parametro' AND type = 'P')
	DROP PROCEDURE pa_buscar_det_parametro
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 20/02/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Buscar detalle parametro
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_buscar_det_parametro		
(
	@p_cod INT			-- Usuario
)	
AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
		
		SET @g_const_0 = 0
		
		SET NOCOUNT ON;  
		
		SELECT tblDetalleParametro.codParametro,
		tblDetalleParametro.tipo,
		tblDetalleParametro.valorEntero1,
		tblDetalleParametro.valorEntero2,
		tblDetalleParametro.valorCaneda1,
		tblDetalleParametro.valorCaneda2,
		tblDetalleParametro.valorMoneda1,
		tblDetalleParametro.valorMoneda2,
		tblDetalleParametro.valorFloat1,
		tblDetalleParametro.valorFloat2,
		tblDetalleParametro.valorFecha1,
		tblDetalleParametro.valorFecha2 
		
		FROM tblParametro INNER JOIN tblDetalleParametro 
		ON tblParametro.codigoParametro = tblDetalleParametro.codParametro
		WHERE tblParametro.codigoParametro = @p_cod AND tblParametro.marcaBaja = @g_const_0
		

	END	
GO

--exec pa_buscar_det_parametro 1

 