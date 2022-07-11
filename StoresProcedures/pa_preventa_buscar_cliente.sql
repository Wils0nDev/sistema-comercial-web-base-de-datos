
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_preventa_buscar_cliente' AND type = 'P')
DROP PROCEDURE pa_preventa_buscar_cliente
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 09/03/2020
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripcion: Buscar cliente preventa
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_preventa_buscar_cliente
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
		SELECT codPersona as codCliente, nombres, tipoListaPrecio, numDocumento
		FROM v_preventa_listar_clientes
		WHERE concatenado LIKE '%'+ RTRIM(LTRIM(@p_cadena)) + '%'

	/*IF(@p_flag = 1)
		BEGIN
		

			SELECT p.codPersona as 'codCliente', (CASE WHEN (p.tipoPersona) = 2 THEN UPPER(p.razonSocial) ELSE UPPER(p.apellidoPaterno + ' ' + p.apellidoMaterno + ' ' + p.nombres) END) AS 'nombres', 
			c.tipoListaPrecio as 'tipoListaPrecio'
			FROM tblPersona p INNER JOIN tblCliente c ON p.codPersona = c.codPersona
			WHERE CAST(p.codPersona AS varchar(12)) LIKE '%'+ CAST(@p_codCliente AS varchar(12)) + '%'
		
		END
	ELSE
		BEGIN
			SELECT p.codPersona as 'codCliente', (CASE WHEN (p.tipoPersona) = 2 THEN UPPER(p.razonSocial) ELSE UPPER(p.apellidoPaterno + ' ' + p.apellidoMaterno + ' ' + p.nombres) END) AS 'nombres', 
			c.tipoListaPrecio as 'tipoListaPrecio'
			FROM tblPersona p INNER JOIN tblCliente c ON p.codPersona = c.codPersona
			WHERE p.apellidoPaterno like '%'+ @p_nombres + '%' OR p.apellidoMaterno like '%'+ @p_nombres + '%'
			OR p.nombres like '%'+ @p_nombres + '%' OR p.razonSocial like '%'+ @p_nombres + '%'
		END*/
	
	END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER() as 'codCliente', 'Error en pa_preventa_buscar_cliente ' + ERROR_MESSAGE() as 'nombres', 1 as 'tipoListaPrecio', '' as 'numDocumento'
	END CATCH
END
GO