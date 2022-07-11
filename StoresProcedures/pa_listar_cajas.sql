IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_cajas' AND type = 'P')
	DROP PROCEDURE pa_listar_cajas
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
CREATE PROCEDURE [dbo].[pa_listar_cajas] 
(
@p_ntraCaja INT = NULL, -- Código de Caja
@p_estadoCaja TINYINT =  NULL, -- Código de Estado de Caja
@p_ntraUsuario INT =  NULL, -- Código de Usuario
@p_ntraSucursal INT =  NULL, -- Código de Sucursal
@p_fechaInicial DATE =  NULL, -- Fecha Inicial Filtro
@p_fechaFinal DATE =  NULL -- Fecha Final Filtro
)
AS   
BEGIN

	SELECT c.ntraCaja,c.descripcion,s.descripcion as sucursal, c.estado as codestado, cp.descripcion as estado, c.fechaCreacion,  
		c.horaCreacion, c.ntraUsuario,u.users, p.apellidoPaterno + ' ' + p.apellidoMaterno + ', ' + p.nombres as nombreCompleto
		FROM tblCaja c 
		INNER JOIN tblSucursal s ON s.ntraSucursal = c.ntraSucursal
		INNER JOIN tblUsuario u ON u.ntraUsuario = c.ntraUsuario
		INNER JOIN tblPersona p ON p.codPersona = u.codPersona
		INNER JOIN tblConcepto cp ON c.estado = cp.correlativo
		WHERE c.marcaBaja = 0
		AND cp.codConcepto = 41
		AND (@p_ntraCaja = 0 OR @p_ntraCaja = c.ntraCaja)
		AND (@p_estadoCaja = 0 OR @p_estadoCaja = c.estado)
		AND (@p_ntraUsuario = 0 OR @p_ntraUsuario = u.ntraUsuario)
		AND (@p_ntraSucursal = 0 OR @p_ntraSucursal = c.ntraSucursal)
		AND (@p_fechaInicial IS NULL OR c.fechaCreacion >= @p_fechaInicial)
		AND (@p_fechaFinal IS NULL OR c.fechaCreacion <= @p_fechaFinal)

END
GO