<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="delete_ab_contact_rel">      
      <querytext>

	 select ab_contact_rel__delete(:rel_id);
    
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

	 -- Delete the contact, blowing away orphan addresses.
	 ab_contact__delete(contact_id => :contact_id,
	                    delete_orphan_addresses_p => 't');
	
      </querytext>
</fullquery>

 
</queryset>
