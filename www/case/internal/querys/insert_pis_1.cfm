<cfif form.state EQ '0' OR form.region EQ '0'>
	<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
		<tr><td>You must select state and region in order to continue. Please go back and try again.</td></tr>
		<tr><td align="center">	<a href="javascript:history.back()"><img src="../pics/back.gif" border="0"></a></td>
	</table>	
	<cfabort>
</cfif>

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

<cftransaction action="BEGIN" isolation="SERIALIZABLE">
<cfquery name="insert_host_page_1" datasource="caseusa">
	INSERT INTO smg_hosts 
		(familylastname, fatherlastname, fatherfirstname, fathermiddlename, fatherbirth, fatherdob, fatherssn, fatherworktype,
		motherfirstname, motherlastname, mothermiddlename, motherbirth, motherdob, motherssn, motherworktype,
		address, address2, city, state, zip, phone, email, companyid, regionid, arearepid)
	VALUES 
		( '#form.familyname#', '#form.fatherlast#', '#form.fatherfirst#', '#form.fathermiddle#', 
		<cfif form.fatherbirth is ''>'0'<cfelse>'#form.fatherbirth#'</cfif>,
		<cfif form.fatherdob EQ ''>NULL <cfelse> #CreateODBCDate(form.fatherdob)# </cfif>,
		'#EncryptFatherSSN#',	
		'#form.fatherocc#',	'#form.motherfirst#', '#form.motherlast#', '#form.mothermiddle#',
		<cfif form.motherbirth is ''>'0'<cfelse>'#form.motherbirth#'</cfif>,
		<cfif form.motherdob EQ ''>NULL <cfelse> #CreateODBCDate(form.motherdob)# </cfif>,
		'#EncryptMotherSSN#',
		'#form.motherocc#', '#form.address#', '#form.address2#', '#form.city#', '#form.state#', 
		'#form.zip#', '#form.phone#', '#form.email#', '#client.companyid#', '#form.region#', '#form.userid#')  
</cfquery>

<cfquery name="get_host_id" datasource="caseusa">
	Select Max(hostid) as hostid
	from smg_hosts
</cfquery>

<cfset client.hostid = #get_host_id.hostid#>
</cftransaction>

<cfoutput>

<cflocation url="../index.cfm?curdoc=forms/host_fam_pis_2" addtoken="No">

</cfoutput>
</body>
</html>
