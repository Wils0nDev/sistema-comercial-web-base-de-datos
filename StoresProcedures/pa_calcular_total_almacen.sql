IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_calcular_total_almacen' AND type = 'P')
	DROP PROCEDURE pa_calcular_total_almacen
GO
----------------------------------------------------------------------------------
-- Author: Jose Chumioque IDE-SOLUTION
-- Created: 12/02/2020  
-- Sistema: Sistema de Preventas
-- Modulo: General
-- Descripción: Calcular el monto de stock por almacen
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_calcular_total_almacen]	
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
	select sum(COALESCE(stock,@g_const_0) )as TotalStock 
	from  tblProducto  pro left join tblInventario  inv
	on inv.codProducto = pro.codProducto and pro.marcaBaja = @g_const_0 and inv.marcaBaja=@g_const_0
	where pro.codProducto = trim(@codArticulo)
	
   END
END TRY
BEGIN CATCH
           SELECT   
	        ERROR_NUMBER() AS ErrorNumber  
	       ,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
END
GO
