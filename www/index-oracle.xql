<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="package_name">      
      <querytext>
      begin :1 := acs_object.name(:instance_id); end;
      </querytext>
</fullquery>

 
</queryset>
