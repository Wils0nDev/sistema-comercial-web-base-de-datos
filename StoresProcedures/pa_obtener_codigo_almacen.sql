
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_obtener_codigo_almacen' AND type = 'P')
	DROP PROCEDURE pa_obtener_codigo_almacen
GO
----------------------------------------------------------------------------------
-- Author: Jose Chumioque IDE-SOLUTION
-- Created: 23/01/2020  
-- Sistema: Sistema de Preventas
-- Modulo: General
-- Descripción: Obtener el codigo de almacen
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_obtener_codigo_almacen	
(
@descAlmacen  VARCHAR(100)
)
AS
SET NOCOUNT ON

BEGIN
        DECLARE @g_const_0 SMALLINT; -- valor 0
		DECLARE @g_const_1 SMALLINT;  --valor 1
		DECLARE @codigo INT; -- Codigo 
		DECLARE @mensaje VARCHAR(100); -- mensaje
		DECLARE @estado SMALLINT; -- 0:EXITO, 1:error interno
		DECLARE @ntralm INT;     --Codigo de almacen

BEGIN TRY      
           SET @g_const_0 = 0;
		   SET @g_const_1 = 1;
		   SET @estado = 0;
		   SET @mensaje = 'EXITO';
		   SET @ntralm = 0;
		   SET @codigo = 2000;
 
    select @ntralm = ntraAlmacen from tblAlmacen
    where upper(descripcion) = TRIM(@descAlmacen) and marcaBaja = @g_const_0;

   SELECT @ntralm as codAlmacen,@codigo as codigo,@estado as estado,@mensaje as mensaje
END TRY
BEGIN CATCH
            SET @codigo = 3000;
		    SET @estado = @g_const_1;
		    SET @mensaje = ERROR_MESSAGE();
			SET @ntralm = @g_const_0;
	SELECT @ntralm as codAlmacen,@codigo as codigo,@estado as estado,@mensaje as mensaje
END CATCH
END
GO