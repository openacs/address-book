--
-- packages/address-book/sql/address-book-create.sql
--
-- @author jmileham@arsdigita.com
-- @creation_date 2000-12-04
-- @cvs-id $Id$
--

-----------------------------------
-- AB_CONTACT_ATTR_TYPES PACKAGE --
-----------------------------------

create or replace package ab_contact_attr_type
as

 function new (
  type_id	in ab_contact_attr_types.type_id%TYPE
		   default null,
  object_type	in acs_objects.object_type%TYPE
		   default 'ab_contact_attr_type',
  creation_date	in acs_objects.creation_date%TYPE
		   default sysdate,
  creation_user	in acs_objects.creation_user%TYPE
		   default null,
  creation_ip	in acs_objects.creation_ip%TYPE
		   default null,
  context_id	in acs_objects.context_id%TYPE
		   default null,
  type_name	in ab_contact_attr_types.type_name%TYPE,
  type_key	in ab_contact_attr_types.type_key%TYPE
 ) return ab_contact_attr_types.type_id%TYPE;

 function name (
  type_id	in ab_contact_attr_types.type_id%TYPE
 ) return ab_contact_attr_types.type_name%TYPE;

 procedure del (
  type_id	in ab_contact_attr_types.type_id%TYPE
 );

end ab_contact_attr_type;
/
show errors


create or replace package body ab_contact_attr_type
as

 function new (
  type_id	in ab_contact_attr_types.type_id%TYPE
		   default null,
  object_type	in acs_objects.object_type%TYPE
		   default 'ab_contact_attr_type',
  creation_date	in acs_objects.creation_date%TYPE
		   default sysdate,
  creation_user	in acs_objects.creation_user%TYPE
		   default null,
  creation_ip	in acs_objects.creation_ip%TYPE
		   default null,
  context_id	in acs_objects.context_id%TYPE
		   default null,
  type_name	in ab_contact_attr_types.type_name%TYPE,
  type_key	in ab_contact_attr_types.type_key%TYPE
 ) return ab_contact_attr_types.type_id%TYPE
 is
  v_type_id ab_contact_attr_types.type_id%TYPE;
 begin
  v_type_id :=
   acs_object.new(object_id => type_id,
		  object_type => object_type,
		  creation_date => creation_date,
		  creation_user => creation_user,
		  creation_ip => creation_ip,
		  context_id => context_id
		 );

  insert into ab_contact_attr_types
   (type_id, type_name, type_key)
  values
   (v_type_id, new.type_name, new.type_key);

  return v_type_id;
 end new;

 function name (
  type_id	in ab_contact_attr_types.type_id%TYPE
 ) return ab_contact_attr_types.type_name%TYPE
 is
  v_type_name ab_contact_attr_types.type_name%TYPE;
 begin
  select type_name
    into v_type_name
    from ab_contact_attr_types
   where type_id = name.type_id;
  return v_type_name;
 end name;


 procedure del (
  type_id	in ab_contact_attr_types.type_id%TYPE
 )
 is
 begin
  acs_object.del(type_id);
 end del;

end ab_contact_attr_type;
/
show errors


-----------------------------
-- AB_CONTACT_ATTR PACKAGE --
-----------------------------


create or replace package ab_contact_attr
as

 function new (
  attr_id		in ab_contact_attrs.attr_id%TYPE
			   default null,
  object_type		in acs_objects.object_type%TYPE
			   default 'ab_contact_attr',
  creation_date		in acs_objects.creation_date%TYPE
			   default sysdate,
  creation_user		in acs_objects.creation_user%TYPE
			   default null,
  creation_ip		in acs_objects.creation_ip%TYPE
			   default null,
  context_id		in acs_objects.context_id%TYPE
			   default null,
  contact_id		in ab_contact_attrs.contact_id%TYPE,
  type_key		in ab_contact_attrs.type_key%TYPE,
  value			in ab_contact_attrs.value%TYPE,
  before_attr_id	in ab_contact_attrs.attr_id%TYPE
			   default null
 ) return ab_contact_attrs.attr_id%TYPE;

 procedure swap_sort (
  attr_id_one		in ab_contact_attrs.attr_id%TYPE,
  attr_id_two		in ab_contact_attrs.attr_id%TYPE
 );

 procedure del (
  attr_id	in ab_contact_attrs.attr_id%TYPE
 );

end ab_contact_attr;
/
show errors


create or replace package body ab_contact_attr
as

 function new (
  attr_id		in ab_contact_attrs.attr_id%TYPE
			   default null,
  object_type		in acs_objects.object_type%TYPE
			   default 'ab_contact_attr',
  creation_date		in acs_objects.creation_date%TYPE
			   default sysdate,
  creation_user		in acs_objects.creation_user%TYPE
			   default null,
  creation_ip		in acs_objects.creation_ip%TYPE
			   default null,
  context_id		in acs_objects.context_id%TYPE
			   default null,
  contact_id		in ab_contact_attrs.contact_id%TYPE,
  type_key		in ab_contact_attrs.type_key%TYPE,
  value			in ab_contact_attrs.value%TYPE,
  before_attr_id	in ab_contact_attrs.attr_id%TYPE
			   default null
 ) return ab_contact_attrs.attr_id%TYPE
 is
  v_attr_id ab_contact_attrs.attr_id%TYPE;
 begin

  v_attr_id :=
   acs_object.new (
    object_id => attr_id,
    object_type => object_type,
    creation_date => creation_date,
    creation_user => creation_user,
    creation_ip => creation_ip,
    context_id => context_id
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


 procedure swap_sort (
  attr_id_one		in ab_contact_attrs.attr_id%TYPE,
  attr_id_two		in ab_contact_attrs.attr_id%TYPE
 )
 is
 begin

  -- The exists clause verifies that the application is trying
  -- to perform a legal swap (one between two attributes of
  -- the same contact_id).

  update ab_contact_attrs aca1
     set sort_key = (select sort_key
		       from ab_contact_attrs aca2
		      where aca1.attr_id = decode(aca2.attr_id,
					   swap_sort.attr_id_one, swap_sort.attr_id_two,
					   swap_sort.attr_id_two, swap_sort.attr_id_one))
   where attr_id in (swap_sort.attr_id_one, swap_sort.attr_id_two)
     and exists (select 1 from ab_contact_attrs aca3, ab_contact_attrs aca4
		  where aca3.attr_id = swap_sort.attr_id_one
		    and aca4.attr_id = swap_sort.attr_id_two
		    and aca3.contact_id = aca4.contact_id);

 end swap_sort;


 procedure del (
  attr_id	in ab_contact_attrs.attr_id%TYPE
 )
 is
 begin
  acs_object.del(attr_id);
 end del;

end ab_contact_attr;
/
show errors



create or replace package ab_contact_rel
as

  function new (
    rel_id		in ab_contact_rels.rel_id%TYPE default null,
    rel_type		in acs_rels.rel_type%TYPE default 'ab_contact_rel',
    object_id_one	in acs_rels.object_id_one%TYPE,
    object_id_two	in acs_rels.object_id_two%TYPE,
    creation_user	in acs_objects.creation_user%TYPE default null,
    creation_ip		in acs_objects.creation_ip%TYPE default null,
    category		in ab_contact_rels.category%TYPE default null
  ) return ab_contact_rels.rel_id%TYPE;

  procedure del (
    rel_id	in ab_contact_rels.rel_id%TYPE
  );

end ab_contact_rel;
/
show errors



create or replace package body ab_contact_rel
as

  function new (
    rel_id		in ab_contact_rels.rel_id%TYPE default null,
    rel_type		in acs_rels.rel_type%TYPE default 'ab_contact_rel',
    object_id_one	in acs_rels.object_id_one%TYPE,
    object_id_two	in acs_rels.object_id_two%TYPE,
    creation_user	in acs_objects.creation_user%TYPE default null,
    creation_ip		in acs_objects.creation_ip%TYPE default null,
    category		in ab_contact_rels.category%TYPE default null
  ) return ab_contact_rels.rel_id%TYPE
  is
    v_rel_id ab_contact_rels.rel_id%TYPE;
  begin
    v_rel_id :=
      acs_rel.new (
	rel_id => rel_id,
	rel_type => rel_type,
	object_id_one => object_id_one,
	object_id_two => object_id_two,
	context_id => object_id_one,
	creation_user => creation_user,
	creation_ip => creation_ip
      );

    insert into ab_contact_rels
      (rel_id, category)
    values
      (v_rel_id, new.category);
   return v_rel_id;
  end new;

  procedure del (
    rel_id	in ab_contact_rels.rel_id%TYPE
  )
  is
  begin
    acs_object.del(rel_id);
  end del;

end ab_contact_rel;
/
show errors


------------------------
-- AB_CONTACT PACKAGE --
------------------------

create or replace package ab_contact
as

 function new (
  contact_id	in ab_contacts.contact_id%TYPE default null,
  object_type	in acs_objects.object_type%TYPE
		   default 'ab_contact',
  creation_date in acs_objects.creation_date%TYPE
		   default sysdate,
  creation_user in acs_objects.creation_user%TYPE
		   default null,
  creation_ip	in acs_objects.creation_ip%TYPE
		   default null,
  context_id	in acs_objects.context_id%TYPE
		   default null,
  first_names	in ab_contacts.first_names%TYPE default null,
  last_name	in ab_contacts.last_name%TYPE default null,
  title		in ab_contacts.title%TYPE default null,
  organization	in ab_contacts.organization%TYPE default null,
  object_id	in acs_objects.object_id%TYPE default null,
  category	in ab_contact_rels.category%TYPE default null
 ) return ab_contacts.contact_id%TYPE;

 function name (
  contact_id	in ab_contacts.contact_id%TYPE
 ) return varchar2;

 procedure del (
  contact_id		in ab_contacts.contact_id%TYPE,
  delete_orphan_addresses_p	in char default 't'
 );

 function work_phone (
  contact_id	in ab_contacts.contact_id%TYPE
 ) return varchar2;

 function home_phone (
  contact_id	in ab_contacts.contact_id%TYPE
 ) return varchar2;

 function fax (
  contact_id	in ab_contacts.contact_id%TYPE
 ) return varchar2;

 function other (
  contact_id	in ab_contacts.contact_id%TYPE
 ) return varchar2;

 function email (
  contact_id	in ab_contacts.contact_id%TYPE
 ) return varchar2;

end ab_contact;
/
show errors



create or replace package body ab_contact
as

 function new (
  contact_id	in ab_contacts.contact_id%TYPE default null,
  object_type	in acs_objects.object_type%TYPE
		   default 'ab_contact',
  creation_date in acs_objects.creation_date%TYPE
		   default sysdate,
  creation_user in acs_objects.creation_user%TYPE
		   default null,
  creation_ip	in acs_objects.creation_ip%TYPE
		   default null,
  context_id	in acs_objects.context_id%TYPE
		   default null,
  first_names	in ab_contacts.first_names%TYPE default null,
  last_name	in ab_contacts.last_name%TYPE default null,
  title		in ab_contacts.title%TYPE default null,
  organization	in ab_contacts.organization%TYPE default null,
  object_id	in acs_objects.object_id%TYPE default null,
  category	in ab_contact_rels.category%TYPE default null
 ) return ab_contacts.contact_id%TYPE
 is
  v_contact_id ab_contacts.contact_id%TYPE;
  v_rel_id ab_contact_rels.rel_id%TYPE;
 begin
  v_contact_id := 
   acs_object.new(object_id => contact_id,
		  object_type => object_type,
		  creation_date => creation_date,
		  creation_user => creation_user,
		  creation_ip => creation_ip,
		  context_id => context_id);

  -- If they supplied an object_id, relate it:
  if object_id is not null then
   v_rel_id :=
   ab_contact_rel.new(object_id_one => object_id,
		      object_id_two => v_contact_id,
		      creation_user => creation_user,
		      creation_ip => creation_ip,
		      category => category);
  end if;

  insert into ab_contacts
   (contact_id, first_names, last_name,
    title, organization)
  values
   (v_contact_id, new.first_names, new.last_name,
    new.title, new.organization);


  return v_contact_id;
 end new;

 function name (
  contact_id	in ab_contacts.contact_id%TYPE
 ) return varchar2
 is
  v_name varchar2(400);
 begin
  select first_names||' '||last_name
    into v_name
    from ab_contacts
   where contact_id = name.contact_id;

  return v_name;
 end name;

 procedure del (
  contact_id			in ab_contacts.contact_id%TYPE,
  delete_orphan_addresses_p	in char default 't'
 )
 is
   v_ab_contact_attrs_row ab_contact_attrs%ROWTYPE;
   v_addresses_located_row pl_addresses_located%ROWTYPE;
   cursor address_is_orphan_p_cursor (address_id in pl_addresses.address_id%TYPE) is
     select decode(count(*),0,'t','f') from place_element_map where place_id = address_is_orphan_p_cursor.address_id;
   v_address_is_orphan_p char(1);
   cursor subplace_rel_cursor (address_id in pl_addresses.address_id%TYPE) is
     select sr.rel_id
       from subplace_rels sr,
	    acs_rels ar
      where ar.rel_id = sr.rel_id
	and ar.object_id_two = subplace_rel_cursor.address_id;
   v_rel_id subplace_rels.rel_id%TYPE;
 begin
  -- First blow away attributes
   for v_ab_contact_attrs_row in (select attr_id from ab_contact_attrs where contact_id = ab_contact.del.contact_id) loop
     ab_contact_attr.del(v_ab_contact_attrs_row.attr_id);
   end loop;

  -- Then iterate through address location relations

   for v_addresses_located_row in (select * from pl_addresses_located where locatee_id = ab_contact.del.contact_id) loop

    -- Delete the rel
     subplace_rel.del(v_addresses_located_row.rel_id);


    -- If we're deleting orphans then
     if delete_orphan_addresses_p = 't' then

      -- Check if the address is an orphan
       open address_is_orphan_p_cursor(address_id => v_addresses_located_row.address_id);
       fetch address_is_orphan_p_cursor into v_address_is_orphan_p;
       close address_is_orphan_p_cursor;
       if v_address_is_orphan_p = 't' then

	-- Delete the address's subplace_relation
	 open subplace_rel_cursor(address_id => v_addresses_located_row.address_id);
	 fetch subplace_rel_cursor into v_rel_id;
	 if not subplace_rel_cursor%NOTFOUND then
	   subplace_rel.del(v_rel_id);
	 end if;
	 close subplace_rel_cursor;
	-- Delete the address itself
	 pl_address.del(v_addresses_located_row.address_id);

       end if;

     end if;

   end loop;

   acs_object.del(contact_id);
 end del;

 function work_phone (
  contact_id	in ab_contacts.contact_id%TYPE
 ) return varchar2
 is
  v_value ab_contact_attrs.value%TYPE;
 begin
  select value
    into v_value
    from ab_contact_attrs
   where contact_id = work_phone.contact_id
     and sort_key = (select min(sort_key)
		       from ab_contact_attrs
		      where contact_id = work_phone.contact_id
			and type_key = 'work_phone');
  return v_value;
 end work_phone;


 function home_phone (
  contact_id	in ab_contacts.contact_id%TYPE
 ) return varchar2
 is
  v_value ab_contact_attrs.value%TYPE;
 begin
  select value
    into v_value
    from ab_contact_attrs
   where contact_id = home_phone.contact_id
     and sort_key = (select min(sort_key)
		       from ab_contact_attrs
		      where contact_id = home_phone.contact_id
			and type_key = 'home_phone');
  return v_value;
 end home_phone;


 function fax (
  contact_id	in ab_contacts.contact_id%TYPE
 ) return varchar2
 is
  v_value ab_contact_attrs.value%TYPE;
 begin
  select value
    into v_value
    from ab_contact_attrs
   where contact_id = fax.contact_id
     and sort_key = (select min(sort_key)
		       from ab_contact_attrs
		      where contact_id = fax.contact_id
			and type_key = 'fax');
  return v_value;
 end fax;


 function other (
  contact_id	in ab_contacts.contact_id%TYPE
 ) return varchar2
 is
  v_value ab_contact_attrs.value%TYPE;
 begin
  select value
    into v_value
    from ab_contact_attrs
   where contact_id = other.contact_id
     and sort_key = (select min(sort_key)
		       from ab_contact_attrs
		      where contact_id = other.contact_id
			and type_key = 'other');
  return v_value;
 end other;

 function email (
  contact_id	in ab_contacts.contact_id%TYPE
 ) return varchar2
 is
  v_value ab_contact_attrs.value%TYPE;
 begin
  select value
    into v_value
    from ab_contact_attrs
   where contact_id = email.contact_id
     and sort_key = (select min(sort_key)
		       from ab_contact_attrs
		      where contact_id = email.contact_id
			and type_key = 'email');
  return v_value;
 end email;

end ab_contact;
/
show errors

--------------------------
-- AB_CONTACTS_COMPLETE --
--------------------------
