ad_page_contract {

    address-book street address add/edit page

    @author John Mileahm (jmileham@arsdigita.com
    @creation-date 11/20/2000
    @cvs-id $Id$
} {
    contact_id:integer
    address_id:integer,optional
} -properties {
    page_title:onevalue
    context:onevalue
    address_widget:onevalue
    activity:onevalue
}

set instance_id [ad_conn package_id]

ad_require_permission $instance_id read

set address_widget "<input type=hidden name=contact_id value=$contact_id>"

if ![info exists address_id] {
    ad_require_permission $contact_id create
    set page_title "Add an Address"
    set activity "Insert"
    set address_id [db_nextval acs_object_id_seq]
    append address_widget "<input type=hidden name=address_id value=$address_id>
[place::address::entrywidget]"
} else {
    ad_require_permission $address_id write
    set activity "Update"
    set page_title "Edit an Address"
    append address_widget [place::address::entrywidget -address_id $address_id]
}

set context [list [list contact-view?contact_id=$contact_id "View a Contact"] Address]



ad_return_template