ad_page_contract {
    Form recipient of address-book address add-edit page

    @author John Mileham (jmileham@arsdigita.com)
} "
    address:array,address([ad_parameter FreePostalCodes])
    address_id:integer,optional
    contact_id:integer
"

set user_id [ad_verify_and_get_user_id]
set instance_id [ad_conn package_id]
set peeraddr [ad_conn peeraddr]

ad_require_permission $instance_id read

if { [ad_parameter FreePostalCodes] != 0 } {
    set switch -free_postal_code
} else {
    set switch --
}


# If the form was an add form:
if [info exists address_id] {
    ad_require_permission $contact_id create
    # and it wasn't doubleclicked:
    if ![db_string address_exists_p {select decode(count(*),0,0,1) from pl_addresses where address_id = :address_id}] {
	place::address::insert -guess_mun -context_id $contact_id -address_id $address_id $switch address $contact_id ab_contact_address
    }
} else {
    ad_require_permission $address(address_id) write
    #update the record:
    place::address::update $switch address
}

ad_returnredirect contact-view?contact_id=$contact_id