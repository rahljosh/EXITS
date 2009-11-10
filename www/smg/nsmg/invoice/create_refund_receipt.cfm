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

<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="check_rights.cfm">

<!----

<Cfquery name="intrep" datasource="mysql">

	select distinct smg_invoices.intrepid, smg_users.businessname, smg_users.userid
	from smg_invoices left join smg_users
	on smg_invoices.intrepid = smg_users.userid
where smg_users.userid = #url.userid#
	order by smg_users.businessname
	
</Cfquery>
---->
<Cfoutput>
	<Cfquery name="intrep" datasource="mysql">

	select smg_users.businessname, smg_users.userid
	from  smg_users
	
where smg_users.userid = #url.userid#
	
	
</Cfquery>
</Cfoutput>
			
<cfquery name="refunds" datasource="mysql">
			select smg_invoice_refunds.companyid, smg_invoice_refunds.agentid,smg_invoice_refunds.amount, smg_credit.creditid, smg_credit.description, smg_credit.invoiceid, smg_credit.stuid, smg_credit.type, smg_credit.amount, 
			smg_credit.payref, smg_invoice_refunds.date
			 from smg_invoice_refunds right join smg_credit on smg_invoice_refunds.creditid = smg_credit.id
			where smg_invoice_refunds.agentid = #url.userid#
			and refund_receipt_id = 0
			order by smg_invoice_refunds.companyid
			</cfquery>
			
			
			<Cfoutput query="intrep">
			<div class="page-break">
<table align="center" >
<Tr>
<td><img src="../pics/smg_banner.jpg" align="Center"></Td>
</Tr>
<tr>
	<td align="center"><h1>Refund Receipt</h1></td>
</tr>
</table>
<br>
<br>
			<cfquery name="business_name" datasource="MySQL">
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
		<tr></tr>
				<td bgcolor="CCCCCC" align="center" class="thin-border-bottom">Receipt ##</td>
			
		  </tr>
		  <tr>
			<td  align="center" class="thin-border-bottom"><A href="approve_refund.cfm?userid=#url.userid#">CLICK TO APPROVE</A></td>
			
		  </tr>

		
		</table>
</td>
</Tr>
	<tr>
	
	
	<td  valign="top" class="thin-border-left-bottom-right">
		Student Management Group<br>
		119 Cooper St.<br>
		Babylon, NY 11702<br>
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
		<td>Company</td><td>ID</td><td>Date Applied</td><td>Type</td><td>Description</td><td>Student</td><td>Inv.</td><td>Amount</td>
	</tr>
	

<cfquery name="total_refund" datasource="mysql">
			select sum(smg_invoice_refunds.amount) as total_refund
			 from smg_invoice_refunds right join smg_credit on smg_invoice_refunds.creditid = smg_credit.id
			where smg_invoice_refunds.agentid = #url.userid#
			and refund_receipt_id = 0
			order by smg_invoice_refunds.companyid
			<!----select sum(smg_credit.amount) as total_refund
			from smg_invoice_refunds right join smg_credit on smg_invoice_refunds.creditid = smg_credit.creditid
			where smg_invoice_refunds.agentid =#url.userid#
			and smg_invoice_refunds.refund_receipt_id = 0
			---->
			</cfquery>
			<cfif total_refund.total_refund is ''>
				<cfset total_refund.total_refund = 0>
			</cfif>
<Cfoutput>
	
<cfif refunds.recordcount is 0>
	<tr>
		<td colspan=7 align="center">No refunds were applied to your account.</td>
	</tr>
<cfelse>
<cfset total_credit=0>
<cfloop query=refunds>
	
		<Tr <cfif refunds.currentrow mod 2>bgcolor="ededed"</cfif>>
		<td>
		<cfquery name="companyshort" datasource="MySQL">
		select companyshort
		from smg_companies
		where companyid = #companyid#
		</cfquery>
		#companyshort.companyshort#</td><td>#creditid#</td><td>#DateFormat(date,'mm/dd/yyyy')#</td><td>#type#</td><td>#description#</td><td>#stuid#</td><td>#invoiceid#</td><td>#LSCurrencyFormat(amount, 'local')#</td>
			
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
			
			
			
