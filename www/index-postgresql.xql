<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="package_name">      
      <querytext>
         select acs_object__name(:instance_id);
      </querytext>
</fullquery>

<fullquery name="sql_query">
  <querytext>
    select contact_id,
           coalesce(last_name,'<br />') as last_name,
           coalesce(first_names,'<br />') as first_names,
           coalesce(title,'<br />') as title,
           coalesce(organization,'<br />') as organization,
           coalesce(work_phone,'<br />') as work_phone,
           coalesce(home_phone,'<br />') as home_phone,
           coalesce(fax,'<br />') as fax,
           coalesce(other,'<br />') as other,
           coalesce(email,'<br />') as email,
           acs_permission__permission_p(acr.rel_id,:user_id,'delete') as delete_p,
           acr.rel_id
      from ab_contacts_related acr
     where acs_permission__permission_p(contact_id,:user_id,'read') = 't'
       and object_id = :instance_id
      [value_if_exists search_filter]
  </querytext>
</fullquery>
 
 
</queryset>
