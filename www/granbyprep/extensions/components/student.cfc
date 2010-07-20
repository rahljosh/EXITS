<!--- ------------------------------------------------------------------------- ----
	
	File:		student.cfc
	Author:		Marcus Melo
	Date:		June 14, 2010
	Desc:		This holds the functions needed for student online application module

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="student"
	output="false" 
	hint="A collection of functions for the student module">


	<!--- Return the initialized UDF object --->
	<cffunction name="Init" access="public" returntype="student" output="No" hint="Returns the initialized Student object">

		<cfscript>
			// Return this initialized instance
			return(this);
		</cfscript>

	</cffunction>


	<!--- Get StudentID --->
	<cffunction name="getStudentID" access="public" returntype="numeric" hint="Get student ID from session. Returns 0 if it's not found." output="no">
        
        <cftry>
	        <cfparam name="SESSION.STUDENT.ID" type="numeric" default="0">
            <cfcatch type="any">
                <cfset SESSION.STUDENT.ID = 0>
            </cfcatch>
        </cftry>

		<cfscript>
			if (VAL(SESSION.STUDENT.ID)) {
				// return studentID 
				return SESSION.STUDENT.ID;
			} else {
				// studentID not found
				return 0;
			}
		</cfscript>
        
	</cffunction>


	<!--- Set Student Session Variables --->
	<cffunction name="setStudentSession" access="public" returntype="void" hint="Set student SESSION variables" output="no">
		<cfargument name="ID" type="numeric" default="0">
        <cfargument name="updateDateLastLoggedIn" type="numeric" default="0">
        
        <cfscript>
			if ( VAL(ARGUMENTS.ID) ) {
			
				// Set student ID
				SESSION.STUDENT.ID = ARGUMENTS.ID;
	
				// Get Student Information
				qGetStudentInfo = getStudentByID(ID=ARGUMENTS.ID);
			
				// Set student session variables 
				SESSION.STUDENT.firstName = qGetStudentInfo.firstName;
				SESSION.STUDENT.lastName = qGetStudentInfo.lastName;
				SESSION.STUDENT.hasAddFamInfo = qGetStudentInfo.hasAddFamInfo;
				
				if ( VAL(ARGUMENTS.updateDateLastLoggedIn) ) {				
					SESSION.STUDENT.dateLastLoggedIn = qGetStudentInfo.dateLastLoggedIn;
				}
				
				// Set student session complete
				SESSION.STUDENT.isSection1Complete = APPLICATION.CFC.ONLINEAPP.checkRequiredSectionFields(sectionName='section1', foreignTable='student', foreignID=ARGUMENTS.ID).isComplete;
				SESSION.STUDENT.isSection2Complete = APPLICATION.CFC.ONLINEAPP.checkRequiredSectionFields(sectionName='section2', foreignTable='student', foreignID=ARGUMENTS.ID).isComplete;
				SESSION.STUDENT.isSection3Complete = APPLICATION.CFC.ONLINEAPP.checkRequiredSectionFields(sectionName='section3', foreignTable='student', foreignID=ARGUMENTS.ID).isComplete;
				SESSION.STUDENT.isSection4Complete = APPLICATION.CFC.ONLINEAPP.checkRequiredSectionFields(sectionName='section4', foreignTable='student', foreignID=ARGUMENTS.ID).isComplete;
				SESSION.STUDENT.isSection5Complete = APPLICATION.CFC.ONLINEAPP.checkRequiredSectionFields(sectionName='section5', foreignTable='student', foreignID=ARGUMENTS.ID).isComplete;
				
				// set up upload files path
				SESSION.STUDENT.myUploadFolder = APPLICATION.PATH.uploadDocumentStudent & ARGUMENTS.ID & '/';
				// Make sure folder exists
				APPLICATION.CFC.DOCUMENT.createFolder(SESSION.STUDENT.myUploadFolder);
			}
		</cfscript>
        
	</cffunction>

	
    <!--- Get Student Session Variables --->
	<cffunction name="getStudentSession" access="public" returntype="struct" hint="Get student SESSION variables" output="no">

        <cfscript>
			return SESSION.STUDENT;
		</cfscript>
        
	</cffunction>


	<!--- Check Login --->
	<cffunction name="checkLogin" access="public" returntype="query" output="false" hint="Check student credentials">
		<cfargument name="email" required="yes" hint="Email Address" />
		<cfargument name="password" required="yes" hint="Password" />		

		<cfquery 
			name="qCheckLogin" 
			datasource="#APPLICATION.DSN.Source#">
				SELECT
					id, 
                    firstName,
                    lastName,                    
                    email,
                    password
				FROM
					student
				WHERE
                    email  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.email)#">
                AND 
    	            password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.password)#">
				AND
					isActive = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                AND    
                   	isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0"> 
		</cfquery>
		
		<cfreturn qCheckLogin /> 
	</cffunction>


	<!--- Check Email Address --->
	<cffunction name="checkEmail" access="public" returntype="query" output="false" hint="Check student credentials">
		<cfargument name="email" required="yes" hint="Email Address" />
		<cfargument name="ID" default="0" hint="Pass studentID if you are updating account">
        
		<cfquery 
			name="qCheckEmail" 
			datasource="#APPLICATION.DSN.Source#">
				SELECT
					ID, 
                    firstName,
                    lastName,                    
                    email,
                    password
				FROM
					student
				WHERE
                    email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.email)#">
				AND
					isActive = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                AND    
                   	isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                <cfif VAL(ARGUMENTS.ID)>
                	AND
                    	ID != <cfqueryparam cfsqltype="cf_sql_integer" value="#TRIM(ARGUMENTS.ID)#">
                </cfif> 
		</cfquery>
		
		<cfreturn qCheckEmail /> 
	</cffunction>


	<!--- Insert Student --->
	<cffunction name="insertStudent" access="public" returntype="numeric" output="false" hint="Inserts a new student. Returns student ID.">
		<cfargument name="firstName" required="yes" hint="First Name" />		
        <cfargument name="lastName" required="yes" hint="Last Name" />		
		<cfargument name="email" required="yes" hint="Email" />
		<cfargument name="password" required="yes" hint="Password" />

		<cfquery 
            result="newRecord"
			datasource="#APPLICATION.DSN.Source#">
				INSERT INTO
					student
				(                    
                    applicationStatusID,
                    firstName,
                    lastName,                    
                    email,
                    password,                    
                    dateCreated
				)
                VALUES
                (
					<cfqueryparam cfsqltype="cf_sql_integer" value="1">,	
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.firstName)#">,	
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.lastName)#">,		
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.email)#">,		
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.password)#">,		
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                )                    
		</cfquery>
		
        <cfscript>
			// Insert Application History
			insertApplicationHistory(
				applicationStatusID=1,
				studentID=newRecord.GENERATED_KEY,
				foreignTable='student',
				foreignID=newRecord.GENERATED_KEY,
				description='Application Issued'
			);
		</cfscript>	
        
		<cfreturn newRecord.GENERATED_KEY /> 
	</cffunction>


    <!--- Insert Application History --->
	<cffunction name="insertApplicationHistory" access="public" returntype="void" output="false" hint="Inserts a record into studentApplicationStatusJN">
		<cfargument name="applicationStatusID" type="numeric" required="yes" hint="applicationStatusID is required" />		
        <cfargument name="studentID" type="numeric" required="yes" hint="studentID is required" />	
        <cfargument name="foreignTable" type="string" required="yes" hint="User/Student is updating status - is required." />	
        <cfargument name="foreignID" type="numeric" required="yes" hint="ID of user/student updating status - is required" />		
        <cfargument name="description" type="string" default="" hint="Reason is not required" />		

		<cfquery 
			datasource="#APPLICATION.DSN.Source#">
				INSERT INTO
                	studentApplicationStatusJN
                (
                	applicationStatusID,
                    sessionInformationID,
                    studentID,
                    foreignTable,
                    foreignID,
                    description,
                	dateCreated
                )
                VALUES 
                (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.applicationStatusID)#">,	
					<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(SESSION.informationID)#">,	
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.foreignTable#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.foreignID)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.description#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                )
        </cfquery>        
        
	</cffunction>


	<!--- Get Student By ID --->
	<cffunction name="getStudentByID" access="public" returntype="query" output="false" hint="Gets student information by ID">
		<cfargument name="ID" required="yes" hint="Student ID" />

		<cfquery 
			name="qGetStudentByID" 
			datasource="#APPLICATION.DSN.Source#">
				SELECT
					ID, 
                    applicationStatusID,
                    applicationPaymentID,
                    firstName,
                    middleName,                    
                    lastName,  
                    preferredName,
                    email,
                    password,
                    gender,
                    dob,
                    countryBirthID,
                    countryCitizenID,
                    hasAddFamInfo,
                    isActive,
                    isDeleted,
                    dateCanceled,
                    dateLastLoggedIn,
                    dateCreated,
                    dateupdated                  
				FROM
					student
				WHERE
	                ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.ID)#">
		</cfquery>
		
		<cfreturn qGetStudentByID /> 
	</cffunction>


	<!--- Update Student --->
	<cffunction name="updateStudent" access="public" returntype="void" output="false" hint="Update Student Information">
		<cfargument name="ID" required="yes" hint="Student ID" />
		<cfargument name="firstName" default="" hint="Student First Name">
        <cfargument name="middleName" default="" hint="Student Middle Name">
        <cfargument name="lastName" default="" hint="Student Last Name">
        <cfargument name="preferredName" default="" hint="Student Preferred Name">
        <cfargument name="gender" default="" hint="Student Gender">
        <cfargument name="dob" default="" hint="Student Date of Birth">
        <cfargument name="countryBirthID" default="" hint="Student Country of Birth">
        <cfargument name="countryCitizenID" default="" hint="Student Country of Citizenship">

		<cfquery 
			datasource="#APPLICATION.DSN.Source#">
				UPDATE
                	student
                SET
                    firstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.firstName)#">,
                    middleName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.middleName)#">,                    
                    lastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.lastName)#">,  
                    preferredName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.preferredName)#">,
                    gender = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.gender)#">,
                    <cfif IsDate(ARGUMENTS.dob)>
	                    dob = <cfqueryparam cfsqltype="cf_sql_date" value="#TRIM(ARGUMENTS.dob)#">,
                    <cfelse>
                    	dob = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    </cfif>
                    countryBirthID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.countryBirthID)#">,
                    countryCitizenID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.countryCitizenID)#">
				WHERE
	                ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.ID)#">
		</cfquery>
		
	</cffunction>


	<!--- Update hasAddFamInfo --->
	<cffunction name="updateHasAddFamInfo" access="public" returntype="void" output="false" hint="Update Student Information">
		<cfargument name="ID" required="yes" hint="Student ID" />
        <cfargument name="hasAddFamInfo" default="" hint="Set to 1 to display the second tab of student information">

		<cfquery 
			datasource="#APPLICATION.DSN.Source#">
				UPDATE
                	student
                SET
                    hasAddFamInfo = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hasAddFamInfo)#">
				WHERE
	                ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.ID)#">
		</cfquery>
		
	</cffunction>


	<!--- Update Student Email --->
	<cffunction name="updateEmail" access="public" returntype="void" output="false" hint="Update Student Email">
		<cfargument name="ID" required="yes" hint="Student ID" />
		<cfargument name="email" required="yes" hint="Email Address / Username">

		<cfquery 
			datasource="#APPLICATION.DSN.Source#">
				UPDATE
                	student
                SET
                    email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.email)#">
				WHERE
	                ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.ID)#">
		</cfquery>
		
	</cffunction>
    
    
    <!--- Update Student Password --->
	<cffunction name="updatePassword" access="public" returntype="void" output="false" hint="Update Student Password">
		<cfargument name="ID" required="yes" hint="Student ID" />
        <cfargument name="password" required="yes" hint="Password">

		<cfquery 
			datasource="#APPLICATION.DSN.Source#">
				UPDATE
                	student
                SET
                    password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.password)#">
				WHERE
	                ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.ID)#">
		</cfquery>

	</cffunction>
 
 
 	<!--- Update Logged In Date --->
 	<cffunction name="updateLoggedInDate" access="public" returntype="void" output="false" hint="Update Student last logged in date">
		<cfargument name="ID" required="yes" hint="Student ID" />

		<cfquery 
			datasource="#APPLICATION.DSN.Source#">
				UPDATE 
                	student
                SET
                	dateLastLoggedIn =  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				WHERE
                	id = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.ID#">
		</cfquery>
		
	</cffunction>


    <!--- Check Required Student Fields --->
	<cffunction name="checkStudentRequiredFields" access="public" returntype="struct" output="false" hint="Check if required fields were answered">
        <cfargument name="ID" type="string" required="yes" hint="Name of the Table">
        <cfargument name="sectionName" type="string" required="yes" hint="Section name" />
        
        <cfscript>
			// Declare structure
			var stRequiredFields = StructNew();	

			// Create an array and populate with the field name in case we need to display missing items
			stRequiredFields.fieldList = ArrayNew(1);

			// Set complete = 1
			stRequiredFields.isComplete = 1;
			
			// Get Student Info
			qGetStudentInfo = getStudentByID(ID=ARGUMENTS.ID);			
		</cfscript>
        
        <cfscript>
			switch(ARGUMENTS.sectionName) {
				case "section1": {
					
					if ( NOT LEN(qGetStudentInfo.firstName) ) {
						ArrayAppend(stRequiredFields.fieldList, "First Name");
						stRequiredFields.isComplete = 0;
					}
						
					if ( NOT LEN(qGetStudentInfo.lastName) ) {
						ArrayAppend(stRequiredFields.fieldList, "Last Name");
						stRequiredFields.isComplete = 0;
					}

					if ( NOT LEN(qGetStudentInfo.gender) ) {
						ArrayAppend(stRequiredFields.fieldList, "Gender");
						stRequiredFields.isComplete = 0;
					}

					if ( NOT LEN(qGetStudentInfo.dob) ) {
						ArrayAppend(stRequiredFields.fieldList, "Date of Birth");
						stRequiredFields.isComplete = 0;
					}

					if ( NOT VAL(qGetStudentInfo.countryBirthID) ) {
						ArrayAppend(stRequiredFields.fieldList, "Country of Birth");
						stRequiredFields.isComplete = 0;
					}

					if ( NOT VAL(qGetStudentInfo.countryCitizenID) ) {
						ArrayAppend(stRequiredFields.fieldList, "Country of Citizenship");
						stRequiredFields.isComplete = 0;
					}

					break;
				}
				  
			}	
			
			// Return Structure
			return stRequiredFields;
		</cfscript>
        
	</cffunction>
   

</cfcomponent>