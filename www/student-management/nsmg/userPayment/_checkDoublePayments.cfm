<cfoutput>

<cfquery name="get_payments" datasource="MySql">
	SELECT studentID, agentid, count( studentID ) AS totalstudents, paymenttype, programID
	FROM smg_rep_payments
	<!--- WHERE paymenttype = '3' OR paymenttype = '4' OR paymenttype = '5' OR paymenttype = '6' OR paymenttype = '7' OR paymenttype = '8' --->
	GROUP BY inputby, studentID, agentid, programID, paymenttype
	ORDER BY companyID, agentid, id
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
				SELECT payments.id, payments.studentID, payments.transtype, payments.amount,
					 payments.comment, payments.date, payments.inputby, payments.companyID,
					 types.type,
					 c.companyshort,
					 p.programName,
					 u.firstName as repfirst, u.lastname as replast, u.userid,
					 s.firstName as stufirst, s.familyLastName as stulast, 
					 office.firstName as officefirst
				FROM smg_rep_payments payments
				LEFT JOIN smg_payment_types types ON types.id = payments.paymenttype
				LEFT JOIN smg_companies c ON c.companyID = payments.companyID
				LEFT JOIN smg_programs p ON p.programID = payments.programID
				LEFT JOIN smg_users u ON u.userid = payments.agentid
				LEFT JOIN smg_students s ON s.studentID = payments.studentID
				LEFT JOIN smg_users office ON office.userid = payments.inputby
				WHERE payments.studentID = '#studentID#' 
					AND payments.paymenttype = '#paymenttype#'
					AND payments.agentid = '#agentid#'
					AND payments.programID = '#programID#'
					<!--- AND date = #date# --->
			</cfquery>	
			<cfloop query="get_details">
				<tr><td>###id#</td>
					<td>#officefirst#</td>
					<td>#stufirst# #stulast# ###studentID#</td>
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