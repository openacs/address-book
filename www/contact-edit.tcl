ad_page_contract {

    Edit basic contact info page

    @author John Mileham (jmileham@arsdigita.com)
    @creation_date 11/20/2000
    @cvs-id $Id$

} {
    contact_id:optional
} -properties {
    hidden_vars:onevalue
    page_title:onevalue
    context:onevalue
    escaped_first_names:onevalue
    escaped_last_name:onevalue
    escaped_title:onevalue
    escaped_organization:onevalue
    activity:onevalue
    contact_id:onevalue
}

set instance_id [ad_conn package_id]

ad_require_permission $instance_id read

ad_require_permission $contact_id write
set activity "Update"
set page_title "Edit a Contact"
set context [list [list contact-view?contact_id=$contact_id "View a Contact"] $activity]

set hidden_vars "<input type=hidden name=contact_id value=$contact_id>"

if { [db_0or1row grab_contact_info {
    select first_names,
           last_name,
           title,
           organization
      from ab_contacts
     where contact_id = :contact_id
}] } {
    set escaped_first_names [ad_quotehtml $first_names]
    set escaped_last_name [ad_quotehtml $last_name]
    set escaped_title [ad_quotehtml $title]
    set escaped_organization [ad_quotehtml $organization]
} else {
    set escaped_first_names {}
    set escaped_last_name {}
    set escaped_title {}
    set escaped_organization {}
}

ad_return_template