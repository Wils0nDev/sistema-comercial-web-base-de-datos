
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_buscar_modulos' AND type = 'P')
	DROP PROCEDURE pa_buscar_modulos
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------------------
-- Author: Jeffrey Garcia IDE-SOLUTION
-- Created: 22/04/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: buscar detalle de modulos
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_buscar_modulos]
(
    @p_codUser INT ,      -- codigo de usuario
    @p_flag INT           -- tipo de opearcion(1:listar por perfil, 2:listar todos)

)
AS
BEGIN 
	SET NOCOUNT ON;  
	BEGIN TRY
        BEGIN   
            DECLARE @codPerfil INT;
            IF @p_flag = 1 
               BEGIN
                    SET @codPerfil = (SELECT codPerfil from tblUsuario WHERE ntraUsuario = @p_codUser)

                    SELECT * FROM v_modulos_detalle where responsable = @codPerfil
                    order by codModulo,codMenu
               END
            ELSE IF @p_flag = 2   
                BEGIN
                    SELECT * FROM v_modulos_detalle where responsable = @p_codUser
                    order by codModulo,codMenu
                END 
        END
    END TRY
    BEGIN CATCH
        SELECT ERROR_NUMBER() as 'codError' , 'Error en pa_buscar_modulos' + ERROR_MESSAGE() as 'mensaje'
    END CATCH
END
