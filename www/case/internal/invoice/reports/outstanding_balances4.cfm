<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="../check_rights.cfm">

<cfif not isDefined('form.beg_date')>
	<cfset form.beg_date = '09/01/2004'>
</cfif>
<cfset form.end_date = '08/31/2005'>
<cfif not isDefined('form.end_date')>
	<cfset form.end_date = #DateFormat(now(), 'mm/dd/yyyy')#>
</cfif>

<cfquery name="agents" datasource="caseusa">
select userid, businessname
from smg_users 
where usertype = 8 and userid = 6442 or userid = 6439
order by businessname
</cfquery>
<table>
	<tr>
		<td>Agent</td><td>ISE</td><td>INTO</td><td>ASA</td><td>DMD</td><td>SMG</td><td>Total</td>
	</tr>
<tr>
<cfoutput query=agents>
<td>#businessname#</td>
<cfloop list='1,2,3,4,5' index="x" >
	<cfquery name="charges_unpaid" datasource="caseusa">

		SELECT smg_charges.amount_due, smg_charges.chargeid, smg_payment_charges.amountapplied 
		FROM smg_charges 
		LEFT JOIN smg_payment_charges ON smg_payment_charges.chargeid = smg_charges.chargeid 
		WHERE smg_payment_charges.chargeid IS NULL  AND smg_charges.agentid = #userid#  
		and (date between #CreateODBCDateTime(form.beg_Date)# and #CreateODBCDateTime(form.end_date)#) and companyid = #x#
			
	
	</cfquery>
	<cfif charges_unpaid.recordcount eq 0><cfset amount_due = 0><cfelse><cfset amount_due=#charges_unpaid.amount_due#></cfif>
			<td>#LsCurrencyFormat(amount_due,'local')#</td> <cfif #x# eq 5>
			<cfquery name="agent_total" datasource="caseusa">
							SELECT sum( smg_charges.amount_due ) AS amount_due 
				FROM smg_charges 
				INNER JOIN smg_users ON smg_users.userid = smg_charges.agentid 
				LEFT JOIN smg_payment_charges ON smg_payment_charges.chargeid = smg_charges.chargeid 
				WHERE smg_payment_charges.chargeid IS NULL  
				and agentid = #userid#
				and (date between #CreateODBCDateTime(form.beg_Date)# and #CreateODBCDateTime(form.end_date)#) 	
			</cfquery>
			<td>#agent_total.amount_due#</td>
			</tr><tr></cfif>
</cfloop>
</cfoutput> 
</tr>