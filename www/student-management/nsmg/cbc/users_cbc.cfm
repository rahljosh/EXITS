<!--- ------------------------------------------------------------------------- ----
	
	File:		users_cbc.cfm
	Author:		Marcus Melo
	Date:		December 09, 2009
	Desc:		Host CBC Management

	Updated:  	12/09/09 - Combined qr_users_cbc.cfm to this file.
				12/09/09 - Running CBCs on this page					

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
	
    <cfsetting requesttimeout="9999">

    <cftry>
	    <!--- param variables --->
	    <cfparam name="userID" type="numeric" default="0">

		<!--- param FORM variables --->
        <cfparam name="FORM.submitted" type="numeric" default="0">
		<cfparam name="FORM.userSeasonID" default="0">
		<cfparam name="FORM.memberIDs" default="0">

	    <cfcatch type="any">
        
			<cfscript>
				// set default values
				userID = 0;
				FORM.submitted = 0;
			</cfscript>
            
		</cfcatch>
	</cftry>        

	<cfscript>
		// Gets List of Companies
		qGetCompanies = APPCFC.COMPANY.getCompanies();	
		
		// Get User InFORMation
		qGetUser = APPCFC.USER.getUserByID(userID=userID);

		// Get User CBC
		qGetCBCUser = APPCFC.CBC.getCBCUserByID(
			userID=userID,
			cbcType='user'
		);

		// Get User Available Seasons
		qGetUserSeason = APPCFC.CBC.getAvailableSeasons(currentSeasonIDs=ValueList(qGetCBCUser.seasonID));

		// Get Family Member CBC
		qGetUserMembers = APPCFC.CBC.getEligibleUserMember(userID=userID);

		// Set Variables
		userIDs = ValueList(qGetCBCUser.cbcID);
		memberIDs = ValueList(qGetUserMembers.ID);
	</cfscript>

    <!--- Form Submitted --->
	<cfif VAL(FORM.submitted)>
		
        <!--- User --->
		<cfscript>
			// Check if we have valid data
			if ( VAL(FORM.seasonID) AND LEN(FORM.date_authorized) ) {
				// Insert User CBC
				APPCFC.CBC.insertUserCBC(
					userID=FORM.userID,
					familyMemberID=0,
					seasonID=FORM.seasonID, 
					companyID=FORM.companyID,
					dateAuthorized=FORM.date_authorized
				);		
			}

			// User - Update Date - Loop over CBC not submitted
			For (i=1; i LTE VAL(FORM.userCount); i=i+1) {
				
				// Set Flag Value
				if ( IsDefined('flagcbc_' & i) ) {
					flagValue = 1;
				} else {
					flagValue = 0;
				}
				
				// Update User CBC				
				APPCFC.CBC.updateUserCBCByID(
					cbcID=FORM["cbcID" & i],
					companyID=FORM["companyID" & i],
					flagCBC=flagValue,
					dateAuthorized=FORM["date_authorized" & i]
				);
				
			} // End of for


			/*
				INSERT/UPDATE MEMBERS
			*/
			
			// Loop over Member IDs List
            For (listID=1; listID LTE ListLen(FORM.memberIDs); listID=listID+1) {
            	
				// Get current element from the list
				ID=listGetAt(FORM.memberIDs, listID); 
			
                // Check if we have valid data
                if ( VAL(FORM[ID & "seasonID"]) AND LEN(FORM[ID & "date_authorized"]) ) {
                    
                    // Insert User CBC
                    APPCFC.CBC.insertUserCBC(
                        userID=FORM.userID,
                        familyMemberID=ID,
                        seasonID=FORM[ID & "seasonID"], 
                        companyID=FORM[ID & "companyID"],
                        dateAuthorized=FORM[ID & "date_authorized"]
                    );		

                } 
                
                // Update Member - Loop Over Count
                For (x=1; x LTE VAL(FORM[ID & "count"]); x=x+1) {
                    
                    // Set Flag Value
                    if ( IsDefined(id & 'flagcbc' & x) ) {
                        flagValue = 1;
                    } else {
                        flagValue = 0;
                    }

                    APPCFC.CBC.updateUserCBCByID(
                        cbcID=FORM[ID & "cbcID" & x],
                        companyID=FORM[ID & "companyID" & x],
                        flagCBC=flagValue,
                        dateAuthorized=FORM[ID & "date_authorized" & x]
                    );
                    
                } // End of Update Member
            
            } // End of Loop over Member IDs


			/*
				Submit Batch 12/09/2009
			*/
		
			// Get Pending CBCs User
            qGetPendingCBCUser = APPCFC.CBC.getPendingCBCUser(
                companyID=CLIENT.companyID,
				userID=FORM.userID
            );	

			// Get Pending CBCs User Member
			qGetPendingCBCMember = APPCFC.CBC.getPendingCBCUserMember(
				companyID=CLIENT.companyID,
				userID=FORM.userID
			);	
        </cfscript>  
	
    	<!--- Submit Batch User --->
		<cfloop query="qGetPendingCBCUser">
			
            <cfscript>
				// User Data Validation
				if (LEN(qGetPendingCBCUser.firstName)
					AND LEN(qGetPendingCBCUser.lastName)
					AND IsDate(qGetPendingCBCUser.DOB) 
					AND LEN(qGetPendingCBCUser.SSN) ) {

					// Get Company ID
					qGetCompanyID = APPCFC.COMPANY.getCompanies(companyID=qGetPendingCBCUser.companyID);
				
                    // Process Batch
                    CBCStatus = APPCFC.CBC.processBatch(
                        companyID=qGetCompanyID.companyID,
                        companyShort=qGetCompanyID.companyShort,
                        userType='User',
                        userID=qGetPendingCBCUser.userID,
                        cbcID=qGetPendingCBCUser.cbcID,
                        // XML variables
                        username=qGetCompanyID.gis_username,
                        password=qGetCompanyID.gis_password,
                        account=qGetCompanyID.gis_account,
                        SSN=qGetPendingCBCUser.SSN,
                        lastName=qGetPendingCBCUser.lastName,
                        firstName=qGetPendingCBCUser.firstName,
                        middleName=Left(qGetPendingCBCUser.middleName,1),
                        DOBYear=DateFormat(qGetPendingCBCUser.DOB, 'yyyy'),
                        DOBMonth=DateFormat(qGetPendingCBCUser.DOB, 'mm'),
                        DOBDay=DateFormat(qGetPendingCBCUser.DOB, 'dd')
                    );	
				}
			</cfscript>
		
        </cfloop>
        
    	<!--- Submit Batch Member --->
		<cfloop query="qGetPendingCBCMember">
			
            <cfscript>
				// Data Validation
				if (LEN(qGetPendingCBCMember.firstName)
					AND LEN(qGetPendingCBCMember.lastName)
					AND IsDate(qGetPendingCBCMember.DOB) 
					AND LEN(qGetPendingCBCMember.SSN) ) {
					
					// Get Company ID
					qGetCompanyID = APPCFC.COMPANY.getCompanies(companyID=qGetPendingCBCMember.companyID);
				
                    // Process Batch
                    CBCStatus = APPCFC.CBC.processBatch(
                        companyID=qGetCompanyID.companyID,
                        companyShort=qGetCompanyID.companyShort,
                        userType='Member',
                        userID=qGetPendingCBCMember.userID,
                        cbcID=qGetPendingCBCMember.cbcID,
                        // XML variables
                        username=qGetCompanyID.gis_username,
                        password=qGetCompanyID.gis_password,
                        account=qGetCompanyID.gis_account,
                        SSN=qGetPendingCBCMember.SSN,
                        lastName=qGetPendingCBCMember.lastName,
                        firstName=qGetPendingCBCMember.firstName,
                        middleName=Left(qGetPendingCBCMember.middleName,1),
                        DOBYear=DateFormat(qGetPendingCBCMember.DOB, 'yyyy'),
                        DOBMonth=DateFormat(qGetPendingCBCMember.DOB, 'mm'),
                        DOBDay=DateFormat(qGetPendingCBCMember.DOB, 'dd')
                    );	
				}
			</cfscript>
            					
        </cfloop>

	</cfif> <!--- End of FORM.submitted --->
    
</cfsilent>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>User CBC Management</title>
</head>
<body>

<cfoutput>

<!--- FORM submitted --->
<cfif VAL(FORM.submitted)>

	<script language="JavaScript">
		<!-- 
		alert("You have successfully updated this page. Thank You.");
			location.replace("?curdoc=cbc/users_cbc&userID=#FORM.userID#");
		//-->
    </script>
    
</cfif>

<cfif NOT VAL(userID)>
	Sorry, an error has ocurred. Please go back and try again.
	<cfabort>
</cfif>

<!--- header of the table --->
<table width="100%" cellpadding="0" cellspacing="0" border="0" height="24">
	<tr valign=middle height="24">
        <td height="24" width=13 background="pics/header_leftcap.gif">&nbsp;</td>
        <td width="26" background="pics/header_background.gif"><img src="pics/school.gif"></td>
        <td background="pics/header_background.gif"><h2>Criminal Background Check - Processing CBCs</h2></td>
        <td width="17" background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfform action="?curdoc=cbc/users_cbc" method="post">
    <cfinput type="hidden" name="submitted" value="1">
    <cfinput type="hidden" name="userID" value="#userID#">
    <!--- list cbcs --->
    <cfinput type="hidden" name="userIDs" value="#userIDs#">
    <cfinput type="hidden" name="memberIDs" value="#memberIDs#">

    <cfinput type="hidden" name="userCount" value="#qGetCBCUser.recordcount#">

    <table border="0" cellpadding="4" cellspacing="0" width="100%" class="section">
        <tr><td colspan="6">&nbsp;</td></tr>
        <tr><th colspan="6" bgcolor="e2efc7">#qGetUser.firstname# #qGetUser.lastname# (###qGetUser.userID#)</th><th bgcolor="e2efc7"><a href="javascript:OpenWindow('cbc/user_info.cfm?userID=#url.userID#');">Edit User Info</a></th></tr>

        <tr>
            <th valign="top">Company</th>
            <th valign="top">Season</th>		
            <th valign="top">Authorization Received <br><font size="-2">mm/dd/yyyy</font></th>		
            <th valign="top">CBC Sent <br><font size="-2">mm/dd/yyyy</font></th>		
            <th valign="top">CBC Received <br><font size="-2">mm/dd/yyyy</font></th>
            <th valign="top">Request ID</th>
            <th valign="top">Flag CBC</th>
            <td width="20%">&nbsp;</td>
        </tr>

        <!--- User UPDATE --->
        <cfif VAL(qGetCBCUser.recordcount)>
            
            <cfloop query="qGetCBCUser">
                <tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("ffffe6") )#"> 
                    <td align="center">
                        <cfif NOT LEN(date_sent)>
                            <cfselect name="companyID#currentrow#" required="yes" message="You must select a company">
                                <cfloop query="qGetCompanies">
                                	<option value="#companyID#" <cfif qGetCompanies.companyID EQ qGetCBCUser.companyID>selected</cfif>>#companyshort#</option>
                                </cfloop>
                            </cfselect>
                        <cfelse>
                            #companyshort#
                            <cfinput type="hidden" name="companyID#currentrow#" value="#companyID#">
                        </cfif>
                    </td>
                    <td align="center">
                    	<b>#season#</b> 
                        <cfinput type="hidden" name="cbcid#currentrow#" value="#cbcid#">
                    </td>
                    <td align="center">
                        <cfif NOT LEN(date_sent)>
                            <cfinput type="Text" name="date_authorized#currentrow#" size="8" value="#DateFormat(date_authorized, 'mm/dd/yyyy')#" validate="date" maxlength="10">
                        <cfelse>
                            #DateFormat(date_authorized, 'mm/dd/yyyy')#
                            <cfinput type="hidden" name="date_authorized#currentrow#" value="#DateFormat(date_authorized, 'mm/dd/yyyy')#">
                        </cfif>
                    </td>
                    <td align="center"><cfif NOT LEN(date_sent)>in process<cfelse>#DateFormat(date_sent, 'mm/dd/yyyy')#</cfif></td>
                    <td align="center"><cfif NOT LEN(date_received)>in process<cfelse>#DateFormat(date_received, 'mm/dd/yyyy')#</cfif></td>
                    <td align="center"><a href="cbc/view_user_cbc.cfm?userID=#qGetCBCUser.userID#&cbcID=#qGetCBCUser.cbcID#&file=batch_#qGetCBCUser.batchID#_user_#qGetCBCUser.userID#_rec.xml" target="_blank">#requestid#</a></td>
                    <td align="center"><input type="checkbox" name="flagCBC_#currentrow#" <cfif VAL(flagCBC)>checked="checked"</cfif>></td>
                    <td width="20%">&nbsp;</td>
                </tr>
            </cfloop>
        </cfif>
        
		<!--- User New --->
        <cfif VAL(qGetUserSeason.recordcount)>
            <cfif NOT LEN(qGetUser.dob)>
                <tr><td colspan="6">Date of birth cannot be blank. Please check the DOB before you continue.</td></tr>
                <cfinput type="hidden" name="seasonID" value="0">
            <cfelse>
				
                <!--- SSN Warning --->
				<cfif NOT LEN(qGetUser.ssn)>
                    <tr><td colspan="6"><font color="##FF0000">SSN is currently blank. Please check the SSN before you continue.</font></td></tr>
                </cfif>            
            
                <tr>
                    <td align="center">
                        <cfselect name="companyID" required="yes" message="You must select a company">
                            <cfloop query="qGetCompanies">
                            <option value="#companyID#" <cfif qGetCompanies.companyID EQ client.companyID>selected</cfif>>#companyshort#</option>
                            </cfloop>
                        </cfselect>
                    </td>		
                    <td align="center">
                        <cfselect name="seasonID" required="yes" message="You must select a season">
                            <option value="0">Select a Season</option>
                            <cfloop query="qGetUserSeason">
                            <option value="#seasonID#">#season#</option>
                            </cfloop>
                        </cfselect>
                    </td>
                    <td align="center"><cfinput type="Text" name="date_authorized" size="8" value="" validate="date" maxlength="10"></td>
                    <td align="center">n/a</td>
                    <td align="center">n/a</td>
                    <td align="center">n/a</td>
                    <td width="20%">&nbsp;</td>
                </tr>
                <tr><td colspan="4"><font size="-2" color="000099">* Season must be selected.</font></td></tr>
            </cfif>
        <cfelse>
            <cfinput type="hidden" name="seasonID" value="0">
        </cfif>
        <tr><td colspan="6">&nbsp; <br><br></td></tr>
    
        <!--- OTHER FAMILY MEMBERS --->
        <tr><th colspan="6" bgcolor="e2efc7">Other Family Members 18 years old and older</th><th bgcolor="e2efc7"><a href="javascript:OpenWindow('cbc/user_member_info.cfm?userID=#url.userID#');">Edit Member(s) Info</a></th></tr>
        <tr><td colspan="6">&nbsp;</td></tr>
        <cfif NOT VAL(qGetUserMembers.recordcount)>
            <tr><td colspan="6" align="center">There are no eligible family members.</td></tr>
            <tr><td colspan="6">&nbsp;</td></tr>
        <cfelse>	
            <cfloop query="qGetUserMembers">
                
                <cfscript>
					// Set current Family ID
					familyID = qGetUserMembers.id;
					
					// Gets User Member CBC
					qGetCBCMember = APPCFC.CBC.getCBCUserByID(
						userID=userID,
						familyID=familyID
					);		

					// Get Member Available Seasons
					qGetMemberSeason = APPCFC.CBC.getAvailableSeasons(currentSeasonIDs=ValueList(qGetCBCMember.seasonID));
				</cfscript>
   
   				<cfinput type="hidden" name="#familyID#count" value="#qGetCBCMember.recordcount#">
                
                <tr><th colspan="6" bgcolor="e2efc7">#qGetUserMembers.firstname# #qGetUserMembers.lastname#</th><th bgcolor="e2efc7"></th></tr>
                <tr>
                    <td align="center" valign="top"><b>Company</b></td>
                    <td align="center" valign="top"><b>Season</b></td>		
                    <td align="center" valign="top"><b>Authorization Received</b> <br><font size="-2">mm/dd/yyyy</font></td>		
                    <td align="center" valign="top"><b>CBC Sent</b> <br><font size="-2">mm/dd/yyyy</font></td>		
                    <td align="center" valign="top"><b>CBC Received</b> <br><font size="-2">mm/dd/yyyy</font></td>
                    <td align="center" valign="top"><b>Request ID</b></td>
                    <th valign="top">Flag CBC</th>
                    <td width="20%">&nbsp;</td>
                </tr>
                
				<!--- Member Update --->
                <cfif VAL(qGetCBCMember.recordcount)>
                    
                    <cfloop query="qGetCBCMember">
                        <tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("ffffe6") )#"> 
                            <td align="center">
                                <cfif NOT LEN(date_sent)>
                                    <cfselect name="#familyID#companyID#currentrow#" required="yes" message="You must select a company">
                                        <cfloop query="qGetCompanies">
                                        <option value="#companyID#" <cfif qGetCompanies.companyID EQ qGetCBCMember.companyID>selected</cfif>>#companyshort#</option>
                                        </cfloop>
                                    </cfselect>
                                <cfelse>
                                    #companyshort#
                                    <cfinput type="hidden" name="#familyID#companyID#currentrow#" value="#companyID#">
                                </cfif>
                            </td>
                            <td align="center"><b>#season#</b> <cfinput type="hidden" name="#familyID#cbcid#currentrow#" value="#cbcid#"></td>
                            <td align="center">
                                <cfif NOT LEN(date_sent)>
                                    <cfinput type="Text" name="#familyID#date_authorized#currentrow#" size="8" value="#DateFormat(date_authorized, 'mm/dd/yyyy')#" validate="date" maxlength="10">
                                <cfelse>
                                    #DateFormat(date_authorized, 'mm/dd/yyyy')#
                                    <cfinput type="hidden" name="#familyID#date_authorized#currentrow#" value="#DateFormat(date_authorized, 'mm/dd/yyyy')#">
                                </cfif>
                            </td>
                            <td align="center"><cfif NOT LEN(date_sent)>in process<cfelse>#DateFormat(date_sent, 'mm/dd/yyyy')#</cfif></td>
                            <td align="center"><cfif NOT LEN(date_received)>in process<cfelse>#DateFormat(date_received, 'mm/dd/yyyy')#</cfif></td>
                            <td align="center"><a href="cbc/view_user_cbc.cfm?userID=#qGetCBCMember.userID#&cbcID=#qGetCBCMember.cbcID#&file=batch_#qGetCBCMember.batchID#_user_#qGetCBCMember.userID#_rec.xml" target="_blank">#requestid#</a></td>
                            <td align="center"><input type="checkbox" name="#familyID#flagCBC#currentrow#" <cfif VAL(flagCBC)>checked="checked"</cfif>></td>
                            <td width="20%">&nbsp;</td>
                        </tr>
                    </cfloop>
                    
                </cfif>
                
				<!--- NEW CBC --->
                <cfif VAL(qGetMemberSeason.recordcount)>
                <tr>
                    <td align="center">
                        <cfselect name="#familyID#companyID" required="yes" message="You must select a company">
                            <cfloop query="qGetCompanies">
                            <option value="#companyID#" <cfif qGetCompanies.companyID EQ client.companyID>selected</cfif>>#companyshort#</option>
                            </cfloop>
                        </cfselect>
                    </td>						
                    <td align="center">
                        <cfselect name="#familyID#seasonID" required="yes" message="You must select a season">
                            <option value="0">Select a Season</option>
                            <cfloop query="qGetMemberSeason">
                            <option value="#seasonID#">#season#</option>
                            </cfloop>
                        </cfselect>
                    </td>
                    <td align="center"><cfinput type="Text" name="#familyID#date_authorized" size="8" value="" validate="date" maxlength="10"></td>
                    <td align="center">n/a</td>
                    <td align="center">n/a</td>
                    <td align="center">n/a</td>
                    <td width="20%">&nbsp;</td>
                </tr>
                <tr><td colspan="4"><font size="-2" color="000099">* Season must be selected.</font></td></tr>
                <cfelse>
                    <cfinput type="hidden" name="#familyID#seasonID" value="0">
                </cfif>
            <tr><td colspan="6">&nbsp; <br><br></td></tr>			
            </cfloop>
        </cfif>
    </table>
    
    <table border="0" cellpadding="4" cellspacing="0" width="100%" class="section">
        <tr><td align="center">
                <a href="?curdoc=user_info&userID=#url.userID#"><img src="pics/back.gif" border="0"></a> &nbsp;  &nbsp;  &nbsp;  &nbsp; &nbsp;  &nbsp;
                <input name="Submit" type="image" src="pics/update.gif" border="0" alt="submit">
            </td>
        <td width="20%">&nbsp;</td></tr>
    </table>
</cfform>

<table width="100%" cellpadding="0" cellspacing="0" border="0">
	<tr valign=bottom >
		<td width="9" valign="top" height="12"><img src="pics/footer_leftcap.gif" ></td>
		<td width="100%" background="pics/header_background_footer.gif"></td>
		<td width="9" valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>
</cfoutput>

</body>
</html>