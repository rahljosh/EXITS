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
                	smg_programs p ON p.programID = s.programID AND p.startDate < ADDDATE(now(), INTERVAL 120 DAY) <!--- Get only programs that are starting 120 days from now --->
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
		
		FLIGHT INFORMATION
	
	----- ------------------------------------------------------------------------- --->

	<cffunction name="getFlightInformation" access="public" returntype="query" output="false" hint="Gets flight information by studentID and type">
    	<cfargument name="studentID" hint="studentID is required">
        <cfargument name="flightType" hint="Arrival/Departure is required">
              
        <cfquery 
			name="qGetFlightInformation" 
			datasource="#APPLICATION.dsn#">
                SELECT 
                    flightID, 
                    studentID, 
                    dep_date, 
                    dep_city, 
                    dep_aircode, 
                    dep_time, 
                    flight_number, 
                    arrival_city, 
                    arrival_aircode, 
                    arrival_time, 
                    overnight, 
                    flight_type
                FROM 
                    smg_flight_info
                WHERE 
                    studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#"> 
                AND 
                    flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.flightType#">
                ORDER BY 
                    flightID <!--- dep_date, dep_time --->
		</cfquery>
		   
		<cfreturn qGetFlightInformation>
	</cffunction>


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


	<cffunction name="insertFlightInfo" access="public" returntype="void" output="false" hint="Inserts Flight Information">
    	<cfargument name="studentID" hint="studentID is required">
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
         <cfargument name="assignedCompanyID" default=0 hint="Company Student is assigned to">

		<cfquery datasource="MySQL">
            INSERT INTO 
            	smg_flight_info
            (
            	studentid, 
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
                companyid
            )
            VALUES 
            (
            	<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">,
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

                <cfqueryparam cfsqltype="cf_sql_varchar" value="#VAL(ARGUMENTS.overNight)#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.flightType#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.assignedCompanyID#"> 
            )
        </cfquery>

	</cffunction>


	<cffunction name="updateFlightInfo" access="public" returntype="void" output="false" hint="Updates Flight Information">
    	<cfargument name="flightID" hint="flightID is required">
        <cfargument name="flightNumber" default="" hint="flightNumber is not required">
        <cfargument name="depCity" default="" hint="depCity is not required">
        <cfargument name="depAirCode" default="" hint="depAirCode is not required">
        <cfargument name="depDate" default="" hint="Departure is not required">
        <cfargument name="depTime" default="" hint="depTime is not required">
        <cfargument name="arrivalCity" default="" hint="arrivalCity is not required">
        <cfargument name="arrivalAirCode" default="" hint="arrivalAirCode is not required">
        <cfargument name="arrivalTime" default="" hint="arrivalTime is not required">
        <cfargument name="overNight" default="0" hint="overNight is not required">

		<cfquery datasource="MySQL">
            UPDATE
            	smg_flight_info
            SET 
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
            	
                overnight = <cfqueryparam cfsqltype="cf_sql_varchar" value="#VAL(ARGUMENTS.overNight)#">
                
            WHERE 
            	flightID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.flightID#">
            LIMIT 1
        </cfquery>

	</cffunction>


	<!--- ------------------------------------------------------------------------- ----
		
		END OF FLIGHT INFORMATION
	
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