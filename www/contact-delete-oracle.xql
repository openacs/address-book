<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="delete_ab_contact_rel">      
      <querytext>
      
	begin
	  ab_contact_rel.delete(:rel_id);
	end;
    
      </querytext>
</fullquery>

 
<fullquery name="delete_orphan_address_perms">      
      <querytext>
      
	 delete from acs_permissions
         where object_id = :contact_id;
	
      </querytext>
</fullquery>
 
<fullquery name="delete_orphan_address">      
      <querytext>
      
	    begin

	      -- Delete the contact, blowing away orphan addresses.
	      ab_contact.delete(contact_id => :contact_id,
	                        delete_orphan_addresses_p => 't');
	    end;
	
      </querytext>
</fullquery>

 
</queryset>
