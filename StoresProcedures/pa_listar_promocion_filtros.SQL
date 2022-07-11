IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_promocion_filtros' AND type = 'P')
DROP PROCEDURE pa_listar_promocion_filtros
GO
----------------------------------------------------------------------------------
-- Author: KVASQUEZ IDE-SOLUTION
-- Created: 18/03/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Traer lista de preventa por filtros
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_listar_promocion_filtros]
@codfechaI date,			--fecha inicial
@codfechaF date,			--fecha final
@codProveedor int,			--cod Proveedor
@codTipoVenta int,			--cod Tipo de venta
@codProducto varchar(10),	--sku del producto
@codVendedor int,			--codigo del vendedor
@codCliente int,			--codigo del cliente
@estado int					--estado de la promocion
AS
BEGIN
	declare @csql nvarchar(1000)	--consulta sql


	set @csql = 'select distinct ntraPromocion,nombrePromo,fechaInicial,fechaFin,estado,estadoPromo,ISNULL(codPersona,0)codPersona,cliente,ISNULL(codVendedor,0)codVendedor,vendedor,codProducto,producto,ISNULL(codTipoVenta,0)codTipoVenta,ISNULL(tipoVenta,0)tipoVenta,ISNULL(codProveedor,0)codProveedor,proveedor ' +
				' proveedor,descImporte, tipoImporte,codProdPromoionado,prodPromocionado,ISNULL(cantVecesUsarProm,0)cantVecesUsarProm,ISNULL(vecesUsarXvendedor,0)vecesUsarXvendedor,ISNULL(cantVecesUsarXvendedor,0)cantVecesUsarXvendedor,ISNULL(vecesUsarXcliente,0)vecesUsarXcliente,ISNULL(cantVecesUsarXcliente,0)cantVecesUsarXcliente,horaInicial,horaFin,cantImporte ' +
				' from v_promocionesfiltrosweb where 1=1 '


	if @codfechaI != '' and @codfechaF != ''
		set @csql = @csql+' and fechaInicial BETWEEN ''' + convert(varchar, @codfechaI)+''''+' and '''+convert(varchar, @codfechaF)+''''
	if @codProveedor != 0
		set @csql = @csql + ' and codProveedor = ' + convert(varchar, @codProveedor)
	if @codTipoVenta != 0
		set @csql = @csql + ' and codTipoVenta = ' + convert(varchar, @codTipoVenta)
	if @codProducto != ''
		set @csql = @csql + ' and codProducto = ''' + convert(varchar, @codProducto)+ ''''
	if @codVendedor != 0
		set @csql = @csql + ' and codVendedor = ' + convert(varchar, @codVendedor)
	if @codCliente != 0
		set @csql = @csql + ' and codPersona = ' + convert(varchar, @codCliente)
	if @estado != 0
		set @csql = @csql + ' and estado = ' + convert(varchar, @estado)
	EXEC (@csql)
	--select @csql

END 

GO