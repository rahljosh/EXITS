<cftransaction action="BEGIN" isolation="SERIALIZABLE">
<cfquery name="insert_host_page_1" datasource="caseusa">
insert into smg_hosts (familylastname, fatherlastname, fatherfirstname, fatherbirth, fatherssn, fathercompany, fatherworkphone, fatherworktype,
						motherfirstname, motherlastname, motherbirth,motherssn,mothercompany,motherworkphone,motherworktype,
						 address, address2, city, state, zip, phone, email)
				values ( '#form.familyname#', '#form.fatherlast#', '#form.fatherfirst#', '#form.fatherdob#',  '#form.fathersocial#', '#form.fatherbusiness#', '#form.fatherbusinessphone#', '#form.fatherocc#',
						'#form.motherfirst#', '#form.motherlast#', '#form.motherdob#', '#form.mothersocial#', '#form.motherbusiness#', '#form.motherbusinessphone#', '#form.motherocc#', 
						'#form.address#', '#form.address2#', '#form.city#', '#form.state#', '#form.zip#', '#form.phone#', '#form.email#') 
						
</cfquery>
<cfquery name="get_host_id" datasource="caseusa">
Select Max(hostid) as hostid
from smg_hosts
</cfquery>
<cfset client.hostid = #get_host_id.hostid#>
</cftransaction>
<cfoutput>

<cflocation url="../index.cfm?curdoc=forms/family_app_2" addtoken="No">
</cfoutput>
</body>
</html>
