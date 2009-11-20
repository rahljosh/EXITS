<cfdump var="#form#">
<!----
<cfif fatherssn NEQ ''>
	<cfset EncryptFatherSSN = encrypt("#form.fatherssn#", 'BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR', "desede", "hex")>
<cfelse>
	<cfset EncryptFatherSSN = ''>
</cfif>

<cfif motherssn NEQ ''>
	<cfset EncryptMotherSSN = encrypt("#form.motherssn#", 'BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR', "desede", "hex")>
<cfelse>
	<cfset EncryptMotherSSN = ''>
</cfif>
---->
<cftransaction action="BEGIN" isolation="SERIALIZABLE">
<cfquery name="insert_host_page_1" datasource="mysql">
	UPDATE smg_hosts
	SET familylastname='#form.familyname#',
		fatherlastname = '#form.fatherlast#',
		fatherfirstname= '#form.fatherfirst#',
		
		fatherbirth = <cfif form.fatherdob EQ ''>NULL <cfelse> #form.fatherdob# </cfif>,
        <!---
		fatherssn = '#EncryptFatherSSN#',
		---->
		fatherworktype= '#form.fatherocc#',
		father_cell = '#form.fathercell#',
		motherfirstname='#form.motherfirst#',
		motherlastname='#form.motherlast#', 		
		emergency_contact_name = '#form.emergency_contact_name#',
		emergency_phone = '#form.emergency_phone#',
		motherbirth = <cfif form.motherdob EQ ''>NULL <cfelse> #form.motherdob# </cfif>,
        <!----
		motherssn = '#EncryptMotherSSN#',
		---->
		motherworktype='#form.motherocc#',
		mother_cell = '#form.mothercell#',
		address='#form.address#',
		address2= '#form.address2#',
		city='#form.city#',
		state='#form.state#',
		zip='#form.zip#',
		phone='#form.phone#',
		email='#form.email#'
	WHERE hostid = <cfqueryparam value="#form.hostid#" cfsqltype="cf_sql_integer">
	LIMIT 1
</cfquery>

</cftransaction>
<cfoutput>

<cflocation url="../index.cfm?curdoc=forms/host_fam_pis_2" addtoken="No">
</cfoutput>
</body>
</html>
