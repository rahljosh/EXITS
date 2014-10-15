

<!--- ------------------------------------------------------------------------- ----
	
	File:		start_student.cfm
	Author:		Marcus Melo
	Date:		April 16, 2010
	Desc:		This creates an online application account

	Updated:  	

----- ------------------------------------------------------------------------- --->

<link rel="stylesheet" href="../linked/chosen/chosen.css">
<link type="text/css" rel="stylesheet" href="studentApp.css" />

<!----<cfdump var="#qTest4#">---->
<!--- Kill Extra Output --->
<!----
<cfsilent>
	---->
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
    
    <!---user allocations---->
    <cfquery name="userAllocations" datasource="#application.dsn#">
    SELECT 
    	a.augustAllocation, a.januaryAllocation, a.seasonid
    FROM 
    	smg_users_allocation a
    LEFT JOIN 
    	smg_seasons s on s.seasonid = a.seasonid
    WHERE 
    	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#"> 
    AND 
    	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
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
	<!----Get Available Programs based on types, etc---->
    <cfquery name="qAllAvailablePrograms" datasource="#APPLICATION.dsn#">
   SELECT 
			p.programID,
			p.programName,
            p.startDate,
            p.endDate,
            p.type,
			p.seasonid,
            p.companyid,
            p.fk_smg_student_app_programID,
						(SELECT count(studentid) as NoStudents
						 FROM smg_Students s
						 WHERE s.programID = p.programid
                   		 AND  s.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">)  as NoStudents,
                      (SELECT Month(startdate) as startMonth
						 FROM smg_programs
						 WHERE programID = p.programid
                   		)  as startMonth   
                        
        FROM 
        	smg_programs p
		
	
        WHERE
			
            p.applicationDeadline >= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
        <cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.publicHS, CLIENT.companyid)> 
        	AND ( p.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.publicHS#" list="yes"> )
			OR p.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.php#" list="yes"> ) )
        <cfelse>
            AND ( p.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
			OR p.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.php#" list="yes"> ) )
        </cfif>
		
       
		
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

			if ( NOT VAL(FORM.internalProgram) ) {
				ArrayAppend(Errors.Messages, "Please select a valid program. You must have an available allocation to select a program. ");
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
        	 <cfquery name="checkAllocation" dbtype="query">
           		select *
                from qAllAvailablePrograms
                where programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.internalProgram#">
            </cfquery>
            <cfif DateFormat(checkAllocation.startDate, 'm') is 1>
				<cfset remainingAllocation = #val(checkAllocation.januaryallocation)# - #checkAllocation.NoStudents#>
                <cfset programType = 'January'>
            <cfelseif DateFormat(checkAllocation.startDate, 'm') is 8>
                <cfset remainingAllocation = #val(checkAllocation.augustallocation)# - #checkAllocation.NoStudents#>
                <cfset programType = 'December'>
            </cfif>
            <cfif remainingAllocation eq 1>
            	<!----Insert message that allocation has been met.---->
                <cfquery datasource="#APPLICATION.dsn#">
                insert into smg_notifications (title, message, status, submitID, datePosted)
                						values('You have reached your allocation of  students.',
                                        	   'The allocation of students for #programType# programs durring the #checkAllocation.programName# season.
                                               Please contact Brian Hause bhause@iseusa.org to request additional allocations.','Contact Brian Hause',
                                               '1', <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">)
    
               </cfquery>
            </cfif>
            
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
					<cfif ListFind("10,11,13,14", CLIENT.companyID)>
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
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#checkAllocation.fk_smg_student_app_programID#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.app_additional_program#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.internalProgram#">, 
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.app_canada_area)#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#randid#">, 
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#setIntRepID#">, 
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#setBranchID#">, 
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(now())#">, 
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(currentStatus)#">, 
                    <!--- Record Company ID for CASE, WEP, Canada and ESI --->
                    <cfif ListFind("10,11,13,14", CLIENT.companyID)>
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">, 
                    </cfif>
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#expiration_date#">
                )
            </cfquery>
            
            <!----Check if agent has hit allocation limit, and post notification---->
            
           
            
            
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
<!----
</cfsilent>
---->
<style>
	.requiredField {
		color:#F00;
		font-style:italic;
		padding: 5px;
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
<cfform name="start_student" action="#cgi.SCRIPT_NAME#?#cgi.QUERY_STRING#" method="post">
	<input type="hidden" name="submitted" value="1" />
    <input type="hidden" name="option" value="#option#" />

    <table width="100%" border="0" cellpadding="2" cellspacing="0" align="center" id="formBox" class="section" style="padding-top:20px;">	
		
		<!--- Display Errors --->
        <cfif VAL(ArrayLen(Errors.Messages))>
            <tr>
        
                <td colspan="2" style="color:##FF0000; padding-bottom:20px; line-height:20px;">
                    <strong>*** Please review the following item(s): ***</strong> <br>
                    <cfloop from="1" to="#ArrayLen(Errors.Messages)#" index="i">
                    	#Errors.Messages[i]# <br>        	
                    </cfloop>
                </td>
            
            </tr>
        </cfif>	
        
        <tr>
            
            <td colspan="2">
                <cfif option EQ 2>
<p>Please enter the basic information to create the students application.  This basic information is needed to set up the next screens where you will fill out the remainder of the students application.</p>
<p><strong> The student will not receive an automated email with account information.</strong></p>
<p>Once you have completed the complete online application, you will have the option to notify the student by email that their application has been submitted.  Students will need this account info if you want them to have access to their host family profile after they have been placed.</p>
                <cfelse>
<h2>Start Application Process</h2>
<p>Login information will be sent to the student immedialty upon submitting this form. </p> 
<p>&nbsp;</p>  
                  
                </cfif>
            </td>
         
        </tr>
        <tr>
            
            <td><h3 style="color: ##0E5FAC;">Student Information</h3></td>
            <td><h3 style="color: ##0E5FAC;">Program Information</h3></td>
           
        </tr>

        <tr>
            <td valign="top"><input type="text" name="firstName" value="#FORM.firstName#" maxlength="150" size="30"  placeholder="First Name" style="height: 30px;">
            </td>
            <td >
     
            <select name="internalProgram" data-placeholder="Select a program..." style="width:275px" class="chosen-select"  >
           	 <option value=""></option>
           <cfloop query="qAppPrograms">
               <cfquery name="specificPrograms" dbtype="query">
				select *
                from qAllAvailablePrograms
                where fk_smg_student_app_programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#app_programID#">
               </cfquery> 
               
               
            
           
               <Cfquery name="programAllocation" dbtype="query">
               SELECT
                	augustAllocation, januaryAllocation
               FROM
               		userAllocations
               WHERE
               		seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(specificPrograms.seasonid)#">
               </Cfquery>
         
              				 <cfif DateFormat(specificPrograms.startDate, 'm') is 1>
                                <cfquery name="studentCount" dbtype="query">
                                   select sum(noStudents) as totalStudents
                                   from  qAllAvailablePrograms
                                   where seasonid = <cfqueryparam cfsqltype="cf_sql_integer" value="#specificPrograms.seasonid#"> 
                                   and startMonth = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                                   </cfquery>
                                                 
                            	<cfset remainingAllocation = #val(programAllocation.januaryallocation)# - #studentCount.totalStudents#>
                            <cfelseif DateFormat(specificPrograms.startDate, 'm') is 8>
                            	<cfquery name="studentCount" dbtype="query">
                                   select sum(noStudents) as totalStudents
                                   from  qAllAvailablePrograms
                                   where seasonid = <cfqueryparam cfsqltype="cf_sql_integer" value="#specificPrograms.seasonid#"> 
                                   and startMonth = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
                                   </cfquery>
                            	<cfset remainingAllocation = #val(programAllocation.augustallocation)# -  #studentCount.totalStudents#>
                            </cfif>
                            <cfif remainingAllocation lte 0 ><cfset remainingAllocation = 0></cfif>
                        
               		<optgroup label="#app_program# <cfif  ListFind (#APPLICATION.SETTINGS.COMPANYLIST.publicHS#, #specificPrograms.companyID#) > - #remainingAllocation# spots left </cfif>">
                    	  
						<cfif #specificPrograms.recordcount# eq 0>
                            <option value=0 style="color:##ccc;" disabled>no programs available</option>
                        <cfelse>
                            <cfloop query="specificPrograms">
                         
                           
							
							<!----17468E---->
                            
                            <cfif  ListFind (#APPLICATION.SETTINGS.COMPANYLIST.publicHS#, #companyID#) >
                                     
									<cfif val(remainingAllocation) lte 0>
                                     <option  style="color:##ccc;font-style: italic;" value="0"> 
                                    <cfelse>
                                      <option style="color:##090;font-weight:bold;" value=#programid# >
                                     </cfif>#programName#</option>
                             <cfelse>
                              	<option style="color:##090;font-weight:bold;" value=#programid# >#programName#</option>
                             </cfif>
                              
                            </cfloop>
                       </cfif>
             		</optgroup> 
             
		   </cfloop>
		   
           </select>
       
            </td>
        </tr>
        <tr>
            <td valign="top"><input type="text" name="middleName" value="#FORM.middleName#" maxlength="150" size="30" placeholder="Middle Name" style="height: 30px;"></td>
          
            <td valign="bottom"><em>Additional Optional Programs</em></td>
        </tr>
        <tr>
            
            <td valign="top"><input type="text" name="familyLastName" value="#FORM.familyLastName#" maxlength="150" size="30" placeholder="Family Name" style="height: 30px;"></td>
            <Td><input type="checkbox" name="selfPlacement" />
            <span class="formlabel">Self Placement</span></td>
        </tr>
        
        <!--- Student Account --->
        <cfif option EQ 1>

            <tr>
                <td><input type="text" name="email1" id="email1" value="#FORM.email1#" maxlength="150" size="30" Placeholder="Email Address" style="height: 30px;"></td>
                <Td><input type="checkbox" name="preAYP" />
                <span class="formlabel">Pre - AYP English</span></td>
            </tr>
            <tr>
                <td><input type="text" name="email2" id="email2" value="#FORM.email2#" maxlength="150" size="30" Placeholder="Confirm Email" style="height: 30px;"></td>
                <Td class="formlabel"><input type="checkbox" name="iff" />
               International Foreign Family</td>
               
               
            </tr>
        <cfelse>
             <tr>
                <td></Td><td class="formlabel"><input type="checkbox" name="preAYP" />Pre - AYP English</td>
            </tr>
            <tr>
                <td></td>
                <Td><input type="checkbox" name="iff" />
                <span class="formlabel">International Foreign Family</span></td>
               
               
            </tr>
        	
        </cfif>
        <tr>
        	<td></td>
            <td>
                <div class="canadaAreaDiv" style="display:none">
	                <em>Please select an area in Canada</em>
                </div>
            </td>
     	</tr>
        
       
     
        <tr>
          <td colspan="2"><p>&nbsp;</p>
                <p> This application will expire on:  <b>#DateFORMat(DateAdd('d','#appDays#','#now()#'), 'mmmm d, yyyy')# </b>.</p>
                  <p> 
                <input type="hidden" name="expiration_date" value="#DateFORMat(DateAdd('d','#appDays#','#now()#'), 'yyyy-mm-dd')# #TimeFORMat(DateAdd('d','#appDays#','#now()#'), 'HH:mm:ss')#">
              Extend deadline now by 
                <cfif remainingDays GT 1>
                    <select name="extdeadline">
                        <cfloop index="i" from="0" to="#remainingDays#" step="5">
                            <option value="#i#">#i#</option>
                        </cfloop>
                    </select>
                    days.
                <cfelse>
                    You can not extend the deadline.
                    <cfinput type="hidden" name="extdeadline" value="0">
                </cfif></p>
               <p><em><span style="color:##454647;font-size;font-size:12px"> By default we set an expiration of 15 days for applications.  You can always extend this expiration date up until the application deadline,  either now upon expiration of application.</span></em></p>
                 
            </td>
        </tr>
        <!---
        <tr><td></td>
            <td colspan=10>The system will not allow students to submit an application for approval after #deadline#.<br> Application must be submitted to SMG by #deadline# <br></td>
        </tr>
        --->
        <tr>
         <td colspan="2" align="center"><input type="image" name="submit" value=" Start Application Process " src="pics/start-application-button.png"  class="myButton">
         </td>
         </tr>
        <tr>
          <td colspan="2">
         
   			  
				
				<cfif option EQ 2>
                    <br>
                    <strong>From this point on, you will be accessing the student application as if you are the student. 
                    At any time you can click save and exit back to your regular welcome page. 
                    You can also get back into the application at any time.</strong><br>
                </cfif>
                <br>
               
            </td>
           
        </tr>
    </table>


</cfform>

</cfoutput>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js" type="text/javascript"></script>
  <script src="../linked/js/chosen.jquery.js" type="text/javascript"></script>
  <script src="../linked/js/prism.js" type="text/javascript" charset="utf-8"></script>
	  <script type="text/javascript">
    var config = {
      '.chosen-select' : {disable_search_threshold:100,allow_single_deselect: true,display_disabled_options: false},

    }
    for (var selector in config) {
      $(selector).chosen(config[selector]);
    }
  </script>



</body>
</html>