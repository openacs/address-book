<?xml version="1.0"?>
<queryset>

<fullquery name="unique_type_key">      
      <querytext>
      
	select type_key
	  from ab_contact_attr_types
	 where type_id = (select min(type_id)
                            from ab_contact_attr_types
                           where type_key not in (select type_key
                                                    from ab_contact_attrs
                                                   where contact_id = :contact_id))
    
      </querytext>
</fullquery>

 
<fullquery name="first_type_key">      
      <querytext>
      
	    select type_key
	      from ab_contact_attr_types
	     where type_id = (select min(type_id)
	                      from ab_contact_attr_types)
        
      </querytext>
</fullquery>

 
<fullquery name="get_attribute">      
      <querytext>
      select type_key, value from ab_contact_attrs where attr_id = :attr_id
      </querytext>
</fullquery>

 
</queryset>
