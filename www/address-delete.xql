<?xml version="1.0"?>
<queryset>

<fullquery name="orphan_address">      
      <querytext>
      select case when count(*) = 0 then 1 else 0 end from place_element_map where place_id = :address_id
      </querytext>
</fullquery>

 
<fullquery name="address_is_orphan_p">      
      <querytext>
      select case when count(*) = 0 then 0 else 1 end from acs_objects where object_id = :address_id and object_type = 'pl_address'
      </querytext>
</fullquery>

 
</queryset>
