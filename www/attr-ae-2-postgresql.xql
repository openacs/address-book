<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="insert_ab_contact_attr">      
      <querytext>
      FIX ME PLSQL
FIX ME PLSQL

	begin
	  :1 :=
	    ab_contact_attr__new(creation_user => :user_id,
	                        creation_ip => :peeraddr,
	                        context_id => :contact_id,
	                        contact_id => :contact_id,
	                        type_key => :attr_type,
	                        value => :attr_value);
	end;
    
      </querytext>
</fullquery>

 
<fullquery name="delete_empty_attr">      
      <querytext>
      FIX ME PLSQL
FIX ME PLSQL
begin ab_contact_attr__delete(:attr_id); end;
      </querytext>
</fullquery>

 
</queryset>
