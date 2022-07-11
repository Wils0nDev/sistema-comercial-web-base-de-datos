IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_obtener_preventa' AND type = 'P')
	DROP PROCEDURE pa_obtener_preventa
GO
----------------------------------------------------------------------------------
-- Author: Diego Sanchez IDE-SOLUTION
-- Created: 25/03/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen.
-- Descripción: Obtener datos de una preventa
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_obtener_preventa]
@npre int
as
begin
	select distinct ntraPreventa,codUsuario, codCliente, tipoVenta, tipoDocumentoVenta, fechaEntrega, horaEntrega,  
	codPuntoEntrega, cliente, identificacion,direccion, tipoListaPrecio, flagRecargo
	from v_preventa_filtros_web where ntraPreventa = @npre;
end