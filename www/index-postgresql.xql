<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="package_name">      
      <querytext>
         select acs_object__name(:instance_id);
      </querytext>
</fullquery>

 
</queryset>
