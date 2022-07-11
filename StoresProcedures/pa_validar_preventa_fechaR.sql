IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_validar_preventa_fechaR' AND type = 'P')
	DROP PROCEDURE pa_validar_preventa_fechaR
GO
----------------------------------------------------------------------------------
-- Author: Diego Sanchez IDE-SOLUTION
-- Created: 20/03/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen.
-- Descripción: Validar cantidad de dias maximo en la fecha de registro de la preventa
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_validar_preventa_fechaR]
@codfechaRegistroI date,
@codfechaRegistroF date
AS
BEGIN
	DECLARE @diasMax SMALLINT -- valor 0-- Contador de usuario activo
	declare @fecha1 date
	declare @fecha2 date
	declare @diferencia int
	declare @msj varchar(50)
	declare @resp int
	set @fecha1 = @codfechaRegistroI
	set @fecha2 = @codfechaRegistroF
	select @diasMax = valorEntero1 from tblDetalleParametro where codParametro = 7;

	set @diferencia = DATEDIFF(DAY,@fecha1,@fecha2)
		
	if @diferencia > @diasMax
		begin
		set @resp = 0 ;
		set @msj = 'El rango de fechas maximo es de '+ Convert(varchar,@diasMax) +' dias';
		end
	else
		begin
		set @resp = 1 ;
		set @msj = 'ok';
		end

	select @resp as codMsj, @msj as mensaje;
END
