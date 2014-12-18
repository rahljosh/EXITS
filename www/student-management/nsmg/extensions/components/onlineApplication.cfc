<!--- ------------------------------------------------------------------------- ----
	
	File:		onlineApplication.cfc
	Author:		Marcus Melo
	Date:		March 24, 2011
	Desc:		This holds the functions needed for the online application

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="onlineApplication"
	output="false" 
	hint="A collection of functions for the onlineApplication">


	<!--- Return the initialized Company object --->
	<cffunction name="Init" access="public" returntype="onlineApplication" output="false" hint="Returns the initialized onlineApplication object">
		
		<cfscript>
			// There is nothing really to initiate, so just return this
			return(this);
		</cfscript>
        
	</cffunction>


	<cffunction name="getCurrentApplicationStatus" access="public" returntype="query" output="false" hint="Returns current application status">
    	<cfargument name="studentID" hint="studentID Is required">

        <cfquery 
        	name="qGetCurrentApplicationStatus" 
            datasource="#APPLICATION.DSN#">
                SELECT 
                   ID,
                   studentID,
                   status,
                   approvedBy,
                   reason,
                   date 
                FROM 
                    smg_student_app_status
                WHERE 
                    studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">
                AND          
                    date = ( 
                                SELECT 
                                    max(date)
                                FROM 
                                    smg_student_app_status
                                WHERE 
                                    studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">
                    		)             
		</cfquery>

        <cfscript>
			return qGetCurrentApplicationStatus;
		</cfscript>
              
	</cffunction>


	<cffunction name="insertApplicationStatus" access="public" returntype="void" output="false" hint="Inserts application status">
    	<cfargument name="studentID" hint="studentID is required">
        <cfargument name="statusID" hint="programID is required">
        <cfargument name="approvedBy" hint="approvedBy is required">
              
        <cfquery 
			datasource="#APPLICATION.dsn#">
                INSERT INTO 
                	smg_student_app_status 
                (
                	studentID, 
                    status, 
                    approvedBy
                )
                VALUES (
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">, 
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.statusID#">, 
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.approvedBy#">
                )
		</cfquery>

	</cffunction>


	<cffunction name="setNextStatusID" access="public" returntype="numeric" output="false" hint="Returns the next approve/deny status ID">
    	<cfargument name="statusID" hint="Current status of the application. statusID Is required">
        <cfargument name="type" hint="approve/deny">

        <cfscript>
			var newStatusID = 0;
		
			// APPROVE
			if ( ARGUMENTS.TYPE EQ 'approve' ) {
				
				if ( ARGUMENTS.statusID EQ 2 ) {
					// ACTIVE APPLICATION
					newStatusID = 3;
				} else if ( ARGUMENTS.statusID EQ 3 OR ARGUMENTS.statusID EQ 4 ) {
					// SUBMITTED/DENIED BY BRANCH
					newStatusID = 5;
				} else if ( ARGUMENTS.statusID EQ 5 OR ARGUMENTS.statusID EQ 6 ) {
					// SUBMITTED/DENIED BY INTL. REP
					newStatusID = 7;
				} else if ( ARGUMENTS.statusID GTE 7 ) {
					// SUBMITTED TO SMG = 7 / RECEIVED = 8 / DENIED = 9 / ON HOLD = 10
					newStatusID = 11;
				}

			}
			// DENY
			
			return newStatusID;
		</cfscript>
              
	</cffunction>


	<cffunction name="approveStudentApplication" access="public" returntype="void" output="false" hint="Process and Approve an online application">
    	<cfargument name="studentID" hint="studentID is required">
        <cfargument name="statusID" hint="programID is required">
        <cfargument name="companyID" hint="companyID is required">
        <cfargument name="programID" default="0" hint="programID is not required">
        <cfargument name="regionID" default="0" hint="regionID is not required">
        <cfargument name="approvedBy" hint="approvedBy is required">
        <cfargument name="regionGuarantee" default="0" hint="regionGuarantee is not required">
        <cfargument name="stateGuarantee" default="0" hint="stateGuarantee is not required">
        <cfargument name="privateSchool" default="0" hint="privateSchool is not required">
    	<cfargument name="iffschool" default="0" hint="iffschool is not required">
        <cfargument name="aypenglish" default="0" hint="iffschool is not required">
        <cfargument name="directPlace" default="0" hint="iffschool is not required">
              
		<cfscript>
			// Stores Intl. Rep. and Student Email Addresses
			var vEmailList = '';
			
			// Get Student Information
			qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(studentID=ARGUMENTS.studentID);
			
			// Get Intl. Rep. Information
			qGetIntlRep = APPLICATION.CFC.USER.getUserByID(userID=qGetStudentInfo.intRep);

			// Get Assigned Company Information
			qGetCompanyInfo = APPLICATION.CFC.COMPANY.getCompanies(companyID=ARGUMENTS.companyID);

			// Insert Application Status
			insertApplicationStatus(
					studentID=ARGUMENTS.studentID,
					statusID=ARGUMENTS.statusID,
					approvedBy=ARGUMENTS.approvedBy
			);																		  
		</cfscript>

        <!--- Approve Application --->   
        <cfquery 
			datasource="#APPLICATION.dsn#">
                UPDATE 
                    smg_students 
                SET 
                    <!--- Make sure student is active --->
                    active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">,
                    cancelDate = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    cancelReason = <cfqueryparam cfsqltype="cf_sql_varchar" value="">,
                    <!--- Update Application Data --->
                    app_current_status = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.statusID#">, 
                    companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">, 
                    programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.programID#">, 
                    regionAssigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.regionID#">, 
                    entered_by = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.approvedBy#">,
                    dateapplication = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    regionalguarantee = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.regionGuarantee#">,
                    <Cfif ARGUMENTS.regionGuarantee gt 0>
                    regionguar = <cfqueryparam cfsqltype="cf_sql_varchar" value="yes">,
                    </Cfif>
                    state_guarantee = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.stateGuarantee#">,
                    direct_placement = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.directPlace#">,
                    iffschool = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.iffschool#">,
                    privateschool = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.privateSchool#">,
                    aypenglish = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.aypEnglish#">
                WHERE 
                    studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">
		</cfquery>
        
       <!--- Check if Application is Assigned to PHP --->
		<cfif ARGUMENTS.companyID EQ 6>
        	
            <!--- Insert PHP Application --->
            <cfquery 
                datasource="#APPLICATION.dsn#">
                    INSERT INTO 
                        php_students_in_program 
                    (
                        studentID, 
                        companyID, 
                        inputBy, 
                        active, 
                        datecreated
                    ) 
                    VALUES 
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">, 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">, 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.approvedBy#">, 
                        <cfqueryparam cfsqltype="cf_sql_bit" value="1">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    )		
			</cfquery>
            
		</cfif>
        
        <!--- Send Out Email --->
        <!---<cfscript>
			// Check if we have a valid intl. rep. email
			if ( IsValid("email", qGetIntlRep.email) ) {
				vEmailList = vEmailList & qGetIntlRep.email & ';' ; 
			}

			// Check if intl. rep. account is set to notify the students and if there is a valid student email
			if ( VAL(qGetIntlRep.congrats_email) AND IsValid("email", qGetStudentInfo.email) ) {
				// Send a copy to the student
				vEmailList = vEmailList & qGetStudentInfo.email & ';' ; 
			}
		</cfscript>
		
        <!--- We have at least one email address --->
        <cfif ARGUMENTS.statusID EQ 11 AND LEN(vEmailList)>
        
            <cfsavecontent variable="vEmailMessage">
                <cfoutput>
                    <table width="600px" cellspacing="0" cellpadding="0" style="border: 1px solid ##000000; margin-top:15px;">
                        <tr><td bgcolor="b5d66e"><img src="#CLIENT.exits_url#/nsmg/student_app/pics/EXITSbanner.jpg" width="600" heignt="75"></td></tr>
                        <tr>
                            <td>
                                <h2>Congratulations!</h2>
                                <p>#qGetStudentInfo.firstname# #qGetStudentInfo.familylastname#-</p>
                                <p>This email is to inform you that your application has been accepted and approved by #qGetCompanyInfo.companyName# in #qGetCompanyInfo.city#, #qGetCompanyInfo.state#.</p>
                                <p><em>What does this mean to you and what are the next steps?</em></p>
                                <p>
                                    You are now listed as available for placement in the United States and the region or state you chose if applicable. 
                                    Students are placed on a daily basis all over the country. All you have to do is wait to hear from us.
								</p>
                                <p>                                    
                                    You will receive an email and acceptance letter once you have been placed with a host family.
                                    You will also be able to see your host family profile when you log into <a href="#CLIENT.exits_url#">#CLIENT.exits_url#</a> after you have been placed.
                                </p> 
                            </td>
                        </tr>
                        
                    </table>                                    
				</cfoutput>                    
            </cfsavecontent>
                
            <cfinvoke component="nsmg.cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="#vEmailList#">
                <cfinvokeargument name="email_subject" value="#qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# ###qGetStudentInfo.studentID# - Exchange Application Approved">
                <cfinvokeargument name="email_message" value="#vEmailMessage#">
                <cfinvokeargument name="email_from" value="#qGetCompanyInfo.companyshort#-support@exitsapplication.com">
            </cfinvoke>
                
     	</cfif>--->
                  
	</cffunction>


</cfcomponent>