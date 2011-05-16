<!--- ------------------------------------------------------------------------- ----
	
	File:		student.cfc
	Author:		Marcus Melo
	Date:		May 13, 2011
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
    	<cfargument name="assignedID" default="0" hint="assignedID is not required">
        <cfargument name="programID" default="0" hint="programID is not required">
              
        <cfquery 
			name="qGetStudentByID" 
			datasource="#APPLICATION.dsn#">
                SELECT 
                	s.studentid, 
                    uniqueid, 
                    familylastname, 
                    firstname, 
                    middlename, 
                    fathersname, 
                    fatheraddress,
                    fatheraddress2, 
                    fathercity, 
                    fathercountry, 
                    fatherzip, 
                    fatherbirth, 
                    fathercompany, 
                    fatherworkphone,
                    fatherworkposition, 
                    fatherworktype, 
                    fatherenglish,
                    motherenglish, 
                    mothersname, 
                    motheraddress,
                    motheraddress2, 
                    mothercity, 
                    mothercountry,
                    motherzip,
                    motherbirth, 
                    mothercompany, 
                    motherworkphone,
                    motherworkposition, 
                    motherworktype, 
                    emergency_phone, 
                    emergency_name, 
                    emergency_address, 
                    emergency_country, 
                    address, 
                    address2, 
                    city, 
                    country, 
                    zip, 
                    phone, 
                    fax, 
                    email, 
                    citybirth,
                    countrybirth,
                    countryresident, 
                    countrycitizen, 
                    sex, 
                    dob, 
                    religiousaffiliation, 
                    dateapplication, 
                    entered_by,
                    passportnumber, 
                    intrep, 
                    current_state, 
                    approved, 
                    band, 
                    orchestra, 
                    comp_sports, 
                    cell_phone, 
                    additional_phone,
                    emergency_name, 
                    emergency_phone, 
                    convalidation_completed,
                    familyletter, 
                    pictures, 
                    interests, 
                    interests_other, 
                    religious_participation, 
                    churchfam, 
                    churchgroup,
                    smoke, 
                    animal_allergies, 
                    med_allergies, 
                    other_allergies, 
                    chores, 
                    chores_list, 
                    weekday_curfew, 
                    weekend_curfew, 
                    letter, height, 
                    weight, haircolor, 
                    eyecolor, graduated, 
                    direct_placement, 
                    direct_place_nature, 
                    termination_date, 
                    notes,
                    yearsenglish, 
                    estgpa, 
                    transcript, 
                    language_eval, 
                    social_skills, 
                    health immunization, 
                    health,
                    minorauthorization, 
                    placement_notes, 
                    needs_smoking_house, 
                    likes_pets, 
                    accepts_private_high,
                    app_completed_school, 
                    visano, 
                    grades, 
                    slep_Score, 
                    convalidation_needed, 
                    other_missing_docs, 
                    flight_info_notes,
                    scholarship, app_current_status, 
                    php_wishes_graduate, 
                    php_grade_student,  
                    php_passport_copy, 
                    <!--- FROM THE NEW TABLE PHP_STUDENTS_IN_PROGRAM --->		
                    php.assignedID, 
                    php.companyID, 
                    php.programID, 
                    php.hostID, 
                    php.schoolID, 
                    php.placerepID, 
                    php.arearepID,
                    php.dateplaced, 
                    php.school_acceptance, 
                    php.active, 
                    php.i20no, 
                    php.i20received, 
                    php.i20note,
                    php.i20sent, 
                    php.doubleplace, 
                    php.canceldate, 
                    php.cancelreason,
                    php.insurancedate, 
                    php.insurancecanceldate,
                    php.hf_placement, 
                    php.hf_application, 
                    php.sevis_fee_paid, 
                    php.transfer_type,
                    php.doc_evaluation9,
                    php.doc_evaluation12, 
                    php.doc_evaluation2, 
                    php.doc_evaluation4, 
                    php.doc_evaluation6, 
                    php.doc_grade1, 
                    php.doc_grade2,
                    php.doc_grade3, 
                    php.doc_grade4, 
                    php.doc_grade5, 
                    php.doc_grade6,
                    php.doc_grade7,
                    php.doc_grade8,
                    php.return_student, 
                    php.flightinfo_sent, 
                    php.flightinfo_received,
                    php.flightinfo_no, 
                    php.flightinfo_note
                FROM 
                	smg_students s
                INNER JOIN 
                	php_students_in_program php ON php.studentID = s.studentID
                WHERE 
                	1 = 1
                    
				<cfif VAL(ARGUMENTS.studentID)>
                    AND
                        s.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">
                </cfif>
                
                <cfif LEN(ARGUMENTS.uniqueID)>
                    AND
                        s.uniqueID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.uniqueID#">
                </cfif>

                <cfif LEN(ARGUMENTS.assignedID)>
                    AND
                        php.assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.assignedID#">
                </cfif>
                    
                <cfif LEN(ARGUMENTS.programID)>
                    AND
                        php.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.programID#">
                </cfif>

		</cfquery>
		   
		<cfreturn qGetStudentByID>
	</cffunction>


	<cffunction name="isStudentAssignedToPHP" access="public" returntype="numeric" output="false" hint="Returns 1 if student is assigned to PHP">
    	<cfargument name="studentID" default="0" hint="studentID is not required">

        <cfquery 
			name="qIsStudentAssignedToPHP" 
			datasource="#APPLICATION.dsn#">
                SELECT 
                    studentID
                FROM 
                    php_students_in_program
                WHERE 
                    studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">
				AND
                	active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
        </cfquery>
		
        <cfscript>
			if ( qIsStudentAssignedToPHP.recordCount ) {
				return 1;
			} else {
				return 0;
			}		
		</cfscript>
        
	</cffunction>


	<cffunction name="getStudentFullInformationByID" access="public" returntype="query" output="false" hint="Returns PHP student">
    	<cfargument name="studentID" default="0" hint="studentID is not required">
        <cfargument name="uniqueID" default="" hint="uniqueID is not required">
        <cfargument name="programID" default="" hint="programID is not required">
        <cfargument name="assignedID" default="" hint="assignedID is not required">

        <cfquery 
			name="qGetPHPStudent" 
			datasource="#APPLICATION.dsn#">
                SELECT 
                    s.studentID, 
                    s.uniqueID,                     
                    s.regionAssigned,
                    s.familylastname, 
                    s.firstname, 
                    s.middlename, 
                    s.email, 
                    s.sex, 
                    s.dob, 
                    s.flight_info_notes,
                    s.AYPOrientation,
                    s.AYPEnglish,
                    <!--- PHP --->
                    php.assignedID, 
                    php.companyID, 
                    php.programID, 
                    php.hostID, 
                    php.schoolID, 
                    php.placeRepID, 
                    php.areaRepID,
                    php.datePlaced,
                    <!--- Intl Representative --->
                    intlRep.userID AS intlRepUserID,
                    intlRep.firstName AS intlRepFirstName,
                    intlRep.lastName AS intlRepLastName,
                    intlRep.businessName AS intlRepBusinessName,
                    intlRep.email AS intlRepEmail,
                    intlRep.insurance_typeID,
                    <!--- Program --->
                    p.programName,
                    p.insurance_startdate,
                    <!--- Host Family --->
                    school.airport_city, 
                    school.major_air_code,
                    <!--- Area Representative --->
                    areaRep.userID AS areaRepUserID,
                    areaRep.firstName AS areaRepFirstName,
                    areaRep.lastName AS areaRepLastName,
					areaRep.email AS areaRepEmail,
                    areaRep.work_phone AS areaRepPhone
                FROM 
                    smg_students s
                INNER JOIN 
                    php_students_in_program php ON php.studentID = s.studentID
                INNER JOIN
                	smg_users intlRep ON intlRep.userID = s.intRep 
                LEFT OUTER JOIN 
                    php_schools school ON school.schoolID = php.schoolID
				LEFT OUTER JOIN
                	smg_programs p ON p.programID = php.programID                    
				LEFT OUTER JOIN
                	smg_users areaRep ON areaRep.userID = php.areaRepID
                WHERE 
                    php.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">

				<cfif VAL(ARGUMENTS.studentID)>
                    AND
                        s.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">
                </cfif>
                
                <cfif LEN(ARGUMENTS.uniqueID)>
                    AND
                        s.uniqueID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.uniqueID#">
                </cfif>

                <cfif LEN(ARGUMENTS.assignedID)>
                    AND
                        php.assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.assignedID#">
                </cfif>
                    
                <cfif VAL(ARGUMENTS.programID)>
                    AND
                        php.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.programID#">
                </cfif>
                                    
        </cfquery>

        <cfreturn qGetPHPStudent>            
	</cffunction>


	<!--- ------------------------------------------------------------------------- ----
		
		FLIGHT INFORMATION
	
	----- ------------------------------------------------------------------------- --->

	<cffunction name="getFlightInformation" access="public" returntype="query" output="false" hint="Gets flight information by studentID and type">
    	<cfargument name="studentID" hint="studentID is required">
        <cfargument name="flightType" hint="PreAypArrival/Arrival/Departure is required">
        <cfargument name="programID" default="0" hint="programID is not required">
        <cfargument name="flightLegOption" default="" hint="firstLeg/lastLeg to get first or last leg of the flight">
        
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
                    dateCreated,
                    dateUpdated,
                    isCompleted,
                    isDeleted
                FROM 
                    smg_flight_info
                WHERE 
                    studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#"> 
                AND 
                    flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.flightType#">
				AND
                	isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                    
				<cfif VAL(ARGUMENTS.programID)>
                    AND 
                        programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.programID#">
                </cfif> 
				
                <cfswitch expression="#ARGUMENTS.flightLegOption#">
                
                	<cfcase value="firstLeg">
                        ORDER BY 
                            dep_date
						LIMIT 1                            
                    </cfcase>

                	<cfcase value="lastLeg">
                        ORDER BY 
                            dep_date DESC
						LIMIT 1                            
                    </cfcase>

                	<cfdefaultcase>
                        ORDER BY 
                            flightID,
                            dep_date, 
                            dep_time
                    </cfdefaultcase>
                
                </cfswitch>
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
                    dateCreated,
                    dateUpdated,
                    isCompleted,
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

        <cfquery 
			datasource="#APPLICATION.dsn#">
                UPDATE 
                    smg_students
                SET 
                    flight_info_notes = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.flightNotes#">
                WHERE 
                    studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">
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
		
        <cfscript>
			var isCompleted = 1;
			
			// Check if Flight Info is Complete, these fields are required to get a complete flight information
			if ( NOT IsDate(ARGUMENTS.depDate) OR NOT LEN(ARGUMENTS.depCity) OR NOT LEN(ARGUMENTS.arrivalCity) OR NOT LEN(ARGUMENTS.flightNumber) OR NOT LEN(ARGUMENTS.arrivalTime)	) {
				isCompleted = 0;
			}
		</cfscript>
        
        <cfquery 
			datasource="#APPLICATION.dsn#">
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
                    isCompleted,
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
                    <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.depDate#" null="#NOT IsDate(ARGUMENTS.depDate)#">,
                    <cfqueryparam cfsqltype="cf_sql_time" value="#ARGUMENTS.depTime#" null="#NOT IsDate(ARGUMENTS.depTime)#">, 
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.arrivalCity#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.arrivalAirCode#">,
                    <cfqueryparam cfsqltype="cf_sql_time" value="#ARGUMENTS.arrivalTime#" null="#NOT IsDate(ARGUMENTS.arrivalTime)#">, 
                    <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(ARGUMENTS.overNight)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.flightType#">,
                    <cfqueryparam cfsqltype="cf_sql_bit" value="#isCompleted#">,
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

        <cfscript>
			var isCompleted = 1;
			
			// Check if Flight Info is Complete, these fields are required to get a complete flight information
			if ( NOT IsDate(ARGUMENTS.depDate) OR NOT LEN(ARGUMENTS.depCity) OR NOT LEN(ARGUMENTS.arrivalCity) OR NOT LEN(ARGUMENTS.flightNumber) OR NOT LEN(ARGUMENTS.arrivalTime)	) {
				isCompleted = 0;
			}
		</cfscript>

        <cfquery 
			datasource="#APPLICATION.dsn#">
                UPDATE
                    smg_flight_info
                SET 
                    companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">,
                    programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.programID#">,
                    enteredByID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.enteredByID#">,
                    flight_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.flightNumber#">,                 
                    dep_city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.depCity#">, 
                    dep_aircode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.depAirCode#">, 
                    dep_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.depDate#" null="#NOT IsDate(ARGUMENTS.depDate)#">,
                    dep_time = <cfqueryparam cfsqltype="cf_sql_time" value="#ARGUMENTS.depTime#" null="#NOT IsDate(ARGUMENTS.depTime)#">, 
                    arrival_city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.arrivalCity#">, 
                    arrival_aircode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.arrivalAirCode#">, 
                    arrival_time = <cfqueryparam cfsqltype="cf_sql_time" value="#ARGUMENTS.arrivalTime#" null="#NOT IsDate(ARGUMENTS.arrivalTime)#">, 
                    overnight = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(ARGUMENTS.overNight)#">,
                    isCompleted = <cfqueryparam cfsqltype="cf_sql_bit" value="#isCompleted#">
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
        <cfargument name="programID" hint="programID is required">
        <cfargument name="enteredByID" default="0" hint="ID of user entering the flight information">
        <cfargument name="sendEmail" default="1" hint="Set to 0 to not send email notification">
		
        <cfquery 
			datasource="#APPLICATION.dsn#">
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
					programID=ARGUMENTS.programID,
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
		
        <cfquery 
			datasource="#APPLICATION.dsn#">
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
        <cfargument name="programID" hint="programID is required">
        <cfargument name="flightID" default="0" hint="flightID is not required, pass flightID of a leg that has been deleted">
		<cfargument name="emailPDF" default="1" hint="Set to 0 to send the flight arrival in HTML format">
        <cfargument name="sendEmailTo" default="" hint="emailSchool | emailCurrentUser">
       
   		<!--- Import CustomTag --->
		<cfimport taglib="../customTags/gui/" prefix="gui" />	

		<cfscript>
            var flightEmailTo = '';
			var flightEmailCC = '';
            var flightEmailBody = '';
			var flightInfoReport = '';
        	
			qGetStudentFullInformation = getStudentFullInformationByID(studentID=ARGUMENTS.studentID, programID=ARGUMENTS.programID);
			
			// Path to save temp PDF files
			pdfPath = APPLICATION.PATH.temp & '##' & qGetStudentFullInformation.studentID & '-' & qGetStudentFullInformation.firstName & qGetStudentFullInformation.familyLastName & '-FlightInformation.pdf';
			// Remove Empty Spaces
			pdfPath = ReplaceNoCase(pdfPath, " ", "", "ALL");

			// Default Flight Information
			flightInfoLink = '#APPLICATION.PATH.PHP.phpusa#/student/index.cfm?action=flightInformation&uniqueID=#qGetStudentFullInformation.uniqueID#&programID=#qGetStudentFullInformation.programID#';
			
			// Get School Information
			qGetSchoolInfo = APPLICATION.CFC.SCHOOL.getSchools(schoolID=qGetStudentFullInformation.schoolID);
			
			// Get School Dates
			qGetSchoolDates = APPLICATION.CFC.SCHOOL.getSchoolDates(schoolID=qGetStudentFullInformation.schoolID, programID=qGetStudentFullInformation.programID);
			
            // Get Current User
            qGetCurrentUser = APPLICATION.CFC.USER.getUsers(userID=CLIENT.userID);
            			
            // Get Specific Flight Information
            qGetDeletedFlightInfo = getFlightInformationByFlightID(flightID=VAL(ARGUMENTS.flightID));
            
            // Get Arrival
            qGetArrival = APPLICATION.CFC.STUDENT.getFlightInformation(studentID=VAL(qGetStudentFullInformation.studentID), programID=VAL(qGetStudentFullInformation.programID), flightType="arrival");
    
            // Get Departure
            qGetDeparture = APPLICATION.CFC.STUDENT.getFlightInformation(studentID=VAL(qGetStudentFullInformation.studentID), programID=VAL(qGetStudentFullInformation.programID), flightType="departure");
			
			// PHP Student - Email Luke
			flightInfoLink = '#APPLICATION.PATH.PHP.phpusa#/index.cfm?curdoc=student/student_info&unqid=#qGetStudentFullInformation.uniqueID#';
            
			if ( ARGUMENTS.sendEmailTo EQ 'emailSchool' AND IsValid("email", qGetSchoolInfo.email) ) {
				
				// Email School | No copy to the current user
				flightEmailTo = qGetSchoolInfo.email;

            } else if ( ARGUMENTS.sendEmailTo EQ 'emailCurrentUser' AND IsValid("email", qGetCurrentUser.email) ) {
				
				// Email Current User
				flightEmailTo = qGetCurrentUser.email;

            } else if ( APPLICATION.IsServerLocal ) {
				
				// Local Server - Always email support
                flightEmailTo = APPLICATION.EMAIL.support;
			
			} else {
				
				// Not a valid email, use support
                flightEmailTo = APPLICATION.EMAIL.programManager;
            
			}
			
			// DELETE OR COMMENT THIS
			// flightEmailTo = 'marcus@iseusa.com';
        </cfscript>
        
        <!--- Send out Email if there is a flight information or if a leg has been deleted --->
        <cfif qGetDeletedFlightInfo.recordCount OR qGetArrival.recordCount OR qGetDeparture.recordCount>
        	
            <cfoutput>
            	              
                <!--- Email Body --->
                <cfsavecontent variable="flightEmailBody">
					
                    <!--- Student Information --->
                    <fieldset style="margin: 5px 0px 10px 0px; padding: 7px; border: ##DDD 1px solid; font-size:13px;">
                        
                        <legend style="color: ##333; font-weight: bold; padding-bottom:5px; text-transform:uppercase;">
                            Flight Information
                        </legend>

                        <p style="color: ##333;">
                        	Please find flight information attached for #qGetStudentFullInformation.firstName# #qGetStudentFullInformation.familyLastName# (###qGetStudentFullInformation.studentID#). 
                        </p>

                        <p style="color: ##333;">
	                        This information can also be found on EXITS by clicking <a href="#flightInfoLink#">here</a> then click on "Flight Information" on the right menu.
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
                        </p>

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
                        
                        <p style="color: ##333;">
                            <span style="font-weight:bold;">Area Representative:</span> 
                            #qGetStudentFullInformation.areaRepFirstName# #qGetStudentFullInformation.areaRepLastName# (###qGetStudentFullInformation.areaRepUserID#)
                            - Email: <a href="mailto:#qGetStudentFullInformation.areaRepEmail#">#qGetStudentFullInformation.areaRepEmail#</a> 
                            <cfif LEN(qGetStudentFullInformation.areaRepPhone)>
                                - Phone: #qGetStudentFullInformation.areaRepPhone#
                            </cfif>                                    
                        </p>
                        
                        <p style="color: ##333;">
                            <span style="font-weight:bold;">School:</span> 
                            #qGetSchoolInfo.schoolName# (###qGetSchoolInfo.schoolID#)
                        </p>

						<!--- Arrival Airport --->
                        <p style="color: ##333;">
                            <span style="font-weight:bold;">Arrival/Departure Airport:</span> 
                            <cfif LEN(qGetSchoolInfo.airport_city)>#qGetSchoolInfo.airport_city# <cfelse> n/a </cfif>
                            - Airport Code: <cfif LEN(qGetSchoolInfo.major_air_code)>#qGetSchoolInfo.major_air_code# <cfelse> n/a </cfif>
                        </p>
						
                        <!--- Notes --->
                        <p style="color: ##333;">
                            <span style="font-weight:bold;">Notes:</span> 
                            <cfif LEN(qGetStudentFullInformation.flight_info_notes)> #qGetStudentFullInformation.flight_info_notes# <cfelse> n/a </cfif>
                        </p>
						
                        <!--- Updated By --->
                        <cfif ARGUMENTS.sendEmailTo NEQ 'emailSchool'>
                            <p style="color: ##333;">
                                <span style="font-weight:bold;">Updated By:</span> 
                                #qGetCurrentUser.firstName# #qGetCurrentUser.lastName# (###qGetCurrentUser.userID#) 
                                <cfif LEN(qGetCurrentUser.businessname)> - #qGetCurrentUser.businessname# </cfif>
                            </p>
                        </cfif>
                        
                        <!--- Today's Date --->
                        <p style="color: ##333;">
                            <span style="font-weight:bold;">Today's Date:</span> 
                            #DateFormat(now(), 'mm/dd/yyyy')# at #TimeFormat(now(), 'hh:mm tt')# EST
                        </p>
                                            
                    </fieldset>


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
                
                <cfinvoke component="internal.cfc.email" method="send_mail">
                    <cfinvokeargument name="email_to" value="#flightEmailTo#">
                    <cfinvokeargument name="email_cc" value="#flightEmailCC#">
                    <cfinvokeargument name="email_subject" value="Flight Information for #qGetStudentFullInformation.firstname# #qGetStudentFullInformation.familylastname# (###qGetStudentFullInformation.studentID#)">
                    <cfinvokeargument name="email_message" value="#flightEmailBody#">
                    <cfinvokeargument name="email_from" value="#APPLICATION.EMAIL.programManager#">
                    <cfinvokeargument name="email_file" value="#pdfPath#">
                </cfinvoke>       
			
                <cfcatch type="any">
						
                    <!--- Send Out Email - NO PDF --->
                    <cfinvoke component="internal.cfc.email" method="send_mail">
                        <cfinvokeargument name="email_to" value="#flightEmailTo#">
                        <cfinvokeargument name="email_cc" value="#flightEmailCC#">
                        <cfinvokeargument name="email_subject" value="Flight Information for #qGetStudentFullInformation.firstname# #qGetStudentFullInformation.familylastname# (###qGetStudentFullInformation.studentID#)">
                        <cfinvokeargument name="email_message" value="#flightInfoReport#">
                        <cfinvokeargument name="email_from" value="#APPLICATION.EMAIL.programManager#">
                    </cfinvoke>       
                
                </cfcatch>
			
            </cftry>
            
        </cfif>
            
    </cffunction>
    

	<!--- ------------------------------------------------------------------------- ----
		
		END OF FLIGHT INFORMATION
	
	----- ------------------------------------------------------------------------- --->

</cfcomponent>