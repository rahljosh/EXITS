<cfif form.lastname is not ''>
	<cfquery name="find_user" datasource="mysql">
	select firstname, lastname, email, phone
	from smg_users
	where lastname = '#form.lastname#'
	</cfquery>
<cfelseif form.id is not ''>
	<cfquery name="find_user" datasource="mysql">
	select firstname, lastname, email, phone
	from smg_users
	where userid = #form.id#
	</cfquery>
<cfelseif form.email is not ''>
	<cfquery name="find_user" datasource="mysql">
	select firstname, lastname, email, phone
	from smg_users
	where userid = #form.email#
	</cfquery>
</cfif>

<table>
	<tr>
		<td>Last Name: </td><td>#form.lastname#</td><td></td>
	</tr>
	<tr>
		<td>ID: </td><td>#form.id#</td><td></td>
	</tr>
	<tr>
		<td> Email: </td><td>#form.email#</td><td></td>
	</tr>
</table>

<cfoutput query="find_user">

</cfoutput>