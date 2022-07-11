IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_filtro_objetivos' AND type = 'P')
	DROP PROCEDURE pa_listar_filtro_objetivos
GO
----------------------------------------------------------------------------------
-- Author: Giancarlos Sanginez IDE-SOLUTION
-- Created: 25/04/2020  
-- Sistema: web virgen del Carmen
-- Descripción: Consultar objetivos por filtros
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_listar_filtro_objetivos]
(
 @codTipoIndicador INT ,
 @codIndicador INT ,
 @codPerfil INT,
 @codTrabajador INT,
 @fechaInicio DATE = NULL,
 @fechaFin DATE = NULL
)
AS
SET NOCOUNT ON

BEGIN
	DECLARE @g_const_0 INT -- valor 0
	DECLARE @g_const_1 SMALLINT -- valor 1
	DECLARE @g_const_9 SMALLINT -- valor 9
	DECLARE @g_const_12 SMALLINT -- valor 9
	DECLARE @g_const_3000 SMALLINT -- valor 3000
	DECLARE @g_const_2000 SMALLINT -- valor 2000
	DECLARE @g_caracter CHAR(1)
	DECLARE @codigo INT -- Codigo 
	DECLARE @mensaje VARCHAR(100) -- mensaje
	DECLARE @estado SMALLINT -- 0:EXITO, 1:error interno

	DECLARE @g_codObjetivo INT -- Codigo de Objetivo
	DECLARE @g_descripcion VARCHAR(50) --Descripcion de objetivo
	DECLARE @g_codTipoIndicador INT --Codigo de Tipo de Indicador
	DECLARE @g_descTipoIndicador VARCHAR(50) -- Descripcion del Tipo de Indicador
	DECLARE @g_codIndicador INT -- Codigo de indicador
	DECLARE @g_descIndicador VARCHAR(50) -- Descripcion del Indicador
	DECLARE @g_valorIndicador DECIMAL -- Valor del indicador	
	DECLARE @g_codPerfil INT -- Codigo de Perfil
	DECLARE @g_descPerfil VARCHAR(50) -- Descripcion de Perfil
	DECLARE @g_codTrabajador INT -- Codigo de Trabajador
	DECLARE @g_descTrabajador VARCHAR(50) -- Descripcion de Perfil
	DECLARE @g_fechaRegistro DATE   -- Fecha de registro del Objetivo
		
	CREATE TABLE #listObjetivo 
		(codObjetivo INT, descripcion VARCHAR(50), codTipoIndicador INT, descTipoIndicador VARCHAR(50), codIndicador INT, descIndicador VARCHAR(50), 
		valorIndicador DECIMAL, codPerfil INT, descPerfil VARCHAR(50), codTrabajador INT, descTrabajador VARCHAR(50),fechaRegistro DATE,
		 codigo INT,estado SMALLINT,mensaje VARCHAR(100)); --tabla temporal
BEGIN TRY
	SET @g_const_0 = 0;
	SET @g_const_1 = 1;
	SET @g_const_9 = 9;
	SET @g_const_12 = 12;
	SET @g_const_2000 = 2000;
	SET @g_const_3000 = 3000;
	SET @g_caracter = ''
	SET @mensaje = 'EXITO';
	SET @estado = 0;

	SET @g_codObjetivo = 0;
	SET @g_descripcion = NULL;
	SET @g_codTipoIndicador = 0;
	SET @g_descTipoIndicador = NULL;
	SET @g_codIndicador = 0;
	SET @g_descIndicador = NULL;
	SET @g_valorIndicador = 0.0;	
	SET @g_codPerfil = 0;
	SET @g_descPerfil = NULL;
	SET @g_codTrabajador = 0;
	SET @g_descTrabajador = NULL;
	SET @g_fechaRegistro = NULL;

	DECLARE qcur_objetivos CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
		SELECT tblObjetivo.codObjetivo AS CodOjetivo, 
		tblObjetivo.descripcion AS Descripcion, 
		tblObjetivo.tipoIndicador AS CodTipoIndicador,
		tblObjetivo.indicador AS CodIndicador, 
		tblObjetivo.valorIndicador AS ValorIndicador,
		tblObjetivo.perfil AS CodPerfil, 
		tblObjetivo.trabajador AS CodTrabajador,
		tblObjetivo.fechaProceso AS FechaRegistro
		FROM tblObjetivo
		WHERE tblObjetivo.marcaBaja = 0 ;
	OPEN qcur_objetivos;
		FETCH NEXT FROM qcur_objetivos
		INTO @g_codObjetivo,@g_descripcion,@g_codTipoIndicador,@g_codIndicador,@g_valorIndicador,@g_codPerfil,@g_codTrabajador,@g_fechaRegistro; 
		WHILE @@FETCH_STATUS = @g_const_0
		BEGIN
			SELECT @g_descTipoIndicador = descripcion FROM tblConcepto WHERE codConcepto = 35 AND correlativo = @g_codTipoIndicador AND marcaBaja = 0
			IF @g_codTipoIndicador = @g_const_1
				BEGIN
					SELECT @g_descIndicador = descripcion FROM tblConcepto WHERE codConcepto = 21 AND correlativo = @g_codIndicador AND marcaBaja = 0;
				END
			ELSE
				BEGIN
					SELECT @g_descIndicador = descripcion FROM tblConcepto WHERE codConcepto = 12 AND correlativo = @g_codIndicador AND marcaBaja = 0;
				END
			SELECT @g_descPerfil = descripcion FROM tblPerfil WHERE codigo = @g_codPerfil AND marcaBaja = 0
			SELECT @g_descTrabajador = CONCAT(p.nombres,' ', p.apellidoPaterno,' ',p.apellidoMaterno) FROM tblTrabajador t
			INNER JOIN tblPersona p on t.codPersona = p.codPersona WHERE p.marcaBaja = 0 AND t.marcaBaja = 0 and p.codPersona = @g_codTrabajador

			INSERT INTO #listObjetivo 
			SELECT  @g_codObjetivo,@g_descripcion,@g_codTipoIndicador,@g_descTipoIndicador,@g_codIndicador,@g_descIndicador,@g_valorIndicador,
			@g_codPerfil,@g_descPerfil,@g_codTrabajador,@g_descTrabajador,@g_fechaRegistro,@g_const_2000,@g_const_0,@mensaje
			SET @g_codObjetivo = NULL;

			FETCH NEXT FROM qcur_objetivos 
			INTO @g_codObjetivo,@g_descripcion,@g_codTipoIndicador,@g_codIndicador,@g_valorIndicador,@g_codPerfil,@g_codTrabajador,@g_fechaRegistro;  
		 END
	CLOSE qcur_objetivos;
	DEALLOCATE qcur_objetivos;	
	IF  @codTipoIndicador = @g_const_0 AND @codIndicador = @g_const_0 AND @codPerfil = @g_const_0 AND @codTrabajador = @g_const_0 AND @fechaInicio IS NULL AND @fechaFin IS NULL
		BEGIN 
			SELECT codObjetivo,descripcion,codTipoIndicador,descTipoIndicador,codIndicador,descIndicador,valorIndicador,codPerfil,descPerfil,codTrabajador,descTrabajador,fechaRegistro,codigo,estado,mensaje
			FROM #listObjetivo ORDER BY codObjetivo DESC;		 
		END
END TRY
BEGIN CATCH
	SET @codigo = @g_const_3000;
	SET @estado = @g_const_1;
	SET @mensaje = ERROR_MESSAGE();
	SELECT '' AS codObjetivo,@g_const_0 as codproveedor,@g_const_0 as codEstado,'' as descproveedor,'' as descripcion,
	@codigo as codigo, @estado as estado,@mensaje as mensaje
END CATCH
END