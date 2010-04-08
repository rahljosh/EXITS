<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="../check_rights.cfm">

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>SMG Statement</title>
</head>

<body>

<Cfquery name="get_intl_rep" datasource="caseusa">
	SELECT userid, businessname
	FROM smg_users
	WHERE usertype = '8'
		AND active = '1'
		<cfif client.usertype GT '4'>
			AND userid = <cfqueryparam value="#client.userid#" cfsqltype="cf_sql_integer">
		</cfif>
	ORDER BY businessname
</Cfquery>

<cfquery name="get_companyname" datasource="caseusa">
	SELECT companyid, companyname
	FROM smg_companies
	WHERE companyid = <cfqueryparam value="#client.companyid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfoutput>

<cfif NOT IsDefined('form.userid')>
	<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
		<tr valign=middle height=24>
			<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
			<td width=26 background="pics/header_background.gif"><img src="pics/$.gif"></td>
			<td background="pics/header_background.gif"><h2>Account Statement</h2></td>
			<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
		</tr>
	</table>
	
	<table border=0 cellpadding=8 cellspacing=2 width=100% class="section">
		<tr>
			<td width="100%" valign="top" align="center">
				<cfform action="invoice/reports/statement.cfm" method="POST" target="blank">
					<Table class="nav_bar" cellpadding=6 cellspacing="0" width="60%" align="center">
						<tr><th colspan="2" bgcolor="##e2efc7">Statement</th></tr>
						<tr align="left">
							<td>Intl. Rep:</td>
							<td><select name="userid" size="1">
								<cfloop query="get_intl_rep">
									<option value="#userid#">#businessname#</option>
								</cfloop>
								</select>
							</td>
						</tr>
						<tr>
							<td>From : </td>
							<td><cfinput type="text" name="date1" size="8" maxlength="10" validate="date"> mm-dd-yyyy</td>
						</tr>
						<tr>
							<td>To : </td>
							<td><cfinput type="text" name="date2" size="8" maxlength="10" validate="date"> mm-dd-yyyy</td>
						</tr>			
						<tr><td>* Dates are not required.</td></tr>
						<tr><td>&nbsp;</td></tr>	
						<tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
					</table>
				</cfform>
			</td>
		</tr>
	</table>
<cfinclude template="../../table_footer.cfm">	

<!--- REPORT --->
<cfelse>

	<Cfquery name="get_intl_rep" datasource="caseusa">
		SELECT businessname, firstname, lastname, city, smg_countrylist.countryname
		FROM smg_users
		LEFT JOIN smg_countrylist ON smg_countrylist.countryid = smg_users.country
		WHERE userid = <cfqueryparam value="#form.userid#" cfsqltype="cf_sql_integer">
	</Cfquery>

	<!--- RUNNING BALANCE --->
	<cfquery name="get_statement" datasource="caseusa">
		SELECT 'charges', smg_users.businessname, SUM( smg_charges.amount_due ) AS total_amount, smg_charges.invoicedate as orderdate
		FROM smg_charges
		INNER JOIN smg_users ON smg_charges.agentid = smg_users.userid
		WHERE smg_users.userid = '#form.userid#'
			<cfif client.companyid NEQ '5'>
				AND smg_charges.companyid = '#client.companyid#'
			</cfif>
			<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
				AND (smg_charges.invoicedate BETWEEN #CreateODBCDateTime(form.date1)# AND #CreateODBCDateTime(form.date2)#)
			</cfif>
		GROUP BY smg_users.userid, smg_charges.invoicedate
		UNION
		SELECT 'payments', smg_users.businessname, SUM( pay.totalreceived ) AS total_amount, pay.date as orderdate
		FROM smg_payment_received pay
		INNER JOIN smg_users ON pay.agentid = smg_users.userid
		WHERE smg_users.userid = '#form.userid#'
			AND pay.paymenttype != 'apply credit'
			<cfif client.companyid NEQ '5'>
				AND pay.companyid = '#client.companyid#'
			</cfif>
			<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
				AND (pay.date BETWEEN #CreateODBCDateTime(form.date1)# AND #CreateODBCDateTime(form.date2)#)
			</cfif>
		GROUP BY smg_users.userid, pay.date
		UNION
		SELECT 'credits', smg_users.businessname, SUM( smg_credit.amount ) AS total_amount, smg_credit.date as orderdate
		FROM smg_credit
		INNER JOIN smg_users ON smg_credit.agentid = smg_users.userid
		WHERE smg_users.userid = '#form.userid#'
			<cfif client.companyid NEQ '5'>
				AND smg_credit.companyid = '#client.companyid#'
			</cfif>
			<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
				AND (smg_credit.date BETWEEN #CreateODBCDateTime(form.date1)# AND #CreateODBCDateTime(form.date2)#)
			</cfif>
		GROUP BY smg_users.userid, smg_credit.date
		
		ORDER BY orderdate DESC
	</cfquery>
	<!--- END OF RUNNING BALANCE --->

	<!--- BEGINNING BALANCE --->
	<cfset beg_invoiced = '0'>
	<cfset beg_payments = '0'>
	<cfset beg_balance = '0'>

	<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
	
		<cfquery name="beginning_balance" datasource="caseusa">
			SELECT 'charges', smg_users.businessname, SUM( smg_charges.amount_due ) AS total_amount, smg_charges.invoicedate as orderdate
			FROM smg_charges
			INNER JOIN smg_users ON smg_charges.agentid = smg_users.userid
			WHERE smg_users.userid = '#form.userid#'
				<cfif client.companyid NEQ '5'>
					AND smg_charges.companyid = '#client.companyid#'
				</cfif>
				<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
					AND smg_charges.invoicedate < #CreateODBCDateTime(form.date1)#
				</cfif>
			GROUP BY smg_users.userid, smg_charges.invoicedate
			UNION
			SELECT 'payments', smg_users.businessname, SUM( pay.totalreceived ) AS total_amount, pay.date as orderdate
			FROM smg_payment_received pay
			INNER JOIN smg_users ON pay.agentid = smg_users.userid
			WHERE smg_users.userid = '#form.userid#'
				AND pay.paymenttype != 'apply credit'
				<cfif client.companyid NEQ '5'>
					AND pay.companyid = '#client.companyid#'
				</cfif>
				<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
					AND pay.date < #CreateODBCDateTime(form.date1)#
				</cfif>
			GROUP BY smg_users.userid, pay.date
			UNION
			SELECT 'credits', smg_users.businessname, SUM( smg_credit.amount ) AS total_amount, smg_credit.date as orderdate
			FROM smg_credit
			INNER JOIN smg_users ON smg_credit.agentid = smg_users.userid
			WHERE smg_users.userid = '#form.userid#'
				<cfif client.companyid NEQ '5'>
					AND smg_credit.companyid = '#client.companyid#'
				</cfif>
				<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
					AND smg_credit.date < #CreateODBCDateTime(form.date1)#
				</cfif>
			GROUP BY smg_users.userid, smg_credit.date
			
			ORDER BY orderdate
		</cfquery>
		
		<cfloop query="beginning_balance">
			<cfif charges EQ 'charges'>
				<cfset beg_invoiced = beg_invoiced + total_amount>			
			</cfif>
			<cfif charges EQ 'payments'>
				<cfset beg_payments = beg_payments + total_amount>
			</cfif>
			<cfif charges EQ 'credits'>
				<cfset beg_payments = beg_payments + total_amount>					
			</cfif>	
			<cfset beg_balance = beg_invoiced - beg_payments>	
		</cfloop>
	
	</cfif>
	<!--- END OF BEGINNING BALANCE --->

	<!--- OUTSTANDING BALANCE --->
	<cfquery name="outstanding_balance" datasource="caseusa">
		SELECT 'charges', smg_users.businessname, SUM( smg_charges.amount_due ) AS total_amount, smg_charges.invoicedate as orderdate
		FROM smg_charges
		INNER JOIN smg_users ON smg_charges.agentid = smg_users.userid
		WHERE smg_users.userid = '#form.userid#'
			<cfif client.companyid NEQ '5'>
				AND smg_charges.companyid = '#client.companyid#'
			</cfif>
			<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
				AND (smg_charges.invoicedate BETWEEN #CreateODBCDateTime(form.date1)# AND #CreateODBCDateTime(form.date2)#)
			</cfif>
		GROUP BY smg_users.userid, smg_charges.invoicedate
		UNION
		
		SELECT 'payments', smg_users.businessname, SUM( pay.totalreceived ) AS total_amount, pay.date as orderdate
		FROM smg_payment_received pay
		INNER JOIN smg_users ON pay.agentid = smg_users.userid
		WHERE smg_users.userid = '#form.userid#'
			AND pay.paymenttype != 'apply credit'
			<cfif client.companyid NEQ '5'>
				AND pay.companyid = '#client.companyid#'
			</cfif>
			<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
				AND (pay.date BETWEEN #CreateODBCDateTime(form.date1)# AND #CreateODBCDateTime(form.date2)#)
			</cfif>
		GROUP BY smg_users.userid, pay.date
		UNION
		
		SELECT 'credits', smg_users.businessname, SUM( smg_credit.amount ) AS total_amount, smg_credit.date as orderdate
		FROM smg_credit
		INNER JOIN smg_users ON smg_credit.agentid = smg_users.userid
		WHERE smg_users.userid = '#form.userid#'
			<cfif client.companyid NEQ '5'>
				AND smg_credit.companyid = '#client.companyid#'
			</cfif>
			<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
				AND (smg_credit.date BETWEEN #CreateODBCDateTime(form.date1)# AND #CreateODBCDateTime(form.date2)#)
			</cfif>
		GROUP BY smg_users.userid, smg_credit.date
		
		ORDER BY orderdate
	</cfquery>

	<cfset out_invoiced = '0'>
	<cfset out_payments = '0'>
	
	<cfloop query="outstanding_balance">
		<cfif charges EQ 'charges'>
			<cfset out_invoiced = out_invoiced + total_amount>
		</cfif>
		<cfif charges EQ 'payments'>
			<cfset out_payments = out_payments + total_amount>
		</cfif>
		<cfif charges EQ 'credits'>
			<cfset out_payments = out_payments + total_amount>
		</cfif>
	</cfloop>
	<cfset outstanding = beg_balance + (out_invoiced - out_payments)>
	<!--- END OF OUTSTANDING BALANCE --->

	<cfset total_invoiced = '0'>
	<cfset total_payments = '0'>
	<cfset running_balance = outstanding>

	<table width="650" cellpadding="2" cellspacing="0" border="1" align="center">
		<tr><th colspan="5">
				<table width="100%">
					<tr>
						<th width="100"><img src="../../pics/logos/#get_companyname.companyid#.gif" border="0" /></th>
						<th width="450" valign="top">#get_companyname.companyname# <br /><br /> Account Statement</th>
					</tr>
				</table>
			</th>
		</tr>
		<tr>
			<th colspan="5">
				Intl. Agent: &nbsp; #get_intl_rep.businessname# <br /> <br />
				OUTSTANDING BALANCE: #LSCurrencyFormat(outstanding, 'local')#<br />
				<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
				<br /> From &nbsp; #DateFormat(form.date1, 'mm/dd/yyyy')# &nbsp; to &nbsp; #DateFormat(form.date2, 'mm/dd/yyyy')#
				</cfif>
			</th>
		</tr>

		<!--- RUNNING BALANCE --->
		<tr>
			<th>Date</th><th>Invoiced</th><th>Payments</th><th>Credits & <br /> Cancelations</th><th>Running <br /> Balance</th></tr>
		</tr>				
		<cfloop query="get_statement">
		<tr <cfif currentrow MOD 2 EQ 0>bgcolor="##E0E0E0"<cfelse>bgcolor="##FFFFFF"</cfif>>
			<td align="center">#DateFormat(orderdate, 'mm/dd/yyyy')#</td>
			<td align="center">
				<cfif charges EQ 'charges'>
					#LSCurrencyFormat(total_amount, 'local')#
					<cfset total_invoiced = total_invoiced + total_amount>
				<cfelse>
					&nbsp;						
				</cfif>
			</td>
			<td align="center">
				<cfif charges EQ 'payments'>
					<font color="##FF0000">#LSCurrencyFormat(total_amount, 'local')#</font>
					<cfset total_payments = total_payments + total_amount>
				<cfelse>
					&nbsp;	
				</cfif>
			</td>
			<td align="center">
				<cfif charges EQ 'credits'>
					<font color="##FF0000">#LSCurrencyFormat(total_amount, 'local')#</font>
					<cfset total_payments = total_payments + total_amount>
				<cfelse>
					&nbsp;						
				</cfif>
			</td>
			<td align="center">
				<cfset last_balance = running_balance>
				<cfset running_balance = outstanding - (total_invoiced - total_payments)>
				<cfif last_balance LT 0>
					<font color="##FF0000">#LSCurrencyFormat(last_balance, 'local')#</font>
				<cfelse>
					#LSCurrencyFormat(last_balance, 'local')#
				</cfif>
			</td>
		</tr>
		</cfloop>
		<!--- END OF RUNNING BALANCE --->

		<!--- BEGINNING BALANCE --->
		<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
			<tr>
				<th>Date</th><th>Invoiced</th><th>Payments</th><th>Credits & <br /> Cancelations</th><th>Beginning <br /> Balance</th></tr>
			</tr>		
			<tr>
				<td align="center"><b> < </b> &nbsp; #DateFormat(form.date1, 'mm/dd/yyyy')#</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td align="center">#LSCurrencyFormat(beg_balance, 'local')#</td>
			</tr>
		</cfif>
		<!--- END OF BEGINNING BALANCE --->

	</table><br />

</cfif>

</cfoutput>

</body>
</html>


<!---- STATEMENT OUTSTANDING BALANCE IS THE LAST LINE 

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>SMG Statement</title>
</head>

<body>

<Cfquery name="get_intl_rep" datasource="caseusa">
	SELECT userid, businessname
	FROM smg_users
	WHERE usertype = '8'
		AND active = '1'
		<cfif client.usertype GT '4'>
			AND userid = <cfqueryparam value="#client.userid#" cfsqltype="cf_sql_integer">
		</cfif>
	ORDER BY businessname
</Cfquery>

<cfquery name="get_companyname" datasource="caseusa">
	SELECT companyid, companyname
	FROM smg_companies
	WHERE companyid = <cfqueryparam value="#client.companyid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfoutput>

<cfif NOT IsDefined('form.userid')>
	<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
		<tr valign=middle height=24>
			<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
			<td width=26 background="pics/header_background.gif"><img src="pics/$.gif"></td>
			<td background="pics/header_background.gif"><h2>Account Statement</h2></td>
			<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
		</tr>
	</table>
	
	<table border=0 cellpadding=8 cellspacing=2 width=100% class="section">
		<tr>
			<td width="100%" valign="top" align="center">
				<cfform action="invoice/reports/statement.cfm" method="POST" target="blank">
					<Table class="nav_bar" cellpadding=6 cellspacing="0" width="60%" align="center">
						<tr><th colspan="2" bgcolor="##e2efc7">Statement</th></tr>
						<tr align="left">
							<td>Intl. Rep:</td>
							<td><select name="userid" size="1">
								<cfloop query="get_intl_rep">
									<option value="#userid#">#businessname#</option>
								</cfloop>
								</select>
							</td>
						</tr>
						<tr>
							<td>From : </td>
							<td><cfinput type="text" name="date1" size="8" maxlength="10" validate="date"> mm-dd-yyyy</td>
						</tr>
						<tr>
							<td>To : </td>
							<td><cfinput type="text" name="date2" size="8" maxlength="10" validate="date"> mm-dd-yyyy</td>
						</tr>			
						<tr><td>* Dates are not required.</td></tr>
						<tr><td>&nbsp;</td></tr>	
						<tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
					</table>
				</cfform>
			</td>
		</tr>
	</table>
<cfinclude template="../../table_footer.cfm">	

<!--- REPORT --->
<cfelse>

	<Cfquery name="get_intl_rep" datasource="caseusa">
		SELECT businessname, firstname, lastname, city, smg_countrylist.countryname
		FROM smg_users
		LEFT JOIN smg_countrylist ON smg_countrylist.countryid = smg_users.country
		WHERE userid = <cfqueryparam value="#form.userid#" cfsqltype="cf_sql_integer">
	</Cfquery>
	
	<cfquery name="get_statement" datasource="caseusa">
		SELECT 'charges', smg_users.businessname, SUM( smg_charges.amount_due ) AS total_amount, smg_charges.invoicedate as orderdate
		FROM smg_charges
		INNER JOIN smg_users ON smg_charges.agentid = smg_users.userid
		WHERE smg_users.userid = '#form.userid#'
			<cfif client.companyid NEQ '5'>
				AND smg_charges.companyid = '#client.companyid#'
			</cfif>
			<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
				AND (smg_charges.invoicedate BETWEEN #CreateODBCDateTime(form.date1)# AND #CreateODBCDateTime(form.date2)#)
			</cfif>
		GROUP BY smg_users.userid, smg_charges.invoicedate
		UNION
		SELECT 'payments', smg_users.businessname, SUM( pay.totalreceived ) AS total_amount, pay.date as orderdate
		FROM smg_payment_received pay
		INNER JOIN smg_users ON pay.agentid = smg_users.userid
		WHERE smg_users.userid = '#form.userid#'
			AND pay.paymenttype != 'apply credit'
			<cfif client.companyid NEQ '5'>
				AND pay.companyid = '#client.companyid#'
			</cfif>
			<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
				AND (pay.date BETWEEN #CreateODBCDateTime(form.date1)# AND #CreateODBCDateTime(form.date2)#)
			</cfif>
		GROUP BY smg_users.userid, pay.date
		UNION
		SELECT 'credits', smg_users.businessname, SUM( smg_credit.amount ) AS total_amount, smg_credit.date as orderdate
		FROM smg_credit
		INNER JOIN smg_users ON smg_credit.agentid = smg_users.userid
		WHERE smg_users.userid = '#form.userid#'
			<cfif client.companyid NEQ '5'>
				AND smg_credit.companyid = '#client.companyid#'
			</cfif>
			<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
				AND (smg_credit.date BETWEEN #CreateODBCDateTime(form.date1)# AND #CreateODBCDateTime(form.date2)#)
			</cfif>
		GROUP BY smg_users.userid, smg_credit.date
		
		ORDER BY orderdate
	</cfquery>

	<!--- GET BEGINNING BALANCE ---->
	<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
		<cfquery name="beginning_balance" datasource="caseusa">
			SELECT 'charges', smg_users.businessname, SUM( smg_charges.amount_due ) AS total_amount, smg_charges.invoicedate as orderdate
			FROM smg_charges
			INNER JOIN smg_users ON smg_charges.agentid = smg_users.userid
			WHERE smg_users.userid = '#form.userid#'
				<cfif client.companyid NEQ '5'>
					AND smg_charges.companyid = '#client.companyid#'
				</cfif>
				<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
					AND smg_charges.invoicedate < #CreateODBCDateTime(form.date1)#
				</cfif>
			GROUP BY smg_users.userid, smg_charges.invoicedate
			UNION
			SELECT 'payments', smg_users.businessname, SUM( pay.totalreceived ) AS total_amount, pay.date as orderdate
			FROM smg_payment_received pay
			INNER JOIN smg_users ON pay.agentid = smg_users.userid
			WHERE smg_users.userid = '#form.userid#'
				AND pay.paymenttype != 'apply credit'
				<cfif client.companyid NEQ '5'>
					AND pay.companyid = '#client.companyid#'
				</cfif>
				<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
					AND pay.date < #CreateODBCDateTime(form.date1)#
				</cfif>
			GROUP BY smg_users.userid, pay.date
			UNION
			SELECT 'credits', smg_users.businessname, SUM( smg_credit.amount ) AS total_amount, smg_credit.date as orderdate
			FROM smg_credit
			INNER JOIN smg_users ON smg_credit.agentid = smg_users.userid
			WHERE smg_users.userid = '#form.userid#'
				<cfif client.companyid NEQ '5'>
					AND smg_credit.companyid = '#client.companyid#'
				</cfif>
				<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
					AND smg_credit.date < #CreateODBCDateTime(form.date1)#
				</cfif>
			GROUP BY smg_users.userid, smg_credit.date
			
			ORDER BY orderdate
		</cfquery>
	</cfif>
	
	<cfset total_invoiced = '0'>
	<cfset total_payments = '0'>
	<cfset running_balance = '0'>
	<cfset beg_balance = '0'>

	<table width="550" cellpadding="3" cellspacing="0" border="1" align="center">
		<tr><th colspan="5">
				<table width="100%">
					<tr>
						<th width="100"><img src="../../pics/logos/#get_companyname.companyid#.gif" border="0" /></th>
						<th width="450" valign="top">#get_companyname.companyname# <br /><br /> Account Statement</th>
					</tr>
				</table>
			</th>
		</tr>
		<tr>
			<td colspan="5">
				<form name="get_balance">
				Intl. Agent: &nbsp; <b>#get_intl_rep.businessname#</b>  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp; 
				Outstanding Balance: <input name="balance" type="text" size="10" disabled="disabled" />
				</form>
			</td>
		</tr>
		<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
		<tr><td colspan="5">From &nbsp; #DateFormat(form.date1, 'mm/dd/yyyy')# &nbsp; to &nbsp; #DateFormat(form.date2, 'mm/dd/yyyy')#</td></tr>
		</cfif>
		
		<!--- Beginning Balance --->
		<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
			<cfset beg_invoiced = '0'>
			<cfset beg_payments = '0'>
			<tr>
				<th>Date</th><th>Invoiced</th><th>Payments</th><th>Credits & <br /> Cancelations</th><th>Beginning <br /> Balance</th></tr>
			</tr>		
			<cfloop query="beginning_balance">
				<cfif charges EQ 'charges'>
					<cfset beg_invoiced = beg_invoiced + total_amount>			
				</cfif>
				<cfif charges EQ 'payments'>
					<cfset beg_payments = beg_payments + total_amount>
				</cfif>
				<cfif charges EQ 'credits'>
					<cfset beg_payments = beg_payments + total_amount>					
				</cfif>	
				<cfset beg_balance = beg_invoiced - beg_payments>	
			</cfloop>
			<tr>
				<td align="center">< &nbsp; #DateFormat(form.date1, 'mm/dd/yyyy')#</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td align="center">#LSCurrencyFormat(beg_balance, 'local')#</td>
			</tr>
		</cfif>

		<tr>
			<th>Date</th><th>Invoiced</th><th>Payments</th><th>Credits & <br /> Cancelations</th><th>Running <br /> Balance</th></tr>
		</tr>				
		<cfloop query="get_statement">
		<tr>
			<td align="center">#DateFormat(orderdate, 'mm/dd/yyyy')#</td>
			<td align="center">
				<cfif charges EQ 'charges'>
					#LSCurrencyFormat(total_amount, 'local')#
					<cfset total_invoiced = total_invoiced + total_amount>
				<cfelse>
					&nbsp;						
				</cfif>
			</td>
			<td align="center">
				<cfif charges EQ 'payments'>
					<font color="##FF0000">#LSCurrencyFormat(total_amount, 'local')#</font>
					<cfset total_payments = total_payments + total_amount>
				<cfelse>
					&nbsp;	
				</cfif>
			</td>
			<td align="center">
				<cfif charges EQ 'credits'>
					<font color="##FF0000">#LSCurrencyFormat(total_amount, 'local')#</font>
					<cfset total_payments = total_payments + total_amount>
				<cfelse>
					&nbsp;						
				</cfif>
			</td>
			<td align="center">
				<cfset running_balance = beg_balance + (total_invoiced - total_payments)>
				<cfif running_balance LT 0>
					<font color="##FF0000">#LSCurrencyFormat(running_balance, 'local')#</font>
				<cfelse>
					#LSCurrencyFormat(running_balance, 'local')#
				</cfif>
			</td>
		</tr>
		</cfloop>
		
		<!--- javascript - set outstanding balance --->
		<script language="JavaScript">
		<!--// 
			document.get_balance.balance.value = '#LSCurrencyFormat(running_balance, 'local')#';
		//-->
		</script>			
		
	</table><br />

</cfif>

</cfoutput>

</body>
</html>

--->