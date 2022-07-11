IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'v_auto_nom_listar_usuario' AND type = 'V')
	DROP VIEW v_auto_nom_listar_usuario
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
CREATE VIEW [dbo].[v_auto_nom_listar_usuario]
AS
SELECT  
	CONCAT(	(CASE WHEN (p.tipoPersona) = 1 THEN UPPER(p.apellidoPaterno ) ELSE UPPER(p.apellidoPaterno + ' ' + p.apellidoMaterno + ' ' + p.nombres) END), ' ',
			(CASE WHEN (p.tipoPersona) = 1 THEN UPPER(p.apellidoMaterno ) ELSE UPPER(p.apellidoPaterno + ' ' + p.apellidoMaterno + ' ' + p.nombres) END), ' ',
			(CASE WHEN (p.tipoPersona) = 1 THEN UPPER( p.nombres ) ELSE UPPER(p.apellidoPaterno + ' ' + p.apellidoMaterno + ' ' + p.nombres) END) , ' - ',
			(CASE WHEN (p.tipoPersona) = 1 THEN  UPPER (u.users)  ELSE  (p.apellidoPaterno + ' ' + p.apellidoMaterno + ' ' + p.nombres) END)) AS 'concatenado',
			

		--    (CASE WHEN (p.tipoPersona) = 1 THEN  UPPER (u.users)  ELSE  (p.apellidoPaterno + ' ' + p.apellidoMaterno + ' ' + p.nombres) END ) AS 'userConcatenado',

	CONCAT(	(CASE WHEN (p.tipoPersona) = 1 THEN UPPER(p.apellidoPaterno ) ELSE UPPER(p.apellidoPaterno + ' ' + p.apellidoMaterno + ' ' + p.nombres) END), ' ',
			(CASE WHEN (p.tipoPersona) = 1 THEN UPPER(p.apellidoMaterno ) ELSE UPPER(p.apellidoPaterno + ' ' + p.apellidoMaterno + ' ' + p.nombres) END), ' ',
			(CASE WHEN (p.tipoPersona) = 1 THEN UPPER( p.nombres ) ELSE UPPER(p.apellidoPaterno + ' ' + p.apellidoMaterno + ' ' + p.nombres) END)) AS 'nombres',

				p.codPersona		as 'codPersona',
				p.numeroDocumento	as	'numDoc'
			--	u.users				as	'userName'


FROM tblPersona p INNER JOIN tblUsuario u
ON p.codPersona = u.codPersona 
WHERE u.marcaBaja = 0 and p.marcaBaja = 0
