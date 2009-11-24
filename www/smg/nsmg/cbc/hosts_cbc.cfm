<!--- ------------------------------------------------------------------------- ----
	
	File:		hosts_cbc.cfm
	Author:		Marcus Melo
	Date:		October 12, 2009
	Desc:		Host CBC Management

	Updated:  	10/12/09 - Combined qr_hosts_cbc.cfm to this file.
				10/13/09 - Running CBC background checks						

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
	
    <cfsetting requesttimeout="99999">
    
    <cftry>
	    <!--- param variables --->
	    <cfparam name="hostID" type="numeric" default="0">

		<!--- param FORM variables --->
        <cfparam name="FORM.submitted" type="numeric" default="0">
		<cfparam name="FORM.motherSeasonID" default="0">
		<cfparam name="FORM.fatherSeasonID" default="0">
		<cfparam name="FORM.memberIDs" default="0">

	    <cfcatch type="any">
        
			<cfscript>
				// set default values
				hostID = 0;
				FORM.submitted = 0;
			</cfscript>
            
		</cfcatch>
	</cftry>        


	<cfscript>
		// Gets List of Companies
		qGetCompanies = APPLICATION.CFC.COMPANY.getCompanies();
	
		// Gets Host Family Information
		qGetHost = APPLICATION.CFC.HOST.getHosts(hostID=hostID);

		// Gets Host Mother CBC
		qGetCBCMother = APPLICATION.CFC.CBC.getCBCHostByID(
			hostID=hostID, 
			cbcType='mother'
		);
		
		// Get Mother Available Seasons
		qGetMotherSeason = APPLICATION.CFC.CBC.getAvailableSeasons(currentSeasonIDs=ValueList(qGetCBCMother.seasonID));
		
		// Gets Host Father CBC
		qGetCBCFather = APPLICATION.CFC.CBC.getCBCHostByID(
			hostID=hostID, 
			cbcType='father'
		);
		
		// Get Father Available Seasons
		qGetFatherSeason = APPLICATION.CFC.CBC.getAvailableSeasons(currentSeasonIDs=ValueList(qGetCBCFather.seasonID));

		// Get Family Member CBC
		qGetHostMembers = APPLICATION.CFC.CBC.getEligibleHostMember(hostID=hostID);

		// Set Variables
		motherIDs = ValueList(qGetCBCMother.cbcfamID);
		fatherIDs = ValueList(qGetCBCFather.cbcfamID);
		memberIDs = ValueList(qGetHostMembers.childID);
	</cfscript>
    
    <!--- Form Submitted --->
	<cfif VAL(FORM.submitted)>

		<cfscript>
            // Check if we have valid data for host mother
            if ( VAL(FORM.motherSeasonID) AND LEN(FORM.motherdate_authorized) ) {
				// Insert Host Mother CBC
				APPLICATION.CFC.CBC.insertHostCBC(
					hostID=FORM.hostID,
					familyMemberID=0,
					cbcType='mother',
					seasonID=FORM.motherSeasonID, 
					companyID=FORM.mothercompanyID,
					dateAuthorized=FORM.motherdate_authorized
				);		
			}
			
            // Check if we have valid data for host father
            if ( VAL(FORM.fatherSeasonID) AND LEN(FORM.fatherdate_authorized) ) {
				// Insert Host Father CBC
                APPLICATION.CFC.CBC.insertHostCBC(
                    hostID=FORM.hostID,
                    familyMemberID=0,
                    cbcType='father',
                    seasonID=FORM.fatherSeasonID, 
                    companyID=FORM.fathercompanyID,
                    dateAuthorized=FORM.fatherdate_authorized
                );	
            }
        </cfscript>
        
        <!--- FAMILY MEMBERS --->
        <cfif VAL(FORM.memberIDs)>
        
            <cfloop list="#FORM.memberIDs#" index="memberID">
                
                <cfscript>
					// Check if we have valid data for family members
					if ( VAL(FORM[memberID & 'seasonID']) AND LEN(FORM[memberID & 'date_authorized']) ) {
						// Insert Host Father CBC
						APPLICATION.CFC.CBC.insertHostCBC(
							hostID=FORM.hostID,
							familyMemberID=memberID,
							cbcType='member',
							seasonID=FORM[memberID & 'seasonID'],
							companyID=FORM[memberID & 'companyID'],
							dateAuthorized=FORM[memberID & "date_authorized"]
						);	
					}
				</cfscript>
                
            </cfloop>
            
        </cfif>
        
        <!--- CBC FLAG HOST MOTHER ---->
        <cfloop list="#FORM.motherIDs#" index="cbcID">
            
            <cfscript>
				if ( IsDefined('motherFlagCBC'&cbcID) ) {
					flagValue = 1;
				} else {
					flagValue = 0;
				}
			
				// update Host Mother CBC Flag
				APPLICATION.CFC.CBC.updateHostFlagCBC(
					cbcfamID=cbcID,
					flagCBC=flagValue
				);			
			</cfscript>

        </cfloop>
        
        <!--- CBC FLAG HOST FATHER ---->
        <cfloop list="#FORM.fatherIDs#" index='m_cbcfamID'>
        
            <cfscript>
				if ( IsDefined('fatherFlagCBC'&cbcID) ) {
					flagValue = 1;
				} else {
					flagValue = 0;
				}
			
				// update Host Father CBC Flag
				APPLICATION.CFC.CBC.updateHostFlagCBC(
					cbcfamID=cbcID,
					flagCBC=flagValue
				);			
			</cfscript>

        </cfloop>
        
        <!--- Submit Batch 10/20/2009 --->
		<cfscript>
            // Declares newBatchID
			newBatchID = 0;
			// Set errorCount used in data validaation
			errorCount = 0;
			
			// Get CBCs Host Parents
            qGetCBCHost = APPLICATION.CFC.CBC.getCBCHost(
                companyID=CLIENT.companyID,
				hostID=FORM.hostID,
				userType='mother,father'
            );	

			// Get CBCs Host Member
			qGetCBCMember = APPLICATION.CFC.CBC.GetCBCMember(
				companyID=CLIENT.companyID,
				hostID=FORM.hostID
			);	
        </cfscript>  

		<!--- Host Parents Data Validation --->
		<cfloop query="qGetCBCHost">
			
            <cfscript>
				if (NOT LEN(Evaluate(qGetCBCHost.cbc_type & "firstname"))
					AND NOT LEN(Evaluate(qGetCBCHost.cbc_type & "lastname"))
					AND NOT LEN(Evaluate(qGetCBCHost.cbc_type & "dob")) 
					AND NOT IsDate(Evaluate(qGetCBCHost.cbc_type & "dob")) 
					AND NOT LEN(Evaluate(qGetCBCHost.cbc_type & "ssn")) ) {
					errorCount = errorCount + 1;
				}
			</cfscript>
		
        </cfloop>

		<!--- Host Members Data Validation --->
		<cfloop query="qGetCBCMember">
			
            <cfscript>
				if (NOT LEN(qGetCBCMember.name)
					AND NOT LEN(qGetCBCMember.lastname)
					AND NOT LEN(birthdate)
					AND NOT IsDate(qGetCBCMember.birthdate) 
					AND NOT LEN(qGetCBCMember.ssn) ) {
					errorCount = errorCount + 1;
				}
			</cfscript>
            					
        </cfloop>
        
        <!--- Check if any errors were found --->
		<cfif NOT VAL(errorCount)>
        
            <cfscript>
                // Create a batch ID - It must be unique
                newBatchID = APPLICATION.CFC.CBC.createBatchID(
                    companyID=CLIENT.companyID,
                    userID=CLIENT.userid,
                    cbcTotal=qGetCBCHost.recordcount,
                    batchType='host'
                );
			</cfscript>
            
            <cfloop query="qGetCBCHost">
            
				<cfscript>
					// Get Company ID
					qGetCompanyID = APPLICATION.CFC.COMPANY.getCompanies(companyID=qGetCBCHost.companyID);
				
                    // Process Batch
                    CBCStatus = APPLICATION.CFC.CBC.processBatch(
                        companyID=qGetCBCHost.companyID,
                        companyShort=qGetCompanyID.companyShort,
                        batchID=newBatchID,
                        userType=qGetCBCHost.cbc_type,
                        hostID=qGetCBCHost.hostid,
                        CBCFamID=qGetCBCHost.CBCFamID,
                        // XML variables
                        username=qGetCompanyID.gis_username,
                        password=qGetCompanyID.gis_password,
                        account=qGetCompanyID.gis_account,
                        SSN=Evaluate(qGetCBCHost.cbc_type & 'ssn'),
                        lastName=Evaluate(qGetCBCHost.cbc_type & 'lastname'),
                        firstName=Evaluate(qGetCBCHost.cbc_type & 'firstname'),
                        middleName=Left(Evaluate(qGetCBCHost.cbc_type & 'middlename'),1),
                        DOBYear=DateFormat(Evaluate(qGetCBCHost.cbc_type & 'dob'), 'yyyy'),
                        DOBMonth=DateFormat(Evaluate(qGetCBCHost.cbc_type & 'dob'), 'mm'),
                        DOBDay=DateFormat(Evaluate(qGetCBCHost.cbc_type & 'dob'), 'dd'),
                        noSummary='YES',
                        includeDetails='YES'
                    );	
                </cfscript>
            
            </cfloop> <!--- Loop qGetCBCHost --->
            
            <cfloop query="qGetCBCMember"> 
            
                <cfscript>
					// Get Company ID
					qGetCompanyID = APPLICATION.CFC.COMPANY.getCompanies(companyID=qGetCBCMember.companyID);
				
                    // Process Batch
                    CBCStatus = APPLICATION.CFC.CBC.processBatch(
                        companyID=qGetCompanyID.companyID,
                        companyShort=qGetCompanyID.companyShort,
                        batchID=newBatchID,
                        userType='member',
                        hostID=qGetCBCMember.hostid,
                        CBCFamID=qGetCBCMember.CBCFamID,
                        // XML variables
                        username=qGetCompanyID.gis_username,
                        password=qGetCompanyID.gis_password,
                        account=qGetCompanyID.gis_account,
                        SSN=qGetCBCMember.ssn,
                        lastName=qGetCBCMember.lastName,
                        firstName=qGetCBCMember.name,
                        middleName=Left(qGetCBCMember.middleName,1),
                        DOBYear=DateFormat(qGetCBCMember.birthdate, 'yyyy'),
                        DOBMonth=DateFormat(qGetCBCMember.birthdate, 'mm'),
                        DOBDay=DateFormat(qGetCBCMember.birthdate, 'dd'),
                        noSummary='YES',
                        includeDetails='YES'
                    );	
                </cfscript>
			
            </cfloop> <!--- qGetCBCMember --->                    
            
        </cfif> <!--- NOT VAL(errorCount) --->

    </cfif> <!--- VAL(FORM.submitted) --->
    
</cfsilent>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" 
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Host Family CBC Management</title>
</head>
<body>

<script language="JavaScript"> 	
<!--//
// opens letters in a defined format
function OpenWindow(url) {
	newwindow=window.open(url, 'Application', 'height=300, width=720, location=no, scrollbars=yes, menubar=yes, toolbars=no, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}
//-->
</script> 	<!--// [ end ] custom JavaScript //-->

<cfoutput>


<!--- FORM submitted --->
<cfif VAL(FORM.submitted)>

	<script language="JavaScript">
        <!-- 
        alert("You have successfully updated this page. Thank You.");
            location.replace("?curdoc=cbc/hosts_cbc&hostID=#hostID#");
        //-->
    </script>
    
</cfif>


<cfif NOT VAL(hostID)>
	Sorry, an error has ocurred. Please go back and try again.
	<cfabort>
</cfif>


<!--- header of the table --->
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
<tr valign=middle height=24>
	<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
	<td width=26 background="pics/header_background.gif"><img src="pics/school.gif"></td>
	<td background="pics/header_background.gif"><h2>Criminal Background Check - Host Family and Members</h2></td>
	<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfform action="?curdoc=cbc/hosts_cbc" method="post"> <!--- ?curdoc=cbc/qr_hosts_cbc / ?#CGI.QUERY_STRING# --->
    <cfinput type="hidden" name="submitted" value="1">
    <cfinput type="hidden" name="hostID" value="#hostID#">
    <!--- list cbcs --->
    <cfinput type="hidden" name="motherIDs" value="#motherIDs#">
    <cfinput type="hidden" name="fatherIDs" value="#fatherIDs#">
    <cfinput type="hidden" name="memberIDs" value="#memberIDs#">

    <table border=0 cellpadding=4 cellspacing=0 width="100%" class="section">
        <!--- 
        <tr><td valign="center"> <img src="student_app/pics/delete.gif"><td colspan="5"> If you are running a second rouund of reports,  delete the current CBC records. This will remove CBC's associatd with ALL family members.</td></tr>
        --->
		<tr><th colspan="6" bgcolor="e2efc7">H O S T &nbsp; P A R E N T S</th><th bgcolor="e2efc7"><a href="javascript:OpenWindow('cbc/host_parents_info.cfm?hostID=#hostID#');">Edit Host Parents Info</a></th></tr>
        <tr><td colspan="6">&nbsp;</td></tr>
        
        <!--- HOST MOTHER --->
        <cfif qGetHost.motherfirstname NEQ '' AND qGetHost.motherlastname NEQ ''>
            <tr><td colspan="6" bgcolor="e2efc7"><b>Host Mother - #qGetHost.motherfirstname# #qGetHost.motherlastname#</b></td><th bgcolor="e2efc7"></th></tr>
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
            <cfloop query="qGetCBCMother">
                <tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("ffffe6") )#"> 
                    <td align="center">#companyshort#</td>
                    <td align="center"><b>#season#</b></td>
                    <td align="center">#DateFormat(date_authorized, 'mm/dd/yyyy')#</td>
                    <td align="center"><cfif date_sent EQ ''>in process<cfelse>#DateFormat(date_sent, 'mm/dd/yyyy')#</cfif></td>
                    <td align="center"><cfif date_received EQ ''>in process<cfelse>#DateFormat(date_received, 'mm/dd/yyyy')#</cfif></td>
                    <td align="center">#requestID#</td>
                    <td align="center"><input type="checkbox" name="motherFlagCBC#cbcfamID#" <cfif flagcbc EQ 1>checked="checked"</cfif>></td>
                    <td width="20%">&nbsp;</td>
                </tr>
            </cfloop>
        
			<!--- NEW CBC - HOST MOTHER --->
            <cfif qGetMotherSeason.recordcount GT '0'>
                <cfif qGetHost.motherssn EQ ''>
                    <tr><td colspan="6">PS: Mother's SSN is missing.</td></tr>
                </cfif>
                <cfif qGetHost.motherdob EQ ''>
                    <tr><td colspan="6">Mother's date of birth cannot be blank. Please check the DOB before you continue.</td></tr>
                <cfelse>
                    <tr>
                        <td align="center">
                            <cfselect name="mothercompanyID" required="yes" message="You must select a company">
                                <cfloop query="qGetCompanies">
                                <option value="#companyID#" <cfif qGetCompanies.companyID EQ client.companyID>selected</cfif>>#companyshort#</option>
                                </cfloop>
                            </cfselect>
                        </td>		
                        <td align="center">
                            <cfselect name="motherSeasonID" required="yes" message="You must select a season">
                                <option value="0">Select a Season</option>
                                <cfloop query="qGetMotherSeason"><option value="#seasonID#">#season#</option></cfloop>
                            </cfselect>
                        </td>
                        <td align="center"><cfinput type="Text" name="motherdate_authorized" size="8" value="" validate="date" maxlength="10"></td>
                        <td align="center">n/a</td>
                        <td align="center">n/a</td>
                        <td align="center">n/a</td>
                        <td width="20%">&nbsp;</td>
                    </tr>
                    <tr><td colspan="4"><font size="-2" color="000099">* Season must be selected.</font></td></tr>
                </cfif>
            <cfelse>
                <cfinput type="hidden" name="motherSeasonID" value="0">
            </cfif>
            <tr><td colspan="6">&nbsp; <br></td></tr>
        </cfif>
        
        <!--- HOST FATHER --->
        <cfif qGetHost.fatherfirstname NEQ '' AND qGetHost.fatherlastname NEQ ''>
            <tr><td colspan="6" bgcolor="e2efc7"><b>Host Father - #qGetHost.fatherfirstname# #qGetHost.fatherlastname#</b></td><th bgcolor="e2efc7"></th></tr>
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
            <cfloop query="qGetCBCFather">
                <tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("ffffe6") )#"> 
                    <td align="center">#companyshort#</td>
                    <td align="center"><b>#season#</b></td>
                    <td align="center">#DateFormat(date_authorized, 'mm/dd/yyyy')#</td>
                    <td align="center"><cfif date_sent EQ ''>in process<cfelse>#DateFormat(date_sent, 'mm/dd/yyyy')#</cfif></td>
                    <td align="center"><cfif date_received EQ ''>in process<cfelse>#DateFormat(date_received, 'mm/dd/yyyy')#</cfif></td>
                    <td align="center">#requestID#</td>
                    <td align="center"><input type="checkbox" name="fatherFlagCBC#cbcfamID#" <cfif flagcbc EQ 1>checked="checked"</cfif>></td>
                    <td width="20%">&nbsp;</td>
                </tr>
            </cfloop>
        
			<!--- NEW CBC --->
            <cfif qGetFatherSeason.recordcount GT '0'>
                <cfif qGetHost.fatherssn EQ ''>
                    <tr><td colspan="6">PS: Father's SSN is missing.</td></tr>
                </cfif>
                <cfif qGetHost.fatherdob EQ ''>
                    <tr><td colspan="6">Father's date of birth cannot be blank. Please check the DOB before you continue.</td></tr>
                <cfelse>
                    <tr>
                        <td align="center">
                            <cfselect name="fathercompanyID" required="yes" message="You must select a company">
                                <cfloop query="qGetCompanies">
                                <option value="#companyID#" <cfif qGetCompanies.companyID EQ client.companyID>selected</cfif>>#companyshort#</option>
                                </cfloop>
                            </cfselect>
                        </td>		
                        <td align="center">
                            <cfselect name="fatherSeasonID" required="yes" message="You must select a season">
                                <option value="0">Select a Season</option>
                                <cfloop query="qGetFatherSeason"><option value="#seasonID#">#season#</option></cfloop>
                            </cfselect>
                        </td>
                        <td align="center"><cfinput type="Text" name="fatherdate_authorized" size="8" value="" validate="date" maxlength="10"></td>
                        <td align="center">n/a</td>
                        <td align="center">n/a</td>
                        <td align="center">n/a</td>
                        <td width="20%">&nbsp;</td>
                    </tr>
                    <tr><td colspan="4"><font size="-2" color="000099">* Season must be selected.</font></td></tr>
                </cfif>
            <cfelse>
                <cfinput type="hidden" name="fatherSeasonID" value="0">
            </cfif>
        	<tr><td colspan="6">&nbsp; <br></td></tr>
        </cfif>
        
        <!--- OTHER FAMILY MEMBERS ---> 	
        <tr><th colspan="6" bgcolor="e2efc7">O T H E R &nbsp; F A M I L Y &nbsp; M E M B E R S &nbsp; +17 &nbsp; Y E A R S &nbsp; OLD</th><th bgcolor="e2efc7"><a href="javascript:OpenWindow('cbc/host_fam_cbc.cfm?hostID=#hostID#');">Edit Family Members Info</a></th></tr>
        <tr><td colspan="6">&nbsp;</td></tr>
        <cfif qGetHostMembers.recordcount EQ '0'>
            <tr><td colspan="6" align="center">There are no family members.</td></tr>
            <tr><td colspan="6">&nbsp;</td></tr>
        <cfelse>	
            <cfloop query="qGetHostMembers">
                
                <cfscript>
					// Set current Family ID
					family_ID = qGetHostMembers.childID;
					
					// Gets Host Member CBC
					qGetCBCMember = APPLICATION.CFC.CBC.getCBCHostByID(
						hostID=hostID,
						familyMemberID=family_ID,
						cbcType='member'
					);		

					// Get Member Available Seasons
					qGetMemberSeason = APPLICATION.CFC.CBC.getAvailableSeasons(currentSeasonIDs=ValueList(qGetCBCMember.seasonID));
				</cfscript>
   
                <tr><td colspan="6" bgcolor="e2efc7"><b>#name# #lastname#</b></td><th bgcolor="e2efc7"></th></tr>
                <tr>
                    <th valign="top">Company</th>
                    <th valign="top">Season</th>		
                    <th valign="top">Authorization Received <br><font size="-2">mm/dd/yyyy</font></th>		
                    <th valign="top">CBC Sent <br><font size="-2">mm/dd/yyyy</font></th>		
                    <th valign="top">CBC Received <br><font size="-2">mm/dd/yyyy</font></th>
                    <th valign="top">Request ID</th>
                    <td width="20%">&nbsp;</td>
                </tr>
                <cfinput type="hidden" name="#family_ID#count" value="#qGetCBCMember.recordcount#">
                
                <!--- UPDATE DATE RECEIVED --->
                <cfif qGetCBCMember.recordcount NEQ '0'>
                    <cfloop query="qGetCBCMember">
                        <tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("ffffe6") )#"> 
                            <td align="center">#companyshort#</td>
                            <td align="center"><b>#season#</b></td>
                            <td align="center">#DateFormat(date_authorized, 'mm/dd/yyyy')#</td>
                            <td align="center"><cfif date_sent EQ ''>in process<cfelse>#DateFormat(date_sent, 'mm/dd/yyyy')#</cfif></td>
                            <td align="center"><cfif date_received EQ ''>in process<cfelse>#DateFormat(date_received, 'mm/dd/yyyy')#</cfif></td>
                            <td align="center">#requestID#</td>
                            <td width="20%">&nbsp;</td>
                        </tr>
                    </cfloop>
                </cfif>
                
                <!--- NEW CBC --->
                <cfif qGetMemberSeason.recordcount GT '0'>
                    <tr>
                        <td align="center">
                            <cfselect name="#family_ID#companyID" required="yes" message="You must select a company">
                                <cfloop query="qGetCompanies">
                                <option value="#companyID#" <cfif qGetCompanies.companyID EQ client.companyID>selected</cfif>>#companyshort#</option>
                                </cfloop>
                            </cfselect>
                        </td>						
                        <td align="center">
                            <cfselect name="#family_ID#seasonID" required="yes" message="You must select a season">
                                <option value="0">Select a Season</option>
                                <cfloop query="qGetMemberSeason">
                                <option value="#seasonID#">#season#</option>
                                </cfloop>
                            </cfselect>
                        </td>
                        <td align="center"><cfinput type="Text" name="#family_ID#date_authorized" size="8" value="" validate="date" maxlength="10"></td>
                        <td align="center">n/a</td>
                        <td align="center">n/a</td>
                        <td align="center">n/a</td>
                        <td width="20%">&nbsp;</td>
                    </tr>
                    <tr><td colspan="4"><font size="-2" color="000099">* Season must be selected.</font></td></tr>
                <cfelse>
                    <cfinput type="hidden" name="#family_ID#seasonID" value="0">
                </cfif>
            <tr><td colspan="6">&nbsp; <br><br></td></tr>			
            </cfloop>
        </cfif>
    </table>
    
    <table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
        <tr><td align="center">
                <a href="?curdoc=host_fam_info&hostID=#hostID#"><img src="pics/back.gif" border="0"></a>
                &nbsp;  &nbsp;  &nbsp;  &nbsp; &nbsp;  &nbsp;
                <input name="Submit" type="image" src="pics/update.gif" border=0 alt="submit">
            </td>
        <td width="20%">&nbsp;</td></tr>
    </table>
</cfform>

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>
</cfoutput>

</body>
</html>