<?xml version="1.0"?>
<queryset>

<fullquery name="grab_addresses">      
      <querytext>
      
    select address_id,
           address_name,
           line_one,
           line_two,
           line_three,
           line_four,
           municipality_name,
           region_id,
           postal_code,
           country_id,
           rel_id
      from pl_addresses_located
     where locatee_id = :contact_id
  order by sort_key

      </querytext>
</fullquery>

 
</queryset>
