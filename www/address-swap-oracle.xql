<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_other_rel_id">      
      <querytext>
      select rel_id from (select rel_id from addresses_located where sort_key $operator (select sort_key from location_rels where rel_id = :rel_id) and locatee_id = :contact_id order by sort_key $direction) sq where rownum = 1
      </querytext>
</fullquery>

 
<fullquery name="swap_location_rel_sort_key">      
      <querytext>
      
    begin
      location_rel.swap_sort(rel_id_one => :rel_id,
                             rel_id_two => :other_rel_id);
    end;

      </querytext>
</fullquery>

 
</queryset>
