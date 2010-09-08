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
		
        <cfscript>
			// Set Candidate Session Variables  (candidateID / firstName / lastname / lastLoggedInDate / myUploadFolder )
			APPLICATION.CFC.CANDIDATE.setCandidateSession(
				ID=ARGUMENTS.candidateID,
				updateDateLastLoggedIn=1
			);
			
			// Record last logged in date
			APPLICATION.CFC.CANDIDATE.updateLoggedInDate(candidateID=ARGUMENTS.candidateID);
		</cfscript>
        
	</cffunction>


	<!--- Current Logged In --->
	<cffunction name="isCurrentUserLoggedIn" output="false" access="public" returntype="boolean"  description="Returns whether or not user is logged in">
		
        <cfscript>
			 if ( structkeyexists(SESSION,"CANDIDATE") AND VAL(SESSION.CANDIDATE.ID) ) {
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
		</cfscript>
        
	</cffunction>


	<cffunction name="setLoginLinks" access="public" returntype="string" hint="Returns the link according to the user/candidate company.">
        <cfargument name="companyID" type="numeric" required="yes" hint="User/Candidate is required">
		<cfargument name="loginType" type="string" required="yes" hint="User/Candidate is required">
		
		<cfscript>
			var candidateFolder = '';
		
			if ( ARGUMENTS.loginType EQ 'candidate' ) {
				candidateFolder = 'onlineApplication/';
			}
			
			// SET LINKS                    
			switch(ARGUMENTS.companyID) {
				case 7: {
					return("internal/trainee/" & candidateFolder & "index.cfm");
					break;
				}
				case 8: {
					return("internal/wat/" & candidateFolder & "index.cfm");
					break;
				}
				case 9: {
					return("internal/h2b/" & candidateFolder & "index.cfm");
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
	<cffunction name="IsValidPassword" access="public" returntype="struct" hint="Determines if the password is of valid format">
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
					applicationStatus
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
					applicationStatus
				WHERE
	                statusID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.statusID#">
		</cfquery>
		
		<cfreturn qGetApplicationStatusByID /> 
	</cffunction>


	<!--- Save application to a zip file --->
	<cffunction name="saveApplicationToZip" access="public" returntype="string" hint="Saves application in ZIP format and returns file path">
		<cfargument name="candidateID" type="numeric" required="yes" hint="Candidate ID is required">
        
        <cfscript>
			// Get Candidate Information	
			var qGetCandidateInfo = APPLICATION.CFC.CANDIDATE.getCandidateByID(ID=ARGUMENTS.candidateID);

			// Get Candidate Documents
			var qGetDocuments = APPLICATION.CFC.DOCUMENT.getDocuments(foreignTable='candidate', foreignID=ARGUMENTS.candidateID);

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
        <cfargument name="description" type="string" default="" hint="Reason is not required" />		

		<cfquery 
			datasource="#APPLICATION.DSN.Source#">
				INSERT INTO
                	applicationStatusJN
                (
                	applicationID,
                    applicationStatusID,
                    <!--- sessionInformationID, --->
                    foreignTable,
                    foreignID,
                    description,
                	dateCreated
                )
                VALUES 
                (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.applicationID)#">,	
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.applicationStatusID)#">,	
					<!--- <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(SESSION.informationID)#">, --->	
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.foreignTable#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.foreignID)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.description#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                )
        </cfquery>        
        
	</cffunction>


    <!--- Get Application History --->
	<cffunction name="getApplicationHistory" access="public" returntype="query" output="false" hint="Inserts a record into candidateApplicationStatusJN">
		<cfargument name="applicationStatusID" type="numeric" default="0" hint="applicationStatusID is NOT required" />		
        <cfargument name="foreignTable" type="string" required="yes" hint="User/Candidate is updating status - is required." />	
        <cfargument name="foreignID" type="numeric" required="yes" hint="ID of user/candidate updating status - is required" />		

		<cfquery 
        	name="qGetApplicationHistory"
			datasource="#APPLICATION.DSN.Source#">
				SELECT
                	ID,
                	applicationStatusID,
                    sessionInformationID,
                    foreignTable,
                    foreignID,
                    description,
                	dateCreated,
                    dateUpdated
				FROM	
                	applicationStatusJN
				WHERE
                	foreignTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.foreignTable#">
                AND
					foreignID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.foreignID)#">
				<cfif VAL(ARGUMENTS.applicationStatusID)>                
                    AND
                        applicationStatusID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.applicationStatusID)#">
				</cfif>
				ORDER BY
                	dateCreated DESC                    
        </cfquery>        
        
        <cfreturn qGetApplicationHistory>
	</cffunction>


	<!--- Get Online Application Question --->
	<cffunction name="getQuestionByAppID" access="public" returntype="query" output="false" hint="Returns a list with Application questions">
		<cfargument name="applicationID" type="numeric" required="yes" hint="Application ID" />
		
		<cfquery 
			name="qgetQuestionByAppID" 
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
					applicationQuestion
				WHERE
	                applicationID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.applicationID#">
				AND
                	isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                ORDER BY
                	<!--- Keep the same order as getAnswerByFilter --->
                	sectionName,
                    orderKey                    
		</cfquery>
		
		<cfreturn qgetQuestionByAppID /> 
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
				APPLICATION.QUERY.qGetCandidateQuestion = getQuestionByAppID(applicationID=4);
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
					applicationAnswer aa
                RIGHT OUTER JOIN
                	applicationQuestion aq ON aa.applicationQuestionID = aq.ID
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
						applicationAnswer
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
                    	applicationAnswer
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
					applicationQuestion aq
				WHERE
                    sectionName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.sectionName#">    
                AND	
                	isRequired = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                AND
                	ID NOT IN 
                    (
                    	SELECT 
                        	applicationQuestionID 
                        FROM 
                        	applicationAnswer 
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

			// section1 has required items in the candidate table as well.
			if ( ARGUMENTS.foreignTable EQ 'candidate' ) {
				
				stCheckCandidate = APPLICATION.CFC.CANDIDATE.checkCandidateRequiredFields(
					ID=ARGUMENTS.foreignID,
					sectionName=ARGUMENTS.sectionName
				);
				
				// Merge Arrays
				if ( ARGUMENTS.sectionName EQ 'section1') {
					// Section 1 - Candidate errors goes first
					stRequiredFields.fieldList = APPLICATION.CFC.UDF.arrayMerge(array1=stCheckCandidate.fieldList, array2=ListToArray(queryFieldList));
				}
				
				if ( stCheckCandidate.isComplete EQ 0 ) {
					// Set setion as not completed
					stRequiredFields.isComplete = 0;
				}				
			}

			// Return Structure
			return stRequiredFields;
		</cfscript>
        
	</cffunction>


</cfcomponent>