<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Refund Receipt</title>

<style type="text/css" media="print">
	.page-break {page-break-after: always}
</style>

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
</head>

<body>

<link rel="stylesheet" href="../smg.css" type="text/css">

<cfoutput>

<cfif not isdefined('url.id') OR url.id EQ ''> 
	<table align="center" width="90%" frame="box">
		<tr><th colspan="2">No refund specified, please go back and select a refund. <br>If you received this error from clicking directly on a link, contact the person who sent you the link.</th></tr>
	</table>
	<cfabort>
</cfif>

<Cfquery name="intrep" datasource="caseusa">
	select smg_users.businessname, smg_users.userid
	from  smg_users
	where smg_users.userid = <cfqueryparam value="#client.userid#" cfsqltype="cf_sql_integer"> 
</Cfquery>
			
<cfquery name="refunds" datasource="caseusa">
	select smg_invoice_refunds.creditid, smg_invoice_refunds.companyid, smg_invoice_refunds.agentid, smg_invoice_refunds.amount,
	smg_credit.description, smg_credit.invoiceid, smg_credit.stuid, smg_credit.type, smg_credit.amount, 
	smg_credit.payref, smg_invoice_refunds.date
	from smg_invoice_refunds right join smg_credit on smg_invoice_refunds.creditid = smg_credit.creditid
	where refund_receipt_id = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer">
	order by smg_invoice_refunds.companyid
</cfquery>

<cfif refunds.agentid NEQ client.userid> 
	<table align="center" width="90%" frame="box">
		<tr><td valign="top"><img src="../../pics/error.gif"></td>
			<td valign="top"><font color="##CC3300">You can only view your invoices. The invoice that you are trying to view is not yours.  <br>If you received this error from clicking directly on a link, contact the person who sent you the link.</td>
		</tr>
	</table>
	<cfabort>
</cfif>
			
<cfloop query="intrep">
	<div class="page-break">
	<table align="center" >
		<Tr><td><img src="../../pics/smg_banner.jpg" align="Center"></Td></Tr>
		<tr><td align="center"><h1>Refund Receipt</h1></td></tr>
	</table>
	<br><br>
			
	<cfquery name="business_name" datasource="caseusa">
		select *
		from smg_users 
		where userid = <cfqueryparam value="#client.userid#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<table width=90% border=0 cellspacing=0 cellpadding=2 bgcolor="FFFFFF" align="Center">
		<Tr>
			<td bgcolor="cccccc" class="thin-border" background="../../pics/cccccc.gif" valign="top">From:</td>
			<td valign="top">&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<Td bgcolor="cccccc" class="thin-border" valign="top">To:</Td>
			<td rowspan=2 valign="top" valign="top">  
				<table border="0" cellspacing="0" cellpadding="2" class="nav_bar" align="right">
				  	<tr><td bgcolor="CCCCCC" align="center" class="thin-border-bottom"><b><font size="+1">Refund Date</font></b></td> </tr>
				    <tr><td align="center" class="thin-border-bottom" ><B><font size=+1>#DateFormat(refunds.date, 'M/DD/yy')#</b></font></td></tr>
					<tr><td bgcolor="CCCCCC" align="center" class="thin-border-bottom"><b><font size="+1">Receipt ##</font></td></tr>
					<tr><td  align="center" class="thin-border-bottom"><b><font size="+1">###url.id#</font></td></tr>	
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
</cfloop>

<table align="Center" width=90% border=0>
	<Tr>
		<td colspan=2><br>
			<!----Refund Section of Invoice---->
			<table class="nav_bar" cellpadding=2 cellspacing=0 width=100%>
				<tr bgcolor="000066">
					<td colspan=8><font color="white">Refund Details</font></td>
				</tr>
				<tr>
					<td>Company</td>
					<td>ID</td>
					<td>Date Applied</td>
					<td>Type</td>
					<td>Description</td>
					<td>Student</td>
					<td>Inv.</td>
					<td>Amount</td>
				</tr>
				<cfquery name="total_refund" datasource="caseusa">
					select sum(smg_invoice_refunds.amount) as total_refund
					from smg_invoice_refunds right join smg_credit on smg_invoice_refunds.creditid = smg_credit.creditid
					where smg_invoice_refunds.refund_receipt_id = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfif total_refund.total_refund is ''>
					<cfset total_refund.total_refund = 0>
				</cfif>
	
				<cfif refunds.recordcount is 0>
					<tr><td colspan=7 align="center">No refunds were applied to your account.</td></tr>
				<cfelse>
					<cfset total_credit=0>
					<cfloop query="refunds">
							<cfquery name="companyshort" datasource="caseusa">
								select companyshort
								from smg_companies
								where companyid = #companyid#
							</cfquery>
						<Tr <cfif refunds.currentrow mod 2>bgcolor="##ededed"</cfif>>
							<td>#companyshort.companyshort#</td>
							<td>###creditid#</td>
							<td>#DateFormat(date,'mm/dd/yyyy')#</td>
							<td>#type#</td><td>#description#</td>
							<td>###stuid#</td>
							<td>###invoiceid#</td>
							<td>#LSCurrencyFormat(amount, 'local')#</td>
						</Tr>
					</cfloop>
					<Tr><td colspan=7 align="center"><b>Total Amount Refunded: #LSCurrencyFormat(total_refund.total_refund, 'local')#</b></td></Tr>	
				</cfif>
			</table>
		</td>
	</Tr>
	<tr><td align="left"><img src="../../pics/logos/#refunds.companyid#.gif"></td></tr>
</table>

</cfoutput>
			
</body>
</html>