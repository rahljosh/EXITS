<!--- ------------------------------------------------------------------------- ----
	
	File:		initial_welcome.cfm
	Author:		Marcus Melo
	Date:		August 24, 2010
	Desc:		Initial Welcome page that includes news, students and host companies.

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../extensions/customTags/gui/" prefix="gui" />	

	<cfscript>
		// Get Application Status
		qStatus = APPLICATION.CFC.onlineApp.getApplicationStatus(applicationID=APPLICATION.applicationID);
		
		if ( VAL(CLIENT.usertype) LTE 4 ) {
			// Get Totals
			qGetTotalByStaus = APPLICATION.CFC.candidate.getTotalByStatus(); 
		} else { 
			// Get Totals
			qGetTotalByStaus = APPLICATION.CFC.candidate.getTotalByStatus(intRep=CLIENT.userID); 
		}
	</cfscript>

    <cfquery name="qNewsMessages" datasource="#APPLICATION.DSN.Source#">
        SELECT
        	*
        FROM
       		smg_news_messages
        WHERE
        	messagetype = <cfqueryparam cfsqltype="cf_sql_varchar" value="news">
        AND
        	expires > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
        AND
        	startdate < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
        AND 
        	companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
    </cfquery>

    <cfquery name="qNewCandidates" datasource="#APPLICATION.DSN.Source#">
        SELECT 
        	ec.firstname, 
            ec.lastname, 
            ec.residence_country, 
            ec.uniqueid,
        	cl.countryname
        FROM 
        	extra_candidates ec
        LEFT JOIN 
        	smg_countrylist cl ON cl.countryid = ec.residence_country 
        WHERE ec.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
       	<cfif IsDate(CLIENT.lastlogin)>
        	AND ec.entrydate > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CLIENT.lastlogin#">
      	</cfif>        	
        <cfif VAL(CLIENT.usertype) LTE 4>
            AND ec.applicationStatusID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="0,11" list="yes"> )
        <cfelseif CLIENT.userType EQ 8>
            AND ec.intRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
        <cfelseif CLIENT.userType EQ 11>
            AND ec.branchID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
         <cfelseif CLIENT.userType EQ 28>
            AND hostCompanyID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#CLIENT.hostCompanyID#">)
		</cfif>
    </cfquery>
   
    <cfquery name="qNewHostCompanies" datasource="#APPLICATION.DSN.Source#">
        SELECT 
        	ehc.hostcompanyid, 
            ehc.name, 
            ehc.city, 
            ehc.state, 
            ehc.homepage, 
            s.statename
        FROM 
        	extra_hostcompany ehc
        LEFT JOIN 
        	smg_states s ON s.id = ehc.state
     	<cfif IsDate(CLIENT.lastlogin)> 
        	WHERE ehc.entrydate > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CLIENT.lastlogin#">
       	</cfif>
    </cfquery>
    
</cfsilent>

<cfoutput>

<!--- Table Header --->
<table width="100%" style="border:1px solid ##CCCCCC">
    <tr>
        <td style="padding:15px;" width="40%" valign="top">
			
            <!--- System Messages --->
            <table cellspacing="0" cellpadding="3" width="100%" align="center" border="0" class="style1">
 						
				<!--- News & Announcements --->
                <tr>
                    <td colspan="2" style="font-weight:bold; text-decoration:underline;">News & Announcements</td>
                </tr>
                <tr>
                    <td valign="top" width="100%" class="style1" style="padding:10px 15px 15px 15px;">
                        <cfif qNewsMessages.recordCount>
                            <cfloop query="qNewsMessages">
                                <strong>#message#</strong><br>
                                #DateFormat(startdate, 'MMMM D, YYYY')# - #ParagraphFormat(details)#
                            </cfloop>
                        <cfelse>
                            <strong>#DateFormat(now(), 'mmm. d, yyyy')#</strong><br>
                            There are currently no announcements or news items.
                        </cfif>
                    </td>
                    <td align="right" valign="top">
                        <div align="right"><img src="../pics/tower.gif" width="31" height="51"></div>
                    </td>
                </tr>

                <!--- New Candidates --->
                <tr>
                    <td colspan="2" style="font-weight:bold; text-decoration:underline;">New Candidates</td>
                </tr>
                <tr>
                    <td colspan="2" valign="top" class="style1" style="padding:10px 15px 15px 15px;">
                        <cfif qNewCandidates.recordCount>
                            <cfloop query="qNewCandidates">
                                <a href="?curdoc=candidate/candidate_info&uniqueid=#qNewCandidates.uniqueid#" class="style4">
                                    #qNewCandidates.firstname# #qNewCandidates.lastname#
                                </a> 
                                <cfif LEN(qNewCandidates.countryName)>
                                	of #qNewCandidates.countryname# 
                                </cfif>
                                <br>
                            </cfloop>
                        <cfelse>
                            No new students have been added.
                        </cfif>
                    </td>
                </tr>

                <!--- New Host Companies --->
                <cfif CLIENT.userType LTE 4>
                    <tr>
                        <td colspan="2" style="font-weight:bold; text-decoration:underline;">New Host Companies</td>
                    </tr>
                    <tr>
                        <td colspan="2" valign="top" class="style1" style="padding:10px 15px 15px 15px;">
                            <cfif qNewHostCompanies.recordCount>
                                <cfloop query="qNewHostCompanies">
                                    <a href="?curdoc=hostcompany/hostCompanyInfo&hostcompanyid=#hostcompanyid#" class="style4">
                                        #qNewHostCompanies.name# in  #qNewHostCompanies.city#, #qNewHostCompanies.statename#
                                    </a> 
                                    <cfif LEN(qNewHostCompanies.homepage)>
                                        &nbsp; :: &nbsp; <a href="#qNewHostCompanies.homepage#" class="style4">Site</a>
                                    </cfif><br>
                                </cfloop>
                            <cfelse>
                                No new host companies have been added.
                            </cfif>
                        </td>
                    </tr>
				</cfif>
                
				<!--- Update Messages --->
				<cfif qUpdateMessages.recordCount>
					<tr>
						<td colspan="2" style="font-weight:bold; text-decoration:underline;">System Updates</td>
					</tr>
					<tr>
						<td colspan="2" valign="top" class="style1" style="padding:10px 15px 15px 15px;">
							<cfloop query="qUpdateMessages">
								<a class="style4"  href="" class="style4" onClick="javascript: win=window.open('message_details.cfm?id=#qUpdateMessages.messageid#', 'Details', 'height=480, width=450, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">
									<font style="font-weight:bold">#message#</font>
								</a> <br>
							</cfloop>
						</td>
					</tr>
				</cfif>
				
				<!--- Alert Messages --->
				<cfif qAlertMessages.recordCount>
					<tr>
						<td colspan="2" style="font-weight:bold; text-decoration:underline; color:##FF0000">Alerts</td>
					</tr>
					<tr>
						<td colspan="2" valign="top" class="style1" style="padding:10px 15px 15px 15px;">
							<cfloop query="qAlertMessages">
								<a class="style4" href="" onClick="javascript: win=window.open('message_details.cfm?id=#qAlertMessages.messageid#', 'Details', 'height=480, width=450, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">
									<font style="font-weight:bold">#message#</font>
								</a> <br>
							</cfloop>
						</td>
					</tr>
				</cfif>
                
                <!--- New Users --->
                <cfif NOT ListFind('1,2,3,4',CLIENT.userType)>
                    <tr>
                        <td colspan="2" style="font-weight:bold; text-decoration:underline;">New user in EXTRA?</td>
                    </tr>
                    <tr>
                        <td colspan="2" valign="top" class="style1" style="padding:10px 15px 15px 15px;">
                            <a href="onlineApplication/tutorial.cfm" style="color:red;">Click here for a breif tutorial</a>
                        </td>
                    </tr>
               	</cfif>
                
        	</table>

        </td>
		
        <!--- Application Stats --->
        <td style="padding:15px;" width="60%" valign="top">
            
			<!--- Page Messages --->
            <gui:displayPageMessages 
                pageMessages="#SESSION.pageMessages.GetCollection()#"
                messageType="section"
                />
            
            <table cellspacing="0" cellpadding="3" width="100%" align="center" border="0" class="style1">
                <tr>
                    <td colspan="2" style="font-weight:bold; text-decoration:underline">Online Application Stats</td>
                </tr>
                <tr>
                    <td valign="top" class="style1" style="padding:5px 0px 15px 0px;">
                    
						<table width="100%" class="applicationStatsTable" cellspacing="0" cellpadding="5" valign="top">
                            <tr style="min-height:12px;">
                                <th colspan="2" class="applicationStatsCandidate">Candidate</th>
								<!--- <th colspan="2" class="applicationStatsBranch">Intl. Branch</th> --->
                                <th colspan="3" class="applicationStatsIntlRep">Intl. Rep.</th>
                                <th colspan="3" class="applicationStatsCSB">CSB</th>
                            </tr>
                            <tr>
                                <cfloop query="qStatus">
                                    <th class="ApplicationStatsTitle"> 
										<a<cfif qStatus.statusID EQ 12> style="color:red"</cfif> href="index.cfm?curdoc=onlineApplication/index&action=list&statusID=#qStatus.statusID#" title="#qStatus.description#">#qStatus.name#</a>
                                	</th>
                                </cfloop>
     						</tr>
                            <tr>
                                <cfloop query="qGetTotalByStaus">
                                    <td align="center">
                                    	<a href="index.cfm?curdoc=onlineApplication/index&action=list&statusID=#qGetTotalByStaus.statusID#" title="#qStatus.description[qGetTotalByStaus.currentRow]#">#qGetTotalByStaus.total#</a>
                                    </td>
                                </cfloop>
     						</tr>
                            
                            <!--- Intl. Reps --->
                            <cfif CLIENT.userType EQ 8>
                                <tr>
                                    <td colspan="2" align="right">Applications you are <br /> entering can be found here </td>
                                    <td class="applicationStatsEnterHere"></td>
                                </tr>
                                <tr>
                                	<td colspan="9" align="center">
                                        <a href="index.cfm?curdoc=onlineApplication/index&action=createApplication">
                                        	<img src="../pics/onlineApp/start-application.gif" border="0">
                                        </a>
                                	</td>
                                </tr>
                            </cfif>
                            
                            <!--- Intl. Branches --->
                            <cfif CLIENT.userType EQ 11>
                                <tr>
                                    <td colspan="2" align="right">Applications you are <br /> entering can be found here </td>
                                    <td class="applicationStatsEnterHere"></td>
                                </tr>
                                <tr>
                                	<td colspan="9" align="center">
                                        <a href="index.cfm?curdoc=onlineApplication/index&action=createApplication">
                                        	<img src="../pics/onlineApp/start-application.gif" border="0">
                                        </a>
                                	</td>
                                </tr>
                            </cfif>
                    	</table>
                                               
                    </td>
                </tr>
                
            </table>        
        
        </td>
    </tr>
</table>

</cfoutput>
