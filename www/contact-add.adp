<master>
<property name=>@page_title@</property>
<property name="context">@context@</property>

<form method=post action=contact-add-2>
@hidden_vars@
<table>
<tr>
<td alignleft>First Name:</td>
<td><input type=text size=30 maxlength=200 name=first_names value="@escaped_first_names@"></td>
</tr>
<tr>
<td alignleft>Last Name:</td>
<td><input type=text size=30 maxlength=200 name=last_name value="@escaped_last_name@"></td>
</tr>
<tr>
<td alignleft>Title:</td>
<td><input type=text size=30 maxlength=200 name=title value="@escaped_title@"></td>
</tr>
<tr>
<td alignleft>Organization:</td>
<td><input type=text size=30 maxlength=200 name=organization value="@escaped_organization@"></td>
</tr>

<tr>
<td colspan=2><hr></td>
</tr>

<multiple name=attribute>
 <tr>
 <input type=hidden name=attr_id value=@attribute.attr_id@>
 <td align=left>@attribute.attr_types_dropdown@</td>
 <td><input type=text size=30 maxlength=200 name=attr_value value="@attribute.escaped_value@"></td>
 </tr>
</multiple>
<if @attribute:rowcount@ eq 0>
<tr>
<td></td>
<td><i>No Attributes Found</i></td>
</tr>
</if>

<tr>
<td colspan=2><hr></td>
</tr>

<tr>
 @address.hidden_fields_w@
 <td align=left>Address:</td>
 <td>@address.line_one_w@</td>
</tr>
<tr>
 <td align=left>City, State ZIP:</td>
 <td>@address.municipality_name_w@, @address.region_id_w@ @address.postal_code_w@</td>
</tr>
<tr>
 <td align=left>Country:</td>
 <td>@address.country_id_w@</td>
</tr>
</table>


<center><input type=submit value="@activity@"></center>
</form>
