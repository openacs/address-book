ad_page_contract {
    Swaps sort keys of two addresses
} {
    rel_id:integer,notnull
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

set contact_id [db_string get_contact_id {select locatee_id from pl_addresses_located where rel_id = :rel_id}]

set other_rel_id [db_string get_other_rel_id "select rel_id from (select rel_id from addresses_located where sort_key $operator (select sort_key from location_rels where rel_id = :rel_id) and locatee_id = :contact_id order by sort_key $direction) sq where rownum = 1"]

ad_require_permission $rel_id write
ad_require_permission $other_rel_id write

db_exec_plsql swap_location_rel_sort_key {
    begin
      location_rel.swap_sort(rel_id_one => :rel_id,
                             rel_id_two => :other_rel_id);
    end;
}

ad_returnredirect contact-view?contact_id=$contact_id
