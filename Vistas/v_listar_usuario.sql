
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'v_listar_usuario' AND type = 'V')
	DROP VIEW v_listar_usuario
GO
/****** Object:  View [dbo].[v_listar_usuario]    Script Date: 14/04/2020 00:00:00 ******/
----------------------------------------------------------------------------------
-- Author:  Joseph Guivar IDE-SOLUTION
-- Created: 14/04/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen.
-- Modulo : Mantenedor de Usuarios
-- Descripción: Vista listar Usuario
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[v_listar_usuario]
AS
SELECT        p.codPersona as codPersona, u.codPersona as ntraUsuario, p.numeroDocumento, u.users as Usuario,CONCAT(p.nombres,' ',' ', p.apellidoPaterno,' ', p.apellidoMaterno) AS usuarioPersona
,p.correo, p.celular,  f.descripcion AS perfil ,s.descripcion as sucursal, s.ntraSucursal AS codigoSucursal, 
f.codigo AS codigoPerfil , u.estado as codEstado ,c.descripcion as estadoDescp, p.telefono		
FROM			tblUsuario AS u 
INNER JOIN		tblPersona AS p ON u.codPersona = p.codPersona 
INNER JOIN		tblSucursal AS s ON u.codSucursal = s.ntraSucursal
INNER JOIN		tblPerfil AS f ON u.codPerfil = f.codigo
INNER JOIN		tblConcepto AS  c ON u.estado = c.correlativo
WHERE c.codConcepto = 14 AND u.marcaBaja = 0 AND p.marcaBaja = 0 AND s.marcaBaja = 0 AND f.marcaBaja = 0 AND c.marcaBaja = 0
GO


