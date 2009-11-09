<cfoutput>

<Cfif form.firstname is '' and form.lastname is '' and not isDefined('form.no_members')>
	<cflocation url="../index.cfm?curdoc=user_info&userid=#url.userid#">
<cfelseif isDefined('form.no_members')>
	<cfquery name="no_mem" datasource="mysql">
	insert into smg_user_family(userid, no_members)
		values(#form.userid#, 1)
	</cfquery>
	<cflocation url="../index.cfm?curdoc=forms/edit_family_members&userid=#url.userid#">
<cfelse>
	<Cfquery name="check_for_no_members" datasource="mysql">
	delete 	from 
	smg_user_family
	where userid = #form.userid# and no_members = 1
	</Cfquery>
	<cfset key='BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR'>
<cfset encryptedssn = encrypt("#form.ssn#", key, "desede", "hex")>
	<cfquery name="new_fam_member" datasource="MySQL">
	insert into smg_user_family (userid, firstname, middlename, lastname, relationship, dob, ssn)
	values(#form.userid#,'#form.firstname#', '#form.middlename#', '#form.lastname#','#form.relationship#',#CreateODBCDate(form.dob)#, '#encryptedssn#')
	</cfquery>
	<cflocation url="../index.cfm?curdoc=forms/edit_family_members&userid=#url.userid#">
</cfif>

</cfoutput>
