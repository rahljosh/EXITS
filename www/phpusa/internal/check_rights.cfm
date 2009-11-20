<!----Keep AR's from switching around to other accounts---->
<cfquery name="get_usertype" datasource="MySql">
	SELECT userid, usertype
	FROM user_access_rights
	WHERE userid = <cfqueryparam value="#url.userid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfoutput>

<cfif client.usertype NEQ 0 AND client.usertype GTE 5 AND url.userid NEQ client.userid>
<table>
	<tr>
		<td>
			<br /><img src="pics/error_exclamation.gif" width="37" height="44"></td><td>You do not have access to view this account.<br><br>
			You can view your account by clicking <a href="?curdoc=forms/user_info&userid=#client.userid#">here.<a/><br />
		</td>
	</tr>
</table>
<cfabort>
</cfif>

</cfoutput>