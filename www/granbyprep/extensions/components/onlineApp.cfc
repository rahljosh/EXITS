<!--- ------------------------------------------------------------------------- ----
	
	File:		onlineApp.cfc
	Author:		Marcus Melo
	Date:		June 14, 2010
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
	<cffunction name="doLogin" access="public" returntype="void" hint="Logs in a student">
		<cfargument name="studentID" type="numeric" default="0">
		
        <cfscript>
			// Set Student Session Variables  (studentID / firstName / lastname / lastLoggedInDate / myUploadFolder )
			APPLICATION.CFC.STUDENT.setStudentSession(ID=ARGUMENTS.studentID);
			
			// Record last logged in date
			APPLICATION.CFC.STUDENT.updateLoggedInDate(ID=ARGUMENTS.studentID);
		</cfscript>
        
	</cffunction>
	
    
	<!--- Logout --->
	<cffunction name="doLogout" access="public" returntype="void" hint="Logs out a student from the Online Application">

		<cfscript>
			// Re-set customer session variables 
			SESSION.STUDENT.ID = 0;
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
				stResults.Errors = stResults.Errors & 'The minimum password lenght is 8 characters. <br>';		
			}

			// Check Maximum Characters
			if ( LEN(ARGUMENTS.password) GT 20 ) {
				stResults.isValidPassword = false;
				stResults.Errors = stResults.Errors & 'The maximum password lenght is 20 characters. <br>';					
			}
			
			// Check for valid characters
			if (REFindNoCase("[^0-9a-zA-Z\~\!\@\$\$\%\^\&\*]{1,}", ARGUMENTS.Password)){
				stResults.isValidPassword = false;
				stResults.Errors = stResults.Errors & 'Password contains an invalid character. <br>';					
			}
			
			return stResults;
		</cfscript>
               
	</cffunction>
	

    <!--- Generates a Password --->
	<cffunction name="generatePassword" access="private" returntype="string">
		
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
                    sortOrder,
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
                    sortOrder                    
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
				// Declare Query
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
		<cfargument name="foreignID" default="0" hint="This could be a student or host family ID" />
        <cfargument name="applicationQuestionID" default="0" hint="Application Question ID" />
        <cfargument name="sectionName" type="string" default="" hint="Section name" />

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
                    aq.sortOrder                    
		</cfquery>
		
		<cfreturn qGetAnswerByFilter /> 
	</cffunction>


	<cffunction name="insertAnswer" access="public" returntype="void" output="false" hint="Inserts/Updates an application answer">
        <cfargument name="applicationQuestionID" default="0" hint="Application Question ID" />
		<cfargument name="foreignID" default="0" hint="This could be a student or host family ID" />
        <cfargument name="fieldKey" default="" hint="Field Key" />
        <cfargument name="answer" default="" hint="Application Asnwer" />
        
        <cfscript>
			// Check if we need to update or insert an answer
			qCheckAnswer = getAnswerByFilter(applicationQuestionID=ARGUMENTS.applicationQuestionID,foreignID=ARGUMENTS.foreignID);
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
                        foreignID,
                        fieldKey,
                        answer,
                        dateCreated
					)
                    VALUES
                    (
						<cfqueryparam cfsqltype="cf_sql_integer" value="#TRIM(ARGUMENTS.applicationQuestionID)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#TRIM(ARGUMENTS.foreignID)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.fieldKey)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.answer)#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    )                        
            </cfquery>
            
        </cfif>
		
	</cffunction>

	
    <!--- Check Required Fields --->
	<cffunction name="checkRequiredSectionFields" access="public" returntype="query" output="false" hint="Query of queries. Returns an application question by field.">
        <cfargument name="sectionName" type="string" required="yes" hint="Section name" />

		<cfquery  
			name="qCheckRequiredSectionFields" 
			datasource="#APPLICATION.DSN.Source#">
				SELECT
					aq.ID,
                    aq.applicationID,
                    aq.fieldKey,
                    aq.displayField,
                    aq.sectionName,
                    aq.sortOrder,
                    aq.classType
				FROM
					applicationQuestion aq
                LEFT OUTER JOIN
                	applicationAnswer aa ON aq.ID = aa.applicationQuestionID	    
				WHERE
                    aq.sectionName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.sectionName#">    
                AND	
                	aq.isRequired = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
		</cfquery>
		
		<cfreturn qCheckRequiredSectionFields /> 
	</cffunction>


</cfcomponent>