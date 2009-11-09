<!----Application Info---->
<style type="text/css">
<!--
.style1 {font-size: 11px}
-->
</style>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/news.gif"></td>
		<td background="pics/header_background.gif"><h2>Current Online Application Stats</h2></td>
		<td background="pics/header_background.gif" width=16></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>
					
<table width=100% cellpadding=4 cellspacing=0 border=0 class="section">
	<tr>
		<td style="line-height:20px;" valign="top" width="100%">
		<table width=100% valign="top" border=0>
			<tr class="style1">
				<th colspan="2" align="center" bgcolor="#E2E2E2">Student</th>
				<th colspan="2" align="center" bgcolor="#CCCCCC">Branch</th>
				<th colspan="2" align="center" bgcolor="#CCCCCC">Main Office</th>
				<th colspan="5" align="center" bgcolor="#B0B0B0">SMG</th>
			</tr>			
			<tr class="style1">
				<th valign="top">Issued</th>
				<th valign="top">Active</th>
				<th valign="top">Apps to Approve</th>
				<th valign="top">Apps you Denied</th>
				<th valign="top">To be approved</th>
				<th valign="top">Denied</th>
				<th valign="top">Submitted</th>
				<th valign="top">Received</th>
				<th valign="top">Denied</th>
				<th valign="top">Hold</th>				
				<th valign="top">Approved</th>
			</tr>
			<tr class="style1">
			<cfloop list = '1,2,3,4,5,6,7,8,9,10,11' index="i">
				<td align="center">	
					<!----Application has been sent, but student hasn't logged in.---->
                    <cfquery name="apps" datasource="#application.dsn#">
                        SELECT COUNT(*) AS count 
                        FROM smg_students
                        WHERE branchid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
						<cfif not listFind("4,6,9", i)>
                        	AND active = 1
                        </cfif>
                        AND randid != 0
                        AND app_current_status = #i#
                    </cfquery>
                    <!--- RANDID = TO IDENTIFY ONLINE APPS --->
                    <cfoutput><a href="index.cfm?curdoc=student_app/student_app_list&status=#i#">#apps.count#</a></cfoutput>
				</td>
			</cfloop>
			</tr>
			<tr>
				<td colspan=2 align="right">Apps you are entering can be found here</td><td><img src="pics/arrow_rt.gif"></td>
			</tr>
			<tr><td colspan="11" align=center><a href="index.cfm?curdoc=student_app/question_start_student"><img src="student_app/pics/start-application.gif" border=0></a></td></tr>
		</table>
		</td>
	</tr>
</table>

<!----footer of table---->
<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr>
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>