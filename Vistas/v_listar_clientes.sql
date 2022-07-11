
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'v_listar_clientes' AND type = 'V')
	DROP VIEW v_listar_clientes
GO
/****** Object:  View [dbo].[v_listar_clientes]    Script Date: 31/01/2020 10:00:00 ******/
----------------------------------------------------------------------------------
-- Author: Jonathan Macalupu S. IDE-SOLUTION
-- Created:  31/01/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen.
-- Modulo : Mantenedor de clientes.
-- Descripción: Vista listar clientes
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW v_listar_clientes
AS

SELECT p.codPersona AS codPersona, p.tipoPersona AS tipoPersona, p.tipoDocumento AS tipoDocumento, p.numeroDocumento AS numeroDocumento, p.ruc AS ruc, p.razonSocial AS razonSocial, 
p.nombres AS nombres, p.apellidoPaterno as apellidoPaterno, p.apellidoMaterno AS apellidoMaterno, p.nombres + ' ' + p.apellidoPaterno + ' ' + p.apellidoMaterno AS nombreCompleto , 
p.direccion AS direccion, p.correo AS correo, p.telefono AS telefono, p.celular AS celular,
c.perfilCliente AS perfilCliente, c.clasificacionCliente AS clasificacionCliente, c.frecuenciaCliente AS frecuenciaCliente, 
c.tipoListaPrecio AS tipoListaPrecio, c.codRuta AS codRuta, c.ordenAtencion AS ordenAtencion, p.codUbigeo AS codUbigeo,l.coordenadaX as coordenadaX , l.coordenadaY as coordenadaY
FROM tblPersona p INNER JOIN tblCliente c ON p.codPersona = c.codPersona
INNER JOIN tblLocalizacion l on c.codPersona = l.codPersona
WHERE p.marcaBaja = 0 AND c.marcaBaja = 0;

GO