<cftransaction action="BEGIN" isolation="SERIALIZABLE">
<CFQUERY name="selectdb" datasource="caseusa">
USE smg
</CFQUERY>
<cfif form.name is not ''>
<cfquery name="insert_fam_ref1" datasource="caseusa">
insert into smg_suggested_families(name, address, address2, city, state, zip, phone, suggestedby, date_suggested)
	values('#form.name#', '#form.address#', '#form.address2#', '#form.city#', '#form.state#', #form.zip#, '#form.phone#', #client.hostid#, #now()#)
</cfquery>
</cfif>
<cfif form.name2 is not ''>
<cfquery name="insert_fam_ref2" datasource="caseusa">
insert into smg_suggested_families(name, address, address2, city, state, zip, phone, suggestedby, date_suggested)
	values('#form.name2#', '#form.address_2#', '#form.address2_2#', '#form.city2#', '#form.state2#', #form.zip2#, '#form.phone2#', #client.hostid#, #now()#)
</cfquery>
</cfif>
</cftransaction>
<cflocation url="../forms/family_App_15.cfm" addtoken="no">