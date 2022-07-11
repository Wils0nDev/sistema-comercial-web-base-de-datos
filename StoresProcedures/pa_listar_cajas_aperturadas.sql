IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_cajas_aperturadas' AND type = 'P')
	DROP PROCEDURE pa_listar_cajas_aperturadas
GO
----------------------------------------------------------------------------------
-- Author: PEDRO YACILA IDE-SOLUTION
-- Created: 15/04/2020   
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Traer lista de cajas aperturadas
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_listar_cajas_aperturadas]   
( 
@p_ntraSucursal INT = NULL, -- Código de Sucursal
@p_ntraCaja INT = NULL, -- Número de Caja
@p_flag INT = NULL  -- Flag
)
AS   
BEGIN
	
	declare @csql nvarchar(1000)	--consulta sql
	
	set @csql = 'SELECT ac.ntraAperturaCaja, ac.ntraCaja, c.descripcion as caja, ac.fecha, ac.hora,  
		ac.saldoSoles, ac.saldoDolares, ac.estado as codEstado, cp.descripcion as estado, ac.marcaBaja 
		FROM tblAperturaCaja ac 
		INNER JOIN tblCaja c ON ac.ntraCaja = c.ntraCaja
		INNER JOIN tblConcepto cp ON ac.estado = cp.correlativo
		WHERE c.marcaBaja = 0
		AND cp.codConcepto = 58
		AND (' + convert(varchar, @p_ntraSucursal)  + ' = 0 OR ' + convert(varchar, @p_ntraSucursal) + ' = c.ntraSucursal)
		AND (' + convert(varchar, @p_ntraCaja)  + ' = 0 OR ' + convert(varchar, @p_ntraCaja) + ' = c.ntraCaja)'
		
	IF @p_flag = 0
		set @csql = @csql + 'AND ac.marcaBaja = 0 AND c.estado = 1'

	EXEC (@csql)
END
GO