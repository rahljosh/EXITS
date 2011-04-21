<cfparam name="URL.studentID" default="0">

<link rel="stylesheet" href="../smg.css" type="text/css">

<script>
function areYouSure() { 
   if(confirm("You are about to delete this payment record. You should only delete payments if they were entered by mistake. Click OK to continue")) { 
     form.submit(); 
        return true; 
   } else { 
        return false; 
   } 
} 
</script>

<cfinclude template="../querys/get_company_short.cfm">

<Cfquery name="student_info" datasource="MySQL">
	SELECT firstname, familylastname, studentid
	FROM smg_students
	WHERE studentid = <cfqueryparam value="#url.studentid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="get_charges" datasource="MySQL">
	SELECT rep.id, rep.agentid, rep.amount, rep.comment, rep.date, rep.inputby, rep.companyid, rep.transtype, rep.studentid,
		   u.firstname, u.lastname, u.userid,
		   type.type,
		   p.programname, p.programid
	FROM smg_rep_payments rep
	LEFT JOIN smg_users u ON u.userid = rep.agentid
	LEFT JOIN smg_payment_types type ON type.id = rep.paymenttype
	LEFT JOIN smg_programs p ON p.programid = rep.programid
	WHERE rep.studentid = <cfqueryparam value="#url.studentid#" cfsqltype="cf_sql_integer">
	ORDER BY rep.id, rep.date
</cfquery>

<cfoutput>
<table width=100% cellpadding=0 cellspacing=0 border="0" height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="../pics/header_background.gif"><img src="../pics/user.gif"></td>
		<td background="../pics/header_background.gif"><h2>#companyshort.companyshort#</h2></td>
		<td align="right" background="../pics/header_background.gif"><h2>All Payments for student #student_info.firstname# #student_info.familylastname# (#student_info.studentid#)</h2></td>
		<td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table width="100%" border="0" cellpadding=4 cellspacing=0 class="section">
	<tr><td><b>Date</b></td><Td><b>ID</b></Td><td><b>Rep</b></td><td><b>Type</b></td><td><b>Program</b></td><td><b>Amount</b></td><td><b>Comment</b></td><td><b>Trans. Type</b></td></tr>
		<Cfif get_charges.recordcount is '0'>
		<tr><td colspan="5" align="center">No payments submitted for this student.</td></tr>
		<cfelse>
			<cfset total = '0'>
			<cfloop query="get_charges">
			<tr bgcolor="#iif(get_charges.currentrow MOD 2 ,DE("ffffe6") ,DE("e2efc7") )#">
				<td>#DateFormat(date, 'mm/dd/yyyy')#</td>
				<Td>#id#</Td>
				<td>#firstname# #lastname# (#userid#)</td>
				<Td>#type#</Td> 
				<td>#programname# (###programid#)</td> 
				<td>#LSCurrencyFormat(amount, 'local')#</td>
				<td>#comment#</td>
				<td>#transtype#</td>
			</tr>
			<cfset total =  total +  #amount#>
			</cfloop>
			<tr><td colspan=4 align="right"><b>Total to Date:</b></td><td>#LSCurrencyFormat(total, 'local')#</td><td colspan=2></td></tr>
		</cfif>
</table>

<table border="0" cellpadding=4 cellspacing=0 width=100% class="section">
	<tr><td align="center" width="50%">&nbsp;<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></td></tr>
</table>

<!----footer of table---->
<table width=100% cellpadding=0 cellspacing=0 border="0">
	<tr valign="bottom">
		<td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td>
		<td width=100% background="../pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td></tr>
</table>

</cfoutput>