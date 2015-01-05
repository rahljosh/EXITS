<!--- ------------------------------------------------------------------------- ----
	
	File:		onlineApp.cfc
	Author:		Marcus Melo
	Date:		August 25, 2010
	Desc:		This holds the functions needed for the online application module

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="onlineApp"
	output="false" 
	hint="A collection of functions for the Online Application module">


	<!--- Return the initialized OnlineApp object --->
	<cffunction name="Init" access="public" returntype="onlineApp" output="No" hint="Returns the initialized OnlineApp object">

		<cfscript>
			// Return this initialized instance
			return(this);
		</cfscript>

	</cffunction>


	<!--- Login --->
	<cffunction name="doLogin" access="public" returntype="void" hint="Logs in a candidate">
		<cfargument name="candidateID" type="numeric" default="0">
        <cfargument name="updateDateLastLoggedIn" type="numeric" default="1">
		
        <cfscript>
			// Set Candidate Session Variables  (candidateID / firstName / lastname / lastLoggedInDate / myUploadFolder )
			APPLICATION.CFC.CANDIDATE.setCandidateSession(candidateID=ARGUMENTS.candidateID);
			
			// Record last logged in date
			if ( VAL(ARGUMENTS.updateDateLastLoggedIn) ) {
				APPLICATION.CFC.CANDIDATE.updateLoggedInDate(candidateID=ARGUMENTS.candidateID);
			}
		</cfscript>
        
	</cffunction>


	<!--- Current Logged In --->
	<cffunction name="isCurrentUserLoggedIn" output="false" access="public" returntype="boolean"  description="Returns whether or not user is logged in">
		
        <cfscript>
			 if ( structkeyexists(SESSION,"CANDIDATE") AND VAL(SESSION.CANDIDATE.isLoggedIn) AND VAL(SESSION.CANDIDATE.ID) ) {
				return true;
			 } else {
				return false;				 
			 }
		</cfscript>
        	
	</cffunction>
	
    
	<!--- Logout --->
	<cffunction name="doLogout" access="public" returntype="void" hint="Logs out a candidate from the Online Application">

		<cfscript>
			// Re-set customer session variables 
			SESSION.CANDIDATE.ID = 0;
			SESSION.CANDIDATE.isLoggedIn = 0;
		</cfscript>
        
	</cffunction>


	<cffunction name="setLoginLinks" access="public" returntype="string" hint="Returns the link according to the user/candidate company.">
        <cfargument name="companyID" type="numeric" required="yes" hint="User/Candidate is required">
		<cfargument name="loginType" type="string" required="yes" hint="User/Candidate is required">
		
		<cfscript>
			var applicationFolder = '';
		
			if ( ARGUMENTS.loginType EQ 'candidate' ) {
				applicationFolder = 'onlineApplication/';
			}
			
			// SET LINKS                    
			switch(ARGUMENTS.companyID) {
				// Trainee
				case 7: {
					APPLICATION.applicationID = 5;
					APPLICATION.foreignTable = 'extra_candidates';
					return("internal/trainee/" & applicationFolder & "index.cfm");
					break;
				}
				// Work and Travel
				case 8: {
					APPLICATION.applicationID = 4;
					APPLICATION.foreignTable = 'extra_candidates';
					return("internal/wat/" & applicationFolder & "index.cfm");
					break;
				}
				// H2B
				case 9: {
					// APPLICATION.applicationID = 6;
					APPLICATION.foreignTable = 'extra_candidates';
					return("internal/h2b/" & applicationFolder & "index.cfm");
					break;
				}
				default: {
					return("index.cfm");
					break;
				}
			}
			
			// Once more of site is complete, change this to an appropriate welcome page.
			// location("internal/index.cfm?curdoc=initial_welcome", "no");
		</cfscript>
        
	</cffunction>


	<!--- Check if Password is valid --->
	<cffunction name="isValidPassword" access="public" returntype="struct" hint="Determines if the password is of valid format">
		<cfargument name="Password" type="string" required="Yes" />

        <cfscript>
			/* Password Policy
			   Must have at least 8 characters in length
			   Must have at least 1 number
			   Must have at least 1 uppercase letter
			   Must have at least 1 lower case letter */

			var stResults = StructNew();			
			stResults.isValidPassword = true;
			stResults.Errors = '';
			
			// Check Minimum Characters
			if ( LEN(ARGUMENTS.password) LT 8 ) {
				stResults.isValidPassword = false;
				stResults.Errors = stResults.Errors & 'The minimum password lenght is 8 characters. <br />';		
			}

			// Check Maximum Characters
			if ( LEN(ARGUMENTS.password) GT 20 ) {
				stResults.isValidPassword = false;
				stResults.Errors = stResults.Errors & 'The maximum password lenght is 20 characters. <br />';					
			}
			
			// Check for valid characters
			if (REFindNoCase("[^0-9a-zA-Z\~\!\@\$\$\%\^\&\*]{1,}", ARGUMENTS.Password)){
				stResults.isValidPassword = false;
				stResults.Errors = stResults.Errors & 'Password contains an invalid character. <br />';					
			}
			
			return stResults;
		</cfscript>
               
	</cffunction>
	

    <!--- Generates a Password --->
	<cffunction name="generatePassword" access="public" returntype="string" hint="Generates a 8 characters random password">
		
        <cfscript>
			/***  ***/
			/* Password Policy
			   Must have at least 8 characters in length
			   Must have at least 1 number
			   Must have at least 1 uppercase letter
			   Must have at least 1 lower case letter */
		
			// Set up available lower case values.
			strLowerCaseAlpha = "abcdefghijklmnopqrstuvwxyz";
			
			// Set up available upper case values
			strUpperCaseAlpha = UCase( strLowerCaseAlpha );
			
			// Set up available numbers
			strNumbers = "0123456789";
	
			// Set up additional valid password chars
			strOtherChars = "~!@##$%^&*";
			
			// Concatenate all the previous valid character sets
			strAllValidChars = ( strLowerCaseAlpha & strUpperCaseAlpha & strNumbers & strOtherChars );
			
			// Create an array to contain the password ( think of a string as an array of character).
			arrPassword = ArrayNew( 1 );
			
			// Select the random number from our number set.
			arrPassword[ 1 ] = Mid(strNumbers, RandRange( 1, Len( strNumbers ) ), 1);	

			// Select the random letter from our lower case set.
			arrPassword[ 2 ] = Mid( strLowerCaseAlpha, RandRange( 1, Len( strLowerCaseAlpha ) ), 1 );
			
			// Select the random letter from our upper case set.
			arrPassword[ 3 ] = Mid( strUpperCaseAlpha, RandRange( 1, Len( strUpperCaseAlpha ) ), 1 );	
			
			//Create rest of the password
			For (i=(ArrayLen( arrPassword ) + 1);i LTE 8; i=i+1) {
				arrPassword[ i ] = Mid( strAllValidChars, RandRange( 1, Len( strAllValidChars ) ), 1 );
			}
			
			// Java Collections utility class to shuffle this array into a "random" order
			CreateObject( "java", "java.util.Collections" ).Shuffle(arrPassword);
			
			// converting the array to a list and then just providing no delimiters (empty string delimiter).
			strPassword = ArrayToList(arrPassword, "" );
			
			return strPassword;
    	</cfscript>
    
    </cffunction>


	<cffunction name="getApplicationStatus" access="public" returntype="query" output="false" hint="Returns a list with Application questions">
		<cfargument name="applicationID" type="numeric" required="yes" hint="Application ID" />
		
		<cfquery 
			name="qGetApplicationStatus" 
			datasource="#APPLICATION.DSN.Source#">
				SELECT
					ID, 
					statusID,
                    applicationID,
                    name,
                    description,
                    isDeleted,
                    dateCreated,
                    dateUpdated
				FROM
					applicationstatus
				WHERE
	                applicationID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.applicationID#">
				AND
                	isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                ORDER BY
                	statusID                    
		</cfquery>
		
		<cfreturn qGetApplicationStatus /> 
	</cffunction>


	<cffunction name="getApplicationStatusByID" access="public" returntype="query" output="false" hint="Returns a list with Application questions">
		<cfargument name="statusID" type="numeric" required="yes" hint="status ID" />
		
		<cfquery 
			name="qGetApplicationStatusByID" 
			datasource="#APPLICATION.DSN.Source#">
				SELECT
					ID, 
					statusID,
                    applicationID,
                    name,
                    description,
                    isDeleted,
                    dateCreated,
                    dateUpdated
				FROM
					applicationstatus
				WHERE
	                statusID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.statusID#">
		</cfquery>
		
		<cfreturn qGetApplicationStatusByID /> 
	</cffunction>


	<!--- Submit Application --->
	<cffunction name="whoIsSubmittingApplication" access="public" returntype="struct" output="false" hint="Sets the current user that is submitting the application">
    
    	<cfscript>
			var result = StructNew();
    
			// Set who is submitting the application (candidate/branch or intl. rep)
			if ( CLIENT.loginType NEQ 'user' ) {
				// Candidate is submitting the application
				result.foreignTable=APPLICATION.foreignTable;
				result.foreignID=APPLICATION.CFC.CANDIDATE.getCandidateID();
			} else {
				// Branch or Intl. Rep. is submitting the application	
				result.foreignTable='smg_users';
				result.foreignID=CLIENT.userID;
			}
			
			return result;
		</cfscript>			
	</cffunction>


	<!--- Submit Application --->
	<cffunction name="submitApplication" access="public" returntype="void" output="false" hint="Submit Application">
		<cfargument name="candidateID" required="yes" hint="candidateID is required">
        <cfargument name="submissionType" default="" hint="received,onhold,approved,denied">
        <cfargument name="comments" default="" hint="Comments by submitting user">
        		
        <cfscript>
			// Get Current Status
			var currentApplicationStatusID = APPLICATION.CFC.CANDIDATE.getCandidateSession().applicationStatusID;

			// Set New Status as Current Status
			var newApplicationStatusID = currentApplicationStatusID;
			
			// Get who is submitting the application
			var setSubmittedBy = whoIsSubmittingApplication();
			
			// Stores the email template
			var emailTemplate = '';

			// Get Intl. Rep. Information
			qGetIntlRep = APPLICATION.CFC.USER.getUserByID(userID=APPLICATION.CFC.CANDIDATE.getCandidateSession().intlRepID);

			// Set Next Status               
			switch(currentApplicationStatusID) {
				
				// Application Issued - Student can activate application
				case 1: {
					
					// Application activated by candidate
					newApplicationStatusID = 2;
					// Set Email Template
					emailTemplate = 'activateAccount';
					/*** 
						Set extra_candidates as the foreignTable. Candidates alwayas activate themselves.
						These are defined in the internal/wat/application.cfm since we are calling from / we need to set them.
					***/
					APPLICATION.applicationID = 4;
					APPLICATION.foreignTable = 'extra_candidates';
					setSubmittedBy.foreignTable = 'extra_candidates';
					ARGUMENTS.comments = getApplicationStatusByID(statusID=newApplicationStatusID).description;
					break;
				}
				
				// Application Active - Student can submit the application to branch or Intl. Rep.
				case 2: {
					
					if ( VAL(APPLICATION.CFC.CANDIDATE.getCandidateSession().branchID) ) {
						// application submitted by candidate to branch
						newApplicationStatusID = 3;			
					} else {
						// application submitted by candidate to Intl. Rep.
						newApplicationStatusID = 5;
					}
					// Set Email Template
					emailTemplate = 'submittedByCandidate';
					break;		
				}
				
				// Application Submitted by Student to Branch - Branch can approve/deny the application
				case 3: {
					
					if ( ARGUMENTS.submissionType EQ 'approved' ) {
						// Application approved by branch
						newApplicationStatusID = 5;		
						// Set Email Template
						emailTemplate = 'approvedByBranch';
					} else if ( ARGUMENTS.submissionType EQ 'denied' ) {
						// Application denied by branch
						newApplicationStatusID = 4;		
						// Set Email Template
						emailTemplate = 'deniedByBranch';
					}
					break;
				}
				
				// Application Denied by Branch - Student can re-submit the application
				case 4: {
					
					// Application re-submitted by candidate
					newApplicationStatusID = 3;		
					// Set Email Template
					emailTemplate = 'submittedByCandidate';
					break;
				}
				
				// Application Submitted by candidate/branch to Intl. Rep. - Intl. Rep. can approve/deny the application
				case 5: {
				
					if ( ARGUMENTS.submissionType EQ 'approved' ) {
						// Application approved by Intl. Rep.
						newApplicationStatusID = 7;		
						// Set Email Template
						emailTemplate = 'approvedByIntlRep';
					} else if ( ARGUMENTS.submissionType EQ 'denied' ) {
						// Application denied by Intl. Rep.
						newApplicationStatusID = 6;	
						// Set Email Template
						emailTemplate = 'deniedByIntlRep';
					}
					break;
				}
				
				// Application Denied By Intl. Rep. - Student can re-submit the application - Branch can re-approve/deny the application
				case 6: {
					
					// Student can re-submit, branch could deny/re-submit application
					if ( VAL(APPLICATION.CFC.CANDIDATE.getCandidateSession().branchID) ) {

						if ( ARGUMENTS.submissionType EQ 'approved' ) {
							// Application re-submitted by branch
							newApplicationStatusID = 5;		
							// Set Email Template
							emailTemplate = 'approvedByBranch';
						} else if ( ARGUMENTS.submissionType EQ 'denied' ) {
							// Application denied by branch
							newApplicationStatusID = 4;		
							// Set Email Template
							emailTemplate = 'deniedByBranch';
						}

					} else {
						
						// Application re-submitted by candidate
						newApplicationStatusID = 5;		
						// Set Email Template
						emailTemplate = 'submittedByCandidate';
					}
					break;
				}
				
				// Application Submitted by Intl. Rep. - NY Office can receive, put on hold, approve/deny the application
				case 7: {
					
					if ( ARGUMENTS.submissionType EQ 'received' ) {
						// Application received by NY office
						newApplicationStatusID = 8;		
						// Set Email Template
						emailTemplate = 'receivedByOffice';						
					} else if ( ARGUMENTS.submissionType EQ 'onhold' ) {
						// Application onhold by NY office
						newApplicationStatusID = 10;		
						// Set Email Template
						emailTemplate = 'onHoldByOffice';
					} else if ( ARGUMENTS.submissionType EQ 'approved' ) {
						// Application denied by NY office
						newApplicationStatusID = 11;		
						// Set Email Template
						emailTemplate = 'approvedByOffice';
					} else if ( ARGUMENTS.submissionType EQ 'denied' ) {
						// Application denied by NY office
						newApplicationStatusID = 9;		
						// Set Email Template
						emailTemplate = 'deniedByOffice';
					}
					break;
				}
				
				// Application Received By NY Office - NY office can put on hold, approve/deny the application
				case 8: {
					
					if ( ARGUMENTS.submissionType EQ 'onhold' ) {
						// Application onhold by NY office
						newApplicationStatusID = 10;	
						// Set Email Template
						emailTemplate = 'onHoldByOffice';
					} else if ( ARGUMENTS.submissionType EQ 'approved' ) {
						// Application denied by NY office
						newApplicationStatusID = 11;	
						// Set Email Template
						emailTemplate = 'approvedByOffice';
					} else if ( ARGUMENTS.submissionType EQ 'denied' ) {
						// Application denied by NY office
						newApplicationStatusID = 9;	
						// Set Email Template
						emailTemplate = 'deniedByOffice';
					}
					break;
				}
				
				// Application Denied By NY Office - Intl. Rep. can re-submit or deny the application
				case 9: {
					
					if ( ARGUMENTS.submissionType EQ 'approved' ) {
						// Application denied by NY office
						newApplicationStatusID = 7;		
						// Set Email Template
						emailTemplate = 'approvedByIntlRep';
					} else if ( ARGUMENTS.submissionType EQ 'denied' ) {
						// Application denied by NY office
						newApplicationStatusID = 6;	
						// Set Email Template
						emailTemplate = 'deniedByIntlRep';
					}
					break;
				}
				
				// Application On Hold By NY Office - NY office can approve/deny the application
				case 10: {
					
					if ( ARGUMENTS.submissionType EQ 'approved' ) {
						// Application denied by NY office
						newApplicationStatusID = 11;	
						// Set Email Template
						emailTemplate = 'approvedByOffice';
					} else if ( ARGUMENTS.submissionType EQ 'denied' ) {
						// Application denied by NY office
						newApplicationStatusID = 9;		
						// Set Email Template
						emailTemplate = 'deniedByOffice';
					}
					break;
				}
				
				// Approved By NY Office
				case 11: {
					// Do Nothing
					break;
				}
				
				default: {
					// Do Nothing
					break;
				}
			}
			
			/* Debug
			writedump(currentApplicationStatusID);
			writedump(newApplicationStatusID);
			writedump(emailTemplate);
			abort;
			*/

			// Check if we are updating the status of the application
			if ( currentApplicationStatusID NEQ newApplicationStatusID ) {
				
				// Update Candidate Status
				APPLICATION.CFC.CANDIDATE.updateApplicationStatus(
					candidateID=ARGUMENTS.candidateID,
					applicationStatusID=newApplicationStatusID
				);
			
				// Insert Application History
				insertApplicationHistory(
					applicationID=APPLICATION.applicationID,
					applicationStatusID=newApplicationStatusID,
					foreignTable=APPLICATION.foreignTable,
					foreignID=ARGUMENTS.candidateID,
					submittedByForeignTable=setSubmittedBy.foreignTable,
					submittedByforeignID=setSubmittedBy.foreignID,
					comments=ARGUMENTS.comments
				);
				
				// Email the candidate
				if ( ListFind("1,2,3,4,6", newApplicationStatusID) ) {
				
					APPLICATION.CFC.email.sendEmail(
						emailTo=APPLICATION.CFC.CANDIDATE.getCandidateSession().email,
						emailTemplate=emailTemplate,
						candidateID=ARGUMENTS.candidateID,
						companyID=APPLICATION.CFC.CANDIDATE.getCandidateSession().companyID
					);
				
				}
				
				// Email Branch - No need for now
				
				// Email Intl. Rep.
				if ( ListFind("7,9,10,11", newApplicationStatusID) ) {
					
					APPLICATION.CFC.email.sendEmail(
						emailTo=qGetIntlRep.email,
						emailTemplate=emailTemplate,
						candidateID=ARGUMENTS.candidateID,
						companyID=APPLICATION.CFC.CANDIDATE.getCandidateSession().companyID
					);
				
				}

				// Email Admissions Office - No need for now
				
			}
		</cfscript>
		
	</cffunction>


	<!--- Save application to a zip file --->
	<cffunction name="saveApplicationToZip" access="public" returntype="string" hint="Saves application in ZIP format and returns file path">
		<cfargument name="candidateID" type="numeric" required="yes" hint="Candidate ID is required">
        
        <cfscript>
			// Get Candidate Information	
			var qGetCandidateInfo = APPLICATION.CFC.CANDIDATE.getCandidateByID(ID=ARGUMENTS.candidateID);

			// Get Candidate Documents
			var qGetDocuments = APPLICATION.CFC.DOCUMENT.getDocuments(foreignTable=APPLICATION.foreignTable, foreignID=ARGUMENTS.candidateID);

			var pdfPath = APPLICATION.PATH.uploadDocumentTemp & '##' & qGetCandidateInfo.ID & qGetCandidateInfo.firstName & qGetCandidateInfo.lastName & '-Application.pdf';

			var zipPath = APPLICATION.PATH.uploadDocumentTemp &  '##' & qGetCandidateInfo.ID & qGetCandidateInfo.firstName & qGetCandidateInfo.lastName & '-ApplicationFiles.zip';
			
			// Remove watermark
        	var printApplicationAdmissions = 1;
        </cfscript>
                        
        <cftry>
        
			<!--- Include Print Application File --->
            <cfinclude template="../../admissions/_printApplication.cfm">
            
            <!--- At this point we should have a variable called printPDFApplication / Save the file in a temp folder --->
            
            <!--- Create a PDF document in the temp folder --->
            <cffile 
                action="write"
                file="#pdfPath#"
                output="#printPDFApplication#"
                nameconflict="overwrite">
            
            <!--- Create a ZIP file and include application in pdf format --->        
            <cfzip 
                action="zip" 
                source="#pdfPath#"  
                file="#zipPath#"> 
            
            <!--- Insert Uploaded Files to Zip File --->
            <cfloop query="qGetDocuments">
                
                <cfzip 
                    action="zip" 
                    source="#qGetDocuments.location##qGetDocuments.fileName#"  
                    file="#zipPath#"> 
            
            </cfloop>
        
	        <cfcatch type="any">
            	<!--- Catch Errors / Return file path --->
            </cfcatch>
        
        </cftry>
        
		<cfreturn zipPath>
	</cffunction>


    <!--- Insert Application History --->
	<cffunction name="insertApplicationHistory" access="public" returntype="void" output="false" hint="Inserts a record into candidateApplicationStatusJN">
    	<cfargument name="applicationID" type="numeric" required="yes" hint="applicationID is required" />
		<cfargument name="applicationStatusID" type="numeric" required="yes" hint="applicationStatusID is required" />		
        <cfargument name="foreignTable" type="string" required="yes" hint="User/Candidate is updating status - is required." />	
        <cfargument name="foreignID" type="numeric" required="yes" hint="ID of user/candidate updating status - is required" />		
        <cfargument name="submittedByForeignTable" type="string" required="yes" hint="User/Candidate is updating status - is required." />	
        <cfargument name="submittedByForeignID" type="numeric" required="yes" hint="ID of user/candidate updating status - is required" />		
        <cfargument name="comments" type="string" default="" hint="Comments is not required" />

		<cfquery 
			datasource="#APPLICATION.DSN.Source#">
				INSERT INTO
                	applicationstatusjn
                (
                	applicationID,
                    applicationStatusID,
                    <!--- sessionInformationID, --->
                    foreignTable,
                    foreignID,
                    submittedByForeignTable,
                    submittedByForeignID,
                    comments,
                	dateCreated
                )
                VALUES 
                (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.applicationID)#">,	
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.applicationStatusID)#">,	
					<!--- <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(SESSION.informationID)#">, --->	
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.foreignTable#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.foreignID)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.submittedByForeignTable#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.submittedByForeignID)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.comments#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                )
        </cfquery>        
        
	</cffunction>


    <!--- Get Application History --->
	<cffunction name="getApplicationHistory" access="public" returntype="query" output="false" hint="Gets application status history">
		<cfargument name="applicationStatusID" type="numeric" default="0" hint="applicationStatusID is NOT required" />		
        <cfargument name="foreignTable" type="string" required="yes" hint="User/Candidate is updating status - is required." />	
        <cfargument name="foreignID" type="numeric" required="yes" hint="ID of user/candidate updating status - is required" />		

		<cfquery 
        	name="qGetApplicationHistory"
			datasource="#APPLICATION.DSN.Source#">
				SELECT
                	apsJN.ID,
                	apsJN.applicationStatusID,
                    apsJN.sessionInformationID,
                    apsJN.foreignTable,
                    apsJN.foreignID,
                    apsJN.submittedByForeignTable,
                    apsJN.submittedByForeignID,
                    apsJN.comments,
                	apsJN.dateCreated,
                    apsJN.dateUpdated,
                    aps.name,
                    aps.description
				FROM	
                	applicationstatusjn apsJN
                LEFT OUTER JOIN
                	applicationstatus aps ON aps.statusID = apsJN.applicationStatusID
				WHERE
                	apsJN.foreignTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.foreignTable#">
                AND
					apsJN.foreignID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.foreignID)#">
				<cfif VAL(ARGUMENTS.applicationStatusID)>                
                    AND
                        apsJN.applicationStatusID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.applicationStatusID)#">
				</cfif>
				ORDER BY
                	apsJN.dateCreated DESC                    
        </cfquery>        
        
        <cfreturn qGetApplicationHistory>
	</cffunction>


	<cffunction name="isOfficeApplication" access="public" returntype="numeric" output="false" hint="Returns yes/no if application is being filled out by Intl. Rep.">
        <cfargument name="foreignTable" type="string" required="yes" hint="User/Candidate is updating status - is required." />	
        <cfargument name="foreignID" type="numeric" required="yes" hint="ID of user/candidate updating status - is required" />		
		
		<cfquery 
        	name="qGetIsOfficeApplication"
			datasource="#APPLICATION.DSN.Source#">
				SELECT
                	apsJN.ID,
                	apsJN.applicationStatusID,
                    apsJN.sessionInformationID,
                    apsJN.foreignTable,
                    apsJN.foreignID,
                    apsJN.submittedByForeignTable,
                    apsJN.submittedByForeignID,
                    apsJN.comments,
                	apsJN.dateCreated,
                    apsJN.dateUpdated,
                    aps.name,
                    aps.description
				FROM	
                	applicationstatusjn apsJN
                LEFT OUTER JOIN
                	applicationstatus aps ON aps.statusID = apsJN.applicationStatusID
				WHERE
                	apsJN.foreignTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.foreignTable#">
                AND
					apsJN.foreignID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.foreignID)#">
				AND
                	apsJN.applicationStatusID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2" list="yes"> )
                ORDER BY
                	apsJN.dateCreated DESC                    
        </cfquery>        
		
        <cfscript>
			if ( qGetIsOfficeApplication.recordCount ) {
				return 0;
			} else {
				return 1;
			}
		</cfscript>        
	</cffunction>


	<!--- Get Online Application Question --->
	<cffunction name="getQuestionByAppID" access="public" returntype="query" output="false" hint="Returns a list with Application questions">
		<cfargument name="applicationID" type="numeric" required="yes" hint="Application ID" />
		
		<cfquery 
			name="qGetQuestionByAppID" 
			datasource="#APPLICATION.DSN.Source#">
				SELECT
					ID, 
					applicationID,
                    fieldKey,
                    displayField,
                    sectionName,
                    orderKey,
                    classType,
                    requiredMessage,
                    isRequired,
                    isDeleted,
                    dateCreated,
                    dateUpdated
				FROM
					applicationquestion
				WHERE
	                applicationID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.applicationID#">
				AND
                	isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                ORDER BY
                	<!--- Keep the same order as getAnswerByFilter --->
                	sectionName,
                    orderKey                    
		</cfquery>
		
		<cfreturn qGetQuestionByAppID /> 
	</cffunction>


	<!--- Get Online Application Question By Field --->
	<cffunction name="getQuestionByFilter" access="public" returntype="query" output="false" hint="Query of queries. Returns an application question by field.">
		<cfargument name="fieldKey" type="string" default="" hint="Field Key" />
        <cfargument name="sectionName" type="string" default="" hint="Section name" />

		<cfscript>
			try {
				 // Check if we have a query in the application scope, if not store the query.
				var getQuery = APPLICATION.QUERY.qGetCandidateQuestion;
			} catch (Any e) {
				// Set Query
				APPLICATION.QUERY.qGetCandidateQuestion = getQuestionByAppID(applicationID=APPLICATION.applicationID);
			}
			
			if ( NOT VAL(APPLICATION.QUERY.qGetCandidateQuestion.recordCount) ) {
				// Set Query
				APPLICATION.QUERY.qGetCandidateQuestion = getQuestionByAppID(applicationID=APPLICATION.applicationID);
			}			
		</cfscript>

		<cfquery  
			name="qGetQuestionByFilter" 
			dbtype="query">
				SELECT
					*
				FROM
					APPLICATION.QUERY.qGetCandidateQuestion
				WHERE
	                1 = 1
                
				<cfif LEN(ARGUMENTS.fieldKey)>    
                	AND
	                    fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.fieldKey#">                				
				</cfif>
                
                <cfif LEN(ARGUMENTS.sectionName)>    
                	AND
	                    sectionName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.sectionName#">                				
				</cfif>
		</cfquery>
		
		<cfreturn qGetQuestionByFilter /> 
	</cffunction>


	<!--- Get Online Application Answer --->
	<cffunction name="getAnswerByFilter" access="public" returntype="query" output="false" hint="Returns a list with Application Answers">
        <cfargument name="sectionName" type="string" default="" hint="Section name" />
        <cfargument name="foreignTable" type="string"  default="" hint="Name of the Table">
		<cfargument name="foreignID" type="numeric" default="0" hint="This could be a candidate or host family ID">
        <cfargument name="applicationQuestionID" default="0" hint="Application Question ID" />
		
		<cfquery 
			name="qGetAnswerByFilter" 
			datasource="#APPLICATION.DSN.Source#">
				SELECT
					aa.ID, 
					aa.applicationQuestionID,
                    aa.foreignID,
                    aa.fieldKey,
                    aa.answer,
                    aa.dateCreated,
                    aa.dateUpdated
				FROM
					applicationanswer aa
                RIGHT OUTER JOIN
                	applicationquestion aq ON aa.applicationQuestionID = aq.ID
				WHERE
	                aq.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">

					<cfif VAL(ARGUMENTS.foreignTable)>
						AND
    	                    aa.foreignTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.foreignTable#">
					</cfif>
                    
					<cfif VAL(ARGUMENTS.foreignID)>
						AND
    	                    aa.foreignID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.foreignID#">
					</cfif>
                    
                    <cfif VAL(ARGUMENTS.applicationQuestionID)>
						AND
    	                    aa.applicationQuestionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.applicationQuestionID#">
					</cfif>
                    
					<cfif LEN(ARGUMENTS.sectionName)>    
                        AND
                            aq.sectionName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.sectionName#">                				
                    </cfif>

        		ORDER BY
                	<!--- Keep the same order as getQuestionByFilter --->
                    aq.sectionName,
                    aq.orderKey                    
		</cfquery>
		
		<cfreturn qGetAnswerByFilter /> 
	</cffunction>


	<cffunction name="insertAnswer" access="public" returntype="void" output="false" hint="Inserts/Updates an application answer">
        <cfargument name="applicationQuestionID" default="0" hint="Application Question ID" />
        <cfargument name="foreignTable" type="string" required="yes" hint="Name of the Table">
		<cfargument name="foreignID" type="numeric" required="yes" hint="This could be a candidate or host family ID">
        <cfargument name="fieldKey" hint="Field Key" />
        <cfargument name="answer" default="" hint="Application Asnwer" />
        
        <cfscript>
			// Check if we need to update or insert an answer
			qCheckAnswer = getAnswerByFilter(
				applicationQuestionID=ARGUMENTS.applicationQuestionID,
				foreignTable=ARGUMENTS.foreignTable,
				foreignID=ARGUMENTS.foreignID
			);
		</cfscript>
        
        <!--- Check if we need to insert or update the record --->
        <cfif qCheckAnswer.recordCount>
        
        	<!--- Update --->
            <cfquery 
                datasource="#APPLICATION.DSN.Source#">
					UPDATE
						applicationanswer
                    SET
                    	answer = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.answer)#">
					WHERE
                        ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#qCheckAnswer.ID#">
            </cfquery>                        
        
        <cfelse>
        	
            <!--- Insert --->
            <cfquery 
                datasource="#APPLICATION.DSN.Source#">
                    INSERT INTO
                    	applicationanswer
                    (
						applicationQuestionID,
                        foreignTable,
                        foreignID,
                        fieldKey,
                        answer,
                        dateCreated
					)
                    VALUES
                    (
						<cfqueryparam cfsqltype="cf_sql_integer" value="#TRIM(ARGUMENTS.applicationQuestionID)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.foreignTable)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#TRIM(ARGUMENTS.foreignID)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.fieldKey)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.answer)#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    )                        
            </cfquery>
            
        </cfif>
		
	</cffunction>

	
    <!--- Check Required Section Fields --->
	<cffunction name="checkRequiredSectionFields" access="public" returntype="struct" output="false" hint="Check if required fields were answered">
        <cfargument name="sectionName" type="string" required="yes" hint="Section name" />
        <cfargument name="foreignTable" type="string" required="yes" hint="Name of the Table">
		<cfargument name="foreignID" type="numeric" required="yes" hint="This could be a candidate or host family ID">
        
        <cfscript>
			// Declare structure
			var stRequiredFields = StructNew();	
			
			// List of query fields
			var queryFieldList = '';
			
			// Create an array and populate with the field name in case we need to display missing items
			stRequiredFields.fieldList = ArrayNew(1);

			// Set complete = 1
			stRequiredFields.isComplete = 1;
		</cfscript>
        
		<cfquery  
			name="qCheckRequiredSectionFields" 
			datasource="#APPLICATION.DSN.Source#">
				SELECT
                    displayField,
                    sectionName
				FROM
					applicationquestion aq
				WHERE
                    sectionName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.sectionName#">    
                AND	
                	isRequired = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                AND
                	isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                AND
                	ID NOT IN 
                    (
                    	SELECT 
                        	applicationQuestionID 
                        FROM 
                        	applicationanswer 
                        WHERE 
                            foreignTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.foreignTable#">    
                        AND	
                            foreignID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.foreignID#">
						AND                                    
                        	LENGTH(answer) >= <cfqueryparam cfsqltype="cf_sql_integer" value="1">
					)                            
		</cfquery>
        
        <cfscript>
			if (qCheckRequiredSectionFields.recordCount) {
				
				// Set setion as not completed
				stRequiredFields.isComplete = 0;

				// Get all the missing items in a list
				queryFieldList = ValueList(qCheckRequiredSectionFields.displayField);

				// Store The List into an Array
				stRequiredFields.fieldList = ListToArray(queryFieldList);
			}
			
			// Section 3 is filled out by the Intl. Rep/Branch - Set them as complete if candidate is logged in
			if ( ARGUMENTS.sectionName EQ 'section3' AND CLIENT.loginType NEQ 'user' ) {
				
				// Create an array and populate with the field name in case we need to display missing items
				stRequiredFields.fieldList = ArrayNew(1);

				// Set complete = 1
				stRequiredFields.isComplete = 1;
			}
			
			// Return Structure
			return stRequiredFields;
		</cfscript>
        
	</cffunction>


</cfcomponent>