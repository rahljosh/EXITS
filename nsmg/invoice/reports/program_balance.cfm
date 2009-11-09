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
<div align="center"><h2>Outstanding balances as of #DateFormat(now(), 'mm-dd-yyyy')# at #TimeFormat(now(),'h:mm:ss tt')#<br>
Selected Time Frams: #form.beg_date# thru #form.end_date#</h2></div>

<Table width=100% cellpadding=4 cellspacing=0 class="thin-border">
	<tr bgcolor="000066">
		<td><font color="white">Agent</td>
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
	<cfset total_charge_comp =0>
			<cfloop list=#form.companies# index='comp'>
				

					<!----Loop to catch selected agents---->
					
						<!----Gets the amount that needs to be paid---->
							<cfquery name="get_students_charges" datasource="MySQL">
							select smg_students.studentid, smg_students.programid, smg_charges.chargeid, smg_charges.amount_due
							from smg_students right join smg_charges on smg_students.studentid = smg_charges.stuid
							where smg_students.companyid = #comp# and
							(
							<cfloop list=#form.programs# index='prog'>
							 smg_students.programid = #prog# 
							 <cfif prog is #ListLast(form.programs)#>
							 <Cfelse>or
							 </cfif>
							 </cfloop>
							 )
							and  smg_students.intrep =#agnt#
							and (date between #CreateODBCDateTime(form.beg_Date)# and #CreateODBCDateTime(form.end_date)#)
							order by smg_students.studentid
							</cfquery>
							<cfset total_due_company = 0>
							<cfloop query="get_students_charges">
							<cfset total_due_company = #total_due_company# + #amount_due#>
							</cfloop>
							
							
							
							<!----get the amount that has been paid---->
							<cfset total_invoice_amount_received = 0>
							<Cfset total_charge_comp= 0>
							<cfloop query=get_students_charges>
								<cfquery name=get_applied_amount datasource="mysql">
								select smg_payment_charges.amountapplied
								from smg_payment_charges 
								where chargeid = #chargeid#
								</cfquery>
									<cfloop query=get_applied_amount>
										<cfset total_invoice_amount_received = #total_invoice_amount_received# + #get_applied_amount.amountapplied#>
									</cfloop>
									<Cfset total_charge_comp=#total_charge_comp# + #total_invoice_amount_received#>
							</cfloop>
							
							 <cfset comp_balance = #total_due_company# - #total_invoice_amount_received#>
						
							<cfset comp_val = #Evaluate("smg_comp_total_due_" & comp)#> 
							<cfset "smg_comp_total_due_#comp#" = #comp_val# + #comp_balance#>
							<Cfset business_total_due = #business_total_due# + #comp_balance#>
			
				 <td><Cfif comp_balance is 0>#LSCurrencyFormat(0, 'local')#<cfelse>#LSCurrencyFormat(comp_balance, 'local')#</Cfif></td>  
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


</td>
</tr>
</Table>
</Cfoutput>

