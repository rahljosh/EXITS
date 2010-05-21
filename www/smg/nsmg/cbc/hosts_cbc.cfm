<!--- ------------------------------------------------------------------------- ----
	
	File:		hosts_cbc.cfm
	Author:		Marcus Melo
	Date:		October 12, 2009
	Desc:		Host CBC Management

	Updated:  	10/12/09 - Combined qr_hosts_cbc.cfm to this file.
				10/13/09 - Running CBCs on this page						

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
	
    <cfsetting requesttimeout="9999">

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customtags/gui/" prefix="gui" />	
    
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
		qGetCompanies = APPCFC.COMPANY.getCompanies();
	
		// Gets Host Family Information
		qGetHost = APPCFC.HOST.getHosts(hostID=hostID);

		// Get Host Mother CBC
		qGetCBCMother = APPCFC.CBC.getCBCHostByID(
			hostID=hostID, 
			cbcType='mother'
		);
		
		// Get Mother Available Seasons
		qGetMotherSeason = APPCFC.CBC.getAvailableSeasons(currentSeasonIDs=ValueList(qGetCBCMother.seasonID));
		
		// Gets Host Father CBC
		qGetCBCFather = APPCFC.CBC.getCBCHostByID(
			hostID=hostID, 
			cbcType='father'
		);
		
		// Get Father Available Seasons
		qGetFatherSeason = APPCFC.CBC.getAvailableSeasons(currentSeasonIDs=ValueList(qGetCBCFather.seasonID));

		// Get Family Member CBC
		qGetHostMembers = APPCFC.CBC.getEligibleHostMember(hostID=hostID);

		// Set Variables
		motherIDs = ValueList(qGetCBCMother.cbcfamID);
		fatherIDs = ValueList(qGetCBCFather.cbcfamID);
		memberIDs = ValueList(qGetHostMembers.childID);
		
		// Create Structure to store errors
		Errors = StructNew();
		// Create Array to store error messages
		Errors.Messages = ArrayNew(1);
	</cfscript>
    
    <!--- Form Submitted --->
	<cfif VAL(FORM.submitted)>

		<cfscript>
            // Check if we have valid data for host mother
            if ( VAL(FORM.motherSeasonID) AND LEN(FORM.motherdate_authorized) ) {
				// Insert Host Mother CBC
				APPCFC.CBC.insertHostCBC(
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
                APPCFC.CBC.insertHostCBC(
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
						APPCFC.CBC.insertHostCBC(
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
				if ( IsDefined('motherFlagCBC' & cbcID) ) {
					flagValue = 1;
				} else {
					flagValue = 0;
				}
			
				// update Host Mother CBC Flag
				APPCFC.CBC.updateHostFlagCBC(
					cbcfamID=cbcID,
					flagCBC=flagValue
				);			
			</cfscript>

        </cfloop>
        
        <!--- CBC FLAG HOST FATHER ---->
        <cfloop list="#FORM.fatherIDs#" index='cbcID'>
        
            <cfscript>
				if ( IsDefined('fatherFlagCBC' & cbcID) ) {
					flagValue = 1;
				} else {
					flagValue = 0;
				}
			
				// update Host Father CBC Flag
				APPCFC.CBC.updateHostFlagCBC(
					cbcfamID=cbcID,
					flagCBC=flagValue
				);			
			</cfscript>

        </cfloop>
        
        <!--- Submit Batch 10/20/2009 --->
		<cfscript>
            // Declare newBatchID
			newBatchID = 0;
			// Set errorCount used in data validation
			errorCount = 0;
			
			// Get CBCs Host Parents
            qGetCBCHost = APPCFC.CBC.getPendingCBCHost(
                companyID=CLIENT.companyID,
				hostID=FORM.hostID,
				userType='mother,father'
            );	

			// Get CBCs Host Member
			qGetCBCMember = APPCFC.CBC.getPendingCBCHostMember(
				companyID=CLIENT.companyID,
				hostID=FORM.hostID
			);	
        </cfscript>  

		<!--- Submit CBC Host Parents --->
		<cfloop query="qGetCBCHost">
			
            <cfscript>
				// Set processCBC to 1, if error is found it is set to 0 and it does not validate.
				processCBC = 1;
			
				// Data Validation
				// First Name
				if ( NOT LEN(Evaluate(qGetCBCHost.cbc_type & "firstname")) ) {
					ArrayAppend(Errors.Messages, "Missing first name for host #qGetCBCHost.cbc_type# #Evaluate(qGetCBCHost.cbc_type & "lastname")# (###qGetCBCHost.hostid#).");			
					processCBC = 0;
				}
				// Last Name
				if ( NOT LEN(Evaluate(qGetCBCHost.cbc_type & "lastname")) )  {
					ArrayAppend(Errors.Messages, "Missing last name for host #qGetCBCHost.cbc_type# #Evaluate(qGetCBCHost.cbc_type & "firstname")# (###qGetCBCHost.hostid#).");
					processCBC = 0;
				}
				// DOB
				if ( NOT LEN(Evaluate(qGetCBCHost.cbc_type & "dob")) OR NOT IsDate(Evaluate(qGetCBCHost.cbc_type & "dob")) )  {
					ArrayAppend(Errors.Messages, "DOB is missing or is not a valid date for host #qGetCBCHost.cbc_type# #Evaluate(qGetCBCHost.cbc_type & "firstname")# #Evaluate(qGetCBCHost.cbc_type & "lastname")# (###qGetCBCHost.hostid#).");
					processCBC = 0;
				}
				// SSN
				if ( NOT LEN(Evaluate(qGetCBCHost.cbc_type & "ssn")) )  {
					ArrayAppend(Errors.Messages, "Missing SSN for host #qGetCBCHost.cbc_type# #Evaluate(qGetCBCHost.cbc_type & "firstname")# #Evaluate(qGetCBCHost.cbc_type & "lastname")# (###qGetCBCHost.hostid#).");
					processCBC = 0;
				}
				
				// Data Validation
				if ( VAL(processCBC) ) {

					// Get Company ID
					qGetCompanyID = APPCFC.COMPANY.getCompanies(companyID=qGetCBCHost.companyID);
				
                    // Process Batch
                    CBCStatus = APPCFC.CBC.processBatch(
                        companyID=qGetCBCHost.companyID,
                        companyShort=qGetCompanyID.companyShort,
                        userType=qGetCBCHost.cbc_type,
                        hostID=qGetCBCHost.hostid,
                        cbcID=qGetCBCHost.CBCFamID,
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
                        DOBDay=DateFormat(Evaluate(qGetCBCHost.cbc_type & 'dob'), 'dd')
                    );	

				}
			</cfscript>
		
        </cfloop>

		<!--- Submit CBC Host Member --->
		<cfloop query="qGetCBCMember">
			
            <cfscript>
				// Set processCBC to 1, if error is found it is set to 0 and it does not validate.
				processCBC = 1;
				
				// Data Validation
				if ( NOT LEN(qGetCBCMember.name) ) {
					ArrayAppend(Errors.Messages, "Missing first name for #qGetCBCMember.lastname# member of (###qGetCBCMember.hostid#).");			
					processCBC = 0;
				}
			
				if ( NOT LEN(qGetCBCMember.lastname) )  {
					ArrayAppend(Errors.Messages, "Missing last name for #qGetCBCMember.name# member of (###qGetCBCMember.hostid#).");
					processCBC = 0;
				}
				
				if ( NOT LEN(qGetCBCMember.birthdate) OR NOT IsDate(qGetCBCMember.birthdate) )  {
					ArrayAppend(Errors.Messages, "Missing DOB for #qGetCBCMember.name# #qGetCBCMember.lastname# member of (###qGetCBCMember.hostid#).");
					processCBC = 0;
				}
	
				if ( NOT LEN(qGetCBCMember.ssn) )  {
					ArrayAppend(Errors.Messages, "Missing SSN for #qGetCBCMember.name# #qGetCBCMember.lastname# member of (###qGetCBCMember.hostid#).");
					processCBC = 0;
				}
			
				// Data Validation
				if ( VAL(processCBC) ) {
					
					// Get Company ID
					qGetCompanyID = APPCFC.COMPANY.getCompanies(companyID=qGetCBCMember.companyID);
				
                    // Process Batch
                    CBCStatus = APPCFC.CBC.processBatch(
                        companyID=qGetCompanyID.companyID,
                        companyShort=qGetCompanyID.companyShort,
                        userType='member',
                        hostID=qGetCBCMember.hostid,
                        cbcID=qGetCBCMember.CBCFamID,
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
                        DOBDay=DateFormat(qGetCBCMember.birthdate, 'dd')
                    );	

				}
			</cfscript>
            		
        </cfloop>
        
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

<cfoutput>

<cfif NOT VAL(hostID)>
	Sorry, an error has ocurred. Please go back and try again.
	<cfabort>
</cfif>

<!--- Table Header --->
<gui:tableHeader
	imageName="school.gif"
	tableTitle="Criminal Background Check - Host Family and Members ###hostID#"
	tableRightTitle=""
/>

<cfform action="?curdoc=cbc/hosts_cbc&hostID=#hostID#" method="post">
    <cfinput type="hidden" name="submitted" value="1">
    <cfinput type="hidden" name="hostID" value="#hostID#">
    <!--- list cbcs --->
    <cfinput type="hidden" name="motherIDs" value="#motherIDs#">
    <cfinput type="hidden" name="fatherIDs" value="#fatherIDs#">
    <cfinput type="hidden" name="memberIDs" value="#memberIDs#">

    <table border="0" cellpadding="4" cellspacing="0" width="100%" class="section">

		<!--- FORM submitted --->
        <cfif VAL(FORM.submitted)>

			<!--- Display Errors --->
            <cfif VAL(ArrayLen(Errors.Messages))>
                <tr>
                    <td colspan="6" style="padding:15px; line-height:1.5em;">
                        <font color="##FF0000">
                        	Criminal Background Checks could not be processed for one or more family members. <br> 
                            Please review the following items: <br>
                        </font>
        
                        <cfloop from="1" to="#ArrayLen(Errors.Messages)#" index="i">
                            #Errors.Messages[i]# <br>        	
                        </cfloop>
                    </td>
                </tr>
            <cfelse>
                <tr><td colspan="6" style="padding:15px; line-height:1.5em;"><font color="##0000FF">Form Successfully Submitted.</font></td></tr>
            </cfif>	
            
        </cfif>
        	
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
            </tr>
            <cfloop query="qGetCBCMother">
                <tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("ffffe6") )#"> 
                    <td align="center">#companyshort#</td>
                    <td align="center"><b>#season#</b></td>
                    <td align="center">#DateFormat(date_authorized, 'mm/dd/yyyy')#</td>
                    <td align="center"><cfif NOT LEN(date_sent)>in process<cfelse>#DateFormat(date_sent, 'mm/dd/yyyy')#</cfif></td>
                    <td align="center"><cfif NOT LEN(date_received)>in process<cfelse>#DateFormat(date_received, 'mm/dd/yyyy')#</cfif></td>
                    <td align="center"><a href="cbc/view_host_cbc.cfm?hostID=#qGetCBCMother.hostID#&CBCFamID=#qGetCBCMother.CBCFamID#&file=batch_#qGetCBCMother.batchid#_host_mother_#qGetCBCMother.hostid#_rec.xml" target="_blank">#requestID#</a></td>
                    <td align="center"><input type="checkbox" name="motherFlagCBC#cbcfamID#" <cfif VAL(flagCBC)>checked="checked"</cfif>></td>
                </tr>
            </cfloop>
        
			<!--- NEW CBC - HOST MOTHER --->
            <cfif VAL(qGetMotherSeason.recordcount)>
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
            </tr>
            <cfloop query="qGetCBCFather">
                <tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("ffffe6") )#"> 
                    <td align="center">#companyshort#</td>
                    <td align="center"><b>#season#</b></td>
                    <td align="center">#DateFormat(date_authorized, 'mm/dd/yyyy')#</td>
                    <td align="center"><cfif NOT LEN(date_sent)>in process<cfelse>#DateFormat(date_sent, 'mm/dd/yyyy')#</cfif></td>
                    <td align="center"><cfif NOT LEN(date_received)>in process<cfelse>#DateFormat(date_received, 'mm/dd/yyyy')#</cfif></td>
                    <td align="center"><a href="cbc/view_host_cbc.cfm?hostID=#qGetCBCFather.hostID#&CBCFamID=#qGetCBCFather.CBCFamID#&file=batch_#qGetCBCFather.batchid#_host_mother_#qGetCBCFather.hostid#_rec.xml" target="_blank">#requestID#</a></td>
                    <td align="center"><input type="checkbox" name="fatherFlagCBC#cbcfamID#" <cfif VAL(flagCBC)>checked="checked"</cfif>></td>
                </tr>
            </cfloop>
        
			<!--- NEW CBC --->
            <cfif VAL(qGetFatherSeason.recordcount)>
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
					familyID = qGetHostMembers.childID;
					
					// Gets Host Member CBC
					qGetCBCMember = APPCFC.CBC.getCBCHostByID(
						hostID=hostID,
						familyMemberID=familyID,
						cbcType='member'
					);		

					// Get Member Available Seasons
					qGetMemberSeason = APPCFC.CBC.getAvailableSeasons(currentSeasonIDs=ValueList(qGetCBCMember.seasonID));
				</cfscript>
   
   				<cfinput type="hidden" name="#familyID#count" value="#qGetCBCMember.recordcount#">
   
                <tr><td colspan="6" bgcolor="e2efc7"><b>#name# #lastname#</b></td><th bgcolor="e2efc7"></th></tr>
                <tr>
                    <th valign="top">Company</th>
                    <th valign="top">Season</th>		
                    <th valign="top">Authorization Received <br><font size="-2">mm/dd/yyyy</font></th>		
                    <th valign="top">CBC Sent <br><font size="-2">mm/dd/yyyy</font></th>		
                    <th valign="top">CBC Received <br><font size="-2">mm/dd/yyyy</font></th>
                    <th valign="top">Request ID</th>
                </tr>
                
                <!--- UPDATE DATE RECEIVED --->
                <cfif qGetCBCMember.recordcount NEQ '0'>
                    <cfloop query="qGetCBCMember">
                        <tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("ffffe6") )#"> 
                            <td align="center">#companyshort#</td>
                            <td align="center"><b>#season#</b></td>
                            <td align="center">#DateFormat(date_authorized, 'mm/dd/yyyy')#</td>
                            <td align="center"><cfif NOT LEN(date_sent)>in process<cfelse>#DateFormat(date_sent, 'mm/dd/yyyy')#</cfif></td>
                            <td align="center"><cfif NOT LEN(date_received)>in process<cfelse>#DateFormat(date_received, 'mm/dd/yyyy')#</cfif></td>
                            <td align="center"><a href="cbc/view_host_cbc.cfm?hostID=#qGetCBCMember.hostID#&CBCFamID=#qGetCBCMember.CBCFamID#&file=batch_#qGetCBCMember.batchid#_host_mother_#qGetCBCMember.hostid#_rec.xml" target="_blank">#requestID#</a></td>
                        </tr>
                    </cfloop>
                </cfif>
                
                <!--- NEW CBC --->
                <cfif qGetMemberSeason.recordcount GT '0'>
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
                <a href="?curdoc=host_fam_info&hostID=#hostID#"><img src="pics/back.gif" border="0"></a>
                &nbsp;  &nbsp;  &nbsp;  &nbsp; &nbsp;  &nbsp;
                <input name="Submit" type="image" src="pics/update.gif" border="0" alt="submit">
            </td>
    </table>
</cfform>

<!--- Table Footer --->
<gui:tableFooter />

</cfoutput>

</body>
</html>