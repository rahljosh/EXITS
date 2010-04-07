<!DOCTYPE html PUBLIC "-//W3C//Dtd XHTML 1.0 transitional//EN" "http://www.w3.org/TR/xhtml1/Dtd/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<head>

<!----collapse script---->
<script language="JavaScript" src="CollapsibleRows.js"></script>
    
<style type="text/css">
/*<![CDATA[*/
	body {
		font-family:arial, sans-serif;
		font-size:76%;
	}
/*]]>*/
</style>

<style type="text/css">
table{font-size:10px;}
table.nav_bar {  background-color: #ffffff; border: 1px solid #000000; }
.thin-border{ border: 1px solid #000000;}
.thin-border-right{ border-right: 1px solid #000000;}
.thin-border-left{ border-left: 1px solid #000000;}
.thin-border-right-bottom{ border-right: 1px solid #000000; border-bottom: 1px solid #000000;}
.thin-border-bottom{  border-bottom: 1px solid #000000;}
.thin-border-top{  border-top: 1px solid #000000;}
.thin-border-left-bottom{ border-left: 1px solid #000000; border-bottom: 1px solid #000000;}
.thin-border-right-bottom-top{ border-right: 1px solid #000000; border-bottom: 1px solid #000000; border-top: 1px solid #000000;}
.thin-border-left-bottom-top{ border-left: 1px solid #000000; border-bottom: 1px solid #000000; border-top: 1px solid #000000;}
.thin-border-left-bottom-right{ border-left: 1px solid #000000; border-bottom: 1px solid #000000; border-right: 1px solid #000000;}
.thin-border-left-top-right{ border-left: 1px solid #000000; border-top: 1px solid #000000; border-right: 1px solid #000000;}
-->
</style>

<!----Statement Info---->
<cfquery name="get_invoiceid" datasource="mysql">
	SELECT invoiceid
	FROM egom_invoice
	WHERE uniqueid = <cfqueryparam value="#url.i#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfset invoice = get_invoiceid.invoiceid>

<cfquery name="invoice_info" datasource="mysql">
	SELECT inv.invoiceid, inv.intrepid,
		s.firstname, s.familylastname,
		e.chargetypeid, e.studentid, e.programid, e.amount, e.description, e.date, e.full_paid,
		u.userid, u.businessname, u.firstname as int_firstname, u.lastname as int_lastname, u.address, u.address2, u.city, u.zip, u.phone, u.fax, u.php_contact_email,
		smg_countrylist.countryname, billcountry.countryname as billcountryname
	FROM egom_invoice inv
	LEFT JOIN smg_users u on u.userid = inv.intrepid
	LEFT JOIN egom_charges e on e.invoiceid = inv.invoiceid
	LEFT JOIN smg_students s on s.studentid = e.studentid
	LEFT JOIN smg_countrylist ON smg_countrylist.countryid = u.country  
	LEFT JOIN smg_countrylist billcountry ON billcountry.countryid = u.billing_country  	
	WHERE inv.invoiceid = '#invoice#'
	ORDER BY e.canceled, e.chargeid
</cfquery>
  
<!----Business Info for Header---->

<cfoutput>

<title>Statement for #invoice_info.businessname#</title>
</head>

<body>

<div class="page-break">

<table align="center" >
	<tr><td><!--- <img src="dmd_banner.gif" align="Center"> ---></td></tr>
	<tr><td align="center"><h1>Invoice</h1></td></tr>
</table>
<br />

<table width=90% border=0 cellspacing=0 cellpadding=2 bgcolor="FFFFFF" align="Center">
	<tr>
		<td bgcolor="cccccc" class="thin-border" background="../pics/cccccc.gif">From:</td>
		<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td bgcolor="cccccc" class="thin-border" background="../pics/cccccc.gif" >To:</td>
		<td rowspan=2 valign="top">  
			<table border="0" cellspacing="0" cellpadding="2" class="nav_bar" align="right">
				<tr><td bgcolor="CCCCCC" align="center" class="thin-border-bottom" background="../pics/cccccc.gif"><b><FONT size="+1">Invoice</FONT></b></td></tr>
		 		<tr><td align="center" class="thin-border-bottom" ><b>#invoice_info.invoiceid#</b></td></tr>
		  		<tr><td bgcolor="CCCCCC" align="center" class="thin-border-bottom" background="../pics/cccccc.gif">Date Sent</td></tr>
		  		<tr><td align="center" class="thin-border-bottom">#DateFormat(now(), 'mm/dd/yyyy')#</td></tr>
			</table>
		</td>
	</tr>
	<tr>
		<td  valign="top" class="thin-border-left-bottom-right">
			KCK INTERNATIONAL <br />
			Private High School Program<br />
			119 Cooper St.<br />
			Suite 5<br />
			Babylon, NY 11702<br />
		</td>
		<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td valign=top class="thin-border-left-bottom-right">
			#invoice_info.businessname# (###invoice_info.userid#)<br />
			#invoice_info.int_firstname# #invoice_info.int_lastname#<br />
			#invoice_info.address#<br />
			<cfif invoice_info.address2 NEQ ''>#invoice_info.address2#<br /></cfif>
			#invoice_info.city# <cfif invoice_info.billcountryname NEQ ''>#invoice_info.billcountryname#<cfelse>#invoice_info.countryname#</cfif> #invoice_info.zip#<br />
			E: <a href="mailto:#invoice_info.php_contact_email#">#invoice_info.php_contact_email#</a> <br />
			P: #invoice_info.phone#<br />
			F: #invoice_info.fax#<br />
		</td>
	</tr>
</table>
<br />

<cfset balance = 0>

<!----Invoice Info---->
<table width=90% border=0 cellspacing=0 cellpadding=2 bgcolor="FFFFFF" align="Center" class="thin-border"> 
	<tr><td colspan=5 class=thin-border-bottom>Below is a quick summary of the charges on your account as of the above date.  To view the full details of all charges and invocies, please click the link below.</td></tr>
	<tr><td bgcolor="CCCCCC"  class="thin-border-bottom" background="../pics/cccccc.gif" colspan=5>Charges</td></tr>
	<tr>
		<td>Date</td>
		<td>Student Name (ID)</td>
		<td>Description</td>
		<td>Amount</td>
		<td>Running Total</td>
	</tr>
	<cfloop query="invoice_info">
	<tr <cfif invoice_info.currentrow mod 2>bgcolor="##F5F5F5"</cfif>>	
		<td>#LSDateFormat(date, 'mm/dd/yyyy')#</td>
		<td>#firstname# #familylastname# (###studentid#)</td>
		<td>#description#</td>
		<td>#LSCurrencyFormat(amount,'local')#</td>
		<td><cfset balance = #balance# + #amount#>#LSCurrencyFormat(balance,'local')#</td>
	</tr>	
	</cfloop>
	<tr>
		<td colspan=4 align="right" bgcolor="##FFFFCC"><h2>Total Charges</h2></td>
		<td bgcolor="##FFFFCC"><h2>#LsCurrencyFormat(balance, 'local')#</h2></td>
	</td>
</table>
<br />

<!----
<!----Payment Info---->
<cfquery name="payments" datasource="mysql">
select date, total_amount, description, paymentid
from egom_payments 
where intrepid = 49
</cfquery>

<table width=90% border=0 cellspacing=0 cellpadding=2 bgcolor="FFFFFF" align="Center" class="thin-border"> 

<tr>
	<td bgcolor="CCCCCC"  class="thin-border-bottom" background="../pics/cccccc.gif" colspan=5>Payments</td>
</tr>

<tr>
	<td>Date</td><td>Payment ID</td><td>Description</td><td>Amount</td><td>Running Total</td>
</tr>
<cfset pay_balance = 0>

<cfif payments.recordcount eq 0>
<tr>
	<td colspan=5 align="center">No payments received durring this time period.</td>
</tr>
<cfelse>
<cfloop query="payments">
<tr <cfif payments.currentrow mod 2>bgcolor="##F5F5F5"</cfif>>	
	<td >#LSDateFormat(date, 'mm/dd/yyyy')#</td><td>#paymentid#</td><td>#description#</td><td>#LSCurrencyFormat(total_amount,'local')#</td><td><cfset pay_balance = #pay_balance# + #amount#>#LSCurrencyFormat(balance,'local')#</td>
</tr>	
</cfloop>

<tr>
	<td colspan=4 align="right" bgcolor="##FFFFCC"><h2>Total Payments</h2></td><td bgcolor="##FFFFCC"><h2>#LsCurrencyFormat(pay_balance, 'local')#</h2></td>
</tr>
</cfif>
</table>
<br />---->

<table width=90% border=0 cellspacing=0 cellpadding=2 bgcolor="##FFFF66" align="Center" class="thin-border"> 
	<tr><td bgcolor="##FFFF66" align="center"><h2>Total Due: #LSCurrencyFormat(balance, 'local')#</h2></td></tr>
</table>
<br />

<!--- BANK INFORMATION --->
<table width=90% border=0 cellspacing=0 cellpadding=2 align="Center" class="thin-border"> 
	<tr>
    	<td bgcolor="CCCCCC"  class="thin-border-bottom" background="../pics/cccccc.gif" colspan=5>
        	Remit Payment to:
        </td>
    </tr>
	<tr>
		<td>
            #AppInvoice.companyName# <br />
            #AppInvoice.bankName# <br />
            #AppInvoice.bankAddress# <br />
            #AppInvoice.bankCity#, #AppInvoice.bankState# #AppInvoice.bankZip# <br />
			ABA/Routing ## #AppInvoice.bankRouting#<br />
			Account ## #AppInvoice.bankAccount#

		</td>
		<td valign="top">
		</td>
	</tr>
</table>
<br />

</cfoutput>
</body>
</html>
