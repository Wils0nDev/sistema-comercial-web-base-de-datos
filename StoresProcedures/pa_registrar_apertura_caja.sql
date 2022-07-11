IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_registrar_apertura_caja' AND type = 'P')
	DROP PROCEDURE pa_registrar_apertura_caja
GO
----------------------------------------------------------------------------------
-- Author: PEDRO YACILA IDE-SOLUTION
-- Created: 16/04/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripcion: Registrar Apertura de Caja
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_registrar_apertura_caja]
(
	@ntraCaja INT,		-- Número de Caja
	@saldoSoles MONEY,		-- Saldo Inicial en Soles
	@saldoDolares MONEY    -- Saldo Inicial en Dólares
)

AS
	BEGIN 
	DECLARE @flag INT = NULL; -- Flag de verificacion
BEGIN TRY
			BEGIN
			
			SELECT @flag = ntraCierreCaja FROM tblCierreCaja 
			WHERE ntraCaja = @ntraCaja AND marcaBaja = 0;
									
			IF @flag IS NOT NULL
				UPDATE tblCierreCaja SET marcaBaja = 9
				WHERE ntraCierreCaja = @flag
			
			INSERT INTO tblAperturaCaja
			(ntraCaja,saldoSoles,saldoDolares,usuario,ip,mac)
			VALUES (@ntraCaja,@saldoSoles,@saldoDolares,'pyacila','172.18.1.184','00:1B:44:11:3A:B7');
				
			UPDATE tblCaja SET estado = 1 WHERE ntraCaja = @ntraCaja
			
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