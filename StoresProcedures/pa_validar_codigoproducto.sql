
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_validar_codigoproducto' AND type = 'P')
	DROP PROCEDURE pa_validar_codigoproducto

GO
----------------------------------------------------------------------------------
-- Author: Luis Llatas IDE-SOLUTION
-- Created: 10/02/2020  
-- Sistema: WEB / Mantenedor Precios
-- Descripción: Validar codigo de producto
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

CREATE PROCEDURE dbo.pa_validar_codigoproducto
(
@codProducto  VARCHAR(10)
)
AS
SET NOCOUNT ON

BEGIN
   
    SELECT count(codProducto) as cantidad FROM
    tblProducto where codProducto = @codProducto and marcabaja = 0
   

END

GO