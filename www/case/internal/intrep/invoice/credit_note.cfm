<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Credit Note</title>
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

<cfif not isdefined('url.creditid') OR url.creditid EQ ''> 
	<table align="center" width="90%" frame="box">
		<tr><th colspan="2">No credit specified, please go back and select a credit. <br>If you received this error from clicking directly on a link, contact the person who sent you the link.</th></tr>
	</table>
	<cfabort>
</cfif>

<cfquery name="credit_check" datasource="caseusa">
	SELECT agentid 
	FROM smg_credit 
	WHERE creditid = <cfqueryparam value="#url.creditid#" cfsqltype="cf_sql_integer">
</cfquery>
<cfif credit_check.agentid NEQ client.userid> 
	<table align="center" width="90%" frame="box">
		<tr><td valign="top"><img src="../../pics/error.gif"></td>
			<td valign="top"><font color="##CC3300">You can only view your invoices. The invoice that you are trying to view is not yours.  <br>If you received this error from clicking directly on a link, contact the person who sent you the link.</td>
		</tr>
	</table>
	<cfabort>
</cfif>

<br><br>
<table align="center">
	<Tr><td><img src="../../pics/smg_banner.jpg" align="Center"></Td></Tr>
</table>
<br><br>
	
<cfquery name="credit_info" datasource="caseusa">
	SELECT creditid, agentid, stuid, invoiceid, description, type, amount, date, smg_credit.companyid,
		s.firstname, s.familylastname
	FROM smg_credit 
	LEFT JOIN smg_students s ON s.studentid = smg_credit.stuid
	WHERE creditid = <cfqueryparam value="#url.creditid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="company_info" datasource="caseusa">
	SELECT * 
	FROM smg_companies 
	WHERE companyid = #client.companyid#
</cfquery>

<cfquery name="agent_info" datasource="caseusa">
	SELECT *,  
		smg_countrylist.countryname, 
		billcountry.countryname as billcountryname
	FROM smg_users   
	LEFT JOIN smg_countrylist ON smg_countrylist.countryid = smg_users.country  
	LEFT JOIN smg_countrylist billcountry ON billcountry.countryid = smg_users.billing_country  
	WHERE userid = '#credit_info.agentid#'
</cfquery>	
	
<cfif NOT Isdefined('url.creditid') OR url.creditid EQ ''> 
	<table align="center" width="90%" frame="box">
		<tr><th colspan="2">No credit specified, please go back and select a credit note. <br>If you received this error from clicking directly on a link, contact the person who sent you the link.</th></tr>
	</table>
<cfabort>
</cfif>
	
<cfif credit_info.recordcount EQ 0> 
	<table align="center" width="90%" frame="box">
		<tr><th colspan="2">No credit was found with the id: #url.creditid# please go back and select a different credit note. <br>If you received this error from clicking directly on a link, contact the person who sent you the link.</th></tr>
	</table>
	<cfabort>
</cfif>
<br><br>

<table width=100% border=0 cellspacing=0 cellpadding=2 bgcolor="FFFFFF"> 
	<Tr>
		<Td bgcolor="cccccc" class="thin-border" >Bill To:</Td>
		<td rowspan=2 valign="top">  
			<table width="90%" border="0" cellspacing="0" cellpadding="2" align="right" class=thin-border>
				  <tr><td bgcolor="CCCCCC" align="center" class="thin-border-bottom"><b><FONT size="+1">Credit</FONT></b></td></tr>
				  <tr><td align="center" class="thin-border-bottom" ><B><font size=+1>###credit_info.creditid#</b></td></tr>
				  <tr><td bgcolor="CCCCCC" align="center" class="thin-border-bottom">Date</td></tr>
				  <tr><td  align="center" class="thin-border-bottom">#DateFormat(credit_info.date, 'mm/dd/yyyy')#</td></tr>
			</table>
		</td>
	</Tr>
	<tr>
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
	<cfif agent_info.billing_address neq agent_info.address or agent_info.billing_address2 neq agent_info.address2
	or agent_info.billing_city neq agent_info.city or  agent_info.billing_zip neq agent_info.zip>
		<tr><td>&nbsp;</td></tr>
		<Tr><td bgcolor="cccccc" class="thin-border" background="../../pics/cccccc.gif">Local Contact:</td></tr>
		<tr>
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
<br>

<div align="center"><img src="../../pics/detach.jpg" ></div><br>
	<table width=100% cellspacing=0 cellpadding=2 class=thin-border border=0> 
		<tr bgcolor="CCCCCC" >
			<td class="thin-border-right-bottom">Type</td><td class="thin-border-right-bottom">Invoice</td><td class="thin-border-right-bottom">Student ID</td><td class="thin-border-right-bottom">Description</td><td class="thin-border-bottom" align="right">Total</td>
		</tr>
		<tr>
			<td>#credit_info.type#</td><td>###credit_info.invoiceid#</td><td>###credit_info.stuid#</td><td>#credit_info.description#</td><td align="right">#LSCurrencyFormat(credit_info.amount,'local')#</td>
		</tr>
	</table><br />
	<table width=100% cellspacing=0 cellpadding=2 border=0 bgcolor="FFFFFF">	
		<tr>
			<td width="70%"><img src="../../pics/logos/#credit_info.companyid#.gif"></td>
			<td width="30%" valign="top" align="right">
				<table width=100% cellspacing=0 cellpadding=2 border=0 bgcolor="FFFFFF">	
					<tr>
						<td bgcolor="CCCCCC" class="thin-border-left-bottom-top" align="right"><b>TOTAL CREDIT/CANCELED</b></td>
						<td bgcolor="CCCCCC" class="thin-border-right-bottom-top" align="right"><b>#LSCurrencyFormat(credit_info.amount, 'local')#</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
<br><br>

</cfoutput>

</body>
</html>