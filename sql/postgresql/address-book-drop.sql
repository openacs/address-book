-- packages/address-book/sql/address-book-drop.sql
-- @author John Mileham (jmileham@arsdigita.com)
-- @cvs-id $Id$

select ab_contact_attr__delete(attr_id) from ab_contact_attrs;
select ab_contact_rel__delete(rel_id) from ab_contact_rels;
select ab_contact_attr_type__delete(type_id) from ab_contact_attr_types;
select ab_contact__delete(contact_id, 't') from ab_contacts;

drop view ab_contacts_related;

drop view ab_contacts_complete;

drop function ab_contact_attr_type__name(integer);       -- RC
drop function ab_contact_attr_type__delete(integer);     -- RC


drop function ab_contact_attr__swap_sort(integer,integer);--RC
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
 
select acs_object_type__drop_type ('ab_contact_attrs', 'f');
select acs_rel_type__drop_type('ab_contact_rel', 'f');
select acs_rel_type__drop_role('contact');
select acs_object_type__drop_type ('ab_contact_attr_type', 'f');
select acs_object_type__drop_type ('ab_contact', 'f');

select  acs_object_type__drop_type('ab_contact_attr_type', 'f');


select  acs_object_type__drop_type('ab_contact', 'f');

drop function ab_contact_rel__delete(integer);
drop function ab_contact_rel__new(integer,integer,integer,integer,varchar,varchar,varchar);

drop function ab_contact__new( integer,varchar,timestamp,integer,varchar,integer,varchar,varchar,varchar,varchar,integer,varchar);
drop function ab_contact__name( integer);

drop function ab_contact__delete(integer, boolean);
drop function ab_contact__work_phone (integer);
drop function ab_contact__home_phone (integer);
drop function ab_contact__fax (integer);
drop function ab_contact__other (integer);
drop function ab_contact__email (integer);
drop function ab_contact__delete_orphan_address(integer);

drop table ab_contact_attr_types;
drop table ab_contacts;
drop table ab_contact_rels;
drop table ab_contact_attrs;
