<!--- ------------------------------------------------------------------------- ----
	
	File:		candidate.cfc
	Author:		Marcus Melo
	Date:		October, 27 2009
	Desc:		This holds the functions needed for the user

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="candidate"
	output="false" 
	hint="A collection of functions for the candidate">


	<!--- Return the initialized candidate object --->
	<cffunction name="Init" access="public" returntype="candidate" output="false" hint="Returns the initialized candidate object">
		
		<cfscript>
			// There is nothing really to initiate, so just return this
			return(this);
		</cfscript>
        
	</cffunction>


	<!--- Set Candidate Session Variables --->
	<cffunction name="setCandidateSession" access="public" returntype="void" hint="Set candidate SESSION variables" output="no">
		<cfargument name="candidateID" type="numeric" default="0">
        <cfargument name="doLogin" type="numeric" default="1">
        <cfargument name="updateDateLastLoggedIn" type="numeric" default="0">
        
        <cfscript>
			if ( VAL(ARGUMENTS.candidateID) ) {

				// Set Logged In Flag
				if ( VAL(ARGUMENTS.doLogin) ) {
					SESSION.CANDIDATE.isLoggedIn = 1;
				} else {
					SESSION.CANDIDATE.isLoggedIn = 0;
				}
				
				// Get Candidate Information
				qGetCandidateInfo = getCandidateByID(candidateID=ARGUMENTS.candidateID);
				
				// Set candidate session variables 
				SESSION.CANDIDATE.ID = qGetCandidateInfo.candidateID;
				SESSION.CANDIDATE.companyID = qGetCandidateInfo.companyID;
				SESSION.CANDIDATE.firstName = qGetCandidateInfo.firstName;
				SESSION.CANDIDATE.lastName = qGetCandidateInfo.lastName;
				SESSION.CANDIDATE.dateLastLoggedIn = qGetCandidateInfo.dateLastLoggedIn;
				SESSION.CANDIDATE.applicationStatusID = qGetCandidateInfo.applicationStatusID;
				SESSION.CANDIDATE.email = qGetCandidateInfo.email;
				
				SESSION.CANDIDATE.isOfficeApplication = APPLICATION.CFC.ONLINEAPP.isOfficeApplication(foreignTable=APPLICATION.foreignTable, foreignID=ARGUMENTS.candidateID);
									
				// set up upload files path
				SESSION.CANDIDATE.myUploadFolder = APPLICATION.PATH.uploadDocumentCandidate & ARGUMENTS.candidateID & '/';
				// Make sure folder exists
				APPLICATION.CFC.DOCUMENT.createFolder(APPLICATION.CFC.CANDIDATE.getCandidateSession().myUploadFolder);
				
				// Set student SESSION complete
				stCheckSession1 = checkCandidateRequiredFields(candidateID=ARGUMENTS.candidateID, sectionName='section1');
				SESSION.CANDIDATE.isSection1Complete = stCheckSession1.isComplete;
				SESSION.CANDIDATE.section1FieldList = stCheckSession1.fieldList;
				
				stCheckSession2 = checkCandidateRequiredFields(candidateID=ARGUMENTS.candidateID, sectionName='section2');
				SESSION.CANDIDATE.isSection2Complete = stCheckSession2.isComplete;
				SESSION.CANDIDATE.section2FieldList =  stCheckSession2.fieldList;

				stCheckSession3 = checkCandidateRequiredFields(candidateID=ARGUMENTS.candidateID, sectionName='section3');
				SESSION.CANDIDATE.isSection3Complete = stCheckSession3.isComplete;
				SESSION.CANDIDATE.section3FieldList = stCheckSession3.fieldList;

				if ( SESSION.CANDIDATE.isSection1Complete AND SESSION.CANDIDATE.isSection2Complete AND SESSION.CANDIDATE.isSection3Complete ) {
					SESSION.CANDIDATE.isApplicationComplete = 1;
				} else {
					SESSION.CANDIDATE.isApplicationComplete = 0;
				}				
				
				// Set Intl Rep ID / Branch ID / Intl Rep/Branch Name
				SESSION.CANDIDATE.intlRepID = qGetCandidateInfo.intRep;
				SESSION.CANDIDATE.branchID = qGetCandidateInfo.branchID;
				if ( VAL(qGetCandidateInfo.branchID) ) {
					SESSION.CANDIDATE.intlRepName = APPLICATION.CFC.USER.getUserByID(userID=qGetCandidateInfo.branchID).businessName;
				} else {
					SESSION.CANDIDATE.intlRepName = APPLICATION.CFC.USER.getUserByID(userID=qGetCandidateInfo.intRep).businessName;
				}
				
				// Set Application as readOnly
				if ( qGetCandidateInfo.applicationStatusID EQ 1 ) {
					// Issued Application - ReadOnly
					SESSION.CANDIDATE.isReadOnly = 1;
				
				} else if ( CLIENT.loginType NEQ 'user' AND VAL(qGetCandidateInfo.branchID) AND NOT ListFind("1,2,4", qGetCandidateInfo.applicationStatusID) ) {
					// Candidate logged in / there is a branch / application submitted
					SESSION.CANDIDATE.isReadOnly = 1;
				
				} else if ( CLIENT.loginType NEQ 'user' AND NOT ListFind("1,2,4,6", qGetCandidateInfo.applicationStatusID) ) {
					// Candidate logged / no branch / application submitted
					SESSION.CANDIDATE.isReadOnly = 1;
				
				} else if ( CLIENT.userID EQ qGetCandidateInfo.branchID AND NOT ListFind("1,2,3,4,6", qGetCandidateInfo.applicationStatusID) ) {
					// Branch logged in and application submitted
					SESSION.CANDIDATE.isReadOnly = 1;
				
				} else if ( CLIENT.userID EQ qGetCandidateInfo.intRep AND NOT ListFind("1,2,3,4,5,6,9", qGetCandidateInfo.applicationStatusID) ) {
					// Intl. Rep. logged in and application submitted
					SESSION.CANDIDATE.isReadOnly = 1;
				
				} else if ( VAL(CLIENT.userType) AND ListFind("1,2,3,4", CLIENT.userType) AND NOT ListFind("7,8,10,11", qGetCandidateInfo.applicationStatusID) ) {
					// Office logged in and application not submitted
					SESSION.CANDIDATE.isReadOnly = 1;				
				
				} else {
					// Application can be edited
					SESSION.CANDIDATE.isReadOnly = 0;
				}
				
			}
		</cfscript>
        
	</cffunction>


	<cffunction name="setCandidateSessionRemote" access="remote" returntype="void" hint="Set candidate SESSION variables" output="no">
		<cfargument name="candidateID" type="numeric" default="0">
        <cfargument name="updateDateLastLoggedIn" type="numeric" default="0">
        
        <cfscript>
			// Calls setCandidateSession
			setCandidateSession(
				candidateID=ARGUMENTS.candidateID,
				updateDateLastLoggedIn=ARGUMENTS.updateDateLastLoggedIn
			);
		</cfscript>
        
	</cffunction>


    <!--- Get Candidate Session Variables --->
	<cffunction name="getCandidateSession" access="public" returntype="struct" hint="Get candidate SESSION variables" output="no">

        <cfscript>
			return SESSION.CANDIDATE;
		</cfscript>
        
	</cffunction>


	<!--- Get Current Candidate from SESSION --->
	<cffunction name="getCandidateID" access="public" returntype="numeric" hint="Get candidate ID from session. Returns 0 if it's not found." output="no">
        
        <cftry>
	        <cfparam name="SESSION.CANDIDATE.ID" type="numeric" default="0">
            <cfcatch type="any">
                <cfset SESSION.CANDIDATE.ID = 0>
            </cfcatch>
        </cftry>

		<cfscript>
			if (VAL(SESSION.CANDIDATE.ID)) {
				// return CandidateID 
				return SESSION.CANDIDATE.ID;
			} else {
				// CandidateID not found
				return 0;
			}
		</cfscript>
        
	</cffunction>


	<cffunction name="getCandidateByID" access="public" returntype="query" output="false" hint="Gets a candidate by candidateID or uniqueID">
    	<cfargument name="candidateID" default="0" hint="candidateID is not required">
        <cfargument name="uniqueID" default="" hint="uniqueID is not required">
              
        <cfquery 
			name="qGetCandidateByID" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
					*
                FROM 
                    extra_candidates
                WHERE
                	1 = 1
					
				<cfif VAL(ARGUMENTS.candidateID)>
                    AND
                        candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#TRIM(ARGUMENTS.candidateID)#">
                </cfif>
                
                <cfif LEN(ARGUMENTS.uniqueID)>
                    AND
                        uniqueID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.uniqueID)#">
                </cfif>
		</cfquery>
		   
		<cfreturn qGetCandidateByID>
	</cffunction>


	<!--- Update Candidate --->
	<cffunction name="updateCandidate" access="public" returntype="void" output="false" hint="Update Candidate Information">
		<cfargument name="candidateID" required="yes" hint="Candidate ID" />
		<cfargument name="lastName" default="" hint="Candidate Last Name">
        <cfargument name="firstName" default="" hint="Candidate First Name">
        <cfargument name="middleName" default="" hint="Candidate Middle Name">
        <cfargument name="sex" default="" hint="Candidate sex">
        <cfargument name="dob" default="" hint="Candidate Date of Birth">
        <cfargument name="birth_city" default="" hint="Candidate City of Birth">
        <cfargument name="birth_country" default="" hint="Candidate Country of Birth">
        <cfargument name="residence_country" default="" hint="Candidate Country of Residence">
        <cfargument name="citizen_country" default="" hint="Candidate Country of Citizenship">
        <cfargument name="home_address" default="" hint="Candidate Home Address">
        <cfargument name="home_city" default="" hint="Candidate Home City">
        <cfargument name="home_country" default="" hint="Candidate Home Country">
        <cfargument name="home_zip" default="" hint="Candidate Home Zip">
        <cfargument name="home_phone" default="" hint="Candidate Home Phone">
        <cfargument name="email" default="" hint="Email Address">
        <cfargument name="passport_number" default="" hint="Candidate Passport Number">
        <cfargument name="emergency_name" default="" hint="Candidate Emergency Name">
        <cfargument name="emergency_phone" default="" hint="Candidate Emergency Phone">
        <cfargument name="wat_vacation_start" default="" hint="Start of Official Vacation">
        <cfargument name="wat_vacation_end" default="" hint="End of Official Vacation">
        <cfargument name="startDate" default="" hint="Program Start Date">
        <cfargument name="endDate" default="" hint="Program End Date">
        <cfargument name="wat_placement" default="" hint="Program Option">
        <cfargument name="wat_participation" default="" hint="Number of participations in program">
        <cfargument name="ssn" default="" hint="Social Security Number">

		<cfquery 
			datasource="#APPLICATION.DSN.Source#">
				UPDATE
                	extra_candidates
                SET
                    lastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.lastName))#">,  
                    firstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.firstName))#">,
                    middleName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.middleName))#">,                    
                    sex = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.sex)#">,
                    dob = <cfqueryparam cfsqltype="cf_sql_date" value="#TRIM(ARGUMENTS.dob)#" null="#NOT IsDate(ARGUMENTS.dob)#">,
                    birth_city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.birth_city))#">,
                    birth_country = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.birth_country)#">,
                    residence_country = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.residence_country)#">,
                    citizen_country = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.citizen_country)#">,
                    home_address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.home_address))#">,
                    home_city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.home_city))#">,
                    home_country = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.home_country)#">,
                    home_zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.home_zip))#">,
                    home_phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.home_phone))#">,
                    email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.email))#">,
                    passport_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.passport_number))#">,
                    emergency_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.emergency_name))#">,
                    emergency_phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.emergency_phone))#">,
                    wat_vacation_start = <cfqueryparam cfsqltype="cf_sql_date" value="#TRIM(ARGUMENTS.wat_vacation_start)#" null="#NOT IsDate(ARGUMENTS.wat_vacation_start)#">,
                    wat_vacation_end = <cfqueryparam cfsqltype="cf_sql_date" value="#TRIM(ARGUMENTS.wat_vacation_end)#" null="#NOT IsDate(ARGUMENTS.wat_vacation_end)#">,
                    startDate = <cfqueryparam cfsqltype="cf_sql_date" value="#TRIM(ARGUMENTS.startDate)#" null="#NOT IsDate(ARGUMENTS.startDate)#">,
                    endDate = <cfqueryparam cfsqltype="cf_sql_date" value="#TRIM(ARGUMENTS.endDate)#" null="#NOT IsDate(ARGUMENTS.endDate)#">,
                    wat_placement = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.wat_placement))#">,
                    <cfif LEN(ARGUMENTS.wat_participation)>
                    	wat_participation = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.wat_participation#">,
                    </cfif>
                    ssn = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.ssn))#">
				WHERE
	                candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.candidateID)#">
		</cfquery>
		
	</cffunction>


	<!--- Update Application Status --->
	<cffunction name="updateApplicationStatusID" access="public" returntype="void" output="false" hint="Update Candidate Information">
		<cfargument name="candidateID" required="yes" hint="candidate ID" />
        <cfargument name="applicationStatusID" required="yes" hint="Application Status ID is required.">
			
		<cfquery 
			datasource="#APPLICATION.DSN.Source#">
				UPDATE
                	extra_candidates
                SET
                    applicationStatusID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.applicationStatusID#">
				WHERE
	                candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.ID)#">
		</cfquery>
		
	</cffunction>


	<!--- Delete Candidate --->
	<cffunction name="deleteCandidate" access="public" returntype="void" output="false" hint="Sets a candidate as deleted">
		<cfargument name="candidateID" required="yes" hint="candidate ID" />
			
		<cfquery 
			datasource="#APPLICATION.DSN.Source#">
				UPDATE
                	extra_candidates
                SET
                    isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
				WHERE
	                candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.candidateID)#">
		</cfquery>
		
	</cffunction>


	<!--- Check Login --->
	<cffunction name="authenticateCandidate" access="public" returntype="query" output="false" hint="Check candidate credentials">
		<cfargument name="email" required="yes" hint="Email Address" />
		<cfargument name="password" required="yes" hint="Password" />		

		<cfquery 
			name="qAuthenticateCandidate" 
			datasource="#APPLICATION.DSN.Source#">
				SELECT
					candidateID,
                    companyID, 
                    firstName,
                    lastName,                    
                    email,
                    password
				FROM
					extra_candidates
				WHERE
                    email  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.email))#">
                AND 
    	            password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.password))#">
				AND
					status = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                AND
                	applicationStatusID > <cfqueryparam cfsqltype="cf_sql_integer" value="1">
				<!---
                AND    
                   	isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">					
				--->
		</cfquery>
		
		<cfreturn qAuthenticateCandidate /> 
	</cffunction>


	<cffunction name="doesAccountExist" access="public" returntype="numeric" output="false" hint="Returns 1 if email is already registered in the system.">
    	<cfargument name="email" hint="email is required">
        <cfargument name="candidateID" default="0" hint="candidateID is not required">
              
        <cfquery 
			name="qDoesAccountExist" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
					candidateID
                FROM 
                    extra_candidates
                WHERE
                    email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.email#">

                <cfif VAL(ARGUMENTS.candidateID)>
                    AND
                        candidateID != <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.candidateID#">
                </cfif>
		</cfquery>
		
        <cfscript>
			if ( NOT LEN(ARGUMENTS.email) ) {
				return 0;
			} else if ( qDoesAccountExist.recordCount ) {
				return 1;
			} else {
				return 0;
			}
		</cfscript>
	</cffunction>


	<cffunction name="checkEmail" access="public" returntype="query" output="false" hint="Check if email exists - Forgot password">
    	<cfargument name="email" hint="email is required">
        <cfargument name="candidateID" default="0" hint="candidateID is not required">
              
        <cfquery 
			name="qCheckEmail" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
					candidateID,
                    applicationStatusID,
                    firstName,
                    lastName,                    
                    email,
                    password                    
                FROM 
                    extra_candidates
                WHERE
                    email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.email#">
				AND	
                	active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                <cfif VAL(ARGUMENTS.candidateID)>
                    AND
                        candidateID != <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.candidateID#">
                </cfif>
		</cfquery>
		
        <cfscript>
			return qCheckEmail;
		</cfscript>
	</cffunction>

	
    <!--- Create Online Application Account --->
	<cffunction name="createApplication" access="public" returntype="void" output="false" hint="Inserts a new candidate. Returns candidate ID.">
		<cfargument name="type" type="string" required="yes" hint="Type: Candidate or Office" />
        <cfargument name="companyID" type="numeric" required="yes" hint="companyID" />	
        <cfargument name="userType" type="numeric" required="yes" hint="userType" />
        <cfargument name="intlRepID" type="numeric" required="yes" hint="intlRepID" />
        <cfargument name="branchID" type="numeric" required="yes" hint="branchID" />
        <cfargument name="firstName" type="string" required="yes" hint="First Name" />
        <cfargument name="middleName"  type="string"required="yes" hint="Middle Name" />		
        <cfargument name="lastName" type="string" required="yes" hint="Last Name" />	
        <cfargument name="gender" type="string" required="yes" hint="Gender" />			
		<cfargument name="email" type="string" default="" hint="Email" />	
        
        <cfscript>
			var applicationStatusID = 1;
			var setPassword = '';		

			// Get who is submitting the application
			var submittedBy = APPLICATION.CFC.ONLINEAPP.whoIsSubmittingApplication();

			// Check if we need to create an account
			if ( ARGUMENTS.type EQ 'Candidate' ) {
			
				setPassword = APPLICATION.CFC.onlineApp.generatePassword();	
			
			// Set Application Status Based on who is creating the application
			} else if ( ARGUMENTS.type EQ 'Office') {
				
				
				if ( ARGUMENTS.userType EQ 8 ) {
					// Intl. Rep.
					applicationStatusID = 5;
				} else if ( ARGUMENTS.userType EQ 11 ) {
					// Branch
					applicationStatusID = 3;
				}
			
			}
		</cfscript>

		<cfquery 
            result="newRecord"
			datasource="#APPLICATION.DSN.Source#">
				INSERT INTO
					extra_candidates
				(                    
                    companyID,
                    uniqueID,
                    applicationStatusID,
                    intRep,
                    branchID, 
                    status,                   
                    firstName,
                    middleName,
                    lastName,  
                    sex,                  
                    email,
                    password,
                    entryDate,                    
                    dateCreated
				)
                VALUES
                (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateUUID()#">,                    
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#applicationStatusID#">,	
					<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.intlRepID#">,	
					<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.branchID#">,	
                    <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.firstName))#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.middleName))#">,	
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.lastName))#">,		
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.gender#">,		
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.email))#">,	
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#setPassword#">,		
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                )                    
		</cfquery>
		
        <cfscript>
			// Email the candidate
			if ( ARGUMENTS.type EQ 'Candidate' ) {

				APPLICATION.CFC.EMAIL.sendEmail(
					emailFrom=APPLICATION.EMAIL.contactUs,
					emailTo=APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.email)),
					emailTemplate='newAccount',
					candidateID=newRecord.GENERATED_KEY,
					companyID=ARGUMENTS.companyID
				);
	
			}
			
			// Insert History
			APPLICATION.CFC.ONLINEAPP.insertApplicationHistory(
				applicationID=APPLICATION.applicationID,											   
				applicationStatusID=applicationStatusID,
				foreignTable=APPLICATION.foreignTable,
				foreignID=newRecord.GENERATED_KEY,
				submittedByForeignTable=submittedBy.foreignTable,
				submittedByforeignID=submittedBy.foreignID
				//comments=APPLICATION.CFC.ONLINEAPP.getApplicationStatusByID(applicationStatusID).description
			);
		</cfscript>

	</cffunction>


 	<!--- Update Logged In Date --->
 	<cffunction name="updateLoggedInDate" access="public" returntype="void" output="false" hint="Update Candidate last logged in date">
		<cfargument name="candidateID" required="yes" hint="candidate ID" />

		<cfquery 
			datasource="#APPLICATION.DSN.Source#">
				UPDATE 
                	extra_candidates
                SET
                	dateLastLoggedIn =  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				WHERE
                	candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.candidateID#">
		</cfquery>
		
	</cffunction>


	<!--- Update Candidate Email --->
	<cffunction name="updateEmail" access="public" returntype="void" output="false" hint="Update Candidate Email">
		<cfargument name="candidateID" required="yes" hint="Candidate ID" />
		<cfargument name="email" required="yes" hint="Email Address / Username">

		<cfquery 
			datasource="#APPLICATION.DSN.Source#">
				UPDATE
                	extra_candidates
                SET
                    email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.email))#">
				WHERE
	                candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.candidateID)#">
		</cfquery>
		
	</cffunction>
    
    
    <!--- Update Candidate Password --->
	<cffunction name="updatePassword" access="public" returntype="void" output="false" hint="Update Candidate Password">
		<cfargument name="candidateID" required="yes" hint="Candidate ID" />
        <cfargument name="password" required="yes" hint="Password">

		<cfquery 
			datasource="#APPLICATION.DSN.Source#">
				UPDATE
                	extra_candidates
                SET
                    password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.password))#">
				WHERE
	                candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.candidateID)#">
		</cfquery>

	</cffunction>


	<!--- Update Candidate Application Status --->
	<cffunction name="updateApplicationStatus" access="public" returntype="void" output="false" hint="Update application status and record into the history">
        <cfargument name="candidateID" type="numeric" required="yes" hint="CandidateID is required" />
        <cfargument name="applicationStatusID" type="numeric" required="yes" hint="CandidateID is required" />	

		<cfquery 
			datasource="#APPLICATION.DSN.Source#">
				UPDATE
					extra_candidates
				SET
                	applicationStatusID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.applicationStatusID#">
				WHERE
                	candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.candidateID#">
		</cfquery>
		
	</cffunction>


	<!--- Get Total of Online Applications --->
	<cffunction name="getTotalByStatus" access="public" returntype="query" output="false" hint="Returns total of applications grouped by status">
    	<cfargument name="intRep" type="numeric" default="0" hint="International Representative is not required">
        <cfargument name="applicationStatusID" type="numeric" default="0" hint="applicationStatusID is not required">

        <cfquery 
			name="qGetTotalByStatus" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT 
                    aps.statusID,
                    count(candidateID) AS total              
                FROM 
                    applicationStatus aps               
                LEFT OUTER JOIN                
                    extra_candidates ec ON aps.StatusID = ec.applicationStatusID 
                    	AND 
                        	ec.status = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                    	AND 
                        	ec.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                        <cfif VAL(ARGUMENTS.intRep)>
                        AND
                        	ec.intRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.intRep#">
                		</cfif>
                WHERE            
                    aps.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">        

				<cfif VAL(ARGUMENTS.applicationStatusID)>
                	AND
                    	aps.statusID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.applicationStatusID#">
                </cfif>                
                
                GROUP BY            
                	statusID                                   
                ORDER BY            
                	aps.statusID  
		</cfquery>
		   
		<cfreturn qGetTotalByStatus>
    </cffunction>
  
  
	<cffunction name="getApplicationListbyStatusID" access="public" returntype="query" output="false" hint="Returns a list of candidates by statusID">
    	<cfargument name="applicationStatusID" type="numeric" default="0" hint="applicationStatusID is not required">
        <cfargument name="intRep" type="numeric" default="0" hint="International Representative is not required">
		
        <cfquery 
			name="qGetApplicationListbyStatusID" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT DISTINCT
                    c.candidateID,
                    c.applicationStatusID,
                    c.uniqueID,
                    c.firstName,
                    c.lastName,
                    c.sex,
                    c.email,
                    c.password,
                    u.businessName,
                    branch.businessName as branchName,
                    ast.dateCreated
                FROM 
                    extra_candidates c
                INNER JOIN	
                	smg_users u ON u.userID = c.intRep
                LEFT OUTER JOIN                
                      applicationStatusJn ast ON ast.foreignID = c.candidateID
                      AND
                         ast.foreignTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.foreignTable#"> 
					  AND 
                    	ast.applicationStatusID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.applicationStatusID#">                                              
				LEFT OUTER JOIN 
        			smg_users branch ON branch.userid = c.branchid                
                WHERE            
                    c.status = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
				AND
					c.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                AND 
                    c.applicationStatusID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.applicationStatusID#"> 
                <cfif VAL(ARGUMENTS.intRep)>
                	AND	
                    	c.intRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.intRep#">
                </cfif>
                GROUP BY
                	c.candidateID
                ORDER BY            
                	u.businessName,
                    c.candidateID
		</cfquery>
           
		<cfreturn qGetApplicationListbyStatusID>
    </cffunction>
 
 
	<!-------------------------------------------------- 
		Check Required Candidate and Section Fields 
	--------------------------------------------------->
	<cffunction name="checkCandidateRequiredFields" access="public" returntype="struct" output="false" hint="Check if required fields were answered">
        <cfargument name="candidateID" type="numeric" required="yes" hint="candidateID" />
        <cfargument name="sectionName" type="string" required="yes" hint="Section name" />
        <cfargument name="foreignTable" type="string" default="#APPLICATION.foreignTable#" hint="Foreign Table" />
        
		<!--- Candidate Picture --->
        <cfdirectory name="candidatePicture" directory="#APPLICATION.PATH.uploadCandidatePicture#" filter="#ARGUMENTS.candidateID#.*">
            
        <cfscript>
			// Get Student Information
			qGetStudentInfo = getCandidateByID(candidateID=ARGUMENTS.candidateID);
			
			// Set if we need to check form or table fields for the section questions
			var checkRequiredSection = 0;
			
			// Declare structure that will store the result
			var stRequiredFields = StructNew();	
			
			// Create an array that will be populated with the validation message in case we need to display missing items
			stRequiredFields.fieldList = ArrayNew(1);

			// Set complete = 1
			stRequiredFields.isComplete = 1;

			// Get Questions for this section
			qGetQuestions = APPLICATION.CFC.ONLINEAPP.getQuestionByFilter(sectionName=ARGUMENTS.sectionName);

			// Get Answers for this section
			qGetAnswers = APPLICATION.CFC.ONLINEAPP.getAnswerByFilter(sectionName=ARGUMENTS.sectionName, foreignTable=ARGUMENTS.foreignTable, foreignID=ARGUMENTS.candidateID);

			// Check in which section we are in and validate section specific fields        
			switch(ARGUMENTS.sectionName) {
				case 'section1': {
				
					// Check required Fields
					if ( NOT candidatePicture.recordCount ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please upload a picture');
					}
					
					if ( NOT LEN(qGetStudentInfo.lastName) ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please enter your last name');
					}

					if ( NOT LEN(qGetStudentInfo.firstName) ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please enter your first name');
					}
		
					if ( NOT LEN(qGetStudentInfo.sex) ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please select a gender');
					}
	
					if ( NOT IsDate(qGetStudentInfo.dob) ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please enter a valid date of birth');
					}
		
					if ( NOT LEN(qGetStudentInfo.birth_city) ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please enter your place of birth');
					}
		
					if ( NOT VAL(qGetStudentInfo.birth_country) ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please select a country of birth');
					}
		
					if ( NOT VAL(qGetStudentInfo.residence_country) ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please select a country of residence');
					}
		
					if ( NOT VAL(qGetStudentInfo.citizen_country) ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please select a country of citizenship');
					}
					
					if ( NOT LEN(qGetStudentInfo.home_address) ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please enter your mailing address');
					}
		
					if ( NOT LEN(qGetStudentInfo.home_city) ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please enter your mailing city');
					}
		
					if ( NOT VAL(qGetStudentInfo.home_country) ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please select your mailing country');
					}
					
					if ( NOT LEN(qGetStudentInfo.email) ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please enter an email address');
					}
		
					if ( NOT LEN(qGetStudentInfo.passport_number) ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please enter your passport number');
					}
		
					if ( NOT LEN(qGetStudentInfo.emergency_name) ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please enter your emergency contact name');
					}
		
					if ( NOT LEN(qGetStudentInfo.emergency_phone) ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please enter your emergency contact phone');
					}
		
					if ( NOT IsDate(qGetStudentInfo.wat_vacation_start) ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please enter a valid vacation start date');
					}
					
					if ( NOT IsDate(qGetStudentInfo.wat_vacation_end) ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please enter a valid vacation end date');
					}
					
					if ( NOT IsDate(qGetCandidateInfo.startDate) ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please enter a valid program start date');
					}
					
					if ( NOT IsDate(qGetCandidateInfo.endDate) ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please enter a valid program end date');
					}
					
					if ( NOT LEN(qGetCandidateInfo.wat_placement) ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please select a program option');
					}
					
					if ( qGetCandidateInfo.wat_placement EQ 'CSB-Placement' AND NOT LEN(qGetAnswers.answer[2]) ) {
					 	ArrayAppend(stRequiredFields.fieldList, 'Please enter a requested placement');
					}
					
					if ( NOT LEN(qGetCandidateInfo.wat_participation) ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please select number of previous participations in the program');
					}
					break;
				}

				case 'section2': {
					// It also requires a document to be uploaded - Agreement ID=2
					qAgreement = APPLICATION.CFC.DOCUMENT.getDocumentsByFilter(
						foreignTable=APPLICATION.foreignTable,
						foreignID=ARGUMENTS.candidateID,
						documentTypeID=2
					);
					
					// Check if Agreement has been uploaded
					if ( NOT qAgreement.recordCount AND NOT APPLICATION.CFC.DOCUMENT.DocumentExists(ID=VAL(qAgreement.ID)) ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please print, sign and upload the Agreement');
					}
					break;
				}
				
				case 'section3': {
					// It also requires a document to be uploaded - English Assessment ID=2
					if ( CLIENT.loginType EQ 'user' ) {
						
						qEnglishAssessment = APPLICATION.CFC.DOCUMENT.getDocumentsByFilter(
							foreignTable=APPLICATION.foreignTable,
							foreignID=ARGUMENTS.candidateID,
							documentTypeID=2
						);
						
						// Check if English Assessment has been uploaded
						if ( NOT qEnglishAssessment.recordCount AND NOT APPLICATION.CFC.DOCUMENT.DocumentExists(ID=VAL(qEnglishAssessment.ID)) ) {
							ArrayAppend(stRequiredFields.fieldList, 'Please print, sign and upload the English Assessment');
						}
						
                    }
					break;
				}
				
				default: {
					break;
				}
			}
			
			  // Section Fields are checked on this function
			stRequiredSection = APPLICATION.CFC.ONLINEAPP.checkRequiredSectionFields(
									sectionName=ARGUMENTS.sectionName, 
									foreignTable=ARGUMENTS.foreignTable, 
									foreignID=ARGUMENTS.candidateID
								);
			
			// Merge Arrays
			stRequiredFields.fieldList = APPLICATION.CFC.UDF.arrayMerge(array1=stRequiredFields.fieldList, array2=stRequiredSection.fieldList);
			
			// Check if there are errors
			if ( ArrayLen(stRequiredFields.fieldList) ) {
				// Set setion as not completed
				stRequiredFields.isComplete = 0;
			}
		
			// Return Structure
			return stRequiredFields;
		</cfscript>
        
	</cffunction>


	<!-------------------------------------------------- 
		Candidate Profile Update Tool
	--------------------------------------------------->
	<cffunction name="getProfileToolList" access="remote" returnFormat="json" output="false" hint="Returns verification report list in Json format">
		<cfargument name="keyword" default="" hint="Keyword used in search">
    	<cfargument name="intRep" default="0" hint="International Representative is not required">
        
        <cfquery 
			name="qGetProfileToolList" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
					ec.candidateID,
                    ec.firstName,
                    ec.middleName,
                    ec.lastName,
					CASE 
                    	WHEN ec.sex = 'f' THEN 'female' 
                        WHEN ec.sex = 'm' THEN 'male' 
                        ELSE '' END AS sex,
                    DATE_FORMAT(ec.dob, '%m/%e/%Y') as dob,
                    DATE_FORMAT(ec.startDate, '%m/%e/%Y') as startDate,
                    DATE_FORMAT(ec.endDate, '%m/%e/%Y') as endDate,
                    IFNULL(u.businessName, '') AS businessName,
                    IFNULL(p.programName, '') AS programName,
                    IFNULL(c.countryName, '') AS countryName
                FROM 
                    extra_candidates ec
				INNER JOIN
                	smg_users u ON u.userID = ec.intRep
                LEFT OUTER JOIN
                	smg_programs p ON p.programID = ec.programID
				LEFT OUTER JOIN
                    smg_countrylist c ON c.countryid = ec.residence_country  
                WHERE
                    ec.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
                AND
                	ec.status = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                AND    
                    ec.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">                       
				AND
		        	ec.applicationStatusID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="0,11" list="yes"> )
				
				<cfif VAL(ARGUMENTS.intRep)>
                    AND
                        ec.intRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.intRep#">
                </cfif>
                
                <cfif LEN(ARGUMENTS.keyword)>
                	AND
                    	(
                        	ec.firstName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ARGUMENTS.keyWord#%">
						OR
							ec.lastName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ARGUMENTS.keyWord#%">                                                    
                        )
                </cfif>
                
			ORDER BY
            	ec.lastName,
                ec.firstName
		</cfquery>
		   
		<cfreturn qGetProfileToolList>
	</cffunction>
    
	<cffunction name="updateProfileToolListByID" access="remote" returntype="void" hint="Updates a candidate record.">
        <cfargument name="candidateID" required="yes" hint="candidateID is required">
        <cfargument name="englishAssessment" required="yes" hint="englishAssessment is required">
        <cfargument name="englishAssessmentDate" required="yes" hint="englishAssessmentDate is required">
        <cfargument name="englishAssessmentComment" required="yes" hint="englishAssessmentComment is required">

        <cfquery 
			datasource="#APPLICATION.DSN.Source#">
                UPDATE
					extra_candidates
				SET
                    englishAssessment = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.englishAssessment)#">,
                    englishAssessmentDate = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.englishAssessmentDate#" null="#NOT IsDate(ARGUMENTS.englishAssessmentDate)#">,
                    englishAssessmentComment = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.englishAssessmentComment)#">
                WHERE
                    candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.candidateID#">
		</cfquery>
		   
	</cffunction>
	<!-------------------------------------------------- 
		End of Candidate Profile Update Tool
	--------------------------------------------------->


	<!--------------------------------------------------
		DS-2019 Online Verification Tool 
	--------------------------------------------------->
	<cffunction name="getVerificationList" access="remote" returnFormat="json" output="false" hint="Returns verification report list in Json format">
    	<cfargument name="intRep" default="0" hint="International Representative is not required">
        <cfargument name="receivedDate" default="" hint="Filter by verification received date">

        <cfquery 
			name="qGetVerificationList" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
					ec.candidateID,
                    ec.firstName,
                    ec.middleName,
                    ec.lastName,
					CASE 
                    	WHEN ec.sex = 'f' THEN 'female' 
                        WHEN ec.sex = 'm' THEN 'male' 
                        ELSE '' END AS sex,
                    DATE_FORMAT(ec.dob, '%m/%e/%Y') as dob,
                    ec.birth_city,
                    ec.birth_country,
                    ec.citizen_country,
                    ec.residence_country,
                    DATE_FORMAT(ec.startDate, '%m/%e/%Y') as startDate,
                    DATE_FORMAT(ec.endDate, '%m/%e/%Y') as endDate,
                    birth.countryName as birthCountry,
                    citizen.countryName as citizenCountry,
                    resident.countryName as residentCountry
                FROM 
                    extra_candidates ec
				INNER JOIN
                	smg_programs p ON p.programID = ec.programID
                LEFT OUTER JOIN
                	smg_countrylist birth ON birth.countryID = ec.birth_country
				LEFT OUTER JOIN
                	smg_countrylist citizen ON citizen.countryID = ec.citizen_country
				LEFT OUTER JOIN
                	smg_countrylist resident ON resident.countryID = ec.residence_country
                WHERE
                	ec.status = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
				AND   
                    ec.ds2019 = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
                AND
                    ec.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
				
				<cfif VAL(ARGUMENTS.intRep)>
                    AND
                        ec.intRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.intRep#">
                </cfif>
                
				<cfif IsDate(ARGUMENTS.receivedDate)>
                	AND
                    	ec.verification_received = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.receivedDate#">
				<cfelse>
                	AND
                    	ec.verification_received IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                </cfif>
                
			ORDER BY
            	ec.lastName,
                ec.firstName
		</cfquery>
		   
		<cfreturn qGetVerificationList>
	</cffunction>


	<cffunction name="getRemoteCandidateByID" access="remote" returnFormat="json" output="false" hint="Returns a candidate in Json format">
        <cfargument name="candidateID" required="yes" hint="candidateID is required">

        <cfquery 
			name="qGetRemoteCandidateByID" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
					ec.candidateID,
                    ec.firstName,
                    ec.middleName,
                    ec.lastName,
                    ec.sex,
                    DATE_FORMAT(ec.dob, '%m/%e/%Y') as dob,
                    ec.birth_city,
                    ec.birth_country,
                    ec.citizen_country,
                    ec.residence_country,
                    DATE_FORMAT(ec.startDate, '%m/%e/%Y') as startDate,
                    DATE_FORMAT(ec.endDate, '%m/%e/%Y') as endDate,
                    ec.englishAssessment,
                    DATE_FORMAT(ec.englishAssessmentDate, '%m/%e/%Y') as englishAssessmentDate,
                    ec.englishAssessmentComment
                FROM 
                    extra_candidates ec
                WHERE
                    ec.candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.candidateID#">
		</cfquery>
		   
		<cfreturn qGetRemoteCandidateByID>
	</cffunction>


	<cffunction name="updateRemoteCandidateByID" access="remote" returntype="void" hint="Updates a candidate record.">
        <cfargument name="candidateID" required="yes" hint="candidateID is required">
        <cfargument name="firstName" required="yes" hint="firstName is required">
        <cfargument name="middleName" required="yes" hint="middleName is required">
        <cfargument name="lastName" required="yes" hint="lastName is required">
        <cfargument name="sex" required="yes" hint="sex is required">
        <cfargument name="dob" required="yes" hint="dob is required">
        <cfargument name="birthCity" required="yes" hint="birthCity is required">
        <cfargument name="birthCountry" required="yes" hint="birthCountry is required">
        <cfargument name="citizenCountry" required="yes" hint="citizenCountry is required">
        <cfargument name="residenceCountry" required="yes" hint="residenceCountry is required">
        <cfargument name="startDate" required="yes" hint="citizenCountry is required">
        <cfargument name="endDate" required="yes" hint="residenceCountry is required">

        <cfquery 
			datasource="#APPLICATION.DSN.Source#">
                UPDATE
					extra_candidates
				SET
                    firstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.firstName)#">,
                    middleName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.middleName)#">,
                    lastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.lastName)#">,
                    sex = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.sex#">,
                    dob = <cfqueryparam cfsqltype="cf_sql_date" value="#TRIM(ARGUMENTS.dob)#" null="#NOT IsDate(ARGUMENTS.dob)#">,
                    birth_city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.birthCity#">,
                    birth_country = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.birthCountry)#">,
                    citizen_country = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.citizenCountry)#">,
                    residence_country = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.residenceCountry)#">,
                    startDate = <cfqueryparam cfsqltype="cf_sql_date" value="#TRIM(ARGUMENTS.startDate)#" null="#NOT IsDate(ARGUMENTS.startDate)#">,
                    endDate = <cfqueryparam cfsqltype="cf_sql_date" value="#TRIM(ARGUMENTS.endDate)#" null="#NOT IsDate(ARGUMENTS.endDate)#">
                WHERE
                    candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.candidateID#">
		</cfquery>
		   
	</cffunction>


	<cffunction name="confirmVerificationReceived" access="remote" returntype="void" hint="Sets verification_received field as received.">
        <cfargument name="candidateID" required="yes" hint="candidateID is required">

        <cfquery 
			datasource="#APPLICATION.DSN.Source#">
                UPDATE
					extra_candidates
				SET
                    verification_received = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                WHERE
                    candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.candidateID#">
		</cfquery>
		   
	</cffunction>
	<!-------------------------------------------------- 
		End of DS-2019 Online Verification Tool 
	--------------------------------------------------->

</cfcomponent>