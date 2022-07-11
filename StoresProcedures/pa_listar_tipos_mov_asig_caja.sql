IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_tipos_mov_asig_caja' AND type = 'P')
	DROP PROCEDURE pa_listar_tipos_mov_asig_caja
GO
----------------------------------------------------------------------------------
-- Author: PEDRO YACILA IDE-SOLUTION
-- Created: 15/04/2020   
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Traer lista de cajas
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_listar_tipos_mov_asig_caja] 
( 
@ntraCaja int   -- Código de caja
)  
AS   
BEGIN

	SELECT tmc.ntraTipoMovimiento, tm.descripcion,tm.tipoRegistro as codTipoRegistro,
		c.descripcion as tipoRegistro
		FROM tblTipoMovimientoCaja  tmc
		INNER JOIN tblTipoMovimiento tm ON tmc.ntraTipoMovimiento = tm.ntraTipoMovimiento
		INNER JOIN tblConcepto c ON tm.tipoRegistro = c.correlativo
		WHERE tmc.marcaBaja = 0 AND tmc.ntraCaja = @ntraCaja AND c.codConcepto = 39

END
GO