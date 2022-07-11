
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_insertar_rutas' AND type = 'P')
	DROP PROCEDURE pa_insertar_rutas
GO
----------------------------------------------------------------------------------
-- Author: KEVIN V IDE-SOLUTION
-- Created: 14/03/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Insertar rutas
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_insertar_rutas]
(
	@descripcion varchar(100),		--Nombre de la Ruta
	@pseudonimo varchar(100),		--Abreviatura
	@codSucursal INT				--codigo de Sucursal
)

AS
	BEGIN 

BEGIN TRY
			BEGIN
			INSERT INTO tblRutas
			(descripcion,pseudonimo,codSucursal,usuario,ip,mac)
			VALUES (@descripcion,@pseudonimo,1,'kvasquez','172.18.1.184','00:1B:44:11:3A:B7');
				
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
