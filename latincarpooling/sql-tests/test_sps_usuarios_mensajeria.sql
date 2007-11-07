-- Scripts TEST
-- Insertar más datos
INSERT INTO usuariomensajeria VALUES('yahooer666', 1, 666);
INSERT INTO usuariomensajeria VALUES('icqler666', 3, 666);
INSERT INTO usuariomensajeria VALUES('jaberer666', 4, 666);
INSERT INTO usuariomensajeria VALUES('googler666', 5, 666);

-- Información extra
select * from usuariomensajeria;

-- No existe el usuario. [1]
EXECUTE PROCEDURE sps_usuarios_mensajeria(1);

-- Buscar usuarios de mensajeria
EXECUTE PROCEDURE sps_usuarios_mensajeria(666);
