DECLARE @codUsuario INTEGER
DECLARE @orden INTEGER
DECLARE @estado SMALLINT
DECLARE @codUser INTEGER
DECLARE EstadUpdate CURSOR FOR SELECT codUsuario FROM tblRutasAsignadas WHERE marcaBaja = 0 GROUP BY codUsuario 
OPEN EstadUpdate
FETCH NEXT FROM EstadUpdate INTO @codUsuario
WHILE @@fetch_status = 0
BEGIN
	SELECT  @orden = MIN(codOrden) FROM tblRutasAsignadas WHERE codUsuario = @codUsuario and estado = 0 and marcaBaja = 0
	UPDATE tblRutasAsignadas SET estado = 1 WHERE codUsuario = @codUsuario AND codOrden = @orden and marcaBaja = 0

	SELECT @orden = MAX(codOrden) FROM tblRutasAsignadas WHERE codUsuario = @codUsuario and marcaBaja = 0
	SELECT @estado = estado FROM tblRutasAsignadas WHERE codUsuario = @codUsuario and codOrden = @orden and marcaBaja = 0
	GROUP BY codUsuario,estado

	IF @estado = 1 
		BEGIN
		PRINT CONCAT('actualizar todos los estados ', @codUsuario)
		UPDATE tblRutasAsignadas SET estado = 0 WHERE  codUsuario = @codUsuario and marcaBaja = 0

		SELECT @codUsuario as usuario, @estado as estaddo, @orden as orden
	END 
    FETCH NEXT FROM EstadUpdate INTO @codUsuario
END
CLOSE EstadUpdate
DEALLOCATE EstadUpdate
