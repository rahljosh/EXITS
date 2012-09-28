<!----Application Info---->

					
<table width=100% cellpadding=4 cellspacing=0 border=0>
	<tr>
		<td style="line-height:20px;" valign="top" width="100%">
		<table width=100% valign="top">
			<tr>
				<th colspan="2" align="center" bgcolor="#fef3b9">Waiting on Host</th>
				<th colspan="3" align="center" bgcolor="#bed0fc">Waiting on Field</th>
				<th colspan="2" align="center" bgcolor="#bde2ac">Waiting on <cfoutput>#client.company_submitting#</cfoutput></th>
			</tr>
			<tr>
				<th valign="top">Started</th>
				<th valign="top">Host</th>                
				<th valign="top">Rep</th>
                <th valign="top">Advisor</th>
				<th valign="top">Manager</th>
				<th valign="top">HQ</th>
				<th valign="top">Approved</th>

			</tr>
			<tr>
				<cfloop list = '9,8,7,6,5,4,3' index="i">
                    <td align="center">	
                    
					<cfif client.usertype eq 6>
                    <cfset userUnderList ='#client.userid#'>
                        <cfquery name="usersUnder" datasource="#application.dsn#">
                        select userid
                        from user_access_rights
                        where regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.regionid#">
                        AND advisorid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
                        </cfquery>
                        <cfloop query="usersUnder">
                        <Cfset userUnderList = #ListAppend(userUnderList, userid)#> 
                        </cfloop>
                    </cfif>

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
                                	
                                       <cfif listFind('1,2,3,4,12', '#client.companyid#')>
                                       companyID   = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
                                     <cfelseif client.companyid eq 5>
                                      (companyID   <  <cfqueryparam cfsqltype="cf_sql_integer" value="6"> OR 
                                      companyID   =  <cfqueryparam cfsqltype="cf_sql_integer" value="12">)
                                     </cfif>
								  <Cfif client.usertype eq 7>
                                      AND arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
                                  <cfelseif client.usertype eq 6>
                                    and 
                                        arearepid in (#userUnderList#) 
                                  <cfelseif client.usertype eq 5>
                                      AND regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.regionid#">
                                  
                                      
                                   </Cfif>
                        </cfquery> 
                        
                        <cfoutput><cfif #client.usertype# lte i><a href="index.cfm?curdoc=hostApplication/listOfApps&status=#i#"></cfif>#apps.count#</a></cfoutput>
                    </td>
				</cfloop>
                </tr>
		</table>
        
        	</td>
	<td align="right" valign="top" rowspan=2></td>
	</tr>
</table>
