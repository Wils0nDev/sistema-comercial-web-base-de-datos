IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_transacciones_caja' AND type = 'P')
	DROP PROCEDURE pa_listar_transacciones_caja
GO
----------------------------------------------------------------------------------
-- Author: PEDRO YACILA IDE-SOLUTION
-- Created: 15/04/2020   
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Traer lista de transacciones de cajas
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_listar_transacciones_caja]   
( 
@p_ntraSucursal INT = NULL, -- Código de Sucursal
@p_ntraCaja INT = NULL, -- Número de Caja
@p_fechaTransaccion DATE = NULL, -- Fecha filtro transacciones de caja
@p_flag INT = NULL   -- Flag
)
AS   
BEGIN
	
	declare @csql nvarchar(2000)	--consulta sql
	
	set @csql = 'SELECT tc.ntraTransaccionCaja, tc.ntraCaja, c.descripcion as caja, 
		tc.ntraTipoMovimiento, tm.descripcion as tipoMovimieno, tc.fechaTransaccion, tc.horaTransaccion,
		tc.codVenta, tc.tipoTransaccion as codTipoTransaccion, c1.descripcion as tipoTransaccion,
		tc.modoPago as codModoPago, c2.descripcion as modoPago, tc.tipoMoneda as codTipoMoneda,
		c3.descripcion as tipoMoneda, tc.importe, tc.marcaBaja, tm.tipoRegistro as codTipoRegistro,
		c4.descripcion as tipoRegistro
		FROM tblTransaccionCaja tc 
		INNER JOIN tblCaja c ON tc.ntraCaja = c.ntraCaja
		INNER JOIN tblTipoMovimiento tm ON tc.ntraTipoMovimiento = tm.ntraTipoMovimiento
		INNER JOIN tblConcepto c1 ON tc.tipoTransaccion = c1.correlativo
		INNER JOIN tblConcepto c2 ON tc.modoPago = c2.correlativo
		INNER JOIN tblConcepto c3 ON tc.tipoMoneda = c3.correlativo
		INNER JOIN tblConcepto c4 ON tm.tipoRegistro = c4.correlativo
		WHERE c.marcaBaja = 0
		AND c1.codConcepto = 59
		AND c2.codConcepto = 48
		AND c3.codConcepto = 21
		AND c4.codConcepto = 39
		AND (' + convert(varchar, @p_ntraSucursal)  + ' = 0 OR ' + convert(varchar, @p_ntraSucursal) + ' = c.ntraSucursal)
		AND (' + convert(varchar, @p_ntraCaja)  + ' = 0 OR ' + convert(varchar, @p_ntraCaja) + ' = c.ntraCaja)'
	
	IF @p_fechaTransaccion IS NOT NULL
		set @csql = @csql + 'AND tc.fechaTransaccion = ' +CHAR(39) + convert(varchar(10), @p_fechaTransaccion) +CHAR(39)
		
	IF @p_flag = 0
		set @csql = @csql + 'AND tc.marcaBaja = 0'

	EXEC (@csql)
END
GO