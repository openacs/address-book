<master src="master">
<property name="title">@instance_name@</property>
<property name="context_bar">@context_bar@</property>

<form action="./">
<input type=text name=substr size=20 maxlength=40 value=@escaped_substr@>
<input type=submit value=Search>
</form>
<center>
<if @escaped_substr@ not nil>
 Displaying all contacts containing the string '@escaped_substr@'. [ <a href=./>Show All</a>  ]
</if>
<p>
@contact_table@
</p>
<p>
<if @create_p@ eq 1>
  [ <a href=contact-add>Add a Contact</a> ]
</if>
</p>
</center>
