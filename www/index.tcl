ad_page_contract {

    Address Book Main Page

    @author John Mileham (jmileham@arsdigita.com)
    @creation-date 11/19/2000
    @cvs-id $Id$

} {
    {orderby:optional "last_name"}
    {substr:trim,optional ""}
} -properties {
    instance_name:onevalue
    context_bar:onevalue
    user_id:onevalue
    create_p:onevalue
    admin_p:onevalue
    contact_table:onevalue
    escaped_substr:onevalue
}

set user_id [ad_verify_and_get_user_id]

set instance_id [ad_conn package_id]

ad_require_permission $instance_id read

set instance_name [db_exec_plsql package_name {begin :1 := acs_object.name(:instance_id); end;}]

set context_bar [ad_context_bar]

set create_p [ad_permission_p $instance_id create]

set admin_p [ad_permission_p $instance_id admin]

set escaped_substr [ad_quotehtml $substr]

if ![empty_string_p $substr] {
    regsub -all {'} $substr {''} substr

    regsub -all {%} $substr {} substr

    set like_clause "like '%[string tolower $substr]%'"

    set search_filter "and (lower(last_name) $like_clause
        or lower(first_names) $like_clause
        or lower(title) $like_clause
        or lower(organization) $like_clause
        or lower(work_phone) $like_clause
        or lower(home_phone) $like_clause
        or lower(fax) $like_clause
        or lower(other) $like_clause
        or lower(email) $like_clause)"
}

set datadef {
    { last_name {Last Name} {} {} }
    { first_names {First Name} {} {} }
    { title {Title} {} {} }
    { organization {Organization} {} {} }
    { work_phone {Work Phone} {} {} }
    { home_phone {Home Phone} {} {} }
    { fax {Fax} {} {} }
    { other {Other} {} {} }
    { email {E-Mail} {} {} }
    { links {Actions} no_sort {<td>\[&nbsp;[join [subst {
	"<a href=contact-view?contact_id=$contact_id>View</a>"
	[ad_decode $delete_p t "<a\\ href=contact-delete?contact_id=$contact_id&rel_id=$rel_id>Delete</a>" {}]
    }] "&nbsp;|&nbsp;"]&nbsp;\]} }
}

# This invokes a bunch of functions, which is bad, I think, but maybe it's still way faster than the
# join, 'cause the view meant for joining has been commented out in the permission SQL file... ?

set sql_query "
    select contact_id,
           nvl(last_name,'<br>') as last_name,
           nvl(first_names,'<br>') as first_names,
           nvl(title,'<br>') as title,
           nvl(organization,'<br>') as organization,
           nvl(work_phone,'<br>') as work_phone,
           nvl(home_phone,'<br>') as home_phone,
           nvl(fax,'<br>') as fax,
           nvl(other,'<br>') as other,
           nvl(email,'<br>') as email,
           acs_permission.permission_p(acr.rel_id,:user_id,'delete') as delete_p,
           acr.rel_id
      from ab_contacts_related acr
     where acs_permission.permission_p(contact_id,:user_id,'read') = 't'
       and object_id = :instance_id
      [value_if_exists search_filter]
"
append sql_query [ad_order_by_from_sort_spec $orderby $datadef]

if { $instance_id && $user_id } {
    set pee 1
}
set bind_vars [ad_tcl_vars_to_ns_set instance_id user_id]

set contact_table [ad_table -Torderby $orderby -bind $bind_vars address_book_listing $sql_query $datadef]
      
ad_return_template