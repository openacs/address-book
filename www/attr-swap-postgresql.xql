<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="get_other_attr_id">      
      <querytext>

        select attr_id
        from (select attr_id, sort_key
              from ab_contact_attrs
              where sort_key $operator (select sort_key
                                        from ab_contact_attrs
                                        where attr_id = :attr_id) and
                  contact_id = :contact_id)
        order by sort_key $direction
        limit 1

      </querytext>
</fullquery>

 
<fullquery name="swap_attribute_sort_key">      
      <querytext>

         select ab_contact_attr__swap_sort(:attr_id, :other_attr_id);

      </querytext>
</fullquery>

 
</queryset>
