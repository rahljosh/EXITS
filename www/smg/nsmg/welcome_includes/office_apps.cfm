<!----Application Info---->
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/news.gif"></td>
		<td background="pics/header_background.gif"><h2>Current Application Stats - Office</h2></td>
		<td background="pics/header_background.gif" width=16></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>
					
<table width=100% cellpadding=4 cellspacing=0 border=0 class="section">
	<tr>
		<td style="line-height:20px;" valign="top" width="100%">
		<table width=100% valign="top">
			<tr>
				<th colspan="3" align="center" bgcolor="#999999">Waiting on Student</th>
				<th colspan="2" align="center" bgcolor="#CCCCCC">Waiting on Agent</th>
				<th colspan="5" align="center" bgcolor="#999999">Waiting on <cfoutput>#client.company_submitting#</cfoutput></th>
			</tr>
			<tr>
				<th valign="top">Issued</th>
				<th valign="top">Active</th>
                <th valign="top">Future</th>
				<th valign="top">To Approve</th>
				<th valign="top">Denied</th>
				<th valign="top">Submitted</th>
				<th valign="top">Received</th>
				<th valign="top">Denied</th>
				<th valign="top">On Hold</th>
				<th valign="top">Approved</th>
			</tr>
			<tr>
				<cfloop list = '1,2,25,5,6,7,8,9,10,11' index="i">
                    <td align="center">	
                        <cfquery name="apps" datasource="#application.dsn#">
                            SELECT COUNT(*) AS count 
                            FROM smg_students
	                        <!--- RANDID = TO IDENTIFY ONLINE APPS --->
                            WHERE randid != 0
                            <cfif i neq 9>
                                AND active = 1
                            </cfif>
                            AND (
                            	app_current_status = #i#
								<cfif i EQ 2>
                                	OR app_current_status = 3 OR app_current_status = 4
                                </cfif>
                            )
                            <cfif client.companyid gt 5>
                            and companyid = #client.companyid#
                            </cfif>
                        </cfquery> 
                        <cfoutput><a href="index.cfm?curdoc=student_app/student_list_intrep&status=#i#">#apps.count#</a></cfoutput>
                    </td>
				</cfloop>
                </tr>
			<tr><td colspan=3 align="right">Apps you are entering can be found here </td>
            	<td>&nbsp;&nbsp;&nbsp;&nbsp;<img src="pics/arrow_rt.gif"></td></tr>
				<tr><td colspan=10 align="center"> 
                <cfoutput>
                <cfif client.companyid gt 5>
                	<a href="index.cfm?curdoc=student_app/question_start_student"><img src="student_app/pics/#client.companyid#_startApplication.png" border=0></a>
					</cfif>
                    </cfoutput>
				</td></tr>
		</table>
	</td>
	<td align="right" valign="top" rowspan=2></td>
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
<br />