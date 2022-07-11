
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_tipos_precio_paramatrizado' AND type = 'P')
	DROP PROCEDURE pa_listar_tipos_precio_paramatrizado
GO
----------------------------------------------------------------------------------
-- Author: Luis Llatas IDE-SOLUTION
-- Created: 10/02/2020  
-- Sistema: WEB / Mantenedor Precio
-- Descripción: Listar Tipos Precio Parametrizado 
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE pa_listar_tipos_precio_paramatrizado
AS

BEGIN
SET NOCOUNT ON

DECLARE @const_0 TINYINT 
DECLARE @const_1 TINYINT 
DECLARE @const_7 TINYINT 
DECLARE @const_200 TINYINT 
DECLARE @g_const_3000 INT
DECLARE @g_const_n999 INT
DECLARE @codRespuesta INT
DECLARE @mensaje VARCHAR(100)

SET @const_0  = 0
SET @const_1  = 1
SET @const_7 = 7
SET @const_200 = 200
SET @g_const_3000 = 3000
SET @g_const_n999 = -999

BEGIN TRY

  SELECT @const_200 AS codRespuesta , correlativo, descripcion,
   ( CASE WHEN (SELECT valorEntero1 FROM tblDetalleParametro WHERE tblDetalleParametro.tipo = fu_buscar_conceptos_generales.correlativo) IS NULL
       THEN @const_0
       ELSE (SELECT valorEntero1 FROM tblDetalleParametro WHERE tblDetalleParametro.tipo = fu_buscar_conceptos_generales.correlativo) END )
       AS factor 
  FROM fu_buscar_conceptos_generales (@const_7) 
  LEFT JOIN tblDetalleParametro
  ON fu_buscar_conceptos_generales.correlativo = tblDetalleParametro.tipo  
  WHERE fu_buscar_conceptos_generales.correlativo > @const_1 
  AND (tblDetalleParametro.marcaBaja = @const_0 OR tblDetalleParametro.marcaBaja IS NULL) 
  
END TRY

BEGIN CATCH
		
				SELECT @g_const_n999 AS codRespuesta, ERROR_NUMBER() AS correlativo, ERROR_MESSAGE() AS descripcion
END CATCH


END