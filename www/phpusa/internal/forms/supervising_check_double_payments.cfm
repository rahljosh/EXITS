<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Untitled Document</title>
</head>

<body>

<cfoutput>

<cfquery name="get_payments" datasource="MySql">
	SELECT studentid, agentid, count( studentid ) AS totalstudents, paymenttype, programid
	FROM smg_rep_payments
	<!--- WHERE paymenttype = '3' OR paymenttype = '4' OR paymenttype = '5' OR paymenttype = '6' OR paymenttype = '7' OR paymenttype = '8' --->
	GROUP BY inputby, studentid, agentid, programid, paymenttype
	ORDER BY companyid, agentid, id
</cfquery>

<table width="100%" cellpadding="0" cellpadding="0" border="below">
	<tr>
		<td width="8%">Payment ID</td>
		<td width="8%">Input By</td>
		<td width="18%">Student</td>
		<td width="5%">Comp.</td>
		<td width="20%">Rep.</td>
		<td width="10%">Payment Type</td>
		<td width="8%">Date</td>
		<td width="7%">Amount</td>
		<td width="16%">Comment</td>
	</tr>
	<cfloop query="get_payments">
		<cfif totalstudents GTE 2>
			<cfquery name="get_details" datasource="MySql">
				SELECT payments.id, payments.studentid, payments.transtype, payments.amount,
					 payments.comment, payments.date, payments.inputby, payments.companyid,
					 types.type,
					 c.companyshort,
					 p.programname,
					 u.firstname as repfirst, u.lastname as replast, u.userid,
					 s.firstname as stufirst, s.familylastname as stulast, 
					 office.firstname as officefirst
				FROM smg_rep_payments payments
				LEFT JOIN smg_payment_types types ON types.id = payments.paymenttype
				LEFT JOIN smg_companies c ON c.companyid = payments.companyid
				LEFT JOIN smg_programs p ON p.programid = payments.programid
				LEFT JOIN smg_users u ON u.userid = payments.agentid
				LEFT JOIN smg_students s ON s.studentid = payments.studentid
				LEFT JOIN smg_users office ON office.userid = payments.inputby
				WHERE payments.studentid = '#studentid#' 
					AND payments.paymenttype = '#paymenttype#'
					AND payments.agentid = '#agentid#'
					AND payments.programid = '#programid#'
					<!--- AND date = #date# --->
			</cfquery>	
			<cfloop query="get_details">
				<tr><td>###id#</td>
					<td>#officefirst#</td>
					<td>#stufirst# #stulast# ###studentid#</td>
					<td>#companyshort#</td>
					<td>#repfirst# #replast# ###userid#</td>
					<td>#type#</td>
					<td>#DateFormat(date, 'mm/dd/yy')#</td>
					<td>#amount#</td>
					<td>#comment# &nbsp;</td>					
				</tr>
			</cfloop>
				<tr><td colspan="9">&nbsp;</td></tr>
		</cfif>
	</cfloop>
</table>
</cfoutput>

</body>
</html>