<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_other_attr_id">      
      <querytext>
      select attr_id from (select attr_id from ab_contact_attrs where sort_key $operator (select sort_key from ab_contact_attrs where attr_id = :attr_id) and contact_id = :contact_id order by sort_key $direction) where rownum = 1
      </querytext>
</fullquery>

 
<fullquery name="swap_attribute_sort_key">      
      <querytext>
      
    begin
      ab_contact_attr.swap_sort(attr_id_one => :attr_id,
                                attr_id_two => :other_attr_id);
    end;

      </querytext>
</fullquery>

 
</queryset>
