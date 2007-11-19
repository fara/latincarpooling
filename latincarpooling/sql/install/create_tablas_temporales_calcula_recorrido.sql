create table t_control_ciudad (
    cad_id INT,
    sesion_id INT
)
;

create table t_orden_recorrido (
    oro_ordentramo SMALLINT not null,
    oro_rdo_id INT not null,
    oro_tra_id INT not null,
    sesion_id INT not null
)
;

create table t_cantidad_iteraciones (
		cant_iteraciones integer not null
	);

insert into t_cantidad_iteraciones values ( 50);

