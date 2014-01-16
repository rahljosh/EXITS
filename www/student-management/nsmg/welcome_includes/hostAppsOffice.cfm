
<table width=100% cellpadding=4 cellspacing=0 border=0>
	<tr>
		<td style="line-height:20px;" valign="top" width="100%">
		<table width=100% valign="top">
			<tr>
				<th colspan="2" align="center" bgcolor="#fef3b9">Waiting on Host</th>
				<th colspan="3" align="center" bgcolor="#bed0fc">Waiting on Field</th>
				<th colspan="2" align="center" bgcolor="#bde2ac">Waiting on <cfoutput>#CLIENT.company_submitting#</cfoutput></th>
			</tr>
			<tr>
				<th valign="top">Not Started</th>
				<th valign="top">Host</th>                
				<th valign="top">Area Rep.</th>
                <th valign="top">Advisor</th>
				<th valign="top">Manager</th>
				<th valign="top">HQ</th>
				<th valign="top">Approved</th>
			</tr>
			<tr>
				<cfloop list = '9,8,7,6,5,4,3' index="i">
                    <td align="center">	
                    
					<cfif CLIENT.usertype EQ 6>
                    	
						<cfset userUnderList = CLIENT.userID>
                        
                        <cfquery name="usersUnder" datasource="#application.dsn#">
                            select 
                            	userID
                            from 
                            	user_access_rights
                            where 	
                            	regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.regionID#">
                            AND 
                            	advisorid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
                        </cfquery>
                        
                        <cfloop query="usersUnder">
                        	<cfset userUnderList = ListAppend(userUnderList, userID)> 
                        </cfloop>
                        
                    </cfif>
                    
                    <cfscript>
						if (VAL(vSelectedSeason)) {
							vCurrentSeason = vSelectedSeason;	
						} else {
							vCurrentSeason = APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason().seasonID;
						}
					</cfscript>

                    <cfquery name="apps" datasource="#application.dsn#">
                        SELECT 
                            COUNT(smg_hosts.hostid) AS count 
                        FROM 
                            smg_hosts
                      	INNER JOIN smg_host_app_season ON smg_host_app_season.hostID = smg_hosts.hostID
                        	AND smg_host_app_season.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#vCurrentSeason#">
                            AND smg_host_app_season.applicationStatusID != 0
                        WHERE                        
                        <!--- Do not get active reps if viewing a rejected status --->
                            smg_host_app_season.applicationStatusID = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#"> 
                        AND
                        	active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                      	AND
                        	isHosting = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                    
						
                        <!--- ISE Divisions --->
                        <cfif CLIENT.companyID NEQ 5>
                            AND
                                companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
                        <!--- Get All ISE Apps --->
                        <cfelseif CLIENT.companyID eq 5>
                            AND
                                companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> ) 
                        </cfif>
                        
                        <!--- Area Rep --->
                        <cfif CLIENT.usertype eq 7>
                            AND 
                                arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
                        <!--- RA --->
                        <cfelseif CLIENT.usertype eq 6 AND len(userUnderList)>
                            AND 
                                arearepid in ( <cfqueryparam cfsqltype="cf_sql_integer" value="#userUnderList#" list="yes"> ) 
                        <!--- RM --->
                        <cfelseif CLIENT.usertype eq 5>
                            AND 
                                regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.regionID#">
                        </cfif>
                        
                    </cfquery> 
                    
                    <cfoutput><a href="index.cfm?curdoc=hostApplication/listOfApps&status=#i#&seasonID=#vCurrentSeason#">#apps.count#</a></cfoutput>
                </td>
            </cfloop>
            </tr>
		</table>
        
        	</td>
	<td align="right" valign="top" rowspan=2></td>
	</tr>
</table>