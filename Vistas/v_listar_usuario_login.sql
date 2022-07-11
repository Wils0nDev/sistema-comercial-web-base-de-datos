IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'v_listar_usuario_login' AND type = 'V')
	DROP VIEW v_listar_usuario_login
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----------------------------------------------------------------------------------
-- Author: Jeffrey Garcia
-- Created: 11/04/2020  
-- Sistema: WEB / LOGIN
-- Descripción: Vista listar credenciales de usuario logueado
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[v_listar_usuario_login]
AS
	SELECT 	u.ntraUsuario as codusuario,u.users as usuario, u.[password] as [password],ps.codPersona as codpersona,p.descripcion as perfil,
			CONCAT(ps.nombres,' ',ps.apellidoPaterno,' ',ps.apellidoMaterno) as nombreCompleto ,
			c.descripcion as estadoUsuario,p.estado  as estadoPersona,ps.correo as correo,s.ntraSucursal as sucural,ps.telefono as telefono
			FROM tblUsuario as u
			inner join tblPerfil as p on u.codPerfil = p.codigo
			inner join tblPersona as ps on u.codPersona = ps.codPersona
			inner join tblConcepto as c on c.correlativo = u.estado
			inner join tblSucursal as s  on s.ntraSucursal = u.codSucursal
			WHERE	
				 u.marcaBaja = 0 and p.marcaBaja = 0
				and ps.marcaBaja = 0 and c.codConcepto = 14
go