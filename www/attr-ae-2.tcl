ad_page_contract {
    Form recipient of address-book address add-edit page

    @author John Mileham (jmileham@arsdigita.com)
} {
    attr_id:integer
    attr_type
    attr_value:trim
    contact_id:integer
}

set user_id [ad_verify_and_get_user_id]
set instance_id [ad_conn package_id]
set peeraddr [ad_conn peeraddr]

ad_require_permission $instance_id read

if ![db_string attr_exists_p {select decode(count(*),0,0,1) from ab_contact_attrs where attr_id = :attr_id}] {
  ad_require_permission $contact_id create
  #if the attribute text is actually there:
  if ![empty_string_p $attr_value] {
    #insert the attribute
    db_exec_plsql insert_ab_contact_attr {
	begin
	  :1 :=
	    ab_contact_attr.new(creation_user => :user_id,
	                        creation_ip => :peeraddr,
	                        context_id => :contact_id,
	                        contact_id => :contact_id,
	                        type_key => :attr_type,
	                        value => :attr_value);
	end;
    }
  } 
} else {
  ad_require_permission $attr_id write
  #update the attribute
  if ![empty_string_p $attr_value] {
    db_dml update_ab_contact_attr {
	update ab_contact_attrs
	   set type_key = :attr_type, value = :attr_value
	 where attr_id = :attr_id
    }
  } else {
      db_exec_plsql delete_empty_attr "begin ab_contact_attr.delete(:attr_id); end;"
  }
}

ad_returnredirect contact-view?contact_id=$contact_id