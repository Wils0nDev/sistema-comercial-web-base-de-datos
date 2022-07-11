IF DB_NAME() = 'BD_virgendelcarmen'
	set noexec on
GO
--TABLA DE CATEGORIAS DE CATEGORIAS

IF OBJECT_ID(N'dbo.tblCategoria', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblCategoria]
(
[ntraCategoria] [int] IDENTITY (1,1) NOT NULL,
[abreviatura] [varchar](5) NOT NULL,
[descripcion] [varchar] (100) NOT NULL,
[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso] [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario] [varchar](20) NOT NULL,
[ip] [varchar](20) NULL,
[mac] [varchar](20) NULL,
CONSTRAINT pk_tblCategoria PRIMARY KEY (ntraCategoria)
);
END

--TABLA DE CATEGORIAS DE SUB CATEGORIAS

IF OBJECT_ID(N'dbo.tblSubcategoria', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblSubcategoria]
(
[ntraSubcategoria] [int] IDENTITY (1,1) NOT NULL,
[codCategoria] [int] NOT NULL,
[abreviatura] [varchar](5) NOT NULL,
[descripcion] [varchar] (100) NOT NULL,
[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso] [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario] [varchar](20) NOT NULL,
[ip] [varchar](20) NULL,
[mac] [varchar](20) NULL,
CONSTRAINT pk_tblSubcategoria PRIMARY KEY (ntraSubcategoria,codCategoria)
);
END

ALTER TABLE tblSubcategoria ADD CONSTRAINT fk_cod_categoria FOREIGN KEY (codCategoria) REFERENCES tblCategoria (ntraCategoria);


--TABLA DE MARCA DE FABRICANTE

IF OBJECT_ID(N'dbo.tblFabricante', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblFabricante]
(
[ntraFabricante] [int] IDENTITY (1,1) NOT NULL,
[abreviatura] [varchar](5) NOT NULL,
[descripcion] [varchar] (100) NOT NULL,
[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso] [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario] [varchar](20) NOT NULL,
[ip] [varchar](20) NULL,
[mac] [varchar](20) NULL,
CONSTRAINT pk_tblFabricante PRIMARY KEY (ntraFabricante)
);
END

--TABLA DE MARCA DE PROVEDDOR
IF OBJECT_ID(N'dbo.tblProveedor', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblProveedor]
(
[ntraProveedor] [int] IDENTITY (1,1) NOT NULL,
[abreviatura] [varchar](5) NOT NULL,
[descripcion] [varchar] (100) NOT NULL,
[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso] [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario] [varchar](20) NOT NULL,
[ip] [varchar](20) NULL,
[mac] [varchar](20) NULL,
CONSTRAINT pk_tblProveedor PRIMARY KEY (ntraProveedor)
);
END


--TABLA DE PRODUCTOS
IF OBJECT_ID(N'dbo.tblProducto', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblProducto]
(
[codProducto] [varchar](10) NOT NULL,
[descripcion] [varchar](200) NOT NULL,
[codUnidadBaseventa] [int] NOT NULL,
[codCategoria] [int] NOT NULL,
[codSubcategoria] [int] NOT NULL,
[tipoProducto] [tinyint] NOT NULL,
[flagVenta] [tinyint] NOT NULL,
[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[codFabricante] [int] NOT NULL,
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso] [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario] [varchar](20) NOT NULL,
[ip] [varchar](20) NULL,
[mac] [varchar](20) NULL,
CONSTRAINT pk_tblProducto PRIMARY KEY (codProducto)
);
END

ALTER TABLE tblProducto ADD CONSTRAINT fk_codSubcategoria FOREIGN KEY (codSubcategoria,codCategoria) REFERENCES tblSubcategoria (ntraSubcategoria,codCategoria);
GO
ALTER TABLE tblProducto ADD CONSTRAINT fk_codFabricante FOREIGN KEY (codFabricante) REFERENCES tblFabricante (ntraFabricante);
GO

--TABLA DE SUCURSALES
IF OBJECT_ID(N'dbo.tblSucursal', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblSucursal]
(
[ntraSucursal] [int] IDENTITY (1,1) NOT NULL,
[descripcion] [varchar](100) NOT NULL,
[codUbigeo] [char](6) NULL, 
[factor] [decimal](14, 2) NOT NULL, 
[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso] [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario] [varchar](20) NOT NULL,
[ip] [varchar](20) NULL,
[mac] [varchar](20) NULL,
CONSTRAINT pk_tblSucursal PRIMARY KEY (ntraSucursal)
);
END
GO

--TABLA DE ALMACENES
IF OBJECT_ID(N'dbo.tblAlmacen', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblAlmacen]
(
[ntraAlmacen] [tinyint] IDENTITY (1,1) NOT NULL,
[descripcion] [varchar](20) NOT NULL,
[abreviatura] [varchar](5) NOT NULL,
[codSucursal] [int] NULL,
[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso] [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario] [varchar](20) NOT NULL,
[ip] [varchar](20) NULL,
[mac] [varchar](20) NULL,
CONSTRAINT pk_tblAlmacen PRIMARY KEY (ntraAlmacen)
);
END

ALTER TABLE tblAlmacen ADD CONSTRAINT fk_tblAlmacen_codSucursal FOREIGN KEY (codSucursal) REFERENCES tblSucursal (ntraSucursal);
GO 

--TABLA DE INVENTARIO
IF OBJECT_ID(N'dbo.tblInventario', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblInventario]
(
[ntraInventario] [int] IDENTITY (1,1) NOT NULL,
[codAlmacen] [tinyint] NOT NULL,
[codProducto] [varchar](10) NOT NULL,
[stock] [int] NOT NULL,
[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso] [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario] [varchar](20) NOT NULL,
[ip] [varchar](20) NULL,
[mac] [varchar](20) NULL,
CONSTRAINT pk_tblInventario PRIMARY KEY (ntraInventario)
);
END
ALTER TABLE tblInventario ADD CONSTRAINT fk_codAlmacen FOREIGN KEY (codAlmacen) REFERENCES tblAlmacen (ntraAlmacen);
GO
ALTER TABLE tblInventario ADD CONSTRAINT fk_codProducto FOREIGN KEY (codProducto) REFERENCES tblProducto (codProducto);
GO


--TABLA DE PERSONA
IF OBJECT_ID(N'dbo.tblPersona', N'U') IS NULL
BEGIN 
CREATE TABLE tblPersona  
(
codPersona int PRIMARY KEY NOT NULL,  
tipoPersona tinyint NOT NULL,
tipoDocumento tinyint NULL,
numeroDocumento varchar(15) NULL,
ruc varchar(15) NULL,
razonSocial varchar(150) NULL,
nombres varchar(30) NULL,
apellidoPaterno varchar(20) NULL,
apellidoMaterno varchar(20) NULL,
fechaNacimiento date NULL,
estadoCivil smallint NULL,
direccion varchar(200) NOT NULL,
correo varchar(60) NULL,
telefono varchar(15) NULL,
celular char(9) NULL,
codUbigeo char(6) NULL, 
marcaBaja tinyint NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
fechaProceso date NOT NULL DEFAULT GETDATE(),
horaProceso time (0) NOT NULL DEFAULT SYSDATETIME(),
usuario varchar(20) NOT NULL,
ip varchar(20) NULL,
mac varchar(20) NULL
);
END
GO


--TABLA DE DEPARTAMENTO
IF OBJECT_ID(N'dbo.tblDepartamento', N'U') IS NULL
BEGIN
CREATE TABLE tblDepartamento  
(
codDepartamento char(2) PRIMARY KEY NOT NULL,
nombre varchar(50) NOT NULL,
marcaBaja tinyint NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
fechaProceso date NOT NULL DEFAULT GETDATE(),
horaProceso time (0) NOT NULL DEFAULT SYSDATETIME(),
usuario varchar(20) NOT NULL,
ip varchar(20) NULL,
mac varchar(20) NULL
);
END


--TABLA DE PROVINCIA
IF OBJECT_ID(N'dbo.tblProvincia', N'U') IS NULL
BEGIN
CREATE TABLE tblProvincia  
(
codDepartamento char(2) NOT NULL,
codProvincia char(2) NOT NULL,
nombre varchar(50) NOT NULL,
marcaBaja tinyint NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
fechaProceso date NOT NULL DEFAULT GETDATE(),
horaProceso time (0) NOT NULL DEFAULT SYSDATETIME(),
usuario varchar(20) NOT NULL,
ip varchar(20) NULL,
mac varchar(20) NULL,
PRIMARY KEY(codDepartamento, codProvincia)
);
END


--TABLA DE DISTRITO
IF OBJECT_ID(N'dbo.tblDistrito', N'U') IS NULL
BEGIN
CREATE TABLE tblDistrito  
(
codDepartamento char(2) NOT NULL,
codProvincia char(2) NOT NULL,
codDistrito char(2) NOT NULL,
nombre varchar(50) NOT NULL,
ubigeo char(6) NULL,
marcaBaja tinyint NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
fechaProceso date NOT NULL DEFAULT GETDATE(),
horaProceso time (0) NOT NULL DEFAULT SYSDATETIME(),
usuario varchar(20) NOT NULL,
ip varchar(20) NULL,
mac varchar(20) NULL,
PRIMARY KEY(codDepartamento, codProvincia, codDistrito)
);
END


-- TABLA DE BITACORAS DE RUTAS
CREATE TABLE tblRutaBitacora (
  codRuta int NOT NULL,
  codCliente VARCHAR(12) NOT NULL,
  fecha date NOT NULL,
  visita smallint NOT NULL ,
  motivo varchar(500)  NULL,
  cordenadaX varchar(100) NOT NULL,
  cordenadaY varchar(100) NOT NULL,
  estado smallint NOT NULL,
  marcaBaja tinyint NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
  fechaProceso date NOT NULL DEFAULT GETDATE(),
  horaProceso time NOT NULL  DEFAULT SYSDATETIME(),
  usuario varchar(20) NOT NULL,
  ip varchar(20)  NULL,
  mac varchar(20) NULL
  
);

-- TABLA DE RUTAS 
CREATE TABLE tblRutas (
  ntraRutas  int NOT NULL identity primary key,
  descripcion varchar(200) NOT NULL,
  pseudonimo varchar(100) NOT NULL,
  codSucursal int NULL,
  marcaBaja tinyint NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
  fechaProceso date NOT NULL DEFAULT GETDATE(),
  horaProceso time NOT NULL  DEFAULT SYSDATETIME(),
  usuario varchar(20) NOT NULL,
  ip varchar(20)  NULL,
  mac varchar(20) NULL
);

ALTER TABLE tblRutas ADD CONSTRAINT fk_tblRutas_codSucursal FOREIGN KEY (codSucursal) REFERENCES tblSucursal (ntraSucursal);
GO 

-- TABLA DE RUTAS ASIGNADAS
CREATE TABLE tblRutasAsignadas (
  ntraRutasAsignadas int NOT NULL identity primary key,
  codUsuario int NOT NULL,
  codRuta int NOT NULL,
  codOrden int NOT NULL,
  diaSemana smallint NOT NULL, 
  estado smallint NOT NULL DEFAULT 0, 
  marcaBaja tinyint NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
  fechaProceso date NOT NULL DEFAULT GETDATE(),
  horaProceso time NOT NULL  DEFAULT SYSDATETIME(),
  usuario varchar(20) NOT NULL,
  ip varchar(20)  NULL,
  mac varchar(20) NULL
);

-- TABLA DE USUARIO 
CREATE TABLE tblUsuario (
  ntraUsuario int  not null  identity primary key,
  users varchar(20) not null,
  password VARBINARY(8000) NOT NULL,
  codPersona integer not null,
  codPerfil int not null,
  codSucursal int null,
  estado tinyint not null,
  marcaBaja tinyint not null,
  fechaProceso date not null,
  horaProceso time not null,
  usuario varchar(20) not null,
  ip varchar(20) not null,
  mac varchar(20) not null
);	

ALTER TABLE tblUsuario ADD CONSTRAINT fk_tblUsuario_codSucursal FOREIGN KEY (codSucursal) REFERENCES tblSucursal (ntraSucursal);
GO 

--TABLA DE CLIENTES

IF OBJECT_ID(N'dbo.tblCliente', N'U') IS NULL
BEGIN
CREATE TABLE tblCliente  
(
codPersona int PRIMARY KEY NOT NULL,  
ordenAtencion smallint NULL,  
perfilCliente tinyint NULL,  
clasificacionCliente tinyint NULL,  
frecuenciaCliente tinyint NOT NULL,
tipoListaPrecio tinyint NOT NULL,
codRuta int NOT NULL,
marcaBaja tinyint NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
fechaProceso date NOT NULL DEFAULT GETDATE(),
horaProceso time (0) NOT NULL DEFAULT SYSDATETIME(),
usuario varchar(20) NOT NULL,
ip varchar(20) NULL,
mac varchar(20) NULL
);
END 

ALTER TABLE tblCliente ADD CONSTRAINT fk_codRuta FOREIGN KEY (codRuta) REFERENCES tblRutas (ntraRutas);
GO

ALTER TABLE tblPersona ADD CONSTRAINT fk_codCliente FOREIGN KEY (codPersona) REFERENCES tblPersona (codPersona);
GO


--TABLA DE PROMOCIONES

IF OBJECT_ID(N'dbo.tblPromociones', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblPromociones]
(
[ntraPromocion] [int] IDENTITY (1,1) NOT NULL,
[descripcion] [varchar] (100) NOT NULL,
[fechaInicial] [date] NOT NULL,
[fechaFin] [date] NOT NULL,
[horaInicial] [time] NOT NULL,
[horaFin] [time] NOT NULL,
[estado] [tinyint] NOT NULL,
[codSucursal] [int] NULL,
[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso] [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario] [varchar](20) NOT NULL,
[ip] [varchar](20) NULL,
[mac] [varchar](20) NULL,
CONSTRAINT pk_tblPromociones PRIMARY KEY (ntraPromocion)
);
END

ALTER TABLE tblPromociones ADD CONSTRAINT fk_tblPromociones_codSucursal FOREIGN KEY (codSucursal) REFERENCES tblSucursal (ntraSucursal);
GO 

--TABLA DE DETALLE DE PROMOCIONES

IF OBJECT_ID(N'dbo.tblDetallePromociones', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblDetallePromociones]
(
[ntraPromocion] [int] NOT NULL,
[flag] [int] NOT NULL,
[descripcion] [varchar] (100) NOT NULL,
[valorInicial] [varchar] (200) NOT NULL,
[valorFinal] [varchar] (200) NOT NULL,
[detalle] [tinyint] NOT NULL,
[estado] [tinyint] NULL,
[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso] [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario] [varchar](20) NOT NULL,
[ip] [varchar](20) NULL,
[mac] [varchar](20) NULL,
CONSTRAINT pk_tblDetallePromociones PRIMARY KEY (ntraPromocion,flag)
);
END


--TABLA DE DETALLE FLAG DE PROMOCIONES

IF OBJECT_ID(N'dbo.tblDetalleFlagPromocion', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblDetalleFlagPromocion]
(
[ntraPromocion] [int] NOT NULL,
[flag] [int] NOT NULL,
[descripcion] [varchar] (100) NOT NULL,
[valorEntero1] [int] NULL,
[valorEntero2] [int] NULL,
[valorMoneda1] [money] NULL,
[valorMoneda2] [money] NULL,
[valorCadena1] [varchar] (200) NULL,
[valorCadena2] [varchar] (200) NULL,
[valorFecha1] [date] NULL,
[valorFecha2] [date] NULL,
[estado] [tinyint] NULL,
[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso] [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario] [varchar](20) NOT NULL,
[ip] [varchar](20) NULL,
[mac] [varchar](20) NULL,
CONSTRAINT pk_tblDetalleFlagPromocion PRIMARY KEY (ntraPromocion,flag)
);
END


ALTER TABLE tblDetallePromociones ADD CONSTRAINT fk_ntra_flag_detalle FOREIGN KEY (ntraPromocion) REFERENCES tblPromociones (ntraPromocion);
GO

ALTER TABLE tblDetalleFlagPromocion ADD CONSTRAINT fk_ntra_flag_detalle_flag FOREIGN KEY (ntraPromocion,flag) REFERENCES tblDetallePromociones (ntraPromocion,flag);
GO



--TABLA DE DESCUENTOS

IF OBJECT_ID(N'dbo.tblDescuentos', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblDescuentos]
(
[ntraDescuento] [int] IDENTITY (1,1) NOT NULL,
[descripcion]  [varchar] (200) NOT NULL,
[fechaInicial] [date] NOT NULL,
[fechaFin] [date] NOT NULL,
[horaInicial] [time] NOT NULL,
[horaFin] [time] NOT NULL,
[tipoDescuento] [tinyint] NOT NULL,
[estado]  [tinyint] NOT NULL,
[codSucursal] [int] NULL,
[marcaBaja]    [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso]  [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario]      [varchar](20) NOT NULL,
[ip]           [varchar](20) NULL,
[mac]          [varchar](20) NULL,
CONSTRAINT pk_tblDescuentos PRIMARY KEY (ntraDescuento)
);
END

ALTER TABLE tblDescuentos ADD CONSTRAINT fk_tblDescuentos_codSucursal FOREIGN KEY (codSucursal) REFERENCES tblSucursal (ntraSucursal);
GO 


--TABLA DE DETALLE DE DESCUENTOS

IF OBJECT_ID(N'dbo.tblDetalleDescuentos', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblDetalleDescuentos]
(
[ntraDescuento] [int] NOT NULL,
[flag] [int] NOT NULL,
[descripcion]  [varchar] (100) NOT NULL,
[valorInicial]  [varchar] (200) NOT NULL,
[valorFinal]  [varchar] (200) NOT NULL,
[detalle]  [tinyint] NOT NULL,
[estado]  [tinyint] NULL,
[marcaBaja]    [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso]  [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario]      [varchar](20) NOT NULL,
[ip]           [varchar](20) NULL,
[mac]          [varchar](20) NULL,
CONSTRAINT pk_tblDetalleDescuentos PRIMARY KEY (ntraDescuento,flag)
);
END


--TABLA DE DETALLE FLAG DE DESCUENTOS

IF OBJECT_ID(N'dbo.tblDetalleFlagDescuento', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblDetalleFlagDescuento]
(
[ntraDescuento] [int] NOT NULL,
[flag] [int] NOT NULL,
[descripcion]  [varchar] (100) NOT NULL,
[valorEntero1] [int] NULL,
[valorEntero2] [int] NULL,
[valorMoneda1] [money] NULL,
[valorMoneda2] [money] NULL,
[valorCadena1]  [varchar] (200) NULL,
[valorCadena2]  [varchar] (200) NULL,
[valorFecha1] [datetime] NULL,
[valorFecha2] [datetime] NULL,
[estado]  [tinyint] NULL,
[marcaBaja]    [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso]  [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario]      [varchar](20) NOT NULL,
[ip]           [varchar](20) NULL,
[mac]          [varchar](20) NULL,
CONSTRAINT pk_tblDetalleFlagDescuento PRIMARY KEY (ntraDescuento,flag)
);
END


ALTER TABLE tblDetalleDescuentos ADD CONSTRAINT fk_ntra_flag_detalle_des FOREIGN KEY (ntraDescuento) REFERENCES tblDescuentos (ntraDescuento);
GO

ALTER TABLE tblDetalleFlagDescuento ADD CONSTRAINT fk_ntra_flag_detalle_des_flag FOREIGN KEY (ntraDescuento,flag) REFERENCES tblDetalleDescuentos (ntraDescuento,flag);
GO


--TABLA DE DETALLE DE PRESENTACION


IF OBJECT_ID(N'dbo.tblDetallePresentacion', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblDetallePresentacion]
(
[codProducto] [varchar] (10) NOT NULL,
[codPresentancion] [int] NOT NULL,
[cantidadUnidadBase]  [int] NOT NULL,
[marcaBaja]    [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso]  [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario]      [varchar](20) NOT NULL,
[ip]           [varchar](20) NULL,
[mac]          [varchar](20) NULL,
CONSTRAINT pk_tblDetallePresentacion PRIMARY KEY (codProducto,codPresentancion)
);
END

ALTER TABLE tblDetallePresentacion ADD CONSTRAINT fk_codproducto_detalle_pres FOREIGN KEY (codProducto) REFERENCES tblProducto (codProducto);
GO



--TABLA DE PUNTO DE ENTREAGA


IF OBJECT_ID(N'dbo.tblPuntoEntrega', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblPuntoEntrega]
(
[ntraPuntoEntrega] [int] IDENTITY (1,1) NOT NULL,
[codPersona] [int] NOT NULL,
[coordenadaX] [varchar](100) NOT NULL,
[coordenadaY] [varchar](100) NOT NULL,
[codUbigeo] [varchar](6) NOT NULL,
[direccion] [varchar](200) NOT NULL,
[referencia] [varchar](200) NULL,
[ordenEntrega]  [smallint] NULL,
[marcaBaja]    [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso]  [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario]      [varchar](20) NOT NULL,
[ip]           [varchar](20) NULL,
[mac]          [varchar](20) NULL,
CONSTRAINT pk_tblPuntoEntrega PRIMARY KEY (ntraPuntoEntrega)
);
END

ALTER TABLE tblPuntoEntrega ADD CONSTRAINT fk_codpersona_codcliente FOREIGN KEY (codPersona) REFERENCES tblCliente (codPersona);
GO

IF OBJECT_ID(N'dbo.tblPreventa', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblPreventa]
(
[ntraPreventa] [int] IDENTITY (1,1) NOT NULL,
[codCliente] [int] NOT NULL,
[codUsuario] [int] NOT NULL,
[codPuntoEntrega] [int] NOT NULL,
[codSucursal] [int] NULL,
[tipoMoneda] [tinyint] NULL,
[tipoVenta] [tinyint] NULL,
[origenVenta] [tinyint] NULL,
[tipoDocumentoVenta] [tinyint] NULL,
[fecha] [date] NULL,
[fechaRegistroServidor] [date] NULL DEFAULT GETDATE(),
[fechaEntrega] [date] NULL,
[horaEntrega]  [time] (0) NULL,
[fechaPago] [date] NULL,
[flagRecargo] [tinyint] NULL,
[recargo] [money] NULL,
[igv] [money] NULL,
[isc] [money] NULL,
[total] [money] NULL,
[estado] [tinyint] NULL,
[marcaBaja]    [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso]  [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario]      [varchar](20) NOT NULL,
[ip]           [varchar](20) NULL,
[mac]          [varchar](20) NULL,
CONSTRAINT pk_tblPreventa PRIMARY KEY (ntraPreventa)
);
END

ALTER TABLE tblPreventa ADD CONSTRAINT fk_tblPreventa_codSucursal FOREIGN KEY (codSucursal) REFERENCES tblSucursal (ntraSucursal);
ALTER TABLE tblPreventa ADD CONSTRAINT fk_tblPreventa_codcliente FOREIGN KEY (codCliente) REFERENCES tblCliente (codPersona);
ALTER TABLE tblPreventa ADD CONSTRAINT fk_tblPreventa_codUsuario FOREIGN KEY (codUsuario) REFERENCES tblUsuario (ntraUsuario);
ALTER TABLE tblPreventa ADD CONSTRAINT fk_tblPreventa_codPuntoEntrega FOREIGN KEY (codPuntoEntrega) REFERENCES tblPuntoEntrega (ntraPuntoEntrega);
GO



IF OBJECT_ID(N'dbo.tblDetallePreventa', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblDetallePreventa]
(
[codPreventa] [int] NOT NULL,
[itemPreventa] [tinyint] NOT NULL,
[codPresentacion] [int] NOT NULL,
[codProducto] [varchar](10) NOT NULL,
[codAlmacen] [int] NULL,
[cantidadPresentacion] [int] NULL,
[cantidadUnidadBase] [int] NULL,
[precioVenta] [money] NULL,
[TipoProducto] [tinyint] NULL,
[marcaBaja]    [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso]  [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario]      [varchar](20) NOT NULL,
[ip]           [varchar](20) NULL,
[mac]          [varchar](20) NULL,
CONSTRAINT pk_tblDetallePreventa PRIMARY KEY (codPreventa,itemPreventa)
);
END

ALTER TABLE tblDetallePreventa ADD CONSTRAINT fk_tblDetPreventa_codPreventa FOREIGN KEY (codPreventa) REFERENCES tblPreventa (ntraPreventa);
ALTER TABLE tblDetallePreventa ADD CONSTRAINT fk_tblDetPreventa_presentacion FOREIGN KEY (codProducto,codPresentacion) REFERENCES tblDetallePresentacion (codProducto,codPresentancion);
GO


IF OBJECT_ID(N'dbo.tblPreventaPromocion', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblPreventaPromocion]
(
[codPreventa] [int] NOT NULL,
[codPromocion] [int] NOT NULL,
[itemPreventa] [tinyint] NOT NULL,
[itemPromocionado] [tinyint] NOT NULL,
[marcaBaja]    [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso]  [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario]      [varchar](20) NOT NULL,
[ip]           [varchar](20) NULL,
[mac]          [varchar](20) NULL,
CONSTRAINT pk_tblPreventaPromocion PRIMARY KEY (codPreventa,codPromocion,itemPreventa,itemPromocionado)
);
END

ALTER TABLE tblPreventaPromocion ADD CONSTRAINT fk_tblPreventaPromocion_DetPreventa FOREIGN KEY (codPreventa,itemPreventa) REFERENCES tblDetallePreventa (codPreventa,itemPreventa);
ALTER TABLE tblPreventaPromocion ADD CONSTRAINT fk_tblPreventaPromocion_Promocionado FOREIGN KEY (codPreventa,itemPromocionado) REFERENCES tblDetallePreventa (codPreventa,itemPreventa);
ALTER TABLE tblPreventaPromocion ADD CONSTRAINT fk_tblDetPreventa_promocion FOREIGN KEY (codPromocion) REFERENCES tblPromociones (ntraPromocion);
GO



IF OBJECT_ID(N'dbo.tblPreventaDescuento', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblPreventaDescuento]
(
[codPreventa] [int] NOT NULL,
[codDescuento] [int] NOT NULL,
[itemPreventa] [tinyint] NOT NULL,
[importe] [money] NULL,
[marcaBaja]    [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso]  [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario]      [varchar](20) NOT NULL,
[ip]           [varchar](20) NULL,
[mac]          [varchar](20) NULL,
CONSTRAINT pk_tblPreventaDescuento PRIMARY KEY (codPreventa,codDescuento,itemPreventa)
);
END

ALTER TABLE tblPreventaDescuento ADD CONSTRAINT fk_tblPreventaDescuento_DetPreventa FOREIGN KEY (codPreventa,itemPreventa) REFERENCES tblDetallePreventa (codPreventa,itemPreventa);
ALTER TABLE tblPreventaDescuento ADD CONSTRAINT fk_tblPreventaDescuento_descuento FOREIGN KEY (codDescuento) REFERENCES tblDescuentos (ntraDescuento);
GO


--TABLA DE PARAMETROS

IF OBJECT_ID(N'dbo.tblParametro', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblParametro]
(
[ntraParametro] [int] IDENTITY (1,1) NOT NULL,
[codigoParametro] [int] NOT NULL,
[descripcion] [varchar] (250) NULL,
[estado] [tinyint] NULL,
[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso] [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario] [varchar](20) NOT NULL,
[ip] [varchar](20) NULL,
[mac] [varchar](20) NULL,
CONSTRAINT pk_tblParametro PRIMARY KEY (ntraParametro)
);
END

IF OBJECT_ID(N'dbo.tblDetalleParametro', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblDetalleParametro]
(
[ntraDetParametro] [int] IDENTITY (1,1) NOT NULL,
[codParametro] [int] NOT NULL,
[tipo] [int] NULL,
[valorEntero1] [int] NULL,
[valorEntero2] [int] NULL,
[valorCaneda1] [varchar] (100) NULL,
[valorCaneda2] [varchar] (100) NULL,
[valorMoneda1] [money] NULL,
[valorMoneda2] [money] NULL,
[valorFloat1] [float] NULL,
[valorFloat2] [float] NULL,
[valorFecha1] [date] NULL,
[valorFecha2] [date] NULL,
[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso] [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario] [varchar](20) NOT NULL,
[ip] [varchar](20) NULL,
[mac] [varchar](20) NULL,
CONSTRAINT pk_tblDetalleParametro PRIMARY KEY (ntraDetParametro)
);
END


IF OBJECT_ID(N'dbo.tblConcepto', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblConcepto](
	[ntraConcepto] [int] IDENTITY(1,1) NOT NULL,
	[codConcepto] [int] NOT NULL,
	[correlativo] [int] NOT NULL,
	[descripcion] [varchar](250) NOT NULL,
	[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
	[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
	[horaProceso] [time] (0) NOT NULL DEFAULT SYSDATETIME(),
	[usuario] [varchar](20) NOT NULL,
	[ip] [varchar](20)  NULL,
	[mac] [varchar](20)  NULL,
	CONSTRAINT pk_tblConcepto PRIMARY KEY (ntraConcepto)
);
END


IF OBJECT_ID(N'dbo.tblPrecio', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblPrecio]
(
[ntraPrecio] [int] IDENTITY (1,1) NOT NULL,
[codProducto] [varchar](10) NOT NULL,
[tipoListaPrecio] [tinyint] NOT NULL,
[precioVenta] [money] NULL,
[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso] [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario] [varchar](20) NOT NULL,
[ip] [varchar](20) NULL,
[mac] [varchar](20) NULL,
CONSTRAINT pk_tblPrecio PRIMARY KEY (ntraPrecio,codProducto)
);
END

ALTER TABLE tblPrecio ADD CONSTRAINT fk_tblPrecio_Producto FOREIGN KEY (codProducto) REFERENCES tblProducto (codProducto);


IF OBJECT_ID(N'dbo.tblPerfil', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblPerfil](
	[codigo] [int] NOT NULL IDENTITY PRIMARY KEY,
	[descripcion] [varchar](100) NOT NULL,
	[estado] [tinyint] NULL,
	[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
	[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
	[horaProceso] [time](0) NOT NULL DEFAULT SYSDATETIME(),
	[usuario] [varchar](20) NULL,
	[ip] [varchar](20) NULL,
	[mac] [varchar](20) NULL
)
END

--TABLA DE LOCALIZACION

IF OBJECT_ID(N'dbo.tblLocalizacion', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblLocalizacion]
(
[codPersona] [int]  NOT NULL,
[coordenadaX] [varchar](100) NOT NULL,
[coordenadaY] [varchar] (100) NOT NULL,
[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso] [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario] [varchar](20) NOT NULL,
[ip] [varchar](20) NULL,
[mac] [varchar](20) NULL,
);
END
GO

--TABLA DE  VENTA
IF OBJECT_ID(N'dbo.tblVenta', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblVenta]
(
[ntraVenta] [int] IDENTITY (1,1) NOT NULL,
[serie] [varchar](20) NOT NULL,
[nroDocumento]	[int] NOT NULL,
[tipoPago]		[smallint] NOT NULL,
[tipoDocumentoVenta]	[tinyint] NOT NULL,
[codPreventa]	[int] NOT NULL,
[codSucursal] [int] NOT NULL,
[codCliente]	[int] NOT NULL,
[codVendedor]	[int] NOT NULL,
[fechaTransaccion] 	[date] NOT NULL,
[tipoVenta]		[smallint] NOT NULL,
[tipoMoneda]		[smallint] NOT NULL,
[tipoCambio]		[money] NOT NULL,
[IGV] 				[money] 	NULL,
[isc] [money] NULL,
[estado]			[smallint] NOT NULL,
[importeTotal]		[money] NOT NULL,
[importeRecargo]	[money] NULL,
[codPuntoEntrega]	[int] NOT NULL,
[fechaPago] 	[date] NOT NULL,
[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso] [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario] [varchar](20) NOT NULL,
[ip] [varchar](20) NULL,
[mac] [varchar](20) NULL,
CONSTRAINT pk_ntraVenta PRIMARY KEY (ntraVenta)

);
END

ALTER TABLE tblVenta ADD CONSTRAINT fk_tblVenta_codPuntoEntrega FOREIGN KEY (codPuntoEntrega) REFERENCES tblPuntoEntrega (ntraPuntoEntrega);
ALTER TABLE tblVenta ADD CONSTRAINT fk_tblVenta_codCliente FOREIGN KEY (codCliente) REFERENCES tblCliente (codPersona);
ALTER TABLE tblVenta ADD CONSTRAINT fk_tblVenta_codVendedor FOREIGN KEY (codVendedor) REFERENCES tblUsuario (ntraUsuario);
ALTER TABLE tblVenta ADD CONSTRAINT fk_tblVenta_codSucursal FOREIGN KEY (codSucursal) REFERENCES tblSucursal (ntraSucursal);

--TABLA DE PRESTAMO
IF OBJECT_ID(N'dbo.tblPrestamo', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblPrestamo]
(
[ntraPrestamo] [int] IDENTITY (1,1) NOT NULL,
[codVenta] 		[int] NOT NULL,
[importeTotal]	[money] NOT NULL,
[interesTotal]	[money] NULL,
[plazo]	[int] NULL,
[nroCuotas]	[int] NOT NULL,
[fechaTransaccion]	[datetime] NOT NULL,
[tipoPrestamo] 	[smallint] NOT NULL,
[estado] 		[smallint] NOT NULL,
[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso] [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario] [varchar](20) NOT NULL,
[ip] [varchar](20) NULL,
[mac] [varchar](20) NULL,
CONSTRAINT pk_ntraPrestamo PRIMARY KEY (ntraPrestamo)
);
END

ALTER TABLE tblPrestamo ADD CONSTRAINT fk_tblPrestamo_codVenta FOREIGN KEY (codVenta) REFERENCES tblVenta (ntraVenta);

--TABLA DE CRONOGRAMA
IF OBJECT_ID(N'dbo.tblCronograma', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblCronograma]
(
[codPrestamo] [int]  NOT NULL,
[fechaPago] 		[date] NOT NULL,
[nroCuota]	[int] NOT NULL,
[importe]		[money] NOT NULL,
[estado]	[int] NOT NULL,
[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso] [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario] [varchar](20) NOT NULL,
[ip] [varchar](20) NULL,
[mac] [varchar](20) NULL,
CONSTRAINT pk_ntraPrestamo_nroCuota PRIMARY KEY (codPrestamo,nroCuota)
);
END
ALTER TABLE tblCronograma ADD CONSTRAINT fk_tblCronograma_codPrestamo FOREIGN KEY (codPrestamo) REFERENCES tblPrestamo (ntraPrestamo);

--TABLA DE TRANSACCIONES DE PAGO
IF OBJECT_ID(N'dbo.tblTranssaccionesPago', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblTranssaccionesPago]
(
[ntraTransaccionPago] [int]  IDENTITY (1,1) NOT NULL,
[codPrestamo] 		[int] NULL,
[nroCuota]	[int]  NULL,
[codVenta]		[int] NOT NULL,
[ntraMedioPago]	[tinyint] NOT NULL,
[tipoCambio]		[money] NOT NULL,
[tipoMoneda]		[smallint] NOT NULL,
[IGV] 				[money] 	NULL,
[estado]			[tinyint] NOT NULL,
[fechaTransaccion] 	[date] NOT NULL,
[horaTransaccion] [time] (0) NOT NULL ,
[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso] [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario] [varchar](20) NOT NULL,
[ip] [varchar](20) NULL,
[mac] [varchar](20) NULL,
CONSTRAINT pk_ntraTransaccionPago PRIMARY KEY (ntraTransaccionPago)
);
END

--TABLA DE MEDIO DE PAGO
IF OBJECT_ID(N'dbo.tblMediosDePago', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblMediosDePago]
(
[ntraMedioPago] [int]  IDENTITY (1,1) NOT NULL,	
[descripcion] 		[varchar](50) NOT NULL,
[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso] [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario] [varchar](20) NOT NULL,
[ip] [varchar](20) NULL,
[mac] [varchar](20) NULL,
CONSTRAINT pk_ntraMedioPago PRIMARY KEY (ntraMedioPago)
);
END

--TABLA DE PAGO EFECTIVO
IF OBJECT_ID(N'dbo.tblPagoEfectivo', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblPagoEfectivo]
(
[ntraTransaccionPago] [int] NOT NULL,	
[importe] 		[money] NOT NULL,
[vuelto] 		[money] NOT NULL,
[tipoMoneda] 	[tinyint] NOT NULL,	
[estado]		[tinyint] NOT NULL,
[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso] [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario] [varchar](20) NOT NULL,
[ip] [varchar](20) NULL,
[mac] [varchar](20) NULL,
CONSTRAINT pk_ntraTransaccionPago_Efectivo PRIMARY KEY (ntraTransaccionPago)
);
END

--TABLA DE PAGO TRANSFERENCIA
IF OBJECT_ID(N'dbo.tblPagoTransferencia', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblPagoTransferencia]
(
[ntraTransaccionPago] [int] NOT NULL,
[nroTransferencia] [VARCHAR](50) NULL,
[cuentaTransferencia] [varchar](100) NULL,
[banco] [varchar](100) NULL,	
[importe] 		[money] NOT NULL,
[tipoMoneda] 	[tinyint] NOT NULL,	
[fechaTransferencia] date NOT NULL,
[estado]		[tinyint] NOT NULL,
[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso] [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario] [varchar](20) NOT NULL,
[ip] [varchar](20) NULL,
[mac] [varchar](20) NULL,
CONSTRAINT pk_ntraTransaccionPago_Transferencia PRIMARY KEY (ntraTransaccionPago)
);
END

--TABLA DE ABASTECIMIENTO
IF OBJECT_ID(N'dbo.tblAbastecimento', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblAbastecimento](
	[nroAbast] [int] IDENTITY(1,1) NOT NULL,
	[codProveedor] [int] NOT NULL,
	[codProducto] [varchar](10) NOT NULL,
	[estado]      [tinyint]  NOT NULL,
	[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
	[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
	[horaProceso] [time](7) NOT NULL DEFAULT SYSDATETIME(),
	[usuario] [varchar](20) NOT NULL,
	[ip] [varchar](20) NULL,
	[mac] [varchar](20) NULL,
CONSTRAINT pk_tblAbastecimento PRIMARY KEY (nroAbast)
);
END
ALTER TABLE tblAbastecimento ADD CONSTRAINT fk_tblAbastecimento_codProveedor FOREIGN KEY (codProveedor) REFERENCES tblProveedor (ntraProveedor);
ALTER TABLE tblAbastecimento ADD CONSTRAINT fk_tblAbastecimento_codProducto FOREIGN KEY (codProducto) REFERENCES tblProducto (codProducto);


IF OBJECT_ID(N'dbo.tblParametrosGenerales', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblParametrosGenerales]
(
[ntraParametrosGenerales] [int] IDENTITY (1,1) NOT NULL,
[codSucursal] [INT] NOT NULL,
[tipoCambio] [MONEY] NOT NULL,
[igv] [MONEY] NOT NULL,
[marcaBaja]    [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso]  [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario]      [varchar](20) NOT NULL,
[ip]           [varchar](20) NULL,
[mac]          [varchar](20) NULL,
CONSTRAINT pk_tblParametrosGenerales PRIMARY KEY (ntraParametrosGenerales)
);
END
ALTER TABLE tblParametrosGenerales ADD CONSTRAINT fk_tblParametrosGenerales_codSucursal FOREIGN KEY (codSucursal) 
REFERENCES tblSucursal (ntraSucursal);
GO

IF OBJECT_ID(N'dbo.tblVentasAnuladas', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblVentasAnuladas]
(
[ntraVentaAnulada] [int] IDENTITY (1,1) NOT NULL,
[codVenta] [INT] NOT NULL,
[fecha] [date] NOT NULL,
[marcaBaja]    [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso]  [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario]      [varchar](20) NOT NULL,
[ip]           [varchar](20) NULL,
[mac]          [varchar](20) NULL,
CONSTRAINT pk_tblVentasAnuladas PRIMARY KEY (ntraVentaAnulada)
);
END
ALTER TABLE tblVentasAnuladas ADD CONSTRAINT fk_tblVentasAnuladas_codVenta FOREIGN KEY (codVenta) 
REFERENCES tblVenta (ntraVenta);
GO

IF OBJECT_ID(N'dbo.tblMotivoNotaCredito', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblMotivoNotaCredito]
(
[codigoMotivo] [char](2) NOT NULL,
[descripcion]  [varchar](200) NOT NULL,
[marcaBaja]    [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso]  [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario]      [varchar](20) NOT NULL,
[ip]           [varchar](20) NULL,
[mac]          [varchar](20) NULL,
CONSTRAINT pk_tblMotivoNotaCredito PRIMARY KEY (codigoMotivo)
);
END
GO

IF OBJECT_ID(N'dbo.tblNotaCredito', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblNotaCredito]
(
[ntraNotaCredito] [int] IDENTITY (1,1) NOT NULL,
[serie]        [varchar](20) NOT NULL,
[numero]       [int] NOT NULL,
[codSucursal]  [int] NOT NULL,
[codVenta]     [int] NOT NULL,
[codVentaNega] [int] NOT NULL,
[codMotivo]    [char](2) NOT NULL,
[codUsuario]   [int] NOT NULL,
[fecha]        [date] NOT NULL,
[tipo]         [tinyint] NOT NULL,
[importe]      [money] NOT NULL,
[tipoCambio]   [money] NOT NULL,
[estado]       [tinyint] NOT NULL,
[marcaBaja]    [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso]  [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario]      [varchar](20) NOT NULL,
[ip]           [varchar](20) NULL,
[mac]          [varchar](20) NULL,
CONSTRAINT pk_tblNotaCredito PRIMARY KEY (ntraNotaCredito)
);
END

ALTER TABLE tblNotaCredito ADD CONSTRAINT fk_tblNotaCredito_codSucursal FOREIGN KEY (codSucursal) REFERENCES tblSucursal (ntraSucursal);
ALTER TABLE tblNotaCredito ADD CONSTRAINT fk_tblNotaCredito_codVenta FOREIGN KEY (codVenta) REFERENCES tblVenta (ntraVenta);
ALTER TABLE tblNotaCredito ADD CONSTRAINT fk_tblNotaCredito_codVentaNega FOREIGN KEY (codVentaNega) REFERENCES tblVenta (ntraVenta);
ALTER TABLE tblNotaCredito ADD CONSTRAINT fk_tblNotaCredito_codMotivo FOREIGN KEY (codMotivo) REFERENCES tblMotivoNotaCredito (codigoMotivo);
ALTER TABLE tblNotaCredito ADD CONSTRAINT fk_tblNotaCredito_codUsuario FOREIGN KEY (codUsuario) REFERENCES tblUsuario (ntraUsuario);
GO

IF OBJECT_ID(N'dbo.tblCuentaCorriente', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblCuentaCorriente]
(
[ntraCuentaCorriente] [int] IDENTITY (1,1) NOT NULL,
[codPersona] [int] NOT NULL,
[saldoTotal] [money] NOT NULL,
[marcaBaja]    [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso]  [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario]      [varchar](20) NOT NULL,
[ip]           [varchar](20) NULL,
[mac]          [varchar](20) NULL,
CONSTRAINT pk_tblCuentaCorriente PRIMARY KEY (ntraCuentaCorriente)
);
END

ALTER TABLE tblCuentaCorriente ADD CONSTRAINT fk_tblCuentaCorriente_cliente FOREIGN KEY (codPersona) REFERENCES tblCliente (codPersona);
GO

IF OBJECT_ID(N'dbo.tblDetalleCuentaCorriente', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblDetalleCuentaCorriente]
(
[ntraDetalleCuentaCorriente] [int] IDENTITY (1,1) NOT NULL,
[codCuentaCorriente] [int] NOT NULL,
[codOperacion] [int] NOT NULL,
[codModulo] [smallint] NOT NULL,
[prefijo] [int] NOT NULL,
[correlativo] [int] NOT NULL,
[importe] [money] NOT NULL,
[marcaBaja]    [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso]  [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario]      [varchar](20) NOT NULL,
[ip]           [varchar](20) NULL,
[mac]          [varchar](20) NULL,
CONSTRAINT pk_DetalleCuentaCorriente PRIMARY KEY (ntraDetalleCuentaCorriente)
);
END

ALTER TABLE tblDetalleCuentaCorriente ADD CONSTRAINT fk_tblDetalleCuentaCorriente_codCuentaCorriente FOREIGN KEY (codCuentaCorriente) 
REFERENCES tblCuentaCorriente (ntraCuentaCorriente);
GO


IF OBJECT_ID(N'dbo.tblLogueoUsu', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblLogueoUsu]
(
[ntraLogueo] [bigint] IDENTITY (1,1) NOT NULL,
[codUsuario] [int] NOT NULL,
[FechaIngreso] [datetime] NULL,
[FechaSalida] [datetime] NULL,
[tipoLogueo]  [smallint] NULL,
[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso] [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario] [varchar](20) NOT NULL,
[ip] [varchar](20) NULL,
[mac] [varchar](20) NULL,
CONSTRAINT pk_tblLogueoUsu PRIMARY KEY (ntraLogueo)
);
END

ALTER TABLE tblLogueoUsu ADD CONSTRAINT fk_tblLogueoUsu_codUsuario FOREIGN KEY (codUsuario) REFERENCES tblUsuario (ntraUsuario);
GO 

IF OBJECT_ID(N'dbo.tblLoginFallido', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblLoginFallido]
(
[codUsuario] [int] NOT NULL,
[cantFallido] [smallint] NULL,
[FechaRegistro] [datetime] NULL,
[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso] [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario] [varchar](20) NOT NULL,
[ip] [varchar](20) NULL,
[mac] [varchar](20) NULL
);
END

ALTER TABLE tblLoginFallido ADD CONSTRAINT pk_tblLoginFallido PRIMARY KEY (codUsuario) ;
GO 


IF OBJECT_ID(N'dbo.tblSUNAT', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblSUNAT]
(
[RUC] [bigint] NOT NULL,
	[razonSocial] [varchar](250) NULL,
	[estCont] [varchar](20) NULL,
	[condDom] [varchar](20) NULL,
	[ubigeo] [char](6) NULL,
	[tipVia] [varchar](50) NULL,
	[nomVia] [varchar](250) NULL,
	[codZona] [varchar](50) NULL,
	[nomZona] [varchar](250) NULL,
	[numero] [varchar](10) NULL,
	[interior] [varchar](10) NULL,
	[lote] [varchar](50) NULL,
	[departamento] [varchar](50) NULL,
	[manzana] [varchar](50) NULL,
	[kilometro] [varchar](50) NULL,
CONSTRAINT pk_tblSUNAT PRIMARY KEY (RUC)
);
END

IF OBJECT_ID(N'dbo.tblCuentaCobro', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblCuentaCobro]
(
[ntra] [int] IDENTITY (1,1) NOT NULL, -- numero de transaccion
[codOperacion] [int] NOT NULL, -- codigo de venta
[codModulo] [smallint] NULL, -- codigo de modulo
[prefijo] [int] NULL, -- prefijo
[correlativo] [int] NULL, -- correlativo
[importe]	[money] NULL, -- importe
[fechaTransaccion] 	[date] NOT NULL, -- fecha de transaccion
[horaTransaccion] [time] (0) NOT NULL , -- hora de transaccion
[fechaCobro] 	[date] NOT NULL, -- fecha de cobro
[estado] [smallint] NULL, -- estado
[responsable] [varchar](250) NULL, -- Responsable
[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso] [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario] [varchar](20) NOT NULL,
[ip] [varchar](20) NULL,
[mac] [varchar](20) NULL,
CONSTRAINT pk_tblCuentaCobro PRIMARY KEY (ntra)
);
END

IF OBJECT_ID(N'dbo.tblSerieVenta', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblSerieVenta]
(
[ntra] [int] IDENTITY (1,1) NOT NULL, -- numero de transaccion
[codSucursal] [int] NOT NULL, -- codigo de sucursal
-- boleta
[correlativoB] [int] NULL, -- correlativo
[inicialB] [int] NULL, -- inicial
[finalB] [int] NULL, -- final
[serieB]	[varchar](10) NULL, -- serie
-- factura
[correlativoF] [int] NULL, -- correlativo
[inicialF] [int] NULL, -- inicial
[finalF] [int] NULL, -- final
[serieF]	[varchar](10) NULL, -- serie
-- ticket
[correlativoT] [int] NULL, -- correlativo
[inicialT] [int] NULL, -- inicial
[finalT] [int] NULL, -- final
[serieT]	[varchar](10) NULL, -- serie

-- nota credito
[correlativoNC] [int] NULL, -- correlativo
[inicialNC] [int] NULL, -- inicial
[finalNC] [int] NULL, -- final
[serieNC]	[varchar](10) NULL, -- serie

[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso] [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario] [varchar](20) NOT NULL,
[ip] [varchar](20) NULL,
[mac] [varchar](20) NULL,
CONSTRAINT pk_tblSerieVenta PRIMARY KEY (ntra)
);
END

ALTER TABLE tblSerieVenta ADD CONSTRAINT fk_codSucursal_ntraSucursal FOREIGN KEY (codSucursal) REFERENCES tblSucursal (ntraSucursal);
GO 

-- Detalle de la venta

IF OBJECT_ID(N'dbo.tblDetalleVenta', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblDetalleVenta]
(
[codVenta] [int] NOT NULL,
[itemVenta] [tinyint] NOT NULL,
[codPresentacion] [int] NOT NULL,
[codProducto] [varchar](10) NOT NULL,
[codAlmacen] [int] NULL,
[cantidadPresentacion] [int] NULL,
[cantidadUnidadBase] [int] NULL,
[precioVenta] [money] NULL,
[TipoProducto] [tinyint] NULL,
[cantDespachada] [int] NOT NULL DEFAULT 0,
[cantDevReparto] [int] NOT NULL DEFAULT 0,
[cantDevNC] [int] NOT NULL DEFAULT 0,
[marcaBaja]    [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso]  [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario]      [varchar](20) NOT NULL,
[ip]           [varchar](20) NULL,
[mac]          [varchar](20) NULL,
CONSTRAINT pk_tblDetalleVenta PRIMARY KEY (codVenta,itemVenta)
);
END

ALTER TABLE tblDetalleVenta ADD CONSTRAINT fk_tblDetalleVenta_codVenta FOREIGN KEY (codVenta) REFERENCES tblVenta (ntraVenta);
ALTER TABLE tblDetalleVenta ADD CONSTRAINT fk_tblDetalleVenta_presentacion FOREIGN KEY (codProducto,codPresentacion) REFERENCES tblDetallePresentacion (codProducto,codPresentancion);
GO


IF OBJECT_ID(N'dbo.tblVentaPromocion', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblVentaPromocion]
(
[codVenta] [int] NOT NULL,
[codPromocion] [int] NOT NULL,
[itemVenta] [tinyint] NOT NULL,
[itemPromocionado] [tinyint] NOT NULL,
[marcaBaja]    [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso]  [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario]      [varchar](20) NOT NULL,
[ip]           [varchar](20) NULL,
[mac]          [varchar](20) NULL,
CONSTRAINT pk_tblVentaPromocion PRIMARY KEY (codVenta,codPromocion,itemVenta,itemPromocionado)
);
END

ALTER TABLE tblVentaPromocion ADD CONSTRAINT fk_tblVentaPromocion_DetPreventa FOREIGN KEY (codVenta,itemVenta) REFERENCES tblDetalleVenta (codVenta,itemVenta);
-- ALTER TABLE tblVentaPromocion ADD CONSTRAINT fk_tblVentaPromocion_Promocionado FOREIGN KEY (codVenta,itemPromocionado) REFERENCES tblDetalleVenta (codVenta,itemVenta);
ALTER TABLE tblVentaPromocion ADD CONSTRAINT fk_tblVentaPromocion_promocion FOREIGN KEY (codPromocion) REFERENCES tblPromociones (ntraPromocion);
GO



IF OBJECT_ID(N'dbo.tblVentaDescuento', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblVentaDescuento]
(
[codVenta] [int] NOT NULL,
[codDescuento] [int] NOT NULL,
[itemVenta] [tinyint] NOT NULL,
[importe] [money] NULL,
[marcaBaja]    [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso]  [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario]      [varchar](20) NOT NULL,
[ip]           [varchar](20) NULL,
[mac]          [varchar](20) NULL,
CONSTRAINT pk_tblVentaDescuento PRIMARY KEY (codVenta,codDescuento,itemVenta)
);
END

ALTER TABLE tblVentaDescuento ADD CONSTRAINT fk_tblVentaDescuento_DetVenta FOREIGN KEY (codVenta,itemVenta) REFERENCES tblDetalleVenta (codVenta,itemVenta);
ALTER TABLE tblVentaDescuento ADD CONSTRAINT fk_tblVentaDescuento_descuento FOREIGN KEY (codDescuento) REFERENCES tblDescuentos (ntraDescuento);
GO

IF OBJECT_ID(N'dbo.tblMeta', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblMeta](
	[codMeta] [int] IDENTITY(1,1) NOT NULL,
	[descripcion] [varchar](250) NOT NULL,
	[fechaInicio] [date] NOT NULL,
	[fechaFin] [date] NOT NULL,
	[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
	[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
	[horaProceso] [time](7) NOT NULL DEFAULT SYSDATETIME(),
	[usuario] [varchar](20) NOT NULL,
	[ip] [varchar](20) NULL,
	[mac] [varchar](20) NULL,
 CONSTRAINT pk_tblMeta PRIMARY KEY (codMeta)
);
END
GO

IF OBJECT_ID(N'dbo.tblObjetivo', N'U') IS NULL
BEGIN

CREATE TABLE [dbo].[tblObjetivo](
	[codObjetivo] [int] IDENTITY(1,1) NOT NULL,
	[descripcion] [varchar](250) NOT NULL,
	[tipoIndicador] [smallint] NOT NULL,
	[indicador] [smallint] NOT NULL,
	[valorIndicador] [decimal](10,2) NOT NULL,
	[perfil] [smallint] NOT NULL,
	[trabajador] [int] NOT NULL,
	[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
	[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
	[horaProceso] [time](7) NOT NULL DEFAULT SYSDATETIME(),
	[usuario] [varchar](20) NOT NULL,
	[ip] [varchar](20) NULL,
	[mac] [varchar](20) NULL,
	CONSTRAINT PK_tblObjetivo PRIMARY KEY (codObjetivo)
);
END
GO

IF OBJECT_ID(N'dbo.tblDetalleMetaObjetivos', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblDetalleMetaObjetivos](
	[codMeta] [int] NOT NULL,
	[codObjetivo] [int] NOT NULL,
	[flag] [int] NOT NULL,
	[valorInicio] [VARCHAR] (100) NULL,
	[valorfinal] [VARCHAR] (100) NULL,
	[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
	[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
	[horaProceso] [time](7) NOT NULL DEFAULT SYSDATETIME(),
	[usuario] [varchar](20) NOT NULL,
	[ip] [varchar](20) NULL,
	[mac] [varchar](20) NULL 
);
END
--ALTER TABLE tblDetalleMetaObjetivos ADD CONSTRAINT fk_Det_codMetaObjetivo FOREIGN KEY (codMeta,codObjetivo) REFERENCES tblObjetivo (codMeta, codObjetivo);
GO

IF OBJECT_ID(N'dbo.tblTrabajador', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblTrabajador]
(
[codPersona] [int] NOT NULL,
[asignacionFamilia] [smallint] NULL,
[area] [smallint] NOT NULL,
[estadoTrabajador] [smallint] NULL,
[tipoTrabajador] [smallint] NOT NULL,
[cargo] [smallint] NOT NULL,
[formaPago] [smallint] NOT NULL,
[numeroCuenta] [varchar](16) NOT NULL,
[tipoRegimen] [smallint] NULL,
[regimenPensionario] [smallint] NULL,
[incioRegimen] [date] NOT NULL,
[bancoRemuneracion] [smallint] NOT NULL,
[estadoPlanilla] [smallint] NULL,
[modalidadContrato] [smallint] NOT NULL,
[periodicidad] [smallint] NULL,
[inicioContrato] [date] NOT NULL,
[finContrato] [date] NOT NULL,
[fechaIngreso] [date] NOT NULL,
[sueldo] [money] NULL,
[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso] [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario] [varchar](20) NOT NULL,
[ip] [varchar](20) NULL,
[mac] [varchar](20) NULL,
CONSTRAINT pk_tblTrabajador PRIMARY KEY (codPersona)
);
END

ALTER TABLE tblTrabajador ADD CONSTRAINT fk_tblTrabajador_codPersona FOREIGN KEY (codPersona) REFERENCES tblPersona(codPersona);
GO

-- TABLA TIPO DE MOVIMIENTO DE CAJA
IF OBJECT_ID(N'dbo.tblTipoMovimiento', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblTipoMovimiento]
(
[ntraTipoMovimiento] [int] IDENTITY (1,1) NOT NULL,
[tipoRegistro] [tinyint] NOT NULL,
[descripcion] [varchar](250) NOT NULL,
[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso] [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario] [varchar](20) NOT NULL,
[ip] [varchar](20) NULL,
[mac] [varchar](20) NULL,
CONSTRAINT pk_tblTipoMovimiento PRIMARY KEY (ntraTipoMovimiento)
);
END
GO

-- TABLA CAJA
IF OBJECT_ID(N'dbo.tblCaja', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblCaja]
(
[ntraCaja] [int] IDENTITY (1,1) NOT NULL,
[descripcion] [varchar](100) NOT NULL,
[ntraUsuario] [int] NOT NULL,
[ntraSucursal] [int] NOT NULL,
[fechaCreacion] [date] NOT NULL DEFAULT GETDATE(),
[horaCreacion] [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[estado] [tinyint] NOT NULL DEFAULT 2,
[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso] [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario] [varchar](20) NOT NULL,
[ip] [varchar](20) NULL,
[mac] [varchar](20) NULL,
CONSTRAINT pk_tblCaja PRIMARY KEY (ntraCaja)
);
END
GO

-- TABLA TIPO DE MOVIIENTO ASIGNADO A CAJA
IF OBJECT_ID(N'dbo.tblTipoMovimientoCaja', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblTipoMovimientoCaja]
(
[ntraCaja] [int] NOT NULL,
[ntraTipoMovimiento] [int] NOT NULL,
[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso] [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario] [varchar](20) NOT NULL,
[ip] [varchar](20) NULL,
[mac] [varchar](20) NULL,
CONSTRAINT pk_tblTipoMovimientoCaja PRIMARY KEY (ntraCaja, ntraTipoMovimiento)
);
END
GO

ALTER TABLE tblTipoMovimientoCaja ADD CONSTRAINT fk_ntraCaja_tblTipoMovimientoCaja FOREIGN KEY (ntraCaja) REFERENCES tblCaja (ntraCaja);
GO

ALTER TABLE tblTipoMovimientoCaja ADD CONSTRAINT fk_ntraTipoMovimiento_tblTipoMovimientoCaja FOREIGN KEY (ntraTipoMovimiento) REFERENCES tblTipoMovimiento (ntraTipoMovimiento);
GO

-- TABLA APERTURA DE CAJA
IF OBJECT_ID(N'dbo.tblAperturaCaja', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblAperturaCaja]
(
[ntraAperturaCaja] [int] IDENTITY (1,1) NOT NULL,
[ntraCaja] [int] NOT NULL,
[fecha] [date] NOT NULL DEFAULT GETDATE(),
[hora] [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[saldoSoles] [money] NOT NULL,
[saldoDolares] [money] NOT NULL,
[estado] [tinyint] NOT NULL DEFAULT 1,
[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso] [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario] [varchar](20) NOT NULL,
[ip] [varchar](20) NULL,
[mac] [varchar](20) NULL,
CONSTRAINT pk_tblAperturaCaja PRIMARY KEY (ntraAperturaCaja)
);
END
GO

ALTER TABLE tblAperturaCaja ADD CONSTRAINT fk_ntraCaja_tblAperturaCaja FOREIGN KEY (ntraCaja) REFERENCES tblCaja (ntraCaja);
GO

-- TABLA CIERRE DE CAJA
IF OBJECT_ID(N'dbo.tblCierreCaja', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblCierreCaja]
(
[ntraCierreCaja] [int] IDENTITY (1,1) NOT NULL,
[ntraCaja] [int] NOT NULL,
[fecha] [date] NOT NULL,
[hora] [time] (0) NOT NULL,
[saldoSoles] [money] NOT NULL,
[saldoDolares] [money] NOT NULL,
[saldoSolesCierre] [money] NOT NULL,
[saldoDolaresCierre] [money] NOT NULL,
[difSaldoSoles] [money] NOT NULL,
[difSaldoDolares] [money] NOT NULL,
[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso] [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario] [varchar](20) NOT NULL,
[ip] [varchar](20) NULL,
[mac] [varchar](20) NULL,
CONSTRAINT pk_tblCierreCaja PRIMARY KEY (ntraCierreCaja)
);
END
GO

ALTER TABLE tblCierreCaja ADD CONSTRAINT fk_ntraCaja_tblCierreCaja FOREIGN KEY (ntraCaja) REFERENCES tblCaja (ntraCaja);
GO

-- TABLA TRANSACCION DE CAJA
IF OBJECT_ID(N'dbo.tblTransaccionCaja', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblTransaccionCaja]
(
[ntraTransaccionCaja] [int] IDENTITY (1,1) NOT NULL,
[ntraCaja] [int] NOT NULL,
[ntraTipoMovimiento] [int] NOT NULL,
[codVenta] [int],
[fechaTransaccion] [date] NOT NULL,
[horaTransaccion] [time] (0) NOT NULL,
[tipoTransaccion] [tinyint] NOT NULL,
[modoPago] [tinyint] NOT NULL,
[tipoMoneda] [tinyint] NOT NULL,
[importe] [money] NOT NULL,
[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso] [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario] [varchar](20) NOT NULL,
[ip] [varchar](20) NULL,
[mac] [varchar](20) NULL,
CONSTRAINT pk_tblTransaccionCaja PRIMARY KEY (ntraTransaccionCaja)
);
END
GO

ALTER TABLE tblTransaccionCaja ADD CONSTRAINT fk_ntraCaja_tblTransaccionCaja FOREIGN KEY (ntraCaja) REFERENCES tblCaja (ntraCaja);
GO

ALTER TABLE tblTransaccionCaja ADD CONSTRAINT fk_ntraTipoMovimiento_tblTransaccionCaja FOREIGN KEY (ntraTipoMovimiento) REFERENCES tblTipoMovimiento (ntraTipoMovimiento);
GO

ALTER TABLE tblTransaccionCaja ADD CONSTRAINT fk_codVenta_tblTransaccionCaja FOREIGN KEY (codVenta) REFERENCES tblVenta (ntraVenta);
GO


IF OBJECT_ID(N'dbo.tblEmpresa', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblEmpresa]
(
[ntraEmpresa] [INT] NOT NULL,
[razonSocial] [VARCHAR](250) NOT NULL,
[ruc] [VARCHAR](11) NOT NULL,
[direccion] [VARCHAR](250) NOT NULL,
[ubigeo] [VARCHAR](6),
[email] [VARCHAR](150),
[telefono] [VARCHAR](15),
[marcaBaja]    [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso]  [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario]      [varchar](20) NOT NULL,
[ip]           [varchar](20) NULL,
[mac]          [varchar](20) NULL,
CONSTRAINT pk_tblEmpresa PRIMARY KEY (ntraEmpresa)
);
END
GO

--TABLA DE  COMPROBANTE DONDE SE GUARDARA LOS DATOS QUE SE ENVIARAN A LA SUNAT
IF OBJECT_ID(N'dbo.tblComprobSunat', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblComprobSunat]
(
[ntraComprob] [int] IDENTITY (1,1) NOT NULL,
[codTransaccion]	[int] NOT NULL, -- codigo de transaccion 
[codModulo]		[smallint] NOT NULL,-- Modulo
[tipDocSunat]		[smallint] NOT NULL,-- Tipo de documento de sunat (Ventas, NC, NC Parcial)
[tipDocVenta]		[smallint] NOT NULL,-- Documento de venta (boleta/factura)
[tramEntrada] [VARCHAR] (MAX) NOT NULL,
[tramSalida] [VARCHAR] (MAX) NULL,
[estado]			[smallint] NOT NULL,
[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso] [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario] [varchar](20) NOT NULL,
[ip] [varchar](20) NULL,
[mac] [varchar](20) NULL,
CONSTRAINT pk_tblComprobSunat PRIMARY KEY (ntraComprob)

);
END
GO

IF OBJECT_ID(N'dbo.tblPermiOpera', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblPermiOpera]
(
[codPermiOpera] [int] IDENTITY NOT NULL,
[codResponsable] [int] NOT NULL,
[opcion] [smallint] NOT NULL,
[codMenu] [int] NOT NULL,
[estado] [smallint] NOT NULL DEFAULT 0,
[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso] [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario] [varchar](20) NOT NULL,
[ip] [varchar](20) NULL,
[mac] [varchar](20) NULL,
CONSTRAINT pk_tblPermiOpera PRIMARY KEY (codPermiOpera)
);
END

GO

IF OBJECT_ID(N'dbo.tblMenu', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblMenu]
(
[codMenu] [int] NOT NULL,
[codModulo] [int] NOT NULL,
[ruta] [varchar](100) NOT NULL,
[descripcion] [varchar](50) NOT NULL,
[estado] [smallint] NOT NULL DEFAULT 0,
[orden] [int] NOT NULL,
[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso] [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario] [varchar](20) NOT NULL,
[ip] [varchar](20) NULL,
[mac] [varchar](20) NULL,
CONSTRAINT pk_tblMenu PRIMARY KEY (codMenu)
);
END
GO

IF OBJECT_ID(N'dbo.tblModulo', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[tblModulo]
(
[codModulo] [int] NOT NULL,
[descripcion] [varchar](50) NOT NULL,
[estado] [smallint] NOT NULL DEFAULT 0,
[orden] [int] NOT NULL,
[marcaBaja] [tinyint] NOT NULL DEFAULT 0 CHECK (marcaBaja IN (0,9)),
[fechaProceso] [date] NOT NULL DEFAULT GETDATE(),
[horaProceso] [time] (0) NOT NULL DEFAULT SYSDATETIME(),
[usuario] [varchar](20) NOT NULL,
[ip] [varchar](20) NULL,
[mac] [varchar](20) NULL,
CONSTRAINT pk_tblModulo PRIMARY KEY (codModulo)
);

END
GO

ALTER TABLE tblMenu ADD CONSTRAINT fk_tblMenu_codModulo FOREIGN KEY (codModulo) REFERENCES tblModulo(codModulo);
ALTER TABLE tblPermiOpera ADD CONSTRAINT fk_tblOperPermisos_codMenu FOREIGN KEY (codMenu) REFERENCES tblMenu(codMenu);

GO