<master>
<property name=title>@page_title@</property>
<h2>@page_title@</h2>
@context_bar@
<hr>
<blockquote>
<table>
<tr>
<td valign=top align=left>First Name:</td>
<td valign=top>@contact.first_names@</td>
<if @write_p@ eq 1>
  <td valign=top>
  [ <a href=contact-edit?contact_id=@contact_id@>Edit Contact</a> ]
  </td>
</if>
</tr>
<tr>
<td valign=top align=left>Last Name:</td>
<td valign=top>@contact.last_name@</td>
</tr>
<tr>
<td valign=top align=left>Title:</td>
<td valign=top>@contact.title@</td>
</tr>
<tr>
<td valign=top align=left>Organization:</td>
<td valign=top>@contact.organization@</td>
</tr>
<tr>
<td colspan=3><hr></td>
</tr>

<multiple name=contact_attr>
  <tr>
  <td valign=top align=left>@contact_attr.type_name@:</td>
  <td valign=top>@contact_attr.value@</td>
  <td valign=top>
  <if @write_p@ eq 1>
                 [ <a href=attr-ae?contact_id=@contact_id@&attr_id=@contact_attr.attr_id@>Edit</a> |
                   <a href=attr-delete?contact_id=@contact_id@&attr_id=@contact_attr.attr_id@>Delete</a>
  </if>
  <if @contact_attr.rownum@ ne 1 and @write_p@ eq 1>
    <if @write_p@ eq 1>
      |
    </if>
    <else>
      [
    </else>
    <a href=attr-swap?swap_type=prev&attr_id=@contact_attr.attr_id@>Swap Prev</a>
     ]
  </if>
  <else>
   <if @write_p@ eq 1>
    ]
   </if>
  </else>
  </td>
  </tr>
</multiple>
<if @create_p@ eq 1>
  <tr>
  <td valign=top colspan=2><br>[ <a href=attr-ae?contact_id=@contact_id@>Add Attribute</a> ]</td>
  </tr>
</if>
<tr>
<td valign=top colspan=3><hr></td>
</tr>
<multiple name=address>
  <tr>
  <td valign=top colspan=2>@address.displaywidget@</td>
  <td valign=top>
  <if @address.write_p@ eq 1>
                 [ <a href=address-ae?contact_id=@contact_id@&address_id=@address.address_id@>Edit</a>
    <if @address.rel_delete_p@ eq 1>
		 |
	           <a href=address-delete?contact_id=@contact_id@&address_id=@address.address_id@&rel_id=@address.rel_id@>Delete</a>
    </if>
  </if>
  <if @address.rownum@ ne 1 and @address.rel_write_p@ eq 1>
    | <a href=address-swap?swap_type=prev&rel_id=@address.rel_id@>Swap Prev</a> ]
  </if>
  <else>
   <if @address.write_p@ eq 1>
    ]
   </if>
  </else>
  </td>
  </tr>
</multiple>
<if @create_p@ eq 1>
  <tr>
  <td valign=top colspan=2><br>[ <a href=address-ae?contact_id=@contact_id@>Add Address</a> ]</td>
  </tr>
</if>
</table>
</blockquote>
