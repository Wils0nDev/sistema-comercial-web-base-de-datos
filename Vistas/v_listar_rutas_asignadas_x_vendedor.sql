
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'v_listar_rutas_asignadas_x_vendedor' AND type = 'V')
	DROP VIEW v_listar_rutas_asignadas_x_vendedor
GO
/****** Object:  View [dbo].[v_listar_rutas_asignadas_x_vendedor]    Script Date: 12/02/2020 10:00:00 ******/
----------------------------------------------------------------------------------
-- Author: Wilson Vasquez IDE-SOLUTION
-- Created: 12/02/2020  
-- Sistema: WEB / Mantenedor Rutas Asignadas
-- Descripción: Vista listar rutas asignadas por vendedor
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW v_listar_rutas_asignadas_x_vendedor
AS
SELECT r.ntraRutas,u.ntraUsuario,c.correlativo, codOrden as ORDEN , r.pseudonimo as ABREVIATURA, CONCAT(p.nombres,' ', p.apellidoPaterno,' ',p.apellidoMaterno) as VENDEDOR ,
r.descripcion  AS RUTA, c.descripcion AS DIA , ra.estado
FROM tblRutasAsignadas ra 
INNER JOIN tblRutas r on ra.codRuta = r.ntraRutas 
INNER JOIN tblUsuario u on ra.codUsuario = u.ntraUsuario
INNER JOIN tblPersona p on u.codPersona = p.codPersona
INNER JOIN tblConcepto c on ra.diaSemana = c.correlativo
WHERE c.codConcepto = 8 AND r.marcaBaja = 0 and u.marcaBaja = 0 and c.marcaBaja = 0 and p.marcaBaja = 0 and ra.marcaBaja = 0
GO


