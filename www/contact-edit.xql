<?xml version="1.0"?>
<queryset>

<fullquery name="grab_contact_info">      
      <querytext>
      
    select first_names,
           last_name,
           title,
           organization
      from ab_contacts
     where contact_id = :contact_id

      </querytext>
</fullquery>

 
</queryset>
