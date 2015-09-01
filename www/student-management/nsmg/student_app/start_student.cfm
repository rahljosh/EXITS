
<!--- ------------------------------------------------------------------------- ----
	
	File:		start_student.cfm
	Author:		Marcus Melo
	Date:		April 16, 2010
	Desc:		This creates an online application account

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <!--- Param Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.familyLastName" default="">
    <cfparam name="FORM.firstName" default="">
    <cfparam name="FORM.middleName" default="">
    <cfparam name="FORM.email1" default="">        
    <cfparam name="FORM.email2" default="">
    <cfparam name="FORM.phone" default="">
    <cfparam name="FORM.app_indicated_program" default="0">
    <cfparam name="FORM.app_canada_area" default="0">
    <cfparam name="FORM.app_additional_program" default="0">
    <cfparam name="FORM.internalprogram" default="0">
    <cfparam name="FORM.extdeadline" default="0">    
    <cfparam name="FORM.programID" default="0">  
   
    
    <!--- Declare Option Variable - Option 1 - Student fills out an application / Option 2 - Agent fills out an application for the student --->
	<cfparam name="option" default="1">

	<cfscript>
		// Create Structure to store errors
		Errors = StructNew();
		// Create Array to store error messages
		Errors.Messages = ArrayNew(1);
		
		// Default Application Days
		appDays = 15;
		// Updated from 30 to 90 days - Marcus Melo - 11/20/2009
		remainingDays = 90;
		
		// Get Canada Area Choice
		qGetCanadaAreaChoiceList = APPLICATION.CFC.LOOKUPTABLES.getApplicationLookUp(fieldKey='canadaAreaChoice');
	</cfscript>

	<!--- Queries --->
    <cfquery name="qGetMainOffice" datasource="#APPLICATION.DSN#">
        SELECT 
        	userid, 
        	intrepid
        FROM 
        	smg_users
        WHERE 
        	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
    </cfquery>    
    
    <cfquery name="qAppProgramList" datasource="#APPLICATION.DSN#">
        SELECT 
        	app_programID, 
            app_program, 
            app_type,
            companyID,
            country
        FROM 
        	smg_student_app_programs
        WHERE
        	isActive = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND
            companyID LIKE ( <cfqueryparam cfsqltype="cf_sql_varchar" value="%#CLIENT.companyID#%"> )
    </cfquery>

    <cfquery name="qAppPrograms" dbtype="query">
        SELECT 
        	app_programID, 
            app_program 
        FROM 
        	qAppProgramList
        WHERE 
        	app_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="regular">
    </cfquery>
     
    <cfquery name="qAppAddPrograms" dbtype="query">
        SELECT 
        	app_programID, 
            app_program 
        FROM 
        	qAppProgramList
        WHERE 
        	app_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="additional">
    </cfquery> 
    
    <cfquery name="qAppCanadaPrograms" dbtype="query">
        SELECT 
        	app_programID, 
            country
        FROM 
        	qAppProgramList
        WHERE 
        	country = <cfqueryparam cfsqltype="cf_sql_varchar" value="Canada">
    </cfquery> 
    
    <cfset canadaIDList = ValueList(qAppCanadaPrograms.app_programID)>
    
    <cfquery name="qAppIntlRep" datasource="#APPLICATION.DSN#">
        SELECT 
        	userid, 
            intrepid, 
            usertype
        FROM 
        	smg_users
        WHERE 
        	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#"> 
    </cfquery>

	<!--- FORM SUBMITTED --->
    <cfif FORM.submitted>
  
        <cfquery name="qCheckUsername" datasource="#APPLICATION.DSN#">
            SELECT 
                email
            FROM 
                smg_students
            WHERE 
                email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email1#">
        </cfquery>
          
  		<cfscript>
			// Data Validation
			if ( LEN(FORM.email1) AND qCheckUsername.recordcount ) {
				ArrayAppend(Errors.Messages, "The email address #FORM.email1# is alredy registered for another student account. 
							You must enter a different e-mail address in order to create an account for your student.");	
			}

			if ( NOT LEN(FORM.familyLastName) ) {
				ArrayAppend(Errors.Messages, "Please enter a family name.");
			}
			
			if ( NOT LEN(FORM.firstName) ) {
				ArrayAppend(Errors.Messages, "Please enter a first name.");
			}

			// Option 1 validation - Student Account requires a valid email address
			if ( option EQ 1 ) {
				
				if ( NOT IsValid("email", FORM.email1) ) {
					ArrayAppend(Errors.Messages, "Please enter a valid email address.");
					FORM.email1 = '';
					FORM.email2 = '';
				}
				
				if ( LEN(FORM.email1) AND FORM.email1 NEQ FORM.email2 ) {
					ArrayAppend(Errors.Messages, "Confirmation email address does not match.");
					FORM.email2 = '';
				}
				
			}

			if ( NOT VAL(FORM.app_indicated_program) ) {
				ArrayAppend(Errors.Messages, "Please select a program.");
			}
			
			// Not requiring Canada Area
			/***
			if ( ListFind(canadaIDList, FORM.app_indicated_program) AND NOT VAL(FORM.app_canada_area) ) {
				ArrayAppend(Errors.Messages, "Please select an area in Canada.");
			}
			***/
		</cfscript>
    
		<!--- Check if there are no errors --->
		<cfif NOT VAL(ArrayLen(Errors.Messages))>
        
        	<cfscript>
				// Set uniqueID
				uniqueID = createuuid();
				// Set Rand ID
				randid = RandRange(111111,999999);	
			
				// Set Application Status and Message
				if ( option EQ 2 ) {
					if ( CLIENT.usertype EQ 11 ) {
						// Branch filling out application
						currentStatus = 3;
						statusMessage = 'Intl. Branch filling out application';
					} else {
						// Intl. Rep filling out application
						currentStatus = 5;
						statusMessage = 'Intl. Representative filling out application';
					}
				} else { 
					// Student Filling Out
					currentStatus = 1;
					statusMessage = 'Student filling out application';
				}
				
				// Branch
				IF ( CLIENT.userType EQ 11 ) {
					setIntRepID = qGetMainOffice.intRepID;
					setBranchID = CLIENT.userID;
				// International Representative
				} else if ( CLIENT.userType EQ 8 ) {
					setIntRepID = CLIENT.userID;	
					setBranchID = 0;
				} else {
					setIntRepID = CLIENT.companyID;
					setBranchID = 0;
				}

				expiration_date = DateFORMat(DateAdd('d', extdeadline, FORM.expiration_date), 'yyyy-mm-dd') & ' ' & TimeFORMat(DateAdd('d', extdeadline, FORM.expiration_date), 'HH:mm:ss');
			</cfscript>

			<!--- Insert Student --->
            <cfquery datasource="#APPLICATION.DSN#">
                INSERT INTO 
                    smg_students 
                (
                    uniqueID, 
                    familylastname, 
                    firstname, 
                    middlename, 
                    email, 
                    phone, 
                    app_indicated_program, 
                    app_additional_program, 
                    programid,
                    app_canada_area,
                    randid, 
                    intrep, 
                    branchid,  
                    app_sent_student, 
                    app_current_status, 
                    <!--- Record Company ID for CASE, WEP, Canada and ESI --->
					<cfif ListFind("10,11,13,14,15", CLIENT.companyID)>
                        companyID,
                    </cfif>
                    application_expires
                )
                VALUES 
                (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#uniqueID#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(FORM.familylastname)#">, 
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(FORM.firstname)#">, 
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(FORM.middlename)#">, 
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email1#">, 
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.phone#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.app_indicated_program#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.app_additional_program#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.internalProgram#">, 
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.app_canada_area)#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#randid#">, 
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#setIntRepID#">, 
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#setBranchID#">, 
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(now())#">, 
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(currentStatus)#">, 
                    <!--- Record Company ID for CASE, WEP, Canada and ESI --->
                    <cfif ListFind("10,11,13,14,15", CLIENT.companyID)>
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">, 
                    </cfif>
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#expiration_date#">
                )
            </cfquery>
            
			<!--- Retrieve the students ID number --->
            <cfquery name="qGetStudent" datasource="#APPLICATION.DSN#">
                SELECT 
                    studentid, 
                    branchid, 
                    intrep
                FROM 
                    smg_students 
                WHERE 
                    uniqueID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uniqueID#">
            </cfquery>
        
	        <cfset CLIENT.studentid = qGetStudent.studentid>
        
			<!--- Insert App Status History --->
            <cfquery datasource="#APPLICATION.DSN#">
                INSERT INTO 
                	smg_student_app_status 
                (
                    studentid, 
                    status, 
                    date, 
                    reason,
                    approvedBy
                )
                VALUES 
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudent.studentid#">, 
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#currentStatus#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#statusMessage#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
                )
            </cfquery>
            
            <!--- Send email to student --->
            <cfif option EQ 1>
            
				<!--- Get Agent information --->
                <cfquery name="qIntlRepInfo" datasource="#APPLICATION.DSN#">
                    SELECT 
                        userID,
                        businessname, 
                        phone,
                        email,
                        studentcontactemail
                    FROM 
                        smg_users 
                    WHERE  
                    <cfif qGetStudent.branchid>
                        userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudent.branchid#">
                    <cfelse>
                        userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudent.intrep#">               
                    </cfif>
                </cfquery>
    			
                <cfoutput>
                
                    <cfsavecontent variable="email_message">
                        #FORM.firstname#-
                        <br><br>
                        An account has been created for you on the #CLIENT.companyname# EXITS system.  
                        Using EXITS you will be able to apply for your exchange program and view the status of your application as it is processed. 
                        <br><br>
                        You can start your application at any time and do not need to complete it all at once.
                        You can save your work at any time and return to the application when convenient.  
                        The first time you access EXITS you will create a username and password that will allow you to work 
                        on your application at any time. 
                        <br><br>
                        Your application will remain active until <strong>#expiration_date#</strong>.
                        You will need to contact #qIntlRepInfo.businessname# to re-activate your application if your application expires.
                        <br><br>
                        Please provide the information requested by the application and press the submit button when it is complete.
                        Once submitted, the application can no longer be edited.  
                        The completed application will be reviewed by your international representative and if accepted sent to a parnter organization.
                        The status of your application can be viewed by logging into the EXITS Login Portal. 
                        After your placement has been made, you will also be able to access your host family profile. 
                        (Host family profiles available only if the partner organization uses EXITS)
                        <br><br>
                        You are taking the first step in what will become one of the greatest experiences in your life!
                        <br><br>
                        Click the link below to start your application process.  
                        <br><br>
                        <a href="#CLIENT.exits_url#/nsmg/student_app/index.cfm?s=#uniqueid#">#CLIENT.exits_url#/nsmg/student_app/index.cfm?s=#uniqueid#</a>
                        <br><br>
                        You will need the following information to verify your account:<br>
                        *email address<br>
                        *this ID: #randid#
                        <br><br>
                        If you have any questions about the application or the information you need to submit, please contact your international representative:
                        <br><br>
                        #qIntlRepInfo.businessname#<br>
                        #qIntlRepInfo.phone#<br>
                        #qIntlRepInfo.studentcontactemail#<br><br>
                        
                        For technical issues with EXITS, submit questions to the support staff via the EXITS system.
                    </cfsavecontent>
        		
                </cfoutput>
                
                <cfinvoke component="nsmg.cfc.email" method="send_mail">
                    <cfinvokeargument name="email_to" value="#FORM.email1#">
                    <cfinvokeargument name="email_subject" value="EXITS - Online Student Application - Account Activation Required">
                    <cfinvokeargument name="email_message" value="#email_message#">
                    <cfinvokeargument name="email_from" value="#CLIENT.support_email#">
                </cfinvoke>
            
        	</cfif> <!--- Option 1 --->
			
        </cfif> <!--- NOT VAL(ArrayLen(Errors.Messages)) --->

    </cfif> <!--- FORM.submitted --->

</cfsilent>

<style>
	.requiredField {
		color:#F00;
		font-style:italic;
	}
</style>

<cfoutput>

<script type="text/javascript" language="JavaScript">
	<!--
	function formValidation() {
		if ( $("##email1").val() != $("##email2").val() ) {
			alert('The email addresses you have entered do not match. \n Please re-check and submit again.');
			return false;
		} else {
			return true;
		}
	}

	function displayCanada() {
		// Get canada list from the query
		canadaList = '#canadaIDList#';
		currentProgram = $("##app_indicated_program").val();

		if ( $.ListFind(canadaList, currentProgram, ',') ) {
			$(".canadaAreaDiv").fadeIn("slow");															
		} else {
			$("##app_canada_area").val(0);
			$(".canadaAreaDiv").fadeOut("slow");			
		}
	}

	$(document).ready(function() {
		displayCanada();
	});
	//-->
</script> 

<!--- Student created successfully - relocate user --->
<cfif FORM.submitted AND NOT VAL(ArrayLen(Errors.Messages))>

	<script language="JavaScript">
		<!-- 
		alert("You have successfully created an account for #FORM.firstname# #FORM.familylastname#. Thank You.");
		<cfif option EQ 1>
			location.replace("index.cfm?curdoc=initial_welcome");
		<cfelse>
			location.replace("student_app/rep_start_app.cfm");						
		</cfif>
		-->
	</script>

</cfif>

<!---Aplicant information---->
<table width=100% cellpadding="0" cellspacing="0" border="0" height="24">
	<tr valign="middle" height="24">
		<td height="24" width="13" background="pics/header_leftcap.gif">&nbsp;</td>
		<td width="26" background="pics/header_background.gif"><img src="pics/news.gif"></td>
		<td background="pics/header_background.gif"><h2>Applicant Information</h2></td>
		<td width="17" background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfform name="start_student" action="#cgi.SCRIPT_NAME#?#cgi.QUERY_STRING#" method="post">
	<input type="hidden" name="submitted" value="1" />
    <input type="hidden" name="option" value="#option#" />

    <table width="100%" border="0" cellpadding="2" cellspacing="0" align="center" class="section" style="padding-top:20px;">	
		
		<!--- Display Errors --->
        <cfif VAL(ArrayLen(Errors.Messages))>
            <tr>
                <td width="2%">&nbsp;</td>
                <td colspan="3" style="color:##FF0000; padding-bottom:20px; line-height:20px;">
                    <strong>*** Please review the following item(s): ***</strong> <br>
                    <cfloop from="1" to="#ArrayLen(Errors.Messages)#" index="i">
                    	#Errors.Messages[i]# <br>        	
                    </cfloop>
                </td>
                <td width="2%">&nbsp;</td>
            </tr>
        </cfif>	
        
        <tr>
            <td width="2%">&nbsp;</td>
            <td colspan="3">
                <cfif option EQ 2>
                    Please enter the basic information to create the students application.  This basic information is needed to set up the 
                    next screens where you will fill out the remainder of the students application. <br><br>
                    <strong> The student will not receive an automated email with account information.</strong><br><br>
                    Once you have completed the complete online application, you will have the option to notify the student by email
                    that their application has been submitted.  Students will need this account info if you want them to have access to 
                    their host family profile after they have been placed.
                    <br><br>
                <cfelse>
                    To start a students application, please fill out the following.  An email will be sent to the student
                    providing them a link to create an account and fill out an applilcation.  The student will have 30 days to 'activate'
                    their account. After that time, the account will expire and you will need to re-create an account for them to submit an application. <br><br>
                    You can always see the status of incoming apps under 'Incoming Apps' on your welcome page.   
                    <br><br>
                </cfif>
            </td>
            <td width="2%">&nbsp;</td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td colspan="3"><b>Student information</b></td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td><em>Family Name</em> <span class="requiredField">*</span></td>
            <td><em>First Name</em> <span class="requiredField">*</span></td>
            <td><em>Middle Name</em></td>	
            <td>&nbsp;</td>	
        </tr>
    
        <tr>
            <td>&nbsp;</td>
            <td valign="top"><cfinput type="text" name="familyLastName" value="#FORM.familyLastName#" maxlength="150" size="30" required="yes" message="Family name is required."></td>
            <td valign="top"><cfinput type="text" name="firstName" value="#FORM.firstName#" maxlength="150" size="30" required="yes" message="First name is required."></td>
            <td valign="top"><cfinput type="text" name="middleName" value="#FORM.middleName#" maxlength="150" size="30"></td>
            <td>&nbsp;</td>
        </tr>
        
        <!--- Student Account --->
        <cfif option EQ 1>
            <tr>
                <td>&nbsp;</td>
                <td><em>Email Address &nbsp; <font color="000099">* Username</font></em> <span class="requiredField">*</span></td>
                <td><em>Confirm Email Address</em> <span class="requiredField">*</span></td>
                <td><em>Phone Number</em></td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td><cfinput type="text" name="email1" id="email1" value="#FORM.email1#" maxlength="150" size="30" required="yes" message="Email address is required."></td>
                <td><cfinput type="text" name="email2" id="email2" value="#FORM.email2#" maxlength="150" size="30" required="yes" message="Confirmation email address is required."></td>
                <td><input type="text" name="phone" value="#FORM.phone#" size="30"></td>
                <td>&nbsp;</td>
            </tr>
        </cfif>
        
        <tr><td colspan="3">&nbsp;</td></tr>
        
        <tr>
            <td>&nbsp;</td>
            <td colspan="3"><b>Program information</b></td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td><em>Select Program Type</em> <span class="requiredField">*</span></td>
            <!--- Canada Areas - Only Available for Canada Programs --->
            <td>
                <div class="canadaAreaDiv" style="display:none">
	                <em>Please select an area in Canada</em>
                </div>
            </td>
            <td><em>Additional Programs</em></td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>
                <select name="app_indicated_program" id="app_indicated_program" onchange="displayCanada();" class="xLargeField">
                    <option value="0">To Be Defined</option>
                    <cfloop query="qAppPrograms">
                        <option value="#qAppPrograms.app_programID#" <cfif qAppPrograms.app_programID EQ FORM.app_indicated_program> selected="selected" </cfif> >#qAppPrograms.app_program#</option>
                    </cfloop>
                </select>
            </td>
            <!--- Canada Areas - Only Available for Canada Programs --->
            <td>
                <div class="canadaAreaDiv" style="display:none">
                    <select name="app_canada_area" id="app_canada_area" class="large">
                        <option value="0"></option>
                        <cfloop query="qGetCanadaAreaChoiceList">
                            <option value="#qGetCanadaAreaChoiceList.fieldID#" <cfif qGetCanadaAreaChoiceList.fieldID EQ FORM.app_canada_area> selected="selected" </cfif> >#qGetCanadaAreaChoiceList.name#</option>
                        </cfloop>
                    </select>	
				</div>
            </td>
            <td>
             <table>
                	<tr>
                    	<Td><input type="checkbox" name="selfPlacement" /></Td><td>Self Placement</td>
                    </tr>
                    <Tr>
                    	<Td><input type="checkbox" name="preAYP" /></Td><td>Pre - AYP English</td>
                    </tr>
                    <Tr>
                    	<Td><input type="checkbox" name="iff" /></Td><td>International Foreign Family</td>
                </table>
            </td>
            <td>&nbsp;</td>
        </tr>
          
           <tr>
            <td>&nbsp;</td>
            <td><em>Select Program</em> </td>
            <td></td>
            <td></td>
            </tr>
          <tr>
          	<td></td>
            <td>
                <cfselect
                  name="internalProgram" 
                  id="internalProgram"
                  value="programID"
                  display="programName"
                  selected="#FORM.programID#"
                  bindonload="yes"
                  class="xLargeField"
                  bind="cfc:nsmg.extensions.components.program.qGetActiveInternalPrograms({app_indicated_program})" />
            </td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td colspan="3"><b>Deadline</b></td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td></td>
            <td colspan="3">
                <b>Current Expiration: #DateFORMat(DateAdd('d','#appDays#','#now()#'), 'yyyy-mm-dd')# #TimeFORMat(DateAdd('d','#appDays#','#now()#'), 'HH:mm:ss')#
                <input type="hidden" name="expiration_date" value="#DateFORMat(DateAdd('d','#appDays#','#now()#'), 'yyyy-mm-dd')# #TimeFORMat(DateAdd('d','#appDays#','#now()#'), 'HH:mm:ss')#"></b>
                <br>Student has #appDays# days to fill out and submit application.
                <br>Extend Deadline by:
                <cfif remainingDays GT 1>
                    <select name="extdeadline">
                        <cfloop index="i" from="5" to="#remainingDays#" step="5">
                            <option value="#i#">#i#</option>
                        </cfloop>
                    </select>
                    days.
                <cfelse>
                    You can not extend the deadline.
                    <cfinput type="hidden" name="extdeadline" value="0">
                </cfif>
            </td>
            <Td></Td>
        </tr>
        <!---
        <tr><td></td>
            <td colspan=10>The system will not allow students to submit an application for approval after #deadline#.<br> Application must be submitted to SMG by #deadline# <br></td>
        </tr>
        --->
        <tr>
            <td>&nbsp;</td>
            <td colspan="3">
   			   <span class="requiredField">* Required Field</span> <br />
				
				<cfif option EQ 2>
                    <br>
                    <strong>From this point on, you will be accessing the student application as if you are the student. 
                    At any time you can click save and exit back to your regular welcome page. 
                    You can also get back into the application at any time.</strong><br>
                </cfif>
                <br>
                <div align="center"><cfinput type="submit" name="submit" value=" Start Application Process " onClick="return formValidation();"></div>
            </td>
            <td>&nbsp;</td>
        </tr>
    </table>

</cfform>

</cfoutput>

<!----footer of table---->
<table width=100% cellpadding="0" cellspacing="0" border="0">
	<tr valign="bottom">
		<td width="9" valign="top" height="12"><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width="9" valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>

</body>

</html>