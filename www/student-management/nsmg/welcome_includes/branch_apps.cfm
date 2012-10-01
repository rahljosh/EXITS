<table width=100% cellpadding=4 cellspacing=0 border=0>
	<tr>
		<td style="line-height:20px;" valign="top" width="100%">
		<table width=100% valign="top" border=0>
			<tr class="style1">
				<th colspan="2" align="center" bgcolor="#fef3b9">Waiting on Student</th>
				<th colspan="2" align="center" bgcolor="#fcd3a3">Waiting on Branch</th>
				<th colspan="2" align="center" bgcolor="#bed0fc">Waiting on Main Office</th>
				<th colspan="5" align="center" bgcolor="#bde2ac">Waiting on <cfoutput>#CLIENT.companyShort#</cfoutput></th>
			</tr>			
			<tr class="style1">
				<th valign="top">Issued</th>
				<th valign="top">Active</th>
				<th valign="top">Apps to Approve</th>
				<th valign="top">Apps you Denied</th>
				<th valign="top">To be Approved</th>
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
                        SELECT 
                        	COUNT(*) AS count 
                        FROM 
                        	smg_students
                        WHERE 
                        	branchid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
                            
						<!--- RANDID = TO IDENTIFY ONLINE APPS --->
                        AND    
                            randid != <cfqueryparam cfsqltype="cf_sql_integer" value="0">

						<!--- Display Current Status --->
                        AND 
                            app_current_status = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#"> 
                            
						<!--- Do not get active reps if viewing a rejected status --->     
                        <cfif NOT ListFind("4,6,9", i)>
                            AND 
                                active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
						<cfelse>
                            AND
                                canceldate IS NULL
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
				<td colspan=2 align="right">Apps you are entering can be found here</td><td><img src="pics/arrow_rt.gif"></td>
			</tr>
			<tr><td colspan="11" align=center><a href="index.cfm?curdoc=student_app/question_start_student"><img src="student_app/pics/start-application.gif" border=0></a></td></tr>
		</table>
		</td>
	</tr>
</table>