<cfif cgi.SERVER_PORT eq 443 and ssn is not ''>
<cfset key='BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR'>
<cfset encryptedssn = encrypt(form.ssn, key, "desede", "hex")>
<cfelse>
<cfset encryptedssn = #form.ssn#>
</cfif>

<cfquery name="update_household_member" datasource="caseusa">
	update smg_user_family
	set firstname = '#form.firstname#',
		lastname = '#form.lastname#',
		middlename = '#form.middlename#',
		relationship = '#form.relationship#',
		dob = #CreateODBCDate(form.dob)#,
		ssn= '#encryptedssn#'
	where id = #form.edit#
</cfquery>
<cflocation url="../index.cfm?curdoc=forms/edit_family_members&userid=#url.userid#">