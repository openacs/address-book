--
-- packages/address-book/sql/address-book-create.sql
-- @author ported to pg by Rafael Calvo (rafa@sedal.usyd.edu.au) and 
--         Don Baccus (dhogaza@pacifier.com)
-- @author jmileham@arsdigita.com
-- @creation_date 2000-12-04
-- @cvs-id $Id$
--

---------------------------------------------------------------
-- Data Model for address-book package
-- create ab_contact object *
-- create ab_contacts table *
-- create ab_contact_attr_type object *
-- create ab_contact_attr_type table  *
-- create or replace ab_contact_attr_type package. functions: new,name,delete*
-- create or replace package body ab_contact_attr_type. functions: new,name,de*
-- Definition of Attribute types: work phone, home phone,etc. *
-- create ab_contact_attr object *
-- create ab_contact_attrs table *
-- create or replace package ab_contact_attr. Functions:new,swap_sort,delete. 
-- create or replace package body ab_contact_attr 
-- create ab_contact_rel role
-- create table ab_contact_rels
-- create or replace package ab_contact_rel
-- create or replace package body ab_contact_rel
-- create or replace package ab_contact. Funcs: name,delete,work_phone,etc.
-- create or replace package body ab_contact. Funcs
-- create or replace view ab_contacts_complete
-- create or replace view ab_contacts_related


-----------------------
-- OBJECTS --
-----------------------


create function inline_0 ()
returns integer as '
declare
 attr_id acs_attributes.attribute_id%TYPE;
begin
-- ab_contact object
 PERFORM acs_object_type__create_type (
   ''ab_contact'',               -- object_type
   ''Address Book Contact'',     -- pretty_name
   ''Address Book Contact'',     -- pretty_plural
   ''acs_object'',               -- supertype
   ''ab_contact'',               -- table_name
   ''contact_id'',               -- id_column
   ''ab_contact'',               -- package_name (default)
   ''f'',                        -- abstract_p (default)
   null,                         -- type_extension_table (default)
   ''ab_contact.name''          -- name_method (default)
   );


-- ab_contact_attr_type OBJECT 
 PERFORM acs_object_type__create_type (
   ''ab_contact_attr_type'',                 -- object_type
   ''Address Book Contact Attribute Type'',  -- pretty_name
   ''Address Book Contact Attribute Types'', -- pretty_plural
   ''acs_object'',                           -- supertype
   ''ab_contact_attr_type'',                 -- table_name
   ''type_id'',                              -- id_column
   ''ab_contact_attr_type'',                 -- package_name (default)
   ''f'',                                    -- abstract_p (default)
   null,                                     -- type_extension_table (default)
   ''ab_contact_attr_type.name''            -- name_method (default)
   );

-- ab_contact_attrs OBJECT
 PERFORM acs_object_type__create_type (
   ''ab_contact_attrs'',                  -- object type
   ''Address Book Contact Attribute'',    -- pretty_name
   ''Address Book Contact Attributes'',   -- pretty_plural
   ''acs_object'',                        -- supertype
   ''ab_contact_attrs'',                  -- table_name
   ''attr_id'',                           -- id_column
   ''ab_contact_attr'',                   -- package_name (default)
   ''f'',                                 -- abstract_p (default)
   null,                                  -- type_extension_table (default)
   ''ab_contact_attr.name''             -- name_method (default)
   );

   return 0;
end;' language 'plpgsql';

select inline_0 ();
drop function inline_0 ();

-----------------------
-- AB_CONTACTS TABLES --
-----------------------
-- ab_contacts table
create table ab_contacts (
	contact_id	integer not null
			constraint ab_contacts_contact_id_fk
			references acs_objects (object_id)
			constraint ab_contacts_pk primary key,
	first_names	varchar(200),
	last_name	varchar(200),
	title		varchar(200),
	organization	varchar(200)
);


-- ab_contact_attr_types TABLE --
create table ab_contact_attr_types (
	type_id		integer not null
			constraint ab_con_attr_tp_type_id_fk
			references acs_objects (object_id)
			constraint ab_contact_attr_types_pk
			primary key,
	type_name	varchar(100) not null,
	type_key	varchar(20) not null
			constraint ab_con_attr_tp_type_key_un
			unique
);

-- ab_contact_attrs TABLE
create table ab_contact_attrs (
	attr_id		integer not null
			constraint ab_con_attrs_attr_id_fk
			references acs_objects (object_id)
			constraint ab_con_attrs_pk primary key,
	contact_id	integer not null
			constraint ab_con_attrs_contact_id_fk
			references ab_contacts (contact_id),
	type_key	varchar(20) not null
			constraint ab_con_attrs_type_key_fk
			references ab_contact_attr_types (type_key),
	value		varchar(200),
	sort_key	integer not null
);
 
-----------------------------------
-- AB_CONTACT_ATTR_TYPES PACKAGE --
-----------------------------------
-------------------
-- Function: new contact attribute type

create function ab_contact_attr_type__new (
       -- type_id      
       -- object_type   
       -- creation_date 
       -- creation_user 
       -- creation_ip   
       -- context_id    
       -- type_name     
       -- type_key     
       integer,    -- ab_contact_attr_types.type_id%TYPE
       varchar,    -- acs_objects.object_type%TYPE
       timestamp,  -- acs_objects.creation_date%TYPE
       integer,    -- acs_objects.creation_user%TYPE
       varchar,    -- acs_objects.creation_ip%TYPE
       integer,    -- acs_objects.context_id%TYPE
       varchar,    -- ab_contact_attr_types.type_name%TYPE,
       varchar     -- ab_contact_attr_types.type_key%TYPE
) 
returns integer as '   -- ab_contact_attr_types.type_id%TYPE
declare
  new__type_id                alias for $1;      -- default null
  new__object_type            alias for $2;      -- default ab_contact_attr_type
  new__creation_date          alias for $3;      -- default sysdate
  new__creation_user          alias for $4;      -- default null
  new__creation_ip            alias for $5;      -- default null
  new__context_id             alias for $6;      -- default null
  new__type_name              alias for $7;      -- default null
  new__type_key               alias for $8;       
  v_type_id                   ab_contact_attr_types.type_id%TYPE;
begin
        v_type_id := acs_object__new (
                new__type_id,
                new__object_type,
                new__creation_date,
                new__creation_user,
                new__creation_ip,
                new__context_id
        );

        insert into ab_contact_attr_types
          (type_id, type_name, type_key)
        values
          (v_type_id, new__type_name, new__type_key);

        return v_type_id;

end;' language 'plpgsql';


-- name contact attribute type
create function ab_contact_attr_type__name (
       integer		-- ab_contact_attr_types.type_id%TYPE
) returns integer as '  -- ab_contact_attr_types.type_name%TYPE
declare
  new__type_id                alias for $1;       -- default null
begin
    select type_name
    into v_type_name
    from ab_contact_attr_types
    where type_id = name.type_id;
    return v_type_name;
  
end;' language 'plpgsql';


-- delete contact attribute type
----------------------
create function ab_contact_attr_type__delete (
       integer          -- ab_contact_attr_types.type_id%TYPE
) returns integer as '
declare
  delete__type_id            alias for $1;
begin
    delete from acs_permissions
                   where object_id = delete__type_id;

        delete from ab_contact_attr_types
                   where type_id = delete__type_id;

        raise NOTICE ''Deleting contact attribute type...'';
        PERFORM acs_object__delete(delete__type_id);

        return 0;

end;' language 'plpgsql';




-- ----------------------------
-- -- DEFINE SOME ATTR TYPES --
-- ----------------------------
-- 
-- -- This may look remarkably similar to the attribute types offered
-- -- by the address book in PalmOS.  Not a coincidence.
-- 
create function inline_0 () returns integer as '
declare
  tmpval ab_contact_attr_types.type_id%TYPE;
 begin
  tmpval :=
  ab_contact_attr_type__new(
	null,			-- type_id default null      
        ''ab_contact_attr_type'',	-- object_type   
	now(),			-- creation_date 
	null,			-- creation_user 
	null,			-- creation_ip   
	null,			-- context_id    
	''Work Phone'',		-- type_name
 	''work_phone''          -- type_key
	);		

-- raise notice "....here...";

  tmpval :=
  ab_contact_attr_type__new(
	null,			-- type_id default null      
        ''ab_contact_attr_type'',	-- object_type   
	now(),			-- creation_date 
	null,			-- creation_user 
	null,			-- creation_ip   
	null,			-- context_id    
	''Home Phone'',		-- type_name
 	''home_phone''          -- type_key
	);		

  tmpval :=
  ab_contact_attr_type__new(
	null,			-- type_id default null      
        ''ab_contact_attr_type'',	-- object_type   
	now(),			-- creation_date 
	null,			-- creation_user 
	null,			-- creation_ip   
	null,			-- context_id    
	''Fax Phone'',		-- type_name
 	''fax'');		-- type_key

  tmpval :=
  ab_contact_attr_type__new(
	null,			-- type_id default null      
        ''ab_contact_attr_type'',	-- object_type   
	now(),			-- creation_date 
	null,			-- creation_user 
	null,			-- creation_ip   
	null,			-- context_id    
	''Other'',		-- type_name
 	''other'');		-- type_key

  tmpval :=
  ab_contact_attr_type__new(
	null,			-- type_id default null      
        ''ab_contact_attr_type'',	-- object_type   
	now(),			-- creation_date 
	null,			-- creation_user 
	null,			-- creation_ip   
	null,			-- context_id    
	''E-mail Address'',	-- type_name
 	''email'');		-- type_key

  tmpval :=
  ab_contact_attr_type__new(
	null,			-- type_id default null      
        ''ab_contact_attr_type'',	-- object_type   
	now(),			-- creation_date 
	null,			-- creation_user 
	null,			-- creation_ip   
	null,			-- context_id    
	''Main'',			-- type_name
 	''main'');		-- type_key

  tmpval :=
  ab_contact_attr_type__new(
	null,			-- type_id default null      
        ''ab_contact_attr_type'',	-- object_type   
	now(),			-- creation_date 
	null,			-- creation_user 
	null,			-- creation_ip   
	null,			-- context_id    
	''Pager'',		-- type_name
 	''pager'');		-- type_key

  tmpval :=
  ab_contact_attr_type__new(
null,			-- type_id default null      
        ''ab_contact_attr_type'',	-- object_type   
	now(),			-- creation_date 
	null,			-- creation_user 
	null,			-- creation_ip   
	null,			-- context_id    
	''Mobile Phone'',	-- type_name
 	''mobile'');		-- type_key
return 0;
end;' language 'plpgsql';
select inline_0 ();
drop function inline_0 ();


-- contact attributes package
-------------------
-- Function: new contact attribute
create function ab_contact_attr__new (
       -- attr_id               in ab_contact_attrs.attr_id%TYPE
       -- object_type           in acs_objects.object_type%TYPE
       -- creation_date         in acs_objects.creation_date%TYPE
       -- creation_user         in acs_objects.creation_user%TYPE
       -- creation_ip           in acs_objects.creation_ip%TYPE
       -- context_id            in acs_objects.context_id%TYPE
       -- contact_id            in ab_contact_attrs.contact_id%TYPE,
       -- type_key              in ab_contact_attrs.type_key%TYPE,
       -- value                 in ab_contact_attrs.value%TYPE,
       -- before_attr_id        in ab_contact_attrs.attr_id%TYPE
       integer,    -- ab_contact_attrs.attr_id%TYPE
       varchar,    -- acs_objects.object_type%TYPE
       timestamp,  -- acs_objects.creation_date%TYPE
       integer,    -- acs_objects.creation_user%TYPE
       varchar,    -- acs_objects.creation_ip%TYPE
       integer,    -- acs_objects.context_id%TYPE
       integer,    -- ab_contact_attrs.contact_id%TYPE,
       integer,    -- ab_contact_attrs.type_key%TYPE,
       varchar,    -- ab_contact_attrs.value%TYPE,
       integer    -- ab_contact_attrs.attr_id%TYPE

) returns integer as '   -- ab_contact_attrs.attr_id%TYPE
declare
  new__type_id                alias for $1;       -- default null
  new__object_type            alias for $2;       -- default ''ab_contact_attr''
  new__creation_date          alias for $3;       -- default sysdate
  new__creation_user          alias for $4;       -- default null
  new__creation_ip            alias for $5;       -- default null
  new__context_id             alias for $6;       -- default null
  new__contact_id             alias for $7;       -- 
  new__type_key               alias for $8;
  new__value                  alias for $9;
  new__before_attr_id         alias for $10;      -- default null
  v_attr_id                   ab_contact_attrs.attr_id%TYPE;
begin
        v_attr_id := acs_object__new (
                new__attr_id,
                new__object_type,
                new__creation_date,
                new__creation_user,
                new__creation_ip,
                new__context_id
        );

	if new.before_attr_id is not null then

	-- Shift the attributes down to accomidate if they specified
	-- before_attr_id

update ab_contact_attrs aca
       set sort_key = sort_key + 1
     where sort_key >= (select sort_key
                          from ab_contact_attrs
                         where attr_id = new.before_attr_id)
       and exists (select 1
                     from ab_contact_attrs
                    where attr_id = aca.attr_id
                      and contact_id = new.contact_id);

   -- Insert into the newly create hole

    insert into ab_contact_attrs
     (attr_id, contact_id, type_key, value, sort_key)

select new.v_attr_id, new.contact_id, new.type_key, new.value, (sort_key - 1)
      from ab_contact_attrs
     where attr_id = new.before_attr_id;

  else

   -- Otherwise, tack it on the end

   insert into ab_contact_attrs
     (attr_id, contact_id, type_key, value, sort_key)
    select new.v_attr_id, new.contact_id, new.type_key, new.value, nvl(max(sort_key) + 1, 1)
      from ab_contact_attrs
     where contact_id = new.contact_id;

  end if;

  return v_attr_id;
 end new;
    );

   return v_attr_id;

end;' language 'plpgsql';


-- swap_sort
create function ab_contact_attr__swap_sort (
       integer,     -- ab_contact_attrs.attr_id%TYPE,
       integer      -- ab_contact_attrs.attr_id%TYPE
) returns integer as '
declare
	p_attr_id_one    alias for $1;         
	p_attr_id_two    alias for $2;
begin
  -- The exists clause verifies that the application is trying
  -- to perform a legal swap (one between two attributes of
  -- the same contact_id).

  update ab_contact_attrs aca1
     set sort_key = (select sort_key
                       from ab_contact_attrs aca2
                      where aca1.attr_id = case aca2.attr_id
                                           when p_attr_id_one then p_attr_id_two
                                           when p_attr_id_two then p_attr_id_one)
   where attr_id in (p_attr_id_one, p_attr_id_two)
     and exists (select 1 from ab_contact_attrs aca3, ab_contact_attrs aca4
                  where aca3.attr_id = p_attr_id_one
                    and aca4.attr_id = p_attr_id_two
                    and aca3.contact_id = aca4.contact_id);

end;' language 'plpgsql';

-- delete
create function ab_contact_attr__delete (
       integer     -- ab_contact_attrs.attr_id%TYPE
) returns integer as '
declare
	attr_id       alias for $1;       -- default null
begin
	acs_object__delete(attr_id);
	return 0;
end;' language 'plpgsql';


-- --------------------
-- -- AB_CONTACT_REL --
-- --------------------

create function inline_0 ()
returns integer as '
begin
PERFORM  acs_rel_type__create_role(''contact''); 
PERFORM  acs_rel_type__create_type (
   ''ab_contact_rel'',			--   rel_type
   ''Address Book Contact Relation'',	--   pretty_name
   ''Address Book Contact Relationships'',--   pretty_plural
   ''relationship'',			--   supertype,  
   ''ab_contact_rels'',			--   table_name
   ''rel_id'',				--   id_column 
   ''ab_contact_rel'',			--   package_name 
   ''acs_object'',			--   object_type_one 
   null,				--   role_one
   0,					--   min_n_rels_one 
   null,				--   max_n_rels_one
   ''ab_contact'',			--   object_type_two
   ''contact'',				--   role_two 
   0,					--   min_n_rels_two
    null				--   max_n_rels_two
  );
return 0;
end;' language 'plpgsql';

select inline_0();
drop function inline_0();


create table ab_contact_rels (
  rel_id	integer constraint ab_contact_rels_rel_id_fk
 		references acs_rels (rel_id)
 		constraint ab_contact_rels_rel_id_pk
 		primary key,
   category	varchar(30)
);


--------------------------------
-- Package ab_contact_rel
-- function new
create function ab_contact_rel__new (
       --     rel_id		
       --     rel_type		
       --     object_id_one	
       --     object_id_two	
       --     creation_user	
       --     creation_ip	
       --     category		
       integer,         -- ab_contact_rels.rel_id%TYPE default null,
       integer,         -- acs_rels.rel_type%TYPE 
       integer,		-- acs_rels.object_id_one%TYPE,
       integer,		-- acs_rels.object_id_two%TYPE,
       varchar,		-- acs_objects.creation_user%TYPE default null,
       varchar,		-- acs_objects.creation_ip%TYPE default null,
       varchar		-- ab_contact_rels.category%TYPE default null
) returns integer as '
declare
	rel_id		alias for $1;		
	rel_type	alias for $2;	
	object_id_one	alias for $3;
	object_id_two	alias for $4;
	creation_user	alias for $5;
	creation_ip	alias for $6;
	category	alias for $7;	
	v_rel_id ab_contact_rels.rel_id%TYPE;
begin
     v_rel_id :=
       acs_rel__new (
 	rel_id,
 	rel_type,
 	object_id_one,
 	object_id_two,
 	object_id_one,
 	creation_user,
 	creation_ip
       );
 
     insert into ab_contact_rels
       (rel_id, category)
     values
       (v_rel_id, new.category);
    return v_rel_id;
end;' language 'plpgsql';



-- function delete

create function ab_contact_rel__delete (
       -- rel_id		
       integer         -- ab_contact_rels.rel_id%TYPE
) returns integer as '
declare
	rel_id		alias for $1;		
begin
	acs_object__delete(rel_id);
	return 0;

end;' language 'plpgsql';

-- ------------------------
-- -- AB_CONTACT PACKAGE --
-- ------------------------
-- function new

create function ab_contact__new (
       -- contact_id	
       -- object_type	
       -- creation_date 
       -- creation_user
       -- creation_ip	
       -- context_id	
       -- first_names	
       -- last_name	
       -- title		
       -- organization	
       -- object_id	
       -- category	
       integer,		-- ab_contacts.contact_id%TYPE default null,
       varchar,		-- acs_objects.object_type%TYPE
       timestamp,	-- acs_objects.creation_date%TYPE
       integer,		-- acs_objects.creation_user%TYPE
       varchar,		-- acs_objects.creation_ip%TYPE
       integer,		-- acs_objects.context_id%TYPE
       varchar,		-- ab_contacts.first_names%TYPE default null,
       varchar,		-- ab_contacts.last_name%TYPE default null,
       varchar,		-- ab_contacts.title%TYPE default null,
       varchar,		-- ab_contacts.organization%TYPE default null,
       integer,		-- acs_objects.object_id%TYPE default null,
       varchar		-- ab_contact_rels.category%TYPE default null

) returns integer as '	-- ab_contacts.contact_id%TYPE;
declare
	new__contact_id	alias for $1;	
	new__object_type	alias for $2;
        new__creation_date	alias for $3;
        new__creation_user	alias for $4;
        new__creation_ip	alias for $5;
        new__context_id	alias for $6;
        new__first_names	alias for $7;
        new__last_name	alias for $8;
        new__title		alias for $9;
        new__organization	alias for $10;
        new__object_id	alias for $11;
        new__category	alias for $12;
	v_contact_id ab_contacts.contact_id%TYPE;
	v_rel_id ab_contact_rels.rel_id%TYPE;
begin
	v_contact_id := 
	acs_object__new(
		new__object_id,      -- object_id
		new__object_type,   -- object_type
		new__creation_date, -- creation_date
		new__creation_user, -- creation_user
		new__creation_ip,   -- creation_ip
		new__context_id     -- context_id
		);

		
	-- If they supplied an object_id, relate it:
	--   if object_id is not null then
    v_rel_id :=
    ab_contact_rel.new(
     null,		--     rel_id		
     null,		--     rel_type		
     new__object_id,	--     object_id_one	
     v_contact_id,	--     object_id_two	
     new__creation_user,--     creation_user	
     new__creation_ip,  --     creation_ip	
     new__category	--     category		
);

   end if;
 
   insert into ab_contacts
    (contact_id, first_names, last_name,
     title, organization)
   values
    (v_contact_id, new.first_names, new.last_name,
     new.title, new.organization);
 
   return v_contact_id;

end;' language 'plpgsql';


-- function name
create function ab_contact__name (
       -- contact_id		
       integer         -- ab_contacts.contact_id%TYPE
) returns varchar as '
declare
	contact_id		alias for $1;		
	v_name varchar(400);
begin
	select first_names||'' ''||last_name
	into v_name
	from ab_contacts
	where contact_id = name.contact_id;
 
	return v_name;

end;' language 'plpgsql';

create function pl_address__orphan_address(integer) returns integer as '

declare
  v_rel_id subplace_rels.rel_id%TYPE;
begin
  select sr.rel_id
  from subplace_rels sr, acs_rels ar
  where ar.rel_id = sr.rel_id and ar.object_id_two = :address_id;
  if found then
    subplace_rel__delete(v_rel_id);
  pl_address__delete(:address_id);
end;' language 'plpgsql';
	

-- function delete
create function ab_contact__delete (
       integer,         -- ab_contacts.contact_id%TYPE
       boolean		-- char default t
) returns integer as '
declare
	contact_id			alias for $1;		
	delete_orphan_addresses_p	alias for $2;
	v_ab_contact_attrs_row		ab_contact_attrs%ROWTYPE;
	v_addresses_located_row		pl_addresses_located%ROWTYPE;
        v_rel_id			ab_contact_rels.rel_id%TYPE;
begin

-- First blow away attributes
   for v_ab_contact_attrs_row in (
       select attr_id 
       from   ab_contact_attrs 
       where  contact_id = ab_contact.delete.contact_id) 
   loop
	ab_contact_attr__delete(v_ab_contact_attrs_row.attr_id);
   end loop;

   for v_addresses_located_row in (select * from pl_addresses_located where locatee_id = ab_contact.delete.contact_id) loop
     subplace_rel__delete(v_addresses_located_row.rel_id);
     if delete_orphan_addresses_p and
        not exists(select 1
                   from place_element_map pem, pl_address pl
                   where pem.place_id = pl.address_id and
                   v_addresses_located_row.address_id = pl.address_id) 
     then
       select sr.rel_id into v_rel_id
       from subplace_rels sr, acs_rels ar
       where ar.rel_id = sr.rel_id and ar.object_id_two = v_addresses_located_row.address_id;
       if found then
         subplace_rel__delete(v_rel_id);
       end if;
     end if;
return 0;
end;' language 'plpgsql';


-- function work_phone
create function ab_contact__work_phone (
       --  contact_id
       integer  -- ab_contacts.contact_id%TYPE
) returns varchar as '
declare
        p_contact_id alias for $1;
        v_value ab_contact_attrs.value%TYPE;  -- varchar(200)
begin
   select value
     into v_value
     from ab_contact_attrs
     where contact_id = p_contact_id
     and sort_key = (select min(sort_key)
                       from ab_contact_attrs
                      where contact_id = p_contact_id
                        and type_key = ''work_phone'');
  return v_value;
end;' language 'plpgsql';

-- function home_phone
create function ab_contact__home_phone (
       -- contact_id	
       integer		-- ab_contacts.contact_id%TYPE
) returns varchar as ' 
declare
	p_contact_id	alias for $1;
	v_value ab_contact_attrs.value%TYPE;
begin
	select value
	into v_value
	from ab_contact_attrs
	where contact_id = p_contact_id
	and sort_key = (select min(sort_key)
	       from ab_contact_attrs
	      where contact_id = p_contact_id
		and type_key = ''home_phone'');
   return v_value;

end;' language 'plpgsql';

-- function fax
create function ab_contact__fax (
       -- contact_id	
       integer		-- ab_contacts.contact_id%TYPE
) returns varchar as '
declare
	p_contact_id alias for $1;
	v_value ab_contact_attrs.value%TYPE;
begin
	select value
	    into v_value
	    from ab_contact_attrs
	   where contact_id = p_contact_id
	     and sort_key = (select min(sort_key)
 		       from ab_contact_attrs
 		      where contact_id = p_contact_id
 			and type_key = ''fax'');
return v_value;

end;' language 'plpgsql';

-- function other
create function ab_contact__other (
       -- contact_id	
       integer		-- ab_contacts.contact_id%TYPE
) returns varchar as '
declare
	p_contact_id alias for $1;
	v_value ab_contact_attrs.value%TYPE;
begin
   select value
     into v_value
     from ab_contact_attrs
    where contact_id = p_contact_id
      and sort_key = (select min(sort_key)
 		       from ab_contact_attrs
 		      where contact_id = p_contact_id
 			and type_key = ''other'');
   return v_value;
end;' language 'plpgsql';

-- function email
create function ab_contact__email (
       -- contact_id	
       integer		-- ab_contacts.contact_id%TYPE
) returns varchar as '
declare
	p_contact_id alias for $1;
	v_value ab_contact_attrs.value%TYPE;
begin
   select value
     into v_value
     from ab_contact_attrs
    where contact_id = p_contact_id
      and sort_key = (select min(sort_key)
 		       from ab_contact_attrs
 		      where contact_id = p_contact_id
 			and type_key = ''email'');
   return v_value;

end;' language 'plpgsql';

-- --------------------------
-- -- AB_CONTACTS_COMPLETE --
-- --------------------------

create view ab_contacts_complete as
   select ac.*,
          ab_contact__work_phone(contact_id) as work_phone,
          ab_contact__home_phone(contact_id) as home_phone,
          ab_contact__fax(contact_id) as fax,
          ab_contact__other(contact_id) as other,
 	  ab_contact__email(contact_id) as email
     from ab_contacts ac;

-- 
create view ab_contacts_related as
   select acc.*,
 	 ar.rel_id,
 	 ar.object_id_one as object_id,
 	 acrel.category
     from ab_contacts_complete acc,
 	 acs_rels ar,
 	 ab_contact_rels acrel
    where acc.contact_id = ar.object_id_two
      and ar.rel_id = acrel.rel_id;
 
 

