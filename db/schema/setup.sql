drop table if exists step_collection_memberships;
drop table if exists step_collections;
drop table if exists calculation_style_applicabilities;
drop table if exists step_display_depths;
drop table if exists actualisations;
drop table if exists business_items;
drop table if exists house_steps;
drop table if exists work_packages;
drop table if exists clocks;
drop table if exists procedure_routes;
drop table if exists parliamentary_procedures;
drop table if exists routes;
drop table if exists houses;
drop table if exists steps;
drop table if exists step_types;
drop table if exists calculation_styles;



create table calculation_styles (
	id serial,
	style varchar(255) not null,
	primary key (id)
);
create table houses (
	id serial,
	triple_store_id char(8) not null,
	name varchar(100) not null,
	primary key (id)
);
create table step_types (
	id serial,
	triple_store_id char(8) not null,
	name varchar(255) not null,
	description varchar(500) not null,
	primary key (id)
);
create table steps (
	id serial,
	triple_store_id char(8),
	name varchar(255) not null,
	description varchar(500) not null,
	step_type_id int not null,
	constraint fk_step_type foreign key (step_type_id) references step_types(id),
	primary key (id)
);
create table routes (
	id serial,
	triple_store_id char(8),
	from_step_id int not null,
	to_step_id int not null,
	start_date date,
	end_date date,
	constraint fk_from_step foreign key (from_step_id) references steps(id),
	constraint fk_to_step foreign key (to_step_id) references steps(id),
	primary key (id)
);
create table parliamentary_procedures (
	id serial,
	triple_store_id char(8) not null,
	name varchar(100) not null,
	description varchar(1000) not null,
	primary key (id)
);
create table clocks (
	id serial,
	day_count int not null,
	start_step_id int not null,
	end_step_id int not null,
	parliamentary_procedure_id int not null,
	constraint fk_start_step foreign key (start_step_id) references steps(id),
	constraint fk_end_step foreign key (end_step_id) references steps(id),
	constraint fk_parliamentary_procedure foreign key (parliamentary_procedure_id) references parliamentary_procedures(id),
	primary key (id)
);
create table procedure_routes (
	id serial,
	parliamentary_procedure_id int not null,
	route_id int not null,
	constraint fk_parliamentary_procedure foreign key (parliamentary_procedure_id) references parliamentary_procedures(id),
	constraint fk_route foreign key (route_id) references routes(id),
	primary key (id)
);
create table work_packages (
	id serial,
	triple_store_id char(8) not null,
	web_link varchar(255) not null,
	day_count int,
	is_clock_frozen boolean default false,
	work_packaged_thing_triple_store_id char(8) not null,
	parliamentary_procedure_id int not null,
	calculation_style_id int,
	constraint fk_parliamentary_procedure foreign key (parliamentary_procedure_id) references parliamentary_procedures(id),
	constraint fk_calculation_style foreign key (calculation_style_id) references calculation_styles(id),
	primary key (id)
);
create table house_steps (
	id serial,
	house_id int not null,
	step_id int not null,
	constraint fk_house foreign key (house_id) references houses(id),
	constraint fk_step foreign key (step_id) references steps(id),
	primary key (id)
);
create table business_items (
	id serial,
	triple_store_id char(8) not null,
	web_link varchar(255),
	date date,
	work_package_id int not null,
	constraint fk_work_package foreign key (work_package_id) references work_packages(id),
	primary key (id)
);
create table actualisations (
	id serial,
	business_item_id int not null,
	step_id int not null,
	constraint fk_business_item foreign key (business_item_id) references business_items(id),
	constraint fk_step foreign key (step_id) references steps(id),
	primary key (id)
);
create table step_display_depths (
	id serial,
	step_id int not null,
	parliamentary_procedure_id int not null,
	display_depth float not null,
	constraint fk_step foreign key (step_id) references steps(id),
	constraint fk_parliamentary_procedure foreign key (parliamentary_procedure_id) references parliamentary_procedures(id),
	primary key (id)
);
create table calculation_style_applicabilities (
	id serial,
	parliamentary_procedure_id int not null,
	calculation_style_id int not null,
	constraint fk_parliamentary_procedure foreign key (parliamentary_procedure_id) references parliamentary_procedures(id),
	constraint fk_calculation_style foreign key (calculation_style_id) references calculation_styles(id),
	primary key (id)
);
create table step_collections (
	id serial,
	label varchar(255) not null,
	house_id int,
	parliamentary_procedure_id int,
	constraint fk_parliamentary_procedure foreign key (parliamentary_procedure_id) references parliamentary_procedures(id),
	constraint fk_house foreign key (house_id) references houses(id),
	primary key (id)
);
create table step_collection_memberships (
	id serial,
	step_id int not null,
	step_collection_id int not null,
	constraint fk_step foreign key (step_id) references steps(id),
	constraint fk_step_collection foreign key (step_collection_id) references step_collections(id),
	primary key (id)
);