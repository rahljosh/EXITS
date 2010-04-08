<head>

<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="check_rights.cfm">

<body onLoad="opener.location.reload();setTimeout(window.close, 3000)" > 
</head>
<cfif isDefined ('form.delete')>
<cfquery name="delete_charge" datasource="caseusa">
delete from smg_charges
where chargeid = #form.delete#
</cfquery>
<cfelse>


<cfquery name="update_charge" datasource="caseusa">
update smg_charges 
set type= '#form.type#',
	description='#form.description#',
	amount='#form.amount#', 
	amount_due = '#form.amount#',
	date=#now()#,
	userinput = #client.userid#
where chargeid = #form.chargeid#

</cfquery>
</cfif>

<div align="center"><h2>Charge was successfully updated.  Account window has refreshed and this window will close shortly.</h2></div>
