ad_page_contract {

    address-book attribute add/edit page

    @author John Mileahm (jmileham@arsdigita.com
    @creation_date 11/20/2000
    @cvs-id $Id$
} {
    contact_id:integer
    attr_id:integer,optional
} -properties {
    page_title:onevalue
    context:onevalue
    attr_widget:onerow
    activity:onevalue
}

set instance_id [ad_conn package_id]

ad_require_permission $instance_id read

set attr_widget "<input type=hidden name=contact_id value=$contact_id>"

if ![info exists attr_id] {
    ad_require_permission $contact_id create
    set page_title "Add an Attribute"
    set activity "Insert"
    set attr_id [db_nextval acs_object_id_seq]

    # We'll create a new attribute that's not like any of the others if possible

    set type_key [db_string unique_type_key {
	select type_key
	  from ab_contact_attr_types
	 where type_id = (select min(type_id)
                            from ab_contact_attr_types
                           where type_key not in (select type_key
                                                    from ab_contact_attrs
                                                   where contact_id = :contact_id))
    } -default ""]

    # If not possible, just make another one of the first kind

    if [empty_string_p $type_key] {
	set type_key [db_string first_type_key {
	    select type_key
	      from ab_contact_attr_types
	     where type_id = (select min(type_id)
	                      from ab_contact_attr_types)
        }]
    }

    set value {}
} else {
    ad_require_permission $attr_id write
    set activity "Update"
    set page_title "Edit an Attribute"
    db_1row get_attribute {select type_key, value from ab_contact_attrs where attr_id = :attr_id}
}

append attr_widget "<input type=hidden name=attr_id value=$attr_id>
[ab::contact_attr_type::select -default $type_key]
<input type=text size=30 maxlength=200 name=attr_value value=\"[ad_quotehtml $value]\">
"
set context [list [list contact-view?contact_id=$contact_id "View a Contact"] Attribute]


ad_return_template