ad_page_contract {

    Address Book Contact Add Page

    @author John Mileham (jmileham@arsdigita.com)
    @creation_date 11/20/2000
    @cvs-id $Id$

} {
} -properties {
    page_title:onevalue
    context_bar:onevalue
    hidden_vars:onevalue
    escaped_first_names:onevalue
    escaped_last_name:onevalue
    escaped_title:onevalue
    escaped_organization:onevalue
    attribute:multirow
    address:onerow
    activity:onevalue
    contact_id:onevalue
}

set instance_id [ad_conn package_id]

ad_require_permission $instance_id read

ad_require_permission $instance_id create
set page_title "Add a Contact"
set activity "Add"
set contact_id [db_nextval acs_object_id_seq]
set context_bar [ad_context_bar $page_title]

set hidden_vars "<input type=hidden name=contact_id value=$contact_id>"

set escaped_first_names {}
set escaped_last_name {}
set escaped_title {}
set escaped_organization {}

# Can't use a db_multirow 'cause I need to escape the
# strings for use in a form and generate a bunch of dropdowns:

multirow create attribute attr_id attr_types_dropdown escaped_value 

# Temporary... to be replaced with a package instance param
set default_attr_types [list work_phone home_phone fax other email]

foreach type_key $default_attr_types {
    multirow append attribute {} [ab::contact_attr_type::select -default $type_key] {}
}


# Need to do a foreach here so that we can call address display widget as necessary

place::address::entry1row address address

ad_return_template