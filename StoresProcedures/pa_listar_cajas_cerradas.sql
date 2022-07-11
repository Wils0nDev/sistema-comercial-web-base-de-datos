IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_cajas_cerradas' AND type = 'P')
	DROP PROCEDURE pa_listar_cajas_cerradas
GO
----------------------------------------------------------------------------------
-- Author: PEDRO YACILA IDE-SOLUTION
-- Created: 15/04/2020   
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Traer lista de cajas cerradas
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_listar_cajas_cerradas]   
( 
@p_ntraSucursal INT = NULL, -- Código de Sucursal
@p_ntraCaja INT = NULL, -- Número de Caja
@p_flag INT = NULL   -- Flag
)
AS   
BEGIN
	
	declare @csql nvarchar(1000)	--consulta sql
	
	set @csql = 'SELECT cc.ntraCierreCaja, cc.ntraCaja, c.descripcion as caja, cc.fecha, cc.hora,  
		cc.saldoSoles, cc.saldoDolares, cc.saldoSolesCierre, cc.saldoDolaresCierre,
		cc.difSaldoSoles, cc.difSaldoDolares, cc.marcaBaja 
		FROM tblCierreCaja cc 
		INNER JOIN tblCaja c ON cc.ntraCaja = c.ntraCaja
		WHERE c.marcaBaja = 0
		AND (' + convert(varchar, @p_ntraSucursal)  + ' = 0 OR ' + convert(varchar, @p_ntraSucursal) + ' = c.ntraSucursal)
		AND (' + convert(varchar, @p_ntraCaja)  + ' = 0 OR ' + convert(varchar, @p_ntraCaja) + ' = c.ntraCaja)'
		
	IF @p_flag = 0
		set @csql = @csql + 'AND cc.marcaBaja = 0 AND c.estado = 2'

	EXEC (@csql)
END
GO