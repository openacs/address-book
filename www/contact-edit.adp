<master src="master">
<property name="title">@page_title@</property>
<property name="context_bar">@context_bar@</property>

<form method=post action=contact-edit-2>
@hidden_vars@
<table>
<tr>
<td align=left>First Name:</td>
<td><input type=text size=30 maxlength=200 name=first_names value="@escaped_first_names@"></td>
</tr>
<tr>
<td align=left>Last Name:</td>
<td><input type=text size=30 maxlength=200 name=last_name value="@escaped_last_name@"></td>
</tr>
<tr>
<td align=left>Title:</td>
<td><input type=text size=30 maxlength=200 name=title value="@escaped_title@"></td>
</tr>
<tr>
<td align=left>Organization:</td>
<td><input type=text size=30 maxlength=200 name=organization value="@escaped_organization@"></td>
</tr>
</table>


<center><input type=submit value="@activity@"></center>
</form>

