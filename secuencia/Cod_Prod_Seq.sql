IF EXISTS(select * from sys.objects where object_id = OBJECT_ID('Cod_Prod_Seq'))
DROP SEQUENCE Cod_Prod_Seq
GO
-----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Autor: Dany Gelacio IDE-SOLUTION
-- Created: 19/03/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen
-- Modulo: General
-- Descripción: Secuencia de numero correlativo para el SKU del producto
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE SEQUENCE Cod_Prod_Seq 
	AS smallint
		START WITH 1
			INCREMENT BY 1
		NO CYCLE
	NO CACHE
go