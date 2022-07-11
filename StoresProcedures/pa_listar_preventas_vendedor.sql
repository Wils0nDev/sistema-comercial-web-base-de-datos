
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_preventas_vendedor' AND type = 'P')
	DROP PROCEDURE pa_listar_preventas_vendedor
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 16/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripci?n: Traer lista de preventas por vendedor
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_preventas_vendedor
(
	@p_codUsu INT, -- numero de transaccion de usuario
	@p_fech DATE -- fecha filtro de inicio
)		
AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
		DECLARE @g_const_vacio CHAR(1) -- Constante vacio
		DECLARE @g_const_2000 SMALLINT -- Constante 2000
		DECLARE @g_const_msj VARCHAR(200) -- Mensaje
			
			SET @g_const_vacio = '';
			SET @g_const_0 = 0;
			SET @g_const_2000 = 2000
			SET @g_const_msj = 'Consulta exitosa'

			SET NOCOUNT ON;

			SELECT  ntraPreventa,codCliente,codUsuario,codPuntoEntrega,tipoMoneda,tipoVenta,tipoDocumentoVenta,fecha,fechaEntrega,fechaPago
			,recargo,igv,isc,estado,total
			,(CASE   
			      WHEN (tblPersona.tipoPersona) = 2 THEN tblPersona.ruc ELSE tblPersona.numeroDocumento
			   END ) AS numeroDocumento,tblPersona.tipoPersona as 'tipoDocumento',
			   origenVenta,horaEntrega,codSucursal,flagRecargo
			, @g_const_2000 AS codigo
			, @g_const_msj as mensaje
			FROM tblPreventa LEFT JOIN tblPersona on tblPersona.codPersona = tblPreventa.codCliente
			
			where codUsuario= @p_codUsu AND fecha >= @p_fech  AND tblPreventa.marcaBaja = @g_const_0

	END	
GO

--exec pa_listar_preventas_vendedor 1, '16-01-2020'

