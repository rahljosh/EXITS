<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Invoice View</title>
<style type="text/css">
<!--
.thin-border-left-bottom-right {border-left: 1px solid #000000; border-bottom: 1px solid #000000; border-right: 1px solid #000000;}
-->
</style>
</head>

<body>

<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="check_rights.cfm">

<cfsetting requesttimeout="300">

<link rel="stylesheet" href="../profile.css" type="text/css">

<style type="text/css">
<!--
.style1 {font-size: 10px}

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

<cfquery name="invoice_check" datasource="caseusa">
	select distinct agentid from smg_charges
	where invoiceid = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer">
</cfquery>
<cfif invoice_check.agentid neq client.userid> 
	<table align="center" width="90%" frame="box">
		<tr>
			<td valign="top"><img src="../../pics/error.gif"></td>
			<td valign="top"><font color="##CC3300">You can only view your invoices. The invoice that you are trying to view is not yours.  <br>If you received this error from clicking directly on a link, contact the person who sent you the link.</td>
		</tr>
	</table>
	<cfabort>
</cfif>

<br><br>

<table align="center">
<Tr>
<td><img src="../../pics/case_banner.jpg" align="Center"></Td>
</Tr>
</table>
<br>
<br>
	
	<cfif not isdefined('url.id') or url.id EQ ''> 
		<table align="center" width="90%" frame="box">
			<tr><th colspan="2">No invoice specified, please go back and select an invoice. <br>If you recieved this error from clicking directly on a link, contact the person who sent you the link.</th></tr>
		</table>
		<cfabort>
	</cfif>
	
	<cfquery name="invoice_info" datasource="caseusa">
		select * from smg_charges
		where invoiceid = #url.id#
		order by stuid
	</cfquery>

	<cfif invoice_info.recordcount is 0> 
				<table align="center" width="90%" frame="box">
	<tr><th colspan="2">No invoice was found with the id: #url.id# please go back and select a different invoice. <br>If you recieved this error from clicking directly on a link, contact the person who sent you the link.</th></tr>
	</table>
	<cfabort>
	</cfif>
	
</Cfoutput>
	<cfoutput>


<br>
<br>
	<cfif not isdefined('url.id') or url.id is ''> 
				<table align="center" width="90%" frame="box">
	<tr><th colspan="2">No invoice specified, please go back and select an invoice. <br>If you recieved this error from clicking directly on a link, contact the person who sent you the link.</th></tr>
	</table>
	<cfabort>
	</cfif>

<table width=100% border=0 cellspacing=0 cellpadding=2 bgcolor="FFFFFF" > 


<cfquery name="invoice_info" datasource="caseusa">
select * from smg_charges
where invoiceid = #url.id#
order by stuid
</cfquery>
	<cfif invoice_info.recordcount is 0> 
				<table align="center" width="90%" frame="box">
	<tr><th colspan="2">No invoice was found with the id: #url.id# please go back and select a different invoice. <br>If you recieved this error from clicking directly on a link, contact the person who sent you the link.</th></tr>
	</table>
	<cfabort>
	</cfif>

<cfquery name="company_info" datasource="caseusa">
select * from smg_companies 
where companyid = #client.companyid#
</cfquery>

<cfquery name="agent_info" datasource="caseusa">
select *,  
  smg_countrylist.countryname, 
  billcountry.countryname as billcountryname
 
  from smg_users   
  LEFT JOIN smg_countrylist ON smg_countrylist.countryid = smg_users.country  
  LEFT JOIN smg_countrylist billcountry ON billcountry.countryid = smg_users.billing_country  
  where userid = #invoice_info.agentid# 
</cfquery>

<Tr>
	<td bgcolor="cccccc" class="thin-border" background="../../pics/cccccc.gif" valign="top">Remit To:</td><br />
	<td valign="top">&nbsp;&nbsp;&nbsp;&nbsp;</td>
	<Td bgcolor="cccccc" class="thin-border" valign="top">Bill To:</Td>
	<td rowspan=2 valign="top">  
		<table border="0" cellspacing="0" cellpadding="2" align="right" class=thin-border>
		  <tr>
			<td bgcolor="CCCCCC" align="center" class="thin-border-bottom"><b><FONT size="+1">Invoice</FONT></b></td>
			
		  </tr>
		  <tr>
			<td align="center" class="thin-border-bottom" ><B><font size=+1> ## #invoice_info.invoiceid#</b></td>
		  </tr>
		  		  <tr>
			<td bgcolor="CCCCCC" align="center" class="thin-border-bottom">Date</td>
			
		  </tr>
		  <tr>
			<td  align="center" class="thin-border-bottom">#DateFormat(invoice_info.invoicedate, 'mm/dd/yyyy')#</td>
			
		  </tr>
		  <tr>
			<td bgcolor="CCCCCC" align="center"  class="thin-border-bottom">Terms </td>
			
		  </tr>
		   <tr>
			<td align="center" >Due Upon Receipt</td>
			
		  </tr>
		
		</table>
</td>
</Tr>
	<tr>
	
	
	<td  valign="top" class="thin-border-left-bottom-right" bgcolor="##FFFFFF">Cultural Academic Student Exchange<br />
Chase Bank<Br />
Red Bank, NJ 07701<br />
ABA/Routing: 021202337<Br />
Account: 747523579<br />
SWIFT: CHASUS33 </td>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td valign=top class="thin-border-left-bottom-right">

		#agent_info.billing_company#<br>
		#agent_info.billing_contact#<br>
		#agent_info.billing_address#<br>
		<cfif #agent_info.billing_address2# is ''><cfelse>#agent_info.billing_address2#</cfif>
		#agent_info.billing_city# #agent_info.billcountryname# #agent_info.billing_zip#
		<br>
		E: #agent_info.billing_email#<br>
		P: #agent_info.billing_phone#<br>
		F: #agent_info.billing_fax#<br>
		
		
		
		</td>

</tr>
<cfif #agent_info.billing_address# neq #agent_info.address# or #agent_info.billing_address2# neq #agent_info.address2#
		or #agent_info.billing_city# neq #agent_info.city# or  #agent_info.billing_zip# neq #agent_info.zip#>

<tr>
	<td>&nbsp;</td>
</tr>
<Tr>
	<td bgcolor="cccccc" class="thin-border" background="../../pics/cccccc.gif">Local Contact:</td>
</tr>
<tr></tr>
	<td valign=top class="thin-border-left-bottom-right">
		#agent_info.businessname# (#agent_info.userid#)<br>
		#agent_info.firstname# #agent_info.lastname#<br>
		#agent_info.address#<br>
		<cfif #agent_info.address2# is ''><cfelse>#agent_info.address2#</cfif>
		#agent_info.city#, #agent_info.countryname# #agent_info.zip#<br>
		E: #agent_info.email#<br>
		P: #agent_info.phone#<br>
		F: #agent_info.fax#<br>
		</td>
</Tr>
</cfif>
</table>
<!----<Table width=100%>
<tr><td align="left">


		<td align="right" valign="bottom">
					<table border="0" cellspacing="0" cellpadding="2" class="nav_bar" align="right">
		
		  <tr>
			<td bgcolor="CCCCCC" align="center" class="thin-border-right-bottom">Amount Due</td>
			<td bgcolor="CCCCCC" align="center" class="thin-border-bottom">Amount Enclosed</td>
		  </tr>
		  <tr>
			<td align="center" class="thin-border-right-bottom" >#DateFormat(now(), 'mm/dd/yy')#</td>
			<td align="center" class="thin-border-bottom"><br><Br></td>
		  </tr>
		</td>
		</table>
		</td>
	</tr>
</Table>---->
</td>

</tr>

</table>
</cfoutput>
<br>

<!-----Invoice with Students---->
		<div align="center"><img src="../../pics/detach.jpg" ></div><br>
		<table width=100% cellspacing=0 cellpadding=2 class=thin-border border=0> 
			<tr bgcolor="CCCCCC" >
				<td class="thin-border-right-bottom">Student</td><td class="thin-border-right-bottom">Description / Type</td><td class="thin-border-right-bottom" align="right">Charge</td><td class="thin-border-bottom" align="right">Total</td>
			</tr>
			<cfset current_student = 0>
			<cfset previous_student = 0>
			<Cfset current_recordcount = 1>
		<cfoutput query="invoice_info">
			<cfif current_student is 0>
			<cfset current_student = #stuid#>
			<cfset previous_student = 0>
			</cfif>
			<cfset current_student = #stuid#>
			<cfquery name="student_name" datasource="caseusa">
			select firstname, familylastname
			from smg_students
			where studentid = #stuid#
			</cfquery>
			<cfquery name=charge_count datasource="caseusa">
			select chargeid from smg_charges
			where invoiceid = #id# and stuid = #stuid#
			
			</cfquery>
			<cfquery name="total_student" datasource="caseusa">
			select sum(amount) as total_stu_amount
			from smg_charges
			where invoiceid = #id# and stuid = #stuid#
			</cfquery>

			
				<tr>
					<td><cfif current_student is not #previous_student#>#student_name.firstname# #student_name.familylastname# (#stuid#)<cfelse></cfif></td><td>#description# / #type#</td><td align="right">#LSCurrencyFormat(amount,'local')# </td><td align="right"><cfif #current_recordcount# is #charge_count.recordcount#>#LSCurrencyFormat(total_student.total_stu_amount, 'local')#</cfif></td>
				</tr>
			
		<cfif #current_recordcount# is #charge_count.recordcount#>
				<!----Check for invoice with deposit amount on it---->
				<cfquery name="deposit_invoice" datasource="caseusa">
				select invoicedate, invoiceid, amount, description, type
				from smg_charges where stuid = #stuid# and type = 'deposit' and invoiceid <> #url.id# and active = 1
				</cfquery>
				<!----Check for multiple invoices for THIS student.  If multiple invoices are found, only show deposit on invoice# that is lowest.
				in case fees were generated on an invoice after the initial final invoice---->
				<cfquery name="check_multiple_invoices" datasource="caseusa">
				select distinct invoiceid
				from smg_charges where stuid = #stuid# 
				order by invoiceid
				</cfquery>
				<Cfset show_deposit = 1>
				<cfif check_multiple_invoices.recordcount gt 2>
					<cfloop query=check_multiple_invoices>
						<cfif check_multiple_invoices.currentrow is 1>
							<cfset deposit_invoice_id = #invoiceid#>
						<cfelseif check_multiple_invoices.currentrow is 2>
							<cfset final_invoice_id =#invoiceid#>
						<cfelse>
						</cfif>
					</cfloop>
					<cfif #id# is #deposit_invoice_id# or #id# is #final_invoice_id#>
						<cfset show_deposit = 1>
					<cfelse>
						<cfset show_deposit = 0>
					</cfif>
				</cfif>
		<cfif show_deposit is 1>
			<cfif deposit_invoice.recordcount is 0>
				<Cfset current_recordcount = 0>
			<cfelse>
				<cfif deposit_invoice.recordcount is 0>
					<cfset deposit_invoice.amount = 0>
				</cfif>
			
				<cfset neg_deposit = #deposit_invoice.amount# * -1>
				
				
				
					<tr>
						<td></td><td>#deposit_invoice.description# / #deposit_invoice.type# <font size=-2>- <a href="invoice_view.cfm?id=#deposit_invoice.invoiceid#">invoice ## #deposit_invoice.invoiceid#</a></font></td><td align="right">#LSCurrencyFormat(neg_deposit,'local')#</td><td align="right"><cfset new_line_bal = #total_student.total_stu_amount# + #neg_deposit#>#LSCurrencyFormat(new_line_bal, 'local')#<Cfset current_recordcount = 0></td>
					</tr>
			</cfif>
		<cfelse>
		<Cfset current_recordcount = 0>
		</cfif>
		</cfif>
				<cfset previous_student = #stuid#>
		<cfif current_student is previous_student>
			<cfset current_recordcount = #current_recordcount# +1>
		</cfif>
</cfoutput>
	
			
			
		</table>
		<!----Retrieve Total Due from Invoice---->
		<cfquery name="total_Due" datasource="caseusa">
			select sum(amount_due) as total_due 
			from smg_Charges
			where invoiceid = #url.id#
</cfquery>
		<!----Retrieve Total Deposits Accounted for on this invoice---->
		
		
		<table width=100% cellspacing=0 cellpadding=2 border=0 bgcolor="FFFFFF">	
			<cfset charges.datepaid = ''>
			<tr >
				<td  rowspan=2 width=470><cfoutput><img src="../../pics/logos/#invoice_info.companyid#.gif"></cfoutput></td><td rowspan=3<cfif charges.datepaid is ''>><cfelse> background="../../pics/paid.jpg" align="center" width=146><cfoutput><font color="b31633" size=+1>#DateFormat(charges.datepaid, 'mm/dd/yyyy')#</cfoutput></cfif></td><td align="left" width=120 class="thin-border-left" ><b>SUB - TOTAL</td><td align="right" class="thin-border-right"><b><cfoutput>#LSCurrencyFormat(total_due.total_due,'local')#</cfoutput></td>
			</tr>
			

			<tr >
			
			
				<td align="right" width=120 bgcolor="#CCCCCC" class="thin-border-left-bottom-top"><b>TOTAL DUE</b></td><td align="right" bgcolor="CCCCCC" class="thin-border-right-bottom-top"><b><cfoutput>#LSCurrencyFormat(total_due.total_due, 'local')#</cfoutput></td>
			</tr>
		</table>
		
		<br>
		<br>
		

		</div>


</body>
</html>
