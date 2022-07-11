
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_notacredito_obtener_motivos_nc' AND type = 'P')
DROP PROCEDURE pa_notacredito_obtener_motivos_nc
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 23/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: obtener motivos de nota credito
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_notacredito_obtener_motivos_nc
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		SELECT codigoMotivo, descripcion
		FROM tblMotivoNotaCredito
		WHERE marcaBaja = 0
		ORDER BY codigoMotivo ASC
	
	END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER() as 'codigoMotivo', 'Error en pa_notacredito_obtener_motivos_nc ' + ERROR_MESSAGE() as 'descripcion'
	END CATCH
END
GO