IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_insertar_detalleflagpromocion' AND type = 'P')
DROP PROCEDURE pa_insertar_detalleflagpromocion
GO


----------------------------------------------------------------------------------
-- Author: KVASQUEZ IDE-SOLUTION
-- Created: 03/04/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Insertar Promociones
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[pa_insertar_detalleflagpromocion]
(

	--@flag INT,
	@descripcionDet VARCHAR(100),	--DESCRIPCION DEL PRODUCTO
	@valorEntero1Det INT,			--CANTIDAD DEL PRODUCTO
	--@valorEntero2Det INT,
	@valorMoneda1Det MONEY,			--PRECIO DEL PRODUCTO
	@valorCadena1Det VARCHAR(200),	--COD DEL PRODUCTO
	@valorCadena2Det VARCHAR(200),	--COD UNIDAD BASE DEDL PROD
	@resultado INT OUTPUT
)

AS
	BEGIN
		DECLARE @ntraPromocion INT

BEGIN TRY
		BEGIN

		SELECT @ntraPromocion =  IDENT_CURRENT ('tblPromociones');

			INSERT INTO tblDetalleFlagPromocion
			(ntraPromocion,flag,descripcion, valorEntero1,valorEntero2, valorMoneda1, valorCadena1,valorCadena2,usuario)
			VALUES (@ntraPromocion,3,@descripcionDet,@valorEntero1Det,1,@valorMoneda1Det,@valorCadena1Det,@valorCadena2Det,'EAY');

			SELECT  @resultado = 0
		END
END TRY
BEGIN CATCH
		--UPDATE tblPromociones set marcaBaja = 9 where ntraPromocion = @ntraPromocion;
		SELECT  
			ERROR_NUMBER() AS NumeroDeError   
            ,ERROR_STATE() AS NumeroDeEstado    
            ,ERROR_LINE() AS  NumeroDeLinea  
            ,ERROR_MESSAGE() AS MensajeDeError;  
END CATCH

END
