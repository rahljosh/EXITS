<cftransaction action="BEGIN" isolation="SERIALIZABLE">
<CFQUERY name="selectdb" datasource="MySQL">
USE smg
</CFQUERY>
<cfquery name="insert_fam_ref1" datasource="MySQL">
insert into smg_family_references(name, address, address2, city, state, zip, phone, referencefor)
	values('#form.name#', '#form.address#', '#form.address2#', '#form.city#', '#form.state#', #form.zip#, '#form.phone#', #client.hostid#)
</cfquery>
<cfquery name="insert_fam_ref2" datasource="MySQL">
insert into smg_family_references(name, address, address2, city, state, zip, phone, referencefor)
	values('#form.name2#', '#form.address_2#', '#form.address2_2#', '#form.city2#', '#form.state2#', #form.zip2#, '#form.phone2#', #client.hostid#)
</cfquery>
</cftransaction>
<cflocation url="../forms/family_App_14.cfm" addtoken="no">
