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
		<cfargument name="ID" type="numeric" default="0">
        <cfargument name="updateDateLastLoggedIn" type="numeric" default="0">
        
        <cfscript>
			if ( VAL(ARGUMENTS.ID) ) {
			
				// Set candidate ID
				SESSION.CANDIDATE.ID = ARGUMENTS.ID;
	
				// Get Candidate Information
				qGetCandidateInfo = getCandidateByID(candidateID=ARGUMENTS.ID);
			
				// Set candidate session variables 
				SESSION.CANDIDATE.firstName = qGetCandidateInfo.firstName;
				SESSION.CANDIDATE.lastName = qGetCandidateInfo.lastName;
				SESSION.CANDIDATE.dateLastLoggedIn = qGetCandidateInfo.dateLastLoggedIn;
								
				// set up upload files path
				SESSION.CANDIDATE.myUploadFolder = APPLICATION.PATH.uploadDocumentCandidate & ARGUMENTS.ID & '/';
				// Make sure folder exists
				APPLICATION.CFC.DOCUMENT.createFolder(SESSION.CANDIDATE.myUploadFolder);
				
				// Set student SESSION complete
				stCheckSession1 = checkCandidateRequiredFields(candidateID=ARGUMENTS.ID, FORM=StructNew(), sectionName='section1');
								
				SESSION.CANDIDATE.isSection1Complete = stCheckSession1.isComplete;
				SESSION.CANDIDATE.section1FieldList = stCheckSession1.fieldList;
				
				// REPLACE THIS
				stCheckSession2 = checkCandidateRequiredFields(candidateID=ARGUMENTS.ID, FORM=StructNew(), sectionName='section2');
				SESSION.CANDIDATE.isSection2Complete = 1;
				SESSION.CANDIDATE.section2FieldList = '';

				stCheckSession3 = checkCandidateRequiredFields(candidateID=ARGUMENTS.ID, FORM=StructNew(), sectionName='section3');
				SESSION.CANDIDATE.isSection3Complete = 1;
				SESSION.CANDIDATE.section3FieldList = '';
			}
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
                        candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.candidateID#">
                </cfif>
                
                <cfif LEN(ARGUMENTS.uniqueID)>
                    AND
                        uniqueID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.uniqueID#">
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
                    <cfif IsDate(ARGUMENTS.dob)>
	                    dob = <cfqueryparam cfsqltype="cf_sql_date" value="#TRIM(ARGUMENTS.dob)#">,
                    <cfelse>
                    	dob = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    </cfif>
                    birth_city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.birth_city))#">,
                    birth_country = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.birth_country)#">,
                    residence_country = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.residence_country)#">,
                    citizen_country = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.citizen_country)#">,
                    home_address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.home_address))#">,
                    home_city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.home_city))#">,
                    home_country = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.home_country)#">,
                    home_zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.home_zip))#">,
                    home_phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.home_phone))#">,
                    passport_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.passport_number))#">,
                    emergency_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.emergency_name))#">,
                    emergency_phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.emergency_phone))#">,
                    <cfif IsDate(ARGUMENTS.wat_vacation_start)>
	                    wat_vacation_start = <cfqueryparam cfsqltype="cf_sql_date" value="#TRIM(ARGUMENTS.wat_vacation_start)#">,
                    <cfelse>
                    	wat_vacation_start = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    </cfif>
                    <cfif IsDate(ARGUMENTS.wat_vacation_end)>
	                    wat_vacation_end = <cfqueryparam cfsqltype="cf_sql_date" value="#TRIM(ARGUMENTS.wat_vacation_end)#">,
                    <cfelse>
                    	wat_vacation_end = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    </cfif>
                    <cfif IsDate(ARGUMENTS.startDate)>
	                    startDate = <cfqueryparam cfsqltype="cf_sql_date" value="#TRIM(ARGUMENTS.startDate)#">,
                    <cfelse>
                    	startDate = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    </cfif>
                    <cfif IsDate(ARGUMENTS.endDate)>
	                    endDate = <cfqueryparam cfsqltype="cf_sql_date" value="#TRIM(ARGUMENTS.endDate)#">,
                    <cfelse>
                    	endDate = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    </cfif>
                    wat_placement = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.wat_placement))#">,
                    wat_participation = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.wat_participation))#">,
                    ssn = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.ssn))#">
				WHERE
	                candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.candidateID)#">
		</cfquery>
		
	</cffunction>


	<!--- Check Login --->
	<cffunction name="checkLogin" access="public" returntype="query" output="false" hint="Check candidate credentials">
		<cfargument name="email" required="yes" hint="Email Address" />
		<cfargument name="password" required="yes" hint="Password" />		

		<cfquery 
			name="qCheckLogin" 
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
		
		<cfreturn qCheckLogin /> 
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
		
			// Check if we need to create an account
			if ( ARGUMENTS.type EQ 'Candidate' ) {
			
				setPassword = APPLICATION.CFC.onlineApp.generatePassword();	
			
			// Set Application Status Based on who is creating the application
			} else if ( ARGUMENTS.type EQ 'Office') {
				
				// Intl. Rep.
				if ( ARGUMENTS.userType EQ 8 ) {
					applicationStatusID = 5;
				// Branch
				} else if ( ARGUMENTS.userType EQ 11 ) {
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

				APPLICATION.CFC.email.sendEmail(
					emailFrom=APPLICATION.EMAIL.contactUs,
					emailTo=APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.email)),
					emailType='newAccount',
					candidateID=newRecord.GENERATED_KEY
				);
	
			}
						
			// Insert History
			APPLICATION.CFC.ONLINEAPP.insertApplicationHistory(
				applicationStatusID=applicationStatusID,
				foreignTable='extra_candidates',
				foreignID=newRecord.GENERATED_KEY,
				description='Application Created'
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
		
        <cfscript>
			// Insert History
			APPLICATION.CFC.ONLINEAPP.insertApplicationHistory(
				applicationID=APPLICATION.applicationID,
				applicationStatusID=ARGUMENTS.applicationStatusID,
				foreignTable='extra_candidates',
				foreignID=ARGUMENTS.candidateID,
				description='Application Activated'
			);
		</cfscript>
        
	</cffunction>


    <!--- Activate Online Application Account --->
	<cffunction name="activateApplication" access="public" returntype="void" output="false" hint="Activate an account">
        <cfargument name="candidateID" type="numeric" required="yes" hint="CandidateID is required" />
        <cfargument name="email" type="string" required="yes" hint="email is required" />	
		
        <cfscript>
			// Update Status and record history
			updateApplicationStatus(
				candidateID=ARGUMENTS.candidateID,
				applicationStatusID=2
			);
			
			// Email the candidate
			APPLICATION.CFC.email.sendEmail(
				emailFrom=APPLICATION.EMAIL.contactUs,
				emailTo=ARGUMENTS.email,
				emailType='activateAccount',
				candidateID=ARGUMENTS.candidateID
			);
		</cfscript>

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
                    c.uniqueID,
                    c.firstName,
                    c.lastName,
                    c.sex,
                    c.email,
                    u.businessName,
                    branch.businessName as branchName,
                    ast.dateCreated
                FROM 
                    extra_candidates c
                INNER JOIN	
                	smg_users u ON u.userID = c.intRep
                INNER JOIN                
                      applicationStatusJn ast ON ast.foreignID = c.candidateID
                      AND
                         ast.foreignTable = 'extra_candidates' 
					  AND 
                    	ast.applicationStatusID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.applicationStatusID#">                                              
                LEFT OUTER JOIN 
        			smg_users branch ON branch.userid = c.branchid                
                WHERE            
                    c.status = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                AND 
                    c.applicationStatusID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.applicationStatusID#"> 
                <cfif VAL(ARGUMENTS.intRep)>
                	AND	
                    	c.intRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.intRep#">
                </cfif>
                GROUP BY
                	c.candidateID
                ORDER BY            
                	c.candidateID
		</cfquery>
		   
		<cfreturn qGetApplicationListbyStatusID>
    </cffunction>
 
 
	<!--- 
		Check Required Candidate and Section Fields 
	--->
	<cffunction name="checkCandidateRequiredFields" access="public" returntype="struct" output="false" hint="Check if required fields were answered">
        <cfargument name="candidateID" type="numeric" required="yes" hint="candidateID" />
        <cfargument name="sectionName" type="string" required="yes" hint="Section name" />
        <cfargument name="foreignTable" type="string" default="extra_candidates" hint="Foreign Table" />
        
        <cfscript>
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

			// If FORM is not passed, used the table fields instead
			if ( StructIsEmpty(ARGUMENTS.FORM) ) {
				
				// In this case we need to check the required section fields 
				checkRequiredSection = 1;
				
				// Get Student Information
				qGetStudentInfo = getCandidateByID(candidateID=ARGUMENTS.candidateID);

				// Convert query fields to a structure
				ARGUMENTS.FORM = APPLICATION.CFC.UDF.QueryToStruct(qGetStudentInfo);

				// Set up section1 additional FORM variables
				ARGUMENTS.FORM.dobMonth = Month(qGetCandidateInfo.dob);
				ARGUMENTS.FORM.dobDay = Day(qGetCandidateInfo.dob);
				ARGUMENTS.FORM.dobYear = Year(qGetCandidateInfo.dob);
				
				ARGUMENTS.FORM.watStartVacationMonth = Month(qGetCandidateInfo.wat_vacation_start);
				ARGUMENTS.FORM.watStartVacationDay = Day(qGetCandidateInfo.wat_vacation_start);
				ARGUMENTS.FORM.watStartVacationYear = Year(qGetCandidateInfo.wat_vacation_start);
				
				ARGUMENTS.FORM.watEndVacationMonth = Month(qGetCandidateInfo.wat_vacation_end);
				ARGUMENTS.FORM.watEndVacationDay = Day(qGetCandidateInfo.wat_vacation_end);
				ARGUMENTS.FORM.watEndVacationYear = Year(qGetCandidateInfo.wat_vacation_end);
				
				ARGUMENTS.FORM.programStartMonth = Month(qGetCandidateInfo.startDate);
				ARGUMENTS.FORM.programStartDay = Day(qGetCandidateInfo.startDate);
				ARGUMENTS.FORM.programStartYear = Year(qGetCandidateInfo.startDate);
				
				ARGUMENTS.FORM.programEndMonth = Month(qGetCandidateInfo.endDate);
				ARGUMENTS.FORM.programEndDay = Day(qGetCandidateInfo.endDate);
				ARGUMENTS.FORM.programEndYear = Year(qGetCandidateInfo.endDate);

				// Get Answers for this section
				qGetAnswers = APPLICATION.CFC.ONLINEAPP.getAnswerByFilter(sectionName=ARGUMENTS.sectionName, foreignTable=ARGUMENTS.foreignTable, foreignID=FORM.candidateID);

				// Online Application Fields 
				for ( i=1; i LTE qGetAnswers.recordCount; i=i+1 ) {
					ARGUMENTS.FORM[qGetAnswers.fieldKey[i]] = qGetAnswers.answer[i];
				}

			} else {

				// Param Online Application FORM Variables 
				for ( i=1; i LTE qGetQuestions.recordCount; i=i+1 ) {
					param name="ARGUMENTS.FORM[qGetQuestions.fieldKey[i]]" default="";
				}
				
			}
			
			// Check in which section we are in and validate section specific fields        
			switch(ARGUMENTS.sectionName) {
				case 'section1': {

					// Check required Fields
					if ( NOT LEN(ARGUMENTS.FORM.lastName) ) {
						// Get all the missing items in a list
						ArrayAppend(stRequiredFields.fieldList, 'Please enter your last name');
					}

					if ( NOT LEN(ARGUMENTS.FORM.firstName) ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please enter your first name');
					}
		
					if ( NOT LEN(ARGUMENTS.FORM.sex) ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please select a gender');
					}
	
					if ( NOT IsDate(ARGUMENTS.FORM.dobMonth & '/' & ARGUMENTS.FORM.dobDay & '/' & ARGUMENTS.FORM.dobYear) ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please enter a valid date of birth');
					}
		
					if ( NOT LEN(ARGUMENTS.FORM.birth_city) ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please enter your place of birth');
					}
		
					if ( NOT VAL(ARGUMENTS.FORM.birth_country) ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please select a country of birth');
					}
		
					if ( NOT VAL(ARGUMENTS.FORM.residence_country) ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please select a country of residence');
					}
		
					if ( NOT VAL(ARGUMENTS.FORM.citizen_country) ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please select a country of citizenship');
					}
					
					if ( NOT LEN(ARGUMENTS.FORM.home_address) ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please enter your mailing address');
					}
		
					if ( NOT LEN(ARGUMENTS.FORM.home_city) ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please enter your mailing city');
					}
		
					if ( NOT VAL(ARGUMENTS.FORM.home_country) ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please select your mailing country');
					}
		
					if ( NOT LEN(ARGUMENTS.FORM.passport_number) ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please enter your passport number');
					}
		
					if ( NOT LEN(ARGUMENTS.FORM.emergency_name) ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please enter your emergency contact name');
					}
		
					if ( NOT LEN(ARGUMENTS.FORM.emergency_phone) ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please enter your emergency contact phone');
					}
		
					if ( NOT IsDate(ARGUMENTS.FORM.watStartVacationMonth & '/' & ARGUMENTS.FORM.watStartVacationDay & '/' & ARGUMENTS.FORM.watStartVacationYear) ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please enter a valid vacation start date');
					}
					
					if ( NOT IsDate(ARGUMENTS.FORM.watEndVacationMonth & '/' & ARGUMENTS.FORM.watEndVacationDay & '/' & ARGUMENTS.FORM.watEndVacationYear) ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please enter a valid vacation end date');
					}
					
					if ( NOT IsDate(ARGUMENTS.FORM.programStartMonth & '/' & ARGUMENTS.FORM.programStartDay & '/' & ARGUMENTS.FORM.programStartYear) ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please enter a valid program start date');
					}
					
					if ( NOT IsDate(ARGUMENTS.FORM.programEndMonth & '/' & ARGUMENTS.FORM.programEndDay & '/' & ARGUMENTS.FORM.programEndYear) ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please enter a valid program end date');
					}
					
					if ( NOT LEN(ARGUMENTS.FORM.wat_placement) ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please select a program option');
					}
					
					if ( ARGUMENTS.FORM.wat_placement EQ 'CSB-Placement' AND NOT LEN(ARGUMENTS.FORM[qGetQuestions.fieldKey[2]]) ) {
					 	ArrayAppend(stRequiredFields.fieldList, 'Please enter a requested placement');
					}
					
					if ( NOT LEN(ARGUMENTS.FORM.wat_participation) ) {
						ArrayAppend(stRequiredFields.fieldList, 'Please select number of previous participations in the program');
					}
					break;
				}

				case 'section2': {
					break;
				}
				
				case 'section3': {
					break;
				}
				
				default: {
					break;
				}
			}
			
			// Check Required Table Fields
			if ( checkRequiredSection ) {
			
				// Section Fields are checked on this function
				stRequiredSection = APPLICATION.CFC.ONLINEAPP.checkRequiredSectionFields(
										sectionName=ARGUMENTS.sectionName, 
										foreignTable=ARGUMENTS.foreignTable, 
										foreignID=ARGUMENTS.candidateID
									);
				
				// Merge Arrays
				stRequiredFields.fieldList = APPLICATION.CFC.UDF.arrayMerge(array1=stRequiredFields.fieldList, array2=stRequiredSection.fieldList);
				
			// Check required FORM fields
			} else {

				// Loop Over Application Questions Fields
				for ( i=1; i LTE qGetQuestions.recordCount; i=i+1 ) {
					
					if (qGetQuestions.isRequired[i] AND NOT LEN(ARGUMENTS.FORM[qGetQuestions.fieldKey[i]]) ) {
						ArrayAppend(stRequiredFields.fieldList, qGetQuestions.requiredMessage[i]);
					}
				}
				
			}

			// Check if there are errors
			if ( ArrayLen(stRequiredFields.fieldList) ) {
				// Set setion as not completed
				stRequiredFields.isComplete = 0;
			}
		
			// Return Structure
			return stRequiredFields;
		</cfscript>
        
	</cffunction>
 

	<!--- 
		DS-2019 Online Verification Tool 
	--->
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
                    ec.sex,
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
            	ec.candidateID
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
                    DATE_FORMAT(ec.endDate, '%m/%e/%Y') as endDate
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
                    <cfif IsDate(ARGUMENTS.dob)>
	                    dob = <cfqueryparam cfsqltype="cf_sql_date" value="#TRIM(ARGUMENTS.dob)#">,
                    <cfelse>
                    	dob = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    </cfif>
                    birth_city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.birthCity#">,
                    birth_country = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.birthCountry)#">,
                    citizen_country = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.citizenCountry)#">,
                    residence_country = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.residenceCountry)#">,
                    <cfif IsDate(ARGUMENTS.startDate)>
	                    startDate = <cfqueryparam cfsqltype="cf_sql_date" value="#TRIM(ARGUMENTS.startDate)#">,
                    <cfelse>
                    	startDate = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    </cfif>
                    <cfif IsDate(ARGUMENTS.endDate)>
	                    endDate = <cfqueryparam cfsqltype="cf_sql_date" value="#TRIM(ARGUMENTS.endDate)#">
                    <cfelse>
                    	endDate = <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                    </cfif>
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
	<!--- 
		End of DS-2019 Online Verification Tool 
	--->

</cfcomponent>