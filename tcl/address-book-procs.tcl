# packages/address-book/tcl/address-book-procs.tcl
ad_library {
    Procs related to the address-book package

    @author John Mileham (jmileham@arsdigita.com)
    @cvs-id $Id$
}

namespace eval ab {
    namespace eval contact {}
    namespace eval contact_attr {}
    namespace eval contact_attr_type {}
}

ad_proc ab::contact::1row {
    contact_id
    {out_datasource_name "contact"}
} {
    Creates a 1row datasource for a contact and stores it to the datasource described by
    <code>out_datasource_name</code>.  This doesn't include attributes, just basic elements.

    @param contact_id The <code>contact_id</code> of the contact we want the info on
    @param out_datasource_name The name of the datasource we're storing to
    @author John Mileham (jmileham@arsdigita.com)
} {
    upvar $out_datasource_name my_contact
    db_1row get_contact_info {
	select last_name,
	       first_names,
	       title,
	       organization
	  from ab_contacts
	 where contact_id = :contact_id
    } -column_array my_contact
}

ad_proc ab::contact_attr::multirow {
    contact_id
    {out_datasource_name "contact_attrs"}
} {
    Creates a multirow datasource containing all attributes asssociated with a contact
    in sort order.

    @param contact_id The <code>contact_id</code> of the contact we want the attributes of
    @param out_datasource_name The name of the datasource we're storing to
    @author John Mileham (jmileham@arsdigita.com)
} {
    uplevel [list db_multirow $out_datasource_name get_contact_attrs "
	select attr_id,
               type_name,
	       value
	  from ab_contact_attr_types acat,
	       ab_contact_attrs aca
	 where acat.type_key = aca.type_key
	   and aca.contact_id = :contact_id
      order by sort_key"]
}





ad_proc ab::contact::displaywidget {
    contact_id
} {
    Returns a display widget for a contact

    @param contact_id The <code>contact_id</code> of the widget to be displayed
    @author John Mileham (jmileham@arsdigita.com)
} {
    ab::contact::1row $contact_id contact

    set widget "<table>
<tr>
<td align=left>First Name:</td>
<td>$contact(first_names)</td>
</tr>
<tr>
<td align=left>Last Name:</td>
<td>$contact(last_name)</td>
</tr>
<tr>
<td align=left>Title:</td>
<td>$contact(title)</td>
</tr>
<tr>
<td align=left>Organization:</td>
<td>$contact(organization)</td>
</tr>

<tr>
<td colspan=2><hr></td>
</tr>

"

    db_foreach get_contact_attributes {
	select type_name,
	       value
	  from ab_contact_attr_types acat,
	       ab_contact_attrs aca
	 where acat.type_key = aca.type_key
	   and aca.contact_id = :contact_id
      order by sort_key
    } {
	append widget "<tr>
<td align=left>$type_name:</td>
<td>$value</td>
</tr>
"
    } if_no_rows {
	append widget "<tr>
<td></td>
<td><i>No Attributes Found</i></td>
</tr>
"
    }

    append widget "
<tr>
<td colspan=2><hr></td>
</tr>
"

    set n 0
    db_foreach get_addresses {
	select address_id,
	       address_name,
	       line_one,
	       line_two,
	       line_three,
	       line_four,
	       municipality_name,
	       region_id,
	       postal_code,
	       country_id
	  from addresses_located
	 where locatee_id = :contact_id
      order by sort_key
    } -column_array address {
	incr n
	append widget "<tr>
<td align=left valign=top>Address #$n:</td>
<td valign=top>[place::address::displaywidget -in_datasource_name address]</td>
</tr>
"
    }

    append widget "</table>
"

    return $widget
}

ad_proc ab::contact_attr_type::select {
    {
	-default {}
    }
    {field_name "attr_type"}
} {
    Returns a select widget containing all contact attribute
    types in the database

    @param default <code>type_key</code> of the type to be selected by default
    @param field_name Name carried by the HTML <code>select</code> widget generated
    @author John Mileham (jmileham@arsdigita.com)
} {
    return [ad_db_select_widget -default $default ab_contact_attr_list {select type_name, type_key from ab_contact_attr_types order by type_id} $field_name]
}