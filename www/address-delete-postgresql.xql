<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="delete_location_rel">      
      <querytext>

	select location_rel__delete(:rel_id);
    
      </querytext>
</fullquery>

 
<fullquery name="delete_orphan_address">      
      <querytext>

          select pl_address__delete_orphan_address(:address_id);
	
      </querytext>
</fullquery>

 
</queryset>
