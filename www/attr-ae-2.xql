<?xml version="1.0"?>
<queryset>

<fullquery name="attr_exists_p">      
      <querytext>
      select case when count(*) = 0 then 0 else 1 end from ab_contact_attrs where attr_id = :attr_id
      </querytext>
</fullquery>

 
<fullquery name="update_ab_contact_attr">      
      <querytext>
      
	update ab_contact_attrs
	   set type_key = :attr_type, value = :attr_value
	 where attr_id = :attr_id
    
      </querytext>
</fullquery>

 
</queryset>
