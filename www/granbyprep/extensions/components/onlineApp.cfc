<!--- ------------------------------------------------------------------------- ----
	
	File:		onlineApp.cfc
	Author:		Marcus Melo
	Date:		June 14, 2010
	Desc:		This holds the functions needed for the online application module

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="onlineApp"doLogin
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
	<cffunction name="doLogin" access="public" returntype="void" hint="Logs in a student">
		<cfargument name="studentID" type="numeric" default="0">
        <cfargument name="updateDateLastLoggedIn" type="numeric" default="1">
		
        <cfscript>
			// Set Student Session Variables  (studentID / firstName / lastname / lastLoggedInDate / myUploadFolder )
			APPLICATION.CFC.STUDENT.setStudentSession(
				ID=ARGUMENTS.studentID,
				updateDateLastLoggedIn=1
			);

			// Record last logged in date
			if ( VAL(ARGUMENTS.updateDateLastLoggedIn) ) {
				APPLICATION.CFC.STUDENT.updateLoggedInDate(ID=ARGUMENTS.studentID);
			}
		</cfscript>
        
	</cffunction>


	<!--- Current Logged In --->
	<cffunction name="isCurrentUserLoggedIn" output="false" access="public" returntype="boolean"  description="Returns whether or not user is logged in">
		
        <cfscript>
			 if ( structkeyexists(SESSION,"STUDENT") AND VAL(SESSION.STUDENT.ID) ) {
				return true;
			 } else {
				return false;				 
			 }
		</cfscript>
        	
	</cffunction>
	
    
	<!--- Logout --->
	<cffunction name="doLogout" access="public" returntype="void" hint="Logs out a student from the Online Application">

		<cfscript>
			// Re-set customer session variables 
			SESSION.STUDENT.ID = 0;
		</cfscript>
        
	</cffunction>


	<!--- Save application to a zip file --->
	<cffunction name="saveApplicationToZip" access="public" returntype="string" hint="Saves application in ZIP format and returns file path">
		<cfargument name="studentID" type="numeric" required="yes" hint="Student ID is required">
        
        <cfscript>
			// Get Student Information	
			var qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(ID=ARGUMENTS.studentID);

			// Get Student Documents
			var qGetDocuments = APPLICATION.CFC.DOCUMENT.getDocuments(foreignTable='student', foreignID=ARGUMENTS.studentID);

			var pdfPath = APPLICATION.PATH.uploadDocumentTemp & '##' & qGetStudentInfo.ID & qGetStudentInfo.firstName & qGetStudentInfo.lastName & '-Application.pdf';

			var zipPath = APPLICATION.PATH.uploadDocumentTemp &  '##' & qGetStudentInfo.ID & qGetStudentInfo.firstName & qGetStudentInfo.lastName & '-ApplicationFiles.zip';
			
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
	<cffunction name="insertApplicationHistory" access="public" returntype="void" output="false" hint="Inserts a record into studentApplicationStatusJN">
		<cfargument name="applicationStatusID" type="numeric" required="yes" hint="applicationStatusID is required" />		
        <cfargument name="foreignTable" type="string" required="yes" hint="User/Student is updating status - is required." />	
        <cfargument name="foreignID" type="numeric" required="yes" hint="ID of user/student updating status - is required" />		
        <cfargument name="description" type="string" default="" hint="Reason is not required" />		

		<cfquery 
			datasource="#APPLICATION.DSN.Source#">
				INSERT INTO
                	applicationStatusJN
                (
                	applicationStatusID,
                    sessionInformationID,
                    foreignTable,
                    foreignID,
                    description,
                	dateCreated
                )
                VALUES 
                (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.applicationStatusID)#">,	
					<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(SESSION.informationID)#">,	
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.foreignTable#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.foreignID)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.description#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                )
        </cfquery>        
        
	</cffunction>


    <!--- Get Application History --->
	<cffunction name="getApplicationHistory" access="public" returntype="query" output="false" hint="Inserts a record into studentApplicationStatusJN">
		<cfargument name="applicationStatusID" type="numeric" default="0" hint="applicationStatusID is NOT required" />		
        <cfargument name="foreignTable" type="string" required="yes" hint="User/Student is updating status - is required." />	
        <cfargument name="foreignID" type="numeric" required="yes" hint="ID of user/student updating status - is required" />		

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



    <!--- Calculate Application Fee --->
	<cffunction name="getApplicationFee" access="public" returntype="string" output="false" hint="Calculates Application Fee based on Country of Citizenship">
        <cfargument name="studentID" type="numeric" required="yes" hint="Student ID is required" />
		
        <cfscript>
			// Declare Application Fee
			var applicationFee = '';
			
			// Get Country Citizen ID
			countryCitizenID = APPLICATION.CFC.STUDENT.getStudentByID(ID=ARGUMENTS.studentID).countryCitizenID;
			
			if ( countryCitizenID EQ 0 ) {
				// Country is missing
				applicationFee = 'Please select your country of citizenship in the student information section in order to submit your application fee payment.';
			} else if ( countryCitizenID EQ 211 ) {
				// US Citizens
				applicationFee = 75;
			} else {
				// Non US Citizens
				applicationFee = 150;
			}
			
			return applicationFee;
		</cfscript>

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
				var getQuery = APPLICATION.QUERY.qGetStudentQuestion;
			} catch (Any e) {
				// Set Query
				APPLICATION.QUERY.qGetStudentQuestion = getQuestionByAppID(applicationID=1);
			}
		</cfscript>

		<cfquery  
			name="qGetQuestionByFilter" 
			dbtype="query">
				SELECT
					*
				FROM
					APPLICATION.QUERY.qGetStudentQuestion
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
		<cfargument name="foreignID" type="numeric" default="0" hint="This could be a student or host family ID">
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
		<cfargument name="foreignID" type="numeric" required="yes" hint="This could be a student or host family ID">
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
		<cfargument name="foreignID" type="numeric" required="yes" hint="This could be a student or host family ID">
        
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

			// section1 has required items in the student table as well.
			if ( ARGUMENTS.foreignTable EQ 'student' ) {
				
				stCheckStudent = APPLICATION.CFC.STUDENT.checkStudentRequiredFields(
					ID=ARGUMENTS.foreignID,
					sectionName=ARGUMENTS.sectionName
				);
				
				// Merge Arrays
				if ( ARGUMENTS.sectionName EQ 'section1') {
					// Section 1 - Student errors goes first
					stRequiredFields.fieldList = APPLICATION.CFC.UDF.arrayMerge(array1=stCheckStudent.fieldList, array2=ListToArray(queryFieldList));
				}
				
				if ( stCheckStudent.isComplete EQ 0 ) {
					// Set setion as not completed
					stRequiredFields.isComplete = 0;
				}				
			}

			// Return Structure
			return stRequiredFields;
		</cfscript>
        
	</cffunction>


	<!--- Get Online Application Question --->
	<cffunction name="getApplicationStatus" access="public" returntype="query" output="false" hint="Returns a list with Application Status">
		<cfargument name="applicationStatusID" type="numeric" default="0" hint="Application Status ID" />
		
		<cfquery 
			name="qGetApplicationStatus" 
			datasource="#APPLICATION.DSN.Source#">
				SELECT
					ID, 
					name,
                    description,
                    dateCreated,
                    dateUpdated
				FROM
					applicationStatus
				WHERE
                	isActive = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
				<cfif VAL(ARGUMENTS.applicationStatusID)>
                    AND
                        applicationStatusID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.applicationStatusID#">
                </cfif>                            
                ORDER BY
                	ID
		</cfquery>
		
		<cfreturn qGetApplicationStatus /> 
	</cffunction>

</cfcomponent>