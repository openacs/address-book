<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="delete_location_rel">      
      <querytext>
      FIX ME PLSQL
FIX ME PLSQL

	begin
	  location_rel__delete(:rel_id);
	end;
    
      </querytext>
</fullquery>

 
<fullquery name="delete_orphan_address">      
      <querytext>
      FIX ME PLSQL
FIX ME PLSQL

	    declare
	      v_rel_id subplace_rels.rel_id%TYPE;
	      cursor subplace_rel_cursor is
	        select sr.rel_id
	          from subplace_rels sr,
	               acs_rels ar
	         where ar.rel_id = sr.rel_id
	           and ar.object_id_two = :address_id;
	    begin
	      open subplace_rel_cursor;
	      fetch subplace_rel_cursor into v_rel_id;
	      if not subplace_rel_cursor%NOTFOUND then
	        subplace_rel__delete(v_rel_id);
	      end if;
	      close subplace_rel_cursor;
	      pl_address__delete(:address_id);
	    end;
	
      </querytext>
</fullquery>

 
</queryset>
