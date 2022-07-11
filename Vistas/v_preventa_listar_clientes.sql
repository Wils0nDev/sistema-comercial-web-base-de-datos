
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'v_preventa_listar_clientes' AND type = 'V')
	DROP VIEW v_preventa_listar_clientes
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
CREATE VIEW v_preventa_listar_clientes
AS
SELECT CONCAT((CASE WHEN (p.tipoPersona) = 2 THEN UPPER(p.razonSocial) ELSE UPPER(p.apellidoPaterno + ' ' + p.apellidoMaterno + ' ' + p.nombres) END),
' - ',(CASE WHEN (p.tipoPersona) = 2 THEN UPPER(p.ruc) ELSE UPPER(p.numeroDocumento) END)) AS 'concatenado', 
c.codPersona as 'codPersona',
(CASE WHEN (p.tipoPersona) = 2 THEN UPPER(p.ruc) ELSE UPPER(p.numeroDocumento) END) AS 'numDocumento',
(CASE WHEN (p.tipoPersona) = 2 THEN UPPER(p.razonSocial) ELSE UPPER(p.apellidoPaterno + ' ' + p.apellidoMaterno + ' ' + p.nombres) END) AS 'nombres',
c.tipoListaPrecio as 'tipoListaPrecio'

FROM tblPersona p INNER JOIN tblCliente c
ON p.codPersona = c.codPersona
WHERE c.marcaBaja = 0 and p.marcaBaja = 0

