<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="get_other_rel_id">      
      <querytext>
        select rel_id
        from (select rel_id, sort_key
              from addresses_located
              where sort_key $operator (select sort_key
                                        from location_rels
                                        where rel_id = :rel_id) and
                  locatee_id = :contact_id)
        order by sort_key $direction sq
        limit 1
      </querytext>
</fullquery>

 
<fullquery name="swap_location_rel_sort_key">      
      <querytext>

        select location_rel__swap_sort(rel_id_one => :rel_id, rel_id_two => :other_rel_id);

      </querytext>
</fullquery>

 
</queryset>
