ad_page_contract {
    Form recipient of Contact Add Page

    @author John Mileham (jmileham@arsdigita.com)
} "
    contact_id:integer,notnull
    first_names
    last_name
    title
    organization
   {attr_id:integer,multiple,optional {}}
   {attr_type:nohtml,multiple,optional {}}
   {attr_value:nohtml,multiple,optional {}}
   address:array,address([ad_parameter FreePostalCodes])
"

set user_id [ad_verify_and_get_user_id]
set instance_id [ad_conn package_id]
set peeraddr [ad_conn peeraddr]

ad_require_permission $instance_id read

set contact_exists_p [db_string contact_exists_p {select decode(count(*),0,0,1) from ab_contacts where contact_id = :contact_id}]


# If the contact has been inserted already, and our form was an edit form:
# (this relies on the property that attr_ids are provided for each
# attribute in edit mode:

if { !$contact_exists_p } {

    # If it's an add, require create on the parent:

    ad_require_permission $instance_id create

    # Create the basic record:

    db_transaction {

	db_exec_plsql create_ab_contact {
	    begin
	     :1 :=
	      ab_contact.new(contact_id => :contact_id,
	                     creation_user => :user_id,
	                     creation_ip => :peeraddr,
	                     context_id => :instance_id,
	                     first_names => :first_names,
	                     last_name => :last_name,
	                     title => :title,
	                     organization => :organization,
	                     object_id => :instance_id,
	                     category => 'ab_contact');
	    end;
	}

	# Grant the creating user admin privileges:

	db_exec_plsql grant_admin_to_contact_creator {
	    begin acs_permission.grant_permission(object_id => :contact_id,
	                                          grantee_id => :user_id,
	                                          privilege => 'admin');
	    end;
	}

	# Create a bunch of associated attributes

	for {set n 0} {$n < [llength $attr_id]} {incr n} {
	    set type_key_$n [lindex $attr_type $n]
	    set value_$n [lindex $attr_value $n]
	    if [empty_string_p [set value_$n]] {
		continue
	    }
	    append plsql_block "
	      :1 :=
	        ab_contact_attr.new(creation_user => :user_id,
	                            creation_ip => :peeraddr,
	                            context_id => :contact_id,
	                            contact_id => :contact_id,
	                            type_key => :type_key_$n,
	                            value => :value_$n);
	    "
	}
	if [info exists plsql_block] {
	    db_exec_plsql insert_ab_contact_attrs "begin $plsql_block end;"
	}

	# and insert the address if it's not null:
	set address_notnull 0
	foreach element [array names address] {
	    if ![empty_string_p $address($element)] {
		incr address_notnull
	    }
	}
	if $address_notnull {
	    if { [ad_parameter FreePostalCodes] != 0 } {
		set switch -free_postal_code
	    } else {
		set switch --
	    }
	    place::address::insert -guess_mun -context_id $contact_id $switch address $contact_id ab_contact_address
	}
    }

    # and that's it for an insert...
}

# Note that if it was an edit, but the add form was submitted, that
# means doubleclick... so we just redirect


# We're outta here

ad_returnredirect contact-view?contact_id=$contact_id

    

