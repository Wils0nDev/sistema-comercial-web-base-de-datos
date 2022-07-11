
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_update_stock_almacen' AND type = 'P')
	DROP PROCEDURE pa_update_stock_almacen
GO
----------------------------------------------------------------------------------
-- Author: Jose Chumioque IDE-SOLUTION
-- Created: 16/01/2020  
-- Sistema: Sistema de Preventas
-- Modulo: General
-- Descripción: Registrar/Actualizar stock por almacen
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_update_stock_almacen	
(
@stock  INT,
@codArticulo  VARCHAR(10),
@codAlmacen INT
)
AS
SET NOCOUNT ON

BEGIN
        DECLARE @g_const_0 INT -- valor 0	
		DECLARE @g_const_1 INT -- valor 0
		DECLARE @g_cant    SMALLINT --Cantidad
		DECLARE @codigo INT -- Codigo 
		DECLARE @mensaje VARCHAR(100) -- mensaje
		DECLARE @g_const_3000 SMALLINT -- valor 3000
		DECLARE @g_const_2000 SMALLINT -- valor 2000
		DECLARE @estado SMALLINT -- 0:EXITO, 1:error interno
BEGIN TRY      
           SET @g_const_0 = 0;
		   SET @g_const_1 = 1;
		   SET @g_cant = 0;
		   SET @estado = 0;
		   SET @mensaje = '';
		   SET @g_const_2000 = 2000;
		   SET @g_const_3000 = 3000;
  
    SELECT @g_cant = count(ntraInventario) FROM tblInventario 
    WHERE  codProducto = @codArticulo
    AND codAlmacen = @codAlmacen
    AND marcaBaja = @g_const_0
	IF  @g_cant = @g_const_0
	BEGIN
	  BEGIN TRANSACTION
	   INSERT INTO tblInventario (codAlmacen,codProducto,stock,marcaBaja,usuario)
	   VALUES (@codAlmacen,@codArticulo,@stock,@g_const_0,'');
	   COMMIT TRANSACTION 
	    SET @codigo = @g_const_2000;
        SET @estado = @g_const_0;
		SET @mensaje = 'REGISTRO EXITOSO';	
	END
	ELSE
	BEGIN
	  BEGIN TRANSACTION
	    update tblInventario SET stock = @stock
        WHERE  codProducto = @codArticulo
        AND codAlmacen = @codAlmacen 
        AND marcaBaja = @g_const_0;
		COMMIT TRANSACTION 
		SET @codigo = @g_const_2000;
        SET @estado = @g_const_0;
		SET @mensaje = 'ACTUALIZACION CORRECTA';
	 END
	  SELECT  @codigo as codigo, @estado as estado , @mensaje as mensaje
END TRY
BEGIN CATCH
      BEGIN TRANSACTION
        SET @codigo = @g_const_3000;
        SET @estado = @g_const_1;
	    SET @mensaje = ERROR_MESSAGE();
		SELECT  @codigo as codigo, @estado as estado , @mensaje as mensaje
		ROLLBACK TRANSACTION		
END CATCH
END
GO