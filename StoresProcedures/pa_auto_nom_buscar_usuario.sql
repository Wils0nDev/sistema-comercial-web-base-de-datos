IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_auto_nom_buscar_usuario' AND type = 'P')
	DROP PROCEDURE pa_auto_nom_buscar_usuario
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

----------------------------------------------------------------------------------
-- Author: Joseph Guivar Rimapa IDE-SOLUTION
-- Sistema: Sistema DistribuidoraVDC
-- Descripcion: Buscar usuario por nombre
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_auto_nom_buscar_usuario]
(
	/*@p_flag INT,			--flag
	@p_codCliente INT,		--codigo cliente
	@p_nombres VARCHAR(30)			--nombres*/
	@p_cadena VARCHAR(50)			--cadena
)
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		SELECT codPersona as codUsuario , numDoc , nombres
		FROM v_auto_nom_listar_usuario
		WHERE concatenado LIKE '%'+ RTRIM(LTRIM(@p_cadena)) + '%'

		END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER() as 'codCliente', 'Error en pa_auto_nom_buscar_usuario ' + ERROR_MESSAGE() as 'nombres', '' as 'numDocumento'
	END CATCH
END
