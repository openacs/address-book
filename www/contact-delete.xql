<?xml version="1.0"?>
<queryset>

<fullquery name="orphan_contact">      
      <querytext>
      select case when count(*) = 0 then 1 else 0 end from ab_contacts_related where contact_id = :contact_id
      </querytext>
</fullquery>

 
<fullquery name="contact_is_orphan_p">      
      <querytext>
      select case when count(*) = 0 then 0 else 1 end from acs_objects where object_id = :contact_id and object_type = 'ab_contact'
      </querytext>
</fullquery>

 
</queryset>
