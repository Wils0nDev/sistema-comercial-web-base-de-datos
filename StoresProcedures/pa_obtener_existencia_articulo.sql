
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_obtener_existencia_articulo' AND type = 'P')
	DROP PROCEDURE pa_obtener_existencia_articulo
GO
----------------------------------------------------------------------------------
-- Author: Jose Chumioque IDE-SOLUTION
-- Created: 29/01/2020  
-- Sistema: Sistema de Preventas
-- Modulo: General
-- Descripción: validar si existe un articulo
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_obtener_existencia_articulo]	
(
@codProducto  VARCHAR(10)
)
AS
SET NOCOUNT ON

BEGIN
        DECLARE @g_const_0 SMALLINT; -- valor 0
		DECLARE @g_const_1 SMALLINT;  --valor 1
		DECLARE @g_cant SMALLINT; --articulo
     
           SET @g_const_0 = 0;
		   SET @g_const_1 = 1;
		   SET @g_cant = 0; 
   select @g_cant = count(*) from tblProducto where codProducto = TRIM(@codProducto) 
   and marcaBaja = @g_const_0;  
   select @g_cant as cantidad
END



