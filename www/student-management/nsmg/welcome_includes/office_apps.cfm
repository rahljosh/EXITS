<!----Application Info---->

					
<table width=100% cellpadding=4 cellspacing=0 border=0>
	<tr>
		<td style="line-height:20px;" valign="top" width="100%">
		<table width=100% valign="top">
			<tr>
				<th colspan="3" align="center" bgcolor="#fef3b9">Waiting on Student</th>
				<th colspan="2" align="center" bgcolor="#bed0fc">Waiting on Intl. Rep.</th>
				<th colspan="5" align="center" bgcolor="#bde2ac">Waiting on <cfoutput>#client.company_submitting#</cfoutput></th>
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
                            SELECT 
                            	COUNT(*) AS count 
                            FROM 
                            	smg_students
                            WHERE 
   	                        <!--- RANDID = TO IDENTIFY ONLINE APPS --->
                            	randid != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                                
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

							<!--- Filter for Case, WEP and ESI --->
                            <cfif ListFind(APPLICATION.SETTINGS.COMPANYLIST.NonISE, CLIENT.companyID)>
                           		AND 
                                	companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
                            <cfelse>
                            	AND
                                	companyID NOT IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.NonISE#" list="yes"> )
                            </cfif>	
                      		
                        </cfquery> 
                        
                        <cfoutput><a href="index.cfm?curdoc=student_app/student_list_intrep&status=#i#">#apps.count#</a></cfoutput>
                    </td>
				</cfloop>
                </tr>
		</table>
	</td>
	<td align="right" valign="top" rowspan=2></td>
	</tr>
</table>
