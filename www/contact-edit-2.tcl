ad_page_contract {
    Form recipient of Address Book Add/Edit Page

    @author John Mileham (jmileham@arsdigita.com)
} {
    contact_id:integer,notnull
    first_names
    last_name
    title
    organization
}

set user_id [ad_conn user_id]
set instance_id [ad_conn package_id]
set peeraddr [ad_conn peeraddr]

ad_require_permission $instance_id read
ad_require_permission $contact_id write

db_dml update_contact {
    update ab_contacts
       set first_names = :first_names,
           last_name = :last_name,
           title = :title,
           organization= :organization
     where contact_id = :contact_id
}

# We're outta here

ad_returnredirect contact-view?contact_id=$contact_id

    

