IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_descuento_listar_filtros' AND type = 'P')
	DROP PROCEDURE pa_descuento_listar_filtros
GO
----------------------------------------------------------------------------------
-- Author: Diego Sanchez IDE-SOLUTION
-- Created: 28/03/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen.
-- Descripción: Obtener la lista de descuentos segun el filtro seleccionado
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_descuento_listar_filtros]
@codProducto VARCHAR(10),
@codVendedor int,
@codCliente int,
@codEstado int,
@codfechaI date,
@codfechaF date
AS
BEGIN
	DECLARE @csql NVARCHAR(1500) --consulta sql

	SET @csql = 'select df.ntraDescuento, df.descripcion, df.flag1 as codProd, df.desProducto as desProd, df.codUnidad, df.desUnidad, df.fechaInicial,df.fechaFin, '+
				'df.horaInicial,df.horaFin,df.desestado as desEstado, df.estado as codEstado, flag2 as cant,flag2_2 as tipoCant,flag3 as descuento,flag3_2 tipodesc,isnull(flag4,0) as codVen, '+
				'CONCAT(per2.nombres,'+ '''  ''' +', per2.apellidoPaterno,' + '''  ''' + ', per2.apellidoMaterno) as vendedor, isnull(flag5,0) as codCli, '+ 
				'CASE 
					when per.tipoPersona = 1 THEN  CONCAT(per.nombres, ' + '''  ''' + ', per.apellidoPaterno,' + '''  ''' + ', per.apellidoMaterno)
					WHEN per.tipoPersona = 2 THEN  per.razonSocial 
				END as cliente, isnull(flag6,0) as vecesDes, isnull(flag7,0) as vecesVen, isnull(flag8,0) as vecesCli
				from v_descuentos_filtros df
				left join tblPersona per on per.codPersona = flag5
				left join tblUsuario usr on usr.ntraUsuario = flag4 
				left join tblPersona per2 on per2.codPersona = usr.codPersona
				where 1=1 '

	if @codProducto != ''
		set @csql = @csql + ' and flag1 = ''' + convert(varchar, @codProducto)+''''
	if @codVendedor != 0
		set @csql = @csql + ' and flag4 = ' + convert(varchar, @codVendedor)
	if @codCliente != 0
		set @csql = @csql + ' and flag5 = ' + convert(varchar, @codCliente)
	if @codEstado != 0
		set @csql = @csql + ' and df.estado = ' + convert(varchar, @codEstado)
	if @codfechaI != '' and @codfechaF != ''
		set @csql = @csql+' and df.fechaInicial >= ''' + convert(varchar, @codfechaI)+''''+' and df.fechaFin <= '''+convert(varchar, @codfechaF)+''''
	
	EXEC (@csql)
	--select @csql;
END