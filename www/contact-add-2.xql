<?xml version="1.0"?>
<queryset>

<fullquery name="contact_exists_p">      
      <querytext>
      select case when count(*) = 0 then 0 else 1 end from ab_contacts where contact_id = :contact_id
      </querytext>
</fullquery>

 
</queryset>
