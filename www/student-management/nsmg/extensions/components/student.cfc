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
    	<cfargument name="studentID" default="" hint="studentID is not required">
        <cfargument name="uniqueID" default="" hint="uniqueID is not required">
        <cfargument name="soID" default="" hint="INTO International Representative IDs">
        <cfargument name="companyID" default="" hint="CompanyID is not required">
        <cfargument name="onlyApprovedApps" default="0" hint="onlyApprovedApps is not required">
        
        <cfquery 
			name="qGetStudentByID" 
			datasource="#APPLICATION.DSN#">
                SELECT
					*, smg_student_app_status_type.statusdesc
                FROM 
                    smg_students
                LEFT JOIN smg_student_app_status_type on smg_student_app_status_type.typeid = smg_students.app_current_status
                WHERE
                	1 = 1
					
				<cfif LEN(ARGUMENTS.studentID)>
                    AND
                        studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">
                </cfif>
                
                <cfif LEN(ARGUMENTS.uniqueID)>
                    AND
                        uniqueID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.uniqueID#">
                </cfif>

                <cfif LEN(ARGUMENTS.soID)>
                    AND
                        soID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.soID#">
                </cfif>
                
				<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, ARGUMENTS.companyID)>
                    AND          
                        companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(APPLICATION.SETTINGS.COMPANYLIST.ISESMG)#" list="yes"> )
                <cfelseif VAL(ARGUMENTS.companyID)>
                    AND          
                        companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.companyID)#"> 
                </cfif>
				
                <!--- SHOW ONLY APPS APPROVED --->
                <cfif VAL(ARGUMENTS.onlyApprovedApps)>
					AND                    					
                    	app_current_status = <cfqueryparam cfsqltype="cf_sql_integer" value="11">              
                </cfif>
                
            LIMIT 1                
		</cfquery>
		   
		<cfreturn qGetStudentByID>
	</cffunction>


	<cffunction name="getStudentFullInformationByID" access="public" returntype="query" output="false" hint="Gets a student, intl. rep, program, region, Area Rep by studentID or uniqueID">
    	<cfargument name="studentID" default="" hint="studentID is not required">
        <cfargument name="uniqueID" default="" hint="uniqueID is not required">
              
        <cfquery 
			name="qGetStudentFullInformationByID" 
			datasource="#APPLICATION.DSN#">
                SELECT
					s.studentID,
                    s.uniqueID,
                    s.companyID,
                    s.hostID,
                    s.programID,
                    s.schoolID,
                    s.regionAssigned,
                    s.intRep,
                    s.areaRepID,
                    s.placeRepID,
                    s.doublePlace,
                    s.secondVisitRepID,
                    s.datePlaced,
                    s.firstName,
                    s.familyLastName,
                    s.dob,
                    s.active,
                    s.flight_info_notes,
                    s.AYPOrientation,
                    s.AYPEnglish,
                    s.unblockFlight,
                    s.datePISEmailed,
                    <!--- Intl Representative --->
                    intlRep.userID AS intlRepUserID,
                    intlRep.firstName AS intlRepFirstName,
                    intlRep.lastName AS intlRepLastName,
                    intlRep.businessName AS intlRepBusinessName,
                    intlRep.email AS intlRepEmail, 
                    intlRep.insurance_typeid,                 
                    <!--- Program --->
                    p.programName,
                    p.startDate,
                    p.endDate,
                    <!--- Host Family --->
                    host.airport_city, 
                    host.major_air_code,
                    host.familylastname as hostLastName, 
                    host.fatherfirstname,
                    host.motherfirstname,
                    <!--- Region --->
					r.regionName,
                    <!--- Area Representative --->
                    areaRep.userID AS areaRepUserID,
                    areaRep.firstName AS areaRepFirstName,
                    areaRep.lastName AS areaRepLastName,
					areaRep.email AS areaRepEmail,
                    areaRep.work_phone AS areaRepPhone,
                    <!--- Placing Representative --->
                    placeRep.userID AS placeRepUserID,
                    placeRep.firstname AS placeRepFirstName,
                    placeRep.lastname AS placeRepLastName,
                    placeRep.email AS placeRepEmail,
                    placeRep.work_phone AS placeRepPhone
                FROM 
                    smg_students s
                INNER JOIN
                	smg_users intlRep ON intlRep.userID = s.intRep  
				LEFT OUTER JOIN
                	smg_programs p ON p.programID = s.programID  
                LEFT OUTER JOIN 
                    smg_hosts host ON host.hostID = s.hostID
				LEFT OUTER JOIN
                	smg_regions r ON r.regionID = s.regionAssigned                                 
				LEFT OUTER JOIN
                	smg_users areaRep ON areaRep.userID = s.areaRepID
                LEFT OUTER JOIN
                	smg_users placeRep ON placeRep.userID = s.placeRepID
                WHERE
                	1 = 1

				<cfif LEN(ARGUMENTS.studentID)>
                    AND
                      
                        s.studentID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#" list="yes"> )
                </cfif>
                
                <cfif LEN(ARGUMENTS.uniqueID)>
                    AND
                        s.uniqueID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.uniqueID#">
                </cfif>
		</cfquery>
		   
		<cfreturn qGetStudentFullInformationByID>
	</cffunction>


	<cffunction name="isStudentAssignedToPHP" access="public" returntype="numeric" output="false" hint="Returns 1 if student is assigned to PHP">
    	<cfargument name="studentID" default="" hint="studentID is not required">
        <cfargument name="uniqueID" default="" hint="uniqueID is not required">

        <cfquery 
			name="qIsStudentAssignedToPHP" 
			datasource="#APPLICATION.DSN#">
                SELECT 
                    s.studentID
                FROM 
                    smg_students s
                INNER JOIN 
                    php_students_in_program php ON php.studentID = s.studentID
                WHERE 
                    php.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
				
				<cfif LEN(ARGUMENTS.studentID)>
                    AND
                        s.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">
                </cfif>
                
                <cfif LEN(ARGUMENTS.uniqueID)>
                    AND
                        s.uniqueID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.uniqueID#">
                </cfif>
        </cfquery>
		
        <cfscript>
			if ( qIsStudentAssignedToPHP.recordCount ) {
				return 1;
			} else {
				return 0;
			}		
		</cfscript>
        
	</cffunction>


	<cffunction name="getPHPStudent" access="public" returntype="query" output="false" hint="Returns PHP student">
    	<cfargument name="studentID" default="" hint="studentID is not required">
        <cfargument name="uniqueID" default="" hint="uniqueID is not required">
        <cfargument name="assignedID" default="" hint="assignedID is not required">
        <cfargument name="programID" default="0" hint="programID is not required">

        <cfquery 
			name="qGetPHPStudent" 
			datasource="#APPLICATION.DSN#">
                SELECT 
                    s.studentID, 
                    s.uniqueID, 
                    s.intRep,                    
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
                    s.unblockFlight,
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
                    intlRep.insurance_typeid,
                    <!--- Program --->
                    p.programName,
                    p.startDate,
                    p.endDate,
                    p.insurance_startdate,
                    <!--- Host Family --->
                    host.airport_city, 
                    host.major_air_code,
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
                    smg_hosts host ON host.hostID = php.hostID
				LEFT OUTER JOIN
                	smg_programs p ON p.programID = php.programID                    
				LEFT OUTER JOIN
                	smg_users areaRep ON areaRep.userID = php.areaRepID
                WHERE 
                    php.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">

                <cfif LEN(ARGUMENTS.studentID)>
                    AND                
                        s.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">
                </cfif>
                
                <cfif LEN(ARGUMENTS.uniqueID)>
                    AND                
                        s.uniqueID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.uniqueID#">
                </cfif>

                <cfif LEN(ARGUMENTS.assignedID)>
                    AND                
                        php.assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.assignedID)#">
                </cfif>

                <cfif VAL(ARGUMENTS.programID)>
                    AND                
                        php.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.programID#">
                </cfif>
				
                ORDER BY
                	assignedID DESC
        </cfquery>
        
        <cfreturn qGetPHPStudent>            
	</cffunction>


	<cffunction name="getUnplacedStudents" access="public" returntype="query" output="false" hint="Gets unplaced students">
        <cfargument name="regionID" default="0" hint="regionAssigned is not required">
              
        <cfquery 
			name="qGetUnplacedStudents" 
			datasource="#APPLICATION.DSN#">
                SELECT  
                    s.studentID, 
                    s.uniqueid, 
                    s.programID,
                    s.hostID,
                    s.firstName,
                    s.familyLastName, 
                    s.sex, 
                    s.active, 
                    s.dateassigned, 
                    s.regionguar,
                    s.state_guarantee, 
                    s.aypenglish, 
                    s.ayporientation, 
                    s.scholarship, 
                    s.privateschool,
                    s.host_fam_approved,
                    smg_regions.regionName, 
                    smg_g.regionName as r_guarantee, 
                    smg_states.state,             
                    p.programname,
                    c.countryname, 
                    co.companyShort, 
                    smg_hosts.familyLastName AS hostname
                FROM 
                    smg_students s
                INNER JOIN 
                    smg_companies co ON s.companyID = co.companyID
                LEFT OUTER JOIN 
                    smg_regions ON s.regionassigned = smg_regions.regionID
                LEFT OUTER JOIN 
                    smg_countrylist c ON s.countryresident = c.countryID
                LEFT OUTER JOIN 
                    smg_regions smg_g ON s.regionalguarantee = smg_g.regionID
                LEFT OUTER JOIN 
                    smg_states ON s.state_guarantee = smg_states.id
                LEFT OUTER JOIN 
                    smg_hosts ON s.hostID = smg_hosts.hostID
                LEFT OUTER JOIN 
                    smg_programs p ON s.programID = p.programID
                WHERE 
                    <!--- SHOW ONLY APPS APPROVED --->
                    s.app_current_status = <cfqueryparam cfsqltype="cf_sql_integer" value="11">
                AND 
                    s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                AND 
                    s.hostid = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                AND 
                    s.regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.regionID#">
                ORDER BY 
					s.familyLastName
		</cfquery>
		   
		<cfreturn qGetUnplacedStudents>
	</cffunction>


	<cffunction name="getAvailableDoublePlacement" access="public" returntype="query" output="false" hint="Gets placed available students for double placement">
        <cfargument name="regionID" default="0" hint="regionAssigned is not required">
        <cfargument name="studentID" default="0" hint="studentID is not required">
        <cfargument name="hostID" default="0" hint="hostID is not required">
              
        <cfquery 
			name="qGetAvailableDoublePlacement" 
			datasource="#APPLICATION.DSN#">
                SELECT 
                	s.studentID, 
                    s.familyLastName,
                    s.firstName
                FROM 
                	smg_students s
                INNER JOIN
                	smg_hosts h ON h.hostID = s.hostID
                WHERE 
                	s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">

				<cfif LEN(ARGUMENTS.hostID)>
                    AND
                        s.hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
                </cfif>
                    
				<cfif LEN(ARGUMENTS.regionID)>
                    AND
                        s.regionAssigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.regionID)#">
                </cfif>

                <cfif LEN(ARGUMENTS.studentID)>
                    AND
                        s.studentID != <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">
                </cfif>
                    
                ORDER BY 
                	s.firstname, 
                    s.familylastname
		</cfquery>
        
		<cfreturn qGetAvailableDoublePlacement>
	</cffunction>
    
    
    <cffunction name="getCurrentStudentsByHost" access="public" returntype="query" output="no" hint="Gets students that are currently placed with the given host">
    	<cfargument name="hostID" required="yes">
        <cfargument name="seasonID" default="0" required="no">
        
        <!--- Checks if the host has a previous app, only application --->
        <cfquery name="qGetPreviousHostApp" datasource="#APPLICATION.DSN#">
        	SELECT *
            FROM smg_host_app_season
            WHERE seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.seasonID - 1#">
            AND hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.hostID#">
        </cfquery>
        
        <cfquery name="qGetStudents" datasource="#APPLICATION.DSN#">
            SELECT s.*
            FROM smg_students s
            WHERE s.hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
            <cfif VAL(ARGUMENTS.seasonID)>
            	<cfif NOT VAL(qGetPreviousHostApp.recordCount)>
                	AND s.programID IN (SELECT programID FROM smg_programs WHERE seasonID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.seasonID#,#ARGUMENTS.seasonID - 1#" list="yes">) )
                    AND s.studentID IN (SELECT studentID FROM smg_hosthistory WHERE studentID = s.studentID AND dateCreated >= "2013-09-01")
                <cfelse>
            		AND s.programID IN (SELECT programID FROM smg_programs WHERE seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.seasonID#">)
              	</cfif>
            </cfif>
            AND s.active = 1
            ORDER BY s.familylastname
        </cfquery>
        
        <cfreturn qGetStudents>
    </cffunction>
    
    <!--- ------------------------------------------------------------------------- ----
		
		Languages
	
	----- ------------------------------------------------------------------------- --->

	<cffunction name="getStudentSpokenLanguages" access="public" returntype="query" output="false" hint="Returns a list of languages for a student">
    	<cfargument name="studentID" hint="studentID is required">
		<cfargument name="isPrimary" default="" hint="Set to 1 or 0 to get primary/secondary languages">
        
        <cfquery 
        	name="qGetStudentSpokenLanguages"
        	datasource="#APPLICATION.DSN#">
                SELECT
                    l.ID,
                    l.studentID,
                    l.languageID,
                    alk.name
                FROM
                    smg_student_app_language l
                LEFT OUTER JOIN
                    applicationlookup alk ON alk.fieldID = l.languageID
                    AND
                        alk.fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="language">
                WHERE
                    l.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">
                <cfif LEN(ARGUMENTS.isPrimary)>
                    AND
                        l.isPrimary = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.isPrimary)#">
                </cfif>
                ORDER BY
                    alk.name
        </cfquery> 

		<cfreturn qGetStudentSpokenLanguages>
	</cffunction>


    <cffunction name="addLanguage" access="remote" returntype="void" hint="Adds a language to the language table with the input student id, language id, and primary / secondary">
    	<cfargument name="studentID" type="numeric" required="yes" hint="The student ID for this secondary language">    
		<cfargument name="languageID" type="numeric" required="yes" hint="The field ID of the language to be added">
        <cfargument name="isPrimary" type="numeric" required="yes" hint="1 for primary, 0 for secondary">
        
        <cfquery 
        	name="qFindLanguage" 
            datasource="#APPLICATION.DSN#">
                SELECT
                    languageID
                FROM
                    smg_student_app_language
                WHERE
                    studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">
                AND
                    languageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.languageID#">
        </cfquery>
        
        <cfif NOT VAL(qFindLanguage.recordCount)>
        
            <cfquery 
            	datasource="#APPLICATION.DSN#">
                    INSERT INTO
                        smg_student_app_language 
                        (
                            studentID,
                            languageID,
                            isPrimary,
                            dateCreated 
                        )
                    VALUES
                        (
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.languageID#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.isPrimary#">,
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> 
                        )
            </cfquery>
            
      	</cfif>
    
    </cffunction>
    
    
    <cffunction name="removeLanguage" access="remote" returntype="void" hint="removes a language from the language table based on the id">
    	<cfargument name="ID" required="yes" hint="The table ID of the language to be removed">
        
        <cfquery 
        	datasource="#APPLICATION.DSN#">
                DELETE FROM
                    smg_student_app_language
                WHERE
                    ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.ID)#">
        </cfquery>
        
    </cffunction>
    
    
    <cffunction name="getSecondaryLanguagesAsStruct" access="remote" returntype="any" returnFormat="JSON" hint="gets all secondary languages of a student">
    	<cfargument name="studentID" required="yes">
        
        <cfquery 
        	name="qGetSecondaryLanguages" 
            datasource="#APPLICATION.DSN#">
                SELECT
                    l.ID,
                    alk.name
                FROM
                    smg_student_app_language l
                LEFT OUTER JOIN
                    applicationlookup alk ON alk.fieldID = l.languageID
                    AND
                        alk.fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="language">
                WHERE
                    studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">
                AND
                    isPrimary = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                ORDER BY
                    name ASC
        </cfquery>
        
        <cfscript>
			return SerializeJson(qGetSecondaryLanguages,true);
		</cfscript>
        
    </cffunction>
        
  	<!--- ------------------------------------------------------------------------- ----
		
		End of Languages
	
	----- ------------------------------------------------------------------------- --->

	<!--- ------------------------------------------------------------------------- ----
		
		Placement Management
	
	----- ------------------------------------------------------------------------- --->

	<cffunction name="updatePlacementInformation" access="public" returntype="void" output="false" hint="Update placement information / Approval process must be separate">
        <cfargument name="studentID" hint="studentID is required">
        <cfargument name="hostID" hint="hostID is required">
        <cfargument name="isWelcomeFamily" default="0" hint="isWelcomeFamily is not required">
        <cfargument name="isRelocation" default="0" hint="isRelocation is not required">
        <cfargument name="dateRelocated" default="" hint="dateRelocated is not required">
        <cfargument name="changePlacementReasonID" default="" hint="changePlacementReasonID is not required">
        <cfargument name="changePlacementExplanation" default="" hint="changePlacementExplanation is not required">
        <cfargument name="schoolID" hint="schoolID is required">   
        <cfargument name="schoolIDReason" default="" hint="schoolIDReason is not required">     
        <cfargument name="placeRepID" hint="placeRepID is required">
        <cfargument name="placeRepIDReason" default="" hint="placeRepIDReason is not required"> 
		<cfargument name="areaRepID" hint="areaRepID is required">
        <cfargument name="areaRepIDReason" default="" hint="areaRepIDReason is not required"> 
		<cfargument name="secondVisitRepID" hint="secondVisitRepID is required">
        <cfargument name="secondVisitRepIDReason" default="" hint="secondVisitRepIDReason is not required"> 
		<cfargument name="doublePlace" hint="doublePlace ID is required">
        <cfargument name="doublePlaceReason" default="" hint="secondVisitRepIDReason is not required"> 
        <cfargument name="changedBy" hint="changedBy is required">
        <cfargument name="userType" hint="userType is required">
        <cfargument name="reason" default="" hint="reason is not required">
        <cfargument name="placementStatus" default="" hint="Unplaced/Incomplete/Pending/Approved/Rejected">
            
        <cfscript>	
			// Get Current Placement Information
			var qGetCurrentPlacementInfo = getPlacementHistory(studentID=ARGUMENTS.studentID,isActive=1);
			var vHasHostIDChanged = 0;
			var vHasPlacementChanged = 0;
			var vAutomaticallyApprove = 0;
			
		
			// Check if Host Family has changed - If Yes reset double placement
			if ( ARGUMENTS.hostID NEQ qGetCurrentPlacementInfo.hostID ) {
				vHasHostIDChanged = 1;
			}

			// Check if info has been updated
			if (
					ARGUMENTS.hostID NEQ qGetCurrentPlacementInfo.hostID
				OR
					ARGUMENTS.schoolID NEQ qGetCurrentPlacementInfo.schoolID
				OR
					ARGUMENTS.placeRepID NEQ qGetCurrentPlacementInfo.placeRepID
				OR
					ARGUMENTS.areaRepID NEQ qGetCurrentPlacementInfo.areaRepID
				OR
					ARGUMENTS.secondVisitRepID NEQ qGetCurrentPlacementInfo.secondVisitRepID
				OR
					ARGUMENTS.doublePlace NEQ qGetCurrentPlacementInfo.doublePlacementID
				OR
					ARGUMENTS.isWelcomeFamily NEQ qGetCurrentPlacementInfo.isWelcomeFamily
				) {
					// Data has changed - Update student table
					vHasPlacementChanged = 1;
			}
			if (client.companyid neq 10){
				// Set to automatically approve if the change is to the placing, supervising, or second visit rep - 
				// and it is not a change to the hostID, schoolID, doublePlacementID, or isWelcomeFamily - 
				// and it is already approved
				if ( 
					(ARGUMENTS.placeRepID NEQ qGetCurrentPlacementInfo.placeRepID 
						OR ARGUMENTS.areaRepID NEQ qGetCurrentPlacementInfo.areaRepID 
						OR ARGUMENTS.secondVisitRepID NEQ qGetCurrentPlacementInfo.secondVisitRepID)
					AND NOT (ARGUMENTS.hostID NEQ qGetCurrentPlacementInfo.hostID
						OR ARGUMENTS.schoolID NEQ qGetCurrentPlacementInfo.schoolID
						OR ARGUMENTS.doublePlace NEQ qGetCurrentPlacementInfo.doublePlacementID
						OR ARGUMENTS.isWelcomeFamily NEQ qGetCurrentPlacementInfo.isWelcomeFamily)
					AND (ARGUMENTS.placementStatus EQ "Approved") ) {
						vAutomaticallyApprove = 1;
				}
			}
			// Insert-Update Placement History
			insertPlacementHistory(
				studentID = ARGUMENTS.studentID,					   
				hostID = ARGUMENTS.hostID,
				changePlacementReasonID = ARGUMENTS.changePlacementReasonID,
				changePlacementExplanation = ARGUMENTS.changePlacementExplanation,
				schoolID = ARGUMENTS.schoolID,
				schoolIDReason = ARGUMENTS.schoolIDReason,
				placeRepID = ARGUMENTS.placeRepID,
				placeRepIDReason = ARGUMENTS.placeRepIDReason,
				areaRepID = ARGUMENTS.areaRepID,
				areaRepIDReason = ARGUMENTS.areaRepIDReason,
				secondVisitRepID = ARGUMENTS.secondVisitRepID,
				secondVisitRepIDReason = ARGUMENTS.secondVisitRepIDReason,
				doublePlace = ARGUMENTS.doublePlace,
				doublePlaceReason = ARGUMENTS.doublePlaceReason,
				isWelcomeFamily = ARGUMENTS.isWelcomeFamily,
				isRelocation = ARGUMENTS.isRelocation,			
				dateRelocated = ARGUMENTS.dateRelocated,
				changedBy = ARGUMENTS.changedBy,
				userType = ARGUMENTS.userType,
				placementStatus = ARGUMENTS.placementStatus
			);
		</cfscript>
		
        <!--- Update Student Table --->
        <cfif VAL(vHasPlacementChanged)>
        
            <cfquery 
                datasource="#APPLICATION.DSN#">
                    UPDATE
                        smg_students
                    SET
                        hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">,
                        schoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.schoolID)#">,
                        placeRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.placeRepID)#">,
                        areaRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.areaRepID)#">,
                        secondVisitRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.secondVisitRepID)#">,
                        
						<!--- Reset Double Placement if host family has changed --->
                        <cfif VAL(vHasHostIDChanged)>
                            doublePlace = <cfqueryparam cfsqltype="cf_sql_integer" value="0">,
                        <cfelse>
                            doublePlace = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.doublePlace)#">,
                        </cfif>
                        
                        isWelcomeFamily = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(ARGUMENTS.isWelcomeFamily)#">,
                        
                        <!--- Automatically Approve Placement for the Field  --->
                        <cfif ListFind("5,6,7", ARGUMENTS.userType)>
							<cfif VAL(vAutomaticallyApprove)>
								host_fam_approved = <cfqueryparam cfsqltype="cf_sql_integer" value="4">,
							<cfelse>
                            	host_fam_approved = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userType#">,
							</cfif>
                        
                        <!--- Office | Reset status if changing hostID or SchoolID --->
                        <cfelseif 
                            ListFind("1,2,3,4", ARGUMENTS.userType) <!--- Office User --->
                        AND
                            (
                                qGetCurrentPlacementInfo.hostID NEQ ARGUMENTS.hostID <!--- HF Changed --->
                            OR	
                                qGetCurrentPlacementInfo.schoolID NEQ ARGUMENTS.schoolID <!--- School Changed --->
                            )
                        >
                            host_fam_approved = <cfqueryparam cfsqltype="cf_sql_integer" value="5">,
                        
                        </cfif>
                        
                        <!--- Used to track last approval --->
                        date_host_fam_approved = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    WHERE
                        studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">
            </cfquery>
        
        </cfif>
        
        <cfscript>
			/*******************************************************************************
				Double Placement - Automatically assign/remove/update for the second record
			*******************************************************************************/
			
			/*******************************************************************************
				Add New Double Placement
			********************************************************************************/
			if ( VAL(ARGUMENTS.doublePlace) AND NOT VAL(qGetCurrentPlacementInfo.doublePlacementID) ) {
				
                // Insert-Update Placement History
                insertPlacementHistory(
					studentID = ARGUMENTS.doublePlace,					   
					doublePlace = ARGUMENTS.studentID,
					doublePlaceReason = 'Double placement automatically assigned',
					changedBy = ARGUMENTS.changedBy,
					userType = ARGUMENTS.userType,
					placementAction='setDoublePlacement'
				);
				
				// Update Double Placement Record
				updateDoublePlacement(
					studentID = ARGUMENTS.doublePlace,					   
					doublePlace = ARGUMENTS.studentID,
					userType = ARGUMENTS.userType
				);

			/*******************************************************************************
				Double Placement Assigned to a Different Student 
				Remove previous and add new double placement
			********************************************************************************/
			} else if ( VAL(ARGUMENTS.doublePlace) AND ARGUMENTS.doublePlace NEQ qGetCurrentPlacementInfo.doublePlacementID ) {
				
				/*******************************************************************************
					Remove Double Placement
				********************************************************************************/

                // Insert-Update Placement History
                insertPlacementHistory(
					studentID = qGetCurrentPlacementInfo.doublePlacementID,					   
					doublePlace = 0,
					doublePlaceReason = 'Double placement assigned to a different student - automatically removed',
					changedBy = ARGUMENTS.changedBy,
					userType = ARGUMENTS.userType,
					placementAction='setDoublePlacement'
				);
				
				// Update Double Placement Record
				updateDoublePlacement(
					studentID = qGetCurrentPlacementInfo.doublePlacementID,					   
					doublePlace = 0,
					userType = ARGUMENTS.userType
				);
			
				/*******************************************************************************
					Add New Double Placement Automatically
				********************************************************************************/
				
                // Insert-Update Placement History
                insertPlacementHistory(
					studentID = ARGUMENTS.doublePlace,					   
					doublePlace = ARGUMENTS.studentID,
					doublePlaceReason = 'Double placement automatically assigned',
					changedBy = ARGUMENTS.changedBy,
					userType = ARGUMENTS.userType,
					placementAction='setDoublePlacement'
				);
				
				// Update Double Placement Record
				updateDoublePlacement(
					studentID = ARGUMENTS.doublePlace,					   
					doublePlace = ARGUMENTS.studentID,
					userType = ARGUMENTS.userType
				);

			/*******************************************************************************
				Remove Double Placement Automatically - Student assigned to a different family
			********************************************************************************/
			} else if ( VAL(qGetCurrentPlacementInfo.doublePlacementID) AND VAL(vHasHostIDChanged) ) {
				
                // Insert-Update Placement History
                insertPlacementHistory(
					studentID = qGetCurrentPlacementInfo.doublePlacementID,					   
					doublePlace = 0,
					doublePlaceReason = 'Double placement student assigned to a different family - automatically removed',
					changedBy = ARGUMENTS.changedBy,
					userType = ARGUMENTS.userType,
					placementAction='setDoublePlacement'
				);
				
				// Update Double Placement Record on the second record
				updateDoublePlacement(
					studentID = qGetCurrentPlacementInfo.doublePlacementID,					   
					doublePlace = 0,
					userType = ARGUMENTS.userType
				);
			
			/*******************************************************************************
				Remove Double Placement Automatically
			********************************************************************************/
			} else if ( VAL(qGetCurrentPlacementInfo.doublePlacementID) AND NOT VAL(ARGUMENTS.doublePlace) ) {
				
                // Insert-Update Placement History
                insertPlacementHistory(
					studentID = qGetCurrentPlacementInfo.doublePlacementID,					   
					doublePlace = 0,
					doublePlaceReason = 'Double placement automatically removed',
					changedBy = ARGUMENTS.changedBy,
					userType = ARGUMENTS.userType,
					placementAction='setDoublePlacement'
				);
				
				// Update Double Placement Record on the second record
				updateDoublePlacement(
					studentID = qGetCurrentPlacementInfo.doublePlacementID,					   
					doublePlace = 0,
					userType = ARGUMENTS.userType
				);
			
			}
			
			// Check if there is an approved HF App and copy the paperwork
			if ( VAL(vHasHostIDChanged) ) {
				// SET PAPERWORK AUTOMATICALLY
				APPLICATION.CFC.HOST.setPlacementManagementPaperwork(hostID=ARGUMENTS.hostID);
			}
		</cfscript>
	
	</cffunction>


	<cffunction name="updateDoublePlacement" access="public" returntype="void" output="false" hint="Updates a Double Placement Record">
        <cfargument name="studentID" hint="studentID is required">
		<cfargument name="doublePlace" hint="doublePlace ID is required">
        <cfargument name="userType" hint="userType is required">

			<cfscript>
                // Get Student Info
                var qGetStudentInfo = getStudentByID(studentID=ARGUMENTS.studentID);	
				
				var vHostHistoryID = getPlacementHistory(studentID=ARGUMENTS.studentID,isActive=1).historyID;
            </cfscript>
            
            <cfquery 
                datasource="#APPLICATION.DSN#">
                    UPDATE
                        smg_students
                    SET
                        doublePlace = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.doublePlace)#">,
                        
						<!--- Area Representative | Reset status to 7 --->
                        <cfif ARGUMENTS.userType EQ 7>
                            host_fam_approved = <cfqueryparam cfsqltype="cf_sql_integer" value="7">,
                        
                        <!--- Regional Advisor | If current status > usertype, set status back for approval --->
                        <cfelseif ARGUMENTS.userType EQ 6 AND listFind("1,2,3,4,5", qGetStudentInfo.host_fam_approved)>
                            host_fam_approved = <cfqueryparam cfsqltype="cf_sql_integer" value="6">,
                        
                        <!--- Regional Manager | If current status > usertype, set status back for approval --->
                        <cfelseif ARGUMENTS.userType EQ 5 AND listFind("1,2,3,4", qGetStudentInfo.host_fam_approved)>
                            host_fam_approved = <cfqueryparam cfsqltype="cf_sql_integer" value="5">,
                        
                        <!--- Office Update | Status stays the same --->
                        </cfif>
                        
						<!--- Used to track last approval --->
                        date_host_fam_approved = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    WHERE
                        studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.studentID)#">
            </cfquery>
			
            <!--- Update History --->
            <cfquery 
                datasource="#APPLICATION.DSN#">
                    UPDATE
                        smg_hosthistory
                    SET
                        <cfif qGetStudentInfo.doublePlace NEQ ARGUMENTS.doublePlace>
	                        hasDoublePlacementIDChanged = <cfqueryparam cfsqltype="cf_sql_bit" value="1">,
                        </cfif>                        
                        doublePlacementID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.doublePlace)#">,
                        updatedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
                    WHERE
                        historyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(vHostHistoryID)#">
            </cfquery>
            
	</cffunction>


	<cffunction name="updatePlacementNotes" access="public" returntype="void" output="false" hint="Updates placement notes">
        <cfargument name="studentID" hint="studentID is required">
		<cfargument name="placement_notes" default="" hint="placement_notes is not required">

            <cfquery 
                datasource="#APPLICATION.DSN#">
                    UPDATE
                        smg_students
                    SET
                        placement_notes = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.placement_notes#">
                    WHERE
                        studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">
            </cfquery>

	</cffunction>


	<!--- Unplace Student --->
	<cffunction name="unplaceStudent" access="public" returntype="void" output="false" hint="Unplaces a student">
        <cfargument name="studentID" hint="studentID is required">
        <cfargument name="changedBy" hint="changedBy is required">
        <cfargument name="userType" hint="userType is required">
        <cfargument name="reason" default="" hint="reason is not required">
		
        <cfscript>
			// Get Student Info
			var qGetStudentInfo = getStudentByID(studentID=ARGUMENTS.studentID);
			
            // Get Facilitator Email
            var qGetFacilitator = APPLICATION.CFC.REGION.getRegionFacilitatorByRegionID(regionID=qGetStudentInfo.regionAssigned);
			
            // Get Current User
            var qGetChangedByUser = APPLICATION.CFC.USER.getUserByID(userID=ARGUMENTS.changedBy);
		</cfscript>
        
        <cfquery 
			datasource="#APPLICATION.DSN#">
                UPDATE 
                	smg_students
                SET 
					hostID = <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
                    schoolID = <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
                    placeRepID = <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
                    areaRepID =  <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
					secondVisitRepID = <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
                    isWelcomeFamily = <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
                    doubleplace = <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
                    host_fam_approved = <cfqueryparam cfsqltype="cf_sql_integer" value="10">,
                    date_host_fam_approved = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    datePlaced = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    datePISEmailed = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    <!--- Placement Notes --->
                    placement_notes = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
                WHERE 
                	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">
    	</cfquery>
   
		<cfscript>
			// Set Date Placed Ended
			setDatePlacedEnded(studentID=ARGUMENTS.studentID,datePlacedEnded=DateFormat(now(), 'mm/dd/yyyy'));

			// Set Old Records to Inactive
			setHostHistoryInactive(studentID=ARGUMENTS.studentID);		
		
			// Insert History - It tracks placement statuses only, placement updates are tracked on smg_hosthistory
			insertPlacementActionHistory(
				studentID=ARGUMENTS.studentID,
				changedBy=ARGUMENTS.changedBy,
				userType=ARGUMENTS.userType,
				reason=ARGUMENTS.reason,
				placementAction='unplaceStudent'
			);

        	// Check if there was a double placement, if so remove it automatically 
			if ( VAL(qGetStudentInfo.doublePlace) ) {
				
                // Insert-Update Placement History
                insertPlacementHistory(
					studentID = qGetStudentInfo.doublePlace,					   
					doublePlace = 0,
					doublePlaceReason = 'Double placement student set to unplaced - automatically removed',
					changedBy = ARGUMENTS.changedBy,
					userType = ARGUMENTS.userType,
					placementAction='setDoublePlacement'
				);
				
				// Update Double Placement Record on the second record
				updateDoublePlacement(
					studentID = qGetStudentInfo.doublePlace,					   
					doublePlace = 0,
					userType = ARGUMENTS.userType
				);

			}
        </cfscript>

		<!--- Email Facilitator --->        
        <cfif IsValid("email", qGetFacilitator.email)>
        
            <!--- Email Template --->
            <cfsavecontent variable="vEmailUnplaceNotification">
                <cfoutput>
                    <p>Dear #qGetFacilitator.firstName# #qGetFacilitator.lastName#,</p>
                    
                    <p>
                        This e-mail is to inform you that #qGetStudentInfo.firstName# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentID#) 
                        - Region #qGetFacilitator.regionName# has been <strong>unplaced</strong> as of <strong>#DateFormat(now(), 'mm/dd/yyyy')#</strong> 
                        by #qGetChangedByUser.firstName# #qGetChangedByUser.lastName# (###qGetChangedByUser.userID#).
                    </p>
                    
                    <p>
                        Reason for unplacing the student: #ARGUMENTS.reason#
                    </p>
                </cfoutput>                
            </cfsavecontent>
        
			<!--- Email Placing Representative and Regional Manager --->
            <cfinvoke component="nsmg.cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="#qGetFacilitator.email#">
                <cfinvokeargument name="email_subject" value="Unplaced Notification for Student #qGetStudentInfo.firstName# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentID#)">
                <cfinvokeargument name="email_message" value="#vEmailUnplaceNotification#">
                <cfinvokeargument name="email_from" value="#CLIENT.support_email#">
            </cfinvoke>
        
        </cfif>
        
    </cffunction>

	
    <!--- Approve Placement --->
	<cffunction name="approvePlacement" access="public" returntype="void" output="false" hint="Approves a placement">
        <cfargument name="studentID" hint="studentID is required">
        <cfargument name="changedBy" hint="changedBy is required">
        <cfargument name="userType" hint="userType is required">
        <cfargument name="reason" default="" hint="reason is not required">
        <cfargument name="dateRelocated" default="" hint="dateRelocated is not required">

        <cfscript>
			// Get Student Info
			var qGetStudentInfo = getStudentFullInformationByID(studentID=ARGUMENTS.studentID);
			
			// Get Regional Manager Information
			var qGetRegionalManager = APPLICATION.CFC.USER.getRegionalManager(regionID=qGetStudentInfo.regionAssigned);
			
			// Get Placing Representative Email Address
			qGetPlacingRepresentative = APPLICATION.CFC.USER.getUserByID(userID=qGetStudentInfo.placeRepID);
			
			var vUpdateDatePlaced = 0;
			
			// Set Placement Date if Approved by Headquarters - Only first time approval
			if ( ListFind("1,2,3,4", ARGUMENTS.userType) AND NOT IsDate(qGetStudentInfo.datePlaced) ) {
				vUpdateDatePlaced = 1;
			}
		</cfscript>
        
        <cfquery 
			datasource="#APPLICATION.DSN#">
                UPDATE
                	smg_students
				SET
                    <cfif VAL(vUpdateDatePlaced)>
                    	dateplaced = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    </cfif>
                    host_fam_approved = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userType)#">,
                    date_host_fam_approved = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				WHERE
                	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">
		</cfquery>

		<cfscript>
            // Get History ID
            vHostHistoryID = getPlacementHistory(studentID=ARGUMENTS.studentID,isActive=1).historyID;
        </cfscript>
        
        <cfquery 
            datasource="#APPLICATION.DSN#">
                UPDATE
                    smg_hosthistory
                SET
                    <!--- Set Placement Date on the history if Approved by Headquarters - Only first time approval--->
                    <cfif VAL(vUpdateDatePlaced)>
                        dateplaced = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    </cfif>
                    dateRelocated = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.dateRelocated#" null="#NOT IsDate(ARGUMENTS.dateRelocated)#">,
                    updatedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
                WHERE
                    historyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(vHostHistoryID)#">
        </cfquery>

		<cfscript>
            /*** Holding it for now as per Brian Hause request - 06/02/2011 ****/
            // Assign Pre-AYP English Camp based on host family state	
            // APPLICATION.CFC.STUDENT.assignEnglishCamp(studentID=CLIENT.studentID);
			
			// Insert New History - It tracks placement statuses only, placement updates are tracked on smg_hosthistory
			insertPlacementActionHistory(
				studentID=ARGUMENTS.studentID,
				changedBy=ARGUMENTS.changedBy,
				userType=ARGUMENTS.userType,
				placementAction='Approve'
			);
        </cfscript>
        
        <!--- Email host family that the placement is approved (only if there is no date for the PIS) --->
        <cfif NOT isDate(qGetStudentInfo.datePISEmailed) AND ListFind("1,2,3,4", ARGUMENTS.userType)>
			<cfscript>
                qGetHostFamily = APPLICATION.CFC.HOST.getHosts(hostID = qGetStudentInfo.hostID);
                qGetManager = APPLICATION.CFC.Region.getRegionManagerByRegionID(regionID = qGetStudentInfo.regionAssigned);
                qGetCompany = APPLICATION.CFC.Company.getCompanies(companyID = qGetHostFamily.companyID);
            </cfscript>
            
            <cfsavecontent variable="vEmailContent">
                <cfoutput>
                    <p>Dear #qGetHostFamily.familyLastName# family:</p>
                    <p>
                        Congratulations!  The placement of #qGetStudentInfo.firstName# #qGetStudentInfo.familyLastName# with your family has been fully approved.  
                        Your exchange student will be contacting you soon, and if you want to reach out to him/her it is now permissible to do so. 
                        For any questions, please contact your local area rep #qGetStudentInfo.areaRepFirstName# #qGetStudentInfo.areaRepLastName#. 
                        #qGetCompany.companyshort_nocolor# thanks you for sharing in our mission of making the world a little smaller, one student at a time.
                    </p>
                    <p>
                        Sincerely,<br/>
                        #qGetCompany.companyname#
                    </p>
                </cfoutput>
            </cfsavecontent>
            
            <cfinvoke component="nsmg.cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="#qGetHostFamily.email#">
                <cfinvokeargument name="email_cc" value="#qGetRegionalManager.email#, #qGetPlacingRepresentative.email#">
                <cfinvokeargument name="email_subject" value="#qGetCompany.companyshort_nocolor# Placement Approved">
                <cfinvokeargument name="email_message" value="#vEmailContent#">
                <cfinvokeargument name="email_from" value="#CLIENT.support_email#">
            </cfinvoke>
      	</cfif>
        
	</cffunction>

	
    <!--- Resubmit Placement --->
	<cffunction name="resubmitPlacement" access="public" returntype="void" output="false" hint="Resubmits a denied placement">
        <cfargument name="studentID" hint="studentID is required">
        <cfargument name="changedBy" hint="changedBy is required">
        <cfargument name="userType" hint="userType is required">
        <cfargument name="reason" default="" hint="reason is not required">
        
        <cfquery 
			datasource="#APPLICATION.DSN#">
                UPDATE
                	smg_students
				SET
                    host_fam_approved = <cfqueryparam cfsqltype="cf_sql_integer" value="7">,
                    date_host_fam_approved = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				WHERE
                	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">
		</cfquery>
        
		<cfscript>
			// Insert New History - It tracks placement statuses only, placement updates are tracked on smg_hosthistory
			insertPlacementActionHistory(
				studentID=ARGUMENTS.studentID,
				changedBy=ARGUMENTS.changedBy,
				userType=ARGUMENTS.userType,
				reason=ARGUMENTS.reason,
				placementAction='Resubmit'
			);
        </cfscript>
        
	</cffunction>

	
    <!--- Reject Placement --->
	<cffunction name="rejectPlacement" access="public" returntype="void" output="false" hint="Rejects a placement">
        <cfargument name="studentID" hint="studentID is required">
        <cfargument name="changedBy" hint="changedBy is required">
        <cfargument name="userType" hint="userType is required">
        <cfargument name="regionID" hint="regionID is required">
        <cfargument name="placeRepID" hint="placeRepID is required">
        <cfargument name="reason" hint="reason is required">
        	
        <cfscript>
			// Get Current Placement Information
			qGetStudentInfo = getStudentByID(studentID=ARGUMENTS.studentID);
		
			// Get Regional Manager Information
			qGetRegionalManager = APPLICATION.CFC.USER.getRegionalManager(regionID=ARGUMENTS.regionID);
			
			// Get Placing Representative Email Address
			qGetPlacingRepresentative = APPLICATION.CFC.USER.getUserByID(userID=ARGUMENTS.placeRepID);
		</cfscript>

        <cfquery 
			datasource="#APPLICATION.DSN#">
                UPDATE
                	smg_students
				SET
                    host_fam_approved = <cfqueryparam cfsqltype="cf_sql_integer" value="99">,
                    date_host_fam_approved = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				WHERE
                	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">
		</cfquery>
        
		<cfscript>
			// Insert New History - It tracks placement statuses only, placement updates are tracked on smg_hosthistory
			insertPlacementActionHistory(
				studentID=ARGUMENTS.studentID,
				changedBy=ARGUMENTS.changedBy,
				userType=ARGUMENTS.userType,
				reason=ARGUMENTS.reason,
				placementAction='Reject'
			);
        </cfscript>
        
        <!--- Email Template --->
        <cfsavecontent variable="vEmailRejectMessage">
        	<cfoutput>
                <p>Dear #qGetPlacingRepresentative.firstName# #qGetPlacingRepresentative.lastName#,</p>
                
                <p>The placement for <strong>#qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentID#)</strong> has been rejected. </p> 
                
                <p>Below are the items that need to be addressed before #qGetStudentInfo.firstname# can be placed:</p>
                
                <p><strong>#ARGUMENTS.reason#</strong></p>
                
                <p>A copy of this message has also be sent to regional director:  #qGetRegionalManager.firstname# #qGetRegionalManager.lastname#</p>
			</cfoutput>                
        </cfsavecontent>
        
        <!--- Email Placing Representative and Regional Manager --->
        <cfinvoke component="nsmg.cfc.email" method="send_mail">
            <cfinvokeargument name="email_to" value="#qGetPlacingRepresentative.email#">
            <cfinvokeargument name="email_cc" value="#qGetRegionalManager.email#">
            <cfinvokeargument name="email_subject" value="Placement Rejected - Student #qGetStudentInfo.firstName# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentID#)">
            <cfinvokeargument name="email_message" value="#vEmailRejectMessage#">
            <cfinvokeargument name="email_from" value="#CLIENT.support_email#">
        </cfinvoke>
        
	</cffunction>
    

    <!--- Set Host Family as Permanent --->
	<cffunction name="setFamilyAsPermanent" access="public" returntype="void" output="false" hint="Sets a host family as permanent">
        <cfargument name="studentID" hint="studentID is required">
        <cfargument name="changedBy" hint="changedBy is required">
        <cfargument name="userType" hint="userType is required">
        <cfargument name="reason" default="" hint="reason is not required">
        <cfargument name="dateSetHostPermanent" default="" hint="dateSetHostPermanent is not required">
        
        <cfscript>
			// Get Student Info
			var qGetStudentInfo = getStudentByID(studentID=ARGUMENTS.studentID);
			
			vHostHistoryID = getPlacementHistory(studentID=ARGUMENTS.studentID,isActive=1).historyID;			
		</cfscript>
        
        <cfquery 
			datasource="#APPLICATION.DSN#">
                UPDATE
                	smg_students
				SET
                    isWelcomeFamily = <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
                    
                    <!--- Area Representative | Reset status to 7 --->
                    <cfif ARGUMENTS.userType EQ 7>
                        host_fam_approved = <cfqueryparam cfsqltype="cf_sql_integer" value="7">,
                    
                    <!--- Regional Advisor | If current status > usertype, set status back for approval --->
                    <cfelseif ARGUMENTS.userType EQ 6 AND listFind("1,2,3,4,5", qGetStudentInfo.host_fam_approved)>
                        host_fam_approved = <cfqueryparam cfsqltype="cf_sql_integer" value="6">,
                    
                    <!--- Regional Manager | If current status > usertype, set status back for approval --->
                    <cfelseif ARGUMENTS.userType EQ 5 AND listFind("1,2,3,4", qGetStudentInfo.host_fam_approved)>
                        host_fam_approved = <cfqueryparam cfsqltype="cf_sql_integer" value="5">,
                    
                    <!--- Office Update | Status stays the same --->
                    </cfif>

                    date_host_fam_approved = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				WHERE
                	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">
		</cfquery>
        
        <!--- Update Host History - Insert Permanent Date --->
        <cfquery 
            datasource="#APPLICATION.DSN#">
                UPDATE
                    smg_hosthistory	
                SET
                	isWelcomeFamily = <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
                    dateSetHostPermanent = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.dateSetHostPermanent#">,
                    updatedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
                WHERE
                    historyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(vHostHistoryID)#">
        </cfquery>
        
		<cfscript>
			// Insert New History - It tracks placement statuses only, placement updates are tracked on smg_hosthistory
			insertPlacementActionHistory(
				studentID=ARGUMENTS.studentID,
				changedBy=ARGUMENTS.changedBy,
				userType=ARGUMENTS.userType,
				reason=ARGUMENTS.reason,
				placementAction='setFamilyAsPermanent',
				dateSetHostPermanent=ARGUMENTS.dateSetHostPermanent
			);
        </cfscript>
        
	</cffunction>

	
    <!--- Insert Placement Action History --->
	<cffunction name="insertPlacementActionHistory" access="public" returntype="void" output="false" hint="Actions: Approve/Reject/Resubmit/unplaceStudent/setPermanent, it does not require any update to the history record">
        <cfargument name="studentID" hint="studentID is required">
        <cfargument name="changedBy" hint="changedBy is required">
        <cfargument name="userType" hint="userType is required">
        <cfargument name="reason" default="" hint="Field is used for rejection/resubmit comments">
        <cfargument name="placementAction" default="" hint="Approve/Reject/Resubmit/unplaceStudent/setFamilyAsPermanent/Received">
        <cfargument name="dateSetHostPermanent" default="" hint="dateSetHostPermanent is not required">
		<cfargument name="dateReceived" default="" hint="dateReceived is not required">
    	<cfscript>
			// History ID
			var vHostHistoryID = 0;
			
			// Set Action Message
			var vUpdatedBy = 'n/a';
			var vActions = '';			
			
			// Get User Information
			qGetEnteredBy = APPLICATION.CFC.USER.getUsers(userID=ARGUMENTS.changedBy);

			// Set Track Placement Status Action Message
			switch(ARGUMENTS.userType) { 
				
				case 1: case 2: case 3: case 4:
					vUpdatedBy = 'Office';
					break; 
					
				case 5: 
					vUpdatedBy = 'Regional Manager';
					break; 

				case 6: 
					vUpdatedBy = 'Regional Advisor';
					break; 

				case 7: 
					vUpdatedBy = 'Supervising Representative';
					break; 
					
			} 
			//end switch
		
			// SET ACTION MESSAGE - THESE ARE BASED ON THE PLACEMENT ACTION
			
			// Set Track Placement Status Action Message
			switch(ARGUMENTS.placementAction) { 
				// RECEIVED
				case 'Received':
					vActions = "<strong>Host Application Received by #vUpdatedBy# on #ARGUMENTS.dateReceived#</strong> <br /> #CHR(13)#";
					break; 
					
				// PLACEMENT APPROVED
				case 'Approve':
					vActions = "<strong>Placement Approved by #vUpdatedBy#</strong> <br /> #CHR(13)#";
					break; 

				// PLACEMENT REJECTED
				case 'Reject':
					vActions = "<strong>Placement Rejected by #vUpdatedBy#</strong> <br /> #CHR(13)#";
					break; 

				// PLACEMENT RESUBMITTED
				case 'Resubmit':
					vActions = "<strong>Placement Resubmitted by #vUpdatedBy#</strong> <br /> #CHR(13)#";
					break; 
					
				// UNPLACE STUDENT
				case 'unplaceStudent':
					vActions = "<strong>Student Set to Unplaced</strong> <br /> #CHR(13)#";			
					break; 
				
				// SET FAMILY AS PERMANENT
				case 'setFamilyAsPermanent':
					if ( isDate(ARGUMENTS.dateSetHostPermanent ) ) {
						vActions = "<strong>Host Family Set as Permanent as of #DateFormat(ARGUMENTS.dateSetHostPermanent,'mm/dd/yyyy')# </strong> <br /> #CHR(13)#";
					} else {
						vActions = "<strong>Host Family Set as Permanent</strong> <br /> #CHR(13)#";
					}						
					break; 

			} //end switch
			
			// Reason
			if ( LEN(ARGUMENTS.reason) ) {
				vActions = vActions & "Comment: #ARGUMENTS.reason# <br /> #CHR(13)#";
			}
			
			// Add User Information
			vActions = vActions & "Updated by: #qGetEnteredBy.firstName# #qGetEnteredBy.lastName# (###qGetEnteredBy.userID#) - #vUpdatedBy# <br /> #CHR(13)#";
			
			// Add paragraph tag to set this update
			vActions = "<p>#vActions#</p>";
			
			// Get Current History
			vHostHistoryID = getPlacementHistory(studentID=ARGUMENTS.studentID,isActive=1).historyID;
				
			if ( VAL(vHostHistoryID) ) {
				
				// Insert Actions Into Separate Table
				APPLICATION.CFC.LOOKUPTABLES.insertApplicationHistory(
					applicationID=APPLICATION.CONSTANTS.TYPE.EXITS,
					foreignTable='smg_hosthistory',
					foreignID=vHostHistoryID,
					enteredByID=VAL(ARGUMENTS.changedBy),
					actions=vActions
				);			
		
			}
		</cfscript>
    
    </cffunction>
    
    
	<cffunction name="insertPlacementHistory" access="public" returntype="void" output="false" hint="Insert Placement History and returns the newly creted ID">
        <cfargument name="studentID" hint="studentID is required">
        <cfargument name="changedBy" hint="changedBy is required">
        <cfargument name="userType" hint="userType is required">
        <cfargument name="hostID" default="0" hint="hostID is not required">
        <cfargument name="changePlacementReasonID" default="" hint="changePlacementReasonID is not required">
        <cfargument name="changePlacementExplanation" default="" hint="changePlacementExplanation is not required">
        <cfargument name="isWelcomeFamily" default="0" hint="isWelcomeFamily is not required">
        <cfargument name="isRelocation" default="0" hint="isRelocation is not required">
        <cfargument name="dateRelocated" default="" hint="dateRelocated is not required">
        <cfargument name="schoolID" default="0" hint="schoolID is not required">        
        <cfargument name="schoolIDReason" default="" hint="schoolIDReason is not required">     
        <cfargument name="placeRepID" default="0" hint="placeRepID is not required">
        <cfargument name="placeRepIDReason" default="" hint="placeRepIDReason is not required"> 
		<cfargument name="areaRepID" default="0" hint="areaRepID is not required">
        <cfargument name="areaRepIDReason" default="" hint="areaRepIDReason is not required"> 
        <cfargument name="secondVisitRepID" default="0" hint="secondVisitRepID is required">
        <cfargument name="secondVisitRepIDReason" default="" hint="secondVisitRepIDReason is not required"> 
        <cfargument name="doublePlace" default="0" hint="doublePlace is required">
        <cfargument name="doublePlaceReason" default="" hint="doublePlaceReason is not required"> 
        <cfargument name="reason" default="" hint="Field is used for rejection/resubmit comments">
        <cfargument name="placementStatus" default="" hint="Unplaced/Rejected/Approved/Pending/Incomplete">
        <cfargument name="placementAction" default="" hint="setDoublePlacement">
        
        <cfscript>
			// History ID
			var vHostHistoryID = 0;
			
			// Stores previous placement history, school dates must be kept the same if changing host family and school remains the same
			var qGetPreviousPlacementHistory = getPlacementHistory(studentID=ARGUMENTS.studentID,isActive=1);
			
			// Set whether we are updating or inserting a record
			var vQueryType = '';
			
			// Set Action Message
			var vUpdatedBy = 'n/a';
			var vActions = '';			
			
			var vHasHostIDChanged = 0;
			var vHasSchoolIDChanged = 0;
			var vHasPlaceRepIDChanged = 0;
			var vHasAreaRepIDChanged = 0;
			var vHasSecondVisitRepIDChanged = 0;
			var vHasDoublePlacementIDChanged = 0;
			
			// Set to 1 to add an extra line on the history
			var vAddExtraLine = 0;
			
			// Get Current Placement Information
			qGetStudentInfo = getStudentFullInformationByID(studentID=ARGUMENTS.studentID);

			// Get User Information
			qGetEnteredBy = APPLICATION.CFC.USER.getUsers(userID=ARGUMENTS.changedBy);

			// Set Track Placement Status Action Message
			switch(ARGUMENTS.userType) { 
				
				case 1: case 2: case 3: case 4:
					vUpdatedBy = 'Headquarters';
					break; 
					
				case 5: 
					vUpdatedBy = 'Regional Manager';
					break; 

				case 6: 
					vUpdatedBy = 'Regional Advisor';
					break; 

				case 7: 
					vUpdatedBy = 'Supervising Representative';
					break; 
					
			} //end switch
			
			// Updating Placement Information - Check if we need to update/insert history record

			// STUDENT IS UNPLACED - SET MESSAGE
			if ( ARGUMENTS.placementStatus EQ 'Unplaced' ) {
				
				vQueryType = 'insert';
				vActions = vActions & "<strong>New Placement Information - Pending Approval</strong> <br /> #CHR(13)#";
				
				// Welcome Family Information
				if ( VAL(ARGUMENTS.isWelcomeFamily) ) {
					vActions = vActions & "This is a welcome family <br /> #CHR(13)#";
				}
			
			// STUDENT IS PLACED - CHECK FOR UPDATES
			} else {

				// Host Family Updated
				if ( VAL(ARGUMENTS.hostID) AND VAL(qGetStudentInfo.hostID) AND qGetStudentInfo.hostID NEQ ARGUMENTS.hostID ) {
					vQueryType = 'insert';
					vAddExtraLine = 1;
					vHasHostIDChanged = 1;
					
					// Start building record
					vActions = vActions & "<strong>New Placement Information - Pending Approval</strong> <br /> #CHR(13)#";
					
					// Add Message if info has been updated
					if ( VAL(qGetStudentInfo.hostID) ) {
						vActions = vActions & "<strong>Host Family Updated</strong> <br /> #CHR(13)#";
					}
	
					if ( VAL(ARGUMENTS.isWelcomeFamily) ) {
						vActions = vActions & "<strong>This is a welcome family</strong> <br /> #CHR(13)#";
					}
	
					if ( VAL(ARGUMENTS.isRelocation) ) {
						vActions = vActions & "<strong>This is a relocation</strong> <br /> #CHR(13)#"; 						
						// <cfif isDate(ARGUMENTS.dateRelocated)>- Date: #dateFormat(ARGUMENTS.dateRelocated, 'mm/dd/yyyy')#</cfif>
					}

					if ( VAL(ARGUMENTS.changePlacementReasonID) ) {						
						vActions = vActions & "Reason: #APPLICATION.CFC.LOOKUPTABLES.getApplicationLookUp(fieldKey='changePlacementReason',fieldID=ARGUMENTS.changePlacementReasonID).name# <br /> #CHR(13)#";
					}
					
					if ( LEN(ARGUMENTS.changePlacementExplanation) ) {
						vActions = vActions & "Explanation: #ARGUMENTS.changePlacementExplanation# <br /> #CHR(13)#";
					}
	
				}

				// Add Extra Line
				if ( VAl(vAddExtraLine) ) {
					vActions = vActions & "<br /> #CHR(13)#";
					vAddExtraLine = 0;
				}
				
				// School Information
				if ( VAL(ARGUMENTS.schoolID) AND VAL(qGetStudentInfo.schoolID) AND qGetStudentInfo.schoolID NEQ ARGUMENTS.schoolID ) {
					if ( NOT LEN(vQueryType) ) { 
						vQueryType = 'update';
					}
					vAddExtraLine = 1;
					vHasSchoolIDChanged = 1;
					
					// Add Message if info has been updated
					if ( VAL(qGetStudentInfo.schoolID) ) {
						vActions = vActions & "<strong>School Updated - Pending Approval</strong> <br /> #CHR(13)#";
						// Previous School for reference
						qGetSchoolInfo = APPLICATION.CFC.SCHOOL.getSchools(schoolID=qGetStudentInfo.schoolID);
						vActions = vActions & "Previous School: #qGetSchoolInfo.schoolName# ###qGetSchoolInfo.schoolID# <br /> #CHR(13)#";
						// School Paperwork Received
					}				
	
					if ( LEN(ARGUMENTS.schoolIDReason) ) {
						vActions = vActions & "Reason: #ARGUMENTS.schoolIDReason# <br /> #CHR(13)#";
					}
					
				}

				// Add Extra Line
				if ( VAl(vAddExtraLine) ) {
					vActions = vActions & "<br /> #CHR(13)#";
					vAddExtraLine = 0;
				}
								
				// Placing Representative
				if ( VAL(ARGUMENTS.placeRepID) AND VAL(qGetStudentInfo.placeRepID) AND qGetStudentInfo.placeRepID NEQ ARGUMENTS.placeRepID ) {
					if ( NOT LEN(vQueryType) ) { 
						vQueryType = 'update';
					}
					vAddExtraLine = 1;
					vHasPlaceRepIDChanged = 1;

					// Add Message if info has been updated
					if ( VAL(qGetStudentInfo.placeRepID) ) {
						vActions = vActions & "<strong>Placing Representative Updated</strong> <br /> #CHR(13)#";
						// Previous Placing Representative for reference
						qGetPlacingRep = APPLICATION.CFC.USER.getUserByID(userID=qGetStudentInfo.placeRepID);
						vActions = vActions & "Previous Representative: #qGetPlacingRep.firstName# #qGetPlacingRep.lastName# ###qGetPlacingRep.userID# <br /> #CHR(13)#";
					}
	
					if ( LEN(ARGUMENTS.placeRepIDReason) ) {
						vActions = vActions & "Reason: #ARGUMENTS.placeRepIDReason# <br /> #CHR(13)#";
					}

				}

				// Add Extra Line
				if ( VAl(vAddExtraLine) ) {
					vActions = vActions & "<br /> #CHR(13)#";
					vAddExtraLine = 0;
				}
				
				// Supervising Representative
				if ( VAL(ARGUMENTS.areaRepID) AND VAL(qGetStudentInfo.areaRepID) AND qGetStudentInfo.areaRepID NEQ ARGUMENTS.areaRepID ) {
					if ( NOT LEN(vQueryType) ) { 
						vQueryType = 'update';
					}
					vAddExtraLine = 1;
					vHasAreaRepIDChanged = 1;

					// Add Message if info has been updated
					if ( VAL(qGetStudentInfo.areaRepID) ) {
						vActions = vActions & "<strong>Supervising Representative Updated</strong> <br /> #CHR(13)#";
						// Previous Supervising Representative for reference
						qGetSupervisingRep = APPLICATION.CFC.USER.getUserByID(userID=qGetStudentInfo.areaRepID);
						vActions = vActions & "Previous Representative: #qGetSupervisingRep.firstName# #qGetSupervisingRep.lastName# ###qGetSupervisingRep.userID# <br /> #CHR(13)#";
					}
	
					if ( LEN(ARGUMENTS.areaRepIDReason) ) {
						vActions = vActions & "Reason: #ARGUMENTS.areaRepIDReason# <br /> #CHR(13)#";
					}

				}

				// Add Extra Line
				if ( VAl(vAddExtraLine) ) {
					vActions = vActions & "<br /> #CHR(13)#";
					vAddExtraLine = 0;
				}
				
				// 2nd Representative Visit
				if ( VAL(qGetStudentInfo.secondVisitRepID) AND VAL(ARGUMENTS.secondVisitRepID) AND qGetStudentInfo.secondVisitRepID NEQ ARGUMENTS.secondVisitRepID ) {
					if ( NOT LEN(vQueryType) ) { 
						vQueryType = 'update';
					}
					vAddExtraLine = 1;
					vHasSecondVisitRepIDChanged = 1;

					// Add Message if info has been updated
					if ( VAL(qGetStudentInfo.secondVisitRepID) ) {
						vActions = vActions & "<strong>2<sup>nd</sup> Representative Visit Updated</strong> <br /> #CHR(13)#";	
						// Previous Supervising Representative for reference
						qGetSecondVisitRep = APPLICATION.CFC.USER.getUserByID(userID=qGetStudentInfo.secondVisitRepID);
						vActions = vActions & "Previous Representative: #qGetSecondVisitRep.firstName# #qGetSecondVisitRep.lastName# ###qGetSecondVisitRep.userID# <br /> #CHR(13)#";
					}
					
					if ( LEN(ARGUMENTS.secondVisitRepIDReason) ) {
						vActions = vActions & "Reason: #ARGUMENTS.secondVisitRepIDReason# <br /> #CHR(13)#";
					}

				} else if ( VAL(ARGUMENTS.secondVisitRepID) AND qGetStudentInfo.secondVisitRepID NEQ ARGUMENTS.secondVisitRepID ) {
					if ( NOT LEN(vQueryType) ) { 
						vQueryType = 'update';
					}
					vAddExtraLine = 1;
					vHasSecondVisitRepIDChanged = 1;
					
					vActions = vActions & "<strong>2<sup>nd</sup> Representative Visit Added</strong> <br /> #CHR(13)#";

				}

				// Add Extra Line
				if ( VAl(vAddExtraLine) ) {
					vActions = vActions & "<br /> #CHR(13)#";
					vAddExtraLine = 0;
				}
				
				// Update Double Placement 
				if ( VAL(qGetStudentInfo.doublePlace) AND VAL(ARGUMENTS.doublePlace) AND qGetStudentInfo.doublePlace NEQ ARGUMENTS.doublePlace ) {
					if ( NOT LEN(vQueryType) ) { 
						vQueryType = 'update';
					}
					vAddExtraLine = 1;
					vHasDoublePlacementIDChanged = 1;

					// Add Message if info has been updated
					if ( VAL(qGetStudentInfo.doublePlace) ) {
						vActions = vActions & "<strong>Double Placement Updated</strong> <br /> #CHR(13)#";	
						// Previous Supervising Representative for reference
						qGetDoublePlacementInfo = APPLICATION.CFC.STUDENT.getStudentByID(studentID=qGetStudentInfo.doublePlace);
						vActions = vActions & "Previous Student: #qGetDoublePlacementInfo.firstName# #qGetDoublePlacementInfo.familyLastName# ###qGetDoublePlacementInfo.studentID# <br /> #CHR(13)#";
					}
					
					if ( ARGUMENTS.placementAction EQ 'setDoublePlacement' AND LEN(ARGUMENTS.doublePlaceReason) ) {
						// Automatically Assigned Message
						vActions = vActions & "Message: #ARGUMENTS.doublePlaceReason# <br /> #CHR(13)#";
					} else if ( LEN(ARGUMENTS.doublePlaceReason) ) {
						vActions = vActions & "Reason: #ARGUMENTS.doublePlaceReason# <br /> #CHR(13)#";
					}
				
				// Add Double Placement
				} else if ( NOT VAL(qGetStudentInfo.doublePlace) AND VAL(ARGUMENTS.doublePlace) AND qGetStudentInfo.doublePlace NEQ ARGUMENTS.doublePlace ) {
					if ( NOT LEN(vQueryType) ) { 
						vQueryType = 'update';
					}
					vAddExtraLine = 1;
					vHasDoublePlacementIDChanged = 1;

					vActions = vActions & "<strong>Double Placement Added</strong> <br /> #CHR(13)#";

					if ( ARGUMENTS.placementAction EQ 'setDoublePlacement' AND LEN(ARGUMENTS.doublePlaceReason) ) {
						// Automatically Assigned Message
						vActions = vActions & "Message: #ARGUMENTS.doublePlaceReason# <br /> #CHR(13)#";
					} else if ( LEN(ARGUMENTS.doublePlaceReason) ) {
						vActions = vActions & "Reason: #ARGUMENTS.doublePlaceReason# <br /> #CHR(13)#";
					}

				// Remove Double Placement	
				} else if ( VAL(qGetStudentInfo.doublePlace) AND NOT VAL(ARGUMENTS.doublePlace) ) { // ARGUMENTS.placementStatus NEQ 'Approved'
					if ( NOT LEN(vQueryType) ) { 
						vQueryType = 'update';
					}
					vAddExtraLine = 1;
					vHasDoublePlacementIDChanged = 1;
					
					vActions = vActions & "<strong>Double Placement Removed</strong> <br /> #CHR(13)#";	
					// Previous Supervising Representative for reference
					qGetDoublePlacementInfo = APPLICATION.CFC.STUDENT.getStudentByID(studentID=qGetStudentInfo.doublePlace);
					vActions = vActions & "Previous Student: #qGetDoublePlacementInfo.firstName# #qGetDoublePlacementInfo.familyLastName# ###qGetDoublePlacementInfo.studentID# <br /> #CHR(13)#";
					
					if ( ARGUMENTS.placementAction EQ 'setDoublePlacement' AND LEN(ARGUMENTS.doublePlaceReason) ) {
						vActions = vActions & "Message: #ARGUMENTS.doublePlaceReason# <br /> #CHR(13)#";
					} else if ( LEN(ARGUMENTS.doublePlaceReason) ) {
						vActions = vActions & "Reason: #ARGUMENTS.doublePlaceReason# <br /> #CHR(13)#";
					}
					
				}
			
			}
			
			// Check if there is an extra reason/comment
			if ( LEN(ARGUMENTS.reason) ) {
				vActions = vActions & "Comment: #ARGUMENTS.reason# <br /> #CHR(13)#";
			}
			
			// Add User Information
			vActions = vActions & "Updated by: #qGetEnteredBy.firstName# #qGetEnteredBy.lastName# (###qGetEnteredBy.userID#) - #vUpdatedBy# <br /> #CHR(13)#";
			
			// Add paragraph tag to set this update
			vActions = "<p>#vActions#</p>";
		</cfscript>       
        
		<!--- Insert History Information --->
        <cfif vQueryType EQ 'insert'>        
            
            <!--- Host Family Updated | Reset Fields on the Student Table --->
            <cfquery 
                datasource="#APPLICATION.DSN#">
					UPDATE
                    	smg_students
                    SET
                        host_fam_approved = <cfqueryparam cfsqltype="cf_sql_integer" value="10">,
                        date_host_fam_approved = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                        datePlaced = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                        datePISEmailed = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                        placement_notes = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
	            	WHERE
    					studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">
			</cfquery>
            
            <cfscript>
				// Set Date Placed Ended
				setDatePlacedEnded(studentID=ARGUMENTS.studentID,datePlacedEnded=DateFormat(now(), 'mm/dd/yyyy'));
			
				// Set Old Records to Inactive
				setHostHistoryInactive(studentID=ARGUMENTS.studentID);
				
				// Host Family Changed - Reset Double Placement
				if ( VAL(vHasHostIDChanged) ) {
					ARGUMENTS.doublePlace = 0;
				}
			</cfscript>
            
            <cfquery 
                datasource="#APPLICATION.DSN#"
                result="newRecord">
                    INSERT INTO 
                        smg_hosthistory	
                    (
                        studentID, 
                        hostID,  
                        hasHostIDChanged,
                        changePlacementReasonID,
                        changePlacementExplanation,                   
                        schoolID,
                        hasSchoolIDChanged, 
                        placeRepID, 
                        hasPlaceRepIDChanged,
                        areaRepID,
                        hasAreaRepIDChanged,
                        secondVisitRepID, 
                        hasSecondVisitRepIDChanged,
                        doublePlacementID,
                        hasDoublePlacementIDChanged,
                        changedBy,
                        isWelcomeFamily,
                        isRelocation,
                        dateRelocated,
                        dateOfChange, 
                        reason,
                        isActive,
                        dateCreated,
                        createdBy,
                        updatedBy
                    )
                    VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(vHasHostIDChanged)#">, 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.changePlacementReasonID)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.changePlacementExplanation#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.schoolID)#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(vHasSchoolIDChanged)#">,   
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.placeRepID)#">, 
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(vHasPlaceRepIDChanged)#">, 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.areaRepID)#">, 
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(vHasAreaRepIDChanged)#">, 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.secondVisitRepID)#">, 
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(vHasSecondVisitRepIDChanged)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.doublePlace)#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(vHasDoublePlacementIDChanged)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.changedBy)#">, 
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(ARGUMENTS.isWelcomeFamily)#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(ARGUMENTS.isRelocation)#">, 
                        <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.dateRelocated#" null="#NOT IsDate(ARGUMENTS.dateRelocated)#">, 
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#vActions#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="1">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                       	<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
                    )
            </cfquery>
            
        	<cfscript>
				// Set History ID
				vHostHistoryID = newRecord.GENERATED_KEY;
				
				// Insert Placement Log History
				
				// Insert Host ID Track
				if ( VAL(ARGUMENTS.hostID) ) {
	
					insertPlacementTracking(
						historyID=vHostHistoryID,
						studentID=ARGUMENTS.studentID,
						fieldName='hostID',
						fieldID=ARGUMENTS.hostID
					);
				
				}
				
				// Insert School ID Track
				if ( VAL(ARGUMENTS.schoolID) ) {
	
					insertPlacementTracking(
						historyID=vHostHistoryID,
						studentID=ARGUMENTS.studentID,
						fieldName='schoolID',
						fieldID=ARGUMENTS.schoolID
					);
				
				}
				
				// Insert Place Rep ID Track
				if ( VAL(ARGUMENTS.placeRepID) ) {
	
					insertPlacementTracking(
						historyID=vHostHistoryID,
						studentID=ARGUMENTS.studentID,
						fieldName='placeRepID',
						fieldID=ARGUMENTS.placeRepID
					);
				
				}
				
				// Insert Area Rep ID Track
				if ( VAL(ARGUMENTS.areaRepID) ) {
	
					insertPlacementTracking(
						historyID=vHostHistoryID,
						studentID=ARGUMENTS.studentID,
						fieldName='areaRepID',
						fieldID=ARGUMENTS.areaRepID
					);
				
				}
				
				// Insert Second Visit Rep Track
				if ( VAL(ARGUMENTS.secondVisitRepID) ) {
	
					insertPlacementTracking(
						historyID=vHostHistoryID,
						studentID=ARGUMENTS.studentID,
						fieldName='secondVisitRepID',
						fieldID=ARGUMENTS.secondVisitRepID
					);
				
				}
				
				// Insert Double Placement Track
				if ( VAL(ARGUMENTS.doublePlace) ) {
	
					insertPlacementTracking(
						historyID=vHostHistoryID,
						studentID=ARGUMENTS.studentID,
						fieldName='doublePlacementID',
						fieldID=ARGUMENTS.doublePlace
					);
				
				}
            </cfscript>
            
            <!--- School has not changed, copy student orientation and school dates from previous history --->
            <cfif NOT VAL(vHasSchoolIDChanged) AND VAL(qGetPreviousPlacementHistory.recordCount)>
            
                <cfquery datasource="#APPLICATION.DSN#" result="test1">
					UPDATE
                    	smg_hosthistory
                    SET
                    	stu_arrival_orientation = <cfqueryparam cfsqltype="cf_sql_date" value="#qGetPreviousPlacementHistory.stu_arrival_orientation#" null="#NOT IsDate(qGetPreviousPlacementHistory.stu_arrival_orientation)#">,
                        doc_school_accept_date = <cfqueryparam cfsqltype="cf_sql_date" value="#qGetPreviousPlacementHistory.doc_school_accept_date#" null="#NOT IsDate(qGetPreviousPlacementHistory.doc_school_accept_date)#">,
                        doc_school_sign_date = <cfqueryparam cfsqltype="cf_sql_date" value="#qGetPreviousPlacementHistory.doc_school_sign_date#" null="#NOT IsDate(qGetPreviousPlacementHistory.doc_school_sign_date)#">,
                        doc_class_schedule = <cfqueryparam cfsqltype="cf_sql_date" value="#qGetPreviousPlacementHistory.doc_class_schedule#" null="#NOT IsDate(qGetPreviousPlacementHistory.doc_class_schedule)#">,
                        updatedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
                    WHERE
                    	historyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(vHostHistoryID)#">                     
                </cfquery>
                
          	<cfelseif VAL(qGetPreviousPlacementHistory.recordCount)>
            
                <cfquery datasource="#APPLICATION.DSN#" result="test2">
					UPDATE
                    	smg_hosthistory
                    SET
                    	stu_arrival_orientation = <cfqueryparam cfsqltype="cf_sql_date" value="#qGetPreviousPlacementHistory.stu_arrival_orientation#" null="#NOT IsDate(qGetPreviousPlacementHistory.stu_arrival_orientation)#">,
                        updatedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
                 	WHERE
                    	historyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(vHostHistoryID)#">                     
                </cfquery>
                
            </cfif>
            
        </cfif>
        
		<cfscript>
			// Get Current HistoryID if we do not have one
			if ( NOT VAL(vHostHistoryID) ) {
				vHostHistoryID = getPlacementHistory(studentID=ARGUMENTS.studentID,isActive=1).historyID;
			}
				
			if ( LEN(vQueryType) ) {
				
				// Insert Actions Into Separate Table
				APPLICATION.CFC.LOOKUPTABLES.insertApplicationHistory(
					applicationID=APPLICATION.CONSTANTS.TYPE.EXITS,
					foreignTable='smg_hosthistory',
					foreignID=vHostHistoryID,
					enteredByID=VAL(ARGUMENTS.changedBy),
					actions=vActions
				);			
		
			}
			
			// Insert Placement Log History
			
			// Insert Host ID Track
			if ( VAL(vHasHostIDChanged) AND VAL(ARGUMENTS.hostID) ) {

				insertPlacementTracking(
					historyID=vHostHistoryID,
					studentID=ARGUMENTS.studentID,
					fieldName='hostID',
					fieldID=ARGUMENTS.hostID
				);
			
			}
			
			// Insert School ID Track
			if ( VAL(vHasSchoolIDChanged) AND VAL(ARGUMENTS.schoolID) ) {

				insertPlacementTracking(
					historyID=vHostHistoryID,
					studentID=ARGUMENTS.studentID,
					fieldName='schoolID',
					fieldID=ARGUMENTS.schoolID
				);
			
			}
			
			// Insert Place Rep ID Track
			if ( VAL(vHasPlaceRepIDChanged) AND VAL(ARGUMENTS.placeRepID) ) {

				insertPlacementTracking(
					historyID=vHostHistoryID,
					studentID=ARGUMENTS.studentID,
					fieldName='placeRepID',
					fieldID=ARGUMENTS.placeRepID
				);
			
			}
			
			// Insert Area Rep ID Track
			if ( VAL(vHasAreaRepIDChanged) AND VAL(ARGUMENTS.areaRepID) ) {

				insertPlacementTracking(
					historyID=vHostHistoryID,
					studentID=ARGUMENTS.studentID,
					fieldName='areaRepID',
					fieldID=ARGUMENTS.areaRepID
				);
			
			}
			
			// Insert Second Visit Rep Track
			if ( VAL(vHasSecondVisitRepIDChanged) AND VAL(ARGUMENTS.secondVisitRepID) ) {

				insertPlacementTracking(
					historyID=vHostHistoryID,
					studentID=ARGUMENTS.studentID,
					fieldName='secondVisitRepID',
					fieldID=ARGUMENTS.secondVisitRepID
				);
			
			}
			
			// Insert Double Placement Track
			if ( VAL(vHasDoublePlacementIDChanged) AND VAL(ARGUMENTS.doublePlace) ) {

				insertPlacementTracking(
					historyID=vHostHistoryID,
					studentID=ARGUMENTS.studentID,
					fieldName='doublePlacementID',
					fieldID=ARGUMENTS.doublePlace
				);
			
			}
			
			// Update Mileage if Host Family or Supervising Representative is updated
			if ( ARGUMENTS.placementStatus EQ 'Unplaced' OR VAL(vHasHostIDChanged) OR VAL(vHasAreaRepIDChanged) ) {
			
				// Get Host Family Address
				vHostAddress = APPLICATION.CFC.HOST.getCompleteHostAddress(hostID=ARGUMENTS.hostID).completeAddress;
				
				// Get Supervising Representative Address
				vSupervisingRepAddress = APPLICATION.CFC.USER.getCompleteUserAddress(userID=ARGUMENTS.areaRepID).completeAddress;
				
				// Get Driving Distance From Google
				vGoogleDistance = APPLICATION.CFC.UDF.calculateAddressDistance(origin=vHostAddress,destination=vSupervisingRepAddress);
				
				// Set to 0 if could not retrieve it successfully
				if ( NOT IsNumeric(vGoogleDistance) ) {
					vGoogleDistance = 0;
				}
				
				// Update Distance in the database
				APPLICATION.CFC.STUDENT.updateHostSupervisingDistance(
					historyID=vHostHistoryID,
					distanceInMiles=vGoogleDistance
				);

			}
		</cfscript> 
        
        <!--- Update History --->
        <cfif vQueryType EQ 'update' AND ARGUMENTS.placementAction NEQ 'setDoublePlacement'>

            <cfquery 
                datasource="#APPLICATION.DSN#">
                    UPDATE
                        smg_hosthistory	
                    SET
                    	<!--- If school has changed reset school paperwork --->
						<cfif VAL(vHasSchoolIDChanged)>
                        	hasSchoolIDChanged = <cfqueryparam cfsqltype="cf_sql_bit" value="#vHasSchoolIDChanged#">,                
                        	doc_school_accept_date = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                            doc_school_sign_date = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                            doc_class_schedule = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                            datePISEmailed = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
						</cfif>
                        
                        <cfif VAL(vHasPlaceRepIDChanged)>
                        	hasPlaceRepIDChanged = <cfqueryparam cfsqltype="cf_sql_bit" value="#vHasPlaceRepIDChanged#">,
                        </cfif>
                        
                        <cfif VAL(vHasAreaRepIDChanged)>
                        	hasAreaRepIDChanged = <cfqueryparam cfsqltype="cf_sql_bit" value="#vHasAreaRepIDChanged#">,
                        </cfif>
                        
                        <cfif VAL(vHasSecondVisitRepIDChanged)>
                        	hasSecondVisitRepIDChanged = <cfqueryparam cfsqltype="cf_sql_bit" value="#vHasSecondVisitRepIDChanged#">,
                        </cfif>
                        
                        <cfif VAL(vHasDoublePlacementIDChanged)>
                        	hasDoublePlacementIDChanged = <cfqueryparam cfsqltype="cf_sql_bit" value="#vHasDoublePlacementIDChanged#">,
                       	</cfif> 

                        schoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.schoolID)#">,  
                        placeRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.placeRepID)#">,
                        areaRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.areaRepID)#">,
                        secondVisitRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.secondVisitRepID)#">,
                        doublePlacementID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.doublePlace)#">,
                        updatedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
                    WHERE
                        historyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(vHostHistoryID)#">
            </cfquery>
        
		</cfif>
         
        <!--- If school has changed reset datePISEmailed --->
        <cfif VAL(vHasSchoolIDChanged)>
        
            <cfquery 
                datasource="#APPLICATION.DSN#">
					UPDATE
                    	smg_students
                    SET
                        datePISEmailed = <cfqueryparam cfsqltype="cf_sql_date" null="yes">
	            	WHERE
    					studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">
			</cfquery>

        </cfif>
        
        <cfscript>
			// Send Out School Notification when school reaches 5 students | New Placement or School Update
			if ( ARGUMENTS.placementStatus EQ 'Unplaced' OR VAL(vHasSchoolIDChanged) ) {
				
				APPLICATION.CFC.SCHOOL.complianceSchoolNotification(	
					studentID=ARGUMENTS.studentID, 
					schoolID=ARGUMENTS.schoolID, 
					startDate=qGetStudentInfo.startDate, 
					endDate=qGetStudentInfo.endDate
				);
				
			}
		</cfscript>
        
	</cffunction>


	<!--- Insert Placement Tracking --->
	<cffunction name="insertPlacementTracking" access="public" returntype="void" output="false" hint="Inserts Placement Tracking to the log">
    	<cfargument name="historyID" hint="historyID is required">
        <cfargument name="studentID" hint="studentID is required">
        <cfargument name="fieldName" default="0" hint="fieldName is not required">
        <cfargument name="fieldID" default="0" hint="fieldID is not required">
		
        <!--- Check if record is already in the history --->
        <cfquery
        	name="qCheckRecord" 
			datasource="#APPLICATION.DSN#">
        		SELECT
                	historyID
                FROM
                	smg_hosthistorytracking
                WHERE
                	historyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.historyID)#">
                AND
                	studentiD = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">
                AND
                	fieldID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.fieldID)#">
                AND
                	fieldName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.fieldName#">
		</cfquery>                    
        
        <cfif NOT VAL(qCheckRecord.recordCount)>
        
            <cfquery 
                datasource="#APPLICATION.DSN#">
                    INSERT INTO 
                        smg_hosthistorytracking
                    (
                        historyID,
                        studentID,
                        fieldName,
                        fieldID,
                        dateCreated
                    )
                    VALUES 
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.historyID)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.fieldName#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.fieldID)#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    ) 
            </cfquery>
    
    	</cfif>
    
	</cffunction>

	
    <!--- Set Old Host History Records as Inactive --->
	<cffunction name="setHostHistoryInactive" access="public" returntype="void" output="false" hint="Set Old Host History Records as Inactive">
    	<cfargument name="studentID" hint="studentID is required">

        <cfquery 
            datasource="#APPLICATION.DSN#">
                UPDATE
                    smg_hosthistory
                SET
                    isActive = <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
                    updatedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
                WHERE
                    studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">
                AND	
                    assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        </cfquery> 
                           
    </cffunction>


    <!--- Set Date placed ended --->
	<cffunction name="setDatePlacedEnded" access="public" returntype="void" output="false" hint="Set date placed ended for canceled students">
    	<cfargument name="historyID" default="0" hint="historyID is not required">
        <cfargument name="studentID" default="0" hint="studentID is not required">
        <cfargument name="datePlacedEnded" hint="datePlacedEnded is required">
		
        <cfscript>
			var vHistoryID = ARGUMENTS.historyID;
			
			if ( NOT VAL(vHistoryID) ) {
				vHistoryID = getPlacementHistory(studentID=VAL(ARGUMENTS.studentID)).historyID;
			}	
		</cfscript>
        
        <cfif VAL(vHistoryID) AND isDate(ARGUMENTS.datePlacedEnded)>
        
            <cfquery 
                datasource="#APPLICATION.DSN#">
                    UPDATE
                        smg_hosthistory
                    SET
                        datePlacedEnded = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.datePlacedEnded#">,
                        updatedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
                    WHERE
                        historyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#vHistoryID#">
            </cfquery> 
        
        </cfif>
                           
    </cffunction>


    <!--- Update Host / Supervising Distance --->
	<cffunction name="updateHostSupervisingDistance" access="public" returntype="void" output="false" hint="Update Host / Supervising Distance">
        <cfargument name="historyID" default="0" hint="historyID is not required">
        <cfargument name="distanceInMiles" hint="distanceInMiles is required">
			
        <cfquery 
            datasource="#APPLICATION.DSN#">
                UPDATE
                    smg_hosthistory
                SET
                    hfSupervisingDistance = <cfqueryparam cfsqltype="cf_sql_float" value="#ARGUMENTS.distanceInMiles#">,
                    updatedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
                WHERE
                    historyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.historyID)#">	
        </cfquery>
		
    </cffunction>
    

    <!--- Update Date PIS Emailed --->
	<cffunction name="updateDatePISEmailed" access="public" returntype="void" output="false" hint="Update Date PIS Emailed">
        <cfargument name="studentID" hint="studentID is not required">
			
        <cfquery datasource="#APPLICATION.DSN#">
            UPDATE
                smg_students
            SET
                datePISEmailed = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
            WHERE
                studentID = <cfqueryparam cfsqltype="integer" value="#VAL(ARGUMENTS.studentID)#">                 	
        </cfquery>
        
        <cfquery datasource="#APPLICATION.DSN#">
            UPDATE
                smg_hosthistory
            SET
                datePISEmailed = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                updatedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
            WHERE
                studentID = <cfqueryparam cfsqltype="integer" value="#VAL(ARGUMENTS.studentID)#">      
            AND
                assignedID = <cfqueryparam cfsqltype="cf_sql_bit" value="0"> 
            AND	
                isActive = <cfqueryparam cfsqltype="cf_sql_bit" value="1">           	
        </cfquery>

    </cffunction>
    
    
    <!--- Update Date Placed --->
	<cffunction name="updateDatePlaced" access="public" returntype="void" output="false" hint="Update Date Placed">
        <cfargument name="studentID" hint="studentID is required">
        <cfargument name="historyID" default="0" hint="historyID is not required">
        <cfargument name="datePlaced" hint="studentID is required">
    	
        <cfscript>
			var vSetNewDate = CreateODBCDateTime(ARGUMENTS.datePlaced & " " & TimeFormat(now(), "hh:mm:ss tt"));
		</cfscript>
        
        <!--- Check if we are updating a history or current record --->
        <cfquery name="qGetHistoryID" datasource="#APPLICATION.DSN#">
            SELECT
                historyID,
                isActive
            FROM 
                smg_hosthistory
            WHERE
                studentID = <cfqueryparam cfsqltype="integer" value="#ARGUMENTS.studentID#">
            AND
                assignedID = <cfqueryparam cfsqltype="cf_sql_bit" value="0">

            <!--- Get history record --->
            <cfif VAL(ARGUMENTS.historyID)>
                AND
                    historyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.historyID)#">
            <!--- Get active record --->
            <cfelse>
                AND
                    isActive = <cfqueryparam cfsqltype="cf_sql_bit" value="1">            
            </cfif>
        </cfquery>
        
        <!--- Only update smg_students table if historyID belongs to the current placement --->
        <cfif VAL(qGetHistoryID.isActive)>
        
            <cfquery datasource="#APPLICATION.DSN#">
                UPDATE 
                    smg_students
                SET
                    datePlaced = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vSetNewDate#">
                WHERE
                    studentID = <cfqueryparam cfsqltype="integer" value="#VAL(ARGUMENTS.studentID)#">
            </cfquery>
            
       	</cfif>
        
		<cfquery datasource="#APPLICATION.DSN#" result="recordKey">
        	UPDATE 
				smg_hosthistory
        	SET
				datePlaced = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vSetNewDate#">,
                updatedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
        	WHERE
				historyID = <cfqueryparam cfsqltype="integer" value="#VAL(qGetHistoryID.historyID)#">
        </cfquery>

        <!--- Update History Log --->
        <cfquery datasource="#APPLICATION.DSN#">
			UPDATE
            	applicationhistory
            SET
            	dateCreated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vSetNewDate#">,
                dateUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vSetNewDate#"> 
            WHERE
            	foreignTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="smg_hosthistory">
            AND
            	foreignID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetHistoryID.historyID)#">   
            AND
            	actions LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%Placement Approved by Office%">
        </cfquery>
	
	</cffunction>


	<!--- Get Placement History --->
	<cffunction name="getPlacementHistory" access="public" returntype="query" output="false" hint="Returns full placement information">
    	<cfargument name="studentID" hint="studentID is required">
        <cfargument name="isActive" default="" hint="isActive is not required">
        
        <cfquery 
        	name="qGetPlacementHistory" 
            datasource="#APPLICATION.DSN#">
                SELECT 
                    h.historyID,
                    h.companyID,
                    h.studentID,
                    h.hostID,
                    h.hasHostIDChanged,
                    h.schoolID,
                    h.hasSchoolIDChanged,
                    h.placeRepID,
                    h.hasPlaceRepIDChanged,
                    h.areaRepID,
                    h.hasAreaRepIDChanged,
                    h.secondVisitRepID,
                    h.hasSecondVisitRepIDChanged,
                    h.doublePlacementID,
                    h.hasDoublePlacementIDChanged,
                    h.changedBy,
                    h.isWelcomeFamily,
                    h.isRelocation,
                    h.original_place,
                    h.hfSupervisingDistance,
                    h.reason,
                    h.changePlacementReasonID,
                    h.changePlacementExplanation,
                    h.datePlaced,
                    h.datePlacedEnded,
                    h.dateRelocated,
                    h.datePISEmailed,
                    h.dateSetHostPermanent,
                    <!--- Single Person Placement Paperwork --->
                    h.doc_single_place_auth,
					h.doc_single_ref_form_1,
                    h.doc_single_ref_check1,
                    h.doc_single_ref_form_2,
					h.doc_single_ref_check2,
                    h.doc_single_parents_sign_date,
                    h.doc_single_student_sign_date,
                    <!--- Page 1 --->
                    h.doc_host_app_page1_date,
                    <!--- Page 2 --->
                    h.doc_host_app_page2_date,
                    <!--- Page 3 - Letter --->                    
                    h.doc_letter_rec_date,
                    <!--- Page 4,5,6 - Photos --->
                    h.doc_photos_rec_date,
                    h.doc_bedroom_photo,
                    h.doc_bathroom_photo,
                    h.doc_kitchen_photo,
                    h.doc_living_room_photo,
                    h.doc_outside_photo,
                    <!--- Page 7 - HF Rules ---> 
                    h.doc_rules_rec_date,
                    h.doc_rules_sign_date,
                    <!--- Page 8 - School & Community Profile --->
                    h.doc_school_profile_rec,
                    <!--- Page 9 - Income Verification ---> 
                    h.doc_income_ver_date,
                    <!--- Page 10 - Confidential HF Visit --->
                    h.doc_conf_host_rec,
                    h.compliance_conf_host_rec,
                    h.doc_date_of_visit,
                    <!--- Page 11 - Reference 1 ---> 
                    h.doc_ref_form_1,
                    h.doc_ref_check1,
                    <!--- Page 12 - Reference 2 --->
                    h.doc_ref_form_2,
                    h.doc_ref_check2,
                    h.doc_host_orientation,
                    <!--- Arrival Compliance --->
                    h.doc_school_accept_date,
                    h.compliance_school_accept_date,
                    h.doc_school_sign_date,
                    <!--- Arrival Orientation --->
                    h.stu_arrival_orientation,
                    h.compliance_stu_arrival_orientation,
                    h.host_arrival_orientation,
                    h.compliance_host_arrival_orientation,
                    h.doc_class_schedule,
					<!--- Compliance Review --->
					h.compliance_review,
                    h.actions,
                    h.isActive,
                    h.dateOfChange,
                    h.dateCreated,
                    h.dateUpdated,                
                    <!--- Host Family --->
                    host.familyLastName,
                    <!--- School --->
                    school.schoolName,
                    <!--- Place Rep --->
                    place.firstName AS placeFirstName, 
                    place.lastName AS placeLastName,
                    <!--- Area Rep --->
                    area.firstName AS areaFirstName, 
                    area.lastName AS areaLastName,
                    <!--- 2nd Rep Visit --->
                    secondRep.firstName AS secondRepFirstName,
                    secondRep.lastName AS secondRepLastName,
                    <!--- Double Placement --->
                    dp.firstName AS doublePlacementFirstName,
                    dp.familyLastName AS doublePlacementLastName,
                    <!--- User --->
                    user.firstName AS changedByFirstName, 
                    user.lastName AS changedByLastName
                FROM 
                    smg_hosthistory h
                LEFT JOIN 
                    smg_hosts host ON h.hostid = host.hostID
                LEFT JOIN 
                    smg_schools school ON h.schoolID = school.schoolID
                LEFT JOIN 
                    smg_users place ON h.placeRepID = place.userID
                LEFT JOIN 
                    smg_users area ON h.areaRepID = area.userID
                LEFT JOIN 
                    smg_users secondRep ON h.secondVisitRepID = secondRep.userID
                LEFT JOIN
                	smg_students dp ON h.doublePlacementID = dp.studentID   
                LEFT JOIN 
                    smg_users user ON h.changedby = user.userID
                WHERE 
                    h.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">
                AND
                	h.assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                <!--- Do not display change of school/ and reps --->
                AND
                	h.hostID != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                
                <cfif LEN(ARGUMENTS.isActive)>
                    AND
                        h.isActive = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.isActive)#">
                </cfif>
                
                ORDER BY 
                    h.dateCreated DESC, 
                    h.historyid DESC
        </cfquery>
                
        <cfreturn qGetPlacementHistory>
    </cffunction>


	<!--- Get Placement History By ID --->
	<cffunction name="getHostHistoryByID" access="public" returntype="query" output="false" hint="Returns placement/paperwork history">
    	<cfargument name="studentID" default="" hint="studentID is required">
        <cfargument name="historyID" default="" hint="historyID is required">
        <cfargument name="getActiveRecord" default="0" hint="getActiveRecord is not required">
        
        <cfquery 
        	name="qGetHostHistoryByID" 
            datasource="#APPLICATION.DSN#">
                SELECT 
                    historyID,
                    companyID,
                    studentID,
                    hostID,
                    hasHostIDChanged,
                    schoolID,
                    hasSchoolIDChanged,
                    placeRepID,
                    hasPlaceRepIDChanged,
                    areaRepID,
                    hasAreaRepIDChanged,
                    secondVisitRepID,
                    hasSecondVisitRepIDChanged,
                    doublePlacementID,
                    hasDoublePlacementIDChanged,
                    changedBy,
                    isWelcomeFamily,
                    isRelocation,
                    original_place,
                    hfSupervisingDistance,
                    reason,
                    changePlacementReasonID,
                    changePlacementExplanation,
                    dateReceived,
                    datePlaced,
                    datePlacedEnded,
                    dateRelocated,
                    datePISEmailed,
                    dateSetHostPermanent,
                    <!--- Single Person Placement Paperwork --->
                    doc_single_place_auth,
                    compliance_single_place_auth,
                    doc_single_parents_sign_date,
                    compliance_single_parents_sign_date,
                    doc_single_student_sign_date,  
                    compliance_single_student_sign_date,  
					doc_single_ref_form_1,
					compliance_single_ref_form_1,
                    doc_single_ref_check1,
                    compliance_single_ref_check1,
                    doc_single_ref_form_2,
                    compliance_single_ref_form_2,
					doc_single_ref_check2,
					compliance_single_ref_check2,
                    <!--- Page 1 --->
                    doc_host_app_page1_date,
                    compliance_host_app_page1_date,
                    <!--- Page 2 --->
                    doc_host_app_page2_date,
                    compliance_host_app_page2_date,
                    <!--- Page 3 - Letter --->
                    doc_letter_rec_date,
                    compliance_letter_rec_date,
                    <!--- Page 4,5,6 - Photos --->
                    doc_photos_rec_date,
                    compliance_photos_rec_date,
                    doc_bedroom_photo,
                    compliance_bedroom_photo,
                    doc_bathroom_photo,
                    compliance_bathroom_photo,
                    doc_kitchen_photo,
                    compliance_kitchen_photo,
                    doc_living_room_photo,
                    compliance_living_room_photo,
                    doc_outside_photo,
                    compliance_outside_photo,
                    <!--- Page 7 - HF Rules ---> 
                    doc_rules_rec_date,
                    compliance_rules_rec_date,
                    doc_rules_sign_date,
                    compliance_rules_sign_date,
                    <!--- Page 8 - School & Community Profile ---> 
                    doc_school_profile_rec,
                    compliance_school_profile_rec,
                    <!--- Page 9 - Income Verification ---> 
                    doc_income_ver_date,
                    compliance_income_ver_date,
                    <!--- Page 10 - Confidential HF Visit ---> 
                    doc_conf_host_rec,
                    compliance_conf_host_rec,
                    doc_date_of_visit,
                    compliance_date_of_visit,
                    <!--- Page 11 - Reference 1 ---> 
                    doc_ref_form_1,
                    compliance_ref_form_1,
                    doc_ref_check1,
                    compliance_ref_check1,
                    <!--- Page 12 - Reference 2 --->
                    doc_ref_form_2,
                    compliance_ref_form_2,
                    doc_ref_check2,
                    compliance_ref_check2,
                    <!--- Arrival Compliance --->
                    doc_school_accept_date,
                    compliance_school_accept_date,
                    doc_school_sign_date,
                    compliance_school_sign_date,
					<!--- Compliance Review --->
					compliance_review,
                    <!--- Arrival Orientation --->
                    stu_arrival_orientation,
                    compliance_stu_arrival_orientation,
                    host_arrival_orientation,
                    compliance_host_arrival_orientation,
                    doc_class_schedule,
                    compliance_class_schedule,
                    actions,
					isActive,
                    dateOfChange,
                    dateCreated,
                    dateUpdated
                FROM 
                    smg_hosthistory
                WHERE 
                	1 = 1
                    
                <cfif LEN(ARGUMENTS.historyID)>
                	AND                    
                    	historyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.historyID)#">
                </cfif>
                
                <cfif LEN(ARGUMENTS.studentID)>
                    AND
                        studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">
                </cfif>
                    
                <cfif VAL(ARGUMENTS.getActiveRecord)>
                	AND
                    	isActive = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                </cfif>
                
        </cfquery>
        
        <cfreturn qGetHostHistoryByID>
    </cffunction>


	<!--- Get Double Placement Tracking History --->
	<cffunction name="getDoublePlacementPaperworkHistory" access="public" returntype="query" output="false" hint="Returns double placement paperwork history">
    	<cfargument name="studentID" hint="studentID is required">
        <cfargument name="historyID" hint="historyID is required">
        
        <cfquery 
        	name="qGetDoublePlacementPaperworkHistory" 
            datasource="#APPLICATION.DSN#">
                SELECT 
                    ht.ID,
                    ht.isDoublePlacementPaperworkRequired,                    
                    ht.doublePlacementParentsDateSigned,
                    ht.doublePlacementParentsDateCompliance,
                    ht.doublePlacementStudentDateSigned,
                    ht.doublePlacementStudentDateCompliance,
                    ht.doublePlacementHostFamilyDateSigned,
                    ht.doublePlacementHostFamilyDateCompliance,
                    ht.dateCreated,                    
                    <!--- Double Placement --->
                    dp.studentID AS doublePlacementID,
                    CAST(CONCAT(dp.firstName, ' ', dp.familyLastName,  ' (##', dp.studentID, ')') AS CHAR) AS doublePlacementStudent                    
                FROM
                    smg_hosthistorytracking ht
				INNER JOIN
                	smg_students dp ON ht.fieldID = dp.studentID 
               	WHERE 
                	ht.historyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.historyID)#">
				AND
                    ht.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">
                AND
                   	ht.fieldName = <cfqueryparam cfsqltype="cf_sql_varchar" value="doublePlacementID">
				
                ORDER BY 
                    ht.dateCreated DESC, 
                    ht.historyid DESC
        </cfquery>
                
        <cfreturn qGetDoublePlacementPaperworkHistory>
    </cffunction>
    
    
    <!--- Updates fields in smg_hosthistory that are now in the host application --->
    <cffunction name="updateOldHostHistoryFields" access="public" returntype="void" output="no">
    	<cfargument name="historyID" type="numeric" required="yes" hint="historyID is required">
        <cfargument name="doc_conf_host_rec" default="" hint="doc_conf_host_rec is not required">
        <cfargument name="doc_school_accept_date" default="" hint="doc_school_accept_date is not required">
        <cfargument name="host_arrival_orientation" default="" hint="host_arrival_orientation is not required">
        <cfargument name="stu_arrival_orientation" default="" hint="stu_arrival_orientation is not required">
        <cfargument name="compliance_conf_host_rec" default="" hint="compliance_doc_conf_host_rec is not required">
        <cfargument name="compliance_school_accept_date" default="" hint="compliance_doc_school_accept_date is not required">
        <cfargument name="compliance_host_arrival_orientation" default="" hint="compliance_host_arrival_orientation is not required">
        <cfargument name="compliance_stu_arrival_orientation" default="" hint="compliance_stu_arrival_orientation is not required">
        
        <cfquery datasource="#APPLICATION.DSN#">
        	UPDATE smg_hosthistory
            SET historyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.historyID#"> <!--- To make sure something is updated --->
            <cfif IsDate(ARGUMENTS.doc_conf_host_rec)>
            	,doc_conf_host_rec = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_conf_host_rec#">
            </cfif>
            <cfif IsDate(ARGUMENTS.doc_school_accept_date)>
            	,doc_school_accept_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_school_accept_date#">
            </cfif>
            <cfif IsDate(ARGUMENTS.host_arrival_orientation)>
            	,host_arrival_orientation = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.host_arrival_orientation#">
            </cfif>
            <cfif IsDate(ARGUMENTS.stu_arrival_orientation)>
            	,stu_arrival_orientation = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.stu_arrival_orientation#">
            </cfif>
            <cfif IsDate(ARGUMENTS.compliance_conf_host_rec)>
            	,compliance_conf_host_rec = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.compliance_conf_host_rec#">
            </cfif>
            <cfif IsDate(ARGUMENTS.compliance_school_accept_date)>
            	,compliance_school_accept_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.compliance_school_accept_date#">
            </cfif>
            <cfif IsDate(ARGUMENTS.compliance_host_arrival_orientation)>
            	,compliance_host_arrival_orientation = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.compliance_host_arrival_orientation#">
            </cfif>
            <cfif IsDate(ARGUMENTS.compliance_stu_arrival_orientation)>
            	,compliance_stu_arrival_orientation = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.compliance_stu_arrival_orientation#">
            </cfif>
            WHERE historyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.historyID#">
        </cfquery>
        
    </cffunction>
    
    
	<!--- Updates a double placement tracking history --->
	<cffunction name="updateDoublePlacementTrackingHistory" access="public" returntype="void" output="false" hint="Updates a double placement tracking history">
    	<cfargument name="ID" hint="smg_hosthistoryTracking ID is required">
        <cfargument name="isDoublePlacementPaperworkRequired" default="" hint="isDoublePlacementPaperworkRequired is not required">
        <cfargument name="doublePlacementParentsDateSigned" default="" hint="doublePlacementParentsDateSigned is not required">
        <cfargument name="doublePlacementParentsDateCompliance" default="" hint="doublePlacementParentsDateCompliance is not required">
        <cfargument name="doublePlacementStudentDateSigned" default="" hint="doublePlacementStudentDateSigned is not required">
        <cfargument name="doublePlacementStudentDateCompliance" default="" hint="doublePlacementStudentDateCompliance is not required">
        <cfargument name="doublePlacementHostFamilyDateSigned" default="" hint="doublePlacementHostFamilyDateSigned is not required">
        <cfargument name="doublePlacementHostFamilyDateCompliance" default="" hint="doublePlacementHostFamilyDateCompliance is not required">

        <cfquery 
            datasource="#APPLICATION.DSN#">
                UPDATE
                	smg_hosthistorytracking
                SET
                	isDoublePlacementPaperworkRequired = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(ARGUMENTS.isDoublePlacementPaperworkRequired)#" null="#NOT IsNumeric(ARGUMENTS.isDoublePlacementPaperworkRequired)#">,
                    doublePlacementParentsDateSigned = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doublePlacementParentsDateSigned#" null="#NOT IsDate(ARGUMENTS.doublePlacementParentsDateSigned)#">,
                    doublePlacementParentsDateCompliance = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doublePlacementParentsDateCompliance#" null="#NOT IsDate(ARGUMENTS.doublePlacementParentsDateCompliance)#">,
                    doublePlacementStudentDateSigned = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doublePlacementStudentDateSigned#" null="#NOT IsDate(ARGUMENTS.doublePlacementStudentDateSigned)#">,
                    doublePlacementStudentDateCompliance = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doublePlacementStudentDateCompliance#" null="#NOT IsDate(ARGUMENTS.doublePlacementStudentDateCompliance)#">,
                    doublePlacementHostFamilyDateSigned = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doublePlacementHostFamilyDateSigned#" null="#NOT IsDate(ARGUMENTS.doublePlacementHostFamilyDateSigned)#">,
                    doublePlacementHostFamilyDateCompliance = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doublePlacementHostFamilyDateCompliance#" null="#NOT IsDate(ARGUMENTS.doublePlacementHostFamilyDateCompliance)#">
                WHERE
					ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.ID)#">
        </cfquery>
    </cffunction>
    

	<!--- Placement Paperwork --->
	<cffunction name="updatePlacementPaperworkHistory" access="public" returntype="void" output="false" hint="Update Placement Paperwork">
        <cfargument name="studentID" default="0" hint="studentID is not required">
        <cfargument name="historyID" default="0" hint="historyID is not required">
		<!--- Single Person Placement --->
        <cfargument name="doc_single_place_auth" default="" hint="doc_single_place_auth is not required">
        <cfargument name="compliance_single_place_auth" default="" hint="compliance_single_place_auth is not required">
        <cfargument name="doc_single_parents_sign_date" default="" hint="doc_single_parents_sign_date is not required">
        <cfargument name="compliance_single_parents_sign_date" default="" hint="compliance_single_parents_sign_date is not required">
        <cfargument name="doc_single_student_sign_date" default="" hint="doc_single_student_sign_date is not required">
        <cfargument name="compliance_single_student_sign_date" default="" hint="compliance_single_student_sign_date is not required">
        <cfargument name="doc_single_ref_form_1" default="" hint="doc_single_ref_form_1 is not required">
        <cfargument name="compliance_single_ref_form_1" default="" hint="compliance_single_ref_form_1 is not required">
        <cfargument name="doc_single_ref_check1" default="" hint="doc_single_ref_check1 is not required">
        <cfargument name="compliance_single_ref_check1" default="" hint="compliance_single_ref_check1 is not required">
        <cfargument name="doc_single_ref_form_2" default="" hint="doc_single_ref_form_2 is not required">
        <cfargument name="compliance_single_ref_form_2" default="" hint="compliance_single_ref_form_2 is not required">
        <cfargument name="doc_single_ref_check2" default="" hint="doc_single_ref_check2 is not required">
        <cfargument name="compliance_single_ref_check2" default="" hint="compliance_single_ref_check2 is not required">
        <!--- Placement Paperwork --->
        <cfargument name="datePlaced" default="" hint="datePlaced is not required">
        <cfargument name="previousDatePlaced" default="" hint="previousDatePlaced is not required">
        <cfargument name="dateRelocated" default="" hint="dateRelocated is not required">
        <!--- Page 1 --->
        <cfargument name="doc_host_app_page1_date" default="" hint="doc_host_app_page1_date is not required">
        <cfargument name="compliance_host_app_page1_date" default="" hint="compliance_host_app_page1_date is not required">
        <!--- Page 2 --->
        <cfargument name="doc_host_app_page2_date" default="" hint="doc_host_app_page2_date is not required">
        <cfargument name="compliance_host_app_page2_date" default="" hint="compliance_host_app_page2_date is not required">
        <!--- Page 3 - Letter --->
        <cfargument name="doc_letter_rec_date" default="" hint="doc_letter_rec_date is not required">
        <cfargument name="compliance_letter_rec_date" default="" hint="compliance_letter_rec_date is not required">
        <!--- Page 4,5,6 - Photos --->
        <cfargument name="doc_photos_rec_date" default="" hint="doc_photos_rec_date is not required">
        <cfargument name="compliance_photos_rec_date" default="" hint="compliance_photos_rec_date is not required">
        <cfargument name="doc_bedroom_photo" default="" hint="doc_bedroom_photo is not required">
        <cfargument name="compliance_bedroom_photo" default="" hint="compliance_bedroom_photo is not required">
        <cfargument name="doc_bathroom_photo" default="" hint="doc_bathroom_photo is not required">
        <cfargument name="compliance_bathroom_photo" default="" hint="compliance_bathroom_photo is not required">
        <cfargument name="doc_kitchen_photo" default="" hint="doc_kitchen_photo is not required">
        <cfargument name="compliance_kitchen_photo" default="" hint="compliance_kitchen_photo is not required">
        <cfargument name="doc_living_room_photo" default="" hint="doc_living_room_photo is not required">
        <cfargument name="compliance_living_room_photo" default="" hint="compliance_living_room_photo is not required">
        <cfargument name="doc_outside_photo" default="" hint="doc_outside_photo is not required">
        <cfargument name="compliance_outside_photo" default="" hint="compliance_outside_photo is not required">
        <!--- Page 7 - HF Rules --->
        <cfargument name="doc_rules_rec_date" default="" hint="doc_rules_rec_date is not required">
        <cfargument name="compliance_rules_rec_date" default="" hint="compliance_rules_rec_date is not required">
        <cfargument name="doc_rules_sign_date" default="" hint="doc_rules_sign_date is not required">
        <cfargument name="compliance_rules_sign_date" default="" hint="compliance_rules_sign_date is not required">
        <!--- Page 8 - School & Community Profile --->
        <cfargument name="doc_school_profile_rec" default="" hint="doc_school_profile_rec is not required">
        <cfargument name="compliance_school_profile_rec" default="" hint="compliance_school_profile_rec is not required">
        <!--- Page 9 - Income Verification --->
        <cfargument name="doc_income_ver_date" default="" hint="doc_income_ver_date is not required">
        <cfargument name="compliance_income_ver_date" default="" hint="compliance_income_ver_date is not required">
        <!--- Page 10 - Confidential HF Visit ---> 
        <cfargument name="doc_conf_host_rec" default="" hint="doc_conf_host_rec is not required">
        <cfargument name="compliance_conf_host_rec" default="" hint="compliance_conf_host_rec is not required">
        <cfargument name="doc_date_of_visit" default="" hint="doc_date_of_visit is not required">
        <cfargument name="compliance_date_of_visit" default="" hint="compliance_date_of_visit is not required">
        <!--- Page 11 - Reference 1 --->
        <cfargument name="doc_ref_form_1" default="" hint="doc_ref_form_1 is not required">
        <cfargument name="compliance_ref_form_1" default="" hint="compliance_ref_form_1 is not required">
        <cfargument name="doc_ref_check1" default="" hint="doc_ref_check1 is not required">
        <cfargument name="compliance_ref_check1" default="" hint="compliance_ref_check1 is not required">
        <!--- Page 12 - Reference 2 --->
        <cfargument name="doc_ref_form_2" default="" hint="doc_ref_form_2 is not required">
        <cfargument name="compliance_ref_form_2" default="" hint="compliance_ref_form_2 is not required">
        <cfargument name="doc_ref_check2" default="" hint="doc_ref_check2 is not required">
        <cfargument name="compliance_ref_check2" default="" hint="compliance_ref_check2 is not required">
        <!--- Arrival Compliance --->
        <cfargument name="doc_school_accept_date" default="" hint="doc_school_accept_date is not required">
        <cfargument name="compliance_school_accept_date" default="" hint="compliance_school_accept_date is not required">
        <cfargument name="doc_school_sign_date" default="" hint="doc_school_sign_date is not required">
        <cfargument name="compliance_school_sign_date" default="" hint="compliance_school_sign_date is not required">
        <!--- Arrival Orientation --->
        <cfargument name="stu_arrival_orientation" default="" hint="stu_arrival_orientation is not required">
        <cfargument name="compliance_stu_arrival_orientation" default="" hint="compliance_stu_arrival_orientation is not required">
        <cfargument name="host_arrival_orientation" default="" hint="host_arrival_orientation is not required">
        <cfargument name="compliance_host_arrival_orientation" default="" hint="compliance_host_arrival_orientation is not required">
        <cfargument name="doc_class_schedule" default="" hint="doc_class_schedule is not required">    
        <cfargument name="compliance_class_schedule" default="" hint="compliance_class_schedule is not required">
		<cfargument name="compliance_review" default="" hint="compliance_review is not required">  
		
        <cfscript>
			// Check if placement date has changed
			if ( isDate(ARGUMENTS.previousDatePlaced) AND isDate(ARGUMENTS.datePlaced) AND ARGUMENTS.previousDatePlaced NEQ ARGUMENTS.datePlaced ) {
				// Update History Log
				updateDatePlaced(
					studentID=ARGUMENTS.studentID,
					historyID=ARGUMENTS.historyID,
					datePlaced=ARGUMENTS.datePlaced
				);
			}
		</cfscript>
        
        <!--- Update Host History Documents --->
        <cfquery 
			datasource="#APPLICATION.DSN#">
                UPDATE
	                smg_hosthistory
                SET 
					<!--- Single Person Placement Paperwork --->
                    doc_single_place_auth = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_single_place_auth#" null="#NOT IsDate(ARGUMENTS.doc_single_place_auth)#">,
                    compliance_single_place_auth = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.compliance_single_place_auth#" null="#NOT IsDate(ARGUMENTS.compliance_single_place_auth)#">,
                    doc_single_ref_form_1 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_single_ref_form_1#" null="#NOT IsDate(ARGUMENTS.doc_single_ref_form_1)#">,
                    compliance_single_ref_form_1 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.compliance_single_ref_form_1#" null="#NOT IsDate(ARGUMENTS.compliance_single_ref_form_1)#">,
                    doc_single_ref_check1 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_single_ref_check1#" null="#NOT IsDate(ARGUMENTS.doc_single_ref_check1)#">,
                    compliance_single_ref_check1 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.compliance_single_ref_check1#" null="#NOT IsDate(ARGUMENTS.compliance_single_ref_check1)#">,
                    doc_single_ref_form_2 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_single_ref_form_2#" null="#NOT IsDate(ARGUMENTS.doc_single_ref_form_2)#">,
                    compliance_single_ref_form_2 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.compliance_single_ref_form_2#" null="#NOT IsDate(ARGUMENTS.compliance_single_ref_form_2)#">,
                    doc_single_ref_check2 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_single_ref_check2#" null="#NOT IsDate(ARGUMENTS.doc_single_ref_check2)#">,
                    compliance_single_ref_check2 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.compliance_single_ref_check2#" null="#NOT IsDate(ARGUMENTS.compliance_single_ref_check2)#">,
                    doc_single_parents_sign_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_single_parents_sign_date#" null="#NOT IsDate(ARGUMENTS.doc_single_parents_sign_date)#">,
                    compliance_single_parents_sign_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.compliance_single_parents_sign_date#" null="#NOT IsDate(ARGUMENTS.compliance_single_parents_sign_date)#">,
                    doc_single_student_sign_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_single_student_sign_date#" null="#NOT IsDate(ARGUMENTS.doc_single_student_sign_date)#">,
                    compliance_single_student_sign_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.compliance_single_student_sign_date#" null="#NOT IsDate(ARGUMENTS.compliance_single_student_sign_date)#">,
                    <!--- Placement Paperwork --->
					datePlaced = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.datePlaced#" null="#NOT IsDate(ARGUMENTS.datePlaced)#">,
                    dateRelocated = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.dateRelocated#" null="#NOT IsDate(ARGUMENTS.dateRelocated)#">,
                    <!--- Page 1 --->
                    doc_host_app_page1_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_host_app_page1_date#" null="#NOT IsDate(ARGUMENTS.doc_host_app_page1_date)#">,
                    compliance_host_app_page1_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.compliance_host_app_page1_date#" null="#NOT IsDate(ARGUMENTS.compliance_host_app_page1_date)#">,
                    <!--- Page 2 --->
                    doc_host_app_page2_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_host_app_page2_date#" null="#NOT IsDate(ARGUMENTS.doc_host_app_page2_date)#">,
                    compliance_host_app_page2_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.compliance_host_app_page2_date#" null="#NOT IsDate(ARGUMENTS.compliance_host_app_page2_date)#">,
                    <!--- Page 3 - Letter --->
                    doc_letter_rec_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_letter_rec_date#" null="#NOT IsDate(ARGUMENTS.doc_letter_rec_date)#">,
                    compliance_letter_rec_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.compliance_letter_rec_date#" null="#NOT IsDate(ARGUMENTS.compliance_letter_rec_date)#">,
                    <!--- Page 4,5,6 - Photos --->
                    doc_photos_rec_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_photos_rec_date#" null="#NOT IsDate(ARGUMENTS.doc_photos_rec_date)#">,
                    compliance_photos_rec_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.compliance_photos_rec_date#" null="#NOT IsDate(ARGUMENTS.compliance_photos_rec_date)#">,
                    doc_bedroom_photo = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_bedroom_photo#" null="#NOT IsDate(ARGUMENTS.doc_bedroom_photo)#">,
                    compliance_bedroom_photo = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.compliance_bedroom_photo#" null="#NOT IsDate(ARGUMENTS.compliance_bedroom_photo)#">,
                    doc_bathroom_photo = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_bathroom_photo#" null="#NOT IsDate(ARGUMENTS.doc_bathroom_photo)#">,
                    compliance_bathroom_photo = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.compliance_bathroom_photo#" null="#NOT IsDate(ARGUMENTS.compliance_bathroom_photo)#">,
                    doc_kitchen_photo = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_kitchen_photo#" null="#NOT IsDate(ARGUMENTS.doc_kitchen_photo)#">,
                    compliance_kitchen_photo = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.compliance_kitchen_photo#" null="#NOT IsDate(ARGUMENTS.compliance_kitchen_photo)#">,
                    doc_living_room_photo = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_living_room_photo#" null="#NOT IsDate(ARGUMENTS.doc_living_room_photo)#">,
                    compliance_living_room_photo = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.compliance_living_room_photo#" null="#NOT IsDate(ARGUMENTS.compliance_living_room_photo)#">,
                    doc_outside_photo = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_outside_photo#" null="#NOT IsDate(ARGUMENTS.doc_outside_photo)#">,
                    compliance_outside_photo = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.compliance_outside_photo#" null="#NOT IsDate(ARGUMENTS.compliance_outside_photo)#">,                    
                    <!--- Page 7 - HF Rules --->
                    doc_rules_rec_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_rules_rec_date#" null="#NOT IsDate(ARGUMENTS.doc_rules_rec_date)#">,
                    compliance_rules_rec_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.compliance_rules_rec_date#" null="#NOT IsDate(ARGUMENTS.compliance_rules_rec_date)#">,
                    doc_rules_sign_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_rules_sign_date#" null="#NOT IsDate(ARGUMENTS.doc_rules_sign_date)#">,
                    compliance_rules_sign_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.compliance_rules_sign_date#" null="#NOT IsDate(ARGUMENTS.compliance_rules_sign_date)#">,
                    <!--- Page 8 - School & Community Profile --->
                    doc_school_profile_rec = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_school_profile_rec#" null="#NOT IsDate(ARGUMENTS.doc_school_profile_rec)#">,
                    compliance_school_profile_rec = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.compliance_school_profile_rec#" null="#NOT IsDate(ARGUMENTS.compliance_school_profile_rec)#">,
					<!--- Page 9 - Income Verification ---> 
                    doc_income_ver_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_income_ver_date#" null="#NOT IsDate(ARGUMENTS.doc_income_ver_date)#">,
                    compliance_income_ver_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.compliance_income_ver_date#" null="#NOT IsDate(ARGUMENTS.compliance_income_ver_date)#">,
					<!--- Page 10 - Confidential HF Visit --->
                    doc_conf_host_rec = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_conf_host_rec#" null="#NOT IsDate(ARGUMENTS.doc_conf_host_rec)#">,
                    compliance_conf_host_rec = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.compliance_conf_host_rec#" null="#NOT IsDate(ARGUMENTS.compliance_conf_host_rec)#">,
                    doc_date_of_visit = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_date_of_visit#" null="#NOT IsDate(ARGUMENTS.doc_date_of_visit)#">,
                    compliance_date_of_visit = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.compliance_date_of_visit#" null="#NOT IsDate(ARGUMENTS.compliance_date_of_visit)#">,
                    <!--- Page 11 - Reference 1 --->
                    doc_ref_form_1 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_ref_form_1#" null="#NOT IsDate(ARGUMENTS.doc_ref_form_1)#">,
                    compliance_ref_form_1 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.compliance_ref_form_1#" null="#NOT IsDate(ARGUMENTS.compliance_ref_form_1)#">,
                    doc_ref_check1 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_ref_check1#" null="#NOT IsDate(ARGUMENTS.doc_ref_check1)#">,
                    compliance_ref_check1 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.compliance_ref_check1#" null="#NOT IsDate(ARGUMENTS.compliance_ref_check1)#">,
                    <!--- Page 12 - Reference 2 ---> 
                    doc_ref_form_2 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_ref_form_2#" null="#NOT IsDate(ARGUMENTS.doc_ref_form_2)#">,
                    compliance_ref_form_2 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.compliance_ref_form_2#" null="#NOT IsDate(ARGUMENTS.compliance_ref_form_2)#">,
                    doc_ref_check2 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_ref_check2#" null="#NOT IsDate(ARGUMENTS.doc_ref_check2)#">,
                    compliance_ref_check2 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.compliance_ref_check2#" null="#NOT IsDate(ARGUMENTS.compliance_ref_check2)#">,
                    <!--- Arrival Compliance --->
                    doc_school_accept_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_school_accept_date#" null="#NOT IsDate(ARGUMENTS.doc_school_accept_date)#">,
                    compliance_school_accept_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.compliance_school_accept_date#" null="#NOT IsDate(ARGUMENTS.compliance_school_accept_date)#">,
                    doc_school_sign_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_school_sign_date#" null="#NOT IsDate(ARGUMENTS.doc_school_sign_date)#">,
                    compliance_school_sign_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.compliance_school_sign_date#" null="#NOT IsDate(ARGUMENTS.compliance_school_sign_date)#">,
					<!--- Compliance Review --->
					compliance_review = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.compliance_review#" null="#NOT IsDate(ARGUMENTS.compliance_review)#">,
					<!--- Arrival Orientation --->
                    stu_arrival_orientation = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.stu_arrival_orientation#" null="#NOT IsDate(ARGUMENTS.stu_arrival_orientation)#">,
                    compliance_stu_arrival_orientation = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.compliance_stu_arrival_orientation#" null="#NOT IsDate(ARGUMENTS.compliance_stu_arrival_orientation)#">,
                    host_arrival_orientation = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.host_arrival_orientation#" null="#NOT IsDate(ARGUMENTS.host_arrival_orientation)#">,
                    compliance_host_arrival_orientation = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.compliance_host_arrival_orientation#" null="#NOT IsDate(ARGUMENTS.compliance_host_arrival_orientation)#">,
                    doc_class_schedule = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_class_schedule#" null="#NOT IsDate(ARGUMENTS.doc_class_schedule)#">,
                    compliance_class_schedule = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.compliance_class_schedule#" null="#NOT IsDate(ARGUMENTS.compliance_class_schedule)#">,
                    updatedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
                WHERE 
                    historyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.historyID)#"> 
                AND
                    studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">                    	
		</cfquery>
        
	</cffunction>
    
    
	<!--- Placement Paperwork - Update upon host family app approved or student is placed with an approved host family --->
	<cffunction name="updatePlacementPaperworkUponHostFamilyAppApproval" access="public" returntype="void" output="false" hint="Update Placement Paperwork">
        <cfargument name="historyID" default="0" hint="historyID is not required">
        <!--- Date Received --->
        <cfargument name="dateReceived" default="" hint="dateReceived is not required">
		<!--- Page 1 --->
        <cfargument name="doc_host_app_page1_date" default="" hint="doc_host_app_page1_date is not required">
        <!--- Page 2 --->
        <cfargument name="doc_host_app_page2_date" default="" hint="doc_host_app_page2_date is not required">
        <!--- Page 3 - Letter --->
        <cfargument name="doc_letter_rec_date" default="" hint="doc_letter_rec_date is not required">
        <!--- Page 4,5,6 - Photos --->
        <cfargument name="doc_photos_rec_date" default="" hint="doc_photos_rec_date is not required">
        <cfargument name="doc_bedroom_photo" default="" hint="doc_bedroom_photo is not required">
        <cfargument name="doc_bathroom_photo" default="" hint="doc_bathroom_photo is not required">
        <cfargument name="doc_kitchen_photo" default="" hint="doc_kitchen_photo is not required">
        <cfargument name="doc_living_room_photo" default="" hint="doc_living_room_photo is not required">
        <cfargument name="doc_outside_photo" default="" hint="doc_outside_photo is not required">
        <!--- Page 7 - HF Rules --->
        <cfargument name="doc_rules_rec_date" default="" hint="doc_rules_rec_date is not required">
        <cfargument name="doc_rules_sign_date" default="" hint="doc_rules_sign_date is not required">
        <!--- Page 8 - School & Community Profile --->
        <cfargument name="doc_school_profile_rec" default="" hint="doc_school_profile_rec is not required">
        <!--- Page 9 - Income Verification --->
        <cfargument name="doc_income_ver_date" default="" hint="doc_income_ver_date is not required">
        <!--- Page 10 - Confidential HF Visit ---> 
        <cfargument name="doc_conf_host_rec" default="" hint="doc_conf_host_rec is not required">
        <cfargument name="doc_date_of_visit" default="" hint="doc_date_of_visit is not required">
        <!--- Page 11 - Reference 1 --->
        <cfargument name="doc_ref_form_1" default="" hint="doc_ref_form_1 is not required">
        <cfargument name="doc_ref_check1" default="" hint="doc_ref_check1 is not required">
        <!--- Page 12 - Reference 2 --->
        <cfargument name="doc_ref_form_2" default="" hint="doc_ref_form_2 is not required">
        <cfargument name="doc_ref_check2" default="" hint="doc_ref_check2 is not required">
        
        <!--- Update Host History Documents --->
        <cfquery 
			datasource="#APPLICATION.DSN#">
                UPDATE
	                smg_hosthistory
                SET 
                	<!--- Date Received --->
                    dateReceived = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.dateReceived#" null="#NOT IsDate(ARGUMENTS.dateReceived)#">,
                    <!--- Page 1 --->
                    doc_host_app_page1_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_host_app_page1_date#" null="#NOT IsDate(ARGUMENTS.doc_host_app_page1_date)#">,
                    <!--- Page 2 --->
                    doc_host_app_page2_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_host_app_page2_date#" null="#NOT IsDate(ARGUMENTS.doc_host_app_page2_date)#">,
                    <!--- Page 3 - Letter --->
                    doc_letter_rec_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_letter_rec_date#" null="#NOT IsDate(ARGUMENTS.doc_letter_rec_date)#">,
                    <!--- Page 4,5,6 - Photos --->
                    doc_photos_rec_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_photos_rec_date#" null="#NOT IsDate(ARGUMENTS.doc_photos_rec_date)#">,
                    doc_bedroom_photo = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_bedroom_photo#" null="#NOT IsDate(ARGUMENTS.doc_bedroom_photo)#">,
                    doc_bathroom_photo = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_bathroom_photo#" null="#NOT IsDate(ARGUMENTS.doc_bathroom_photo)#">,
                    doc_kitchen_photo = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_kitchen_photo#" null="#NOT IsDate(ARGUMENTS.doc_kitchen_photo)#">,
                    doc_living_room_photo = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_living_room_photo#" null="#NOT IsDate(ARGUMENTS.doc_living_room_photo)#">,
                    doc_outside_photo = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_outside_photo#" null="#NOT IsDate(ARGUMENTS.doc_outside_photo)#">,
                    <!--- Page 7 - HF Rules --->
                    doc_rules_rec_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_rules_rec_date#" null="#NOT IsDate(ARGUMENTS.doc_rules_rec_date)#">,
                    doc_rules_sign_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_rules_sign_date#" null="#NOT IsDate(ARGUMENTS.doc_rules_sign_date)#">,
                    <!--- Page 8 - School & Community Profile --->
                    doc_school_profile_rec = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_school_profile_rec#" null="#NOT IsDate(ARGUMENTS.doc_school_profile_rec)#">,
					<!--- Page 9 - Income Verification ---> 
                    doc_income_ver_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_income_ver_date#" null="#NOT IsDate(ARGUMENTS.doc_income_ver_date)#">,
					<!--- Page 10 - Confidential HF Visit --->
                    doc_conf_host_rec = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_conf_host_rec#" null="#NOT IsDate(ARGUMENTS.doc_conf_host_rec)#">,
                    doc_date_of_visit = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_date_of_visit#" null="#NOT IsDate(ARGUMENTS.doc_date_of_visit)#">,
                    <!--- Page 11 - Reference 1 --->
                    doc_ref_form_1 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_ref_form_1#" null="#NOT IsDate(ARGUMENTS.doc_ref_form_1)#">,
                    doc_ref_check1 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_ref_check1#" null="#NOT IsDate(ARGUMENTS.doc_ref_check1)#">,
                    <!--- Page 12 - Reference 2 ---> 
                    doc_ref_form_2 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_ref_form_2#" null="#NOT IsDate(ARGUMENTS.doc_ref_form_2)#">,
                    doc_ref_check2 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_ref_check2#" null="#NOT IsDate(ARGUMENTS.doc_ref_check2)#">,
                    updatedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
                WHERE 
                    historyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.historyID)#">                                	
		</cfquery>
        
	</cffunction>    


	<cffunction name="checkPlacementPaperwork" access="public" returntype="string" output="false" hint="Check if placement paperwork was received by deadline">
        <cfargument name="studentID" default="0" hint="studentID is not required">
		<cfargument name="paymentTypeID" default="0" hint="Payment Type ID">
			
        <cfquery 
			name="qCheckPlacementPaperwork" 
			datasource="#APPLICATION.DSN#">
                SELECT 
                    s.studentID,
                    sh.hostID,
                    <!--- Single Person Placement Paperwork --->
                    sh.doc_single_place_auth,
                    sh.doc_single_ref_form_1,
                    sh.doc_single_ref_check1,
                    sh.doc_single_ref_form_2,
                    sh.doc_single_ref_check2,
                    sh.doc_single_parents_sign_date,
                    sh.doc_single_student_sign_date,
                    <!--- Page 1 --->
                    sh.doc_host_app_page1_date,
                    <!--- Page 2 --->
                    sh.doc_host_app_page2_date,
                    <!--- Page 3 - Letter --->
                    sh.doc_letter_rec_date,
                    <!--- Page 4,5,6 - Photos --->
                    sh.doc_photos_rec_date,
                    sh.doc_bedroom_photo,
                    sh.doc_bathroom_photo,
                    sh.doc_kitchen_photo,
                    sh.doc_living_room_photo,
                    sh.doc_outside_photo,
                    <!--- Page 7 - HF Rules --->
                    sh.doc_rules_rec_date,
                    sh.doc_rules_sign_date,
                    <!--- Page 8 - School & Community Profile --->
                    sh.doc_school_profile_rec,
                    <!--- Page 9 - Income Verification ---> 
                    sh.doc_income_ver_date,
                    <!--- Page 10 - Confidential HF Visit --->
                    sh.doc_conf_host_rec,
                    sh.doc_date_of_visit,
                    <!--- Page 11 - Reference 1 ---> 
                    sh.doc_ref_form_1,
                    sh.doc_ref_check1,
                    <!--- Page 12 - Reference 2 --->
                    sh.doc_ref_form_2,
                    sh.doc_ref_check2,
                    <!--- Arrival Compliance --->
                    sh.doc_school_accept_date,
                    sh.doc_school_sign_date
                FROM 
                	smg_students s
                INNER JOIN
                	smg_hosthistory sh ON sh.studentID = s.studentID
                AND
                	sh.isActive = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                AND
                	sh.hostID != <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                WHERE 
                    s.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">                    	
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
				qGetHostInfo = APPLICATION.CFC.HOST.getHosts(hostID=qCheckPlacementPaperwork.hostID);
	
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

				// Host Family Application p.1
				if ( NOT isDate(qCheckPlacementPaperwork.doc_host_app_page1_date) OR qCheckPlacementPaperwork.doc_host_app_page1_date GT setDeadline ) {
					returnMessage = returnMessage & 'Host Family Application p.1 has not been received or received after deadline - Date Received: #DateFormat(qCheckPlacementPaperwork.doc_host_app_page1_date, 'mm/dd/yyyy')#. <br />'; 	
				}

				// Host Family Application p.2
				if ( NOT isDate(qCheckPlacementPaperwork.doc_host_app_page2_date) OR qCheckPlacementPaperwork.doc_host_app_page2_date GT setDeadline ) {
					returnMessage = returnMessage & 'Host Family Application p.2 has not been received or received after deadline - Date Received: #DateFormat(qCheckPlacementPaperwork.doc_host_app_page2_date, 'mm/dd/yyyy')#. <br />'; 	
				}

				// Host Family Letter Received
				if ( NOT isDate(qCheckPlacementPaperwork.doc_letter_rec_date) OR qCheckPlacementPaperwork.doc_letter_rec_date GT setDeadline ) {
					returnMessage = returnMessage & 'Host Family Letter p.3 has not been received or received after deadline - Date Received: #DateFormat(qCheckPlacementPaperwork.doc_letter_rec_date, 'mm/dd/yyyy')#. <br />'; 	
				}

				// Host Family Rules Form
				if ( NOT isDate(qCheckPlacementPaperwork.doc_rules_rec_date) OR qCheckPlacementPaperwork.doc_rules_rec_date GT setDeadline ) {
					returnMessage = returnMessage & 'Host Family Rules Form has not been received or received after deadline - Date Received: #DateFormat(qCheckPlacementPaperwork.doc_rules_rec_date, 'mm/dd/yyyy')#. <br />'; 	
				}

				// Host Family Photos
				if ( NOT isDate(qCheckPlacementPaperwork.doc_photos_rec_date) OR qCheckPlacementPaperwork.doc_photos_rec_date GT setDeadline ) {
					returnMessage = returnMessage & 'Host Family Photo has not been received or received after deadline - Date Received: #DateFormat(qCheckPlacementPaperwork.doc_photos_rec_date, 'mm/dd/yyyy')#. <br />'; 	
				}

				// Host Family - Student Bedroom Photo
				if ( NOT isDate(qCheckPlacementPaperwork.doc_bedroom_photo) OR qCheckPlacementPaperwork.doc_bedroom_photo GT setDeadline ) {
					returnMessage = returnMessage & 'Host Family - Student Bedroom Photo has not been received or received after deadline - Date Received: #DateFormat(qCheckPlacementPaperwork.doc_bedroom_photo, 'mm/dd/yyyy')#. <br />'; 	
				}

				// Host Family - Student Bathroom Photo
				if ( NOT isDate(qCheckPlacementPaperwork.doc_bathroom_photo) OR qCheckPlacementPaperwork.doc_bathroom_photo GT setDeadline ) {
					returnMessage = returnMessage & 'Host Family - Student Bathroom Photo has not been received or received after deadline - Date Received: #DateFormat(qCheckPlacementPaperwork.doc_bathroom_photo, 'mm/dd/yyyy')#. <br />'; 	
				}

				// Host Family Kitchen Photo
				if ( NOT isDate(qCheckPlacementPaperwork.doc_kitchen_photo) OR qCheckPlacementPaperwork.doc_kitchen_photo GT setDeadline ) {
					returnMessage = returnMessage & 'Host Family Kitchen Photo has not been received or received after deadline - Date Received: #DateFormat(qCheckPlacementPaperwork.doc_kitchen_photo, 'mm/dd/yyyy')#. <br />'; 	
				}

				// Host Family Living Room Photo
				if ( NOT isDate(qCheckPlacementPaperwork.doc_living_room_photo) OR qCheckPlacementPaperwork.doc_living_room_photo GT setDeadline ) {
					returnMessage = returnMessage & 'Host Family Living Room Photo has not been received or received after deadline - Date Received: #DateFormat(qCheckPlacementPaperwork.doc_living_room_photo, 'mm/dd/yyyy')#. <br />'; 	
				}

				// Host Family Outside Photo
				if ( NOT isDate(qCheckPlacementPaperwork.doc_outside_photo) OR qCheckPlacementPaperwork.doc_outside_photo GT setDeadline ) {
					returnMessage = returnMessage & 'Host Family Outside Photo has not been received or received after deadline - Date Received: #DateFormat(qCheckPlacementPaperwork.doc_outside_photo, 'mm/dd/yyyy')#. <br />'; 	
				}

				// School & Community Profile Form
				if ( NOT isDate(qCheckPlacementPaperwork.doc_school_profile_rec) OR qCheckPlacementPaperwork.doc_school_profile_rec GT setDeadline ) {
					returnMessage = returnMessage & 'School & Community Profile Form has not been received or received after deadline - Date Received: #DateFormat(qCheckPlacementPaperwork.doc_school_profile_rec, 'mm/dd/yyyy')#. <br />'; 	
				}

				// Confidential Host Family Visit Form
				if ( NOT isDate(qCheckPlacementPaperwork.doc_conf_host_rec) OR qCheckPlacementPaperwork.doc_conf_host_rec GT setDeadline ) {
					returnMessage = returnMessage & 'Confidential Host Family Visit Form has not been received or received after deadline - Date Received: #DateFormat(qCheckPlacementPaperwork.doc_conf_host_rec, 'mm/dd/yyyy')#. <br />'; 	
				}

				// Reference Form 1
				if ( NOT isDate(qCheckPlacementPaperwork.doc_ref_form_1) OR qCheckPlacementPaperwork.doc_ref_form_1 GT setDeadline ) {
					returnMessage = returnMessage & 'Reference Form 1 has not been received or received after deadline - Date Received: #DateFormat(qCheckPlacementPaperwork.doc_ref_form_1, 'mm/dd/yyyy')#. <br />'; 	
				}
				
				// Reference Form 2
				if ( NOT isDate(qCheckPlacementPaperwork.doc_ref_form_2) OR qCheckPlacementPaperwork.doc_ref_form_2 GT setDeadline ) {
					returnMessage = returnMessage & 'Reference Form 2 has not been received or received after deadline - Date Received: #DateFormat(qCheckPlacementPaperwork.doc_ref_form_2, 'mm/dd/yyyy')#. <br />'; 	
				}
				
				// Income Verification Form
				if ( NOT isDate(qCheckPlacementPaperwork.doc_income_ver_date) OR qCheckPlacementPaperwork.doc_income_ver_date GT setDeadline ) {
					returnMessage = returnMessage & 'Income Verification Form has not been received or received after deadline - Date Received: #DateFormat(qCheckPlacementPaperwork.doc_income_ver_date, 'mm/dd/yyyy')#. <br />'; 	
				}
				
				// School Acceptance Form
				if ( NOT isDate(qCheckPlacementPaperwork.doc_school_accept_date) OR qCheckPlacementPaperwork.doc_school_accept_date GT setDeadline ) {
					returnMessage = returnMessage & 'School Acceptance Form has not been received or received after deadline - Date Received: #DateFormat(qCheckPlacementPaperwork.doc_school_accept_date, 'mm/dd/yyyy')#. <br />'; 	
				}
				
				// 2nd Confidential Host Family Visit Form
				/*
				if ( NOT LEN(qCheckPlacementPaperwork.doc_conf_host_rec2) OR qCheckPlacementPaperwork.doc_conf_host_rec2 GT setDeadline ) {
					returnMessage = returnMessage & '2nd Confidential Host Family Visit Form has not been received or received after deadline - Date Received: #DateFormat(qCheckPlacementPaperwork.doc_conf_host_rec2, 'mm/dd/yyyy')#. <br />'; 	
				}
				*/
				
				// Non-Traditional Placement - Extra Documents
				if ( totalFamilyMembers EQ 1 ) {

					// Single Person Placement Verification
					if ( NOT isDate(qCheckPlacementPaperwork.doc_single_place_auth) OR qCheckPlacementPaperwork.doc_single_place_auth GT setDeadline ) {
						returnMessage = returnMessage & 'Single Person Placement Verification has not been received or received after deadline - Date Received: #DateFormat(qCheckPlacementPaperwork.doc_single_place_auth, 'mm/dd/yyyy')#. <br />'; 	
					}

					// Single Person Placement Reference 1
					if ( NOT isDate(qCheckPlacementPaperwork.doc_single_ref_form_1) OR qCheckPlacementPaperwork.doc_single_ref_form_1 GT setDeadline ) {
						returnMessage = returnMessage & 'Single Person Placement Reference 1 has not been received or received after deadline - Date Received: #DateFormat(qCheckPlacementPaperwork.doc_single_ref_form_1, 'mm/dd/yyyy')#. <br />'; 	
					}

					// Single Person Placement Reference 2
					if ( NOT isDate(qCheckPlacementPaperwork.doc_single_ref_form_2) OR qCheckPlacementPaperwork.doc_single_ref_form_2 GT setDeadline ) {
						returnMessage = returnMessage & 'Single Person Placement Reference 2 has not been received or received after deadline - Date Received: #DateFormat(qCheckPlacementPaperwork.doc_single_ref_form_2, 'mm/dd/yyyy')#. <br />'; 	
					}
					
				} // Non-Traditional Placement - Extra Documents

			} // Check if we have a deadline
			
			return returnMessage;
		</cfscript>
        
	</cffunction>


	<!--- Double Placement - Check Primary Language Spoken --->
	<cffunction name="checkDoublePlacementCompliant" access="public" returntype="string" output="false" hint="Double placement is compliant by not having two students that speak the same language">
    	<cfargument name="studentID" hint="studentID is required">
        <cfargument name="doublePlacementID" hint="doublePlacementID is required">
		
        <cfscript>
			// Set Local Variables
			var vReturnMessage = "";
			
			// Get Student Spoken Languages from Student Applicaton (page 3)
			qGetStudentSpokenLanguages = getStudentSpokenLanguages(studentID=ARGUMENTS.studentID, isPrimary=1);
			
			// Query did not return results, Get Student Spoken Languages Based on Country
			if ( NOT VAL(qGetStudentSpokenLanguages.recordCount) ) {
				// Get Student Primary Language Based By Country
				qGetStudentSpokenLanguages = getStudentPrimaryLanguageBasedOnCountry(studentID=ARGUMENTS.studentID);
			}
			
			vStudentPrimaryLanguageIDList = ValueList(qGetStudentSpokenLanguages.languageID);
		</cfscript>
        
        <cfif LEN(vStudentPrimaryLanguageIDList)>
        
            <cfquery name="qCheckDoublePlacementPrimaryLanguage" datasource="#APPLICATION.DSN#">
   				SELECT *
				FROM smg_student_app_language
                INNER JOIN applicationlookup on applicationlookup.fieldID = smg_student_app_language.languageID
                	AND fieldKey = "language"
				WHERE isPrimary = 1
                AND studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.doublePlacementID)#">
				AND languageID IN ( <cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#vStudentPrimaryLanguageIDList#"> )                                
            </cfquery> 
		
        	<cfscript>
				// Check if students speak the same language, if it does set as not compliant
				if ( qCheckDoublePlacementPrimaryLanguage.recordCount) {
					vReturnMessage = "<p>Double Placement Non Compliant - It seems both students speak the same language, #qCheckDoublePlacementPrimaryLanguage.name# #ARGUMENTS.doublePlacementID#</p>";
				}
			</cfscript>
        
        </cfif>
        
        <cfscript>
			return vReturnMessage;
		</cfscript>
	</cffunction>
    

	<!--- Primary Language --->
	<cffunction name="getStudentPrimaryLanguageBasedOnCountry" access="public" returntype="query" output="false" hint="Gets the student primary language">
    	<cfargument name="studentID" hint="studentID is required">
        
        <cfquery 
        	name="qGetStudentPrimaryLanguageBasedOnCountry"
        	datasource="#APPLICATION.DSN#">
                SELECT 
                    cljn.countryID,
                    cljn.languageID,
                    alu.name
				FROM
                	smg_countrylanguagejn cljn
                INNER JOIN
					applicationlookup alu ON alu.fieldID = cljn.languageID
                    	AND
                        	fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="language">
                INNER JOIN	
                     smg_students s ON cljn.countryID = s.countryResident
                     AND
                     	s.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">                
        </cfquery> 
		
        <cfscript>
			return qGetStudentPrimaryLanguageBasedOnCountry;
		</cfscript>
	</cffunction>
    

    <!--- START OF PLACEMENT MANAGEMENT FUNCTIONS --->
	<cffunction name="assignEnglishCamp" access="public" returntype="void" hint="Sets Pre-AYP english camp based on host family state">
        <cfargument name="studentID" required="yes" hint="studentID is required">
		
        <cfscript>
			var setEnglishCampID = 0;
			/*
				19 - MacDuffie, MA
				20 - NorthRidge, CA
			*/
			
			// Get Student Information
			var qGetStudentInformation = getStudentByID(studentID=ARGUMENTS.studentID);
			
			// Get Host Family Information
			var qGetHostInformation = APPLICATION.CFC.HOST.getHosts(hostID=qGetStudentInformation.hostID);
			
			// Student is Pre-AYP, not assigned to a camp and we have a valid host
			if ( VAL(qGetStudentInformation.aypEnglish) AND NOT ListFind("19,20", qGetStudentInformation.aypEnglish) AND qGetHostInformation.recordCount EQ 1) {
			
				// Get Camp Based on Host Family State Address
				if ( ListFind(APPLICATION.CONSTANTS.aypStateList.mcDuffie, qGetHostInformation.state) ) {
					// 19 - MacDuffie, MA
					setEnglishCampID = 19;
				} else if ( ListFind(APPLICATION.CONSTANTS.aypStateList.northRidge, qGetHostInformation.state) )  {
					// 20 - NorthRidge, CA
					setEnglishCampID = 20;
				}
				
			}
		</cfscript>
        
        <cfif VAL(setEnglishCampID)>
            
            <!--- Update Camp --->
            <cfquery 
                datasource="#APPLICATION.DSN#">
                    UPDATE
                        smg_students
                    SET
                        aypEnglish = <cfqueryparam cfsqltype="cf_sql_integer" value="#setEnglishCampID#">
                    WHERE
                        studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">
            </cfquery>
		
        </cfif>
        		   
	</cffunction>

	<!--- ------------------------------------------------------------------------- ----
		
		End of Placement Management
	
	----- ------------------------------------------------------------------------- --->


	<!--- ------------------------------------------------------------------------- ----
		Start of Remote Functions 
	----- ------------------------------------------------------------------------- --->
    <cffunction name="remoteLookUpStudent" access="remote" returnFormat="json" output="false" hint="Remote function to get students, returns an array">
        <cfargument name="searchString" type="string" default="" hint="Search is not required">
        <cfargument name="maxRows" type="numeric" required="false" default="30" hint="Max Rows is not required" />
        <cfargument name="companyID" default="#CLIENT.companyID#" hint="CompanyID is not required">
        
        <cfscript>
			var vReturnArray = arrayNew(1);
		</cfscript>
        
        <cfquery 
			name="qRemoteLookUpStudent" 
			datasource="#APPLICATION.dsn#">
                SELECT 
                	studentID,
					CAST( CONCAT(familyLastName, ', ', firstName, ' (##', studentID, ')' ) AS CHAR) AS displayName
                FROM 
                	smg_students
                WHERE 
                    app_current_status = <cfqueryparam cfsqltype="cf_sql_integer" value="11">                

				<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, ARGUMENTS.companyID)>
                    AND          
                        companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
                <cfelseif VAL(ARGUMENTS.companyID)>
                    AND          
                        companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
                </cfif>

				<cfif IsNumeric(ARGUMENTS.searchString)>
                    AND
                    	studentID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.searchString#%">
                <cfelse>
                    AND 
                    	(
                        	familyLastName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.searchString#%">
	                    OR
    	                	firstName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.searchString#%">
        				)
                </cfif>				
				
                ORDER BY 
                    familyLastName,
                    firstName

				LIMIT 
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.maxRows#" />                 
        </cfquery>

		<cfscript>
			// Loop through query
            For ( i=1; i LTE qRemoteLookUpStudent.recordCount; i=i+1 ) {

				vStudentStruct = structNew();
				vStudentStruct.studentID = qRemoteLookUpStudent.studentID[i];
				vStudentStruct.displayName = qRemoteLookUpStudent.displayName[i];
				
				ArrayAppend(vReturnArray,vStudentStruct);
            }
			
			return vReturnArray;
        </cfscript>

    </cffunction>       

    
	<cffunction name="deletePlacementHistoryRemote" access="remote" returntype="void" output="false" hint="Deletes a placement history">
        <cfargument name="historyID" type="any" hint="historyID is not required">
		
        <cfif VAL(ARGUMENTS.historyID)>
        	
            <!--- applicationHistory --->
            <cfquery 
                datasource="#APPLICATION.dsn#">
                    DELETE FROM
                        applicationhistory
                    WHERE
                    	foreignTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="smg_hosthistory">
                    AND                  
                        foreignID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.historyID#">
            </cfquery>
            
            <!--- smg_hosthistoryTracking --->  
            <cfquery 
                datasource="#APPLICATION.dsn#">
                    DELETE FROM
                        smg_hosthistorytracking
                    WHERE
                        historyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.historyID#">
            </cfquery>
            
            <!--- smg_hosthistory --->
            <cfquery 
                datasource="#APPLICATION.dsn#">
                    DELETE FROM
                        smg_hosthistory
                    WHERE
                        historyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.historyID#">
            </cfquery>
        
        </cfif>
        
	</cffunction>
    
    <cffunction name="unblockFlights" access="remote" returntype="void" output="false" hint="blocks or unblocks flight information from being input early">
    	<cfargument name="studentID" type="numeric" required="yes">
        <cfargument name="unblockFlight" type="numeric" required="yes">
        
        <cfquery datasource="#APPLICATION.DSN#">
        	UPDATE smg_students
            SET unblockFlight = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(ARGUMENTS.unblockFlight)#">
            WHERE studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">
        </cfquery>
    </cffunction>
    
	<!--- ------------------------------------------------------------------------- ----
		End of Remote Functions 
	----- ------------------------------------------------------------------------- --->


	<!--- ------------------------------------------------------------------------- ----
		
		DS-2019 Verification List
	
	----- ------------------------------------------------------------------------- --->
    
	<cffunction name="getVerificationList" access="remote" returnFormat="json" output="false" hint="Returns verification report list in Json format">
    	<cfargument name="intRep" default="0" hint="International Representative is not required">
        <cfargument name="branchID" default="0" hint="Branch is not required">
        <cfargument name="receivedDate" default="" hint="Filter by verification received date">

        <cfquery 
			name="qGetVerificationList" 
			datasource="#APPLICATION.DSN#">
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
                	smg_programs p ON p.programID = s.programID AND p.startDate < ADDDATE(now(), INTERVAL 183 DAY) <!--- Get only programs that are starting 183 days from now --->
                LEFT OUTER JOIN
                	smg_countrylist birth ON birth.countryID = s.countryBirth
				LEFT OUTER JOIN
                	smg_countrylist citizen ON citizen.countryID = s.countryCitizen
				LEFT OUTER JOIN
                	smg_countrylist resident ON resident.countryID = s.countryResident
                WHERE
                	s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
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
                        s.companyid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
                <cfelse>
                    AND          
                        s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#"> 
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
			datasource="#APPLICATION.DSN#">
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


	<cffunction name="updateRemoteStudentByID" access="remote" returntype="void" hint="Updates a student record. DS2019 Verification">
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
			datasource="#APPLICATION.DSN#">
                UPDATE
					smg_students
				SET
                    firstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.firstName)#" maxlength="150">,
                    middleName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.middleName)#" maxlength="150">,
                    familyLastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.familyLastName)#" maxlength="150">,
                    sex = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.sex)#">,
                    dob = <cfqueryparam cfsqltype="cf_sql_date" value="#TRIM(ARGUMENTS.dob)#">,
                    cityBirth = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.cityBirth)#">,
                    countryBirth = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.countryBirth)#">,
                    countryCitizen = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.countryCitizen)#">,
                    countryResident = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.countryResident)#">
                WHERE
                    studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">
		</cfquery>
		   
	</cffunction>
	<!--- End of Remote Functions --->

	<cffunction name="confirmVerificationReceived" access="remote" returntype="void" hint="Sets verification_received field as received.">
        <cfargument name="studentID" required="yes" hint="studentID is required">

        <cfquery 
			datasource="#APPLICATION.DSN#">
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
        <cfargument name="flightType" hint="PreAypArrival/Arrival/Departure is required">
        <cfargument name="programID" default="" hint="programID is not required">
        <cfargument name="flightLegOption" default="" hint="firstLeg/lastLeg to get first or last leg of the flight">
        
        <cfquery 
			name="qGetFlightInformation" 
			datasource="#APPLICATION.DSN#">
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
                    studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#"> 
                
				<cfif ListLen(ARGUMENTS.flightType) GT 1>
                    AND 
                        flight_type IN ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.flightType#" list="yes"> )
                <cfelse>
                    AND 
                        flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.flightType#">
                </cfif>

				AND
                	isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                    
				<cfif LEN(ARGUMENTS.programID)>
                    AND 
                        programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.programID)#">
                </cfif> 
				
                <cfswitch expression="#ARGUMENTS.flightLegOption#">
                
                	<cfcase value="firstLeg">
                        ORDER BY 
                            dep_date ASC,
                            dep_time ASC
						LIMIT 1                            
                    </cfcase>

                	<cfcase value="lastLeg">
                        ORDER BY 
                            dep_date DESC,
                            dep_time DESC
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
			datasource="#APPLICATION.DSN#">
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
			datasource="#APPLICATION.DSN#">
                UPDATE 
                    smg_students
                SET 
                    flight_info_notes = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.flightNotes#">
                WHERE 
                    studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">
                LIMIT 1
        </cfquery> 

	</cffunction>


	<cffunction name="isFlightInformationComplete" access="public" returntype="numeric" output="false" hint="Returns 1 if flight is complete">
        <cfargument name="depDate" default="" hint="Departure is not required">
        <cfargument name="depAirCode" default="" hint="depAirCode is not required">
        <cfargument name="arrivalAirCode" default="" hint="arrivalAirCode is not required">
        <cfargument name="flightNumber" default="" hint="flightNumber is not required">
        <cfargument name="arrivalTime" default="" hint="arrivalTime is not required">

        <cfscript>
			var isCompleted = 1;
			
			// Check if Flight Info is Complete, these fields are required to get a complete flight information
			if ( NOT IsDate(ARGUMENTS.depDate) OR NOT LEN(ARGUMENTS.depAirCode) OR NOT LEN(ARGUMENTS.arrivalAirCode) OR NOT LEN(ARGUMENTS.flightNumber) OR NOT LEN(ARGUMENTS.arrivalTime) ) {
				isCompleted = 0;
			}
			
			return isCompleted;
		</cfscript>

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
			var isCompleted = isFlightInformationComplete(
				depDate=ARGUMENTS.depDate,
				depAirCode=ARGUMENTS.depAirCode,
				arrivalAirCode=ARGUMENTS.arrivalAirCode,
				flightNumber=ARGUMENTS.flightNumber,
				arrivalTime=ARGUMENTS.arrivalTime
			);
		</cfscript>

        <cfquery 
			datasource="#APPLICATION.DSN#">
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
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(ARGUMENTS.depCity)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.depAirCode#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.depDate#" null="#NOT IsDate(ARGUMENTS.depDate)#">,
                    <cfqueryparam cfsqltype="cf_sql_time" value="#ARGUMENTS.depTime#" null="#NOT IsDate(ARGUMENTS.depTime)#">, 
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(ARGUMENTS.arrivalCity)#">,
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
			var isCompleted = isFlightInformationComplete(
				depDate=ARGUMENTS.depDate,
				depAirCode=ARGUMENTS.depAirCode,
				arrivalAirCode=ARGUMENTS.arrivalAirCode,
				flightNumber=ARGUMENTS.flightNumber,
				arrivalTime=ARGUMENTS.arrivalTime
			);
		</cfscript>
		
        <cfquery 
			datasource="#APPLICATION.DSN#">
                UPDATE
                    smg_flight_info
                SET 
                    companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">,
                    programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.programID#">,
                    enteredByID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.enteredByID#">,
                    flight_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.flightNumber#">,                 
                    dep_city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(ARGUMENTS.depCity)#">, 
                    dep_aircode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.depAirCode#">, 
                    dep_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.depDate#" null="#NOT IsDate(ARGUMENTS.depDate)#">,
                    dep_time = <cfqueryparam cfsqltype="cf_sql_time" value="#ARGUMENTS.depTime#" null="#NOT IsDate(ARGUMENTS.depTime)#">, 
                    arrival_city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.removeAccent(ARGUMENTS.arrivalCity)#">, 
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
        <cfargument name="enteredByID" default="0" hint="ID of user entering the flight information">
        <cfargument name="sendEmail" default="1" hint="Set to 0 to not send email notification">
		
        <cfquery 
			datasource="#APPLICATION.DSN#">
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
			if ( ListFind("8,11,13", CLIENT.userType) AND ARGUMENTS.sendEmail ) {
				emailFlightInformation(
					studentID=ARGUMENTS.studentID,
					flightID=ARGUMENTS.flightID
				);
			}
		</cfscript>
        
	</cffunction>
    

	<!--- DELETE COMPLETE FLIGHT INFORMATION --->
	<cffunction name="deleteCompleteFlightInformation" access="public" returntype="void" output="false" hint="Deletes Flight Information. Used in the XML tool for INTO">
        <cfargument name="studentID" hint="studentID is required">
        <cfargument name="programID" default="" hint="programID is required">
        <cfargument name="flightType" hint="Arrival/Departure is required">
        <cfargument name="enteredByID" default="0" hint="ID of user entering the flight information">
		
        <cfquery 
			datasource="#APPLICATION.DSN#">
                UPDATE
                    smg_flight_info
                SET
                    enteredByID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.enteredByID#">,
                    isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                WHERE 
                    studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">  
                AND	
                    flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.flightType#">   
                     
				<cfif LEN(ARGUMENTS.programID)>
                    AND	
                        programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.programID)#">    
                </cfif>  
                                          	         
        </cfquery>

	</cffunction>


    <!--- DISPLAY FLIGHT INFORMATION IN PDF FORMAT --->
	<cffunction name="printFlightInformation" access="public" returntype="string" output="false" hint="Returns a formatted flight information">
    	<cfargument name="studentID" default="" hint="studentID is not required">
        <cfargument name="uniqueID" default="" hint="uniqueID is not required">
        <cfargument name="programID" default="" hint="programID is not required">
        <cfargument name="flightID" default="0" hint="flightID is not required, pass flightID of a leg that has been deleted">
        <cfargument name="sendEmailTo" default="" hint="regionalManager | currentUser">
        <cfargument name="isPHPStudent" default="0" hint="Set to 1 if it's a PHP student">
       
   		<!--- Import CustomTag --->
		<cfimport taglib="../customTags/gui/" prefix="gui" />	

		<cfscript>
			var flightInfoReport = '';
			
			if ( NOT VAL(ARGUMENTS.isPHPStudent) ) {
				
				// Public - Get Student Information
				qGetStudentFullInformation = getStudentFullInformationByID(studentID=ARGUMENTS.studentID, uniqueID=ARGUMENTS.uniqueID, programID=ARGUMENTS.programID);
			
				// Get School Information
				qGetSchoolInfo = APPLICATION.CFC.SCHOOL.getSchoolByID(schoolID=qGetStudentFullInformation.schoolID);
				
				// Get School Dates
				qGetSchoolDates = APPLICATION.CFC.SCHOOL.getSchoolDates(schoolID=qGetStudentFullInformation.schoolID, programID=qGetStudentFullInformation.programID);
				
			} else {
				
				// PHP - Get Student Information
				qGetStudentFullInformation = getPHPStudent(studentID=ARGUMENTS.studentID, uniqueID=ARGUMENTS.uniqueID, programID=ARGUMENTS.programID);

				// PHP - Get School Information
				qGetSchoolInfo = APPLICATION.CFC.SCHOOL.getPHPSchoolByID(schoolID=qGetStudentFullInformation.schoolID);
				
				// PHP - Get School Dates
				qGetSchoolDates = APPLICATION.CFC.SCHOOL.getPHPSchoolDates(schoolID=qGetStudentFullInformation.schoolID, programID=qGetStudentFullInformation.programID);

			}
			
			// Path to save temp PDF files
			pdfPath = APPLICATION.PATH.temp & '##' & qGetStudentFullInformation.studentID & '-' & qGetStudentFullInformation.firstName & qGetStudentFullInformation.familyLastName & '-FlightInformation.pdf';
			// Remove Empty Spaces
			pdfPath = ReplaceNoCase(pdfPath, " ", "", "ALL");

			// Get Host Family Information
			qGetHostFamily = APPLICATION.CFC.HOST.getHosts(hostID=qGetStudentFullInformation.hostID);
			
            // Get Current User
            qGetCurrentUser = APPLICATION.CFC.USER.getUserByID(userID=CLIENT.userID);
            
            // Get Facilitator Email
            qGetFacilitator = APPLICATION.CFC.REGION.getRegionFacilitatorByRegionID(regionID=qGetStudentFullInformation.regionAssigned);
			
			// Get Regional Manager
			qGetRegionalManager = APPLICATION.CFC.USER.getRegionalManager(regionID=qGetStudentFullInformation.regionAssigned);
			
            // Get Specific Flight Information
            qGetDeletedFlightInfo = getFlightInformationByFlightID(flightID=VAL(ARGUMENTS.flightID));
            
            // Get Pre-AYP Arrival
            qGetPreAYPArrival = getFlightInformation(studentID=VAL(qGetStudentFullInformation.studentID), programID=ARGUMENTS.programID, flightType="PreAYPArrival");
    
            // Get Arrival
            qGetArrival = getFlightInformation(studentID=VAL(qGetStudentFullInformation.studentID), programID=ARGUMENTS.programID, flightType="arrival");
    
            // Get Departure
            qGetDeparture = getFlightInformation(studentID=VAL(qGetStudentFullInformation.studentID), programID=ARGUMENTS.programID, flightType="departure");
        </cfscript>
		
        <cfoutput>        
            
            <!--- Flight Report --->
            <cfsavecontent variable="flightInfoReport">
                
                <!--- Include Header --->
                <gui:pageHeader
                    headerType="pdf"
                    companyID="#qGetStudentFullInformation.companyID#"
                />
            
                <!--- Student Information --->
                <fieldset style="margin: 0px 0px 10px 0px; padding: 7px; border: ##DDD 1px solid; font-size:13px;">
                    
                    <legend style="color: ##333; font-weight: bold; padding-bottom:5px; text-transform:uppercase;">
                        Flight Information
                    </legend>
                    
                    <p style="color: ##333;">
                        We are pleased to give you the flight information for the student below. 
                        Please pass it to the host family information as soon as possible and in case of any doubt do not hesitate to contact us.
                    </p>
    
                    <table style="width: 100%; margin-bottom:5px; padding:0px; font-size:13px; line-height:13px;">	
                        <tr>
                            <td width="150px;" style="font-weight:bold; text-align:right; vertical-align:top;">Student:</td>
                            <td>#qGetStudentFullInformation.firstName# #qGetStudentFullInformation.familyLastName# (###qGetStudentFullInformation.studentID#)</td>
                        </tr>

                        <!--- Do Not Display for PHP --->
                        <cfif NOT VAL(ARGUMENTS.isPHPStudent)>
                            <tr>
                                <td style="font-weight:bold; text-align:right; vertical-align:top;">International Representative:</td>
                                <td>#qGetStudentFullInformation.intlRepBusinessName# (###qGetStudentFullInformation.intlRepUserID#)</td>
                            </tr>
                        </cfif>
                                                
                        <tr>
                            <td style="font-weight:bold; text-align:right; vertical-align:top;">Program:</td>
                            <td>#qGetStudentFullInformation.programName#</td>
                        </tr>
                        
                        <!--- Do Not Display for PHP --->
                        <cfif NOT VAL(ARGUMENTS.isPHPStudent)>
                            <tr>
                                <td style="font-weight:bold; text-align:right; vertical-align:top;">Region:</td>
                                <td>#qGetStudentFullInformation.regionName#</td>
                            </tr>
                            
                            <tr>
                                <td style="font-weight:bold; text-align:right; vertical-align:top;">Regional Manager:</td>
                                <td>
                                    #qGetRegionalManager.firstName# #qGetRegionalManager.lastName# (###qGetRegionalManager.userID#)
                                    - Email: <a href="mailto:#qGetRegionalManager.email#">#qGetRegionalManager.email#</a>
                                    <cfif LEN(qGetRegionalManager.work_phone)>
                                        - Phone: #qGetRegionalManager.work_phone#
                                    </cfif>
                                </td>
                            </tr>
                        </cfif>
                        
                        <tr>
                            <td style="font-weight:bold; text-align:right; vertical-align:top;">Area Representative:</td>
                            <td>
                                #qGetStudentFullInformation.areaRepFirstName# #qGetStudentFullInformation.areaRepLastName# (###qGetStudentFullInformation.areaRepUserID#)
                                - Email: <a href="mailto:#qGetStudentFullInformation.areaRepEmail#">#qGetStudentFullInformation.areaRepEmail#</a> 
                                <cfif LEN(qGetStudentFullInformation.areaRepPhone)>
                                    - Phone: #qGetStudentFullInformation.areaRepPhone#
                                </cfif>                                    
                            </td>
                        </tr>
                        
                        <tr>
                            <td style="font-weight:bold; text-align:right; vertical-align:top;">School:</td>
                            <td>#qGetSchoolInfo.schoolName# (###qGetSchoolInfo.schoolID#)</td>
                        </tr>
                        
                        <tr>
                            <td style="font-weight:bold; text-align:right; vertical-align:top;">Host Family:</td>
                            <td>
                                <cfif NOT VAL(qGetHostFamily.recordCount)>
                                    n/a
                                <cfelse>
                                
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
                                    <cfif qGetHostFamily.fatherLastName EQ qGetHostFamily.motherLastName>
                                        #qGetHostFamily.familyLastName#		
                                    </cfif>
                                    
                                    (###qGetHostFamily.hostID#) - Phone: #qGetHostFamily.phone# <br />
                                    
                                    <!--- Address --->
                                    #qGetHostFamily.address#, #qGetHostFamily.city#, #qGetHostFamily.state# #qGetHostFamily.zip#
                                </cfif>                                        
                            </td>
                        </tr>
    
                        <!--- Do Not Display for PHP --->
                        <cfif NOT VAL(ARGUMENTS.isPHPStudent)>
                            <tr>
                                <td style="font-weight:bold; text-align:right; vertical-align:top;">Arrival/Departure Airport::</td>
                                <td>
                                    <cfif LEN(qGetHostFamily.airport_city)>
                                        #qGetHostFamily.airport_city# 
                                    <cfelse> 
                                        n/a 
                                    </cfif>
                                    
                                    - Airport Code: 
                                    <cfif LEN(qGetHostFamily.major_air_code)>
                                        #qGetHostFamily.major_air_code# 
                                    <cfelse> 
                                        n/a 
                                    </cfif>
                                </td>
                            </tr>
                        
                        </cfif>
    
                        <!--- Updated By --->
                        <cfif ARGUMENTS.sendEmailTo NEQ 'regionalManager'>
                            <tr>
                                <td style="font-weight:bold; text-align:right; vertical-align:top;">Sent By:</td>
                                <td>
                                    #qGetCurrentUser.firstName# #qGetCurrentUser.lastName# (###qGetCurrentUser.userID#) 
                                    <cfif LEN(qGetCurrentUser.businessname)> - #qGetCurrentUser.businessname# </cfif>
                                </td>
                            </tr>
                        </cfif>
    
                        <tr>
                            <td style="font-weight:bold; text-align:right; vertical-align:top;">Today's Date:</td>
                            <td>#DateFormat(now(), 'mm/dd/yyyy')# at #TimeFormat(now(), 'hh:mm tt')# EST</td>
                        </tr>
                                                    
                    </table>                            
    
                </fieldset>
    
    
                <!--- Notes --->                
                <fieldset style="margin: 5px 0px 10px 0px; padding: 7px; border: ##DDD 1px solid; font-size:13px;">
                    
                    <legend style="color: ##333; font-weight: bold; padding-bottom:5px; text-transform:uppercase;">NOTES ON THIS FLIGHT INFORMATION</legend>
    
                    <p style="color: ##333;">
                        <cfif LEN(qGetStudentFullInformation.flight_info_notes)> #qGetStudentFullInformation.flight_info_notes# <cfelse> n/a </cfif>
                    </p>
                    
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
                        
        </cfoutput>

		<cfscript>
            // Return Flight Info				
            return flightInfoReport;
        </cfscript>
    </cffunction>

	
    <!--- EMAIL FLIGHT INFORMATION --->
	<cffunction name="emailFlightInformation" access="public" returntype="void" output="false" hint="Sends out flight notification when information is added/edited or deleted">
    	<cfargument name="studentID" hint="studentID is required">
        <cfargument name="flightID" default="0" hint="flightID is not required, pass flightID of a leg that has been deleted">
		<cfargument name="emailPDF" default="1" hint="Set to 0 to send the flight arrival in HTML format">
        <cfargument name="sendEmailTo" default="" hint="regionalManager | currentUser">
        <cfargument name="isPHPStudent" default="0" hint="Set to 1 if it's a PHP student">
       
   		<!--- Import CustomTag --->
		<cfimport taglib="../customTags/gui/" prefix="gui" />	

		<cfscript>
            var flightEmailTo = '';
			var flightEmailCC = '';
            var flightEmailBody = '';
			var flightInfoReport = '';
        	
			if ( VAL(ARGUMENTS.isPHPStudent) ) {
				// PHP - Get Student Information
				qGetStudentFullInformation = getPHPStudent(studentID=ARGUMENTS.studentID);
			} else {
				// Public - Get Student Information
				qGetStudentFullInformation = getStudentFullInformationByID(studentID=ARGUMENTS.studentID);
			}
			
			// Get Formatted Flight Information
			flightInfoReport = printFlightInformation(
				studentID=ARGUMENTS.studentID,
				programID=qGetStudentFullInformation.programID,
				flightID=ARGUMENTS.flightID,
				sendEmailTo=ARGUMENTS.sendEmailTo,
				isPHPStudent=ARGUMENTS.isPHPStudent
			);
			
			// Path to save temp PDF files
			pdfPath = APPLICATION.PATH.temp & '##' & qGetStudentFullInformation.studentID & '-' & qGetStudentFullInformation.firstName & qGetStudentFullInformation.familyLastName & '-FlightInformation.pdf';
			// Remove Empty Spaces
			pdfPath = ReplaceNoCase(pdfPath, " ", "", "ALL");

			// Default Flight Information
			flightInfoLink = '#CLIENT.exits_url#/nsmg/index.cfm?curdoc=student_info&studentID=#qGetStudentFullInformation.studentID#';
			
            // Get Current User
            qGetCurrentUser = APPLICATION.CFC.USER.getUserByID(userID=CLIENT.userID);
            
			// Get Regional Manager
			qGetRegionalManager = APPLICATION.CFC.USER.getRegionalManager(regionID=qGetStudentFullInformation.regionAssigned);

            // Get Facilitator Email
            qGetFacilitator = APPLICATION.CFC.REGION.getRegionFacilitatorByRegionID(regionID=qGetStudentFullInformation.regionAssigned);
			
			// Get Area Rep Email
			qGetAreaRep = APPLICATION.CFC.USER.getUserByID(userID = qGetStudentFullInformation.areaRepID);						
			
			// Make sure we have valid email addresses, if not use support
			if ( IsValid("email", qGetCurrentUser.email) ) {
				vCurrentUserEmailAddress = qGetCurrentUser.email;
			} else {
				vCurrentUserEmailAddress = APPLICATION.EMAIL.support;
			}

			// Make sure we have valid email addresses, if not use support
			if ( IsValid("email", qGetRegionalManager.email) ) {
				vRMEmailAddress = qGetRegionalManager.email;
			} else {
				vRMEmailAddress = APPLICATION.EMAIL.support;
			}
			
			// Make sure we have valid email addresses, if not use support
			if ( IsValid("email", qGetFacilitator.email) ) {
				vFacilitatorEmailAddress = qGetFacilitator.email;
			} else {
				vFacilitatorEmailAddress = APPLICATION.EMAIL.support;
			}
			
			// Set Up EmailTo and FlightInfo Link
			if ( ARGUMENTS.sendEmailTo EQ 'currentUser' ) {
				
				// Email Current User
				flightEmailTo = vCurrentUserEmailAddress;
				
			} else if ( VAL(ARGUMENTS.isPHPStudent) ) {
            	
				// PHP Student - Email PHP
				flightInfoLink = 'http://www.phpusa.com/internal/index.cfm?curdoc=student/student_info&unqid=#qGetStudentFullInformation.uniqueID#';
                flightEmailTo = APPLICATION.EMAIL.PHPContact;
                flightEmailCC = 'chris@phpusa.com';				

			} else if ( ARGUMENTS.sendEmailTo EQ 'regionalManager' ) {
				
				// Public Student - Email Regional Manager and send a copy to the current user
				flightEmailTo = vRMEmailAddress;
				//flightEmailCC = vCurrentUserEmailAddress;
				flightEmailCC = qGetAreaRep.email;
			} else {
				
				// Public Student - Email Facilitator and send a copy to Regional Manager
                flightEmailTo = vFacilitatorEmailAddress;
				flightEmailCC = vRMEmailAddress & ',' & qGetAreaRep.email;
            
			}
			
			// DELETE OR COMMENT THIS
			// flightEmailTo = 'marcus@iseusa.com';
			// flightEmailCC = 'marcus@iseusa.com';
        </cfscript>
        
        <!--- Send out Email if there is a flight information or if a leg has been deleted --->
        <cfif qGetDeletedFlightInfo.recordCount OR qGetPreAYPArrival.recordCount OR qGetArrival.recordCount OR qGetDeparture.recordCount>
        	
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
                        
						<!--- Do Not Display for PHP --->
                        <cfif NOT VAL(ARGUMENTS.isPHPStudent)>   
                            <p style="color: ##333;">
                                <strong>Region:</strong> #qGetStudentFullInformation.regionName#
                            </p>
                            
                            <p style="color: ##333;">
                                <strong>Regional Manager:</strong>
                                #qGetRegionalManager.firstName# #qGetRegionalManager.lastName# (###qGetRegionalManager.userID#)
                                - Email: <a href="mailto:#qGetRegionalManager.email#">#qGetRegionalManager.email#</a>
                                <cfif LEN(qGetRegionalManager.work_phone)>
                                    - Phone: #qGetRegionalManager.work_phone#
                                </cfif>
                            </p>
                        </cfif>
                                
                        <p style="color: ##333;">
                            <strong>Area Representative:</strong>
                            #qGetStudentFullInformation.areaRepFirstName# #qGetStudentFullInformation.areaRepLastName# (###qGetStudentFullInformation.areaRepUserID#)
                            - Email: <a href="mailto:#qGetStudentFullInformation.areaRepEmail#">#qGetStudentFullInformation.areaRepEmail#</a> 
                            <cfif LEN(qGetStudentFullInformation.areaRepPhone)>
                                - Phone: #qGetStudentFullInformation.areaRepPhone#
                            </cfif>                                    
                        </p>

                        <p style="color: ##333;">
	                        This information can also be found on EXITS by clicking <a href="#flightInfoLink#">here</a> then click on "Flight Information" on the right menu.
						</p>
                        
                        <!--- Flight Leg Deleted --->
                        <cfif qGetDeletedFlightInfo.recordCount>
                            
                            <p style="color: ##333;">
                            
                                <cfif qGetDeletedFlightInfo.flight_type EQ 'arrival'>
                                    <p><strong>*** Arrival information has been deleted*** </strong></p>
                                </cfif>
                    
                                <cfif qGetDeletedFlightInfo.flight_type EQ 'departure'>
                                    <p><strong>*** Departure information has been deleted*** </strong></p>
                                </cfif>
                    
                                <p>
                                    The flight leg from <strong>#qGetDeletedFlightInfo.dep_aircode#</strong> to <strong>#qGetDeletedFlightInfo.arrival_aircode#</strong> 
                                    on <strong>#DateFormat(qGetDeletedFlightInfo.dep_date, 'mm/dd/yyyy')#</strong> has been deleted. Please see an updated flight information attached.
                                </p>
                            
                            </p>
                            
                        </cfif>

                    </fieldset>

                </cfsavecontent>
                
                <!--- Flight Information - PDF Format --->
                <cfdocument name="pdfFlightInfo" format="pdf" localUrl="no" backgroundvisible="yes" margintop="0.1" marginright="0.2" marginbottom="0.1" marginleft="0.2">
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
                    <cfinvokeargument name="email_replyto" value="">
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
                        <cfinvokeargument name="email_replyto" value="">
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
		
		IMPORT FLS ID
	
	----- ------------------------------------------------------------------------- --->
	<cffunction name="importFLSFile" access="public" returntype="void" output="true" hint="Reads Excel file received from FLS and stores the ID into the student table">
    	<cfargument name="excelFile" hint="excelFile is required">
        
        <!--- Read Excel --->
        <cfspreadsheet action="read" src="#ARGUMENTS.excelFile#" query="qUserListData" headerRow="1">          
        
        <!--- 
        <cfdump var="#qUserListData.recordCount#">
        <cfdump var="#qUserListData#">
        <cfabort>
		--->
        
		<cfscript>
            // COLUMNS: ID, FLS ID, STUDENT, SEX, DOB, COUNTRY, REGION, INTL. REP. FACILITATOR, ARRIVAL TO CAMP, FLIGHT INFO, DEPARTURE TO HOST, FLIGHT INFO, PRE-AYP CMAP
			
			// Loop thru query
            for (i=1;i LTE qUserListData.recordCount; i=i+1) {
            	
                // Check if we hava a valid ID
                if ( LEN(qUserListData['FLS ID'][i]) ) {
                    
                    // Insert Training
                    updateFLSID(
						studentID=qUserListData['ID'][i], 
						flsID=qUserListData['FLS ID'][i]
					);
                    
                }

            }		
        </cfscript>
        
	</cffunction>  


	<cffunction name="updateFLSID" access="public" returntype="void" output="false" hint="Inserts FLS ID to the student table">
        <cfargument name="studentID" hint="studentID is required">
        <cfargument name="flsID" hint="flsID is required">
		
            <cfquery result="test"
                datasource="#APPLICATION.DSN#">
					UPDATE
                    	smg_students
                    SET
                    	flsID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.flsID#">
					WHERE
                    	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">
            </cfquery>
	</cffunction>
	<!--- ------------------------------------------------------------------------- ----
		
		END OF IMPORT FLS ID
	
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
		
       <cfscript>
       	vCurrentSeasonPrograms = APPLICATION.CFC.LookUpTables.getCurrentSeasonPrograms();
       </cfscript>
       
        <cfquery 
			name="qGetProjectHelpList" 
			datasource="#APPLICATION.DSN#">
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
                        s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
					AND
                		s.programid IN (#vCurrentSeasonPrograms#)
                		
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
			datasource="#APPLICATION.DSN#">
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
			datasource="#APPLICATION.DSN#">
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

						<!--- Headquarters --->
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
                    datasource="#APPLICATION.DSN#">
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
			datasource="#APPLICATION.DSN#">
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
			datasource="#APPLICATION.DSN#">
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
                datasource="#APPLICATION.DSN#">
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
                    datasource="#APPLICATION.DSN#">
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
                    datasource="#APPLICATION.DSN#">
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
                datasource="#APPLICATION.DSN#">
                    UPDATE
                        smg_project_help
                    SET
                        <cfswitch expression="#ARGUMENTS.userType#">
                        	
                            <!--- Headquarters --->
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
			datasource="#APPLICATION.DSN#">
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
			datasource="#APPLICATION.DSN#">
                UPDATE
                	smg_project_help_activities
				SET
                	is_deleted = <cfqueryparam cfsqltype="cf_sql_bit" value="1">,
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
        
        <cfscript>
			// Dump Arguments
			If ( VAL(ARGUMENTS.dumpArguments) ) {
				WriteDump(ARGUMENTS);
				abort;
			}
		</cfscript>
           
        <cfquery 
			name="qGetProjectHelpReport" 
			datasource="#APPLICATION.DSN#">
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

                <cfif LEN(ARGUMENTS.isActive)>
                    AND 
                        s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="#ARGUMENTS.isActive#">
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


    <cffunction name="addHoldStatus" access="remote" returntype="void" hint="">
        <cfargument name="student_id" type="numeric" required="yes" hint="The student ID for this secondary language">    
        <cfargument name="hold_status_id" type="numeric" required="yes" hint="The field ID of the language to be added">        
        <cfargument name="create_by" type="numeric" required="yes" hint="1 for primary, 0 for secondary">
        <cfargument name="school_id" type="numeric" default="0" required="no" hint="1 for primary, 0 for secondary">
        <cfargument name="host_family_id" type="numeric" default="0" required="no" hint="1 for primary, 0 for secondary">
        <cfargument name="area_rep_id" type="numeric" default="0" required="no" hint="1 for primary, 0 for secondary">
        
        <cfquery 
            datasource="#APPLICATION.DSN#">
                INSERT INTO
                    smg_student_hold_status
                    (
                        hold_status_id,
                        student_id,
                        area_rep_id,
                        host_family_id,
                        school_id,
                        create_by,
                        create_date
                    )
                VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.hold_status_id#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.student_id#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.area_rep_id#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.host_family_id#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.school_id#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.create_by#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> 
                    )
        </cfquery>
    </cffunction>



    <cffunction name="getStudentsRemote" access="remote" returnFormat="json" output="false" hint="Returns host leads in Json format">
        <cfargument name="pageNumber" type="numeric" default="1" hint="Page number is not required">
        <cfargument name="regionID" type="string" default="" hint="not required">
        <cfargument name="keyword" type="string" default="" hint="not required">
        <cfargument name="placed" type="string" default="" hint="not required">
        <cfargument name="placement_status" type="string" default="" hint="not required">
        <cfargument name="priority_student" type="string" default="" hint="not required">
        <cfargument name="double_placement" type="string" default="" hint="not required">
        <cfargument name="hold_status_id" type="string" default="" hint="not required">
        <cfargument name="cancelled" type="string" default="" hint="not required">
        <cfargument name="active" type="string" default="" hint="not required">
        <cfargument name="seasonID" type="string" default="" hint="not required">
        <cfargument name="sortBy" type="string" default="studentID" hint="not required">
        <cfargument name="sortOrder" type="string" default="ASC" hint="not required">
        <cfargument name="pageSize" type="numeric" default="30" hint="Page number is not required">

        <cfargument name="adv_search" type="string" default="" hint="not required">
        <cfargument name="familyLastName" type="string" default="" hint="not required">
        <cfargument name="firstName" type="string" default="" hint="not required">
        <cfargument name="age" type="string" default="" hint="not required">
        <cfargument name="sex" type="string" default="" hint="not required">
        <cfargument name="preayp" type="string" default="" hint="not required">
        <cfargument name="direct" type="string" default="" hint="not required">
        <cfargument name="privateschool" type="string" default="" hint="not required">
        <cfargument name="grade" type="string" default="" hint="not required">
        <cfargument name="graduate" type="string" default="" hint="not required">
        <cfargument name="religionid" type="string" default="" hint="not required">
        <cfargument name="interestid" type="string" default="" hint="not required">
        <cfargument name="sports" type="string" default="" hint="not required">
        <cfargument name="interests_other" type="string" default="" hint="not required">
        <cfargument name="placementStatus" type="string" default="" hint="not required">
        <cfargument name="countryID" type="string" default="" hint="not required">
        <cfargument name="intrep" type="string" default="" hint="not required">
        <cfargument name="stateid" type="string" default="" hint="not required">
        <cfargument name="state_placed_id" type="string" default="" hint="not required">
        <cfargument name="programID" type="string" default="" hint="not required">

        <cfargument name="searchStudentID" type="string" default="" hint="not required">

        <cfargument name="clientUserType" type="string" default="" hint="not required">

        <!--- STUDENTS UNDER ADVISOR --->       
        <cfif CLIENT.usertype EQ 6>
        
            <!--- show only placed by the reps under the advisor --->
            <cfquery name="get_users_under_adv" datasource="#application.dsn#">
                SELECT DISTINCT 
                    userid
                FROM 
                    user_access_rights
                WHERE 
                    advisorid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
                AND 
                    regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.regionID#">
            </cfquery>
            
            <cfscript>
                vUserUnderAdvisorList = '';
                vUserUnderAdvisorList = valueList(get_users_under_adv.userid);
                // include the current user on the list.
                vUserUnderAdvisorList = listAppend(vUserUnderAdvisorList, CLIENT.userid);
            </cfscript>
            
        </cfif>
        


        <cfquery name="qGetResults" datasource="#application.dsn#">
            SELECT  
                s.studentID, 
                s.nexits_id,
                s.uniqueid, 
                s.programID,
                s.hostID,
                s.firstName,
                s.familyLastName, 
                s.sex, 
                s.email, 
                s.active, 
                s.dateassigned, 
                s.dateplaced,
                s.intrep, 
                s.branchID,
                s.regionguar,
                s.state_guarantee, 
                s.app_additional_program,
                s.app_region_guarantee,
                s.scholarship, 
                s.privateschool,
                s.host_fam_approved,
                smg_regions.regionName, 
                smg_g.regionName as r_guarantee, 
                smg_states.state,             
                p.programname,
                p2.app_program as add_program,
                c.countryname, 
                co.companyShort, 
                smg_hosts.familyLastName AS hostname,
                sh1.hold_status_id,
                DATE_FORMAT(sh1.create_date,'%m/%d/%Y') AS hold_create_date,
                sasr.state1,
                sasr.state2,
                sasr.state3,
                st1.state AS state1name,
                st2.state AS state2name,
                st3.state AS state3name,
                aypori.name AS ayporientation,
                aypeng.name AS aypenglish, 
                u.businessname,
                u2.businessname AS branchName,

                CASE 
                    WHEN s.canceldate IS NOT NULL
                        AND s.termination_date IS NULL
                    THEN 'Cancelled'

                    WHEN s.termination_date IS NOT NULL
                        AND s.canceldate IS NULL
                    THEN 'Terminated'

                    WHEN sh1.hold_status_id = <cfqueryparam cfsqltype="cf_sql_integer" value="2">
                        AND s.canceldate IS NULL
                        AND s.termination_date IS NULL
                    THEN 'Showing'

                    WHEN sh1.hold_status_id = <cfqueryparam cfsqltype="cf_sql_integer" value="3">
                        AND s.canceldate IS NULL
                        AND s.termination_date IS NULL
                    THEN 'Committed'

                    WHEN s.host_fam_approved IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="5,6,7,10" list="yes"> )
                        AND (sh1.hold_status_id <= 1
                            OR sh1.hold_status_id IS NULL)
                        AND s.hostID > <cfqueryparam cfsqltype="cf_sql_integer" value="0">   
                        AND s.canceldate IS NULL
                        AND s.termination_date IS NULL
                    THEN 'Pending'

                    WHEN s.host_fam_approved IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4" list="yes"> ) 
                        AND (sh1.hold_status_id <= 1
                            OR sh1.hold_status_id IS NULL)
                        AND s.canceldate IS NULL
                        AND s.termination_date IS NULL  
                    THEN 'Placed'

                    WHEN s.hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
                        AND s.canceldate IS NULL
                        AND s.termination_date IS NULL 
                        AND (sh1.hold_status_id <= 1 OR sh1.hold_status_id IS NULL)
                    THEN 'Unplaced'
                END 
                AS stu_status,

                CONCAT('',
                CASE 
                    WHEN (st1.state IS NOT NULL OR st2.state IS NOT NULL OR st3.state IS NOT NULL)
                    THEN CONCAT(st1.state, ' ', st2.state, ' ', st3.state)
                    ELSE ''
                END,
                CASE 
                    WHEN app_region_guarantee = 6 
                    THEN 'West Region'
                    WHEN app_region_guarantee = 7
                    THEN 'Central Region'
                    WHEN app_region_guarantee = 8 
                    THEN 'South Region'
                    WHEN app_region_guarantee = 9 
                    THEN 'East Region' 
                    ELSE ''
                END,
                ' ', 
                CASE 
                    WHEN p2.app_program = 'New York Orientation'
                    THEN '<strong>NY Orientation</strong>'
                    WHEN p2.app_program = 'Pre AYP English'
                    THEN'<strong>Pre-AYP</strong>'
                    WHEN (p2.app_program IS NOT NULL AND p2.app_program != '')
                    THEN p2.app_program
                    ELSE ''
                END) AS stu_requests,

                CASE 
                    WHEN sh1.hold_status_id > 1
                        THEN hs.name 
                    ELSE 'Not on Hold'
                END 
                AS hold_status_name

            FROM smg_students s
            INNER JOIN smg_companies co ON s.companyID = co.companyID
            LEFT OUTER JOIN smg_regions ON s.regionassigned = smg_regions.regionID
            LEFT OUTER JOIN smg_countrylist c ON s.countryresident = c.countryID
            LEFT OUTER JOIN smg_regions smg_g ON s.regionalguarantee = smg_g.regionID
            LEFT OUTER JOIN smg_states ON s.state_guarantee = smg_states.id
            LEFT OUTER JOIN smg_hosts ON s.hostID = smg_hosts.hostID
            LEFT OUTER JOIN smg_programs p ON s.programID = p.programID
            LEFT JOIN smg_student_app_programs p2 ON p2.app_programid = s.app_additional_program

            LEFT OUTER JOIN smg_student_app_state_requested sasr ON sasr.studentid = s.studentiD
            LEFT OUTER JOIN smg_states st1 ON st1.id = sasr.state1
            LEFT OUTER JOIN smg_states st2 ON st2.id = sasr.state2
            LEFT OUTER JOIN smg_states st3 ON st3.id = sasr.state3

            LEFT OUTER JOIN (
                          SELECT    MAX(id) id, student_id
                          FROM      smg_student_hold_status
                          GROUP BY  student_id
                      ) sh ON (sh.student_id = s.studentID)

            LEFT OUTER JOIN smg_student_hold_status sh1 ON (sh1.id = sh.id)
            LEFT OUTER JOIN smg_hold_status hs ON hs.id = sh1.hold_status_id
            LEFT OUTER JOIN smg_aypcamps aypeng ON (s.aypenglish = aypeng.campid)
            LEFT OUTER JOIN smg_aypcamps aypori ON (s.ayporientation = aypori.campid)

            LEFT OUTER JOIN smg_users u ON s.intrep = u.userid
            LEFT OUTER JOIN smg_users u2 ON s.branchID = u2.userid
            
            WHERE 
            
                <!--- SHOW ONLY APPS APPROVED --->
                s.app_current_status = <cfqueryparam cfsqltype="cf_sql_integer" value="11">
            
            <!--- OFFICE PEOPLE --->
            <cfif APPLICATION.CFC.USER.isOfficeUser()>
            
                <!--- Students under companies --->
                <cfif CLIENT.companyID EQ 5>
                    AND s.companyid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> ) 
                <cfelse>
                    AND s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
                </cfif>
                
                <cfif VAL(ARGUMENTS.regionID)>
                    AND s.regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.regionID#">
                </cfif>

                <cfif ARGUMENTS.hold_status_id EQ 0>
                    AND (sh1.hold_status_id = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                        OR sh1.hold_status_id = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                        OR sh1.hold_status_id IS NULL
                        OR sh1.hold_status_id = '')
                <cfelseif ARGUMENTS.hold_status_id GT 0>
                    AND sh1.hold_status_id > <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                    AND s.canceldate IS NULL
                    AND s.termination_date IS NULL
                </cfif>
                
                <cfif ARGUMENTS.cancelled EQ 1>
                    AND s.canceldate IS NOT NULL
                <cfelseif ARGUMENTS.cancelled EQ 0>
                    AND s.canceldate IS NULL
                </cfif>
                
                <cfif LEN(ARGUMENTS.active)>
                    AND s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="#active#">
                </cfif>
                
                <cfif ARGUMENTS.privateschool EQ 0>
                    AND privateschool != <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.privateschool#">
                <cfelseif VAL(ARGUMENTS.privateschool)>
                    AND privateschool = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.privateschool#">
                </cfif>

                <cfif ARGUMENTS.placed EQ 1>
                    AND s.host_fam_approved IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4" list="yes"> ) 
                    AND (sh1.hold_status_id <= <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                        OR sh1.hold_status_id IS NULL)
                    AND s.canceldate IS NULL   
                    AND s.termination_date IS NULL

                <cfelseif ARGUMENTS.placed EQ 0>
                    AND 
                        (
                            (sh1.hold_status_id = <cfqueryparam cfsqltype="cf_sql_integer" value="2">
                            OR sh1.hold_status_id = <cfqueryparam cfsqltype="cf_sql_integer" value="3">
                            OR s.hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> )
                        OR 
                            (s.host_fam_approved IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="5,6,7,10" list="yes"> )
                            AND (sh1.hold_status_id <= <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                            OR sh1.hold_status_id IS NULL)
                            AND s.hostID > <cfqueryparam cfsqltype="cf_sql_integer" value="0">))

                    AND s.canceldate IS NULL   
                    AND s.termination_date IS NULL              
                </cfif>


            
            <!--- Guest Account --->
            <cfelseif CLIENT.usertype EQ 27>
            
                <!--- Students under companies --->
                <cfif ARGUMENTS.companyID EQ 5>
                    AND s.companyid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> ) 
                <cfelse>
                    AND s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
                </cfif>

                AND s.studentID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#VAL(ARGUMENTS.searchStudentID)#">
            
            <!--- FIELD --->
            <cfelse>
            
                AND s.regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.regionID#">
                
                <!--- Don't show 08 programs --->
                AND fieldviewable = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                AND s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                    
                <cfif ARGUMENTS.placed EQ 1>
                    AND s.hostID != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                      
                    <!--- STUDENTS UNDER REGIONAL ADVISOR --->  
                    <cfif ARGUMENTS.clientUserType EQ 6>
                        AND (
                                s.arearepid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.vUserUnderAdvisorList#" list="yes"> )
                                OR s.placerepid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.vUserUnderAdvisorList#" list="yes"> )
                            )
                            
                    <!--- STUDENTS UNDER AN AREA REPRESENTATIVE --->
                    <cfelseif ARGUMENTS.clientUserType EQ 7>
                        AND (
                                s.arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
                                OR s.placerepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
                            )
                    </cfif> 
                               
                <cfelseif ARGUMENTS.placed EQ 0>
                    AND s.hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                </cfif>
                
            </cfif>

            <cfif ARGUMENTS.placement_status EQ "Terminated">
                AND s.termination_date IS NOT NULL
                AND s.canceldate IS NULL
            <cfelseif ARGUMENTS.placement_status EQ "Cancelled">
                AND s.canceldate IS NOT NULL
                AND s.termination_date IS NULL
            <cfelseif ARGUMENTS.placement_status EQ "Showing">
                AND sh1.hold_status_id = <cfqueryparam cfsqltype="cf_sql_integer" value="2">
                AND s.canceldate IS NULL
                AND s.termination_date IS NULL
            <cfelseif ARGUMENTS.placement_status EQ "Committed">
                AND sh1.hold_status_id = <cfqueryparam cfsqltype="cf_sql_integer" value="3"> 
                AND s.canceldate IS NULL
                AND s.termination_date IS NULL
            <cfelseif ARGUMENTS.placement_status EQ "Pending">
                AND s.host_fam_approved IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="5,6,7" list="yes"> )   
                AND (sh1.hold_status_id <= <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                    OR sh1.hold_status_id IS NULL)     
                AND s.hostID > <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                AND s.canceldate IS NULL
                AND s.termination_date IS NULL
            <cfelseif ARGUMENTS.placement_status EQ "Placed">
                AND s.host_fam_approved IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4" list="yes"> ) 
                AND (sh1.hold_status_id <= <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                    OR sh1.hold_status_id IS NULL) 
                AND s.canceldate IS NULL
                AND s.termination_date IS NULL
            <cfelseif ARGUMENTS.placement_status EQ "Unplaced">
                AND s.hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                AND (sh1.hold_status_id <= <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                    OR sh1.hold_status_id IS NULL) 
                AND s.canceldate IS NULL
                AND s.termination_date IS NULL
            </cfif>

            <cfif ARGUMENTS.priority_student EQ 0>
                AND (s.AYPEnglish = 0 OR s.AYPEnglish IS NULL)
                AND (s.ayporientation = 0 OR s.ayporientation IS NULL)
                AND (s.app_region_guarantee = 0 OR s.app_region_guarantee IS NULL)
                AND (sasr.state1 = 0 OR sasr.state1 IS NULL)
                AND (sasr.state2 = 0 OR sasr.state2 IS NULL)
                AND (sasr.state3 = 0 OR sasr.state3 IS NULL)
            <cfelseif ARGUMENTS.priority_student EQ 1>
                AND (s.AYPEnglish > 0
                    OR s.ayporientation > 0
                    OR s.app_region_guarantee > 0
                    OR sasr.state1 > 0
                    OR sasr.state2 > 0
                    OR sasr.state3 > 0)
            </cfif>
                    
            <!--- Search --->            
            <cfif LEN(trim(ARGUMENTS.keyword))>
                AND (  s.studentID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(ARGUMENTS.keyword)#">
                    OR s.familyLastName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(ARGUMENTS.keyword)#%">
                    OR s.firstName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(ARGUMENTS.keyword)#%">
                    OR c.countryname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(ARGUMENTS.keyword)#%">
                    OR smg_regions.regionName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(ARGUMENTS.keyword)#%">
                    OR p.programname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(ARGUMENTS.keyword)#%">
                    OR smg_hosts.familyLastName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(ARGUMENTS.keyword)#%">)
            </cfif>
            
            <!--- advanced search items. --->        
            <cfif VAL(ARGUMENTS.adv_search)>
            
                <cfif LEN(ARGUMENTS.familyLastName)>
                    AND s.familyLastName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(ARGUMENTS.familyLastName)#%">
                </cfif>
                
                <cfif LEN(ARGUMENTS.firstName)>
                    AND s.firstName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(ARGUMENTS.firstName)#%">
                </cfif>
                
                <cfif LEN(ARGUMENTS.direct)>
                    AND s.direct_placement = <cfqueryparam cfsqltype="cf_sql_bit" value="#ARGUMENTS.direct#">
                </cfif>
                
                <cfif VAL(ARGUMENTS.age)>
                    AND FLOOR(DATEDIFF(now(), s.dob) / 365) = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.age#">
                </cfif>
                
                <cfif LEN(ARGUMENTS.sex)>
                    AND s.sex = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.sex#">
                </cfif>
                
                <cfif VAL(ARGUMENTS.grade)>
                    AND s.grades = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.grade#">
                </cfif>
                
                <cfif LEN(ARGUMENTS.graduate)>
                    AND ( s.grades = 12
                          OR ( s.grades = 11 
                               AND s.countryresident IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="49,237" list="yes"> ) 
                            )
                    )
                </cfif>
                
                <cfif VAL(ARGUMENTS.religionid)>
                    AND s.religiousaffiliation = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.religionid#"> 
                </cfif> 
                
                <cfif LEN(ARGUMENTS.interestid)>
                    <!--- s.interests is a comma-delimited list of interestid's.  check single item, beginning of list, middle of list, end of list. --->
                    AND (  s.interests = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.interestid#">
                        OR s.interests LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.interestid#,%">
                        OR s.interests LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#ARGUMENTS.interestid#,%">
                        OR s.interests LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#ARGUMENTS.interestid#">
                        )
                </cfif> 
                
                <cfif LEN(ARGUMENTS.sports)>
                    AND s.comp_sports = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.sports#">
                </cfif>
                
                <cfif LEN(ARGUMENTS.interests_other)>
                    AND s.interests_other LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(ARGUMENTS.interests_other)#%">
                </cfif>
                
                <cfif ARGUMENTS.placementStatus EQ 'Approved'>
                    AND s.host_fam_approved IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4" list="yes"> )   
                <cfelseif ARGUMENTS.placementStatus EQ 'Pending'>
                    AND s.host_fam_approved IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="5,6,7" list="yes"> )              
                </cfif>
                
                <cfif VAL(ARGUMENTS.countryID)>
                    AND s.countryresident = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.countryID#">
                </cfif>
                
                <cfif VAL(ARGUMENTS.intrep)>
                    AND s.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.intrep#">
                </cfif>
                
                <cfif VAL(ARGUMENTS.stateid)>
                    AND s.state_guarantee = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.stateid#">
                </cfif> 

                <cfif LEN(ARGUMENTS.state_placed_id)>
                    AND smg_hosts.state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.state_placed_id#">
                </cfif> 
                    
                <cfif VAL(ARGUMENTS.programID)>
                    AND s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.programID#" list="yes"> )
                </cfif>

                <cfif ARGUMENTS.preayp EQ 'english'>
                    AND s.aypenglish > 0
                <cfelseif ARGUMENTS.preayp EQ 'orient'>
                    AND s.ayporientation
                </cfif>

                <cfif ARGUMENTS.double_placement EQ 0>

                <cfelseif ARGUMENTS.double_placement EQ 1>

                </cfif>
                        
            </cfif>

            <cfif VAL(ARGUMENTS.seasonID)>
                AND p.seasonID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.seasonID#" list="yes"> )
            </cfif>
            
            ORDER BY 
                <cfswitch expression="#ARGUMENTS.sortBy#">

                    <cfcase value="studentID">                    
                        s.studentID #ARGUMENTS.sortOrder#,
                        s.familylastname
                    </cfcase>

                    <cfcase value="lastName">                    
                        s.familylastname #ARGUMENTS.sortOrder#,
                        s.firstname
                    </cfcase>

                    <cfcase value="firstName">                    
                        s.firstname #ARGUMENTS.sortOrder#,
                        s.familylastname
                    </cfcase>

                    <cfcase value="sex">                    
                        s.sex #ARGUMENTS.sortOrder#,
                        s.familylastname
                    </cfcase>

                    <cfcase value="country">                    
                        c.countryname #ARGUMENTS.sortOrder#,
                        s.familylastname
                    </cfcase>

                    <cfcase value="stu_status">                    
                        stu_status #ARGUMENTS.sortOrder#,
                        s.familylastname
                    </cfcase>

                    <cfcase value="hold_create_date">                    
                        sh1.create_date #ARGUMENTS.sortOrder#,
                        s.familylastname
                    </cfcase>

                    <cfcase value="region">                    
                        smg_regions.regionName #ARGUMENTS.sortOrder#,
                        s.familylastname
                    </cfcase>

                    <cfcase value="program">                    
                        p.programname #ARGUMENTS.sortOrder#,
                        s.familylastname
                    </cfcase>

                    <cfcase value="hostName">                    
                        s.hostname #ARGUMENTS.sortOrder#,
                        s.familylastname
                    </cfcase>

                    <cfcase value="requests">                    
                        stu_requests #ARGUMENTS.sortOrder#,
                        s.familylastname
                    </cfcase>
 
                    <cfdefaultcase>
                        s.familyLastName ASC,
                        s.firstname
                    </cfdefaultcase>
                            
                </cfswitch>
        </cfquery>

        <cfscript>
            // Set return structure that will store query + pagination information
            stResult = StructNew();
            
            // Populate structure with pagination information
            stResult.pageNumber = ARGUMENTS.pageNumber;
            stResult.numberOfRecordsOnPage = ARGUMENTS.pageSize;
            stResult.numberOfPages = Ceiling( qGetResults.recordCount / stResult.numberOfRecordsOnPage );
            stResult.numberOfRecords = qGetResults.recordCount;
            stResult.sortBy = ARGUMENTS.sortBy;
            stResult.sortOrder = ARGUMENTS.sortOrder;
            
            // Here using url.pagenumber to work out what records to display on current page
            stResult.recordFrom = ( (ARGUMENTS.pageNumber * stResult.numberOfRecordsOnPage) - stResult.numberOfRecordsOnPage) + 1;
            stResult.recordTo = ( ARGUMENTS.pageNumber * stResult.numberOfRecordsOnPage );
            
            /* 
                if on last page display the actual number of records in record set as the last to 'figure'. Otherwise it gives 
                a false reading and gives the pagenumber * numberOfRecordsOnPage which is always a multiple of 10
            */
            if ( stResult.recordTo EQ (stResult.numberOfPages * 10) ) {
                stResult.recordTo = qGetResults.recordCount;
            }

            // Populate structure with query
            resultQuery = QueryNew("studentID, nexits_id, uniqueid, programID, hostID, firstName, familyLastName, sex, email, active, dateassigned, regionguar,state_guarantee, aypenglish, ayporientation, scholarship, privateschool, host_fam_approved, regionName, r_guarantee, state, programname, countryname, companyShort, hostname, hold_status_id, hold_create_date, hold_status_name, state1name, state2name, state3name, app_region_guarantee, add_program, stu_status, hostID, requests, datePlaced, intrepID, businessname, branchID, branchName");
            
            if ( qGetResults.recordCount < stResult.recordTo ) {
                stResult.recordTo = qGetResults.recordCount;
            }
            
            // Populate query below
            if ( qGetResults.recordCount ) {
                For ( i=stResult.recordFrom; i LTE stResult.recordTo; i++ ) {
                    QueryAddRow(resultQuery);
                    QuerySetCell(resultQuery, "studentid", qGetResults.studentid[i]);
                    QuerySetCell(resultQuery, "nexits_id", qGetResults.studentid[i]);
                    QuerySetCell(resultQuery, "uniqueID", qGetResults.uniqueID[i]);
                    QuerySetCell(resultQuery, "hostID", qGetResults.hostID[i]);
                    QuerySetCell(resultQuery, "firstName", qGetResults.firstName[i]);
                    QuerySetCell(resultQuery, "familyLastName", qGetResults.familyLastName[i]);
                    QuerySetCell(resultQuery, "sex", qGetResults.sex[i]);
                    QuerySetCell(resultQuery, "email", qGetResults.email[i]);
                    QuerySetCell(resultQuery, "active", qGetResults.active[i]);
                    QuerySetCell(resultQuery, "dateassigned", qGetResults.dateassigned[i]);
                    QuerySetCell(resultQuery, "state_guarantee", qGetResults.state[i]);
                    QuerySetCell(resultQuery, "aypenglish", qGetResults.aypenglish[i]);
                    QuerySetCell(resultQuery, "ayporientation", qGetResults.ayporientation[i]);
                    QuerySetCell(resultQuery, "scholarship", qGetResults.scholarship[i]);
                    QuerySetCell(resultQuery, "privateschool", qGetResults.privateschool[i]);
                    QuerySetCell(resultQuery, "host_fam_approved", qGetResults.host_fam_approved[i]);
                    QuerySetCell(resultQuery, "regionName", qGetResults.regionName[i]);
                    QuerySetCell(resultQuery, "r_guarantee", qGetResults.r_guarantee[i]);
                    QuerySetCell(resultQuery, "state", qGetResults.state[i]);
                    QuerySetCell(resultQuery, "programname", qGetResults.programname[i]);
                    QuerySetCell(resultQuery, "countryname", qGetResults.countryname[i]);
                    QuerySetCell(resultQuery, "companyShort", qGetResults.companyShort[i]);
                    QuerySetCell(resultQuery, "hostname", qGetResults.hostname[i]);
                    QuerySetCell(resultQuery, "hold_status_id", qGetResults.hold_status_id[i]);
                    QuerySetCell(resultQuery, "hold_create_date", qGetResults.hold_create_date[i]);
                    QuerySetCell(resultQuery, "hold_status_name", qGetResults.hold_status_name[i]);

                    QuerySetCell(resultQuery, "state1name", qGetResults.state1name[i]);
                    QuerySetCell(resultQuery, "state2name", qGetResults.state2name[i]);
                    QuerySetCell(resultQuery, "state3name", qGetResults.state3name[i]);

                    QuerySetCell(resultQuery, "app_region_guarantee", qGetResults.app_region_guarantee[i]);
                    QuerySetCell(resultQuery, "add_program", qGetResults.add_program[i]);

                    QuerySetCell(resultQuery, "stu_status", qGetResults.stu_status[i]);
                    QuerySetCell(resultQuery, "hostID", qGetResults.hostID[i]);

                    QuerySetCell(resultQuery, "requests", qGetResults.stu_requests[i]);

                    QuerySetCell(resultQuery, "datePlaced", qGetResults.datePlaced[i]);
                    QuerySetCell(resultQuery, "intrepID", qGetResults.intrep[i]);
                    QuerySetCell(resultQuery, "businessname", qGetResults.businessname[i]);
                    QuerySetCell(resultQuery, "branchID", qGetResults.branchID[i]);
                    QuerySetCell(resultQuery, "branchName", qGetResults.branchname[i]);
                }
            
            }
            
            // Add query to structure
            stResult.query = resultQuery;
            
            // return structure
            return stResult;            
        </cfscript>
    </cffunction>

</cfcomponent>