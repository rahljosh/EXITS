
<cfscript>
	qGetHostEligibility = APPLICATION.CFC.LOOKUPTABLES.getApplicationHistory(
		applicationID=7,
		foreignTable='smg_hosts',
		foreignID=hostID
	);

	qGetHostInfo = APPLICATION.CFC.HOST.getApplicationList(hostID=URL.hostID);
	qGetAreaRep = APPLICATION.CFC.USER.getUsers(userID = qGetHostInfo.areaRepID);

	qCurrentSeason = APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason();
	vCurrentSeasonStatus = APPLICATION.CFC.HOST.getApplicationList(hostID=qGetHostInfo.hostID,seasonID=qCurrentSeason.seasonID).applicationStatusID;
	vHasEhost = APPLICATION.CFC.HOST.getSeasonsForHost(hostID=qGetHostInfo.hostID).recordCount;
</cfscript>

         <link rel="stylesheet" href="../smg.css" type="text/css">
         <link rel="stylesheet" href="../linked/css/buttons.css" type="text/css">
           <!--- HOST ELIGIBILITY --->
            <table width=80% cellpadding=0 cellspacing=0 border=0 height=24>
                <tr valign=middle height=24>
                    <td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
                    <td width=26 background="../pics/header_background.gif"><img src="../pics/family.gif"></td>
                    <td background="../pics/header_background.gif"><h2>&nbsp;&nbsp;Host Status</h2></td>
                    <td background="../pics/header_background.gif" width=16>
                        <cfif APPLICATION.CFC.USER.isOfficeUser()>
                        	<span class="buttonBlue smallerButton" onclick="window.location.href='../index.cfm?curdoc=forms/host_fam_eligibility_form&hostID=<cfoutput>#qGetHostInfo.hostID#</cfoutput>&status=9&seasonID=14&active_rep=2&ny_office=2'">Edit</span>
                        </cfif>
                    </td>
                    <td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
                </tr>
            </table>
            <table width="80%" align="left" cellpadding=8 class="section">

                <cfif qGetHostInfo.isNotQualifiedToHost EQ 0>
                    <tr>
                        <td>
                            <input type="checkbox" disabled="disabled" /> Not Qualified
                        </td>
                        <td>
                            <cfif CLIENT.usertype LTE 7>
                                <cfif VAL(qGetHostInfo.isHosting) AND NOT VAL(qGetHostInfo.with_competitor)>
                                     <cfform method="post" action="../index.cfm?curdoc=host_fam_info_status_update&hostid=#url.hostid#" style="display:inline;">
                                        <input type="hidden" name="decideToHost" value="0"/>
                                        <input type="hidden" name="host_lead_referer" value="1">
                                        <input type="submit" value="Decided Not To Host"  alt="Decided Not To Host" border="0" class="buttonRed" />
                                        
                                    </cfform>
                                   
                                       
                                    <cfform method="post" action="../index.cfm?curdoc=host_fam_info_status_update&hostid=#url.hostid#" style="display:inline;">

                                        <input type="hidden" name="withCompetitor" value="1"/>
                                        <input type="hidden" name="host_lead_referer" value="1">
                                        <input type="submit" value="With Other Sponsor"  alt="With Other Sponsor" border="0" class="buttonRed" />
                                    </cfform>
                                    <cfif VAL(qGetHostInfo.applicationStatusID)>
                                         <cfform method="post" action="../index.cfm?curdoc=host_fam_info_status_update&hostid=#url.hostid#" style="display:inline;">
                                           <input type="hidden" name="host_lead_referer" value="1">
                                            <input name="sendAppEmail" type="submit" value="Resend Login Info"  alt="Resend Login Info" border="0" class="buttonGreen" />
                                        </cfform>
                                 
                                    </cfif>
                                <cfelse>
                                  	<cfform method="post" action="../index.cfm?curdoc=host_fam_info_status_update&hostid=#url.hostid#" style="display:inline;">
                                  
                                        <input type="hidden" name="decideToHost" value="1"/>
                                         <input type="hidden" name="host_lead_referer" value="1">
                                        <input type="submit" value="Decided To Host"  alt="Decided To Host" border="0" class="buttonYellow" />
                                    </cfform>
                                </cfif>
                                
                            </cfif>
                            <cfif NOT VAL(vCurrentSeasonStatus) AND VAL(qGetHostInfo.isHosting)>
                                 <cfform method="post" action="../index.cfm?curdoc=host_fam_info_status_update&hostid=#url.hostid#" style="display:inline;">
                                    <input type="hidden" name="hostNewSeason" value="1"/>
                                     <input type="hidden" name="host_lead_referer" value="1">
                                    <input type="submit" value="Host #qCurrentSeason.season#"  alt="Host Season X" border="0" class="buttonGreen" />
                                </cfform>
                         	</cfif>
                        </td>
                    </tr>
<!----                    <cfif NOT VAL(qGetHostInfo.applicationStatusID)>---->
                    <tr>
                        <td style="text-align:center" colspan="2">

                                <cfform method="post" action="../index.cfm?curdoc=host_fam_info_status_update&hostid=#url.hostid#" style="display:inline;">
                                    <input type="hidden" name="StatusUpdateSub"  value="1"/>
                                    <input type="hidden" name="call_back" value="1"/>
                                     <input type="hidden" name="host_lead_referer" value="1">
                                    <input type="submit" value="Call Back"  alt="Call Back" border="0" class="buttonBlue"/>
                                </cfform>
                                <cfform method="post" action="../index.cfm?curdoc=host_fam_info_status_update&hostid=#url.hostid#" style="display:inline;">
                                    <input type="hidden" name="StatusUpdateSub"  value="1"/>
                                    <input type="hidden" name="call_back" value="2"/>
                                     <input type="hidden" name="host_lead_referer" value="1">
                                    <input type="submit" value="Call Back Next SY"  alt="Call Back Next SY" border="0" class="buttonBlue"/>
                                </cfform>

                        </td>
                    </tr>
<!----                    </cfif>---->

                <cfelse>
                    
                    <tr>
                        <td>
                            <input type="checkbox" checked="checked" disabled="disabled" /> <span style="color:red;"><b>Not Qualified</b></span>
                        </td>
                        
                    </tr>
                </cfif>

                <cfif qGetHostEligibility.recordcount GT 0>
                    <tr>
                        <td colspan="2">
                            <div style="max-height: 75px; overflow: auto">
                            <table cellpadding="0" cellspacing="0" width="100%">
                            <tr>
                                <td width="22%">
                                    <u>Status</u>
                                </td>
                                <td width="12%">
                                    <u>Date</u>
                                </td>
                                <td width="25%">
                                    <u>Entered By</u>
                                </td>
                                <td width="41%">
                                    <u>Notes</u>
                                </td>
                            </tr>
                            <cfoutput>
                            	   <cfloop query="qGetHostEligibility">
                                <tr>
                                    <td>
                                        <Cfif LEN(qGetHostEligibility.status_update)>
                                            #qGetHostEligibility.status_update#
                                        <cfelse>
                                            Not Qualified to Host
                                        </Cfif>
                                    </td>
                                    <td>
                                        #DateFormat(dateupdated,'mm/dd/yyyy')#
                                    </td>
                                    <td>
                                        #qGetHostEligibility.enteredBy#
                                    </td>
                                    <td>
                                        #comments#
                                    </td>
                                </tr>
                            </cfloop>
                            </cfoutput>
                         
                            </table>
                            </div>
                        </td>
                    </tr>
                </cfif>
          
            </table>
            
               <table width=80% cellpadding=0 cellspacing=0 border=0>
                <tr valign="bottom">
                    <td width=9 valign="top" height=12>
                        <img src="../pics/footer_leftcap.gif" >
                    </td>
                    <td width=100% background="../pics/header_background_footer.gif">
                    </td>
                    <td width=9 valign="top">
                        <img src="../pics/footer_rightcap.gif">
                    </td>
                </tr>
            </table>
            