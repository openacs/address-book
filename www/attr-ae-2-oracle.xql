<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="insert_ab_contact_attr">      
      <querytext>
      
	begin
	  :1 :=
	    ab_contact_attr.new(creation_user => :user_id,
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
      begin ab_contact_attr.delete(:attr_id); end;
      </querytext>
</fullquery>

 
</queryset>
