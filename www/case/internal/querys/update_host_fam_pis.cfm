<cfif IsDefined('form.fatherssn') AND form.fatherssn NEQ ''>
	<cfset EncryptFatherSSN = encrypt("#form.fatherssn#", 'BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR', "desede", "hex")>
<cfelse>
	<cfset EncryptFatherSSN = ''>
</cfif>

<cfif IsDefined('form.motherssn') AND form.motherssn NEQ ''>
	<cfset EncryptMotherSSN = encrypt("#form.motherssn#", 'BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR', "desede", "hex")>
<cfelse>
	<cfset EncryptMotherSSN = ''>
</cfif>

<cftransaction action="BEGIN" isolation="SERIALIZABLE">
<cfquery name="insert_host_page_1" datasource="caseusa">
	UPDATE smg_hosts
	SET familylastname='#form.familyname#',
		fatherlastname = '#form.fatherlast#',
		fathermiddlename = '#form.fathermiddle#',
		fatherfirstname= '#form.fatherfirst#',
		<cfif form.fatherbirth is ''>fatherbirth= '0'<cfelse>fatherbirth= '#form.fatherbirth#'</cfif>,
		fatherdob = <cfif form.fatherdob EQ ''>NULL <cfelse> #CreateODBCDate(form.fatherdob)# </cfif>,
		<cfif IsDefined('form.fatherssn')>fatherssn = '#EncryptFatherSSN#',</cfif>
		fatherworktype= '#form.fatherocc#',
		
		motherfirstname='#form.motherfirst#',
		mothermiddlename = '#form.mothermiddle#',
		motherlastname='#form.motherlast#', 		
		<cfif form.motherbirth is ''>motherbirth= '0'<cfelse>motherbirth= '#form.motherbirth#'</cfif>,
		motherdob = <cfif form.motherdob EQ ''>NULL <cfelse> #CreateODBCDate(form.motherdob)# </cfif>,
		<cfif IsDefined('form.motherssn')>motherssn = '#EncryptMotherSSN#',</cfif>
		motherworktype='#form.motherocc#',
		 
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
