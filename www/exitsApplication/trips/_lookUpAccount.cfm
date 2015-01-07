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
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />	
	
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
            if ( NOT LEN(FORM.studentID) ) {
                SESSION.formErrors.Add("Please enter student ID");
            }
		
            if ( LEN(FORM.studentID) AND NOT IsNumeric(FORM.studentID) ) {
				FORM.studentID = '';
				// Get all the missing items in a list
				SESSION.formErrors.Add("Please enter a valid student ID (numbers only)");
            }
			
            if ( NOT LEN(FORM.familyLastName) ) {
                SESSION.formErrors.Add("Please enter last name");
            }
            
            if ( NOT LEN(FORM.dob) ) {
                SESSION.formErrors.Add("Please enter date of birth (mm/dd/yyyy)");
            }
            
            if ( LEN(FORM.dob) AND NOT IsDate(FORM.dob) ) {
				FORM.dob = '';
				// Get all the missing items in a list
				SESSION.formErrors.Add("Please enter a valid date of birth");
            }
		</cfscript>
        
        <cfif NOT SESSION.formErrors.length()>
        
			<!----Check to see if there is a student based on the info.---->
            <cfquery name="qCheckStudent" datasource="#APPLICATION.DSN.Source#">
                SELECT 
                	s.studentID,
                    s.hostID,
                    s.companyID
                FROM 
                	smg_students s
                WHERE 
                	s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                     
                <cfif VAL(FORM.studentID)>
                    AND 
                        s.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#TRIM(FORM.studentID)#">
                </cfif>
                
                <cfif LEN(FORM.familyLastName)>
                    AND 
                        s.familylastname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#TRIM(FORM.familyLastName)#%">
                </cfif>
                
                <cfif isDate(FORM.dob)>
                    AND  
                        s.dob = <cfqueryparam cfsqltype="cf_sql_date" value="#TRIM(FORM.dob)#"> 
                </cfif>
            </cfquery>

			<!--- Check PHP Student --->
            <cfquery name="qCheckPHPStudent" datasource="#APPLICATION.DSN.Source#">
                SELECT 
                    s.studentID,
                    <!--- PHP --->
                    php.companyID, 
                    php.hostID
                FROM 
                    smg_students s
                INNER JOIN 
                    php_students_in_program php ON php.studentID = s.studentID
                WHERE 
                    php.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                
                <cfif VAL(FORM.studentID)>
                    AND 
                        s.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#TRIM(FORM.studentID)#">
                </cfif>
                
                <cfif LEN(FORM.familyLastName)>
                    AND 
                        s.familylastname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#TRIM(FORM.familyLastName)#%">
                </cfif>
                
                <cfif isDate(FORM.dob)>
                    AND  
                        s.dob = <cfqueryparam cfsqltype="cf_sql_date" value="#TRIM(FORM.dob)#"> 
                </cfif>
            </cfquery>
			
            <cfscript>
				// Check ISE/CASE Student
				if ( VAL(qCheckStudent.recordcount) ) {
					
					// Display Confirmation
					FORM.studentID = qCheckStudent.studentID;
					FORM.hostID = qCheckStudent.hostID;
					FORM.companyID = qCheckStudent.companyID;
					FORM.subAction = 'displayConfirmation';
				
				// Check PHP Student
				} else if ( VAL(qCheckPHPStudent.recordcount) ) {

                    // Display Confirmation
                    FORM.studentID = qCheckPHPStudent.studentID;
                    FORM.hostID = qCheckPHPStudent.hostID;
                    FORM.companyID = qCheckPHPStudent.companyID;
                    FORM.subAction = 'displayConfirmation';
				
				// Not a ISE/CASE/PHP student
				} else {
					
					// Get all the missing items in a list
					SESSION.formErrors.Add("No records were found based on the information you provided. Please verify the information you have submitted and try again.");
					
				}
            </cfscript>
            
		</cfif> <!--- NOT SESSION.formErrors.length() --->


    <!--- FORM SUBMITTED | EXITS LOGIN --->
	<cfelseif FORM.subAction EQ 'exitsLogin'>

        <cfscript>
            if ( NOT LEN(FORM.exitsUsername) ) {
                SESSION.formErrors.Add("Please enter your EXITS username");
            }

            if ( LEN(FORM.exitsUsername) AND NOT IsValid("email", FORM.exitsUsername) ) {
                SESSION.formErrors.Add("Your EXITS username must be a valid email address");
            }

			if ( NOT LEN(FORM.exitsPassword) ) {
                SESSION.formErrors.Add("Please enter your EXITS password");
            }
		</cfscript>
        
        <cfif NOT SESSION.formErrors.length()>

			<!----Check to see if there is a student based on the info.---->
            <cfquery name="qLoginStudent" datasource="#APPLICATION.DSN.Source#">
                SELECT 
                	s.studentID,
                    s.hostID,
                    s.companyID
                FROM 
                	smg_students s
                WHERE 
                	s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                AND 
                    s.email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.exitsUsername)#">
                AND 
                    s.password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.exitsPassword)#">
            </cfquery>

            <cfscript>
				// Check if total has been reached, if yes check if male/female are allowed to register
			
				if ( qLoginStudent.recordCount ) {
					// Login Valid

					// Set Session Variables
					APPLICATION.CFC.SESSION.setTripSessionVariables(
						isLoggedIn = 1,												
						studentID = qLoginStudent.studentID,
						hostID = qLoginStudent.hostID
					);
					
					// Set Session Company Variables
					APPLICATION.CFC.SESSION.setCompanySessionVariable(companyID=qLoginStudent.companyID);
					
					// Go to confirmation
					Location('#CGI.SCRIPT_NAME#?action=preferences', 'no');

				} else {
					// Login Not Valid

					// Get all the missing items in a list
					SESSION.formErrors.Add("Your login is not valid, please try again or click on forgot login to have your password emailed to you.");

				}
			</cfscript>
		
        </cfif>


    <!--- FORM SUBMITTED | IDENTITY CONFIRMED --->
	<cfelseif FORM.subAction EQ 'confirmed'>
    	
		<cfscript>
			// Set Session Variables
			APPLICATION.CFC.SESSION.setTripSessionVariables(
				isLoggedIn = 1,												
				studentID = FORM.studentID,
				hostID = FORM.hostID
			);
			
			// Set Session Company Variables
			APPLICATION.CFC.SESSION.setCompanySessionVariable(companyID=FORM.companyID);
			
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

<cfoutput>

	<!--- Include Trip Header --->
    <cfinclude template="_breadCrumb.cfm">
    
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
                    <td rowspan="2" width="100px" style="padding-left:5px;"><img src="https://ise.exitsapplication.com/nsmg/uploadedfiles/web-students/#qGetStudentInfo.studentID#.jpg" height="150"/></td>
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
                            <input type="hidden" name="companyID" value="#FORM.companyID#">
                            <input type="image" src="extensions/images/Yesme.png" />
                        </form>
                        
                        <br />
                        
                        <form action="#CGI.SCRIPT_NAME#?action=lookUpAccount" method="post">
                            <input type="hidden" name="submitted" value="1" />
                            <input type="hidden" name="subAction" value="notConfirmed">
                            <input type="image" src="extensions/images/nome.png" />
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

            <table width="665px" border="0" align="center" cellpadding="2" cellspacing="0">                                          
                <tr>
                    <td>
                        <h3 align="Center">Let's get you registered<cfif VAL(qGetTourDetails.recordcount)> to go on the #qGetTourDetails.tour_name# Tour</cfif>.</h3>
                        <em class="tripSubTitle">Please look up your account below or login using your EXITS student application account.</em>
                    </td>
                </tr>
            </table>  

			<!--- Display Form Errors --->
            <gui:displayFormErrors 
                formErrors="#SESSION.formErrors.GetCollection()#"
                messageType="tripSection"
            />

            <form action="#CGI.SCRIPT_NAME#?action=lookUpAccount" method="post">
                <input type="hidden" name="submitted" value="1" />
                <input type="hidden" name="subAction" value="lookUpStudent">

                <!--- Student Information --->
                <h3 class="tripSectionTitle">Look Up Your Account</h3>
                
               
                <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" class="tripTableBorder">
                    <tr class="blueRow">
                        <td class="tripFormTitle" width="30%">Student ID Number <span class="required">*</span></td>
                        <td width="70%"><input type="text" name="studentID" class="smallField" value="#FORM.studentID#" maxlength="10"></td>
                    </tr>
                    <tr>
                        <td class="tripFormTitle">Student Last Name <span class="required">*</span></td>
                        <td><input type="text" name="familyLastName" class="largeField" value="#FORM.familyLastName#" maxlength="100"></td>
                    </tr>
                    <tr class="blueRow">
                        <td class="tripFormTitle">Student Date of Birth <span class="required">*</span></td>
                        <td>
                            <input type="text" name="dob" id="dob"  class="smallField" value="#dateFormat(FORM.dob, 'mm/dd/yyyy')#">
                            <em class="tripNotesRight">MM/DD/YYYY</em>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td><span class="required">* Required Fields</span></td>
                    </tr> 
                </table>
                
                <!--- Button --->
                <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" class="tripTableButton">                                       
                    <tr class="blueRow">
                        <td colspan="2" align="center"><input type="image" src="extensions/images/Next.png" width="89" height="33" /></td>
                    </tr>
                </table>
          
            </form>
            

            <form action="#CGI.SCRIPT_NAME#?action=lookUpAccount" method="post">
                <input type="hidden" name="submitted" value="1" />
                <input type="hidden" name="subAction" value="exitsLogin">

                <!--- Student Information --->
                <h3 class="tripSectionTitle">
                	<img src="extensions/images/exitsLogo.jpg" border="0" style="display:block;" />
                	Login using your EXITS Student Application Account
                </h3> 
						<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" class="tripTableBorder">
                    <tr class="blueRow">
                        <td class="tripFormTitle" width="30%">Username <span class="required">*</span></td>
                        <td width="70%"><input type="text" name="exitsUsername" class="largeField" value="#FORM.exitsUsername#" maxlength="100"></td>
                    </tr>
                    <tr>
                        <td class="tripFormTitle">Password <span class="required">*</span></td>
                        <td width="70%">
                        	<input type="password" name="exitsPassword" class="mediumField" value="#FORM.exitsPassword#" maxlength="100">
                            <em class="tripNotesRight"><a href="https://ise.exitsapplication.com/login.cfm?forgot=1" target="_blank">Forgot Login?</a></em>
                        </td>
                    </tr>
                    <tr class="blueRow">
                        <td>&nbsp;</td>
                        <td><span class="required">* Required Fields</span></td>
                    </tr> 
                </table>
                
                <!--- Button --->
                <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" class="tripTableButton">                                       
                    <tr class="blueRow">
                        <td colspan="2" align="center"><input type="image" src="extensions/images/Next.png" width="89" height="33" /></td>
                    </tr>
                </table>
           
            </form>
            
        </cfdefaultcase>            
    
    </cfswitch>

</cfoutput>
