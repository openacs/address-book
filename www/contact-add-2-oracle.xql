<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="create_ab_contact">      
      <querytext>
      
	    begin
	     :1 :=
	      ab_contact.new(contact_id => :contact_id,
	                     creation_user => :user_id,
	                     creation_ip => :peeraddr,
	                     context_id => :instance_id,
	                     first_names => :first_names,
	                     last_name => :last_name,
	                     title => :title,
	                     organization => :organization,
	                     object_id => :instance_id,
	                     category => 'ab_contact');
	    end;
	
      </querytext>
</fullquery>

 
<fullquery name="grant_admin_to_contact_creator">      
      <querytext>
      
	    begin acs_permission.grant_permission(object_id => :contact_id,
	                                          grantee_id => :user_id,
	                                          privilege => 'admin');
	    end;
	
      </querytext>
</fullquery>

 
<fullquery name="insert_ab_contact_attrs">      
      <querytext>
      begin $plsql_block end;
      </querytext>
</fullquery>

 
</queryset>
