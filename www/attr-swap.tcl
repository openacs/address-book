ad_page_contract {
    Swaps sort keys of two attributes
} {
    attr_id:integer,notnull
    swap_type:notnull
} -validate {
    swap_type_is_correct -requires {swap_type:notnull} {
	if { [string compare $swap_type prev] != 0 && [string compare $swap_type next] != 0 } {
	    ad_complain "Swap type is neither 'prev' nor 'next'"
	}
    }
}

set instance_id [ad_conn package_id]

ad_require_permission $instance_id read

if { [string compare $swap_type prev] == 0 } {
    set operator <
    set direction desc
} else {
    set operator >
    set direction asc
}

set contact_id [db_string get_contact_id {select contact_id from ab_contact_attrs where attr_id = :attr_id}]

set other_attr_id [db_string get_other_attr_id "select attr_id from (select attr_id from ab_contact_attrs where sort_key $operator (select sort_key from ab_contact_attrs where attr_id = :attr_id) and contact_id = :contact_id order by sort_key $direction) where rownum = 1"]


ad_require_permission $attr_id write
ad_require_permission $other_attr_id write

db_exec_plsql swap_attribute_sort_key {
    begin
      ab_contact_attr.swap_sort(attr_id_one => :attr_id,
                                attr_id_two => :other_attr_id);
    end;
}

ad_returnredirect contact-view?contact_id=$contact_id
