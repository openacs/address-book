<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="get_other_rel_id">      
      <querytext>
      FIX ME ROWNUM
select rel_id from (select rel_id from addresses_located where sort_key $operator (select sort_key from location_rels where rel_id = :rel_id) and locatee_id = :contact_id order by sort_key $direction) sq where rownum = 1
      </querytext>
</fullquery>

 
<fullquery name="swap_location_rel_sort_key">      
      <querytext>
      FIX ME PLSQL
FIX ME PLSQL

    begin
      location_rel__swap_sort(rel_id_one => :rel_id,
                             rel_id_two => :other_rel_id);
    end;

      </querytext>
</fullquery>

 
</queryset>
