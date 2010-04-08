<cfif not IsDefined('url.user')>
	<cfinclude template="error_message.cfm">
</cfif>

<link rel="stylesheet" href="../smg.css" type="text/css">

<cfinclude template="../querys/get_company_short.cfm">

<Cfquery name="rep_info" datasource="caseusa">
	SELECT firstname, lastname, userid
	FROM smg_users
	WHERE userid = <cfqueryparam value="#url.user#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="all_charges" datasource="caseusa">
	SELECT rep.id, rep.agentid, rep.amount, rep.comment, rep.date, rep.inputby, rep.companyid, rep.transtype,
		   s.firstname, s.familylastname, s.studentid,
		   type.type
	FROM smg_rep_payments rep
	LEFT JOIN smg_students s ON s.studentid = rep.studentid
	LEFT JOIN smg_payment_types type ON type.id = rep.paymenttype
	WHERE rep.agentid = <cfqueryparam value="#url.user#" cfsqltype="cf_sql_integer"> AND rep.companyid = '#client.companyid#'
	ORDER BY studentid, rep.date
</cfquery>

<cfoutput>
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/user.gif"></td>
		<td background="pics/header_background.gif"><h2>#companyshort.companyshort#</h2></td>
		<td align="right" background="pics/header_background.gif"><h2>All Payments for #rep_info.firstname# #rep_info.lastname#</h2></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td><b>Date</b></td><Td><b>ID</b></Td><td><b>Student</b></td><td><b>Type</b></td><td><b>Amount</b></td><td><b>Comment</b></td><td><b>Trans. Type</b></td></tr>
		<Cfif all_charges.recordcount is '0'>
		<tr><td colspan=5 align="center">No placement payments submitted.</td></tr>
		<cfelse>
			<cfset total = '0'>
			<cfloop query="all_charges">
			<tr bgcolor="#iif(all_charges.currentrow MOD 2 ,DE("ffffe6") ,DE("e2efc7") )#">
				<td>#DateFormat(date, 'mm/dd/yyyy')#</td>
				<Td>#id#</Td>
				<td><cfif studentid is ''>n/a<cfelse>#firstname# #familylastname# (#studentid#)</cfif></td>
				<Td>#type#</Td>  
				<td>#LSCurrencyFormat(amount, 'local')#</td>
				<td>#comment#</td>
				<td>#transtype#</td>
			</tr>
			<cfset total =  total +  #amount#>
			</cfloop>
			<tr><td colspan=4 align="right"><b>Total to Date:</b></td><td>#LSCurrencyFormat(total, 'local')#</td><td colspan=2></td></tr>
		</cfif>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr><td align="center" width="50%">&nbsp;<input type="image" value="Back" src="pics/back.gif" onClick="javascript:history.back()"></td></tr>
</table>

<!----footer of table---->
<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign="bottom">
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td></tr>
</table>

</cfoutput>