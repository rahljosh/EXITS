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
    
    <cffunction name="getCandidateWithPlacementInformation" access="public" returntype="query" output="no" hint="Gets a candidate with their placement information by their candidateID">
    	<cfargument name="candidateID" default="0" hint="candidateID is not required (0 returns all candidates)">
        <cfargument name="placementType" default="All" hint="placementType is not required, values: primary, secondary, all">
        <cfargument name="programID" default="0" hint="programID is not required">
        <cfargument name="candidateStatus" default="All" hint="candidateStatus is not required">
        <cfargument name="intRep" default="0" hint="intRep is not required">
        
        <cfquery name="qGetCandidates" datasource="#APPLICATION.DSN.Source#">
            SELECT 
                ec.*,
                ecpc.jobID AS jobTitleID,  
                ej.title AS jobTitle,
                ehc.name AS hostCompanyName, 
                ehc.city AS hostCompanyCity,
                ss.state AS hostCompanyState,                
                u.businessName,
                eic.subject
            FROM extra_candidates ec
          	<cfif ARGUMENTS.placementType EQ "primary" OR ARGUMENTS.placementType EQ "secondary">
            	INNER JOIN extra_candidate_place_company ecpc ON ecpc.candidateID = ec.candidateID
                    AND ec.hostcompanyid = ecpc.hostCompanyID
                    AND ecpc.status = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                    <cfif ARGUMENTS.placementType EQ "primary">
                        AND ecpc.isSecondary = 0
                    <cfelseif ARGUMENTS.placementType EQ "secondary">
                        AND ecpc.isSecondary = 1
                    </cfif>
          	<cfelse>
            	LEFT JOIN extra_candidate_place_company ecpc ON ecpc.candidateID = ec.candidateID
                    AND ec.hostcompanyid = ecpc.hostCompanyID
                    AND ecpc.status = 1
          	</cfif>
            LEFT JOIN extra_jobs ej ON ej.id = ecpc.jobID
            LEFT JOIN extra_hostcompany ehc ON ehc.hostcompanyid = ec.hostcompanyid
            INNER JOIN smg_programs ON smg_programs.programID = ec.programID
            INNER JOIN smg_users u ON u.userid = ec.intrep
            LEFT JOIN smg_states ss ON ss.id = ehc.state
           	LEFT JOIN extra_incident_report eic ON eic.candidateID = ec.candidateID
              	AND eic.isSolved = 0
          	WHERE ec.status != "canceled"
            <cfif VAL(ARGUMENTS.programID)>  
           		AND ec.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.programID#">
           	</cfif>
          	<cfif ARGUMENTS.candidateStatus NEQ 'all'>
            	AND ec.status = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.candidateStatus#">
            </cfif>
           	<cfif CLIENT.userType EQ 8>
            	AND ec.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
            <cfelse>
				<cfif VAL(ARGUMENTS.intRep)>
                    AND ec.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.intRep#">
                </cfif>
          	</cfif>
            GROUP BY ec.candidateID
        </cfquery>
        
        <cfreturn qGetCandidates>
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
        <cfargument name="emergency_email" default="" hint="Candidate Emergency Email">
        <cfargument name="wat_vacation_start" default="" hint="Start of Official Vacation">
        <cfargument name="wat_vacation_end" default="" hint="End of Official Vacation">
        <cfargument name="startDate" default="" hint="Program Start Date">
        <cfargument name="endDate" default="" hint="Program End Date">
        <cfargument name="wat_placement" default="" hint="Program Option">
        <cfargument name="wat_participation" default="" hint="Number of participations in program">
        <cfargument name="wat_participation_info" default="" hint="Year and Sponsor of previous participations">
        <cfargument name="updateSSN" default="0" hint="Set to 1 to update SSN">
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
                    emergency_email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.emergency_email))#">,
                    wat_vacation_start = <cfqueryparam cfsqltype="cf_sql_date" value="#TRIM(ARGUMENTS.wat_vacation_start)#" null="#NOT IsDate(ARGUMENTS.wat_vacation_start)#">,
                    wat_vacation_end = <cfqueryparam cfsqltype="cf_sql_date" value="#TRIM(ARGUMENTS.wat_vacation_end)#" null="#NOT IsDate(ARGUMENTS.wat_vacation_end)#">,
                    startDate = <cfqueryparam cfsqltype="cf_sql_date" value="#TRIM(ARGUMENTS.startDate)#" null="#NOT IsDate(ARGUMENTS.startDate)#">,
                    endDate = <cfqueryparam cfsqltype="cf_sql_date" value="#TRIM(ARGUMENTS.endDate)#" null="#NOT IsDate(ARGUMENTS.endDate)#">,
                    
					<cfif LEN(ARGUMENTS.wat_participation)>
                    	wat_participation = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.wat_participation#">,
                    </cfif>

                    wat_participation_info = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.wat_participation_info#">,

                    <cfif VAL(ARGUMENTS.updateSSN)>
	                    ssn = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.ssn))#">,
                    </cfif>
                    
                    wat_placement = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.wat_placement))#">
                    
				WHERE
	                candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.candidateID)#">
		</cfquery>
		
	</cffunction>
    
    <!--- Insert candidate history record --->
    <cffunction name="addCandidateHistoryRecord" access="public" returntype="void" output="no" hint="Inserts a new candidate history record based on the candidateID">
   		<cfargument name="candidateID" required="yes" hint="candidateID is required">
       	
        <cfquery name="qGetCandidateInfo" datasource="#APPLICATION.DSN.Source#">
            SELECT *
            FROM extra_candidates
            WHERE candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.candidateID#">
        </cfquery>

		<!--- History Record --->
        <cfquery datasource="#APPLICATION.DSN.Source#">
    		INSERT INTO extra_candidates_history (
                candidateID,
                changedBy,
                dateChanged,
                hostCompanyID,
                firstname, 
                lastname, 
                middlename,
                dob,
                sex, 
                intrep,
                birth_city, 
                birth_country,
                citizen_country,
                residence_country,
                home_address,
                home_city,
                home_zip,
                home_country,
                home_phone,
                email,
                englishAssessment,
                englishAssessmentDate,
                englishAssessmentComment,
                emergency_name,
                emergency_phone,
                emergency_email,
                passport_number,
                programID,        
                ssn,      
                wat_participation,
                wat_participation_info,
                wat_placement,
                wat_vacation_start,
                wat_vacation_end,
                wat_doc_agreement,
                wat_doc_walk_in_agreement,
                wat_doc_cv,
                wat_doc_passport_copy,
                wat_doc_orientation,
                wat_doc_signed_assessment,
                wat_doc_college_letter,
                wat_doc_college_letter_translation,
                wat_doc_job_offer_applicant,
                wat_doc_job_offer_employer,
                wat_doc_other,
                wat_doc_other_received,
                verification_received,
                ds2019,
                requested_placement,
                change_requested_comment,
                status,
                cancel_date,
                cancel_reason,
                startdate,
                enddate,
                verification_address,
                verification_sevis,
                watDateCheckedIn,
                us_phone,
                arrival_address,
                arrival_city,
                arrival_state,
                arrival_zip,
                watDateEvaluation1,
                watDateEvaluation2,
                watDateEvaluation3,
                watDateEvaluation4,
                visaInterview )
  			VALUES (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidateInfo.candidateID#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidateInfo.hostcompanyID#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.firstname#">, 
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.lastname#">, 
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.middlename#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#qGetCandidateInfo.dob#" null="#NOT IsDate(qGetCandidateInfo.dob)#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.sex#">, 
                <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidateInfo.intrep#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.birth_city#">, 
                <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidateInfo.birth_country#">, 
                <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidateInfo.citizen_country#">, 
                <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidateInfo.residence_country#">, 
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.home_address#">, 
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.home_city#">, 
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.home_zip#">,	
                <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidateInfo.home_country#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.home_phone#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.email#">, 
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.englishAssessment#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#qGetCandidateInfo.englishAssessmentDate#" null="#NOT IsDate(qGetCandidateInfo.englishAssessmentDate)#">, 
                <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#qGetCandidateInfo.englishAssessmentComment#">, 
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.emergency_name#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.emergency_phone#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.emergency_email#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.passport_number#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidateInfo.programID#">,         
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.SSN#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCandidateInfo.wat_participation)#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.wat_participation_info#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.wat_placement#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#qGetCandidateInfo.wat_vacation_start#" null="#NOT IsDate(qGetCandidateInfo.wat_vacation_start)#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#qGetCandidateInfo.wat_vacation_end#" null="#NOT IsDate(qGetCandidateInfo.wat_vacation_end)#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#qGetCandidateInfo.wat_doc_agreement#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#qGetCandidateInfo.wat_doc_walk_in_agreement#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#qGetCandidateInfo.wat_doc_cv#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#qGetCandidateInfo.wat_doc_passport_copy#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#qGetCandidateInfo.wat_doc_orientation#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#qGetCandidateInfo.wat_doc_signed_assessment#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#qGetCandidateInfo.wat_doc_college_letter#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#qGetCandidateInfo.wat_doc_college_letter_translation#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#qGetCandidateInfo.wat_doc_job_offer_applicant#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#qGetCandidateInfo.wat_doc_job_offer_employer#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.wat_doc_other#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.wat_doc_other_received#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#qGetCandidateInfo.verification_received#" null="#NOT IsDate(qGetCandidateInfo.verification_received)#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.ds2019#">, 
                <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidateInfo.requested_placement#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.change_requested_comment#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.status#">, 
                <cfif isDate(qGetCandidateInfo.cancel_date) AND qGetCandidateInfo.status EQ 'canceled'>
                    <cfqueryparam cfsqltype="cf_sql_date" value="#qGetCandidateInfo.cancel_date#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.cancel_reason#">,
                <cfelse>
                    <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="">,
                </cfif>
                <cfqueryparam cfsqltype="cf_sql_date" value="#qGetCandidateInfo.startdate#" null="#NOT IsDate(qGetCandidateInfo.startdate)#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#qGetCandidateInfo.enddate#" null="#NOT IsDate(qGetCandidateInfo.enddate)#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#qGetCandidateInfo.verification_address#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#qGetCandidateInfo.verification_sevis#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#qGetCandidateInfo.watDateCheckedIn#" null="#NOT IsDate(qGetCandidateInfo.watDateCheckedIn)#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.us_phone#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.arrival_address#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.arrival_city#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidateInfo.arrival_state#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.arrival_zip#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#qGetCandidateInfo.watDateEvaluation1#" null="#NOT IsDate(qGetCandidateInfo.watDateEvaluation1)#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#qGetCandidateInfo.watDateEvaluation2#" null="#NOT IsDate(qGetCandidateInfo.watDateEvaluation2)#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#qGetCandidateInfo.watDateEvaluation3#" null="#NOT IsDate(qGetCandidateInfo.watDateEvaluation3)#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#qGetCandidateInfo.watDateEvaluation4#" null="#NOT IsDate(qGetCandidateInfo.watDateEvaluation4)#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#qGetCandidateInfo.visaInterview#" null="#NOT IsDate(qGetCandidateInfo.visaInterview)#"> )
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
				AND
                	status = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
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
                	status = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
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
                    applicationstatus aps               
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
                    c.wat_placement,
                    u.businessName,
                    branch.businessName as branchName,
                    ast.dateCreated
                FROM 
                    extra_candidates c
                INNER JOIN	
                	smg_users u ON u.userID = c.intRep
                LEFT OUTER JOIN                
                      applicationstatusjn ast ON ast.foreignID = c.candidateID
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
 
 
	<!------------------------------------------------------------ 
		Check Required Candidate and Section Fields 
	------------------------------------------------------------->
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
					// It also requires a document to be uploaded - English Assessment ID=3
					if ( CLIENT.loginType EQ 'user' ) {
						
						qEnglishAssessment = APPLICATION.CFC.DOCUMENT.getDocumentsByFilter(
							foreignTable=APPLICATION.foreignTable,
							foreignID=ARGUMENTS.candidateID,
							documentTypeID=3
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


	<!------------------------------------------------------------
		EXTRA - Intranet
	------------------------------------------------------------->

	<cffunction name="getCandidatePlacementInformation" access="public" returntype="query" output="false" hint="Gets host company information for a candidate">
    	<cfargument name="candidateID" required="yes" hint="candidateID is required">
        <cfargument name="displayAll" default="0" hint="displayAll is not required">
        <cfargument name="candCompID" default="0" hint="candCompID is not required">
        <cfargument name="placementStatus" default="1" hint="Gets active placement by default">

        <cfquery 
        	name="qGetCandidatePlacementInformation" 
			datasource="#APPLICATION.DSN.Source#">
            SELECT 
                <!--- Host Company Specific --->
                eh.hostCompanyID,
                eh.name AS hostCompanyName,
                eh.authentication_secretaryOfState,
                eh.authentication_departmentOfLabor,
                eh.authentication_googleEarth,
                eh.authentication_incorporation,
                eh.authentication_certificateOfExistence,
                eh.authentication_certificateOfReinstatement,
                eh.authentication_departmentOfState,
                eh.authentication_businessLicenseNotAvailable,
                eh.authentication_secretaryOfStateExpiration,
                eh.authentication_departmentOfLaborExpiration,
                eh.authentication_googleEarthExpiration,
                eh.authentication_incorporationExpiration,
                eh.authentication_certificateOfExistenceExpiration,
                eh.authentication_certificateOfReinstatementExpiration,
                eh.authentication_departmentOfStateExpiration,
                eh.isHousingProvided,
                eh.EIN,
                eh.workmensCompensation,
                eh.WC_carrierName,
                eh.WC_carrierPhone,
                eh.WC_policyNumber,
                eh.WCDateExpired,
                eh.supervisor,
                eh.phone,
                eh.address,
                eh.city,
                eh.zip,
                s.state,
                <!--- Candidate Place Company --->
                ecpc.candCompID,
                ecpc.status,
                ecpc.placement_date,
                ecpc.startDate,
                ecpc.endDate,
                ecpc.selfJobOfferStatus,
                ecpc.selfConfirmationName,
                ecpc.selfConfirmationMethod,
                ecpc.selfJobOfferStatus,
                ecpc.selfConfirmationDate,
                ecpc.selfEmailConfirmationDate,
                ecpc.selfFindJobOffer,
                ecpc.selfConfirmationNotes,
                ecpc.reason_host,
                ecpc.seekingDeadline,
                ecpc.isTransfer,
                ecpc.isSecondary,
                ecpc.isTransferHousingAddressReceived,
                ecpc.isTransferJobOfferReceived,
                ecpc.isTransferSevisUpdated,
                ecpc.dateTransferConfirmed,
                ej.ID AS jobID,
                ej.title AS jobTitle,
                ej.classification,
                ec.confirmed,
                ep.numberPositions,
                ep.programID,
                epc.confirmation_phone,
                CONCAT(d.serverName,".",d.serverExt) AS savedPlacementVetting,
                d.dateCreated
            FROM extra_candidate_place_company ecpc
            INNER JOIN extra_hostcompany eh ON eh.hostCompanyID = ecpc.hostCompanyID
          	LEFT JOIN smg_states s ON s.id = eh.state
            LEFT OUTER JOIN extra_jobs ej ON ej.ID = ecpc.jobID
           	LEFT OUTER JOIN extra_confirmations ec ON ec.hostID = eh.hostCompanyID
           		AND ec.programID = (SELECT programID FROM extra_candidates WHERE candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.candidateID)#"> LIMIT 1)
          	LEFT OUTER JOIN extra_j1_positions ep ON ep.hostID = eh.hostCompanyID
       			AND ep.programID = (SELECT programID FROM extra_candidates WHERE candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.candidateID)#"> LIMIT 1)
          	LEFT OUTER JOIN extra_program_confirmations epc ON epc.hostID = ecpc.hostCompanyID
         		AND epc.programID = ep.programID
          	LEFT OUTER JOIN document d ON d.foreignID = ecpc.candCompID
            	AND d.foreignTable = "extra_candidate_place_company"
                AND d.documentTypeID = 41
                AND d.isDeleted = 0
            WHERE 
                ecpc.candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.candidateID)#">
            
            <cfif LEN(ARGUMENTS.placementStatus)>
                AND 	
                    ecpc.status = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.placementStatus)#">
            </cfif>
            <cfif ARGUMENTS.displayAll EQ 0>
                AND
                    ecpc.isSecondary = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
          	</cfif>
            <cfif ARGUMENTS.candCompID NEQ 0>
            	AND
                	ecpc.candCompID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.candCompID#">
            </cfif>
            
            ORDER BY
            	ecpc.status DESC
        </cfquery>
        
		<cfreturn qGetCandidatePlacementInformation>
	</cffunction>
    
    <cffunction name="removeCandidatePlacementInformation" access="remote" output="false" hint="deletes candidate placement record">
    	<cfargument name="candCompID" required="yes" hint="deletes record based on this id">
        
        <cfquery name="qDeleteRecord" datasource="#APPLICATION.DSN.Source#">
        	DELETE FROM
            	extra_candidate_place_company
          	WHERE
            	candCompID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.candCompID#">
        </cfquery>
    
    </cffunction>


	<!------------------------------------------------------------
		Candidate Incident Report 
	------------------------------------------------------------->
	<cffunction name="getIncidentReport" access="public" returntype="query" output="false" hint="Gets a incidents for a candidate">
    	<cfargument name="incidentID" default="" hint="incidentID is not required">
        <cfargument name="candidateID" default="" hint="candidateID is not required">
        <cfargument name="uniqueID" default="" hint="uniqueID is not required">
              
        <cfquery 
			name="qGetIncidentReport" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
					eir.ID,
                    eir.candidateID,
                    eir.hostCompanyID,
                    eir.userID,
                    eir.dateIncident,
                    eir.subject,
                    eir.reportedBy,
                    eir.relationshipToParticipant,
                    eir.notes,
                    eir.isSolved,
                    eir.dateCreated,
                    eir.dateUpdated,
                    eh.name AS hostCompanyName
                FROM extra_incident_report eir
                INNER JOIN extra_candidates ec ON ec.candidateID = eir.candidateID
				LEFT OUTER JOIN extra_hostcompany eh ON eh.hostCompanyID = eir.hostCompanyID                    
                WHERE 1 = 1 

				<cfif LEN(ARGUMENTS.incidentID)>
                    AND eir.ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.incidentID)#">
                </cfif>
                    
				<cfif LEN(ARGUMENTS.candidateID)>
                    AND ec.candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.candidateID)#">
                </cfif>
                
                <cfif LEN(ARGUMENTS.uniqueID)>
                    AND ec.uniqueID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.uniqueID)#">
                </cfif>
			
            ORDER BY
            	eir.dateIncident DESC                
		</cfquery>
		   
		<cfreturn qGetIncidentReport>
	</cffunction>
    
    <cffunction name="getIncidentNotes" access="public" returntype="query" output="no" hint="Gets notes for a given incident">
    	<cfargument name="incidentID" required="yes">
        
        <cfquery name="qGetIncidents" datasource="#APPLICATION.DSN.Source#">
        	SELECT n.*, u.firstName, u.lastName
            FROM extra_incident_report_notes n
            LEFT OUTER JOIN smg_users u ON u.userID = n.addedBy
            WHERE n.reportID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.incidentID)#">
            ORDER BY n.date DESC
        </cfquery>
        
        <cfreturn qGetIncidents>
        
    </cffunction>
    
	<cffunction name="insertUpdateIncident" access="public" returntype="void" output="false" hint="Insert/Update Incident Information">
		<cfargument name="incidentID" default="0" hint="Incident ID">
		<cfargument name="candidateID" required="yes" hint="Candidate ID is required">
        <cfargument name="hostCompanyID" required="yes" hint="hostCompany ID is required">
        <cfargument name="dateIncident" default="" hint="dateIncident">
        <cfargument name="subject" default="" hint="subject">
        <cfargument name="reportedBy" default="">
        <cfargument name="relationshipToParticipant" default="">
        <cfargument name="previousNotes" default="">
        <cfargument name="notes" default="" hint="notes">
        <cfargument name="isSolved" default="0" hint="Set to 0 or 1">
		
		<cfif VAL(ARGUMENTS.incidentID)>
        	<cfquery datasource="#APPLICATION.DSN.Source#">
            	UPDATE extra_incident_report
                SET
                	hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostCompanyID)#">,
                    dateIncident = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.dateIncident#">,
                    subject = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.subject#">,
                    reportedBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.reportedBy#">,
                    relationshipToParticipant = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.relationshipToParticipant#">,
                    isSolved = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(ARGUMENTS.isSolved)#">
              	WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.incidentID)#">
            </cfquery>
            <cfscript>
				if (LEN(TRIM(ARGUMENTS.notes))) {
					insertUpdateIncidentNotes(reportID=ARGUMENTS.incidentID,note=ARGUMENTS.notes);
				}
				for(i=1; i LTE ArrayLen(ARGUMENTS.previousNotes); i=i+1) {
					insertUpdateIncidentNotes(id=ARGUMENTS.previousNotes[i][1],note=ARGUMENTS.previousNotes[i][2]);
				}
			</cfscript>
        <cfelse>
        	<cfquery result="qInsertIncident" datasource="#APPLICATION.DSN.Source#">
            	INSERT INTO extra_incident_report (
                	candidateID,
                    hostCompanyID,
                    userID,
                    dateIncident,
                    subject,
                    reportedBy,
                    relationshipToParticipant,
                    isSolved )
               	VALUES (
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.candidateID)#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostCompanyID)#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.dateIncident#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.subject#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.reportedBy#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.relationshipToParticipant#">,
                    <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(ARGUMENTS.isSolved)#"> )
            </cfquery>
            <cfscript>
				insertUpdateIncidentNotes(reportID=qInsertIncident.GENERATEDKEY,note=ARGUMENTS.notes);
			</cfscript>
        </cfif>
	</cffunction>
    
    <cffunction name="insertUpdateIncidentNotes" access="public" returntype="void" output="no" hint="Inserts or updates an incident note">
    	<cfargument name="id" default="0" required="no" hint="if nothing is passed in will insert, otherwise will update">
        <cfargument name="reportID" default="0" required="no" hint="needed if id is not passed in to insert">
        <cfargument name="note" default="" required="no">
        
        <cfif VAL(ARGUMENTS.id)>
        	<cfquery datasource="#APPLICATION.DSN.Source#">
            	UPDATE extra_incident_report_notes
                SET note = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#ARGUMENTS.note#">
               	WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.id#">
            </cfquery>
        <cfelse>
        	<cfquery datasource="#APPLICATION.DSN.Source#">
            	INSERT INTO extra_incident_report_notes (
                	reportID,
                    addedBy,
                    date,
                    note )
              	VALUES (
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.reportID#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                    <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#ARGUMENTS.note#"> )
            </cfquery>
        </cfif>
        
    </cffunction>
    
    <cffunction name="getIncidentSubjects" access="public" returntype="query" output="no" hint="Gets the possible subjects for an incident.">
    	<cfargument name="incidentID" default="0" required="no" hint="incidentID is not required">
        
        <cfquery name="qGetIncidentSubjects" datasource="#APPLICATION.DSN.Source#">
        	SELECT *
            FROM extra_incident_subjects
            <cfif VAL(ARGUMENTS.incidentID)>
            	WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.incidentID#">
            </cfif>
            ORDER BY subject ASC
        </cfquery>
        
        <cfreturn qGetIncidentSubjects>
    
    </cffunction>
    
	<!------------------------------------------------------------ 
		End of Candidate Incident Report 
	------------------------------------------------------------->
    
    
	<!------------------------------------------------------------
		Candidate Cultural Activity Report 
	------------------------------------------------------------->
	<cffunction name="getCulturalActivityReport" access="public" returntype="query" output="false" hint="Gets all cultural activities for a candidate">
    	<cfargument name="activityID" default="" hint="activityID is not required">
        <cfargument name="candidateID" default="" hint="candidateID is not required">
        <cfargument name="uniqueID" default="" hint="uniqueID is not required">
              
        <cfquery 
			name="qGetCulturalActivityReport" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
                	a.ID,
                    a.candidateID,
                    a.dateActivity,
                    a.details
                FROM 
                    extra_cultural_activity a
                INNER JOIN
                	extra_candidates ec ON ec.candidateID = a.candidateID                   
                WHERE
                	1 = 1 

				<cfif LEN(ARGUMENTS.activityID)>
                    AND
                        a.ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.activityID)#">
                </cfif>
                    
				<cfif LEN(ARGUMENTS.candidateID)>
                    AND
                        ec.candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.candidateID)#">
                </cfif>
                
                <cfif LEN(ARGUMENTS.uniqueID)>
                    AND
                        ec.uniqueID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.uniqueID)#">
                </cfif>
			
            ORDER BY
            	a.dateActivity DESC                
		</cfquery>
		   
		<cfreturn qGetCulturalActivityReport>
	</cffunction>
    

	<cffunction name="insertUpdateCulturalActivity" access="public" returntype="void" output="false" hint="Insert/Update Cultural Activity Information">
		<cfargument name="activityID" default="0" hint="activity ID" />
		<cfargument name="candidateID" required="yes" hint="Candidate ID is required">
        <cfargument name="userID" required="yes" hint="User entering/updating information">
        <cfargument name="date" default="" hint="date of the activity">
        <cfargument name="details" default="" hint="details - the name of the activity">
        
        <!--- Update --->
        <cfif VAL(ARGUMENTS.activityID)>
        	
            <cfquery 
                datasource="#APPLICATION.DSN.Source#">
                    UPDATE
                        extra_cultural_activity
                    SET
                        userID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#VAL(ARGUMENTS.userID)#">,
                        dateActivity = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.date#" null="#NOT IsDate(ARGUMENTS.date)#">,
                        details = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.details#">
                    WHERE
                        ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.activityID#">
                    AND
                    	candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.candidateID)#">
            </cfquery>
		
        <!--- Insert --->
        <cfelse>
        
            <cfquery 
                datasource="#APPLICATION.DSN.Source#">
                    INSERT INTO
                        extra_cultural_activity
                    (
						candidateID,
                        userID,
                        dateActivity,
                        details,
                        dateCreated                    
                    )
                    VALUES
                    (
                    	<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.candidateID)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#VAL(ARGUMENTS.userID)#">,
                    	<cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.date#" null="#NOT IsDate(ARGUMENTS.date)#">,
                    	<cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.details#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    )
            </cfquery>
        
        </cfif>
        	
	</cffunction>
	<!------------------------------------------------------------ 
		End of Candidate Cultural Activity Report 
	------------------------------------------------------------->
    
    
    <!------------------------------------------------------------ 
		Visa Interview Update Tool
	------------------------------------------------------------->
	<cffunction name="getMissingVisaInterviewStudentList" access="public" returntype="query" output="false" hint="Returns students missing visa interview list in Json format">
    	<cfargument name="intRep" default="0" hint="intRep is not required">
        <cfargument name="programID" default="0" hint="programID is not required">
        
        <cfquery name="qGetMissingVisaInterviewStudentList" datasource="#APPLICATION.DSN.Source#">
        	SELECT
            	candidate.uniqueID,
                candidate.candidateID,
                candidate.lastName,
                candidate.firstname,
                candidate.email,
                candidate.sex,
                candidate.ds2019,
                rep.businessName,
                program.programName,
                DATE_FORMAT(program.startDate,'%m/%d/%Y') AS startDate,
                DATE_FORMAT(program.endDate,'%m/%d/%Y') AS endDate,
                country.countryName
            FROM extra_candidates candidate
            INNER JOIN smg_users rep ON rep.userID = candidate.intRep
            INNER JOIN smg_programs program ON program.programID = candidate.programID
            INNER JOIN smg_countrylist country ON country.countryID = candidate.citizen_country
            WHERE candidate.status = 1
            AND candidate.isDeleted = 0
            AND candidate.applicationStatusID IN (0,11)
            AND candidate.visaInterview IS NULL
            AND candidate.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.companyID)#">
            <cfif VAL(ARGUMENTS.intRep)>
            	AND candidate.intRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.intRep)#">
            </cfif>
            <cfif VAL(ARGUMENTS.programID)>
            	AND candidate.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.programID)#">
            </cfif>
            ORDER BY candidate.lastName, candidate.firstName
		</cfquery>
		   
		<cfreturn qGetMissingVisaInterviewStudentList>
  	</cffunction>
    
    
    <cffunction name="setVisaInterviewDate" access="remote" returntype="void" hint="Updates a candidate visa interview date to today.">
        <cfargument name="candidateID" required="yes" hint="candidateID is required">
        <cfargument name="date" required="no" default="#NOW()#">

        <cfquery datasource="#APPLICATION.DSN.Source#">
                UPDATE extra_candidates
				SET visaInterview = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.date#">
                WHERE candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.candidateID#">
		</cfquery>
        
        <cfscript>
			addCandidateHistoryRecord(candidateID=ARGUMENTS.candidateID);
		</cfscript>
		   
	</cffunction>
  	<!------------------------------------------------------------ 
		End of Visa Interview Update Tool
	------------------------------------------------------------->
      

	<!------------------------------------------------------------ 
		Check-In Update Tool
	------------------------------------------------------------->
	<cffunction name="getCheckInToolStudentList" access="remote" returnFormat="json" output="false" hint="Returns verification report list in Json format">
    	<cfargument name="intRep" default="0" hint="candidateID is not required">
        <cfargument name="programID" default="0" hint="programID is not required">
        
        <cfquery 
			name="qGetCheckInToolStudentList" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
					ec.uniqueID,
                    ec.candidateID,
                    ec.firstName,
                    ec.middleName,
                    ec.lastName,
                    ec.email,
                    ec.ds2019,
                    ec.ds2019_startdate,
                    ec.us_phone,
                    ec.arrival_address,
                    ec.arrival_city,
                    ec.arrival_state,
                    ec.arrival_zip,
                    ef.departDate,
                    ef.isOvernightFlight,
					CASE 
                    	WHEN ec.sex = 'f' THEN 'female' 
                        WHEN ec.sex = 'm' THEN 'male' 
                        ELSE '' END AS sex,
                    DATE_FORMAT(ec.dob, '%m/%e/%Y') as dob,
                    DATE_FORMAT(ec.startDate, '%m/%e/%Y') as startDate,
                    DATE_FORMAT(ec.endDate, '%m/%e/%Y') as endDate,
                    IFNULL(u.businessName, '') AS businessName,
                    IFNULL(p.programName, '') AS programName,
                    IFNULL(c.countryName, '') AS countryName,
                    t.comment
                FROM extra_candidates ec
				INNER JOIN smg_users u ON u.userID = ec.intRep
                LEFT OUTER JOIN smg_programs p ON p.programID = ec.programID
				LEFT OUTER JOIN smg_countrylist c ON c.countryid = ec.residence_country  
               	LEFT OUTER JOIN extra_flight_information ef ON ef.candidateID = ec.candidateID
            		AND ef.programID = p.programID
                    AND flightType = 'Arrival'
              	LEFT OUTER JOIN extra_evaluation_tracking t ON t.id = (
                	SELECT id 
                    FROM extra_evaluation_tracking 
                    WHERE candidateID = ec.candidateID AND 
                    evaluationNumber = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
                    ORDER BY date DESC 
                    LIMIT 1)
                WHERE ec.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
                AND ec.status = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                AND ec.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">                       
				AND ec.watDateCheckedIn IS <cfqueryparam cfsqltype="cf_sql_date" null="yes"> 
                AND ec.applicationStatusID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="0,11" list="yes"> )
                
				<cfif VAL(ARGUMENTS.intRep)>
                    AND ec.intRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.intRep#">
                </cfif>

				<cfif VAL(ARGUMENTS.programID)>
                    AND ec.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.programID#">
                </cfif>
                
                <!--- For Trainee only get records with a DS2019 start date after 9/1/2013 --->
                <cfif CLIENT.companyID EQ 7>
                	AND ec.ds2019_startdate >= <cfqueryparam cfsqltype="cf_sql_date" value="2013-09-01">
                </cfif>
            GROUP BY ec.candidateID    
			ORDER BY
            	ec.lastName,
                ec.firstName
		</cfquery>
		   
		<cfreturn qGetCheckInToolStudentList>
	</cffunction>
    
    
	<cffunction name="confirmCheckInReceived" access="remote" returntype="void" hint="Updates a candidate record.">
        <cfargument name="candidateID" required="yes" hint="candidateID is required">
        <cfargument name="us_phone" default="" hint="initPhone is not required">
        <cfargument name="arrival_address" default="" hint="arrival_address is not required">
        <cfargument name="arrival_city" default="" hint="arrival_city is not required">
        <cfargument name="arrival_state" default="" hint="arrival_state is not required">
        <cfargument name="arrival_zip" default="" hint="arrival_zip is not required">

        <cfquery datasource="#APPLICATION.DSN.Source#">
                UPDATE
					extra_candidates
				SET
                	<cfif LEN(us_phone)>
                    	us_phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.us_phone#">,
                   	</cfif>
                    <cfif LEN(arrival_address)>
                    	arrival_address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.arrival_address#">,
                   	</cfif>
                    <cfif LEN(arrival_city)>
                    	arrival_city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.arrival_city#">,
                   	</cfif>
                    <cfif LEN(arrival_state)>
                    	arrival_state = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.arrival_state#">,
                   	</cfif>
                    <cfif LEN(arrival_zip)>
                    	arrival_zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.arrival_zip#">,
                   	</cfif>
                    watDateCheckedIn = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                    verification_sevis = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                WHERE
                    candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.candidateID#">
		</cfquery>
        
        <cfscript>
			addCandidateHistoryRecord(candidateID=ARGUMENTS.candidateID);
		</cfscript>
		   
	</cffunction>
	<!------------------------------------------------------------ 
		End of Check-In Update Tool
	------------------------------------------------------------->


	<!------------------------------------------------------------ 
		Monthly Evaluation Tool
	------------------------------------------------------------->
	<cffunction name="getMonthlyEvaluationList" access="remote" returnFormat="json" output="false" hint="Returns verification report list in Json format">
    	<cfargument name="intRep" default="0" hint="International Representative is not required">
        <cfargument name="programID" default="0" hint="programID is not required">
        <cfargument name="evaluationID" default="" hint="1-4: evaluation1 - evaluation4 respectively">
        <cfargument name="reportType" default="" hint="0: all, 1: warning, 2: non-compliant">
        
        <cfquery 
			name="qGetMonthlyEvaluationList" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
					ec.uniqueID,
                    ec.candidateID,
                    ec.firstName,
                    ec.middleName,
                    ec.lastName,
                    ec.email,
                    ec.us_phone AS phone,
                    ec.ds2019,
                    DATE_FORMAT(ec.watDateCheckedIn, '%m/%e/%Y') AS checkInDate,
                    ec.watDateCheckedIn,
                    IFNULL(DATE_FORMAT(ec.watDateEvaluation1, '%m/%e/%Y'), '') AS watDateEvaluation1,
                    IFNULL(DATE_FORMAT(ec.watDateEvaluation2, '%m/%e/%Y'), '') AS watDateEvaluation2,
                    IFNULL(DATE_FORMAT(ec.watDateEvaluation3, '%m/%e/%Y'), '') AS watDateEvaluation3,
                    IFNULL(DATE_FORMAT(ec.watDateEvaluation4, '%m/%e/%Y'), '') AS watDateEvaluation4,
                    DATE_FORMAT(ec.dob, '%m/%e/%Y') AS dob,
                    DATE_FORMAT(ec.startDate, '%m/%e/%Y') AS startDate,
                    DATE_FORMAT(ec.endDate, '%m/%e/%Y') AS endDate,
                    IFNULL(u.businessName, '') AS businessName,
                    IFNULL(p.programName, '') AS programName,
                    IFNULL(eh.name, '') AS hostCompanyName,
                    t.comment
                FROM 
                    extra_candidates ec
				INNER JOIN
                	smg_users u ON u.userID = ec.intRep
                LEFT OUTER JOIN
                	extra_hostcompany eh ON eh.hostCompanyID = ec.hostCompanyID
                LEFT OUTER JOIN
                	smg_programs p ON p.programID = ec.programID
              	LEFT OUTER JOIN extra_evaluation_tracking t ON t.id = (
                	SELECT id 
                    FROM extra_evaluation_tracking 
                    WHERE candidateID = ec.candidateID AND 
                    evaluationNumber = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.evaluationID#"> 
                    ORDER BY date DESC 
                    LIMIT 1)
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

				<cfif VAL(ARGUMENTS.programID)>
                    AND
                        ec.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.programID#">
                </cfif>
                
                <cfswitch expression="#ARGUMENTS.evaluationID#">
                
                	<cfcase value="1">
                    	AND
                        	ec.watDateEvaluation1 IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                      	<cfif ARGUMENTS.reportType EQ 1>
                        	AND
                        		ec.watDateCheckedIn <=  <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d',-25,NOW())#"> 
                         	AND
                            	ec.watDateCheckedIn >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d',-29,NOW())#"> 
                        <cfelseif ARGUMENTS.reportType EQ 2>
                        	AND
                        		ec.watDateCheckedIn <=  <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d',-30,NOW())#">
                        </cfif>
                    </cfcase>
                    
                    <cfcase value="2">
                    	AND
                        	ec.watDateEvaluation2 IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                      	<cfif ARGUMENTS.reportType EQ 1>
                        	AND
                        		ec.watDateCheckedIn <=  <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d',-55,NOW())#"> 
                         	AND
                            	ec.watDateCheckedIn >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d',-59,NOW())#"> 
                        <cfelseif ARGUMENTS.reportType EQ 2>
                        	AND
                        		ec.watDateCheckedIn <=  <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d',-60,NOW())#">
                        </cfif>
                    </cfcase>
                    
                    <cfcase value="3">
                    	AND
                        	ec.watDateEvaluation3 IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                       	<cfif ARGUMENTS.reportType EQ 1>
                        	AND
                        		ec.watDateCheckedIn <=  <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d',-85,NOW())#"> 
                         	AND
                            	ec.watDateCheckedIn >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d',-89,NOW())#"> 
                        <cfelseif ARGUMENTS.reportType EQ 2>
                        	AND
                        		ec.watDateCheckedIn <=  <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d',-90,NOW())#">
                        </cfif> 
                    </cfcase>
                    
                    <cfcase value="4">
                    	AND
                        	ec.watDateEvaluation4 IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                      	<cfif ARGUMENTS.reportType EQ 1>
                        	AND
                        		ec.watDateCheckedIn <=  <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d',-115,NOW())#"> 
                         	AND
                            	ec.watDateCheckedIn >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d',-119,NOW())#"> 
                        <cfelseif ARGUMENTS.reportType EQ 2>
                        	AND
                        		ec.watDateCheckedIn <=  <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d',-120,NOW())#">
                        </cfif>
                    </cfcase>
                    
                    <cfdefaultcase>
                        AND
                            (
                                ec.watDateEvaluation1 IS <cfqueryparam cfsqltype="cf_sql_date" null="yes"> 
                            OR
                                ec.watDateEvaluation2 IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                            OR
                                ec.watDateEvaluation3 IS <cfqueryparam cfsqltype="cf_sql_date" null="yes"> 
                            OR
                                ec.watDateEvaluation4 IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                            )               
                    </cfdefaultcase>
                
                </cfswitch>
                
			ORDER BY
            	ec.lastName,
                ec.firstName
		</cfquery>
		   
		<cfreturn qGetMonthlyEvaluationList>
	</cffunction>
    
    
	<cffunction name="confirmEvaluationReceived" access="remote" returntype="void" hint="Updates evaluation 1 record.">
        <cfargument name="candidateID" required="yes" hint="candidateID is required">
        <cfargument name="evaluationID" required="yes" hint="evaluationID 1 = evaluation1 | 2 = evaluation2 | 3 = evaluation3 | 4 = evaluation4">
		
        <cfscript>
			var vEvaluationField = "";
		
			// Make sure we have a valid evaluation
			if ( listFind("1,2,3,4", ARGUMENTS.evaluationID) ) {
				
				// Set which evaluation field to update
				vEvaluationField = "watDateEvaluation#ARGUMENTS.evaluationID#";
				
			}
		</cfscript>
        
        <cfif LEN(vEvaluationField)>
        
            <cfquery 
                datasource="#APPLICATION.DSN.Source#" result="test">
                    UPDATE
                        extra_candidates
                    SET
                        #vEvaluationField# = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
                    WHERE
                        candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.candidateID#">
            </cfquery>
        
        </cfif>

	</cffunction>
    
    <cffunction name="getEvaluationAnswers" access="public" returntype="query" output="no" hint="Returns Evaluation answers based on the candidate and month (0 for check in)">
    	<cfargument name="candidateID" default="0">
        <cfargument name="evaluationID" default="-1">
        
        <cfquery name="qGetEvaluations" datasource="#APPLICATION.DSN.Source#">
        	SELECT *
            FROM extra_evaluation
            WHERE 1=1
            <cfif VAL(ARGUMENTS.candidateID)>
            	AND candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.candidateID#">
          	</cfif>
            <cfif ARGUMENTS.evaluationID GTE 0>
            	AND monthEvaluation = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.evaluationID#">
          	</cfif>
        </cfquery>
        
        <cfreturn qGetEvaluations>
        
    </cffunction>
	<!------------------------------------------------------------ 
		End of Monthly Evaluation Tool
	------------------------------------------------------------->


	<!------------------------------------------------------------ 
		Candidate Profile Update Tool
	------------------------------------------------------------->
	<cffunction name="getEnglishAssessmentToolList" access="remote" returnFormat="json" output="false" hint="Returns verification report list in Json format">
		<cfargument name="keyword" default="" hint="Keyword used in search">
    	<cfargument name="intRep" default="0" hint="International Representative is not required">
        
        <cfquery 
			name="qGetEnglishAssessmentToolList" 
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
                	ec.wat_placement = <cfqueryparam cfsqltype="cf_sql_varchar" value="CSB-Placement">
                AND
		        	ec.applicationStatusID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="0,11" list="yes"> )
                AND
                	ec.englishAssessment = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
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
		   
		<cfreturn qGetEnglishAssessmentToolList>
	</cffunction>
    
    
	<cffunction name="updateEnglishAssessmentByID" access="remote" returntype="void" hint="Updates a candidate record.">
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
	<!------------------------------------------------------------ 
		End of Candidate Profile Update Tool
	------------------------------------------------------------>


	<!------------------------------------------------------------
		DS-2019 Online Verification Tool 
	------------------------------------------------------------->
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
	<!------------------------------------------------------------ 
		End of DS-2019 Online Verification Tool 
	------------------------------------------------------------>


	<!------------------------------------------------------------ 
		Trainee - Candidate Quarterly Questionnaire
	------------------------------------------------------------->
	<cffunction name="getTraineeQuarterlyReport" access="remote" returnFormat="json" output="false" hint="Returns verification report list in Json format">
    	<cfargument name="intRep" default="0" hint="International Representative is not required">
        <cfargument name="programID" default="0" hint="programID is not required">
        <cfargument name="monthEvaluation" default="" hint="monthEvaluation (2,5,8,11)">
        
        <cfquery 
			name="qGetTraineeQuarterlyReport" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
					ec.uniqueID,
                    ec.candidateID,
                    ec.firstName,
                    ec.lastName,
                    DATE_FORMAT(ec.startDate, '%m/%e/%Y') AS startDate,
                    DATE_FORMAT(ec.endDate, '%m/%e/%Y') AS endDate,
                    IFNULL(u.businessName, '') AS businessName,
                    IFNULL(p.programName, '') AS programName,
                    IFNULL(eh.name, '') AS hostCompanyName,
                    IFNULL(DATE_FORMAT(ee.dateCreated, '%m/%e/%Y'), '') AS dateSubmitted, 
                    IFNULL(DATE_FORMAT(ee.dateApproved, '%m/%e/%Y'), '') AS dateApproved                    
                FROM 
                    extra_candidates ec
				INNER JOIN
                	smg_users u ON u.userID = ec.intRep
                LEFT OUTER JOIN
                	smg_programs p ON p.programID = ec.programID
                LEFT OUTER JOIN
                	extra_hostcompany eh ON eh.hostCompanyID = ec.hostCompanyID
                LEFT OUTER JOIN extra_evaluation ee ON ee.candidateID = ec.candidateID
						AND ee.monthEvaluation = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.monthEvaluation)#">
						<!--- This makes sure that we are selecting the most recent evaluation for this month --->
						AND ee.dateCreated = (
							SELECT MAX(dateCreated) 
							FROM extra_evaluation 
							WHERE candidateID = ec.candidateID 
							AND monthEvaluation = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.monthEvaluation)#">)
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

				<cfif VAL(ARGUMENTS.programID)>
                    AND
                        ec.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.programID#">
                </cfif>
                
			ORDER BY
            	ec.lastName,
                ec.firstName
		</cfquery>
		   
		<cfreturn qGetTraineeQuarterlyReport>
	</cffunction>
    
    
	<cffunction name="confirmQuarterlyReportReceived" access="remote" returntype="void" hint="Updates quarterly report on record.">
        <cfargument name="candidateID" required="yes" hint="candidateID is required">
        <cfargument name="monthEvaluation" required="yes" hint="monthEvaluation (2,5,8,11)">
    
        <cfquery 
            datasource="#APPLICATION.DSN.Source#">
                UPDATE
                    extra_evaluation
                SET
                    dateApproved = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                WHERE
                    candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.candidateID#">
                AND
                    monthEvaluation = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.monthEvaluation#">
        </cfquery>
        		   
	</cffunction>
	<!------------------------------------------------------------ 
		End of Trainee - Candidate Quarterly Questionnaire
	------------------------------------------------------------->
    
    
    <cffunction name="getCandidateJobTitle" access="remote" returntype="query" hint="Returns candidate's job title for a given host company">
    	<cfargument name="candidateID" required="yes">
        <cfargument name="hostCompanyID" required="yes">
    
        <cfquery name="getCandidateJobTitle" datasource="#APPLICATION.DSN.Source#">
            SELECT
                ecpc.jobID,
                ej.title
            FROM
                extra_candidate_place_company ecpc
            LEFT JOIN
                extra_jobs ej
            ON
                ej.ID = ecpc.jobID
            WHERE
                candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.candidateID)#">
            AND
                ecpc.hostcompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostCompanyID)#">
        </cfquery>
        
        <cfreturn getCandidateJobTitle>
        
    </cffunction>
    
	<!--- ------------------------------------------------------------------------- ----
		Start of Remote Functions 
	----- ------------------------------------------------------------------------- --->
    
    <cffunction name="remoteLookUpCandidate" access="remote" returnFormat="json" output="false" hint="Remote function to get students, returns an array">
        <cfargument name="searchString" type="string" default="" hint="Search is not required">
        <cfargument name="maxRows" type="numeric" required="false" default="30" hint="Max Rows is not required" />
        <cfargument name="companyID" default="#CLIENT.companyID#" hint="CompanyID is not required">
        
        <cfscript>
			var vReturnArray = arrayNew(1);
		</cfscript>
        
        <cfquery 
			name="qRemoteLookUpCandidate" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT 
                	candidateID,
                    uniqueID,
                    ds2019,
					CAST( CONCAT(lastName, ', ', firstName, ' (##', candidateID, ')' ) AS CHAR) AS displayName
                FROM 
                	extra_candidates
                
                WHERE 
                    programid != <cfqueryparam cfsqltype="cf_sql_integer" value="0">                

                    AND          
                        companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 

				<cfif IsNumeric(ARGUMENTS.searchString)>
                    AND
                    	(
                        	candidateID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.searchString#%">
                        OR
                        	ds2019 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ARGUMENTS.searchString#%">
                        )
                <cfelse>
                    AND 
                    	(
                        	lastName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.searchString#%">
	                    OR
    	                	firstName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.searchString#%">
                        OR
                        	ds2019 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ARGUMENTS.searchString#%">
        				)
                </cfif>				
				
                ORDER BY 
                    lastName,
                    firstName

				LIMIT 
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.maxRows#" />  
        </cfquery>

		<cfscript>
			// Loop through query
            For ( i=1; i LTE qRemoteLookUpCandidate.recordCount; i=i+1 ) {

				vStudentStruct = structNew();
				vStudentStruct.candidateID = qRemoteLookUpCandidate.candidateID[i];
				vStudentStruct.uniqueID = qRemoteLookUpCandidate.uniqueID[i];
				vStudentStruct.displayName = qRemoteLookUpCandidate.displayName[i];
				
				ArrayAppend(vReturnArray,vStudentStruct);
            }
			
			return vReturnArray;
        </cfscript>

    </cffunction> 
    
	<!--- ------------------------------------------------------------------------- ----
		End of Remote Functions 
	----- ------------------------------------------------------------------------- --->

	<cffunction name="setEvaluationTracking" access="public" returntype="void" output="no">
    	<cfargument name="candidateID" type="numeric" required="yes">
        <cfargument name="evaluationNumber" type="numeric" required="yes">
        <cfargument name="date" default="#NOW()#" required="no">
        <cfargument name="comment" default="" required="no">
        
        <cfquery datasource="#APPLICATION.DSN.Source#">
            INSERT INTO extra_evaluation_tracking (
                candidateID,
                evaluationNumber,
                date,
                comment )
            VALUES (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.candidateID)#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.evaluationNumber)#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.date#">,
                <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#ARGUMENTS.comment#"> )
        </cfquery>
    </cffunction>

</cfcomponent>