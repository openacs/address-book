<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="insert_ab_contact_attr">      
      <querytext>

	select ab_contact_attr__new(:user_id, :peeraddr, :contact_id, :contact_id,
	                            :attr_type, :attr_value);
    
      </querytext>
</fullquery>

 
<fullquery name="delete_empty_attr">      
      <querytext>

        select ab_contact_attr__delete(:attr_id);

      </querytext>
</fullquery>

 
</queryset>
