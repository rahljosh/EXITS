<!--- ------------------------------------------------------------------------- ----
	
	File:		student.cfc
	Author:		Marcus Melo
	Date:		October, 27 2009
	Desc:		This holds the functions needed for the user

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="student"
	output="false" 
	hint="A collection of functions for the student">


	<!--- Return the initialized student object --->
	<cffunction name="Init" access="public" returntype="student" output="false" hint="Returns the initialized student object">
		
		<cfscript>
			// There is nothing really to initiate, so just return this
			return(this);
		</cfscript>
        
	</cffunction>


	<cffunction name="getStudentByID" access="public" returntype="query" output="false" hint="Gets a student by studentID or uniqueID">
    	<cfargument name="studentID" default="0" hint="studentID is not required">
        <cfargument name="uniqueID" default="" hint="uniqueID is not required">
              
        <cfquery 
			name="qGetStudentByID" 
			datasource="#APPLICATION.dsn#">
                SELECT
					*
                FROM 
                    smg_students
                WHERE
                	1 = 1
					
					<cfif VAL(ARGUMENTS.studentID)>
	                    AND
                        	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">
					</cfif>
                    
					<cfif LEN(ARGUMENTS.uniqueID)>
	                    AND
                        	uniqueID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.uniqueID#">
					</cfif>
		</cfquery>
		   
		<cfreturn qGetStudentByID>
	</cffunction>


	<cffunction name="getStudentFullInformationByID" access="public" returntype="query" output="false" hint="Gets a student, intl. rep, program, host family information by studentID or uniqueID">
    	<cfargument name="studentID" default="0" hint="studentID is not required">
        <cfargument name="uniqueID" default="" hint="uniqueID is not required">
              
        <cfquery 
			name="qGetStudentFullInformationByID" 
			datasource="#APPLICATION.dsn#">
                SELECT
					s.studentID,
                    s.uniqueID,
                    s.hostID,
                    s.programID,
                    s.schoolID,
                    s.regionAssigned,
                    s.intRep,
                    s.areaRepID,
                    s.placeRepID,
                    s.firstName,
                    s.familyLastName,
                    s.dob,
                    s.active,
                    s.flight_info_notes,
                    <!--- Intl Representative --->
                    intlRep.userID AS intlRepUserID,
                    intlRep.firstName AS intlRepFirstName,
                    intlRep.lastName AS intlRepLastName,
                    intlRep.businessName AS intlRepBusinessName,
                    intlRep.email AS intlRepEmail,
                    <!--- Program --->
                    p.programName,
                    <!--- Region --->
					r.regionName,
					<!--- Placing Representative --->
                    place.userID AS placeUserID,
                    place.firstName AS placeFirstName,
                    place.lastName AS placeLastName,
					place.email AS	placeEmail,
                    place.phone AS placePhone,
                    <!--- Area Representative --->
                    areaRep.userID AS areaRepUserID,
                    areaRep.firstName AS areaRepFirstName,
                    areaRep.lastName AS areaRepLastName,
					areaRep.email AS areaRepEmail,
                    areaRep.phone AS areaRepPhone
                    
                FROM 
                    smg_students s
                INNER JOIN
                	smg_users intlRep ON intlRep.userID = s.intRep    
				LEFT OUTER JOIN
                	smg_regions r ON r.regionID = s.regionAssigned                                 
				LEFT OUTER JOIN
                	smg_programs p ON p.programID = s.programID                    
				LEFT OUTER JOIN
                	smg_users place ON place.userID = s.placeRepID
				LEFT OUTER JOIN
                	smg_users areaRep ON areaRep.userID = s.areaRepID
                                   
                WHERE
                	1 = 1
					
					<cfif VAL(ARGUMENTS.studentID)>
	                    AND
                        	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">
					</cfif>
                    
					<cfif LEN(ARGUMENTS.uniqueID)>
	                    AND
                        	uniqueID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.uniqueID#">
					</cfif>
		</cfquery>
		   
		<cfreturn qGetStudentFullInformationByID>
	</cffunction>

	
	<cffunction name="isStudentAssignedToPHP" access="public" returntype="numeric" output="false" hint="Returns 1 if student is assigned to PHP">
    	<cfargument name="studentID" default="0" hint="studentID is not required">

    	<cfquery name="qIsStudentAssignedToPHP" datasource="MySql">
            SELECT 
            	studentID
            FROM 
            	php_students_in_program
            WHERE 
            	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">
        </cfquery>
		
        <cfscript>
			if ( qIsStudentAssignedToPHP.recordCount ) {
				return 1;
			} else {
				return 0;
			}		
		</cfscript>
        
	</cffunction>


	<!--- ------------------------------------------------------------------------- ----
		
		DS-2019 Verification List
	
	----- ------------------------------------------------------------------------- --->
    
	<cffunction name="getVerificationList" access="remote" returnFormat="json" output="false" hint="Returns verification report list in Json format">
    	<cfargument name="intRep" default="0" hint="International Representative is not required">
        <cfargument name="branchID" default="0" hint="Branch is not required">
        <cfargument name="receivedDate" default="" hint="Filter by verification received date">

        <cfquery 
			name="qGetVerificationList" 
			datasource="#APPLICATION.dsn#">
                SELECT
					s.studentID,
                    s.firstName,
                    s.middleName,
                    s.familyLastName,
                    s.sex,
                    DATE_FORMAT(s.dob, '%m/%e/%Y') as dob,
                    s.cityBirth,
                    s.countryBirth,
                    s.countryCitizen,
                    s.countryResident,
                    birth.countryName as birthCountry,
                    citizen.countryName as citizenCountry,
                    resident.countryName as residentCountry
                FROM 
                    smg_students s
				INNER JOIN
                	smg_programs p ON p.programID = s.programID AND p.startDate < ADDDATE(now(), INTERVAL 145 DAY) <!--- Get only programs that are starting 145 days from now --->
                LEFT OUTER JOIN
                	smg_countrylist birth ON birth.countryID = s.countryBirth
				LEFT OUTER JOIN
                	smg_countrylist citizen ON citizen.countryID = s.countryCitizen
				LEFT OUTER JOIN
                	smg_countrylist resident ON resident.countryID = s.countryResident
                WHERE
                	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
				AND
                	s.app_current_status = <cfqueryparam cfsqltype="cf_sql_integer" value="11">              
                AND   
                    s.ds2019_no = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
                AND
                    s.intRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.intRep)#">
                    
            	<cfif VAL(ARGUMENTS.branchID)>
                    AND
                        s.branchID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.branchID)#">
                </cfif>        
			                    
				<cfif CLIENT.companyID EQ 5>
                    AND
                        s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,10,12" list="yes"> )
                <cfelse>
                    AND
                        s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
                </cfif>
                
				<cfif IsDate(ARGUMENTS.receivedDate)>
                	AND
                    	s.verification_received = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.receivedDate#">
				<cfelse>
                	AND
                    	s.verification_received IS <cfqueryparam cfsqltype="cf_sql_date" value="" null="yes">
                </cfif>
			ORDER BY
            	s.familyLastName,
                s.firstName                                                        
		</cfquery>
		
		<cfreturn qGetVerificationList>
	</cffunction>


	<!--- Remote Functions --->
	<cffunction name="getRemoteStudentByID" access="remote" returnFormat="json" output="false" hint="Returns a student in Json format">
        <cfargument name="studentID" required="yes" hint="studentID is required">

        <cfquery 
			name="qGetRemoteStudentByID" 
			datasource="#APPLICATION.dsn#">
                SELECT
					s.studentID,
                    s.firstName,
                    s.middleName,
                    s.familyLastName,
                    s.sex,
                    DATE_FORMAT(s.dob, '%m/%e/%Y') as dob,
                    s.cityBirth,
                    s.countryBirth,
                    s.countryCitizen,
                    s.countryResident
                FROM 
                    smg_students s
                WHERE
                    s.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">
		</cfquery>
		   
		<cfreturn qGetRemoteStudentByID>
	</cffunction>


	<cffunction name="updateRemoteStudentByID" access="remote" returntype="void" hint="Updates a student record.">
        <cfargument name="studentID" required="yes" hint="studentID is required">
        <cfargument name="firstName" required="yes" hint="firstName is required">
        <cfargument name="middleName" required="yes" hint="middleName is required">
        <cfargument name="familyLastName" required="yes" hint="familyLastName is required">
        <cfargument name="sex" required="yes" hint="sex is required">
        <cfargument name="dob" required="yes" hint="dob is required">
        <cfargument name="cityBirth" required="yes" hint="cityBirth is required">
        <cfargument name="countryBirth" required="yes" hint="countryBirth is required">
        <cfargument name="countryCitizen" required="yes" hint="countryCitizen is required">
        <cfargument name="countryResident" required="yes" hint="countryResident is required">

        <cfquery 
			datasource="#APPLICATION.dsn#">
                UPDATE
					smg_students
				SET
                    firstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.firstName#">,
                    middleName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.middleName#">,
                    familyLastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.familyLastName#">,
                    sex = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.sex#">,
                    dob = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.dob#">,
                    cityBirth = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.cityBirth#">,
                    countryBirth = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.countryBirth)#">,
                    countryCitizen = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.countryCitizen)#">,
                    countryResident = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.countryResident)#">
                WHERE
                    studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">
		</cfquery>
		   
	</cffunction>
	<!--- End of Remote Functions --->

	<cffunction name="confirmVerificationReceived" access="remote" returntype="void" hint="Sets verification_received field as received.">
        <cfargument name="studentID" required="yes" hint="studentID is required">

        <cfquery 
			datasource="#APPLICATION.dsn#">
                UPDATE
					smg_students
				SET
                    verification_received = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                WHERE
                    studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">
		</cfquery>
		   
	</cffunction>

	<!--- ------------------------------------------------------------------------- ----
		
		END OF DS-2019 Verification List
	
	----- ------------------------------------------------------------------------- --->


	<!--- ------------------------------------------------------------------------- ----
		
		FLIGHT INFORMATION
	
	----- ------------------------------------------------------------------------- --->

	<cffunction name="getFlightInformation" access="public" returntype="query" output="false" hint="Gets flight information by studentID and type">
    	<cfargument name="studentID" hint="studentID is required">
        <cfargument name="flightType" hint="Arrival/Departure is required">
		<cfargument name="isPreAYP" default="0" hint="Set to 1 to get PRE-AYP flight arrival information">   
        
        <cfquery 
			name="qGetFlightInformation" 
			datasource="#APPLICATION.dsn#">
                SELECT 
                    flightID,                     
                    studentID,
                    companyID,
                    programID,
                    enteredByID, 
                    dep_date, 
                    dep_city, 
                    dep_aircode, 
                    dep_time, 
                    flight_number, 
                    arrival_city, 
                    arrival_aircode, 
                    arrival_time, 
                    overnight, 
                    flight_type,
                    isPreAYP,
                    dateCreated,
                    dateUpdated,
                    isDeleted
                FROM 
                    smg_flight_info
                WHERE 
                    studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#"> 
                AND 
                    flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.flightType#">
                AND 
                    isPreAYP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.isPreAYP#">
				AND
                	isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                ORDER BY 
                    flightID <!--- dep_date, dep_time --->
		</cfquery>
		   
		<cfreturn qGetFlightInformation>
	</cffunction>


	<cffunction name="getFlightInformationByFlightID" access="public" returntype="query" output="false" hint="Gets flight information by flightID">
    	<cfargument name="flightID" hint="flightID is required">
        <cfargument name="studentID" default="0" hint="studentID is not required">
		        
        <cfquery 
			name="qGetFlightInformationByFlightID" 
			datasource="#APPLICATION.dsn#">
                SELECT 
                    flightID,                     
                    studentID,
                    companyID,
                    programID,
                    enteredByID, 
                    dep_date, 
                    dep_city, 
                    dep_aircode, 
                    dep_time, 
                    flight_number, 
                    arrival_city, 
                    arrival_aircode, 
                    arrival_time, 
                    overnight, 
                    flight_type,
                    isPreAYP,
                    dateCreated,
                    dateUpdated,
                    isDeleted
                FROM 
                    smg_flight_info
                WHERE 
                    flightID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.flightID#">
                <cfif VAL(ARGUMENTS.studentID)>
                    AND	
                        studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">           
				</cfif>                        
		</cfquery>
		   
		<cfreturn qGetFlightInformationByFlightID>
	</cffunction>

	
    <!--- UPDATE FLIGHT NOTES --->
	<cffunction name="updateFlightNotes" access="public" returntype="void" output="false" hint="Updates Flight Information Notes">
    	<cfargument name="studentID" hint="studentID is required">
        <cfargument name="flightNotes" default="" hint="Notes is not required">

        <cfquery datasource="MySQL">
            UPDATE 
                smg_students
            SET 
                flight_info_notes = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.flightNotes#">
            WHERE 
                studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">
            LIMIT 1
        </cfquery> 

	</cffunction>


	<!--- INSERT FLIGHT --->
	<cffunction name="insertFlightInfo" access="public" returntype="void" output="false" hint="Inserts Flight Information">
    	<cfargument name="studentID" hint="studentID is required">
        <cfargument name="companyID" default="0" hint="Company student is currently assigned to">
        <cfargument name="programID" default="0" hint="Program student is currently assigned to">
        <cfargument name="enteredByID" default="0" hint="ID of user entering the flight information">
        <cfargument name="batchID" default="0" hint="BatchID used for XML files">
        <cfargument name="flightNumber" default="" hint="flightNumber is not required">
        <cfargument name="depCity" default="" hint="depCity is not required">
        <cfargument name="depAirCode" default="" hint="depAirCode is not required">
        <cfargument name="depDate" default="" hint="Departure is not required">
        <cfargument name="depTime" default="" hint="depTime is not required">
        <cfargument name="arrivalCity" default="" hint="arrivalCity is not required">
        <cfargument name="arrivalAirCode" default="" hint="arrivalAirCode is not required">
        <cfargument name="arrivalTime" default="" hint="arrivalTime is not required">
        <cfargument name="overNight" default="0" hint="overNight is not required">
        <cfargument name="flightType" hint="Arrival/Departure is required">
        <cfargument name="isPreAYP" default="0" hint="Set to 1 for PRE-AYP flight arrival information"> 
		
		<cfquery datasource="MySQL">
            INSERT INTO 
            	smg_flight_info
            (
            	studentID, 
                companyID,
                programID,
                enteredByID,
                batchID,
                flight_number,                 
                dep_city, 
                dep_aircode, 
                dep_date, 
                dep_time, 
                arrival_city, 
                arrival_aircode, 
                arrival_time,
            	overnight, 
                flight_type,
                isPreAYP,
                dateCreated
            )
            VALUES 
            (
            	<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.programID#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.enteredByID#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.batchID#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.flightNumber#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.depCity#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.depAirCode#">,
                
				<cfif IsDate(ARGUMENTS.depDate)>
	                <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(ARGUMENTS.depDate)#">,
                <cfelse>
                	<cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                </cfif>
                
				<cfif IsDate(ARGUMENTS.depTime)>
	                <cfqueryparam cfsqltype="cf_sql_time" value="#CreateODBCTime(ARGUMENTS.depTime)#">, 
                <cfelse>
                	<cfqueryparam cfsqltype="cf_sql_time" null="yes">,
                </cfif>

                <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.arrivalCity#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.arrivalAirCode#">,

				<cfif IsDate(ARGUMENTS.arrivalTime)>
	                <cfqueryparam cfsqltype="cf_sql_time" value="#CreateODBCTime(ARGUMENTS.arrivalTime)#">,
                <cfelse>
                	<cfqueryparam cfsqltype="cf_sql_time" null="yes">,
                </cfif>

                <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(ARGUMENTS.overNight)#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.flightType#">,
            	<cfqueryparam cfsqltype="cf_sql_bit" value="#ARGUMENTS.isPreAYP#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
            ) 
        </cfquery>

	</cffunction>

	
    <!--- UPDATE FLIGHT INFORMATION --->
	<cffunction name="updateFlightInfo" access="public" returntype="void" output="false" hint="Updates Flight Information">
    	<cfargument name="flightID" hint="flightID is required">
    	<cfargument name="studentID" hint="studentID is required">
        <cfargument name="companyID" default="0" hint="Company student is currently assigned to">
        <cfargument name="programID" default="0" hint="Program student is currently assigned to">
        <cfargument name="enteredByID" default="0" hint="ID of user entering the flight information">
        <cfargument name="flightNumber" default="" hint="flightNumber is not required">
        <cfargument name="depCity" default="" hint="depCity is not required">
        <cfargument name="depAirCode" default="" hint="depAirCode is not required">
        <cfargument name="depDate" default="" hint="Departure is not required">
        <cfargument name="depTime" default="" hint="depTime is not required">
        <cfargument name="arrivalCity" default="" hint="arrivalCity is not required">
        <cfargument name="arrivalAirCode" default="" hint="arrivalAirCode is not required">
        <cfargument name="arrivalTime" default="" hint="arrivalTime is not required">
        <cfargument name="overNight" default="0" hint="overNight is not required">
        <cfargument name="isPreAYP" default="0" hint="Set to 1 for PRE-AYP flight arrival information"> 

		<cfquery datasource="MySQL">
            UPDATE
            	smg_flight_info
            SET 
                companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">,
                programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.programID#">,
                enteredByID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.enteredByID#">,
                flight_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.flightNumber#">,                 
                dep_city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.depCity#">, 
                dep_aircode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.depAirCode#">, 
                
				<cfif IsDate(ARGUMENTS.depDate)>
	                dep_date = <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(ARGUMENTS.depDate)#">,
                <cfelse>
                	dep_date = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                </cfif>
                
				<cfif IsDate(ARGUMENTS.depTime)>
	                dep_time = <cfqueryparam cfsqltype="cf_sql_time" value="#CreateODBCTime(ARGUMENTS.depTime)#">,
                <cfelse>
                	dep_time = <cfqueryparam cfsqltype="cf_sql_time" null="yes">,
                </cfif>
                
                arrival_city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.arrivalCity#">, 
                arrival_aircode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.arrivalAirCode#">, 
                
				<cfif IsDate(ARGUMENTS.arrivalTime)>
	                arrival_time = <cfqueryparam cfsqltype="cf_sql_time" value="#CreateODBCTime(ARGUMENTS.arrivalTime)#">,
                <cfelse>
                	arrival_time = <cfqueryparam cfsqltype="cf_sql_time" null="yes">,
                </cfif>
            	
                overnight = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(ARGUMENTS.overNight)#">,
                isPreAYP =  <cfqueryparam cfsqltype="cf_sql_bit" value="#ARGUMENTS.isPreAYP#">
            WHERE 
            	flightID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.flightID#">
            AND	
                studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">           
            LIMIT 1
        </cfquery>

	</cffunction>


	<!--- DELETE FLIGHT INFORMATION --->
	<cffunction name="deleteFlightInformation" access="public" returntype="void" output="false" hint="Deletes Flight Information">
    	<cfargument name="flightID" hint="flightID is required">
        <cfargument name="studentID" hint="studentID is required">
        <cfargument name="enteredByID" default="0" hint="ID of user entering the flight information">
        <cfargument name="sendEmail" default="1" hint="Set to 0 to not send email notification">
		
        <cfquery datasource="MySql">
            UPDATE
            	smg_flight_info
            SET
            	enteredByID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.enteredByID#">,
            	isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
            WHERE 
            	flightID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.flightID#">
			AND	
            	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">           
            LIMIT 1
        </cfquery>

        <cfscript>
			// Send out email notification
			if ( ARGUMENTS.sendEmail ) {
				emailFlightInformation(
					studentID=ARGUMENTS.studentID,
					flightID=ARGUMENTS.flightID
				);
			}
		</cfscript>
        
	</cffunction>
    

	<!--- DELETE COMPLETE FLIGHT INFORMATION --->
	<cffunction name="deleteCompleteFlightInformation" access="public" returntype="void" output="false" hint="Deletes Flight Information">
        <cfargument name="studentID" hint="studentID is required">
        <cfargument name="flightType" hint="Arrival/Departure is required">
        <cfargument name="enteredByID" default="0" hint="ID of user entering the flight information">
		
        <cfquery datasource="MySql">
            UPDATE
            	smg_flight_info
            SET
            	enteredByID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.enteredByID#">,
            	isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
            WHERE 
            	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">  
			AND	
				flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.flightType#">            	         
        </cfquery>

	</cffunction>

	
    <!--- EMAIL FLIGHT INFORMATION --->
	<cffunction name="emailFlightInformation" access="public" returntype="void" output="false" hint="Sends out flight notification when information is added/edited or deleted">
    	<cfargument name="studentID" hint="studentID is required">
        <cfargument name="flightID" default="0" hint="flightID is not required, pass flightID of a leg that has been deleted">
		<cfargument name="emailPDF" default="1" hint="Set to 0 to send the flight arrival in HTML format">
        <cfargument name="sendEmailTo" default="" hint="regionalManager | currentUser">
       
   		<!--- Import CustomTag --->
		<cfimport taglib="../customTags/gui/" prefix="gui" />	

		<cfscript>
            var flightEmailTo = '';
			var flightEmailCC = '';
            var flightEmailBody = '';
			var flightInfoReport = '';
        	
            // Get Student Information
			qGetStudentFullInformation = getStudentFullInformationByID(ARGUMENTS.studentID);
			
			// Path to save temp PDF files
			pdfPath = APPLICATION.PATH.temp & '##' & qGetStudentFullInformation.studentID & '-' & qGetStudentFullInformation.firstName & qGetStudentFullInformation.familyLastName & '-FlightInformation.pdf';
			// Remove Empty Spaces
			pdfPath = ReplaceNoCase(pdfPath, " ", "", "ALL");
			
			// Get Host Family Information
			qGetHostFamily = APPLICATION.CFC.HOST.getHosts(hostID=qGetStudentFullInformation.hostID);
			
			// Get School Dates
			qGetSchoolDates = APPLICATION.CFC.SCHOOL.getSchoolDates(schoolID=qGetStudentFullInformation.schoolID, programID=qGetStudentFullInformation.programID);
			
            // Get Current User
            qGetCurrentUser = APPLICATION.CFC.USER.getUserByID(userID=CLIENT.userID);
            
            // Get Facilitator Email
            qGetFacilitator = APPLICATION.CFC.REGION.getRegionFacilitatorByRegionID(regionID=qGetStudentFullInformation.regionAssigned);
			
			// Get Regional Manager
			qGetRegionalManager = APPLICATION.CFC.USER.getRegionalManager(regionID=qGetStudentFullInformation.regionAssigned);
			
            // Get Specific Flight Information
            qGetDeletedFlightInfo = getFlightInformationByFlightID(flightID=VAL(ARGUMENTS.flightID));
            
            // Get Pre-AYP Arrival
            qGetPreAYPArrival = APPLICATION.CFC.STUDENT.getFlightInformation(studentID=VAL(qGetStudentFullInformation.studentID), flightType="arrival", isPreAYP=1);
    
            // Get Arrival
            qGetArrival = APPLICATION.CFC.STUDENT.getFlightInformation(studentID=VAL(qGetStudentFullInformation.studentID), flightType="arrival");
    
            // Get Departure
            qGetDeparture = APPLICATION.CFC.STUDENT.getFlightInformation(studentID=VAL(qGetStudentFullInformation.studentID), flightType="departure");

            // Check if it is a PHP student
            isPHPStudent = isStudentAssignedToPHP(qGetStudentFullInformation.studentID);
			
			// Default Flight Information
			flightInfoLink = '#CLIENT.exits_url#/nsmg/index.cfm?curdoc=student_info&studentID=#qGetStudentFullInformation.studentID#';
			
			// Set Up EmailTo and FlightInfo Link
            if ( isPHPStudent ) {
            	
				// PHP Student - Email Luke
				flightInfoLink = 'http://www.phpusa.com/internal/index.cfm?curdoc=student/student_info&unqid=#qGetStudentFullInformation.uniqueID#';
                flightEmailTo = APPLICATION.EMAIL.PHPContact;				

			} else if ( ARGUMENTS.sendEmailTo EQ 'regionalManager' AND IsValid("email", qGetRegionalManager.email) AND IsValid("email", qGetCurrentUser.email) ) {
				
				// Public Student - Email Regional Manager and send a copy to the current user
				flightEmailTo = qGetRegionalManager.email;
				flightEmailCC = qGetCurrentUser.email;
                
            } else if ( ARGUMENTS.sendEmailTo EQ 'regionalManager' AND IsValid("email", qGetRegionalManager.email) ) {
				
				// Public Student - Email Regional Manager | No copy to the current user
				flightEmailTo = qGetRegionalManager.email;

            } else if ( ARGUMENTS.sendEmailTo EQ 'currentUser' AND IsValid("email", qGetCurrentUser.email) ) {
				
				// Public Student - Email Current User
				flightEmailTo = qGetCurrentUser.email;

			} else if ( IsValid("email", qGetFacilitator.email) ) {
                
				// Public Student - Email Facilitator
                flightEmailTo = qGetFacilitator.email;
                
            } else if ( APPLICATION.IsServerLocal ) {
				
				// Local Server - Always email support
                flightEmailTo = APPLICATION.EMAIL.support;
			
			} else {
				
				// Not a valid email, use support
                flightEmailTo = APPLICATION.EMAIL.support;
            
			}
			
			// DELETE OR COMMENT THIS
			flightEmailTo = 'marcus@iseusa.com';
        </cfscript>
        
        <!--- Send out Email if there is a flight information or if a leg has been deleted --->
        <cfif qGetDeletedFlightInfo.recordCount OR qGetPreAYPArrival.recordCount OR qGetArrival.recordCount OR qGetDeparture.recordCount>
        	
            <cfoutput>
            	
                <!--- Information common for body and PDF--->
                <cfsavecontent variable="commonInformation">
 					
                    <p style="color: ##333;">
                        <span style="font-weight:bold;">Student:</span>
                        #qGetStudentFullInformation.firstName# #qGetStudentFullInformation.familyLastName# (###qGetStudentFullInformation.studentID#)
                    </p>

                    <p style="color: ##333;">
                        <span style="font-weight:bold;">International Representative:</span>
                        #qGetStudentFullInformation.intlRepBusinessName# (###qGetStudentFullInformation.intlRepUserID#)
                    </p>

                    <p style="color: ##333;">
                        <span style="font-weight:bold;">Program:</span>
                        #qGetStudentFullInformation.programName#
                    </p>
                	
                    <!--- Do Not Display for PHP --->
                    <cfif NOT isPHPStudent>
                    
                        <p style="color: ##333;">
                            <span style="font-weight:bold;">Region:</span>
                            #qGetStudentFullInformation.regionName#
                        </p>
        
                        <p style="color: ##333;">
                            <span style="font-weight:bold;">Regional Manager:</span>
                            #qGetRegionalManager.firstName# #qGetRegionalManager.lastName# (###qGetRegionalManager.userID#)
                            - Email: <a href="mailto:#qGetRegionalManager.email#">#qGetRegionalManager.email#</a> - Phone: #qGetRegionalManager.phone#
                        </p>
                        
                        <p style="color: ##333;">
                            <span style="font-weight:bold;">Area Representative:</span> 
                            #qGetStudentFullInformation.areaRepFirstName# #qGetStudentFullInformation.areaRepLastName# (###qGetStudentFullInformation.areaRepUserID#)
                            - Email: <a href="mailto:#qGetStudentFullInformation.areaRepEmail#">#qGetStudentFullInformation.areaRepEmail#</a> - Phone: #qGetStudentFullInformation.areaRepPhone#
                        </p>
                        
                        <p style="color: ##333;">
                            <span style="font-weight:bold;">Host Family:</span>
                            <!--- Host Father --->
                            <cfif LEN(qGetHostFamily.fatherFirstName)> 
                                Mr. #qGetHostFamily.fatherFirstName# 
                                <cfif qGetHostFamily.fatherLastName NEQ qGetHostFamily.motherLastName> 
                                    #qGetHostFamily.fatherLastName# 
                                </cfif>							
                            </cfif>
                            
                            <cfif LEN(qGetHostFamily.fatherFirstName) AND LEN(qGetHostFamily.motherFirstName)> and </cfif>                            
                            
                            <!--- Host Mother --->
                            <cfif LEN(qGetHostFamily.motherFirstName)>
                                Mrs. #qGetHostFamily.motherFirstName#
                                <cfif qGetHostFamily.fatherLastName NEQ qGetHostFamily.motherLastName> 
                                    #qGetHostFamily.motherLastName# 
                                </cfif>							
                            </cfif>
                            
                            <!--- Family Last Name --->                            
                            <cfif qGetHostFamily.fatherFirstName EQ qGetHostFamily.motherFirstName>
                                #qGetHostFamily.familyLastName#		
                            </cfif>
                            
                            (###qGetHostFamily.hostid#) - Phone: #qGetHostFamily.phone# <br />
                            
                            <!--- Address --->
                            <span style="margin-left:67px;">#qGetHostFamily.address#, #qGetHostFamily.city#, #qGetHostFamily.state# &nbsp #qGetHostFamily.zip#</span>
                        </p>
                        
                        <!--- Arrival Airport --->
                        <p style="color: ##333;">
                            <span style="font-weight:bold;">Arrival/Departure Airport:</span> 
                            <cfif LEN(qGetHostFamily.airport_city)>#qGetHostFamily.airport_city# <cfelse> n/a </cfif>
                            - Airport Code: <cfif LEN(qGetHostFamily.major_air_code)>#qGetHostFamily.major_air_code# <cfelse> n/a </cfif>
                        </p>
        			
                    </cfif>
                    
                    <!--- Notes --->
                    <p style="color: ##333;">
                        <span style="font-weight:bold;">Notes:</span> 
                        <cfif LEN(qGetStudentFullInformation.flight_info_notes)> #qGetStudentFullInformation.flight_info_notes# <cfelse> n/a </cfif>
                    </p>
                    
                    <!--- Today's Date --->
                    <p style="color: ##333;">
                        <span style="font-weight:bold;">Today's Date:</span> 
                        #DateFormat(now(), 'mm/dd/yyyy')# at #TimeFormat(now(), 'hh:mm tt')# EST
                    </p>
                    
                </cfsavecontent>
               
               
                <!--- Email Body --->
                <cfsavecontent variable="flightEmailBody">
					
                    <!--- Student Information --->
                    <fieldset style="margin: 5px 0px 10px 0px; padding: 7px; border: ##DDD 1px solid; font-size:13px;">
                        
                        <legend style="color: ##333; font-weight: bold; padding-bottom:5px; text-transform:uppercase;">
                            Flight Information
                        </legend>

                        <p style="color: ##333;">
                        	Please find flight information attached. If it looks good, please feel free to forward to your regional manager.                                                      
                        </p>

                        <p style="color: ##333;">
	                        This information can also be found on EXITS by clicking <a href="#flightInfoLink#">here</a> then click on "Flight Information".
						</p>
                        
                        <!--- Flight Leg Deleted --->
                        <cfif qGetDeletedFlightInfo.recordCount>
                            
                            <p style="color: ##333;">
                            
                                <cfif qGetDeletedFlightInfo.flight_type EQ 'arrival'>
                                    <p><strong>Arrival information has been deleted</strong></p>
                                </cfif>
                    
                                <cfif qGetDeletedFlightInfo.flight_type EQ 'departure'>
                                    <p><strong>Departure information has been deleted</strong></p>
                                </cfif>
                    
                                <p>
                                    The flight leg from <strong>#qGetDeletedFlightInfo.dep_aircode#</strong> to <strong>#qGetDeletedFlightInfo.arrival_aircode#</strong> 
                                    on <strong>#DateFormat(qGetDeletedFlightInfo.dep_date, 'mm/dd/yyyy')#</strong> has been deleted. Please see an updated flight information attached.
                                </p>
                            
                            </p>
                            
                        </cfif>
    					
                        <!--- Include Commom Information for Email Body and PDF --->
						#commonInformation#

                        <p style="color: ##333;">
                            <span style="font-weight:bold;">Updated By:</span> 
                            #qGetCurrentUser.firstName# #qGetCurrentUser.lastName# (###qGetCurrentUser.userID#) 
                            <cfif LEN(qGetCurrentUser.businessname)> - #qGetCurrentUser.businessname# </cfif>
                        </p>
                        
                        <cfif APPLICATION.IsServerLocal>
    
                            <p style="color: ##333; padding-bottom:5px; font-weight:bold;">
                                PS: Development Server
                            </p>
                        
                        </cfif>
                        
                    </fieldset>

                </cfsavecontent>
                
                	
				<!--- Flight Report --->
                <cfsavecontent variable="flightInfoReport">
                	
                    <!--- Include Header --->
                    <gui:pageHeader
                        headerType="pdf"
                    />
                
                    <!--- Student Information --->
                    <fieldset style="margin: 5px 0px 10px 0px; padding: 7px; border: ##DDD 1px solid; font-size:13px;">
                        
                        <legend style="color: ##333; font-weight: bold; padding-bottom:5px; text-transform:uppercase;">
                        	Flight Information
                        </legend>
						
                        <p style="color: ##333;">
                            We are pleased to give you the flight information for the student below. 
                            Please pass it to the host family information as soon as possible and in case of any doubt do not hesitate to contact us.
                        </p>

						#commonInformation#
                        
                    </fieldset>

                                    
                    <!--- Pre-AYP Arrival Information --->
                    <cfif qGetPreAYPArrival.recordCount>
                    
                        <fieldset style="margin: 5px 0px 10px 0px; padding: 7px; border: ##DDD 1px solid; font-size:13px;">
                            
                            <legend style="color: ##333; font-weight: bold; padding-bottom:5px; text-transform:uppercase;">PRE-AYP ARRIVAL INFORMATION</legend>
                            
                            <table cellspacing="1" style="width: 100%; border:1px solid ##0069aa; margin-bottom:15px; padding:0px; color: ##333; font-size:13px;">	
                                <tr style="color: ##fff; font-weight: bold; text-align:center; background-color: ##0069aa;">
                                    <td style="padding:4px 0px 4px 0px;">Date</td>
                                    <td style="padding:4px 0px 4px 0px;">Depart <br /> City</td>
                                    <td style="padding:4px 0px 4px 0px;">Depart <br /> Airport Code</td>
                                    <td style="padding:4px 0px 4px 0px;">Arrive <br /> City</td>
                                    <td style="padding:4px 0px 4px 0px;">Arrive <br /> Airport Code</td>
                                    <td style="padding:4px 0px 4px 0px;">Flight <br /> Number</td>
                                    <td style="padding:4px 0px 4px 0px;">Depart <br /> Time</td>
                                    <td style="padding:4px 0px 4px 0px;">Arrive <br /> Time</td>
                                    <td style="padding:4px 0px 4px 0px;">Overnight <br /> Flight</td>
                                </tr>                                
                                
                                <cfloop query="qGetPreAYPArrival">
                                    <tr style="text-align:center; <cfif qGetPreAYPArrival.currentRow MOD 2>background-color: ##EEEEEE;</cfif> ">
                                        <td style="padding:4px 0px 4px 0px;">#DateFormat(qGetPreAYPArrival.dep_date, 'mm/dd/yyyy')#</td>
                                        <td style="padding:4px 0px 4px 0px;">#qGetPreAYPArrival.dep_city#</td>
                                        <td style="padding:4px 0px 4px 0px;">#qGetPreAYPArrival.dep_airCode#</td>
                                        <td style="padding:4px 0px 4px 0px;">#qGetPreAYPArrival.arrival_city#</td>
                                        <td style="padding:4px 0px 4px 0px;">#qGetPreAYPArrival.arrival_airCode#</td>
                                        <td style="padding:4px 0px 4px 0px;">#qGetPreAYPArrival.flight_number#</td>
                                        <td style="padding:4px 0px 4px 0px;">#TimeFormat(qGetPreAYPArrival.dep_time, 'hh:mm tt')#</td>
                                        <td style="padding:4px 0px 4px 0px;">#TimeFormat(qGetPreAYPArrival.arrival_time, 'hh:mm tt')#</td>
                                        <td style="padding:4px 0px 4px 0px;">#YesNoFormat(VAL(qGetPreAYPArrival.overnight))#</td>
                                    </tr>

									<cfif VAL(qGetPreAYPArrival.overnight)>
                                    	<tr style="text-align:center; <cfif qGetPreAYPArrival.currentRow MOD 2>background-color: ##EEEEEE;</cfif> ">
                                    		<td colspan="9">
                                            	Please note arrival time is the next day due to an overnight flight.
                                            </td>
                                        </tr>
                                    </cfif>
                                    	
                                </cfloop> 
                                                               
                            </table>
                            
                        </fieldset>
                        
                    </cfif>
                    
                    
                    <!--- Arrival Information --->
                    <fieldset style="margin: 5px 0px 10px 0px; padding: 7px; border: ##DDD 1px solid; font-size:13px;">
                        
                        <legend style="color: ##333; font-weight: bold; padding-bottom:5px; text-transform:uppercase;">ARRIVAL TO HOST FAMILY INFORMATION</legend>

                        <!--- School Start Date --->
                        <p style="color: ##333;">
                            School Start Date: #qGetSchoolDates.startDate#
                        </p>

                        <cfif qGetArrival.recordCount>
                                
                            <table cellspacing="1" style="width: 100%; border:1px solid ##0069aa; margin-bottom:15px; padding:0px; color: ##333; font-size:13px;">	
                                <tr style="color: ##fff; font-weight: bold; text-align:center; background-color: ##0069aa;">
                                    <td style="padding:4px 0px 4px 0px;">Date</td>
                                    <td style="padding:4px 0px 4px 0px;">Depart <br /> City</td>
                                    <td style="padding:4px 0px 4px 0px;">Depart <br /> Airport Code</td>
                                    <td style="padding:4px 0px 4px 0px;">Arrive <br /> City</td>
                                    <td style="padding:4px 0px 4px 0px;">Arrive <br /> Airport Code</td>
                                    <td style="padding:4px 0px 4px 0px;">Flight <br /> Number</td>
                                    <td style="padding:4px 0px 4px 0px;">Depart <br /> Time</td>
                                    <td style="padding:4px 0px 4px 0px;">Arrive <br /> Time</td>
                                    <td style="padding:4px 0px 4px 0px;">Overnight <br /> Flight</td>
                                </tr>                                
            
                                <cfloop query="qGetArrival">
                                    <tr style="text-align:center; <cfif qGetArrival.currentRow MOD 2>background-color: ##EEEEEE;</cfif> ">
                                        <td style="padding:4px 0px 4px 0px;">#DateFormat(qGetArrival.dep_date, 'mm/dd/yyyy')#</td>
    
                                        <td style="padding:4px 0px 4px 0px;">#qGetArrival.dep_city#</td>
                                        <td style="padding:4px 0px 4px 0px;">#qGetArrival.dep_airCode#</td>
                                        <td style="padding:4px 0px 4px 0px;">#qGetArrival.arrival_city#</td>
                                        <td style="padding:4px 0px 4px 0px;">#qGetArrival.arrival_airCode#</td>
                                        <td style="padding:4px 0px 4px 0px;">#qGetArrival.flight_number#</td>
                                        <td style="padding:4px 0px 4px 0px;">#TimeFormat(qGetArrival.dep_time, 'hh:mm tt')#</td>
                                        <td style="padding:4px 0px 4px 0px;">#TimeFormat(qGetArrival.arrival_time, 'hh:mm tt')#</td>
                                        <td style="padding:4px 0px 4px 0px;">#YesNoFormat(VAL(qGetArrival.overnight))#</td>
                                    </tr>    
                                    
									<cfif VAL(qGetArrival.overnight)>
                                    	<tr style="text-align:center; <cfif qGetArrival.currentRow MOD 2>background-color: ##EEEEEE;</cfif> ">
                                    		<td colspan="9">
                                            	Please note arrival time is the next day due to an overnight flight.
                                            </td>
                                        </tr>
                                    </cfif>
                                                         
                                </cfloop>    						
                            
                            </table>
                            
                        <cfelse>
                            
                            <table cellspacing="0" style="width: 100%; border:1px solid ##0069aa; margin-bottom:15px; padding:0px; font-size:13px;">	
                                <tr style="color: ##fff; font-weight: bold; background-color: ##0069aa;">
                                    <td align="center" style="padding:4px 0px 4px 0px;">No Arrival information at this moment</td>
                                </tr>                                
                            </table>
                            
                        </cfif>
                
                    </fieldset>
                	
                    
                    <!--- Departure Information --->
                    <fieldset style="margin: 5px 0px 10px 0px; padding: 7px; border: ##DDD 1px solid; font-size:13px;">
                        
                        <legend style="color: ##333; font-weight: bold; padding-bottom:5px; text-transform:uppercase;">DEPARTURE FROM USA INFORMATION</legend>

                        <!--- School End Date --->
                        <p style="color: ##333;">
                            School End Date: #qGetSchoolDates.endDate#
                        </p>
                
                        <cfif qGetDeparture.recordCount>
                                
                            <table cellspacing="1" style="width: 100%; border:1px solid ##0069aa; margin-bottom:15px; padding:0px; font-size:13px;">	
                                <tr style="color: ##fff; font-weight: bold; text-align:center; background-color: ##0069aa;">
                                    <td style="padding:4px 0px 4px 0px;">Date</td>
                                    <td style="padding:4px 0px 4px 0px;">Depart <br /> City</td>
                                    <td style="padding:4px 0px 4px 0px;">Depart <br /> Airport Code</td>
                                    <td style="padding:4px 0px 4px 0px;">Arrive <br /> City</td>
                                    <td style="padding:4px 0px 4px 0px;">Arrive <br /> Airport Code</td>
                                    <td style="padding:4px 0px 4px 0px;">Flight <br /> Number</td>
                                    <td style="padding:4px 0px 4px 0px;">Depart <br /> Time</td>
                                    <td style="padding:4px 0px 4px 0px;">Arrive <br /> Time</td>
                                    <td style="padding:4px 0px 4px 0px;">Overnight <br /> Flight</td>
                                </tr>                                
            
                                <cfloop query="qGetDeparture">
                                    <tr style="text-align:center; <cfif qGetDeparture.currentRow MOD 2>background-color: ##EEEEEE;</cfif> ">
                                        <td style="padding:4px 0px 4px 0px;">#DateFormat(qGetDeparture.dep_date, 'mm/dd/yyyy')#</td>
                                        <td style="padding:4px 0px 4px 0px;">#qGetDeparture.dep_city#</td>
                                        <td style="padding:4px 0px 4px 0px;">#qGetDeparture.dep_airCode#</td>
                                        <td style="padding:4px 0px 4px 0px;">#qGetDeparture.arrival_city#</td>
                                        <td style="padding:4px 0px 4px 0px;">#qGetDeparture.arrival_airCode#</td>
                                        <td style="padding:4px 0px 4px 0px;">#qGetDeparture.flight_number#</td>
                                        <td style="padding:4px 0px 4px 0px;">#TimeFormat(qGetDeparture.dep_time, 'hh:mm tt')#</td>
                                        <td style="padding:4px 0px 4px 0px;">#TimeFormat(qGetDeparture.arrival_time, 'hh:mm tt')#</td>
                                        <td style="padding:4px 0px 4px 0px;">#YesNoFormat(VAL(qGetDeparture.overnight))#</td>
                                    </tr>      

									<cfif VAL(qGetDeparture.overnight)>
                                    	<tr style="text-align:center; <cfif qGetDeparture.currentRow MOD 2>background-color: ##EEEEEE;</cfif> ">
                                    		<td colspan="9">
                                            	Please note arrival time is the next day due to an overnight flight.
                                            </td>
                                        </tr>
                                    </cfif>

                                </cfloop>    						
                            
                            </table>
                            
                        <cfelse>
                            
                            <table cellspacing="0" style="width: 100%; border:1px solid ##0069aa; margin-bottom:15px; padding:0px; font-size:13px;">	
                                <tr style="color: ##fff; font-weight: bold; background-color: ##0069aa;">
                                    <td align="center" style="padding:4px 0px 4px 0px;">No Departure information at this moment</td>
                                </tr>                                
                            </table>
                            
                        </cfif>
                
                    </fieldset>
                
                </cfsavecontent>           
                
                <!--- Flight Information - PDF Format --->
                <cfdocument name="pdfFlightInfo" format="pdf" localUrl="no" backgroundvisible="yes" margintop="0.2" marginright="0.2" marginbottom="0.2" marginleft="0.2">
                    #flightInfoReport#
                </cfdocument>
            
            </cfoutput>
            
            <!--- Try To Email a PDF File, if unsuccessful adds the report to the email body --->
            <cftry>
                    
				<!--- Create a PDF document in the temp folder --->
                <cffile 
                    action="write"
                    file="#pdfPath#"
                    output="#pdfFlightInfo#"
                    nameconflict="overwrite">
                
                <cfinvoke component="nsmg.cfc.email" method="send_mail">
                    <cfinvokeargument name="email_to" value="#flightEmailTo#">
                    <cfinvokeargument name="email_cc" value="#flightEmailCC#">
                    <cfinvokeargument name="email_subject" value="Flight Information for #qGetStudentFullInformation.firstname# #qGetStudentFullInformation.familylastname# (###qGetStudentFullInformation.studentID#)">
                    <cfinvokeargument name="email_message" value="#flightEmailBody#">
                    <cfinvokeargument name="email_from" value="#CLIENT.support_email#">
                    <cfinvokeargument name="email_file" value="#pdfPath#">
                </cfinvoke>       
			
                <cfcatch type="any">
						
                    <!--- Send Out Email - NO PDF --->
                    <cfinvoke component="nsmg.cfc.email" method="send_mail">
                        <cfinvokeargument name="email_to" value="#flightEmailTo#">
                        <cfinvokeargument name="email_cc" value="#flightEmailCC#">
                        <cfinvokeargument name="email_subject" value="Flight Information for #qGetStudentFullInformation.firstname# #qGetStudentFullInformation.familylastname# (###qGetStudentFullInformation.studentID#)">
                        <cfinvokeargument name="email_message" value="#flightInfoReport#">
                        <cfinvokeargument name="email_from" value="#CLIENT.support_email#">
                    </cfinvoke>       
                
                </cfcatch>
			
            </cftry>
        
        </cfif>
            
    </cffunction>
    

	<!--- ------------------------------------------------------------------------- ----
		
		END OF FLIGHT INFORMATION
	
	----- ------------------------------------------------------------------------- --->


	<!--- ------------------------------------------------------------------------- ----
		
		PLACEMENT PAPERWORK
	
	----- ------------------------------------------------------------------------- --->

	<cffunction name="checkPlacementPaperwork" access="public" returntype="string" output="false" hint="Check if placement paperwork was received by deadline">
        <cfargument name="studentID" default="0" hint="studentID is not required">
		<cfargument name="paymentTypeID" default="0" hint="Payment Type ID">
			
        <cfquery 
			name="qCheckPlacementPaperwork" 
			datasource="#APPLICATION.dsn#">
                SELECT 
                    studentID,
                    hostID,
                    date_pis_received,
                    doc_full_host_app_date,
                    doc_letter_rec_date,
                    doc_rules_rec_date,
                    doc_photos_rec_date,
                    doc_school_profile_rec,
                    doc_conf_host_rec,
                    doc_date_of_visit,
                    doc_ref_form_1,
                    doc_ref_check1,
                    doc_ref_form_2,
                    doc_ref_check2,
                    doc_income_ver_date,
                    doc_school_accept_date,
                    doc_school_sign_date,
                    <!--- Non-Traditional Placement / Extra Paperwork --->
                    doc_single_place_auth,
                    doc_single_ref_form_1,
                    doc_single_ref_check1,
                    doc_single_ref_form_2,
                    doc_single_ref_check2,
                    doc_conf_host_rec2,
                    doc_date_of_visit2
                FROM 
                	smg_students
                WHERE 
                    studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">                    	
		</cfquery>
        
        <!---
			Fast Track Bonus $1500 - Paperwork must be received by April 15th
			Early Placement $1000 - Paperwork must be received by June 1st (April 16th - June 1st)
			Paperwork Bunus $500 - Paperwork must be received by August 1st (June 2nd - August 1st)		
			
			Pre-AYP Bonus $250 - Placed by May 10th
			Pre-AYP Bonus $200 - Placed by June 1st
			Pre-AYP Bonus $150 - Placed by June 24th
			
			Non-Traditional Placement (Single Parent)
				- Single Person Placement Verification
				- Single Person Placement Reference 1
				- Single Person Placement Reference 2
				- 2nd Confidential Host Family Visit Form
		--->
			
        <cfscript>
			// Declare return structure
			returnMessage = '';
			
			// Store deadline
			setDeadline = '';
			
			// Stores total family members
			totalFamilyMembers =  0;
			
			// Check if we are processing Fast Start, Early Placement, Paperwork Bonus, Pre-AYP 250, Pre-AYP 200, Pre-AYP-150
			switch(ARGUMENTS.paymentTypeID) {
				
				// Set deadline based on payment type
				
				// Fast Track Bonus
				case 17: {
					setDeadline = '04/22/' &  Year(now());
					break;
				}
				// Early Placement Bonus
				case 15: {
					setDeadline = '06/01/' &  Year(now());
					break;
				}
				// Paperwork Bonus
				case 9: {
					setDeadline = '08/01/' &  Year(now());
					break;
				}
				
				// Pre-AYP Bonus $250
				case 18: {
					setDeadline = '05/10/' &  Year(now());
					break;
				}
				// Pre-AYP Bonus $200
				case 19: {
					setDeadline = '06/01/' &  Year(now());
					break;
				}
				// Pre-AYP Bonus $150
				case 20: {
					setDeadline = '06/24/' &  Year(now());
					break;
				}

			}
			
			// Check if we have a deadline
			if ( IsDate(setDeadline) ) {
				
				// Get Host Family Information
				qGetHostInfo = APPLICATION.CFC.HOST.getHosts(hostID=VAL(qCheckPlacementPaperwork.hostID));
	
				// Check if there is a host father
				if ( LEN(qGetHostInfo.fatherFirstName) ) {
					totalFamilyMembers = totalFamilyMembers + 1;	 
				}
				
				// Check if there is a host mother
				if ( LEN(qGetHostInfo.motherFirstName) ) {
					totalFamilyMembers = totalFamilyMembers + 1;	 
				}
				
				// Get Host Children
				qGetChildrenAtHome = APPLICATION.CFC.HOST.getHostMemberByID(hostID=qCheckPlacementPaperwork.hostID,liveAtHome='yes');
	
				totalFamilyMembers = totalFamilyMembers + qGetChildrenAtHome.recordCount;
				
				// Check PaperWork

				// Placement Information Sheet
				if ( NOT LEN(qCheckPlacementPaperwork.date_pis_received) OR qCheckPlacementPaperwork.date_pis_received GT setDeadline ) {
					returnMessage = returnMessage & 'Placement Information Sheet has not been received or received after deadline - Date Received: #DateFormat(qCheckPlacementPaperwork.date_pis_received, 'mm/dd/yyyy')#. <br />'; 	
				}

				// Host Application Received
				if ( NOT LEN(qCheckPlacementPaperwork.doc_full_host_app_date) OR qCheckPlacementPaperwork.doc_full_host_app_date GT setDeadline ) {
					returnMessage = returnMessage & 'Host Application has not been received or received after deadline - Date Received: #DateFormat(qCheckPlacementPaperwork.doc_full_host_app_date, 'mm/dd/yyyy')#. <br />'; 	
				}

				// Host Family Letter Received
				if ( NOT LEN(qCheckPlacementPaperwork.doc_letter_rec_date) OR qCheckPlacementPaperwork.doc_letter_rec_date GT setDeadline ) {
					returnMessage = returnMessage & 'Host Family Letter has not been received or received after deadline - Date Received: #DateFormat(qCheckPlacementPaperwork.doc_letter_rec_date, 'mm/dd/yyyy')#. <br />'; 	
				}

				// Host Family Rules Form
				if ( NOT LEN(qCheckPlacementPaperwork.doc_rules_rec_date) OR qCheckPlacementPaperwork.doc_rules_rec_date GT setDeadline ) {
					returnMessage = returnMessage & 'Host Family Rules Form has not been received or received after deadline - Date Received: #DateFormat(qCheckPlacementPaperwork.doc_rules_rec_date, 'mm/dd/yyyy')#. <br />'; 	
				}

				// Host Family Photos
				if ( NOT LEN(qCheckPlacementPaperwork.doc_photos_rec_date) OR qCheckPlacementPaperwork.doc_photos_rec_date GT setDeadline ) {
					returnMessage = returnMessage & 'Host Family Photos has not been received or received after deadline - Date Received: #DateFormat(qCheckPlacementPaperwork.doc_photos_rec_date, 'mm/dd/yyyy')#. <br />'; 	
				}

				// School & Community Profile Form
				if ( NOT LEN(qCheckPlacementPaperwork.doc_school_profile_rec) OR qCheckPlacementPaperwork.doc_school_profile_rec GT setDeadline ) {
					returnMessage = returnMessage & 'School & Community Profile Form has not been received or received after deadline - Date Received: #DateFormat(qCheckPlacementPaperwork.doc_school_profile_rec, 'mm/dd/yyyy')#. <br />'; 	
				}

				// Confidential Host Family Visit Form
				if ( NOT LEN(qCheckPlacementPaperwork.doc_conf_host_rec) OR qCheckPlacementPaperwork.doc_conf_host_rec GT setDeadline ) {
					returnMessage = returnMessage & 'Confidential Host Family Visit Form has not been received or received after deadline - Date Received: #DateFormat(qCheckPlacementPaperwork.doc_conf_host_rec, 'mm/dd/yyyy')#. <br />'; 	
				}

				// Reference Form 1
				if ( NOT LEN(qCheckPlacementPaperwork.doc_ref_form_1) OR qCheckPlacementPaperwork.doc_ref_form_1 GT setDeadline ) {
					returnMessage = returnMessage & 'Reference Form 1 has not been received or received after deadline - Date Received: #DateFormat(qCheckPlacementPaperwork.doc_ref_form_1, 'mm/dd/yyyy')#. <br />'; 	
				}
				
				// Reference Form 2
				if ( NOT LEN(qCheckPlacementPaperwork.doc_ref_form_2) OR qCheckPlacementPaperwork.doc_ref_form_2 GT setDeadline ) {
					returnMessage = returnMessage & 'Reference Form 2 has not been received or received after deadline - Date Received: #DateFormat(qCheckPlacementPaperwork.doc_ref_form_2, 'mm/dd/yyyy')#. <br />'; 	
				}
				
				// Income Verification Form
				if ( NOT LEN(qCheckPlacementPaperwork.doc_income_ver_date) OR qCheckPlacementPaperwork.doc_income_ver_date GT setDeadline ) {
					returnMessage = returnMessage & 'Income Verification Form has not been received or received after deadline - Date Received: #DateFormat(qCheckPlacementPaperwork.doc_income_ver_date, 'mm/dd/yyyy')#. <br />'; 	
				}
				
				// School Acceptance Form
				if ( NOT LEN(qCheckPlacementPaperwork.doc_school_accept_date) OR qCheckPlacementPaperwork.doc_school_accept_date GT setDeadline ) {
					returnMessage = returnMessage & 'School Acceptance Form has not been received or received after deadline - Date Received: #DateFormat(qCheckPlacementPaperwork.doc_school_accept_date, 'mm/dd/yyyy')#. <br />'; 	
				}
				
				// Host Father CBC
				if ( LEN(qGetHostInfo.fatherFirstName) AND ( NOT LEN(qGetHostInfo.fathercbc_form) OR qGetHostInfo.fathercbc_form GT setDeadline ) ) {
					returnMessage = returnMessage & 'Host Father CBC has not been received or received after deadline - Date Received: #DateFormat(qGetHostInfo.fathercbc_form, 'mm/dd/yyyy')#. <br />'; 	
				}
				
				// Host Mother CBC
				if ( LEN(qGetHostInfo.motherFirstName) AND ( NOT LEN(qGetHostInfo.mothercbc_form) OR qGetHostInfo.mothercbc_form GT setDeadline ) ) {
					returnMessage = returnMessage & 'Host Mother CBC has not been received or received after deadline - Date Received: #DateFormat(qGetHostInfo.mothercbc_form, 'mm/dd/yyyy')#. <br />'; 	
				}
				
				// Host Member CBC
				
				// Non-Traditional Placement - Extra Documents
				if ( totalFamilyMembers EQ 1 ) {

					// Single Person Placement Verification
					if ( NOT LEN(qCheckPlacementPaperwork.doc_single_place_auth) OR qCheckPlacementPaperwork.doc_single_place_auth GT setDeadline ) {
						returnMessage = returnMessage & 'Single Person Placement Verification has not been received or received after deadline - Date Received: #DateFormat(qCheckPlacementPaperwork.doc_single_place_auth, 'mm/dd/yyyy')#. <br />'; 	
					}

					// Single Person Placement Reference 1
					if ( NOT LEN(qCheckPlacementPaperwork.doc_single_ref_form_1) OR qCheckPlacementPaperwork.doc_single_ref_form_1 GT setDeadline ) {
						returnMessage = returnMessage & 'Single Person Placement Reference 1 has not been received or received after deadline - Date Received: #DateFormat(qCheckPlacementPaperwork.doc_single_ref_form_1, 'mm/dd/yyyy')#. <br />'; 	
					}

					// Single Person Placement Reference 2
					if ( NOT LEN(qCheckPlacementPaperwork.doc_single_ref_form_2) OR qCheckPlacementPaperwork.doc_single_ref_form_2 GT setDeadline ) {
						returnMessage = returnMessage & 'Single Person Placement Reference 2 has not been received or received after deadline - Date Received: #DateFormat(qCheckPlacementPaperwork.doc_single_ref_form_2, 'mm/dd/yyyy')#. <br />'; 	
					}
					
					// 2nd Confidential Host Family Visit Form
					if ( NOT LEN(qCheckPlacementPaperwork.doc_conf_host_rec2) OR qCheckPlacementPaperwork.doc_conf_host_rec2 GT setDeadline ) {
						returnMessage = returnMessage & '2nd Confidential Host Family Visit Form has not been received or received after deadline - Date Received: #DateFormat(qCheckPlacementPaperwork.doc_conf_host_rec2, 'mm/dd/yyyy')#. <br />'; 	
					}
					
				} // Non-Traditional Placement - Extra Documents

			} // Check if we have a deadline
			
			return returnMessage;
		</cfscript>
        
	</cffunction>

	<!--- ------------------------------------------------------------------------- ----
		
		END OF PLACEMENT PAPERWORK
	
	----- ------------------------------------------------------------------------- --->


	<!--- ------------------------------------------------------------------------- ----
		
		PROJECT HELP
	
	----- ------------------------------------------------------------------------- --->
    
    <!--- 
		Status Array 
		APPLICATION.Constants.projectHelpStatus[1] = "created";
		APPLICATION.Constants.projectHelpStatus[2] = "sr_approved";
		APPLICATION.Constants.projectHelpStatus[3] = "ra_approved";
		APPLICATION.Constants.projectHelpStatus[4] = "ra_rejected";
		APPLICATION.Constants.projectHelpStatus[5] = "rd_approved";
		APPLICATION.Constants.projectHelpStatus[6] = "rd_rejected";
		APPLICATION.Constants.projectHelpStatus[7] = "ny_approved";
		APPLICATION.Constants.projectHelpStatus[8] = "ny_rejected";	
	--->
    
	<cffunction name="getProjectHelpList" access="public" returntype="query" output="false" hint="Gets a list of students, if studentID is passed gets a student by ID">
    	<cfargument name="userID" default="0" hint="User ID is required">
        <cfargument name="regionID" default="0" hint="Region ID is not required">
        <cfargument name="userType" hint="UserType is required">
        <cfargument name="isActive" default="1" hint="Active status is not required">
        <cfargument name="statusKey" default="" hint="Project Help Status Key is not required">

        <cfquery 
			name="qGetProjectHelpList" 
			datasource="#APPLICATION.dsn#">
                SELECT 
                	s.studentID, 
                    s.firstname, 
                    s.familylastname,
                    <!--- Area Rep --->
                    s.areaRepID,
                    area.firstname as rep_firstName, 
                    area.lastname as rep_lastName,
                    <!--- Advisor --->
                    adv.userID AS advisorID,
                    adv.firstname as advisor_firstname, 
                    adv.lastname as advisor_lastname,
                    <!--- Program --->
					p.programName,
                    <!--- Project Help --->
                    ph.ID as projectHelpID,
                    ph.status_key,
					<!--- Super Rep --->
                    ph.sr_user_id,
                    ph.sr_date_submitted,
                    <!--- Regional Advisor --->
                    ph.ra_user_id,
                    ph.ra_date_approved,
                    ph.ra_date_rejected,
                    ph.ra_reason,
					<!--- Regional Director --->
                    ph.rd_user_id,
                    ph.rd_date_approved,
                    ph.rd_date_rejected, 
                    ph.rd_reason,                   
                    <!--- Office --->
                    ph.ny_user_id,
                    ph.ny_date_approved,
                    ph.ny_date_rejected,
                    ph.ny_reason
                FROM 
                	smg_students s
                INNER JOIN 
                	smg_programs p ON s.programID = p.programID
                INNER JOIN 
                	smg_users area ON s.arearepID = area.userID
                INNER JOIN 
                	user_access_rights uar ON 
                    (
                    	s.arearepID = uar.userID
	                AND 
                    	s.regionassigned = uar.regionID
	                )
                LEFT OUTER JOIN 
                	smg_users adv ON uar.advisorID = adv.userID
				LEFT OUTER JOIN
					smg_project_help ph ON ph.student_id = s.studentID                                    
                WHERE 
                	1 = 1 
                    
				<cfif VAL(ARGUMENTS.isActive)>
                    AND 
                        s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                </cfif>
                
                <cfif VAL(ARGUMENTS.regionID)>                    
                    AND
                        s.regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.regionID#">                    
                </cfif>
                
                <!--- regional advisor sees only their reps or their students. --->
                <cfif ARGUMENTS.userType EQ 6>
                    AND 
                    (
                        uar.advisorID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">
                    OR 
                        s.arearepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">
                    )
                <!--- supervising reps sees only their students. --->
                <cfelseif ARGUMENTS.userType EQ 7>
                    AND 
                        s.arearepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">
                </cfif>
                
                <cfif LEN(ARGUMENTS.statusKey)>
                    AND
                        ph.status_key = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.statusKey#">                    
                </cfif>
                    
				<!--- include the advisorID and arearepID because we're grouping by those in the output, just in case two have the same first and last name. --->
                ORDER BY 
                    advisor_lastname, 
                    advisor_firstname, 
                    uar.advisorID, 
                    rep_lastname, 
                    rep_firstname, 
                    s.arearepID, 
                    s.familylastname, 
                    s.firstname
        	</cfquery>
            
		<cfreturn qGetProjectHelpList>
	</cffunction>


	<cffunction name="getProjectHelpDetail" access="public" returntype="query" output="false" hint="Gets a progress report details by student">
    	<cfargument name="projectHelpID" default="0" hint="projectHelpID is not required">
        <cfargument name="studentID" default="0" hint="studentID is not required">

        <cfquery 
			name="qGetProjectHelpDetail" 
			datasource="#APPLICATION.dsn#">
                SELECT 
                	id,
                    student_id,
                    status_key,
					<!--- Super Rep --->
                    sr_user_id,
                    sr_date_submitted,
                    <!--- Regional Advisor --->
                    ra_user_id,
                    ra_date_approved,
                    ra_date_rejected,
                    ra_reason,
					<!--- Regional Director --->
                    rd_user_id,
                    rd_date_approved,
                    rd_date_rejected, 
                    rd_reason,                   
                    <!--- Office --->
                    ny_user_id,
                    ny_date_approved,
                    ny_date_rejected,
                    ny_reason,
                    <!--- Date Fields - Audit purpose --->
                    date_created,
                    date_updated
                FROM 
                	smg_project_help
                WHERE 
                	1 = 1

                    <cfif VAL(ARGUMENTS.projectHelpID)>
					AND                    	
                        id = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.projectHelpID#">                    	
                    </cfif>
                    
                    <cfif VAL(ARGUMENTS.studentID)>
					AND                    	
                        student_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">                    	
                    </cfif>
                    
        	</cfquery>
            
		<cfreturn qGetProjectHelpDetail>
	</cffunction>


	<cffunction name="submitProjectHelp" access="public" returntype="void" output="false" hint="Submit Approve/Deny a project help">
    	<cfargument name="projectHelpID" hint="projectHelp ID is required">
        <cfargument name="approvedBy" hint="approved by is required">
        <cfargument name="approvedType" hint="Approved type is required. (superRep, regionalAdvisor, regionalManager, office)"> 
        <cfargument name="isApproved" default="1" hint="Is Approved is not required"> 
        <cfargument name="reason" default="" hint="Reason is not required">      

        <cfquery 
			datasource="#APPLICATION.dsn#">
                UPDATE
                	smg_project_help
                SET
                	 <cfswitch expression="#ARGUMENTS.approvedType#">
                     	
                        <!--- Super Representative --->
                        <cfcase value="superRep">
                            sr_user_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.approvedBy)#">,
                            sr_date_submitted = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,  
                            status_key = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.Constants.projectHelpStatus[2]#">,
                            
                            <!--- Reset Approvals --->
                            ra_reason = <cfqueryparam cfsqltype="cf_sql_varchar" value="">, 
                            ra_date_approved = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
                            ra_date_rejected = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,  
                            
                            rd_reason = <cfqueryparam cfsqltype="cf_sql_varchar" value="">, 
                            rd_date_approved = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
                            rd_date_rejected = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,  
                            
                            ny_reason = <cfqueryparam cfsqltype="cf_sql_varchar" value="">, 
                            ny_date_approved = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
                            ny_date_rejected = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,  
                        </cfcase>

						<!--- Regional Advisor --->
                        <cfcase value="regionalAdvisor">
                            ra_user_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.approvedBy)#">,
							<cfif VAL(ARGUMENTS.isApproved)>
                            	ra_date_approved = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                                ra_date_rejected = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
                                ra_reason = <cfqueryparam cfsqltype="cf_sql_varchar" value="">,
                                status_key = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.Constants.projectHelpStatus[3]#">,
                            <cfelse>
                            	ra_date_approved = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
                                ra_date_rejected = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                                ra_reason = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.reason#">,
                                status_key = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.Constants.projectHelpStatus[4]#">,
                            </cfif>
                            
                            <!--- Reset Approvals --->
                            rd_reason = <cfqueryparam cfsqltype="cf_sql_varchar" value="">, 
                            rd_date_approved = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
                            rd_date_rejected = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,  
                            
                            ny_reason = <cfqueryparam cfsqltype="cf_sql_varchar" value="">, 
                            ny_date_approved = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
                            ny_date_rejected = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,  
                        </cfcase>

						<!--- Regional Manager --->
                        <cfcase value="regionalManager">
                            rd_user_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.approvedBy)#">,
							<cfif VAL(ARGUMENTS.isApproved)>
                            	rd_date_approved = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                                rd_date_rejected = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
                                rd_reason = <cfqueryparam cfsqltype="cf_sql_varchar" value="">,
                                status_key = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.Constants.projectHelpStatus[5]#">,
                                
								<!--- Reset Rejections --->
                                ra_date_rejected = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
                                ra_reason = <cfqueryparam cfsqltype="cf_sql_varchar" value="">,
                            <cfelse>
                            	rd_date_approved = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
                            	rd_date_rejected = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                                rd_reason = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.reason#">,
                                status_key = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.Constants.projectHelpStatus[6]#">,
                            </cfif>

                            <!--- Reset Approvals --->
                            ny_reason = <cfqueryparam cfsqltype="cf_sql_varchar" value="">, 
                            ny_date_approved = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
                            ny_date_rejected = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,  
                        </cfcase>

						<!--- NY Office --->
                        <cfcase value="office">
                            ny_user_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.approvedBy)#">,
							<cfif VAL(ARGUMENTS.isApproved)>
                            	ny_date_approved = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                                ny_date_rejected = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
                                ny_reason = <cfqueryparam cfsqltype="cf_sql_varchar" value="">,
                                status_key = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.Constants.projectHelpStatus[7]#">,

								<!--- Reset Rejections --->
                                ra_date_rejected = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
                                ra_reason = <cfqueryparam cfsqltype="cf_sql_varchar" value="">,
                                rd_date_rejected = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
                                rd_reason = <cfqueryparam cfsqltype="cf_sql_varchar" value="">,
                            <cfelse>
                            	ny_date_approved = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
                            	ny_date_rejected = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                                ny_reason = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.reason#">,
                                status_key = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.Constants.projectHelpStatus[8]#">,
                            </cfif>

                       </cfcase>
                     
                     </cfswitch>
					
                   	date_updated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">                    	
                    
                WHERE 
                    id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.projectHelpID)#">                    
        	</cfquery>
            
            <!--- Set Activities as Approved --->
            <cfif ARGUMENTS.approvedType EQ 'office' AND VAL(ARGUMENTS.isApproved)>
            
                <cfquery 
                    datasource="#APPLICATION.dsn#">
                        UPDATE
                            smg_project_help_activities
						SET
                        	date_approved = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                        WHERE                            
                            project_help_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.projectHelpID)#">  
                        AND
                        	date_approved IS NULL
                </cfquery>
	            
            </cfif>
            
	</cffunction>


	<cffunction name="getProjectHelpActivities" access="public" returntype="query" output="false" hint="Gets a project help hours by project help ID">
    	<cfargument name="projectHelpID" hint="ProjectHelp ID is required">

        <cfquery 
			name="qGetProjectHelpActivities" 
			datasource="#APPLICATION.dsn#">
                SELECT 
                	id,
                    project_help_id,
                    activity,
                    hours,
                    date_completed,
                    date_approved,
                    date_created,
                    date_updated
                FROM 
                	smg_project_help_activities
                WHERE 
                    project_help_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.projectHelpID)#">  
				AND
                	is_deleted = <cfqueryparam cfsqltype="cf_sql_integer" value="0">                    
				ORDER BY
                	date_completed                    
		</cfquery>
            
		<cfreturn qGetProjectHelpActivities>
	</cffunction>


	<cffunction name="getProjectHelpTotalHours" access="public" returntype="numeric" output="false" hint="Gets total hours by project help ID">
    	<cfargument name="projectHelpID" hint="ProjectHelp ID is required">

        <cfquery 
			name="qGetProjectHelpActivities" 
			datasource="#APPLICATION.dsn#">
                SELECT 
                    SUM(hours) as hours
                FROM 
                	smg_project_help_activities
                WHERE 
                    project_help_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.projectHelpID)#"> 
				AND
                	is_deleted = <cfqueryparam cfsqltype="cf_sql_integer" value="0">                    
				GROUP BY
                	project_help_id	                    
		</cfquery>
            
		<cfreturn VAL(qGetProjectHelpActivities.hours)>
	</cffunction>


	<cffunction name="insertProjectHelp" access="public" returntype="numeric" output="false" hint="Inserts a project help and returns the ID">
        <cfargument name="studentID" hint="studentID is required">
    	<cfargument name="srUserID" default="0" hint="srUserID is not required">
    	<cfargument name="raUserID" default="0" hint="raUserID is not required">
    	<cfargument name="rdUserID" default="0" hint="rdUserID is not required">
    	<cfargument name="nyUserID" default="0" hint="nyUserID is not required">                   
		
            <cfquery 
            	name="checkProject"
                datasource="#APPLICATION.dsn#">
					SELECT
                    	id
					FROM
                    	smg_project_help
					WHERE
                    	student_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">
            </cfquery>
            
            <!--- If Student has already a record, return the record ID --->
            <cfif checkProject.recordCount>
            
	            <cfreturn checkProject.ID>
    
            <cfelse>
            
                <cfquery 
                    datasource="#APPLICATION.dsn#">
                        INSERT INTO
                            smg_project_help
                        (
                            student_id,
                            status_key,
                            sr_user_id,
                            ra_user_id,
                            rd_user_id,
                            ny_user_id,
                            date_created,
                            date_updated
                        ) 
                        VALUES 
                        (
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.Constants.projectHelpStatus[1]#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.srUserID)#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.raUserID)#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.rdUserID)#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.nyUserID)#">,
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                        )
                </cfquery>            			                    
    
                <cfquery 
                    name="getProjectHelpID"
                    datasource="#APPLICATION.dsn#">
                        SELECT 
                            MAX(id) as ID
                        FROM
                            smg_project_help
                </cfquery>            			                    
				
                <cfreturn getProjectHelpID.ID>
                
			</cfif>
		            
	</cffunction>


	<cffunction name="insertProjectHelpActivity" access="public" returntype="void" output="false" hint="Inserts a project help activity">
    	<cfargument name="projectHelpID" hint="projectHelpID is required">
    	<cfargument name="srUserID" default="0" hint="srUserID is not required">
    	<cfargument name="raUserID" default="0" hint="raUserID is not required">
    	<cfargument name="rdUserID" default="0" hint="rdUserID is not required">
    	<cfargument name="nyUserID" default="0" hint="nyUserID is not required">                   
        <cfargument name="studentID" hint="studentID is required">
        <cfargument name="activity" hint="activity is required">
        <cfargument name="hours" hint="hours is required">
        <cfargument name="dateCompleted" hint="date completed is required">
        <cfargument name="userType" hint="UserType is required">

		<cfscript>
			// Check if there is a project Help
			if ( NOT VAL(ARGUMENTS.projectHelpID) ) {
				// Insert Project Help and get the last ID
				ARGUMENTS.projectHelpID = insertProjectHelp(
					studentID=ARGUMENTS.studentID,
					srUserID=ARGUMENTS.srUserID,
					raUserID=ARGUMENTS.raUserID,
					rdUserID=ARGUMENTS.rdUserID,
					nyUserID=ARGUMENTS.nyUserID					
				);
			}
			
			// Get Project Help Details
			qGetPHDetail = getProjectHelpDetail(projectHelpID=ARGUMENTS.projectHelpID);
		</cfscript>
		
        <!--- Check if Project Help has been approved, if so re-set approvals --->
        <cfif LEN(qGetPHDetail.sr_date_submitted) OR LEN(qGetPHDetail.ra_date_approved) OR LEN(qGetPHDetail.rd_date_approved) OR LEN(qGetPHDetail.ny_date_approved)>

            <cfquery 
                datasource="#APPLICATION.dsn#">
                    UPDATE
                        smg_project_help
                    SET
                        <cfswitch expression="#ARGUMENTS.userType#">
                        	
                            <!--- NY Office --->
                        	<cfcase value="1,2,3,4">
                                ny_date_approved = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
                                ny_date_rejected = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
                                ny_reason = <cfqueryparam cfsqltype="cf_sql_varchar" value="">,
                            </cfcase>
                            
                            <!--- Regional Manager --->
                        	<cfcase value="5">
                                rd_date_approved = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
                                rd_date_rejected = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
                                rd_reason = <cfqueryparam cfsqltype="cf_sql_varchar" value="">,
                                
                                ny_date_approved = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
                                ny_date_rejected = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
                                ny_reason = <cfqueryparam cfsqltype="cf_sql_varchar" value="">,
                            </cfcase>
                           
                            <!--- Regional Advisor --->
                        	<cfcase value="6">
                                ra_date_approved = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
                                ra_date_rejected = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
                                ra_reason = <cfqueryparam cfsqltype="cf_sql_varchar" value="">,
            
                                rd_date_approved = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
                                rd_date_rejected = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
                                rd_reason = <cfqueryparam cfsqltype="cf_sql_varchar" value="">,
                                
                                ny_date_approved = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
                                ny_date_rejected = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
                                ny_reason = <cfqueryparam cfsqltype="cf_sql_varchar" value="">,
                            </cfcase>

							<!--- Area Rep --->
                        	<cfcase value="7">
                                sr_date_submitted = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,                       
            
                                ra_date_approved = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
                                ra_date_rejected = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
                                ra_reason = <cfqueryparam cfsqltype="cf_sql_varchar" value="">,
            
                                rd_date_approved = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
                                rd_date_rejected = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
                                rd_reason = <cfqueryparam cfsqltype="cf_sql_varchar" value="">,
                                
                                ny_date_approved = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
                                ny_date_rejected = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">,
                                ny_reason = <cfqueryparam cfsqltype="cf_sql_varchar" value="">,
                            </cfcase>
                        
                        </cfswitch>
						
						<cfif ARGUMENTS.userType EQ 4>
                        
                        </cfif>
                        
                        date_updated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">                    	
                        
                    WHERE 
                        id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.projectHelpID)#">                    
                </cfquery>
            
            </cfif>
        
        <cfquery 
			datasource="#APPLICATION.dsn#">
                INSERT INTO
                	smg_project_help_activities
				(
                    project_help_id,
                    activity,
                    hours,
                    date_completed,
                    is_deleted,
                    date_created,
                    date_updated
				) 
				VALUES 
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.projectHelpID#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.activity#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#ARGUMENTS.hours#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.dateCompleted#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="0">,                    
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                );
		</cfquery>
            
	</cffunction>


	<cffunction name="deleteProjectHelpActivity" access="public" returntype="void" output="false" hint="Deletes a project help activity">
        <cfargument name="activityID" hint="activity is required">

        <cfquery 
			datasource="#APPLICATION.dsn#">
                UPDATE
                	smg_project_help_activities
				SET
                	is_deleted = <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
                    date_updated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				WHERE
                	id = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.activityID#">
		</cfquery>

	</cffunction>


	<cffunction name="getProjectHelpReport" access="public" returntype="query" output="false" hint="Gets a list of students, if studentID is passed gets a student by ID">
    	<cfargument name="userID" default="0" hint="User ID is required">
        <cfargument name="regionID" default="0" hint="List of Regions is not required">
        <cfargument name="userType" hint="UserType is required">
        <cfargument name="isActive" default="1" hint="Active status is not required">
        <cfargument name="programID" default="0" hint="List of Programs is not required">
        <cfargument name="statusKey" default="" hint="Project Help Status Key is not required">
        <cfargument name="minimumHours" default="" hint="Project Help Minimum number of hours">
		<cfargument name="maxHours" default="" hint="Project Help Maximum number of hours">
        <cfargument name="noHours" default="0" hint="To get students that haven't done any hours">
        <cfargument name="dumpArguments" default="0" hint="Dumps argument variables and aborts processing">
        
        <cfif VAL(ARGUMENTS.dumpArguments)>
            <cfdump var="#ARGUMENTS#">
            <cfabort>
        </cfif>
           
        <cfquery 
			name="qGetProjectHelpReport" 
			datasource="#APPLICATION.dsn#">
                SELECT 
                	s.studentID, 
                    s.firstname, 
                    s.familylastname,
                    <!--- Area Rep --->
                    s.areaRepID,
                    area.firstname as rep_firstName, 
                    area.lastname as rep_lastName,
                    <!--- Program --->
					p.programID,
                    p.programName,                    
                    <!--- Project Help Activities --->
					<cfif NOT VAL(ARGUMENTS.noHours)>					
	                    SUM(pha.hours) as hours,
                    </cfif>
                    <!--- Region --->
                    r.regionID,
                    r.regionName
                FROM 
                	smg_students s
                INNER JOIN 
                	smg_programs p ON s.programID = p.programID
                INNER JOIN 
                	smg_users area ON s.arearepID = area.userID
                INNER JOIN
                	smg_regions r ON r.regionID = s.regionAssigned
                INNER JOIN 
                	user_access_rights uar ON 
                    (
                    	s.arearepID = uar.userID
	                AND 
                    	s.regionassigned = uar.regionID
	                )
               <cfif NOT VAL(ARGUMENTS.noHours)>
                    INNER JOIN
                        smg_project_help ph ON ph.student_id = s.studentID                                    
                    INNER JOIN
                        smg_project_help_activities pha ON 
                        	pha.project_help_id = ph.id 
                        AND 
                            pha.is_deleted = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
				</cfif>
                
                WHERE
                    1 = 1 

                <!--- regional advisor sees only their reps or their students. --->
                <cfif ARGUMENTS.userType EQ 6>
                    AND 
                    (
                        uar.advisorID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">
                    OR 
                        s.arearepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">
                    )
                <!--- supervising reps sees only their students. --->
                <cfelseif ARGUMENTS.userType EQ 7>
                    AND 
                        s.arearepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">
                </cfif>

                <cfif VAL(ARGUMENTS.isActive)>
                    AND 
                        s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                </cfif>
                
                <cfif VAL(ARGUMENTS.regionID)>                    
                    AND
                        s.regionassigned IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.regionID#" list="yes"> )                    
                </cfif>

                <cfif LEN(ARGUMENTS.programID)>
                    AND
                        s.programID IN ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.programID#" list="yes"> )                    
                </cfif>

                <!--- Get Students with no hours --->
				<cfif VAL(ARGUMENTS.noHours)>
                    AND  
                        s.studentID NOT IN (SELECT student_id FROM smg_project_help)
                <cfelse>

					<cfif LEN(ARGUMENTS.statusKey)>
                        AND
                            ph.status_key = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.statusKey#">                    
                    </cfif>
                
                    GROUP BY 
                        ph.id
                    
                    <!--- Minimum Hours --->
                    HAVING 
                         SUM(pha.hours) BETWEEN  
                         	<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.minimumHours#">
                         AND 
                         	<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.maxHours#">				                                         
                </cfif>
    
				<!--- include the advisorID and arearepID because we're grouping by those in the output, just in case two have the same first and last name. --->
                ORDER BY 
                    r.regionName,
                    rep_lastname, 
                    rep_firstname, 
                    s.familylastname, 
                    s.firstname
        	</cfquery>
            
		<cfreturn qGetProjectHelpReport>
	</cffunction>


	<!--- ------------------------------------------------------------------------- ----
		
		END OF PROJECT HELP
	
	----- ------------------------------------------------------------------------- --->

</cfcomponent>