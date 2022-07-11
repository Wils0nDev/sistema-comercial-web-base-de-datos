
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_detalle_almacen' AND type = 'P')
	DROP PROCEDURE pa_listar_detalle_almacen
GO
----------------------------------------------------------------------------------
-- Author: Jose Chumioque IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: Sistema de Preventas
-- Modulo: General
-- Descripción: Listar detalle de almacenes
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_listar_detalle_almacen]	
(
@codArticulo  VARCHAR(10)
)
AS
SET NOCOUNT ON

BEGIN
        DECLARE @g_const_0 INT -- valor 0	

BEGIN TRY      
           SET @g_const_0 = 0;
  
   if len(trim(@codArticulo)) > 0 
    BEGIN
    select ntraAlmacen,alm.descripcion,pro.codProducto,COALESCE(stock,@g_const_0) as stock
    from tblAlmacen as alm  left join tblInventario as inv on codAlmacen=ntraAlmacen and inv.marcaBaja=@g_const_0 and inv.codProducto= @codArticulo 
                            left join tblProducto as pro on inv.codProducto = pro.codProducto and pro.marcaBaja = @g_const_0
    where alm.marcaBaja= @g_const_0 
	
   END
END TRY
BEGIN CATCH
           SELECT   
	        ERROR_NUMBER() AS ErrorNumber  
	       ,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
END
