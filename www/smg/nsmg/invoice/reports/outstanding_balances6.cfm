<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="../check_rights.cfm">



<cfif not isDefined('form.beg_date')>
	<cfset form.beg_date = '09/01/2004'>
</cfif>
<cfset form.end_date = '08/31/2005'>
<cfif not isDefined('form.end_date')>
	<cfset form.end_date = #DateFormat(now(), 'mm/dd/yyyy')#>
</cfif>

<cfquery name="agents" datasource="MySQL">
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
<cfloop list='1,2,3,4,5,12' index="x">
		<!----get the total amount that this agent was charged---->
		<cfquery name="total_charges" datasource="mysql">
		select sum(amount_due) as amount_due
		from smg_charges 
		where agentid = #userid# and companyid = #x#
		and (date between #CreateODBCDateTime(form.beg_Date)# and #CreateODBCDateTime(form.end_date)#) and companyid = #x#
			
		</cfquery>
		<cfif total_charges.amount_due is ''><cfset charges = 0><cfelse><cfset charges = #total_charges.amount_due#></cfif>
		
		
		<!----get the total amount that this agent has paid---->
		<cfquery name="total_paid" datasource="mysql">
		select sum(totalreceived) as total_paid
		from smg_payment_received
		where agentid = #userid# and companyid =#x#
		and (date between #CreateODBCDateTime(form.beg_Date)# and #CreateODBCDateTime(form.end_date)#) and companyid = #x#
			
		</cfquery>
		<cfif total_paid.total_paid is ''><cfset paid = 0><cfelse><cfset paid = #total_paid.total_paid#></cfif>
		<cfset due = #charges# - #paid#>
		
		
<td>#LsCurrencyFormat(due,'local')# </td> <cfif #x# eq 5>

<cfquery name="ttotal_charges" datasource="mysql">
		select sum(amount_due) as amount_due
		from smg_charges 
		where agentid = #userid# 
		and (date between #CreateODBCDateTime(form.beg_Date)# and #CreateODBCDateTime(form.end_date)#) and companyid = #x#
			
		</cfquery>
		<cfif ttotal_charges.amount_due is ''><cfset charges = 0><cfelse><cfset charges = #ttotal_charges.amount_due#></cfif>
		
		<cfquery name="ttotal_paid" datasource="mysql">
		select sum(totalreceived) as total_paid
		from smg_payment_received
		where agentid = #userid#
		and (date between #CreateODBCDateTime(form.beg_Date)# and #CreateODBCDateTime(form.end_date)#) and companyid = #x#
			
		</cfquery>
		<cfif ttotal_paid.total_paid is ''><cfset paid = 0><cfelse><cfset paid = #ttotal_paid.total_paid#></cfif>
		
		<cfset tamount_due = #ttotal_charges.amount_due# - #ttotal_paid.total_paid#>
		<td>#tamount_due#</td></tr><tr>
</tr></cfif>
</cfloop>



</cfoutput>

</table>
