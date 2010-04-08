<!----Application Info---->
<cfoutput>

<!--- EF CENTRAL OFFICES --->			
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/news.gif"></td>
		<td background="pics/header_background.gif"><h2>HQ Online Application Stats</td>
		<td background="pics/header_background.gif" width=16></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>
					
<table width=100% cellpadding=4 cellspacing=0 border=0 class="section" >
	<tr>
		<td style="line-height:20px;" valign="top" width="100%">
			<table width=100% valign="top" border=0>
			<tr>
				<th></th>
				<th colspan="4" align="center" bgcolor="##CCCCCC">Waiting on Agent</th>
				<th colspan="5" align="center" bgcolor="##999999">Waiting on CASE </th>
			</tr>
			<tr>
				<th></th>
				<th valign="top">Issued</th>
				<th valign="top">Active</th>
				<th valign="top">To Approve</th>
				<th valign="top">Denied</th>
				<th valign="top">Submitted</th>
				<th valign="top">Received</th>
				<th valign="top">Denied</th>
				<th valign="top">Hold</th>
				<th valign="top">Approved</th>
			</tr>
			<tr>
				<td>Branches <a class=nav_bar href="" onClick="javascript: win=window.open('branch_hq_desc.cfm', 'Details', 'height=480, width=450, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><img src="pics/current_items.gif"  border=0></a></td>
					<Cfloop list = '1,2,5,6,7,8,9,10,11' index="i">
					<Td align="center">	
					<!----Application has been sent, but student hasn't logged in.---->
					<cfquery name="apps" datasource="caseusa">
						SELECT s.studentid 
						FROM smg_students s
						LEFT JOIN smg_users office ON s.intrep = office.userid
						WHERE s.randid != '0'
							AND s.active = '1'
							AND office.master_accountid = #client.userid# 
							AND intrep != '#client.userid#'
							<!--- INCLUDE BRANCH STUDENTS TO ACTIVE KIDS --->
							AND (s.randid != '0' AND (s.app_current_status = '#i#' <cfif i EQ '2'>OR s.app_current_status = '3' OR s.app_current_status = '4'</cfif> <cfif i EQ '7'>OR s.app_current_status = '8'</cfif> ))
					</cfquery>
					<!--- RANDID = TO IDENTIFY ONLINE APPS --->
					<a href="?curdoc=student_app/student_app_list&status=#i#&ef=central">#apps.recordcount#</a>
					</Td>
					</Cfloop>
				</tr>
				
				<tr>
				<td>HQ <a class=nav_bar href="" onClick="javascript: win=window.open('branch_hq_desc.cfm', 'Details', 'height=480, width=450, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><img src="pics/current_items.gif"  border=0></a></td>
					<Cfloop list = '1,2,5,6,7,8,9,10,11' index="i">
					<Td align="center">	
					<cfquery name="apps" datasource="caseusa">
						SELECT studentid 
						FROM smg_students
						WHERE intrep = '#client.userid#'
							AND randid != '0'
							AND active = '1'
							<!--- INCLUDE BRANCH STUDENTS TO ACTIVE KIDS --->
							AND (randid != '0' AND (app_current_status = '#i#' <cfif i EQ '2'>OR app_current_status = '3' OR app_current_status = '4'</cfif> <cfif i EQ '7'>OR app_current_status = '8'</cfif> ))
					</cfquery>
					<a href="?curdoc=student_app/student_app_list&status=#i#">#apps.recordcount#</a>
					</Td>
					</Cfloop>
				</tr>
				<tr><td colspan=3 align="right">Apps you are entering can be found here </td><td><img src="pics/arrow_rt.gif"></td></tr>
				<tr><td colspan="10" align=center><a href="?curdoc=student_app/question_start_student"><img src="student_app/pics/start-application.gif" border=0></a></td></tr>
			</table>
		</td>
		<td align="right" valign="top" rowspan=2>
	</tr>
</table>
<!----
<!--- EF OFFICES --->
<table width=100% cellpadding=4 cellspacing=0 border=0 class="section">
	<tr bgcolor="e2efc7"><td width="100%"><h2>EF Offices Online Application Stats</h2></td></tr>
	<tr>
		<td style="line-height:20px;" valign="top" width="100%">
			<table width=100% valign="top" border=0>
				<tr>
					<th valign="top">Issued</th>
					<th valign="top">Active</th>
					<th valign="top">Offices to Approve</th>
					<th valign="top">Denied by Offices</th>
					<th valign="top">Waiting on SMG</th>
					<th valign="top">Denied by SMG</th>
					<th valign="top">On Hold by SMG</th>
					<th valign="top">Approved by SMG</th>
				</tr>
				<tr>
					<Cfloop list = '1,2,5,6,7,9,10,11' index="i">
					<Td align="center">	
					<!----Application has been sent, but student hasn't logged in.---->
					<cfquery name="apps" datasource="caseusa">
						SELECT studentid 
						from smg_students
						where randid != '0'
							AND active = '1'
							<!--- INCLUDE BRANCH STUDENTS TO ACTIVE KIDS --->
							AND (randid != '0' AND (app_current_status = '#i#' <cfif i EQ '2'>OR app_current_status = '3' OR app_current_status = '4'</cfif> <cfif i EQ '7'>OR app_current_status = '8'</cfif> ))
							AND (intrep = <cfqueryparam value="#client.userid#" cfsqltype="cf_sql_integer">)
					</cfquery>
					<!--- RANDID = TO IDENTIFY ONLINE APPS --->
					<a href="?curdoc=student_app/student_app_list&status=#i#">#apps.recordcount#</a>
					</Td>
					</Cfloop>
				</tr>
			</table>
		</td>
		<td align="right" valign="top" rowspan=2>
	</tr>
</table>
---->

<!----footer of table---->
<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table><br />
</cfoutput>