<cfif IsDefined('url.studentid')>
	<cfset client.studentid = '#url.studentid#'>
</cfif>

<!--- <cfset newnotes = #Replace(#form.placement_notes#,"#chr(10)#","<br>","all")#> --->
<!--- FORMS/PLACE_NOTES -> #Replace(letter,"<br>","#chr(10)#","all")#--->

<cfquery name="update_placement_notes" datasource="caseusa">
	UPDATE smg_Students
	SET placement_notes= <cfqueryparam value = "#form.placement_notes#" cfsqltype="cf_sql_longvarchar">
	WHERE studentid =  <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
	LIMIT 1
</cfquery>

<cflocation url="../forms/place_notes.cfm?studentid=#client.studentid#&update=yes" addtoken="no">