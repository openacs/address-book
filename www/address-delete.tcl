ad_page_contract {
    Deletes an address from a contact (well kinda... if it is in use elsewhere, we just delete the relation)
} {
    address_id:integer,notnull
    rel_id:integer,notnull
    contact_id:integer,notnull
}

set instance_id [ad_conn package_id]

ad_require_permission $instance_id read

ad_require_permission $rel_id delete

db_transaction {

    db_exec_plsql delete_location_rel {
	begin
	  location_rel.delete(:rel_id);
	end;
    }

    # Now we check if this is an orphan address and delete it if it is (even if the user doesn't
    # have delete privileges on the address itself... it's just good housekeeping)

    # The definition of orphan is an address having 1. no locatees 2. no subplaces

    if [db_string orphan_address {select decode(count(*),0,1,0) from place_element_map where place_id = :address_id}] {

	#Make extra sure that the object we're deleting is indeed an address:

	if ![db_string address_is_orphan_p {select decode(count(*),0,0,1) from acs_objects where object_id = :address_id and object_type = 'pl_address'}] {
	    ad_return_forbidden "Permission Denied" "address_id was modified in transit"
	    ad_script_abort
	}

	db_exec_plsql delete_orphan_address {
	    declare
	      v_rel_id subplace_rels.rel_id%TYPE;
	      cursor subplace_rel_cursor is
	        select sr.rel_id
	          from subplace_rels sr,
	               acs_rels ar
	         where ar.rel_id = sr.rel_id
	           and ar.object_id_two = :address_id;
	    begin
	      open subplace_rel_cursor;
	      fetch subplace_rel_cursor into v_rel_id;
	      if not subplace_rel_cursor%NOTFOUND then
	        subplace_rel.delete(v_rel_id);
	      end if;
	      close subplace_rel_cursor;
	      pl_address.delete(:address_id);
	    end;
	}
    }
}

ad_returnredirect contact-view?contact_id=$contact_id