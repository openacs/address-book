<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="create_ab_contact">      
      <querytext>
	 select ab_contact__new(:contact_id, :user_id, :peeraddr, :instance_id,
	                        :first_names, :last_name, :title, :organization,
	                        :instance_id, 'ab_contact');
	
      </querytext>
</fullquery>

 
<fullquery name="grant_admin_to_contact_creator">      
      <querytext>

	 select acs_permission__grant_permission(:contact_id, :user_id, 'admin');
	
      </querytext>
</fullquery>

 
<fullquery name="insert_ab_contact_attrs">      
      <querytext>
      FIX ME PLSQL
FIX ME PLSQL
begin $plsql_block end;
      </querytext>
</fullquery>

 
</queryset>
