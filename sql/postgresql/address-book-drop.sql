-- packages/address-book/sql/address-book-drop.sql
-- @author John Mileham (jmileham@arsdigita.com)
-- @cvs-id $Id$

drop view ab_contacts_related;

drop view ab_contacts_complete;

drop function ab_contact_attr_type__name(integer);       -- RC
drop function ab_contact_attr_type__delete(integer);     -- RC


drop function ab_contact_attr__swap_sort(integer,integer);--RC
drop function ab_contact_attr__delete();

drop function ab_contact_attr__delete();
drop function ab_contact_attr_type__new(
       integer,    
       varchar,    
       timestamp,  
       integer,    
       varchar,    
       integer,    
       varchar,    
       varchar ); 
drop function ab_contact_attr__delete (integer);

drop function ab_contact_attr__new (
      integer,    
       varchar,    
       timestamp,  
       integer,    
       varchar,    
       integer,    
       integer,    
       integer,   
       varchar,    
       integer    
);
 
drop function ab_contact__delete(integer, boolean);

-- the original loops in Orcle look like:
-- declare
--   cursor object_id_c is
--    select rel_id from ab_contact_rels;
--  v_row ab_contact_rels%ROWTYPE;
--begin
--  for v_row in object_id_c loop
--    ab_contact_rel.delete(v_row.rel_id);
--  end loop;
--end;
--/
--show errors


create function inline_0 () returns integer as '
begin
	PERFORM
		for attr_id 
		    in select attr_id from ab_contact_attrs
		       loop
		       	ab_contact_attr__delete(v_row.attr_id);
			end loop;

			for rel_id 
			in select rel_id from ab_contact_rels
			loop			
				ab_contact_rel__delete(v_row.rel_id);
			end loop;

			for type_id 
			in select type_id from ab_contact_attr_types
			loop
				ab_contact_attr_types__delete(v_row.type_id);
			end loop;

			for contact_id 
			in select contact_id from ab_contacts
			loop
				ab_contacts__delete(v_row.contact_id);
			end loop;
return null;
end;' language 'plpgsql';
select inline_0 ();
drop function inline_0 ();


drop package ab_contact;

drop package ab_contact_rel;

drop table ab_contact_rels;

begin
 acs_rel_type__drop_type(''ab_contact_rel'');
 acs_rel_type__drop_role(''contact'');
end;
less

drop package ab_contact_attr;

drop table ab_contact_attrs;

create function inline_0 () returns integer as '
begin
	PERFORM acs_object_type__drop_type(''ab_contact_attr'');
returns null;
end;' language 'plpgsql';
select inline_0 ();
drop function inline_0 ();


drop package ab_contact_attr_type;

drop table ab_contact_attr_types;

create function inline_0 () returns integer as '
begin
	PERFORM  acs_object_type__drop_type(''ab_contact_attr_type'');
returns null;
end;' language 'plpgsql';
select inline_0 ();
drop function inline_0 ();

drop table ab_contacts;


create function inline_0 () returns integer as '
begin
	PERFORM acs_object_type__drop_type(''ab_contact'');
returns null;
end;' language 'plpgsql';
select inline_0 ();
drop function inline_0 ();

drop function ab_contact_rel__delete(integer);
drop function ab_contact_rel__new(integer,integer,integer,integer,varchar,varchar,varchar);

drop function ab_contact__new( integer,varchar,timestamp,integer,varchar,integer,varchar,varchar,varchar,varchar,integer,varchar);
drop function ab_contact__name( integer);
