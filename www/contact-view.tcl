ad_page_contract {

    Address Book Contact View Page

    @author John Mileham (jmileham@arsdigita.com)
    @creation_date 11/20/2000
    @cvs-id $Id$

} {
    contact_id:integer,notnull
} -properties {
    page_title:onevalue
    context:onevalue
    contact_widget:onevalue
    write_p:onevalue
    create_p:onevalue
    contact:onerow
    contact_attr:multirow
    address:multirow
    contact_id:onevalue
}   

set instance_id [ad_conn package_id]

ad_require_permission $instance_id read

ad_require_permission $contact_id read

set page_title "View a Contact"

set context [list "View a Contact"]

ab::contact::1row $contact_id contact

ab::contact_attr::multirow $contact_id contact_attr

multirow create address address_id displaywidget rel_id write_p rel_delete_p rel_write_p

db_foreach grab_addresses {
    select address_id,
           address_name,
           line_one,
           line_two,
           line_three,
           line_four,
           municipality_name,
           region_id,
           postal_code,
           country_id,
           rel_id
      from pl_addresses_located
     where locatee_id = :contact_id
  order by sort_key
} -column_array address_complete {
    multirow append address $address_complete(address_id) [place::address::displaywidget -in_datasource_name address_complete] $address_complete(rel_id) [ad_permission_p $address_complete(address_id) write] [ad_permission_p $address_complete(rel_id) delete] [ad_permission_p $address_complete(rel_id) write]
}

set write_p [ad_permission_p $contact_id write]

set create_p [ad_permission_p $contact_id create]
