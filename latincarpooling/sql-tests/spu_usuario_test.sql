
-- No existe el usuario
execute procedure dbo.spu_usuario(3, 'Fernando', 'Aramendi', 'faramendi', 'faramendi', 'faramendi@gmail.com',
1, '4290-4657', '15-5122-4888', '4779-6800', 'f', 'M', 'Medrano', 951, 3, '-', '1842', 3436521, 1, '30526985', 
'Argentino', 't', null);

-- No cambia el mail
execute procedure dbo.spu_usuario(2, 'Fernando', 'Aramendi', 'faramendi', 'faramendi', 'faramendi@gmail.com',
1, '4290-4657', '15-5122-4888', '4779-6800', 'f', 'M', 'Medrano', 951, 3, '-', '1842', 3436521, 1, '30526985', 
'Argentino', 't', null);

-- Cambia el mail
execute procedure dbo.spu_usuario(2, 'Fernando', 'Aramendi', 'faramendi', 'faramendi', 'faramendi@gmail2.com',
1, '4290-4657', '15-5122-4888', '4779-6800', 'f', 'M', 'Medrano', 951, 3, '-', '1842', 3436521, 1, '30526985', 
'Argentino', 't', null);