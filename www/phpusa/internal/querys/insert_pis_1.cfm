<cftransaction action="BEGIN" isolation="SERIALIZABLE">
<cfquery name="insert_host_page_1" datasource="mysql">
insert into smg_hosts (familylastname, fatherlastname, fatherfirstname, fatherbirth,  fatherworktype,
						father_cell, fatherSSN,
						motherfirstname, motherlastname, motherbirth,motherworktype, mother_cell, motherSSN, 
						address, address2, city, state, zip, phone, email, companyid)
		values ( '#form.familyname#', '#form.fatherlast#', '#form.fatherfirst#', 
				<cfif form.fatherdob is ''>'0',<cfelse>'#form.fatherdob#',</cfif>
				'#form.fatherocc#','#form.fathercell#','#form.fatherssn#','#form.motherfirst#', '#form.motherlast#', 
				<cfif form.motherdob is ''>'0',<cfelse>'#form.motherdob#',</cfif>
				'#form.motherocc#','#form.mothercell#','#form.motherssn#', '#form.address#', '#form.address2#', '#form.city#', '#form.state#', 
				'#form.zip#', '#form.phone#', '#form.email#', #client.companyid#)  
</cfquery>

<cfquery name="get_host_id" datasource="mysql">
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