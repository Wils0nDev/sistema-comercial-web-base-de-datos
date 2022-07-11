IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_registrar_tipo_mov_caja' AND type = 'P')
	DROP PROCEDURE pa_registrar_tipo_mov_caja
GO
----------------------------------------------------------------------------------
-- Author: PEDRO YACILA IDE-SOLUTION
-- Created: 15/04/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripcion: Registrar tipo movimiento en caja
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_registrar_tipo_mov_caja]
(
	@descripcion varchar(250),		--Descripcion del Tipo de Movimiento
	@tipoRegistro TINYINT		--Código Tipo de Registro (1 - Entrada/ 2 - Salida)
)

AS
	BEGIN 

BEGIN TRY
			BEGIN
			INSERT INTO tblTipoMovimiento
			(descripcion,tipoRegistro,usuario,ip,mac)
			VALUES (@descripcion,@tipoRegistro,'pyacila','172.18.1.184','00:1B:44:11:3A:B7');
				
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