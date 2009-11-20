<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<head>
<!----Statement Info---->
<cfset statementmonthbeg = '2007-01-01'>
<cfset statementmonthend = '2007-03-06'>
<Cfset month = #Dateformat(statementmonthbeg, 'mm')#>
<Cfset statementmonth= '#month#/01/07'>

<cfquery name="get_user_id" datasource="mysql">
select userid
from smg_users 
where uniqueid = '#url.s#'
</cfquery>

<cfset userid = #get_user_id.userid#>

<cfquery name="statement_info" datasource="mysql">
	select inv.invoiceid, inv.intrepid, inv.date,
	u.businessname,
	e.chargetypeid, e.studentid, e.programid, e.amount, e.description, e.date, e.full_paid
	from egom_invoice inv
	LEFT JOIN smg_users u on u.userid = inv.intrepid
	LEFT JOIN egom_charges e on e.invoiceid = inv.invoiceid
	where inv.intrepid = #userid# and (e.date between #CreateODBCDateTime(statementmonthbeg)# and #CreateODBCDateTime(statementmonthend)#)
</cfquery>
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
<!----Business Info for Header---->



<cfoutput>
<title>Statement for #statement_info.businessname#</title>
</head>

<body>





<div class="page-break">
				<table align="center" >
				<Tr>
				<td><img src="dmd_banner.gif" align="Center"></Td>
				</Tr>
				<tr>
					<td align="center"><h1>Summary Statement</h1></td>
				</tr>
				</table>
				<br>
<cfquery name="business_name" datasource="MySQL">
 select *,  
  smg_countrylist.countryname, 
  billcountry.countryname as billcountryname
 
  from smg_users   
  LEFT JOIN smg_countrylist ON smg_countrylist.countryid = smg_users.country  
  LEFT JOIN smg_countrylist billcountry ON billcountry.countryid = smg_users.billing_country  
  where userid = #userid#
</cfquery>
<table width=90% border=0 cellspacing=0 cellpadding=2 bgcolor="FFFFFF" align="Center">
<Tr>
<td bgcolor="cccccc" class="thin-border" background="../pics/cccccc.gif">From:</td><td>&nbsp;&nbsp;&nbsp;&nbsp;</td><Td bgcolor="cccccc" class="thin-border" background="../pics/cccccc.gif" >To:</Td><td rowspan=2 valign="top">  
		<table border="0" cellspacing="0" cellpadding="2" class="nav_bar" align="right">
		
		  <tr>
			<td bgcolor="CCCCCC" align="center" class="thin-border-bottom" background="../pics/cccccc.gif"><b><FONT size="+1">Statement Dates</FONT></b></td>
			
		  </tr>
		  <tr>
			<td align="center" class="thin-border-bottom" ><B>#DateFormat(statementmonthbeg, 'M/DD/yy')# - #DateFormat(statementmonthend, 'M/DD/yy')#
<font size=+1> 


</b></td>
			
		  </tr>
		  		  <tr>
			<td bgcolor="CCCCCC" align="center" class="thin-border-bottom" background="../pics/cccccc.gif">Date Sent</td>
			
		  </tr>
		  <tr>
			<td  align="center" class="thin-border-bottom">#DateFormat(now(), 'mm/dd/yyyy')#</td>
			
		  </tr>

		
		</table>
</td>
</Tr>
	<tr>
	
	
	<td  valign="top" class="thin-border-left-bottom-right">
		DMD Discoveries <br>
		Private High School Program<br>
		119 Cooper St.<br />
		Suite 5<br>
		Babylon, NY 11702<br>
	</td>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
<td valign=top class="thin-border-left-bottom-right">

		#business_name.businessname# (#business_name.userid#)<br>
		#business_name.firstname# #business_name.lastname#<br>
		#business_name.address#<br>
		<cfif #business_name.address2# is ''><cfelse>#business_name.address2#</cfif>
		#business_name.city# #business_name.countryname# #business_name.zip#
		<br>
		E: <a href="mailto:#business_name.email#">#business_name.email#</a><br>
		P: #business_name.phone#<br>
		F: #business_name.fax#<br>
		
		</td>
</tr>

</table>
<br>
<!----Invoice Info---->
<table width=90% border=0 cellspacing=0 cellpadding=2 bgcolor="FFFFFF" align="Center" class="thin-border"> 
<Tr>
	<td colspan=5 class=thin-border-bottom>Below is a quick summary of the charges on your account as of the above date.  To view the full details of all charges and invocies, please click the link below.</td>
</tr>
<tr>
	<td bgcolor="CCCCCC"  class="thin-border-bottom" background="../pics/cccccc.gif" colspan=5>New Invoices</td>
</tr>
<cfset balance = 0>
<tr>
	<td>Date</td><Td>Invoice</Td><td>Description</td><Td>Amount</Td><td>Running Total</td>
</tr>
<cfloop query="statement_info">
<Tr <cfif statement_info.currentrow mod 2>bgcolor="##F5F5F5"</cfif>>	
	<Td >#LSDateFormat(date, 'mm/dd/yyyy')#</Td><td>#invoiceid#</td><Td>#description#</Td><td>#LSCurrencyFormat(amount,'local')#</td><Td><cfset balance = #balance# + #amount#>#LSCurrencyFormat(balance,'local')#</Td>
</tr>	
</cfloop>
<tr>
	<Td colspan=4 align="right" bgcolor="##FFFFCC"><h2>Total Charges</h2></Td><td bgcolor="##FFFFCC"><h2>#LsCurrencyFormat(balance, 'local')#</h2></td>
</td>
</table>
<br />
<!----Payment Info---->
<cfquery name="payments" datasource="mysql">
select date, total_amount, description, paymentid
from egom_payments 
where intrepid = #userid#
</cfquery>

<table width=90% border=0 cellspacing=0 cellpadding=2 bgcolor="FFFFFF" align="Center" class="thin-border"> 

<tr>
	<td bgcolor="CCCCCC"  class="thin-border-bottom" background="../pics/cccccc.gif" colspan=5>Payments</td>
</tr>

<tr>
	<td>Date</td><Td>Payment ID</Td><td>Description</td><Td>Amount</Td><td>Running Total</td>
</tr>
<cfset pay_balance = 0>

<cfif payments.recordcount eq 0>
<tr>
	<td colspan=5 align="center">No payments received durring this time period.</td>
</tr>
<cfelse>
<cfloop query="payments">
<Tr <cfif payments.currentrow mod 2>bgcolor="##F5F5F5"</cfif>>	
	<Td >#LSDateFormat(date, 'mm/dd/yyyy')#</Td><td>#paymentid#</td><Td>#description#</Td><td>#LSCurrencyFormat(total_amount,'local')#</td><Td><cfset pay_balance = #pay_balance# + #amount#>#LSCurrencyFormat(balance,'local')#</Td>
</tr>	
</cfloop>

<tr>
	<Td colspan=4 align="right" bgcolor="##FFFFCC"><h2>Total Payments</h2></Td><td bgcolor="##FFFFCC"><h2>#LsCurrencyFormat(pay_balance, 'local')#</h2></td>
</tr>
</cfif>
</table>
<br />
<cfset total_due=#balance# - #pay_balance#>
<table width=90% border=0 cellspacing=0 cellpadding=2 bgcolor="##FFFF66" align="Center" class="thin-border"> 

<tr>
	<td bgcolor="##FFFF66" align="center"><h2>Total Due: #LSCurrencyFormat(total_due, 'local')#</h2></td>
</tr>
</table>
<br />
<table width=90% border=0 cellspacing=0 cellpadding=2 align="Center" class="thin-border"> 
	<tr>
	<td bgcolor="CCCCCC"  class="thin-border-bottom" background="../pics/cccccc.gif" colspan=5>Remit Payment to:</td>
</tr>
<tr>
	<td>Suffolk Country National Bank<br>
	228 East Main Street<br />
	Port Jefferson, NY 11777<br />
	</td><td valign="top">ABA/Routing ## 021405464<br />
	Account ## 1110038682</td>
	
</cfoutput>
</body>
</html>
