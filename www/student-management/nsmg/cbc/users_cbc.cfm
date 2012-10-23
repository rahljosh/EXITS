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
	
	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

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
		qGetCompanies = APPLICATION.CFC.COMPANY.getCompanies();	
		
		// Get User InFORMation
		qGetUser = APPLICATION.CFC.USER.getUserByID(userID=userID);

		// Get User CBC
		qGetCBCUser = APPLICATION.CFC.CBC.getCBCUserByID(
			userID=userID,
			cbcType='user'
		);

		// Get User Available Seasons
		qGetUserSeason = APPLICATION.CFC.CBC.getAvailableSeasons(currentSeasonIDs=ValueList(qGetCBCUser.seasonID));

		// Get Family Member CBC
		qGetUserMembers = APPLICATION.CFC.CBC.getEligibleUserMember(userID=userID);

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
				APPLICATION.CFC.CBC.insertUserCBC(
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
				APPLICATION.CFC.CBC.updateUserCBCByID(
					cbcID=FORM["cbcID" & i],
					companyID=FORM["companyID" & i],
					flagCBC=flagValue,
					dateAuthorized=FORM["date_authorized" & i],
					dateApproved = FORM["date_approved" & i],
					notes = FORM["notes" & i]
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
                    APPLICATION.CFC.CBC.insertUserCBC(
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

                    APPLICATION.CFC.CBC.updateUserCBCByID(
                        cbcID=FORM[ID & "cbcID" & x],
                        companyID=FORM[ID & "companyID" & x],
                        flagCBC=flagValue,
						dateAuthorized=FORM[ID & "date_authorized" & x],
						dateApproved = FORM[ID & "date_approved" & x],
						notes=FORM[ID & "notes" & x]
                    );
                    
                } // End of Update Member
            
            } // End of Loop over Member IDs


			/*
				Submit Batch 12/09/2009
			*/
		
			// Get Pending CBCs User
            qGetPendingCBCUser = APPLICATION.CFC.CBC.getPendingCBCUser(
                companyID=CLIENT.companyID,
				userID=FORM.userID
            );	

			// Get Pending CBCs User Member
			qGetPendingCBCMember = APPLICATION.CFC.CBC.getPendingCBCUserMember(
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
					qGetCompanyID = APPLICATION.CFC.COMPANY.getCompanies(companyID=qGetPendingCBCUser.companyID);
				
                    // Process Batch
                    CBCStatus = APPLICATION.CFC.CBC.processBatch(
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
					qGetCompanyID = APPLICATION.CFC.COMPANY.getCompanies(companyID=qGetPendingCBCMember.companyID);
				
                    // Process Batch
                    CBCStatus = APPLICATION.CFC.CBC.processBatch(
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
        
        <cfscript>
			// Check if there are no errors 
			if ( NOT SESSION.formErrors.length() ) {
				// Set Page Message
				SESSION.pageMessages.Add("Form successfully submitted.");

				// Check if account is compliant, if so notify user he is granted full access to EXITS
				APPLICATION.CFC.USER.accountFullyEnabledNotification(userID=FORM.userID);
				
			}
		
			if ( isDefined('url.return') ) {
				Location("index.cfm?curdoc=user/index&action=paperworkDetails&userID=#url.userID#", "no");
			} else {
				Location(CGI.SCRIPT_NAME & "?" & CGI.QUERY_STRING, "no");
			}
		</cfscript>
        
	</cfif> <!--- End of FORM.submitted --->
    
</cfsilent>

<cfoutput>
<head>
	<SCRIPT LANGUAGE="JavaScript">
    <!-- Begin
    function CheckDates(ckname, frname) {
        if (document.form.elements[ckname].checked) {
            document.form.elements[frname].value = "#DateFormat(now(), 'mm/dd/yyyy')#";
            }
        else { 
            document.form.elements[frname].value = '';  
        }
    }
    //  End -->
    </script>

	<script language="javascript">	
        // Document Ready!
        $(document).ready(function() {
    
            // JQuery Modal
            $(".jQueryModal").colorbox( {
                width:"60%", 
                height:"60%", 
                iframe:true,
                overlayClose:false,
                escKey:false 
            });		
    
        });
		</script> 	
        <script type="text/javascript">
		function zp(n){
		return n<10?("0"+n):n;
		}
		function insertDate(t,format){
		var now=new Date();
		var DD=zp(now.getDate());
		var MM=zp(now.getMonth()+1);
		var YYYY=now.getFullYear();
		var YY=zp(now.getFullYear()%100);
		format=format.replace(/DD/,DD);
		format=format.replace(/MM/,MM);
		format=format.replace(/YYYY/,YYYY);
		format=format.replace(/YY/,YY);
		t.value=format;
		}
		</script>
</head>	

    <cfif NOT VAL(userID)>
        Sorry, an error has ocurred. Please go back and try again.
        <cfabort>
    </cfif>

	<!--- Table Header --->
    <gui:tableHeader
        imageName="school.gif"
        tableTitle="Criminal Background Check - User and Members ###userID#"
        tableRightTitle=""
    />

	<!--- Page Messages --->
    <gui:displayPageMessages 
        pageMessages="#SESSION.pageMessages.GetCollection()#"
        messageType="tableSection"
        width="100%"
        />
    
    <!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="tableSection"
        width="100%"
        />
    
    <cfform action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
        <input type="hidden" name="submitted" value="1">
        <input type="hidden" name="userID" value="#userID#">
        <!--- list cbcs --->
        <input type="hidden" name="userIDs" value="#userIDs#">
        <input type="hidden" name="memberIDs" value="#memberIDs#">
        <input type="hidden" name="userCount" value="#qGetCBCUser.recordcount#">
    
        <table border="0" cellpadding="4" cellspacing="0" width="100%" class="section">
            <tr><td colspan="9">&nbsp;</td></tr>
            <tr>
            	<th colspan="9" bgcolor="##e2efc7">#qGetUser.firstname# #qGetUser.lastname# (###qGetUser.userID#)</th>
            	<th bgcolor="##e2efc7" colspan=2><a href="cbc/userInfo.cfm?userID=#qGetUser.userID#" class="jQueryModal">Edit User Info</a></th>
            </tr>
            <tr style="font-weight:bold;">
                <td valign="top">Company</td>
                <td valign="top">Season</td>		
                <td valign="top">Authorization Received <br><font size="-2">mm/dd/yyyy</font></td>		
                <td valign="top">CBC Sent <br><font size="-2">mm/dd/yyyy</font></td>
                <td valign="top">Expiration Date<br><font size="-2">mm/dd/yyyy</font></td>		
                <td valign="top">Request ID</td>
                <td valign="top">Flag CBC</td>
                <td valign="top">Date Approved<br><font size="-2">mm/dd/yyyy</font></td>
                <td valign="top">Notes</td>
            </tr>
            
            <!--- User UPDATE --->
            <cfloop query="qGetCBCUser">
                <tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("ffffe6") )#"> 
                    <td>
                        <cfif NOT LEN(date_sent)>
                            <cfselect name="companyID#currentrow#" required="yes" message="You must select a company">
                                <cfloop query="qGetCompanies">
                                    <option value="#companyID#" <cfif qGetCompanies.companyID EQ qGetCBCUser.companyID>selected</cfif>>#companyshort#</option>
                                </cfloop>
                            </cfselect>
                        <cfelse>
                            #companyshort#
                            <input type="hidden" name="companyID#currentrow#" value="#companyID#">
                        </cfif>
                    </td>
                    <td>
                        <b>#season#</b> 
                        <input type="hidden" name="cbcid#currentrow#" value="#cbcid#">
                    </td>
                    <td>
                        <cfif NOT isDate(date_sent)>
                            <cfinput type="Text" name="date_authorized#currentrow#" value="#DateFormat(date_authorized, 'mm/dd/yyyy')#" class="datePicker" validate="date" maxlength="10">
                        <cfelse>
                            #DateFormat(date_authorized, 'mm/dd/yyyy')#
                            <input type="hidden" name="date_authorized#currentrow#" value="#DateFormat(date_authorized, 'mm/dd/yyyy')#">
                        </cfif>
                    </td>
                    <td><cfif isDate(date_sent)>#DateFormat(date_sent, 'mm/dd/yyyy')#<cfelse>processing</cfif></td>
                    <td><cfif isDate(date_expired)>#DateFormat(date_expired, 'mm/dd/yyyy')#<cfelse>n/a</cfif></td>
                    <td><a href="cbc/view_user_cbc.cfm?userID=#qGetCBCUser.userID#&cbcID=#qGetCBCUser.cbcID#&file=batch_#qGetCBCUser.batchID#_user_#qGetCBCUser.userID#_rec.xml" target="_blank">#requestid#</a></td>
                    <td><input type="checkbox" name="flagCBC_#currentrow#" <cfif VAL(flagCBC)>checked="checked"</cfif>></td>
                    <td> 
                        <input type="text" name="date_approved#currentrow#" message="Please input a valid date." <cfif NOT IsDate(date_approved) is ''>onfocus="insertDate(this,'MM/DD/YYYY')"</cfif> value="#DateFormat(date_approved, 'mm/dd/yyyy')#" size="8" maxlength="10">	
                        <cfif NOT IsDate(date_approved)><br /><em><font size=-2>click in box for date</font></em></cfif>
                    </td>
                    <td><textarea rows="4" cols="25" name="notes#currentrow#">#notes#</textarea></td>
                </tr>
            </cfloop>
            
            <!--- User New --->
            <cfif VAL(qGetUserSeason.recordcount)>
                <cfif NOT LEN(qGetUser.dob)>
                    <tr><td colspan="9">Date of birth cannot be blank. Please check the DOB before you continue.</td></tr>
                    <input type="hidden" name="seasonID" value="0">
                <cfelse>
                    
                    <!--- SSN Warning --->
                    <cfif NOT LEN(qGetUser.ssn)>
                        <tr><td colspan="9"><font color="##FF0000">SSN is currently blank. Please check the SSN before you continue.</font></td></tr>
                    </cfif>            
                
                    <tr>
                        <td>
                            <cfselect name="companyID" required="yes" message="You must select a company">
                                <cfloop query="qGetCompanies">
                                <option value="#companyID#" <cfif qGetCompanies.companyID EQ client.companyID>selected</cfif>>#companyshort#</option>
                                </cfloop>
                            </cfselect>
                        </td>		
                        <td>
                            <cfselect name="seasonID" required="yes" message="You must select a season">
                                <option value="0">Select a Season</option>
                                <cfloop query="qGetUserSeason">
                                <option value="#seasonID#">#season#</option>
                                </cfloop>
                            </cfselect>
                        </td>
                        <td><cfinput type="Text" name="date_authorized" value="" class="datePicker" validate="date" maxlength="10"></td>
                        <td>n/a</td>
                        <td>n/a</td>
                        <td>n/a</td>
                    </tr>
                    <tr><td colspan="4"><font size="-2" color="000099">* Season must be selected.</font></td></tr>
                </cfif>
            <cfelse>
                <input type="hidden" name="seasonID" value="0">
            </cfif>
            <tr><td colspan="9">&nbsp; <br><br></td></tr>
        
            <!--- OTHER FAMILY MEMBERS --->
            <tr>
            	<th colspan="9" bgcolor="##e2efc7">Other Family Members 18 years old and older</th>
                <th bgcolor="##e2efc7"><a href="cbc/userMemberInfo.cfm?userID=#qGetUser.userID#" class="jQueryModal">Edit Member(s) Info</a></th>
            </tr>
            <tr><td colspan="9">&nbsp;</td></tr>
            <cfif NOT VAL(qGetUserMembers.recordcount)>
                <tr><td colspan="9">There are no eligible family members.</td></tr>
                <tr><td colspan="9">&nbsp;</td></tr>
            </cfif>
            	
            <cfloop query="qGetUserMembers">
                
                <cfscript>
                    // Set current Family ID
                    familyID = qGetUserMembers.id;
                    
                    // Gets User Member CBC
                    qGetCBCMember = APPLICATION.CFC.CBC.getCBCUserByID(
                        userID=userID,
                        familyID=familyID
                    );		

                    // Get Member Available Seasons
                    qGetMemberSeason = APPLICATION.CFC.CBC.getAvailableSeasons(currentSeasonIDs=ValueList(qGetCBCMember.seasonID));
                </cfscript>
   
                <input type="hidden" name="#familyID#count" value="#qGetCBCMember.recordcount#">
                
                <tr><th colspan="9" bgcolor="##e2efc7">#qGetUserMembers.firstname# #qGetUserMembers.lastname#</th><th bgcolor="##e2efc7"></th></tr>
                <tr style="font-weight:bold;">
                    <td valign="top"><b>Company</b></td>
                    <td valign="top"><b>Season</b></td>		
                    <td valign="top"><b>Authorization Received</b> <br><font size="-2">mm/dd/yyyy</font></td>		
                    <td valign="top"><b>CBC Submitted</b> <br><font size="-2">mm/dd/yyyy</font></td>
                    <td valign="top"><b>Expiration Date</b> <br><font size="-2">mm/dd/yyyy</font></td>		
                    <td valign="top"><b>Request ID</b></td>
                    <th valign="top">Flag CBC</th>
                    <td valign="top">Date Approved<br><font size="-2">mm/dd/yyyy</font></td>
                    <td valign="top">Notes</td>
                </tr>
                
                <!--- Member Update --->
                <cfif VAL(qGetCBCMember.recordcount)>
                    
                    <cfloop query="qGetCBCMember">
                        <tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("ffffe6") )#"> 
                            <td>
                                <cfif NOT isDate(date_sent)>
                                    <cfselect name="#familyID#companyID#currentrow#" required="yes" message="You must select a company">
                                        <cfloop query="qGetCompanies">
                                        <option value="#companyID#" <cfif qGetCompanies.companyID EQ qGetCBCMember.companyID>selected</cfif>>#companyshort#</option>
                                        </cfloop>
                                    </cfselect>
                                <cfelse>
                                    #companyshort#
                                    <input type="hidden" name="#familyID#companyID#currentrow#" value="#companyID#">
                                </cfif>
                            </td>
                            <td><b>#season#</b> <input type="hidden" name="#familyID#cbcid#currentrow#" value="#cbcid#"></td>
                            <td>
                                <cfif NOT isDate(date_sent)>
                                    <cfinput type="Text" name="#familyID#date_authorized#currentrow#" value="#DateFormat(date_authorized, 'mm/dd/yyyy')#" class="datePicker" validate="date" maxlength="10">
                                <cfelse>
                                    #DateFormat(date_authorized, 'mm/dd/yyyy')#
                                    <input type="hidden" name="#familyID#date_authorized#currentrow#" value="#DateFormat(date_authorized, 'mm/dd/yyyy')#">
                                </cfif>
                            </td>
                            <td><cfif isDate(date_sent)>#DateFormat(date_sent, 'mm/dd/yyyy')#<cfelse>processing</cfif></td>
                            <td><cfif isDate(date_expired)>#DateFormat(date_expired, 'mm/dd/yyyy')#<cfelse>n/a</cfif></td>
                            <td><a href="cbc/view_user_cbc.cfm?userID=#qGetCBCMember.userID#&cbcID=#qGetCBCMember.cbcID#&file=batch_#qGetCBCMember.batchID#_user_#qGetCBCMember.userID#_rec.xml" target="_blank">#requestid#</a></td>
                            <td><input type="checkbox" name="#familyID#flagCBC#currentrow#" <cfif VAL(flagCBC)>checked="checked"</cfif>></td>
                            <td> 
                                <input type="text" name="#familyID#date_approved#currentrow#" message="Please input a valid date." <cfif NOT IsDate(date_approved) is ''>onfocus="insertDate(this,'MM/DD/YYYY')"</cfif> value="#DateFormat(date_approved, 'mm/dd/yyyy')#" size="8" maxlength="10">	
                                <cfif NOT IsDate(date_approved)><br /><em><font size=-2>click in box for date</font></em></cfif>
                            </td>
                            <td><textarea rows="4" cols="25" name="#familyID#notes#currentrow#">#notes#</textarea></td>
                        </tr>
                    </cfloop>
                    
                </cfif>
                
                <!--- NEW CBC --->
                <cfif VAL(qGetMemberSeason.recordcount)>
                <tr>
                    <td>
                        <cfselect name="#familyID#companyID" required="yes" message="You must select a company">
                            <cfloop query="qGetCompanies">
                            <option value="#companyID#" <cfif qGetCompanies.companyID EQ client.companyID>selected</cfif>>#companyshort#</option>
                            </cfloop>
                        </cfselect>
                    </td>						
                    <td>
                        <cfselect name="#familyID#seasonID" required="yes" message="You must select a season">
                            <option value="0">Select a Season</option>
                            <cfloop query="qGetMemberSeason">
                            <option value="#seasonID#">#season#</option>
                            </cfloop>
                        </cfselect>
                    </td>
                    <td><cfinput type="Text" name="#familyID#date_authorized" value="" class="datePicker" validate="date" maxlength="10"></td>
                    <td>n/a</td>
                    <td>n/a</td>
                    <td>n/a</td>
                    <td width="20%">&nbsp;</td>
                </tr>
                <tr><td colspan="4"><font size="-2" color="000099">* Season must be selected.</font></td></tr>
                <cfelse>
                    <input type="hidden" name="#familyID#seasonID" value="0">
                </cfif>
            	<tr><td colspan="9">&nbsp; <br><br></td></tr>			
            </cfloop>
        </table>
        
        <table border="0" cellpadding="4" cellspacing="0" width="100%" class="section">
            <tr>
            	<td align="center">
                    <a href="?curdoc=user_info&userID=#qGetUser.userID#"><img src="pics/back.gif" border="0"></a> &nbsp;  &nbsp;  &nbsp;  &nbsp; &nbsp;  &nbsp;
                    <input name="Submit" type="image" src="pics/update.gif" border="0" alt="submit">
                </td>
            </tr>
        </table>
    </cfform>
    
	<!--- Table Footer --->
    <gui:tableFooter />

</cfoutput>
