<!----Application Info---->
<cfoutput>
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/news.gif"></td>
		<td background="pics/header_background.gif"><h2>Current Application Stats - Office</td>
		<td background="pics/header_background.gif" width=16></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>
					
<table width=100% cellpadding=4 cellspacing=0 border=0 class="section" 
	<tr>
		<td style="line-height:20px;" valign="top" width="100%">
		<table width=100% valign="top">
			<tr>
				<th colspan="2" align="center" bgcolor="##999999">Waiting on Student</th>
				<th colspan="2" align="center" bgcolor="##CCCCCC">Waiting on Agent</th>
				<th colspan="5" align="center" bgcolor="##999999">Waiting on CASE</th>
			</tr>
			<tr>
			
				<th valign="top">Issued</th>
				<th valign="top">Active</th>
				<th valign="top">To Approve</th>
				<th valign="top">Denied</th>
				<th valign="top">Submitted</th>
				<th valign="top">Received</th>
				<th valign="top">Denied</th>
				<th valign="top">On Hold</th>
				<th valign="top">Approved</th>
			</tr>
			<tr>
			
				
				<Cfloop list = '1,2,5,6,7,8,9,10,11' index="i">
				<Td align="center">	
					<cfquery name="apps" datasource="caseusa">
						SELECT studentid 
						from smg_students
						where app_current_status = '#i#'
							AND randid != '0'
							<cfif i neq 9>AND active = '1'</cfif>
							<cfif i EQ '2'>OR (randid != '0' AND (app_current_status = '3' OR app_current_status = '4'))</cfif> 
							
					</cfquery> 
					<!--- RANDID = TO IDENTIFY ONLINE APPS --->
					<a href="?curdoc=student_app/student_list_intrep&status=#i#">#apps.recordcount#</a>
				</Td>
				</cfloop>
			
			</tr>
		</table>
	</td>
	<td align="right" valign="top" rowspan=2></td>
	</tr>
</table>

<!----footer of table---->
<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>

<br />

</cfoutput>