create table antonio (
        i integer,
        b blob);

insert into antonio
(i, b)
values (1, 'tito')

        select *
        from antonio;


execute procedure dbo.spi_antonio (2, BLOB('tito'));

drop procedure dbo.spi_antonio
;
create procedure dbo.spi_antonio
(
    id   integer,
    texto like antonio.b
);

        insert into antonio
        (i)
        values (id);

end procedure with listing in 'informix_warn'
;

INSERT INTO rdb@rserv:election (cand_pic)
   VALUES (rdb@rserv:FILETOBLOB('C:\tmp\photos.xxx', 'server')


 INSERT INTO antonio
 VALUES (3, FILETOBLOB('E:\1.txt', 'server'));



