ad_page_contract {
    Deletes an attribute

    @author John Mileham (jmileham@arsdigita.com)
} {
    attr_id:integer,notnull
}

set instance_id [ad_conn package_id]

ad_require_permission $instance_id read
ad_require_permission $attr_id delete

set contact_id [db_string contact_id {
    select contact_id
      from ab_contact_attrs
     where attr_id = :attr_id
}]

db_exec_plsql delete_attr {
    begin ab_contact_attr.delete(:attr_id); end;
}

ad_returnredirect contact-view?contact_id=$contact_id