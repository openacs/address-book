ad_page_contract {
    Deletes a contact (well kinda... if it is in use elsewhere, we just delete the relation)

    @author John Mileham (jmileham@arsdigita.com)
} {
    contact_id:integer,notnull
    rel_id:integer,notnull
}

set instance_id [ad_conn package_id]

ad_require_permission $instance_id read

ad_require_permission $rel_id delete

db_transaction {
    db_exec_plsql delete_ab_contact_rel {
	begin
	  ab_contact_rel.delete(:rel_id);
	end;
    }

    # Now we check if this is an orphan contact and delete it if it is (even if the user doesn't
    # have delete privileges on the contact itself... it's just good housekeeping)

    # The definition of orphan is a contact having no ab_contact_rels.

    if [db_string orphan_contact {select decode(count(*),0,1,0) from ab_contacts_related where contact_id = :contact_id}] {

	# Make extra sure that the object we're deleting is indeed a contact (and not a subtype):

	if ![db_string contact_is_orphan_p {select decode(count(*),0,0,1) from acs_objects where object_id = :contact_id and object_type = 'ab_contact'}] {
	    ad_return_forbidden "Permission Denied" "contact_id was modified in transit"
	    ad_script_abort
	}


	# Clean up perms on the contact and blow it away, deleting orphan addresses it is associated with.
	# an orphan address is an address without any location rels.

        db_transaction {
    	    db_dml delete_orphan_address_perms {
    	      delete from acs_permissions
                   where object_id = :contact_id;
    	    }
    	    db_exec_plsql delete_orphan_address {
                begin
    	      -- Delete the contact, blowing away orphan addresses.
    	      ab_contact.delete(contact_id => :contact_id,
    	                        delete_orphan_addresses_p => 't');
    	        end;
    	    }
        }
    }
}

ad_returnredirect .

