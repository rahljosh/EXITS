<!DOCTYPE html PUBLIC "-//W3C//Dtd XHTML 1.0 transitional//EN" "http://www.w3.org/TR/xhtml1/Dtd/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<head>
<title>PHP INVOICE</title>
</head>

<body>

<cfparam name="totalPaid" default="0">

<!---- INVOICE INFO --->
<cfquery name="get_invoiceid" datasource="mysql">
	SELECT invoiceid
	FROM egom_invoice
	WHERE uniqueid = <cfqueryparam value="#url.i#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfset invoice = get_invoiceid.invoiceid>

<cfquery name="invoice_info" datasource="mysql">
	SELECT 
    	inv.invoiceid, 
    	inv.intrepid, 
    	inv.date,
		s.firstname, 
        s.familylastname,
		e.chargetypeid, 
        e.studentid, 
        e.programid, 
        e.amount, 
        e.description,
        e.date, 
        e.full_paid,
		u.userid, 
        u.businessname, 
        u.firstname as int_firstname, 
        u.lastname as int_lastname, 
        u.address, 
        u.address2, 
        u.city, 
        u.zip, 
        u.phone, 
        u.fax, 
        u.php_contact_email, 
        u.email,
        u.php_billing_email,
		smg_countrylist.countryname, 
		billcountry.countryname as billcountryname
	FROM 
    	egom_invoice inv
	LEFT JOIN 
    	smg_users u 
    ON 
    	u.userid = inv.intrepid
	LEFT JOIN 
    	egom_charges e 
    ON 
    	e.invoiceid = inv.invoiceid
	LEFT JOIN 
    	smg_students s 
    ON 
    	s.studentid = e.studentid
	LEFT JOIN 
    	smg_countrylist 
    ON 
    	smg_countrylist.countryid = u.country  
	LEFT JOIN 
    	smg_countrylist billcountry 
    ON 
    	billcountry.countryid = u.billing_country  	
	WHERE 
    	inv.invoiceid = '#invoice#'
	ORDER BY 
    	e.canceled, e.chargeid
</cfquery>

<cfquery name="invoice_payments" datasource="MySQL">
SELECT 
    SUM(epg.amount_paid) AS amountPaid,
    ptype.paymenttype,
    ep.transaction,
    ep.date_received,
    ep.total_amount
FROM
	egom_payment_charges epg
LEFT JOIN
	egom_payments ep ON ep.paymentid = epg.paymentid
LEFT JOIN
	egom_payment_type ptype ON ptype.paymenttypeid = ep.paymenttypeid
LEFT JOIN
	egom_charges ec ON ec.chargeid = epg.chargeid
WHERE
	ec.invoiceid = '#invoice#'
GROUP BY
	ep.transaction
ORDER BY
	ep.date_received DESC
</cfquery>

<cfquery name="get_sender" datasource="MySql">
	SELECT userid, firstname, lastname, email
	FROM smg_users
	WHERE userid = '#client.userid#'
</cfquery>

<cfoutput>

<cfif invoice_info.php_billing_email EQ ''>
		<table width="95%" class="box" bgcolor="##ffffff" align="center" cellpadding="3" cellspacing="0">
			<tr><td>&nbsp;</td></tr>
			<tr><th bgcolor="##C2D1EF">Invoice Error</th></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><th>There is no email on file for #invoice_info.businessname#. Invoice by Email can not be sent.</th></tr>
			<tr><td>&nbsp;</td></tr>
			<tr bgcolor="##C2D1EF"><th><a href="javascript:window.close()"><img src="../pics/close.gif" border="0" /></a></th></tr>
			<tr><td>&nbsp;</td></tr>
		</table>
	<cfabort>
<cfelseif get_sender.email EQ ''>
		<table width="95%" class="box" bgcolor="##ffffff" align="center" cellpadding="3" cellspacing="0">
			<tr><td>&nbsp;</td></tr>
			<tr><th bgcolor="##C2D1EF">Invoice Error</th></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><th>There is no email on file for for #get_sender.firstname# #get_sender.lastname#. Please include an email address to your account in order to continue.</th></tr>
			<tr><td>&nbsp;</td></tr>
			<tr bgcolor="##C2D1EF"><th><a href="javascript:window.close()"><img src="../pics/close.gif" border="0" /></a></th></tr>
			<tr><td>&nbsp;</td></tr>
		</table>
	<cfabort>
</cfif>

<cfmail from="#AppEmail.finance#" to="#invoice_info.php_billing_email#" bcc="#get_sender.email#" subject='PHP Invoice ###invoice_info.invoiceid# for #invoice_info.businessname#' type="html" failto="support@student-management.com">
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
table.nav_bar {  background-color: ##ffffff; border: 1px solid ##000000; }
.thin-border{ border: 1px solid ##000000;}
.thin-border-right{ border-right: 1px solid ##000000;}
.thin-border-left{ border-left: 1px solid ##000000;}
.thin-border-right-bottom{ border-right: 1px solid ##000000; border-bottom: 1px solid ##000000;}
.thin-border-bottom{  border-bottom: 1px solid ##000000;}
.thin-border-top{  border-top: 1px solid ##000000;}
.thin-border-left-bottom{ border-left: 1px solid ##000000; border-bottom: 1px solid ##000000;}
.thin-border-right-bottom-top{ border-right: 1px solid ##000000; border-bottom: 1px solid ##000000; border-top: 1px solid ##000000;}
.thin-border-left-bottom-top{ border-left: 1px solid ##000000; border-bottom: 1px solid ##000000; border-top: 1px solid ##000000;}
.thin-border-left-bottom-right{ border-left: 1px solid ##000000; border-bottom: 1px solid ##000000; border-right: 1px solid ##000000;}
.thin-border-left-top-right{ border-left: 1px solid ##000000; border-top: 1px solid ##000000; border-right: 1px solid ##000000;}
-->
</style>
  
<div align="center"><p>If you are unable to see the message below, <a href="http://www.phpusa.com/?i=#url.i#">click here to view.</a></p></div><br />

<table align="center" >
	<tr><td><!--- <img src="http://www.phpusa.com/images/dmd_banner.gif" align="Center"> ---></td></tr>
	<tr><td align="center"><h1>Invoice</h1></td></tr>
</table>
<br />

<!----Business Info for Header---->
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
			E: <a href="mailto:#invoice_info.php_billing_email#">#invoice_info.php_billing_email#</a> <br />
			P: #invoice_info.phone#<br />
			F: #invoice_info.fax#<br />
		</td>
	</tr>
</table>
<br />

<cfset balance = 0>

<!----Invoice Info---->
<table width=90% border=0 cellspacing=0 cellpadding=2 bgcolor="FFFFFF" align="Center" class="thin-border"> 
	<tr><td align="center" colspan=5 class=thin-border-bottom>Below is a quick summary of the charges on your account as of the above date.  To view the full details of all charges and invocies, please click the link below.</td></tr>
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

<table width=90% cellspacing=0 cellpadding=2 align="Center" class="thin-border">

	<cfif invoice_payments.recordCount GT 0>
	<tr>
        <td>
        	<b>Payments Applied to this invoice:</b>
        </td>
        <td>
        	<b>Payment Type</b>
        </td>
        <td>
        	<b>Payment Reference</b>
        </td>
        <td>
        	<b>Original Amount</b>
        </td>
        <td>
        	<b>Date Received</b>
        </td>
        <td>
        	<b>Amount Applied to this invoice</b>
        </td>
    </tr>

    <cfloop query="invoice_payments">
    
        <cfquery name="paymRef" datasource="MySQL">
        SELECT
        	SUM(total_amount) AS total_amount
        FROM
        	egom_payments
        WHERE
        	transaction = '#invoice_payments.transaction#'
        GROUP BY
        	transaction
        </cfquery>
        
        <tr>
            <td></td>
            <td>
            	#invoice_payments.paymenttype#
            </td>
            <td>
            	#invoice_payments.transaction#
            </td>
            <td>
            	#LSCurrencyFormat(paymRef.total_amount, 'local')#
            </td>
            <td>
            	#dateFormat(invoice_payments.date_received, 'mm/dd/yyyy')#
            </td>
            <td>
            	#LSCurrencyFormat(invoice_payments.amountPaid, 'local')#
            </td>
        </tr>
        <cfset totalPaid = totalPaid + invoice_payments.amountPaid>
    </cfloop>
    </cfif>
    
	<tr>
        <td class="thin-border-top" colspan="6" bgcolor="##FFFF66" align="center">
        	<h2>Total Due: #LSCurrencyFormat(balance - totalPaid, 'local')#</h2>
        </td>
    </tr>
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
            SWIFT Code ## #AppInvoice.bankSwift#<br />
			ABA/Routing ## #AppInvoice.bankRouting#<br />
			Account ## #AppInvoice.bankAccount#
		</td>
		<td valign="middle" style="color:##FF0000">
        	<cfif #dateformat(now(),'mm/dd/yyyy')# lte '08/30/2012'>
        	<h3><strong>Please note the new KCK's bank account (updated on January 24th 2012).</strong></h3>
            </cfif>
		</td>
	</tr>
</table>
<br />

</cfmail>

<table width="95%" class="box" bgcolor="##ffffff" align="center" cellpadding="3" cellspacing="0">
	<tr><td>&nbsp;</td></tr>
	<tr><th bgcolor="##C2D1EF">Invoice ###invoice_info.invoiceid# Email Confirmation</th></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><th>This invoice was sent to #invoice_info.businessname# at #invoice_info.php_billing_email#.</th></tr>
	<tr><td>&nbsp;</td></tr>
	<tr bgcolor="##C2D1EF"><th><a href="javascript:window.close()"><img src="../pics/close.gif" border="0" /></a></th></tr>
	<tr><td>&nbsp;</td></tr>
</table>

<!--- ADD EMAIL HISTORY --->
<cfquery name="insert_history" datasource="MySql">
	INSERT INTO egom_invoice_sent_history 
		(invoiceid, userid, date, sent_to)
	VALUES
		('#invoice_info.invoiceid#', '#client.userid#', #CreateODBCDateTime(now())#, '#invoice_info.php_billing_email#')
</cfquery>

</cfoutput>
</body>
</html>