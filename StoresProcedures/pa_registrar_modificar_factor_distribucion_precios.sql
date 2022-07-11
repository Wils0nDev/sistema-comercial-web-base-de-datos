
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_registrar_modificar_factor_distribucion_precios' AND type = 'P')
	DROP PROCEDURE pa_registrar_modificar_factor_distribucion_precios
GO
----------------------------------------------------------------------------------
-- Author: Luis Llatas IDE-SOLUTION
-- Created: 10/02/2020  
-- Sistema: WEB / Mantenedor Precio
-- Descripción: Registrar y/o Modificar Factor de Distribucion de Precios
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE pa_registrar_modificar_factor_distribucion_precios
(@tipoPrecio TINYINT,
 @factor     TINYINT
)
AS
BEGIN
SET NOCOUNT ON

DECLARE @const_0 TINYINT 
DECLARE @codParametro TINYINT
DECLARE @cantidad INT
DECLARE @g_const_3000 INT
DECLARE @codRespuesta INT
DECLARE @mensaje VARCHAR(100)

SET @const_0 = 0
SET @cantidad = 0
SET @codParametro = 11
SET @g_const_3000 = 3000

BEGIN TRY

SELECT @cantidad = COUNT(ntraDetParametro)  
FROM tblDetalleParametro WHERE codParametro = @codParametro 
AND tipo = @tipoPrecio AND marcabaja = @const_0

 IF @cantidad > 0 
	BEGIN
	 UPDATE tblDetalleParametro SET valorEntero1 = @factor WHERE codParametro = @codParametro 
	 AND tipo = @tipoPrecio AND marcaBaja = @const_0
	END 
 ELSE
   BEGIN
     IF @cantidad = 0 
       BEGIN
        INSERT INTO tblDetalleParametro (codParametro,tipo,valorEntero1,marcaBaja,usuario,ip,mac) VALUES (@codParametro,@tipoPrecio,@factor,@const_0,'','','')
       END 
        
   END 	

END TRY

BEGIN CATCH
		
			SET @codRespuesta = @g_const_3000
			SET @mensaje = ERROR_MESSAGE()

			SELECT @codRespuesta AS 'codRespuesta', @mensaje as 'mensaje'

END CATCH




END