<?xml version="1.0"?>
<queryset>

<fullquery name="update_contact">      
      <querytext>
      
    update ab_contacts
       set first_names = :first_names,
           last_name = :last_name,
           title = :title,
           organization= :organization
     where contact_id = :contact_id

      </querytext>
</fullquery>

 
</queryset>
