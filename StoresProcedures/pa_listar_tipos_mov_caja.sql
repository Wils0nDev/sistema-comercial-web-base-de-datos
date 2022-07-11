IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_tipos_mov_caja' AND type = 'P')
	DROP PROCEDURE pa_listar_tipos_mov_caja
GO
----------------------------------------------------------------------------------
-- Author: PEDRO YACILA IDE-SOLUTION
-- Created: 15/04/2020   
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Traer lista de tipos de movimientos
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_listar_tipos_mov_caja]   
( 
@flag int   
)
AS   
BEGIN

	declare @csql nvarchar(1000)	--consulta sql


	set @csql = 'SELECT tm.ntraTipoMovimiento,tm.descripcion,tm.tipoRegistro as codTipoRegistro,
		c.descripcion as tipoRegistro, tm.marcaBaja
		FROM tblTipoMovimiento tm
		INNER JOIN tblConcepto c ON tm.tipoRegistro = c.correlativo
		WHERE c.codConcepto = 39'

		IF @flag = 0
			set @csql = @csql + 'AND tm.marcaBaja = 0'

			EXEC (@csql)
END
GO