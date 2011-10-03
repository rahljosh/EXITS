<!--- ------------------------------------------------------------------------- ----
	
	File:		step1.cfm
	Author:		Marcus Melo
	Date:		September 26, 2011
	Desc:		MPD Tours - Step 1 - Look Up Student
	
	Updates:	
	
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
	<!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	
    <cfscript>
		// Student is alredy logged in - go to BookTrip page
		if ( VAL(SESSION.TOUR.isLoggedIn) ) {

			// Go to confirmation
			Location('#CGI.SCRIPT_NAME#?action=preferences', 'no');

		}	
	</cfscript>
    
    <!--- FORM SUBMITTED | Look UP Account --->
	<cfif FORM.subAction EQ 'lookUpStudent'>
        
        <cfscript>
			// Local Variables
			vMissingStudentInfoCount = 0;
			vMissingHostFamilyInfoCount = 0;
			
			// Check number of student items using
			if ( NOT VAL(FORM.studentID) ) {
                vMissingStudentInfoCount ++;
            }
            
            if ( LEN(FORM.studentID) AND NOT IsNumeric(FORM.studentID) ) {
				FORM.studentID = '';
				// Get all the missing items in a list
				SESSION.formErrors.Add("Please enter only numbers on the student ID field");
            }
			
            if ( NOT LEN(FORM.familyLastName) ) {
                vMissingStudentInfoCount ++;
            }
            
            if ( NOT LEN(FORM.dob) ) {
                vMissingStudentInfoCount ++;
            }
            
            if ( LEN(FORM.dob) AND NOT IsDate(FORM.dob) ) {
				FORM.dob = '';
				// Get all the missing items in a list
				SESSION.formErrors.Add("Please enter a valid student DOB");
            }
			
			// Host Family Count
            if ( NOT LEN(FORM.hostLastName) ) {
                vMissingHostFamilyInfoCount ++;
            }
            
            if ( NOT LEN(FORM.hostEmail) ) {
                vMissingHostFamilyInfoCount ++;
            }
			
            if ( LEN(FORM.hostEmail) AND NOT IsValid("email", FORM.hostEmail) ) {
				// Get all the missing items in a list
				SESSION.formErrors.Add("Please enter a valid host Email Address");
            } 
            
            if ( NOT LEN(FORM.hostCity) ) {
                vMissingHostFamilyInfoCount ++;
            }
            
            if ( NOT LEN(FORM.hostZip) ) {
                vMissingHostFamilyInfoCount ++;
            }
			
			// Host Family
			if (vMissingStudentInfoCount GTE 1 ) {
				// Get all the missing items in a list
				SESSION.formErrors.Add("All fields are required in the Student Information section.");
			}	
			
			// Host Family
			if (vMissingHostFamilyInfoCount GT 2 ) {
				// Get all the missing items in a list
				SESSION.formErrors.Add("You must specify at least two (2) pieces of information for the Host Family Information section.");
			}	
		</cfscript>
        
        <cfif NOT SESSION.formErrors.length()>
        
			<!----Check to see if there is a student based on the info.---->
            <cfquery name="qCheckStudent" datasource="#APPLICATION.DSN.Source#">
                SELECT 
                	studentID,
                    hostID
                FROM 
                	smg_students
                WHERE 
                	active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                     
                <cfif VAL(FORM.studentID)>
                    AND 
                        studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#TRIM(FORM.studentID)#">
                </cfif>
                
                <cfif LEN(FORM.familyLastName)>
                    AND 
                        familylastname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#TRIM(familyLastName)#%">
                </cfif>
                
                <cfif isDate(FORM.dob)>
                    AND  
                        dob = <cfqueryparam cfsqltype="cf_sql_date" value="#TRIM(FORM.dob)#"> 
                </cfif>
            </cfquery>
            
			<cfif VAL(qCheckStudent.recordcount)>
            
                <!-----Check to see if there is host associted with this student---->
                <cfquery name="qCheckHostFamily" datasource="#APPLICATION.DSN.Source#">
                    SELECT 
                        hostid 
                    FROM
                        smg_hosts                
                    WHERE
                        1 = 1
                    
                    <cfif LEN(FORM.hostLastName)>
                        AND 
                            familylastname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#TRIM(FORM.hostLastName)#%">
                    </cfif>
                    
                    <cfif LEN(FORM.hostCity)>
                        AND 
                            city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.hostCity)#">
                    </cfif>
                    
                    <cfif LEN(FORM.hostZip)>
                        AND 
                            zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.hostZip)#">
                    </cfif>
                    
                    <cfif LEN(FORM.hostEmail)>
                        AND
                            email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.hostEmail)#">
                    </cfif>            
                </cfquery>
            
                <cfloop query="qCheckHostFamily">
                    
                    <cfscript>	
						// Login Student if Account has been looked up successfully
						if ( qCheckStudent.hostID EQ qCheckHostFamily.hostID ) {
						
							// Display Confirmation
							FORM.studentID = qCheckStudent.studentID;
							FORM.hostID = qCheckStudent.hostID;
							FORM.subAction = 'displayConfirmation';
							
						}
					</cfscript>

                </cfloop>
            
            </cfif> <!--- VAL(qCheckStudent.recordcount) --->
            
			<cfscript>
                if ( NOT VAL(SESSION.TOUR.studentID) ) {
                    // Get all the missing items in a list
                    SESSION.formErrors.Add("No records were found based on the information you provided. Please verify the information you have submitted and try again.");
                }
            </cfscript>
            
		</cfif> <!--- NOT SESSION.formErrors.length() --->

    <!--- FORM SUBMITTED | IDENTITY CONFIRMED --->
	<cfelseif FORM.subAction EQ 'confirmed'>
    	
		<cfscript>
			// Store session information
			SESSION.informationID = APPLICATION.CFC.SESSION.InitSession(
				httpReferer = CGI.http_referer,
				entryPage = 'http://' & CGI.server_name & '/' & CGI.script_name,
				httpUserAgent = CGI.http_user_agent,
				queryString = CGI.query_string,						 
				remoteAddr = CGI.remote_addr,
				remoteHost = CGI.remote_host,
				remoteUser = CGI.remote_user,
				httpHost = CGI.http_host,
				https = CGI.https
			);
			
			// Set Session Variables
			APPLICATION.CFC.SESSION.setTripSessionVariables(
				isLoggedIn = 1,												
				studentID = FORM.studentID,
				hostID = FORM.hostid
			);
			
			// Go to confirmation
			Location('#CGI.SCRIPT_NAME#?action=preferences', 'no');
        </cfscript>

    <!--- FORM SUBMITTED | IDENTITY NOT CONFIRMED --->
    <cfelseif FORM.subAction EQ 'notConfirmed'>
		
        <cfscript>
			// Clear Session Variables and go back to Login Page / Keep Tour Information			
			APPLICATION.CFC.SESSION.setTripSessionVariables(
				isLoggedIn = 0,												
				studentID = 0,
				hostID = 0,
				applicationPaymentID = 0
			);
			
			// Go to Login Page
			location(CGI.SCRIPT_NAME & "?action=lookUpAccount", "no");			
		</cfscript>

	</cfif> <!--- FORM SUBMITTED --->

</cfsilent>

<script type="text/javascript">
	// Date of Birth Mask
	jQuery(function($){
					
	   $("#dob").mask("99/99/9999");
		
	});		
</script>

<style type="text/css">
<!--
	.whtMiddleTrips {		
		margin: 0px;
		height: auto;
		min-height: 720px;
		text-align: justify;
		padding:5px 0px 0px 0px;
		background-repeat: repeat-y;
		background-image: url(../images/whtBoxMiddle.png);
	}
-->
</style>

<cfoutput>

    <div class="whtMiddleTrips">    

        <div class="tripsTours">

			<!--- Include Trip Header --->
            <cfinclude template="_tripHeader.cfm">
			
            <table width="665px" border="0" align="center" cellpadding="2" cellspacing="0">                                          
                <tr>
                    <td>
                        <h3 align="Center">Sweet! Let's get you registered<cfif VAL(qGetTourDetails.recordcount)> to go on the #qGetTourDetails.tour_name# Tour</cfif>.</h3>
                    </td>
                </tr>
            </table>  
            
			<!--- FORM SUBMITTED | Look UP Account --->
            <cfswitch expression="#FORM.subAction#">
            	
                <!--- Display Confirmation Form --->
                <cfcase value="displayConfirmation">
                
					<h3 class="tripSectionTitle">Account Verification</h3>

                    <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" class="tripTableBorder">                
                        <tr class="blueRow">
                        	<td class="tripFormTitle" colspan="3">Please verify that this is you:</td>                     
                        </tr>                                
                        <tr>
                            <td rowspan="2" width="100px" style="padding-left:5px;"><img src="http://ise.exitsapplication.com/nsmg/uploadedfiles/web-students/#qGetStudentInfo.studentID#.jpg" height="150"/></td>
                            <td>
                                <span class="greyText">Name</span>
                                <br />
                                <span class="bigLabel">#Left(qGetStudentInfo.firstname, 1)#. #qGetStudentInfo.familylastname#</span>
                            </td>
                            <td valign="middle" rowspan="2">

                                <form action="#CGI.SCRIPT_NAME#?action=lookUpAccount" method="post">
                                    <input type="hidden" name="submitted" value="1" />
                                    <input type="hidden" name="subAction" value="confirmed">
                                    <input type="hidden" name="studentID" value="#FORM.studentID#">
                                    <input type="hidden" name="hostID" value="#FORM.hostID#">
                                    <input type="image" src="../images/buttons/Yesme.png" />
                                </form>
                                
                                <br />
                                
                                <form action="#CGI.SCRIPT_NAME#?action=lookUpAccount" method="post">
                                    <input type="hidden" name="submitted" value="1" />
                                    <input type="hidden" name="subAction" value="notConfirmed">
                                    <input type="image" src="../images/buttons/nome.png" />
                                </form>
                                
                                <br /><br />
                            </td>
                        </tr>
                        <tr>                            	
                            <Td valign="top"><span class="greyText">Country of Birth</span><br /><span class="bigLabel">#qGetStudentInfo.countryname#</span></td>
                        </tr>
                    </table>

                </cfcase>
				
                <!--- Display Look Up Form --->
                <cfdefaultcase>

                    <form action="#CGI.SCRIPT_NAME#?action=lookUpAccount" method="post">
                        <input type="hidden" name="submitted" value="1" />
                        <input type="hidden" name="subAction" value="lookUpStudent">
                        <input type="hidden" name="tourID" value="#qGetTourDetails.tour_id#">

						<!--- Display Form Errors --->
                        <gui:displayFormErrors 
                            formErrors="#SESSION.formErrors.GetCollection()#"
                            messageType="tripSection"
                        />


						<!--- Student Information --->
                        <h3 class="tripSectionTitle">Student Information</h3>

                        <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" class="tripTableBorder">
                            <tr class="blueRow">
                                <td class="tripFormTitle" width="30%">Student ID Number</td>
                                <td width="70%"><input type="text" name="studentID" class="smallField" value="#FORM.studentID#" maxlength="10"></td>
                            </tr>
                            <Tr>
                                <td class="tripFormTitle">Student Last Name</td>
                                <td><input type="text" name="familyLastName" class="largeField" value="#FORM.familyLastName#" maxlength="100"><br /></td>
                            </tr>
                            <tr bgcolor="##deeaf3"  >
                                <td class="tripFormTitle">Student Date of Birth</td>
                                <td>
                                	<input type="text" name="dob" id="dob"  class="smallField" value="#dateFormat(FORM.dob, 'mm/dd/yyyy')#">
                                	<em class="tripNotesRight">MM/DD/YYYY</em>
                                </td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td>
                                    <span class="required">* All fields are required in this section</span>
                                </td>
                            </tr> 
						</table>
                        
                        
						<!--- Host Family Information --->
                        <h3 class="tripSectionTitle">Host Family Information</h3>
                        
                        <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" class="tripTableBorder">							                                               
                            <tr class="blueRow">
                                <td class="tripFormTitle">Host Last Name</td>
                                <td><input type="text" name="hostLastName" value="#FORM.hostLastName#" class="largeField" maxlength="100"></td>
                            </tr>
                            <tr>
                                <td class="tripFormTitle">Host Email Address</td>
                                <td><input type="text" name="hostEmail" value="#FORM.hostEmail#" class="largeField" maxlength="100"></td>
                            </tr>
                            <tr class="blueRow">
                                <td class="tripFormTitle">Host City</td>
                                <td><input type="text" name="hostCity" value="#FORM.hostCity#" class="largeField" maxlength="100"></td>
                            </tr>
                            <tr>
                                <td class="tripFormTitle">Host Zip/Postal Code</td>
                                <td><input type="text" name="hostZip" value="#FORM.hostZip#" class="smallField" maxlength="15"></td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td>
                                    <span class="required">* At least two fields are required for this section</span>
                                </td>
                            </tr>                    
                        </table>

						<!--- Button --->
                        <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" class="tripTableButton">                                       
                            <tr class="blueRow">
                                <td colspan="2" align="center"><input type="image" src="../images/buttons/Next.png" width="89" height="33" /></td>
                            </tr>
                        </table>
                    
                    </form>
                
                </cfdefaultcase>            
            
            </cfswitch>
            
			<!--- Include Trip Footer --->
            <cfinclude template="_tripFooter.cfm">

        </div> <!-- tripsTours -->

    </div><!-- end whtMiddleTrips -->

</cfoutput>
