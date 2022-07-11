IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_obtener_descripcion_ubigeo' AND type = 'P')
	DROP PROCEDURE pa_obtener_descripcion_ubigeo
GO
----------------------------------------------------------------------------------
-- Author: Diego Sanchez IDE-SOLUTION
-- Created: 23/03/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen.
-- Descripción: Obtener la descripcion del ubigeo
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_obtener_descripcion_ubigeo]
@codUbigeo char(6)
AS
BEGIN

DECLARE @depa char(2)
DECLARE @prov char(2)
DECLARE @dist char(2)
DECLARE @departamento varchar(50)
DECLARE @provincia varchar(50)
DECLARE @distrito varchar(50)

set @depa = SUBSTRING(@codUbigeo,1,2);
set @prov = SUBSTRING(@codUbigeo,3,2);
set @dist = SUBSTRING(@codUbigeo,5,2);

select @departamento = nombre from tblDepartamento where codDepartamento = @depa and marcaBaja = 0 
select @provincia = nombre from tblProvincia where codDepartamento = @depa and codProvincia = @prov and marcaBaja = 0 
select @distrito = nombre from tblDistrito where codDepartamento = @depa and codProvincia = @prov and codDistrito = @dist and marcaBaja = 0;

select @codUbigeo as codigo, concat(@departamento,' - ', @provincia, ' - ', @distrito) as descripcion

END

