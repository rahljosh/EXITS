<!----Application Info---->
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/news.gif"></td>
		<td background="pics/header_background.gif"><h2>Current Online Application Stats</h2></td>
		<td background="pics/header_background.gif" width=16></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>
					
<table width=100% cellpadding=4 cellspacing=0 border=0 class="section" >
	<tr>
		<td style="line-height:20px;" valign="top" width="100%">
			<table width=100% valign="top" border=0>
				<tr>
					<th colspan="3" align="center" bgcolor="#fef3b9">Waiting on Student</th>
					<th colspan="2" align="center" bgcolor="#bed0fc">Waiting on Intl. Rep.</th> 
					<th colspan="5" align="center" bgcolor="#bde2ac">Waiting on <cfoutput>#CLIENT.companyShort#</cfoutput></th>
				</tr>
				<tr>
					<th valign="top">Issued</th>
					<th valign="top">Active</th>					
					<th valign="top">Future</th>
                    <th valign="top">Apps to Approve</th>
					<th valign="top">Apps you Denied</th>
                    <th valign="top">Submitted</th> 					
					<th valign="top">Received</th>
					<th valign="top">Denied</th>
					<th valign="top">Hold</th>
					<th valign="top">Approved</th>
				</tr>
				<tr>
				<cfloop list = '1,2,25,5,6,7,8,9,10,11' index="i">
					<td align="center">	
						<!----Application has been sent, but student hasn't logged in.---->
                        <cfquery name="apps" datasource="#application.dsn#">
                            SELECT 
                            	COUNT(*) AS count
                            FROM
                            	smg_students
                            WHERE
                            	intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
							
							<!--- RANDID = TO IDENTIFY ONLINE APPS --->
                            AND 
                            	(
                                	randid != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                                 OR
                                 	soid != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                                 )
                                 
                            <!--- Do not get active reps if viewing a rejected status --->     
							<cfif NOT ListFind("4,6,9", i)>
                                AND 
                                    active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
							<cfelse>
                                AND
                                    canceldate IS NULL
							</cfif>
    
                            <!--- Display Branch Applications (3/4) in the Active list --->
                            <cfif CLIENT.usertype NEQ 11 AND i EQ 2>
                                AND 
                                    app_current_status IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#i#,3,4" list="yes"> )
                            <!--- Display Current Status --->
                            <cfelse>            
                                AND 
                                    app_current_status = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#"> 
                            </cfif>
                            
                            <!--- Keep Exchange Service Information Apps separate --->
                            <cfif ListFind(APPLICATION.SETTINGS.COMPANYLIST.ESI, CLIENT.companyID)>
                            	AND
                                	companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
                            </cfif>
                            
                        </cfquery>
                     
                        <cfoutput><a href="index.cfm?curdoc=student_app/student_app_list&status=#i#">#apps.count#</a></cfoutput>
					</td>
				</cfloop>
				</tr>
				<tr>
                	<td colspan="3" align="right">Apps you are entering can be found here </td>
                	<td><img src="pics/arrow_rt.gif" align="middle"></td>
                </tr>
				<tr><td colspan=10 align="center">
                	
					<!--- Do Not Display Start Application Process for Bellnor - This agent is now a branch of Troika --->
                    <cfif CLIENT.userID NEQ 8134>
	                    <a href="index.cfm?curdoc=student_app/question_start_student"><img src="student_app/pics/start-application.gif" border=0></a>
					</cfif>
                    
					<!--- INTO Germany / Into Austria / XML Upload Feature --->
					<cfif client.userid eq 20 or client.userid eq 21 or client.userid eq 15130>
                        <br />
                        <a href="index.cfm?curdoc=xml/upload_form&novelaro">Try the XML upload feature.</a>
                    </cfif>
				</td></tr>
			</table>
		</td>
		<td align="right" valign="top" rowspan=2>
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