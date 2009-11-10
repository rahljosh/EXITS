<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="../check_rights.cfm">

<style type="text/css">
table{font-size:12px;}
table.nav_bar {  background-color: #ffffff; border: 1px solid #000000; }

.thin-border{ border: 1px solid #000000;}
.thin-border-right{ border-right: 1px solid #000000;}
.thin-border-left{ border-left: 1px solid #000000;}
.thin-border-right-bottom{ border-right: 1px solid #000000; border-bottom: 1px solid #000000;}
.thin-border-bottom{  border-bottom: 1px solid #000000;}
.thin-border-left-bottom{ border-left: 1px solid #000000; border-bottom: 1px solid #000000;}
.thin-border-right-bottom-top{ border-right: 1px solid #000000; border-bottom: 1px solid #000000; border-top: 1px solid #000000;}
.thin-border-left-bottom-top{ border-left: 1px solid #000000; border-bottom: 1px solid #000000; border-top: 1px solid #000000;}
.thin-border-left-bottom-right{ border-left: 1px solid #000000; border-bottom: 1px solid #000000; border-right: 1px solid #000000;}
.thin-border-left-top-right{ border-left: 1px solid #000000; border-top: 1px solid #000000; border-right: 1px solid #000000;}
-->

    </style>
<Cfoutput>
<div align="center"><h2>Outstanding balances as of #DateFormat(now(), 'mm-dd-yyyy')# at #TimeFormat(now(),'h:mm:ss tt')#</h2></div>

<Table width=100% cellpadding=4 cellspacing=0 class="thin-border">
	<tr bgcolor="000066">
		<td><font color="white">Angent</td>
		<cfloop list =#form.companies# index='comp'>
		<cfquery name="compshort" datasource="MySQL">
		select companyshort from smg_companies
		where companyid = #comp#
		</cfquery>
		<td><font color="white">#compshort.companyshort#</td>
		<cfset "smg_comp_total_due_#comp#" = 0>
		</cfloop>
		<td><font color="white">Total</td>
	</tr>



<!----First Loop goes through companies---->


<cfset bgmod = #ListLen(form.agents)#>
<cfloop list=#form.agents# index='agnt'>
	<cfquery name="business_name" datasource="MySQL">
	select businessname from smg_users
	where userid = #agnt#
	</cfquery>
	<cfset bgmod = #bgmod# -1>
	<tr <cfif bgmod mod 2>bgcolor='cccccc'</cfif>>
	<td>#business_name.businessname#</td>
	<cfset business_total_due = 0>
			<cfloop list=#form.companies# index='comp'>
			
					<!----Loop to catch selected agents---->
					
						
							<cfquery name="get_students_charges" datasource="MySQL">
							select smg_students.studentid, smg_students.programid, smg_charges.chargeid, smg_charges.amount_due
							from smg_students right join smg_charges on smg_students.studentid = smg_charges.stuid
							where smg_students.companyid = #comp# and
							(
							<cfloop list=#form.programs# index='prog'>
							 programid = #prog# 
							 <cfif prog is #ListLast(form.programs)#>
							 <Cfelse>or
							 </cfif>
							 </cfloop>
							 )
							and smg_students.active = 1 and smg_students.intrep =#agnt#
							order by smg_students.studentid
							</cfquery>
							<Cfset total_charge_comp= 0>
							<cfloop query="get_students_charges">
								<Cfquery name="check_paid" datasource="MySQL">
								select chargeid from smg_payment_charges
								where chargeid = #get_students_charges.chargeid#
								</Cfquery>
								<cfif check_paid.recordcount gt 0>
								<cfset famountdue = 0>
								<Cfelse>
								<cfset famountdue = #amount_due#>
								</cfif>
							<Cfset total_charge_comp=#total_charge_comp# + #famountdue#>
							</cfloop>
							<cfset comp_val = #Evaluate("smg_comp_total_due_" & comp)#> 
							<cfset "smg_comp_total_due_#comp#" = #comp_val# + #total_charge_comp#>
							<Cfset business_total_due = #business_total_due# + #total_charge_comp#>
			
				 <td><Cfif total_charge_comp is 0>#LSCurrencyFormat(0, 'local')#<cfelse>#LSCurrencyFormat(total_charge_comp, 'local')#</Cfif></td>  
		</cfloop>
		<td>#LSCurrencyFormat(business_total_due,'local')#</td>
		</tr>
</cfloop>
<td> <strong>Totals</td>
<Cfset gtdue = 0>
<cfloop list =#form.companies# index='comp'>
<cfset gtdue = #gtdue# + #Evaluate("smg_comp_total_due_" & comp)#>
<td><strong> #LSCurrencyFormat(Evaluate("smg_comp_total_due_" & comp), 'local')#</td>
</cfloop>
<td><strong> #LSCurrencyFormat(gtdue,'local')#</td>

</Table>
</Cfoutput>

