<!----Application Info---->

					
<table width=100% cellpadding=4 cellspacing=0 border=0>
	<tr>
		<td style="line-height:20px;" valign="top" width="100%">
		<table width=100% valign="top">
			<tr>
				<th colspan="2" align="center" bgcolor="#fef3b9">Waiting on Host</th>
				<th colspan="2" align="center" bgcolor="#bed0fc">Waiting on Field</th>
				<th colspan="2" align="center" bgcolor="#bde2ac">Waiting on <cfoutput>#client.company_submitting#</cfoutput></th>
			</tr>
			<tr>
				<th valign="top">Started</th>
				<th valign="top">Host</th>                
				<th valign="top">Field</th>
				<th valign="top">Manager</th>
				<th valign="top">NY</th>
				<th valign="top">Approved</th>

			</tr>
			<tr>
				<cfloop list = '9,8,7,6,5,4' index="i">
                    <td align="center">	
                        <cfquery name="apps" datasource="#application.dsn#">
                            SELECT 
                            	COUNT(hostid) AS count 
                            FROM 
                            	smg_hosts
                            WHERE 
   	                        <!--- RANDID = TO IDENTIFY ONLINE APPS --->
                            	hostAppStatus != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                                
                            <!--- Do not get active reps if viewing a rejected status --->     
							
                            
                                     
                                AND 
                                
                                    hostAppStatus = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#"> 
                            

							
                           		AND 
                                	companyID 
                                    <cfif client.companyid eq 10>
                                    	 = <cfqueryparam cfsqltype="cf_sql_integer" value="10">
                                     <cfelse>
                                     	< <cfqueryparam cfsqltype="cf_sql_integer" value="6">
                                     </cfif>
                           
                      		
                        </cfquery> 
                        
                        <cfoutput><a href="index.cfm?curdoc=hostApplication/listOfApps&status=#i#">#apps.count#</a></cfoutput>
                    </td>
				</cfloop>
                </tr>
		</table>
	</td>
	<td align="right" valign="top" rowspan=2></td>
	</tr>
</table>
