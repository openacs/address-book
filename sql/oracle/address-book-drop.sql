-- packages/address-book/sql/address-book-drop.sql
-- @author John Mileham (jmileham@arsdigita.com)
-- @cvs-id $Id$

drop view ab_contacts_related;

drop view ab_contacts_complete;

declare
  cursor object_id_c is
    select attr_id from ab_contact_attrs;
  v_row ab_contact_attrs%ROWTYPE;
begin
  for v_row in object_id_c loop
    ab_contact_attr.del(v_row.attr_id);
  end loop;
end;
/
show errors


declare
  cursor object_id_c is
    select rel_id from ab_contact_rels;
  v_row ab_contact_rels%ROWTYPE;
begin
  for v_row in object_id_c loop
    ab_contact_rel.del(v_row.rel_id);
  end loop;
end;
/
show errors


declare
  cursor object_id_c is
    select type_id from ab_contact_attr_types;
  v_row ab_contact_attr_types%ROWTYPE;
begin
  for v_row in object_id_c loop
    ab_contact_attr_type.del(v_row.type_id);
  end loop;
end;
/
show errors

declare
  cursor object_id_c is
    select contact_id from ab_contacts;
  v_row ab_contacts%ROWTYPE;
begin
  for v_row in object_id_c loop
    ab_contact.del(v_row.contact_id);
  end loop;
end;
/
show errors


drop package ab_contact;

drop package ab_contact_rel;

drop table ab_contact_rels;

begin
 acs_rel_type.drop_type('ab_contact_rel');
 acs_rel_type.drop_role('contact');
end;
/
show errors

drop package ab_contact_attr;

drop table ab_contact_attrs;

begin
 acs_object_type.drop_type('ab_contact_attr');
end;
/
show errors

drop package ab_contact_attr_type;

drop table ab_contact_attr_types;

begin
 acs_object_type.drop_type('ab_contact_attr_type');
end;
/
show errors

drop table ab_contacts;

begin
 acs_object_type.drop_type('ab_contact');
end;
/
show errors
