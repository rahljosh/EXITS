<!--- ------------------------------------------------------------------------- ----
	
	File:		index.cfm
	Author:		Marcus Melo
	Date:		December 11, 2009
	Desc:		Project Help Index

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <!--- Param Variables --->
	<cfparam name="FORM.submitted" default="0">

    <cfparam name="FORM.regionID" default="#CLIENT.regionID#">
	<cfparam name="FORM.isActive" default="1">

    <cfparam name="URL.regionID" default="0">
	<cfparam name="URL.isActive" default="">

	<cfscript>
		// Check if we have a valid URL.isActive
		if ( LEN(URL.isActive) ) {
			FORM.isActive = URL.isActive;	
		}

		// Office Users
		if ( VAL(CLIENT.userType) LTE 4 ) {
		
			if ( VAL(URL.regionID) ) {
				FORM.regionID = URL.regionID;	
			}
		
			// Get All Regions
			qGetRegions = APPCFC.REGION.getRegions(			
				companyID=CLIENT.companyID,
				userID=CLIENT.userID
			);	
			
			// Get Student List
			qGetStudents = APPCFC.STUDENT.getProjectHelpList(
				userID=CLIENT.userID,
				userType=CLIENT.userType,
				regionID=FORM.regionID,
				isActive=FORM.isActive
			);

		// Area Reps, Advisors and Managers
		} else {	
			
			// Get User Regions
			qGetRegions = APPCFC.REGION.getUserRegions(			
				companyID=CLIENT.companyID,
				userType=CLIENT.userType,
				userID=CLIENT.userID);
		
			// Set Regions List
			regionList = ValueList(qGetRegions.regionID);
			
			if ( VAL(URL.regionID) AND ListFind(regionList, URL.regionID) ) {
				FORM.regionID = URL.regionID;		
			}

			// Get Student List
			qGetStudents = APPCFC.STUDENT.getProjectHelpList(
				userID=CLIENT.userID,
				userType=qGetRegions.userType,
				regionID=FORM.regionID,
				isActive=FORM.isActive
			);
			
		}
	</cfscript>

	<!--- Check Access --->
	<cfif VAL(CLIENT.usertype) GT 7>
        <cflocation url="index.cfm?curdoc=progress_reports" addtoken="no">
        <cfabort>
    </cfif>

</cfsilent>

<!--- Header --->
<table width="100%" cellpadding="0" cellspacing="0" border="0" height="24">
    <tr height="24">
        <td height="24" width="13" background="pics/header_leftcap.gif">&nbsp;</td>
        <td width="26" background="pics/header_background.gif"><img src="pics/current_items.gif"></td>
        <td background="pics/header_background.gif"><h2>H.E.L.P. Community Service Hours - Mandatory 5 Hours</h2></td>
        <td width="17" background="pics/header_rightcap.gif">&nbsp;</td>
    </tr>
</table>

<cfform action="index.cfm?curdoc=project_help" method="post">
    <input name="submitted" type="hidden" value="1">
    
    <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%">
        <tr>
        	<td width="2%">&nbsp;</td>
        
			<!--- Include Region Selection for Office Users --->           
            <td width="15%">
                Region <br />
                <cfselect 
                    name="regionID" 
                    query="qGetRegions" 
                    value="regionID" 
                    display="regionname" 
                    selected="#FORM.regionID#" />
            </td>
            
            <td width="15%">
                Student Status<br />
                <select name="isActive">
                    <option value="1" <cfif VAL(FORM.isActive)>selected</cfif>>Active</option>
                    <option value="0" <cfif NOT VAL(FORM.isActive)>selected</cfif>>Cancelled</option>
                </select>            
            </td>

            <td width="15%"><input name="submit" type="submit" value="Submit" /></td>
            
            <td width="53%"></td>
        </tr>
    </table>
</cfform>

<cfif VAL(qGetStudents.recordCount)>

    <table width="100%" class="section">
    	<!--- Group By Advisors --->
        <cfoutput query="qGetStudents" group="advisorID">
            <tr>
                <td colspan="9" class="projectHelpAdvisor">
                    <cfif NOT LEN(advisorID)>
                        Reports Directly to Regional Director
                    <cfelse>
                        #advisor_firstname# #advisor_lastname# (#advisorID#)
                    </cfif>
                </td>
            </tr>
            <!--- Group by Area Reps --->
            <cfoutput group="arearepID">
                <tr>
                    <td colspan="9" class="projectHelpAreaRep">#rep_firstname# #rep_lastname# (#arearepID#)</td>
                <tr>
                <tr align="left">
                    <th width="15px">&nbsp;</th>
                    <th>Student</th>
                    <th>Action</th>
                    <th>Hours</th>
                    <th>Completed</th>
                    <th width="15%">SR Status</th>
                    <th width="15%">RA Status</th>
                    <th width="15%">RD Status</th>
                    <th width="15%">PM Status</th>
                </tr>
                
				<cfoutput> 

					<cfscript>
						// Get Regional Manager		
						qGetRD = APPCFC.USER.getRegionalManager(regionID=FORM.regionID);					
					
                        // Get Total of Hours for this project
                        getPHTotalHours = APPCFC.STUDENT.getProjectHelpTotalHours(projectHelpID=projectHelpID);	
                    </cfscript>

					<tr bgcolor="#IIF(qGetStudents.currentRow MOD 2 ,DE("EEEEEE") ,DE("FFFFFF") )#">
                        <td>&nbsp;</td>
                        <td>
                        	<!--- put in red if user is the supervising rep for this student. Don't do for usertype 7 because they see only those students. --->
                            <cfif arearepID EQ CLIENT.userID and CLIENT.usertype NEQ 7>
                        		<span class="projectHelpAttention">#firstname# #familylastname# (#studentID#)</span>
                            <cfelse>
                                #firstname# #familylastname# (#studentID#)                        		
                            </cfif>
                        </td>
                        <td>
                        	<!--- Create Report --->
							<cfif NOT VAL(projectHelpID) OR NOT VAL(getPHTotalHours)>												
                                <a href="?curdoc=project_help/submit&studentID=#studentID#&regionID=#FORM.regionID#&isActive=#FORM.isActive#">Create</a>
							
							<!--- Area Rep Options --->
							<cfelseif CLIENT.userID EQ areaRepID>
                            
								<cfif NOT LEN(sr_date_submitted)											<!--- Not Approved by SR --->
									OR ( VAL(advisorID) AND LEN(ra_date_rejected) )  						<!--- Advisor - Advisor Rejected --->
									OR ( NOT VAL(advisorID) AND LEN(rd_date_rejected) )> 					<!--- No Advisor - Manager Rejected --->
                                    <a href="?curdoc=project_help/submit&studentID=#studentID#&regionID=#FORM.regionID#&isActive=#FORM.isActive#">Approve</a>
                                <cfelse>																	<!--- View Only --->
                                    <a href="?curdoc=project_help/submit&studentID=#studentID#&regionID=#FORM.regionID#&isActive=#FORM.isActive#">View</a>
                                </cfif>         
							
                            <!--- Regional Advisor --->
                            <cfelseif CLIENT.userID EQ advisorID>
                            
                            	<cfif NOT LEN(ra_date_rejected)	AND NOT LEN(ra_date_approved)	 			<!--- Not Rejected and not Approved by Advisor --->
									AND ( LEN(sr_date_submitted) OR LEN(rd_date_rejected) )>				<!--- Submitted by SR or Rejected by RD --->
                                	<a href="?curdoc=project_help/submit&studentID=#studentID#&regionID=#FORM.regionID#&isActive=#FORM.isActive#">Approve</a>
                                <cfelseif VAL(projectHelpID)>												<!--- View Only --->
                                	<a href="?curdoc=project_help/submit&studentID=#studentID#&regionID=#FORM.regionID#&isActive=#FORM.isActive#">View</a>
                                <cfelse>																	<!--- Report not available --->
                                	N/A    
                                </cfif>
                            
                            <!--- Regional Director --->
                            <cfelseif CLIENT.userID EQ qGetRD.userID>

                            	<cfif NOT LEN(rd_date_rejected) AND NOT LEN(rd_date_approved)				<!--- Not Rejected and not Approved by Director --->	
									AND ( NOT VAL(advisorID) AND LEN(sr_date_submitted) )					<!--- No Advisor - SR Approved --->
									OR ( VAL(advisorID) AND LEN(ra_date_approved) ) 						<!--- Advisor - Advisor Approved --->
                                    OR LEN(ny_date_rejected) >  											<!--- Rejected by Office --->
                                	<a href="?curdoc=project_help/submit&studentID=#studentID#&regionID=#FORM.regionID#&isActive=#FORM.isActive#">Approve</a>	
                                <cfelseif VAL(projectHelpID)>												<!--- View Only --->
                                	<a href="?curdoc=project_help/submit&studentID=#studentID#&regionID=#FORM.regionID#&isActive=#FORM.isActive#">View</a>
                                <cfelse>																	<!--- Report not available --->
                                	N/A    										
                                </cfif>

                            <!--- Office Users --->
                            <cfelseif VAL(CLIENT.userType) LTE 4>
                            	
                            	<cfif NOT LEN(ny_date_rejected) AND NOT LEN(ny_date_approved) AND 			<!--- Not Rejected and not Approved by Office --->	
									LEN(rd_date_approved)>													<!--- Approved by RD --->
                                	<a href="?curdoc=project_help/submit&studentID=#studentID#&regionID=#FORM.regionID#&isActive=#FORM.isActive#">Approve</a>
                                <cfelseif VAL(projectHelpID)>												<!--- View Only --->
                                	<a href="?curdoc=project_help/submit&studentID=#studentID#&regionID=#FORM.regionID#&isActive=#FORM.isActive#">View</a>			
                                <cfelse>																	<!--- Report not available --->
                                	N/A    
                                </cfif>

                            </cfif>                                
                        </td>
                        <td>
                            #getPHTotalHours#
                        </td>
                        <td>
                        	<cfif LEN(ny_date_approved)>
                            	Yes 
                            <cfelse>
                            	No
                            </cfif>
                        </td>
                        <!--- Area Rep --->					
                        <td>
							<cfif NOT VAL(projectHelpID)>
								n/a
							<cfelseif LEN(sr_date_submitted)>
	                            Approved on #DateFormat(sr_date_submitted, 'mm/dd/yyyy')#
                            <cfelse>
                            	Pending
							</cfif>                                                            
                        </td>
                        <!--- Regional Advisor --->
                        <td>
							<cfif NOT VAL(projectHelpID)>
                            	n/a
							<cfelseif LEN(ra_date_approved)>
                                Approved on #DateFormat(ra_date_approved, 'mm/dd/yyyy')#
                            <cfelseif LEN(ra_date_rejected)>
                            	<span class="projectHelpAttention">Rejected on #DateFormat(ra_date_rejected, 'mm/dd/yyyy')#</span>
							<cfelseif LEN(rd_date_approved)>
                            	Approved by RD
							<cfelseif VAL(advisorID)>
                                Pending
							<cfelse>                                
                                N/A
                            </cfif>
                        </td>
                        <!--- Regional Director --->
                        <td>
							<cfif NOT VAL(projectHelpID)>
                            	n/a
							<cfelseif LEN(rd_date_approved)>
                                Approved on #DateFormat(rd_date_approved, 'mm/dd/yyyy')#
                            <cfelseif LEN(rd_date_rejected)>
                            	<span class="projectHelpAttention">Rejected on #DateFormat(rd_date_rejected, 'mm/dd/yyyy')#</span>
  							<cfelseif LEN(ny_date_approved)>
								Approved by PM
                            <cfelse>
                                Pending
                            </cfif>
                        </td>
                        <!--- NY Office --->
                        <td>
							<cfif NOT VAL(projectHelpID)>
                            	n/a
							<cfelseif LEN(ny_date_approved)>
                                Approved on #DateFormat(ny_date_approved, 'mm/dd/yyyy')#
                            <cfelseif LEN(ny_date_rejected)>
                            	<span class="projectHelpAttention">Rejected on #DateFormat(ny_date_rejected, 'mm/dd/yyyy')#</span>
                            <cfelse>
                                Pending
                            </cfif>
                        </td>
                    </tr>
                </cfoutput> <!--- Students --->
            
			</cfoutput> <!--- group="arearepID" --->
            
        </cfoutput> <!--- group="advisorID" --->
    </table>

    <table width="100%" class="section">
        <tr>
            <td>
                <table>
                    <tr>
                        <td bgcolor="#FFDDBB" width="15">&nbsp;</td>
                        <td>Regional Advisor</td>
                    </tr>
                </table>
            </td>
            <td>
                <table>
                    <tr>
                        <td bgcolor="#CCCCCC" width="15">&nbsp;</td>
                        <td>Supervising Rep</td>
                    </tr>
                </table>
            </td>
			<!--- don't do for usertype 7 because they see only students they're supervising. --->
            <cfif CLIENT.usertype NEQ 7>
                <td><span class="projectHelpAttention">Students that you're supervising</span></td>
            </cfif>
        </tr>
    </table>
           
<cfelse>

    <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%">
        <tr>
            <td>No students matched your criteria.</td>
        </tr>
    </table>

</cfif>

<!--- Footer --->
<table width="100%" cellpadding="0" cellspacing="0" border="0">
	<tr valign="bottom">
		<td width="9" valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width="100%" background="pics/header_background_footer.gif"></td>
		<td width="9" valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>
