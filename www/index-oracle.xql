<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="package_name">      
      <querytext>
      begin :1 := acs_object.name(:instance_id); end;
      </querytext>
</fullquery>

<fullquery name="sql_query">
  <querytext>
    select contact_id,
           nvl(last_name,'<br />') as last_name,
           nvl(first_names,'<br />') as first_names,
           nvl(title,'<br />') as title,
           nvl(organization,'<br />') as organization,
           nvl(work_phone,'<br />') as work_phone,
           nvl(home_phone,'<br />') as home_phone,
           nvl(fax,'<br />') as fax,
           nvl(other,'<br />') as other,
           nvl(email,'<br />') as email,
           acs_permission.permission_p(acr.rel_id,:user_id,'delete') as delete_p,
           acr.rel_id
      from ab_contacts_related acr
     where acs_permission.permission_p(contact_id,:user_id,'read') = 't'
       and object_id = :instance_id
      [value_if_exists search_filter]
  </querytext>
</fullquery>
 
</queryset>
