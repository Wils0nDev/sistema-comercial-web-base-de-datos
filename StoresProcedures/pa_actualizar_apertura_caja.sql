IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_actualizar_apertura_caja' AND type = 'P')
	DROP PROCEDURE pa_actualizar_apertura_caja
GO
----------------------------------------------------------------------------------
-- Author: PEDRO YACILA IDE-SOLUTION
-- Created: 16/04/2020   
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripcion: Actualizar Apertura de caja
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_actualizar_apertura_caja]
(
	@ntraAperturaCaja INT, -- Número de Apertura de Caja
  @saldoSoles MONEY,		-- Saldo Inicial en Soles
	@saldoDolares MONEY    -- Saldo Inicial en Dólares
)
AS
BEGIN 

BEGIN TRY
		BEGIN
		UPDATE tblAperturaCaja SET saldoSoles = @saldoSoles, saldoDolares = @saldoDolares WHERE ntraAperturaCaja = @ntraAperturaCaja
		END
END TRY
BEGIN CATCH
		SELECT  
			ERROR_NUMBER() AS NumeroDeError   
            ,ERROR_STATE() AS NumeroDeEstado    
            ,ERROR_LINE() AS  NumeroDeLinea  
            ,ERROR_MESSAGE() AS MensajeDeError;  
			
END CATCH
END
GO