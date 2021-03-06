<head>
<style type="text/css" media="print">
	.page-break {page-break-after: always}
</style>
<style type="text/css">
table{font-size:10px;}
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
	<link rel="stylesheet" href="../smg.css" type="text/css">
</head>


<!----

<Cfquery name="intrep" datasource="caseusa">

	select distinct smg_invoices.intrepid, smg_users.businessname, smg_users.userid
	from smg_invoices left join smg_users
	on smg_invoices.intrepid = smg_users.userid
where smg_users.userid = #url.userid#
	order by smg_users.businessname
	
</Cfquery>
---->
<Cfoutput>
	<Cfquery name="intrep" datasource="caseusa">

	select smg_users.businessname, smg_users.userid
	from  smg_users
	
where smg_users.userid = #url.userid#
	
	
</Cfquery>
</Cfoutput>
			
<cfquery name="refunds" datasource="caseusa">
			select * from smg_invoice_refunds
			where id = #url.id#
			</cfquery>
			
			
			<Cfoutput query="intrep">
			<div class="page-break">
<table align="center" >
<Tr>
<td><img src="../pics/case_banner.jpg" align="Center"></Td>
</Tr>
<tr>
	<td align="center"><h1>Refund Receipt</h1></td>
</tr>
</table>
<br>
<br>
			<cfquery name="business_name" datasource="caseusa">
			select *
			from smg_users 
			where userid = #url.userid#
			</cfquery>
<table width=90% border=0 cellspacing=0 cellpadding=2 bgcolor="FFFFFF" align="Center">
<Tr>
<td bgcolor="cccccc" class="thin-border" background="../pics/cccccc.gif">From:</td><td>&nbsp;&nbsp;&nbsp;&nbsp;</td><Td bgcolor="cccccc" class="thin-border" >To:</Td><td rowspan=2 valign="top">  
		<table border="0" cellspacing="0" cellpadding="2" class="nav_bar" align="right">
		
		  <tr>
			<td bgcolor="CCCCCC" align="center" class="thin-border-bottom"><b><FONT size="+1">Refund Date</FONT></b></td>
			
		  </tr>
		  <tr>
			<td align="center" class="thin-border-bottom" ><B><font size=+1> 
#DateFormat(refunds.date, 'M/DD/yy')# 

</b></td>
			
		  </tr>
		
		

		
		</table>
</td>
</Tr>
	<tr>
	
	
	<td  valign="top" class="thin-border-left-bottom-right">
		Cultural Academic Student Exchange<br>
		19 Charmer Court<br>
		Middletown, NJ 07748<br>
	</td>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td valign=top class="thin-border-left-bottom-right">
		#business_name.businessname# (#business_name.userid#)<br>
		#business_name.firstname# #business_name.lastname#<br>
		#business_name.address#<br>
		<cfif #business_name.address2# is ''><cfelse>#business_name.address2#</cfif>
		#business_name.city# #business_name.country# #business_name.zip#
		<br>
		E: <a href="mailto:#business_name.email#">#business_name.email#</a><br>
		P: #business_name.phone#<br>
		F: #business_name.fax#<br>
		
		
		</td>

</tr>
</table>

</cfoutput>


			
			<table align="Center" width=90% border=0>
				<Tr>
					<td colspan=2>
		
<br>
<!----Refund Section of Invoice---->
<table class="nav_bar" cellpadding=2 cellspacing=0 width=100%>

			<tr bgcolor="000066">
				<td colspan=8><font color="white"><cfoutput>

Refund Details


</cfoutput></font></td>
			</tr>
				<tr>
		<td>ID</td><td>Date Applied</td><td>Reason</td><td>Amount</td>
	</tr>
	
<Cfquery name="refunds" datasource="caseusa">
select date,reason, amount, id
from smg_invoice_refunds
where agentid = #url.userid# 

</Cfquery>
	<cfquery name="total_refund" datasource="caseusa">
			select sum(amount) as total_refund
			from smg_invoice_refunds
			where agentid =#url.userid#
</cfquery>
		<cfif total_refund.total_refund is''><cfset total_refund.total_refund = 0></cfif>

<Cfoutput>
	
<cfif refunds.recordcount is 0>
	<tr>
		<td colspan=7 align="center">No refunds were applied to your account.</td>
	</tr>
<cfelse>
<cfset total_credit=0>
<cfloop query=refunds>
	
		<Tr <cfif refunds.currentrow mod 2>bgcolor="ededed"</cfif>>
			<td>#id#</td><td>#DateFormat(date, 'mm/dd/yyyy')#</td><td>#reason#</td><td>#LSCurrencyFormat(amount, 'local')#</td>
		</Tr>
		
	</cfloop>

	<Tr>
		<td colspan=7 align="center"><b>Total Amount Refunded: #LSCurrencyFormat(total_refund.total_refund, 'local')#</b></td>
	</Tr>	
</cfif>

</table>

			</td>
				</Tr>
			</table>
			</cfoutput>
			
			
			
