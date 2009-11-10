
	<link rel="stylesheet" type="text/css" href="../smg.css">
<cfquery name="get_student_id" datasource="mysql">
select studentid 
from smg_students 
where uniqueid = "#url.uniqueid#"
</cfquery>

<cfquery name="active_history" datasource="mysql">
select history.studentid, history.userid, history.reason, history.date,
smg_users.firstname, smg_users.lastname

from smg_active_stu_reasons history
LEFT  JOIN smg_users on smg_users.userid = history.userid

where history.studentid = #get_student_id.studentid#
</cfquery>

<cfoutput>
<table width="100%"cellpadding=0 cellspacing=0 border=0 height=24 bgcolor=##ffffff>
	<tr valign=middle height=24>
		<td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
		<td width="26" class="tablecenter" background="../pics/header_background.gif"><img src="../pics/students.gif"></td>
		<td class="tablecenter" background="../pics/header_background.gif"><h2>Active / Inactive History</h2></td>
		<td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>


<table width=100% cellpadding=0 cellspacing=0 border=0 align="center " class="section">
		<Tr>
			<td><strong>Reason</strong></td><td><strong>Who Changed</strong></td><td><strong>Date</strong></td>
	</Tr>
	<cfif active_history.recordcount eq 0>
	<tr>
		<td colspan=3 align="Center">There is no acitve / inactive history for this student</td>
	<cfelse>
	<cfloop query="active_history">
	<Tr>
		<td>#reason#</td><td>#firstname# #lastname#</td><td>#DateFormat(date, 'mm/dd/yyyy')#</td>	
	</Tr>
	</cfloop>
	</cfif>
		

</table>


<!--- FOOTER OF TABLE --->
<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign="bottom">
		<td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td>
		<td width=100% background="../pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td></tr>
</table>

</cfoutput>