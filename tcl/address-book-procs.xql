<?xml version="1.0"?>
<queryset>

<fullquery name="ab::contact::1row.get_contact_info">      
      <querytext>
      
	select last_name,
	       first_names,
	       title,
	       organization
	  from ab_contacts
	 where contact_id = :contact_id
    
      </querytext>
</fullquery>

 
<fullquery name="ab::contact_attr::multirow.get_contact_attrs">      
      <querytext>
      
	select attr_id,
               type_name,
	       value
	  from ab_contact_attr_types acat,
	       ab_contact_attrs aca
	 where acat.type_key = aca.type_key
	   and aca.contact_id = :contact_id
      order by sort_key
      </querytext>
</fullquery>

 
<fullquery name="ab::contact::displaywidget.get_contact_attributes">      
      <querytext>
      
	select type_name,
	       value
	  from ab_contact_attr_types acat,
	       ab_contact_attrs aca
	 where acat.type_key = aca.type_key
	   and aca.contact_id = :contact_id
      order by sort_key
    
      </querytext>
</fullquery>

 
<fullquery name="ab::contact::displaywidget.get_addresses">      
      <querytext>
      
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
    
      </querytext>
</fullquery>

 
</queryset>
