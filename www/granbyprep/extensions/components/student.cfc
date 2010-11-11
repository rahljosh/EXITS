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


	<!--- Return the initialized Student object --->
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
				
				// Check if Application has been submitted
				if ( ListFind("3,4,6,7", qGetStudentInfo.applicationStatusID) ) {
					SESSION.STUDENT.isApplicationSubmitted = 1;
				} else {
					SESSION.STUDENT.isApplicationSubmitted = 0;
				}
				
				// Set student session complete
				stCheckSession1 = APPLICATION.CFC.ONLINEAPP.checkRequiredSectionFields(sectionName='section1', foreignTable='student', foreignID=ARGUMENTS.ID);
				SESSION.STUDENT.isSection1Complete = stCheckSession1.isComplete;
				SESSION.STUDENT.section1FieldList = stCheckSession1.fieldList;
				
				stCheckSession2 = APPLICATION.CFC.ONLINEAPP.checkRequiredSectionFields(sectionName='section2', foreignTable='student', foreignID=ARGUMENTS.ID);
				SESSION.STUDENT.isSection2Complete = stCheckSession2.isComplete;
				SESSION.STUDENT.section2FieldList = stCheckSession2.fieldList;
				
				stCheckSession3 = APPLICATION.CFC.ONLINEAPP.checkRequiredSectionFields(sectionName='section3', foreignTable='student', foreignID=ARGUMENTS.ID);
				SESSION.STUDENT.isSection3Complete = stCheckSession3.isComplete;
				SESSION.STUDENT.section3FieldList = stCheckSession3.fieldList;
				
				stCheckSession4 = APPLICATION.CFC.ONLINEAPP.checkRequiredSectionFields(sectionName='section4', foreignTable='student', foreignID=ARGUMENTS.ID);
				SESSION.STUDENT.isSection4Complete = stCheckSession4.isComplete;
				SESSION.STUDENT.section4FieldList = stCheckSession4.fieldList;
				
				stCheckSession5 = APPLICATION.CFC.ONLINEAPP.checkRequiredSectionFields(sectionName='section5', foreignTable='student', foreignID=ARGUMENTS.ID);
				SESSION.STUDENT.isSection5Complete = stCheckSession5.isComplete;
				SESSION.STUDENT.section5FieldList = stCheckSession5.fieldList;
				
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
                    email  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.email))#">
                AND 
    	            password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.password))#">
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
					<cfqueryparam cfsqltype="cf_sql_integer" value="2">, <!--- active status --->	
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.firstName))#">,	
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.lastName))#">,		
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.email))#">,		
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.password))#">,		
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                )                    
		</cfquery>

		<!--- Insert hashID based on the student ID --->
        <cfquery 
            datasource="#APPLICATION.DSN.Source#">
            UPDATE
                student
            SET
                hashID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.generateHashID(newRecord.GENERATED_KEY)#">
            WHERE
                ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#newRecord.GENERATED_KEY#">
        </cfquery>
		
        <cfscript>
			// Insert Application History
			APPLICATION.CFC.ONLINEAPP.insertApplicationHistory(
				applicationStatusID=1,
				foreignTable='student',
				foreignID=newRecord.GENERATED_KEY,
				description='Application Issued'
			);
		</cfscript>	
        
		<cfreturn newRecord.GENERATED_KEY /> 
	</cffunction>


	<!--- Get Student By ID --->
	<cffunction name="getStudentByID" access="public" returntype="query" output="false" hint="Gets student information by ID">
		<cfargument name="ID" required="yes" hint="Student ID" />

		<cfquery 
			name="qGetStudentByID" 
			datasource="#APPLICATION.DSN.Source#">
				SELECT
					ID, 
                    hashID,
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


	<!--- Get Student By HashID --->
	<cffunction name="getStudentByHashID" access="public" returntype="query" output="false" hint="Gets student information by Hash ID">
		<cfargument name="hashID" required="yes" hint="Hash ID" />

		<cfquery 
			name="qGetStudentByHashID" 
			datasource="#APPLICATION.DSN.Source#">
				SELECT
					ID, 
                    hashID,
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
	                hashID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.hashID#">
		</cfquery>
		
		<cfreturn qGetStudentByHashID /> 
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
                    firstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.firstName))#">,
                    middleName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.middleName))#">,                    
                    lastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.lastName))#">,  
                    preferredName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.preferredName))#">,
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


	<!--- Update ApplicationPaymentID --->
	<cffunction name="updateApplicationPaymentID" access="public" returntype="void" output="false" hint="Update Student Information">
		<cfargument name="ID" required="yes" hint="Student ID" />
        <cfargument name="applicationPaymentID" required="yes" hint="Application Payment ID is required.">
			
		<cfquery 
			datasource="#APPLICATION.DSN.Source#">
				UPDATE
                	student
                SET
                    applicationPaymentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.applicationPaymentID#">
				WHERE
	                ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.ID)#">
		</cfquery>
		
	</cffunction>


	<!--- Update Application Status --->
	<cffunction name="updateApplicationStatusID" access="public" returntype="void" output="false" hint="Update Student Information">
		<cfargument name="ID" required="yes" hint="Student ID" />
        <cfargument name="applicationStatusID" required="yes" hint="Application Status ID is required.">
			
		<cfquery 
			datasource="#APPLICATION.DSN.Source#">
				UPDATE
                	student
                SET
                    applicationStatusID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.applicationStatusID#">
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
                    email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.email))#">
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
                    password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(TRIM(ARGUMENTS.password))#">
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
   
   
	<!--- 
		AdminTool 
	--->   

	<!--- Get Student List --->
	<cffunction name="getStudentList" access="remote" returnFormat="json" output="false" hint="Returns a list of students">
		<cfargument name="keyword" default="" hint="keyword" />
        <cfargument name="applicationStatusID" default="0" hint="applicationStatusID ID" />
        <cfargument name="countryHomeID" default="0" hint="countryHome ID" />
        <cfargument name="countryCitizenID" default="0" hint="countryCitizen ID" />
		<cfargument name="page" required="yes">
		<cfargument name="pageSize" required="yes">
		<cfargument name="gridSortColumn" default="dateCreated" hint="By Default dataCreated">
		<cfargument name="gridSortDirection" default="DESC" hint="By Default DESC">

		<cfquery 
			name="qGetStudentList" 
			datasource="#APPLICATION.DSN.Source#">
				SELECT
					s.ID,
                    s.hashID,
                    s.applicationStatusID,
                    s.applicationPaymentID,
                    CONVERT(CONCAT('<a href="javascript:popUpApplication(''', s.hashID, ''');">', s.firstName, '</a>') USING latin1) AS firstName,
                    s.middleName,                    
                    CONVERT(CONCAT('<a href="javascript:popUpApplication(''', s.hashID, ''');">', s.lastName, '</a>') USING latin1) AS lastName,
                    s.preferredName,
                    s.email,
                    s.password,
                    s.gender,
                    s.dob,
                    s.countryBirthID,
                    s.countryCitizenID,
                    s.hasAddFamInfo,
                    s.isActive,
                    s.isDeleted,
                    s.dateCanceled,
                    DATE_FORMAT(s.dateLastLoggedIn, '%m/%d/%y') AS dateLastLoggedIn,
                    DATE_FORMAT(s.dateCreated, '%m/%d/%y') AS displayDateCreated,
                    s.dateupdated,
					CONVERT(CONCAT('<a href="javascript:popUpApplication(''', s.hashID, ''');">[Open]</a>') USING latin1) AS action,
                    c.name as homeCountry,        
       				cCitizen.name AS citizenCountry,
                    aps.name AS statusName
				FROM
					student s
                LEFT OUTER JOIN
                     applicationAnswer aa ON aa.foreignID = s.ID 
                     	AND 
                        	aa.foreignTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="student"> 
                        AND 
                        	aa.fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="homeCountryID">
                LEFT OUTER JOIN
                     country c ON c.ID = aa.answer     
                LEFT OUTER JOIN
                     country cCitizen ON cCitizen.ID = s.countryCitizenID                    
				LEFT OUTER JOIN
                	applicationStatus aps ON aps.ID = s.applicationStatusID
                WHERE
	                1 = 1
                    
				<cfif LEN(ARGUMENTS.keyword)>                    
                    AND
                    	(
                        	s.firstName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ARGUMENTS.keyword#%">
						OR
                        	s.lastName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ARGUMENTS.keyword#%">
						OR
                        	s.email LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ARGUMENTS.keyword#%">
                        )    
				</cfif>  
                    
				<cfif VAL(ARGUMENTS.applicationStatusID)>                    
                    AND
                    	s.applicationStatusID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.applicationStatusID#">
				</cfif>  

				<cfif VAL(ARGUMENTS.countryHomeID)>                    
                    AND
                    	aa.answer = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.countryHomeID#">
				</cfif>  

				<cfif VAL(ARGUMENTS.countryCitizenID)>                    
                    AND
                    	s.countryCitizenID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.countryCitizenID#">
				</cfif>  

				<cfif LEN(ARGUMENTS.gridsortcolumn)>
                    ORDER BY 
                        #ARGUMENTS.gridSortColumn# #ARGUMENTS.gridSortDirection#
                <cfelse>
                    ORDER BY
                        s.dateCreated DESC     
                </cfif>
		</cfquery>
		
		<cfreturn QueryconvertForGrid(qGetStudentList,page,pagesize)/>
	</cffunction>

	
	<cffunction name="getStudentByDate" access="public" returntype="query" output="false" hint="Returns a list of students">
		<cfargument name="dateLastLoggedIn" default="" hint="dateLastLoggedIn" />
 
		<cfquery 
			name="qGetStudentByDate" 
			datasource="#APPLICATION.DSN.Source#">
				SELECT
					s.ID,
                    s.hashID,
                    s.applicationStatusID,
                    s.applicationPaymentID,
                    CONVERT(CONCAT('<a href="javascript:popUpApplication(''', s.hashID, ''');">', s.firstName, '</a>') USING latin1) AS firstName,
                    s.middleName,                    
                    CONVERT(CONCAT('<a href="javascript:popUpApplication(''', s.hashID, ''');">', s.lastName, '</a>') USING latin1) AS lastName,
                    s.preferredName,
                    s.email,
                    s.password,
                    s.gender,
                    s.dob,
                    s.countryBirthID,
                    s.countryCitizenID,
                    s.hasAddFamInfo,
                    s.isActive,
                    s.isDeleted,
                    s.dateCanceled,
                    DATE_FORMAT(s.dateLastLoggedIn, '%m/%d/%y') AS dateLastLoggedIn,
                    s.dateCreated,
                    DATE_FORMAT(s.dateCreated, '%m/%d/%y') AS displayDateCreated,
                    s.dateupdated,
					CONVERT(CONCAT('<a href="javascript:popUpApplication(''', s.hashID, ''');">[Open]</a>') USING latin1) AS action,
                    c.name as homeCountry,        
       				cCitizen.name AS citizenCountry,
                    aps.name AS statusName
				FROM
					student s
                LEFT OUTER JOIN
                     applicationAnswer aa ON aa.foreignID = s.ID 
                     	AND 
                        	aa.foreignTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="student"> 
                        AND 
                        	aa.fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="homeCountryID">
                LEFT OUTER JOIN
                     country c ON c.ID = aa.answer     
                LEFT OUTER JOIN
                     country cCitizen ON cCitizen.ID = s.countryCitizenID                    
				LEFT OUTER JOIN
                	applicationStatus aps ON aps.ID = s.applicationStatusID
                WHERE
	                1 = 1
                    
				<cfif LEN(ARGUMENTS.dateLastLoggedIn)>                    
                    AND
                        s.dateCreated >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ARGUMENTS.dateLastLoggedIn#">
				</cfif>  
                    
                ORDER BY
                    s.dateCreated DESC     
		</cfquery>
		
		<cfreturn qGetStudentByDate />
	</cffunction>

</cfcomponent>