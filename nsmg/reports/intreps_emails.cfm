<cfquery name="int_agents" datasource="MySql">
	SELECT businessname, email
	FROM smg_users
	INNER JOIN smg_countrylist c ON country = c.countryid
	WHERE active = '1' and usertype = '8'
	AND c.continent != 'asia'
	ORDER BY businessname
</cfquery>


<cfoutput>
	<table>
	<tr><td>Business Name</td><td>Email Address</td></tr>
	<cfloop query="int_agents">
	<tr><td>#businessname#</td><td>#email#</td></tr>
	</cfloop>
	</table>

 </cfoutput>