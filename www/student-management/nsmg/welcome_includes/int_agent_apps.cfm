<table width=100% cellpadding=4 cellspacing=0 border=0>
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
                           
							<!--- Filter for Case, WEP, Canada and ESI --->
                            <cfif ListFind(APPLICATION.SETTINGS.COMPANYLIST.NonISE, CLIENT.companyID)>
                                AND 
                                    companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
                            <cfelse>
                                AND
                                    companyID NOT IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.NonISE#" list="yes"> )
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
					<cfif ListFind('1,28,15310,20,109,628,9106,115,21,6584,15130,15330,10659', client.userid)>
                        <br />
                        <a href="index.cfm?curdoc=xml/upload_form&novelaro">Try the XML upload feature.</a>
                    </cfif>
				</td></tr>
			</table>
		</td>
		<td align="right" valign="top" rowspan=2>
	</tr>
</table>