<?xml version="1.0"?>
<queryset>

<fullquery name="address_exists_p">      
      <querytext>
      select case when count(*) = 0 then 0 else 1 end from pl_addresses where address_id = :address_id
      </querytext>
</fullquery>

 
</queryset>
