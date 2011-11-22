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
              
        <cfquery 
			name="qGetStudentByID" 
			datasource="#APPLICATION.DSN#">
                SELECT
					*
                FROM 
                    smg_students
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
                    s.firstName,
                    s.familyLastName,
                    s.dob,
                    s.active,
                    s.flight_info_notes,
                    s.AYPOrientation,
                    s.AYPEnglish,
                    <!--- Intl Representative --->
                    intlRep.userID AS intlRepUserID,
                    intlRep.firstName AS intlRepFirstName,
                    intlRep.lastName AS intlRepLastName,
                    intlRep.businessName AS intlRepBusinessName,
                    intlRep.email AS intlRepEmail, 
                    intlRep.insurance_typeid,                 
                    <!--- Program --->
                    p.programName,
                    <!--- Host Family --->
                    host.airport_city, 
                    host.major_air_code,
                    <!--- Region --->
					r.regionName,
                    <!--- Area Representative --->
                    areaRep.userID AS areaRepUserID,
                    areaRep.firstName AS areaRepFirstName,
                    areaRep.lastName AS areaRepLastName,
					areaRep.email AS areaRepEmail,
                    areaRep.work_phone AS areaRepPhone
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
                WHERE
                	1 = 1

				<cfif LEN(ARGUMENTS.studentID)>
                    AND
                        s.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">
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


	<cffunction name="getAvailableDoublePlacement" access="public" returntype="query" output="false" hint="Gets placed available students for double placement">
        <cfargument name="regionID" default="0" hint="regionAssigned is not required">
        <cfargument name="studentID" default="0" hint="studentID is not required">
              
        <cfquery 
			name="qGetAvailableDoublePlacement" 
			datasource="#APPLICATION.DSN#">
                SELECT 
                	studentID, 
                    familyLastName,
                    firstName
                FROM 
                	smg_students
                WHERE 
                	active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                AND
                	hostID != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                    
				<cfif LEN(ARGUMENTS.regionID)>
                    AND
                        regionAssigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.regionID)#">
                </cfif>

                <cfif LEN(ARGUMENTS.studentID)>
                    AND
                        studentID != <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">
                </cfif>
                    
                ORDER BY 
                	firstname, familylastname
		</cfquery>
		   
		<cfreturn qGetAvailableDoublePlacement>
	</cffunction>
		

	<!--- ------------------------------------------------------------------------- ----
		
		Placement Management
	
	----- ------------------------------------------------------------------------- --->

	<cffunction name="updatePlacementInformation" access="public" returntype="void" output="false" hint="Update placement information / Approval process must be separate">
        <cfargument name="studentID" hint="studentID is required">
        <cfargument name="hostID" hint="hostID is required">
        <cfargument name="isWelcomeFamily" default="0" hint="isWelcomeFamily is not required">
        <cfargument name="isRelocation" default="0" hint="isRelocation is not required">
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
			// Get Student Info
			var qGetStudentInfo = getStudentByID(studentID=ARGUMENTS.studentID);
			
			// Set this to 1 if only second visit is updated
			var vIsOnlySecondVisitRepUpdated = 0;
			
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
				changedBy = ARGUMENTS.changedBy,
				userType = ARGUMENTS.userType,
				placementStatus = ARGUMENTS.placementStatus
			);
			
			if ( ARGUMENTS.userType EQ 5 ) {
			
				// Placement status shouldn't change when a RM updates only a second visit rep
				if (
						ARGUMENTS.hostID EQ qGetStudentInfo.hostID
					AND
						ARGUMENTS.schoolID EQ qGetStudentInfo.schoolID
					AND
						ARGUMENTS.placeRepID EQ qGetStudentInfo.placeRepID
					AND
						ARGUMENTS.areaRepID EQ qGetStudentInfo.areaRepID
					AND
						ARGUMENTS.doublePlace EQ qGetStudentInfo.doublePlace
					AND
						ARGUMENTS.secondVisitRepID NEQ qGetStudentInfo.secondVisitRepID ) {
					
					// Do not reset status
					vIsOnlySecondVisitRepUpdated = 1;
					
				}
				
			}		
		</cfscript>
		
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
                    doublePlace = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.doublePlace)#">,
                    isWelcomeFamily = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(ARGUMENTS.isWelcomeFamily)#">,
					
					<!--- Area Representative | Reset status to 7 --->
                    <cfif ARGUMENTS.userType EQ 7>
                        host_fam_approved = <cfqueryparam cfsqltype="cf_sql_integer" value="7">,
                    
					<!--- Regional Advisor | If current status > usertype, set status back for approval --->
					<cfelseif ARGUMENTS.userType EQ 6 AND listFind("1,2,3,4,5", qGetStudentInfo.host_fam_approved)>
                        host_fam_approved = <cfqueryparam cfsqltype="cf_sql_integer" value="6">,
					
					<!--- Regional Manager | If current status > usertype, set status back for approval --->
					<cfelseif ARGUMENTS.userType EQ 5 AND listFind("1,2,3,4", qGetStudentInfo.host_fam_approved) AND NOT VAL(vIsOnlySecondVisitRepUpdated)>
                        host_fam_approved = <cfqueryparam cfsqltype="cf_sql_integer" value="5">,
					
					<!--- Office | Reset status if changing hostID or SchoolID --->
                    <cfelseif 
						ListFind("1,2,3,4", ARGUMENTS.userType) <!--- Office User --->
					AND
						(
						 	qGetStudentInfo.hostID NEQ ARGUMENTS.hostID <!--- HF Changed --->
						OR	
							qGetStudentInfo.schoolID NEQ ARGUMENTS.schoolID <!--- School Changed --->
						)
					>
                        host_fam_approved = <cfqueryparam cfsqltype="cf_sql_integer" value="5">,
                    
					</cfif>
                    
                    <!--- Used to track last approval --->
                    date_host_fam_approved = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				WHERE
                	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">
		</cfquery>
        
        <cfscript>
			/*********************************************************
				Double Placement - Automatically assign/remove/update
			*********************************************************/
			
			/*********************************************************
				Add New Double Placement
			**********************************************************/
			if ( VAL(ARGUMENTS.doublePlace) AND NOT VAL(qGetStudentInfo.doublePlace) ) {
				
                // Insert-Update Placement History
                insertPlacementHistory(
					studentID = ARGUMENTS.doublePlace,					   
					doublePlace = ARGUMENTS.studentID,
					doublePlaceReason = 'Double placement automatically assigned',
					changedBy = ARGUMENTS.changedBy,
					userType = ARGUMENTS.userType,
					placementAction='setDoublePlacement'
				);
				
				// Update Double Placement Record on the second record
				updateDoublePlacement(
					studentID = ARGUMENTS.doublePlace,					   
					doublePlace = ARGUMENTS.studentID,
					userType = ARGUMENTS.userType
				);

			/*********************************************************
				Double Placement Assigned to a Different Student 
				Remove previous and add new double placement
			**********************************************************/
			} else if ( VAL(ARGUMENTS.doublePlace) AND ARGUMENTS.doublePlace NEQ qGetStudentInfo.doublePlace ) {
				
				/*********************************************************
					Remove Double Placement
				**********************************************************/

                // Insert-Update Placement History
                insertPlacementHistory(
					studentID = qGetStudentInfo.doublePlace,					   
					doublePlace = 0,
					doublePlaceReason = 'Double placement student assigned to a different student - automatically removed',
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
			
				/*********************************************************
					Add New Double Placement
				**********************************************************/
				
                // Insert-Update Placement History
                insertPlacementHistory(
					studentID = ARGUMENTS.doublePlace,					   
					doublePlace = ARGUMENTS.studentID,
					doublePlaceReason = 'Double placement automatically assigned',
					changedBy = ARGUMENTS.changedBy,
					userType = ARGUMENTS.userType,
					placementAction='setDoublePlacement'
				);
				
				// Update Double Placement Record on the second record
				updateDoublePlacement(
					studentID = ARGUMENTS.doublePlace,					   
					doublePlace = ARGUMENTS.studentID,
					userType = ARGUMENTS.userType
				);

			/*********************************************************
				Remove Double Placement
			**********************************************************/
			} else if ( NOT VAL(ARGUMENTS.doublePlace) AND VAL(qGetStudentInfo.doublePlace) ) {
				
                // Insert-Update Placement History
                insertPlacementHistory(
					studentID = qGetStudentInfo.doublePlace,					   
					doublePlace = 0,
					doublePlaceReason = 'Double placement automatically removed',
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
	
	</cffunction>


	<cffunction name="updateDoublePlacement" access="public" returntype="void" output="false" hint="Updates a Double Placement Record">
        <cfargument name="studentID" hint="studentID is required">
		<cfargument name="doublePlace" hint="doublePlace ID is required">
        <cfargument name="userType" hint="userType is required">

			<cfscript>
                // Get Student Info
                var qGetStudentInfo = getStudentByID(studentID=ARGUMENTS.studentID);				
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
                    host_fam_approved = <cfqueryparam cfsqltype="cf_sql_bit" value="10">,
                    date_host_fam_approved = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    datePlaced = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    datePISEmailed = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    <!--- Placement Notes --->
                    placement_notes = <cfqueryparam cfsqltype="cf_sql_varchar" value="no">,
					<!--- Single Placement Paperwork --->
                    doc_single_place_auth = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    doc_single_ref_form_1 = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    doc_single_ref_check1 = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,	
                    doc_single_ref_form_2 = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    doc_single_ref_check2 = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
					<!--- Paperwork Received --->
                    date_pis_received = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    doc_full_host_app_date = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    doc_letter_rec_date = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    doc_rules_rec_date = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    doc_photos_rec_date = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    doc_school_profile_rec = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    doc_conf_host_rec = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    doc_date_of_visit = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    doc_conf_host_rec2 = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    doc_date_of_visit2 = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    doc_ref_form_1 = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    doc_ref_check1 = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    doc_ref_form_2 = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    doc_ref_check2 = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    doc_income_ver_date = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    <!--- Arrival Date Compliance --->
                    doc_school_accept_date = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    doc_school_sign_date = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    <!--- Student Application --->
                    copy_app_school = <cfqueryparam cfsqltype="cf_sql_varchar" value="no">,
                	<!--- Arrival Orientation --->
                    <!--- stu_arrival_orientation = <cfqueryparam cfsqltype="cf_sql_date" null="yes">, | should never reset --->
                    host_arrival_orientation = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    doc_class_schedule = <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                WHERE 
                	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">
    	</cfquery>
        
		<cfscript>
			// Insert History - It tracks placement statuses only, placement updates are tracked on smg_hostHistory
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
        
    </cffunction>

	
    <!--- Approve Placement --->
	<cffunction name="approvePlacement" access="public" returntype="void" output="false" hint="Approves a placement">
        <cfargument name="studentID" hint="studentID is required">
        <cfargument name="changedBy" hint="changedBy is required">
        <cfargument name="userType" hint="userType is required">
        <cfargument name="reason" default="" hint="reason is not required">

        <cfscript>
			// Get Student Info
			var qGetStudentInfo = getStudentByID(studentID=ARGUMENTS.studentID);
			
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
        
        <!--- Set Placement Date on the history if Approved by Headquarters - Only first time approval--->
        <cfif VAL(vUpdateDatePlaced)>
        	
            <cfscript>
				// Get History ID
				vHostHistoryID = getPlacementHistory(studentID=ARGUMENTS.studentID).historyID;
			</cfscript>
            
            <cfquery 
                datasource="#APPLICATION.DSN#">
                    UPDATE
                        smg_hostHistory
                    SET
                        dateplaced = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    WHERE
                        historyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(vHostHistoryID)#">
            </cfquery>
            
        </cfif>
        
		<cfscript>
            /*** Holding it for now as per Brian Hause request - 06/02/2011 ****/
            // Assign Pre-AYP English Camp based on host family state	
            // APPLICATION.CFC.STUDENT.assignEnglishCamp(studentID=CLIENT.studentID);
			
			// Insert New History - It tracks placement statuses only, placement updates are tracked on smg_hostHistory
			insertPlacementActionHistory(
				studentID=ARGUMENTS.studentID,
				changedBy=ARGUMENTS.changedBy,
				userType=ARGUMENTS.userType,
				placementAction='Approve'
			);
        </cfscript>
        
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
			// Insert New History - It tracks placement statuses only, placement updates are tracked on smg_hostHistory
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
			// Insert New History - It tracks placement statuses only, placement updates are tracked on smg_hostHistory
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
			
			vHostHistoryID = getPlacementHistory(studentID=ARGUMENTS.studentID).historyID;			
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
                    dateSetHostPermanent = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.dateSetHostPermanent#">
                WHERE
                    historyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(vHostHistoryID)#">
        </cfquery>
        
		<cfscript>
			// Insert New History - It tracks placement statuses only, placement updates are tracked on smg_hostHistory
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
        <cfargument name="placementAction" default="" hint="Approve/Reject/Resubmit/unplaceStudent/setFamilyAsPermanent">
        <cfargument name="dateSetHostPermanent" default="" hint="dateSetHostPermanent is not required">
	
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
			vHostHistoryID = getPlacementHistory(studentID=ARGUMENTS.studentID).historyID;
				
			if ( VAL(vHostHistoryID) ) {
				
				// Insert Actions Into Separate Table
				APPLICATION.CFC.LOOKUPTABLES.insertApplicationHistory(
					applicationID=APPLICATION.CONSTANTS.TYPE.EXITS,
					foreignTable='smg_hostHistory',
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
			
			// Set whether we are updating or inserting a record
			var vQueryType = '';
			
			// Set Action Message
			var vUpdatedBy = 'n/a';
			var vActions = '';			
			
			var hasHostIDChanged = 0;
			var hasSchoolIDChanged = 0;
			var hasPlaceRepIDChanged = 0;
			var hasAreaRepIDChanged = 0;
			var hasSecondVisitRepIDChanged = 0;
			var hasDoublePlacementIDChanged = 0;

			// Set to 1 to add an extra line on the history
			var vAddExtraLine = 0;
			
			// Get Current Placement Information
			qGetStudentInfo = getStudentByID(studentID=ARGUMENTS.studentID);

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
				vActions = vActions & "<strong>New Placement Information - Pending HQ Approval</strong> <br /> #CHR(13)#";
				
				// Welcome Family Information
				if ( VAL(ARGUMENTS.isWelcomeFamily) ) {
					vActions = vActions & "This is a welcome family <br /> #CHR(13)#";
				}
			
			// STUDENT IS PLACED - CHECK FOR UPDATES
			} else {

				// Host Family
				if ( VAL(ARGUMENTS.hostID) AND VAL(qGetStudentInfo.hostID) AND qGetStudentInfo.hostID NEQ ARGUMENTS.hostID ) {
					vQueryType = 'insert';
					vAddExtraLine = 1;
					hasHostIDChanged = 1;
					
					// Start building record
					vActions = vActions & "<strong>New Placement Information - Pending HQ Approval</strong> <br /> #CHR(13)#";
					
					// Add Message if info has been updated
					if ( VAL(qGetStudentInfo.hostID) ) {
						vActions = vActions & "<strong>Host Family Updated</strong> <br /> #CHR(13)#";
					}
	
					if ( VAL(ARGUMENTS.isWelcomeFamily) ) {
						vActions = vActions & "<strong>This is a welcome family</strong> <br /> #CHR(13)#";
					}
	
					if ( VAL(ARGUMENTS.isRelocation) ) {
						vActions = vActions & "<strong>This is a relocation</strong> <br /> #CHR(13)#";
					}

					if ( VAL(ARGUMENTS.changePlacementReasonID) ) {						
						vActions = vActions & "Reason: #APPLICATION.CFC.LOOKUPTABLES.getApplicationLookUp(applicationID=1,fieldKey='changePlacementReason',fieldID=ARGUMENTS.changePlacementReasonID).name# <br /> #CHR(13)#";
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
					
					vQueryType = 'update';
					vAddExtraLine = 1;
					hasSchoolIDChanged = 1;
					
					// Add Message if info has been updated
					if ( VAL(qGetStudentInfo.schoolID) ) {
						vActions = vActions & "<strong>School Updated - Pending HQ Approval</strong> <br /> #CHR(13)#";
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
					vQueryType = 'update';
					vAddExtraLine = 1;
					hasPlaceRepIDChanged = 1;

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
					vQueryType = 'update';
					vAddExtraLine = 1;
					hasAreaRepIDChanged = 1;

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
					vQueryType = 'update';
					vAddExtraLine = 1;
					hasSecondVisitRepIDChanged = 1;

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
					vQueryType = 'update';
					vAddExtraLine = 1;
					hasSecondVisitRepIDChanged = 1;
					
					vActions = vActions & "<strong>2<sup>nd</sup> Representative Visit Added</strong> <br /> #CHR(13)#";

				}

				// Add Extra Line
				if ( VAl(vAddExtraLine) ) {
					vActions = vActions & "<br /> #CHR(13)#";
					vAddExtraLine = 0;
				}
				
				// Update Double Placement 
				if ( VAL(qGetStudentInfo.doublePlace) AND VAL(ARGUMENTS.doublePlace) AND qGetStudentInfo.doublePlace NEQ ARGUMENTS.doublePlace ) {
					vQueryType = 'update';
					vAddExtraLine = 1;
					hasDoublePlacementIDChanged = 1;

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
					vQueryType = 'update';
					vAddExtraLine = 1;
					hasDoublePlacementIDChanged = 1;

					vActions = vActions & "<strong>Double Placement Added</strong> <br /> #CHR(13)#";

					if ( ARGUMENTS.placementAction EQ 'setDoublePlacement' AND LEN(ARGUMENTS.doublePlaceReason) ) {
						// Automatically Assigned Message
						vActions = vActions & "Message: #ARGUMENTS.doublePlaceReason# <br /> #CHR(13)#";
					} else if ( LEN(ARGUMENTS.doublePlaceReason) ) {
						vActions = vActions & "Reason: #ARGUMENTS.doublePlaceReason# <br /> #CHR(13)#";
					}

				// Remove Double Placement	
				} else if ( ARGUMENTS.placementStatus NEQ 'Approved' AND VAL(qGetStudentInfo.doublePlace) AND NOT VAL(ARGUMENTS.doublePlace) ) {
					vQueryType = 'update';
					vAddExtraLine = 1;
					hasDoublePlacementIDChanged = 1;
					
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
        
        <!--- School Updated | Reset Fields on the Student Table --->
        <cfif VAL(hasSchoolIDChanged)>
        
            <cfquery 
                datasource="#APPLICATION.DSN#">
					UPDATE
                    	smg_students
                    SET
						<!--- Arrival Date Compliance --->
                        doc_school_accept_date = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                        doc_school_sign_date = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                        <!--- Student Application --->
                        copy_app_school = <cfqueryparam cfsqltype="cf_sql_varchar" value="no">,
                        doc_class_schedule = <cfqueryparam cfsqltype="cf_sql_date" null="yes">
	            	WHERE
    					studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">
			</cfquery>
        
        </cfif>
        
        
		<!--- Insert History Information --->
        <cfif vQueryType EQ 'insert'>        
            
            <!--- Host Family Updated | Reset Fields on the Student Table --->
            <cfquery 
                datasource="#APPLICATION.DSN#">
					UPDATE
                    	smg_students
                    SET
                        host_fam_approved = <cfqueryparam cfsqltype="cf_sql_bit" value="10">,
                        date_host_fam_approved = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                        datePlaced = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                        datePISEmailed = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
						<!--- Placement Notes --->
                        placement_notes = <cfqueryparam cfsqltype="cf_sql_varchar" value="no">,
                        <!--- Single Placement Paperwork --->
                        doc_single_place_auth = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                        doc_single_ref_form_1 = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                        doc_single_ref_check1 = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,	
                        doc_single_ref_form_2 = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                        doc_single_ref_check2 = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                        <!--- Paperwork Received --->
                        date_pis_received = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                        doc_full_host_app_date = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                        doc_letter_rec_date = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                        doc_rules_rec_date = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                        doc_photos_rec_date = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                        doc_school_profile_rec = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                        doc_conf_host_rec = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                        doc_date_of_visit = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                        doc_conf_host_rec2 = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                        doc_date_of_visit2 = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                        doc_ref_form_1 = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                        doc_ref_check1 = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                        doc_ref_form_2 = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                        doc_ref_check2 = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                        doc_income_ver_date = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                        <!--- Arrival Orientation --->
                        <!--- stu_arrival_orientation = <cfqueryparam cfsqltype="cf_sql_date" null="yes">, | should never reset --->
                        host_arrival_orientation = <cfqueryparam cfsqltype="cf_sql_date" null="yes">
	            	WHERE
    					studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">
			</cfquery>
            
            <cfscript>
				// Set Old Records to Inactive
				setHostHistoryInactive(studentID=ARGUMENTS.studentID);	
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
                        dateOfChange, 
                        reason,
                        isActive,
                        dateCreated
                    )
                    VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(hasHostIDChanged)#">, 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.changePlacementReasonID)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.changePlacementExplanation#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.schoolID)#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(hasSchoolIDChanged)#">,   
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.placeRepID)#">, 
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(hasPlaceRepIDChanged)#">, 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.areaRepID)#">, 
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(hasAreaRepIDChanged)#">, 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.secondVisitRepID)#">, 
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(hasSecondVisitRepIDChanged)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.doublePlace)#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(hasDoublePlacementIDChanged)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.changedBy)#">, 
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(ARGUMENTS.isWelcomeFamily)#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(ARGUMENTS.isRelocation)#">, 
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#vActions#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="1">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
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
            
        </cfif>
        
		<cfscript>
			if ( NOT VAL(vHostHistoryID) ) {
				// Get Current History
				vHostHistoryID = getPlacementHistory(studentID=ARGUMENTS.studentID).historyID;
			}
				
			if ( LEN(vQueryType) ) {
				
				// Insert Actions Into Separate Table
				APPLICATION.CFC.LOOKUPTABLES.insertApplicationHistory(
					applicationID=APPLICATION.CONSTANTS.TYPE.EXITS,
					foreignTable='smg_hostHistory',
					foreignID=vHostHistoryID,
					enteredByID=VAL(ARGUMENTS.changedBy),
					actions=vActions
				);			
		
			}
			
			// Insert Placement Log History
			
			// Insert Host ID Track
			if ( VAL(hasHostIDChanged) AND VAL(ARGUMENTS.hostID) ) {

				insertPlacementTracking(
					historyID=vHostHistoryID,
					studentID=ARGUMENTS.studentID,
					fieldName='hostID',
					fieldID=ARGUMENTS.hostID
				);
			
			}
			
			// Insert School ID Track
			if ( VAL(hasSchoolIDChanged) AND VAL(ARGUMENTS.schoolID) ) {

				insertPlacementTracking(
					historyID=vHostHistoryID,
					studentID=ARGUMENTS.studentID,
					fieldName='schoolID',
					fieldID=ARGUMENTS.schoolID
				);
			
			}
			
			// Insert Place Rep ID Track
			if ( VAL(hasPlaceRepIDChanged) AND VAL(ARGUMENTS.placeRepID) ) {

				insertPlacementTracking(
					historyID=vHostHistoryID,
					studentID=ARGUMENTS.studentID,
					fieldName='placeRepID',
					fieldID=ARGUMENTS.placeRepID
				);
			
			}
			
			// Insert Area Rep ID Track
			if ( VAL(hasAreaRepIDChanged) AND VAL(ARGUMENTS.areaRepID) ) {

				insertPlacementTracking(
					historyID=vHostHistoryID,
					studentID=ARGUMENTS.studentID,
					fieldName='areaRepID',
					fieldID=ARGUMENTS.areaRepID
				);
			
			}
			
			// Insert Second Visit Rep Track
			if ( VAL(hasSecondVisitRepIDChanged) AND VAL(ARGUMENTS.secondVisitRepID) ) {

				insertPlacementTracking(
					historyID=vHostHistoryID,
					studentID=ARGUMENTS.studentID,
					fieldName='secondVisitRepID',
					fieldID=ARGUMENTS.secondVisitRepID
				);
			
			}
			
			// Insert Double Placement Track
			if ( VAL(hasDoublePlacementIDChanged) AND VAL(ARGUMENTS.doublePlace) ) {

				insertPlacementTracking(
					historyID=vHostHistoryID,
					studentID=ARGUMENTS.studentID,
					fieldName='doublePlacementID',
					fieldID=ARGUMENTS.doublePlace
				);
			
			}
		</cfscript> 
        
        <!--- Update History if not doing any of these actions below (they do not require a history update except setDoublePlacement which is updated outside the history function) --->
        <cfif ARGUMENTS.placementAction NEQ 'setDoublePlacement' AND vQueryType EQ 'update'>

            <cfquery 
                datasource="#APPLICATION.DSN#">
                    UPDATE
                        smg_hosthistory	
                    SET
						<cfif VAL(hasSchoolIDChanged)>
                        	hasSchoolIDChanged = <cfqueryparam cfsqltype="cf_sql_bit" value="#hasSchoolIDChanged#">,                
                        </cfif>
                        
                        <cfif VAL(hasPlaceRepIDChanged)>
                        	hasPlaceRepIDChanged = <cfqueryparam cfsqltype="cf_sql_bit" value="#hasPlaceRepIDChanged#">,
                        </cfif>
                        
                        <cfif VAL(hasAreaRepIDChanged)>
                        	hasAreaRepIDChanged = <cfqueryparam cfsqltype="cf_sql_bit" value="#hasAreaRepIDChanged#">,
                        </cfif>
                        
                        <cfif VAL(hasSecondVisitRepIDChanged)>
                        	hasSecondVisitRepIDChanged = <cfqueryparam cfsqltype="cf_sql_bit" value="#hasSecondVisitRepIDChanged#">,
                        </cfif>
                        
                        <cfif VAL(hasDoublePlacementIDChanged)>
                        	hasDoublePlacementIDChanged = <cfqueryparam cfsqltype="cf_sql_bit" value="#hasDoublePlacementIDChanged#">,
                       	</cfif> 

                        schoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.schoolID)#">,  
                        placeRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.placeRepID)#">,
                        areaRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.areaRepID)#">,
                        secondVisitRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.secondVisitRepID)#">,
                        doublePlacementID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.doublePlace)#">
                    WHERE
                        historyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(vHostHistoryID)#">
            </cfquery>
        
		</cfif>
                
	</cffunction>


	<!--- INSERT FLIGHT --->
	<cffunction name="insertPlacementTracking" access="public" returntype="void" output="false" hint="Inserts Placement Tracking to the log">
    	<cfargument name="historyID" hint="historyID is required">
        <cfargument name="studentID" hint="studentID is required">
        <cfargument name="fieldName" default="0" hint="fieldName is not required">
        <cfargument name="fieldID" default="0" hint="fieldID is not required">
		
        <cfquery 
			datasource="#APPLICATION.DSN#">
                INSERT INTO 
                    smg_hostHistoryTracking
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

	</cffunction>

	
    <!--- Set Old Host History Records as Inactive --->
	<cffunction name="setHostHistoryInactive" access="public" returntype="void" output="false" hint="Set Old Host History Records as Inactive">
    	<cfargument name="studentID" hint="studentID is required">

            <cfquery 
                datasource="#APPLICATION.DSN#">
                	UPDATE
                    	smg_hostHistory
                    SET
                    	isActive = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                    WHERE
                    	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">
			</cfquery>                    
    </cffunction>
    

	<!--- Get Placement History --->
	<cffunction name="getPlacementHistory" access="public" returntype="query" output="false" hint="Returns placement history">
    	<cfargument name="studentID" hint="studentID is required">
        
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
                    h.reason,
                    h.actions,
                    h.datePlaced,
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
                    DP.firstName AS doublePlacementFirstName,
                    DP.familyLastName AS doublePlacementLastName,
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
                	smg_students DP ON h.doublePlacementID = DP.studentID   
                LEFT JOIN 
                    smg_users user ON h.changedby = user.userID
                WHERE 
                    h.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">
                ORDER BY 
                    h.dateCreated DESC, 
                    h.historyid DESC
        </cfquery>
                
        <cfreturn qGetPlacementHistory>
    </cffunction>


	<!--- Get Placement History --->
	<cffunction name="getHostHistoryByID" access="public" returntype="query" output="false" hint="Returns placement history">
    	<cfargument name="studentID" hint="studentID is required">
        <cfargument name="historyID" hint="historyID is required">
        
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
                    reason,
                    changePlacementReasonID,
                    changePlacementExplanation,
                    datePlaced,
                    datePISEmailed,
                    dateSetHostPermanent,
                    <!--- Single Person Placement Paperwork --->
                    doc_single_place_auth,
					doc_single_ref_form_1,
                    doc_single_ref_check1,
                    doc_single_ref_form_2,
					doc_single_ref_check2,
                    <!--- Placement Paperwork --->
                    date_pis_received,
                    doc_full_host_app_date,
                    doc_letter_rec_date,
                    doc_rules_rec_date,
                    doc_photos_rec_date,
                    doc_school_profile_rec,
                    doc_conf_host_rec,
                    doc_date_of_visit,
                    <!---
                    doc_conf_host_rec2,
                    doc_date_of_visit2,
					--->
                    doc_ref_form_1,
                    doc_ref_check1,
                    doc_ref_form_2,
                    doc_ref_check2,
                    doc_host_orientation,
                    doc_income_ver_date,
                    <!--- Arrival Compliance --->
                    doc_school_accept_date,
                    doc_school_sign_date,
                    <!--- Student Application --->
                    copy_app_school,
                    <!--- Arrival Orientation --->
                    stu_arrival_orientation,
                    host_arrival_orientation,
                    doc_class_schedule,
                    actions,
                    dateOfChange,
                    dateCreated,
                    dateUpdated
                FROM 
                    smg_hosthistory
                WHERE 
                    historyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.historyID)#">
                AND
                	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">
        </cfquery>
                
        <cfreturn qGetHostHistoryByID>
    </cffunction>
    

	<!--- Placement Paperwork --->
	<cffunction name="updatePlacementPaperwork" access="public" returntype="void" output="false" hint="Update Placement Paperwork">
        <cfargument name="studentID" default="0" hint="studentID is not required">
        <cfargument name="historyID" default="0" hint="historyID is not required">
		<!--- Single Person Placement --->
        <cfargument name="doc_single_place_auth" default="" hint="doc_single_place_auth is not required">
        <cfargument name="doc_single_ref_form_1" default="" hint="doc_single_ref_form_1 is not required">
        <cfargument name="doc_single_ref_check1" default="" hint="doc_single_ref_check1 is not required">
        <cfargument name="doc_single_ref_form_2" default="" hint="doc_single_ref_form_2 is not required">
        <cfargument name="doc_single_ref_check2" default="" hint="doc_single_ref_check2 is not required">
        <!--- Placement Paperwork --->
        <cfargument name="date_pis_received" default="" hint="date_pis_received is not required">
        <cfargument name="doc_full_host_app_date" default="" hint="doc_full_host_app_date is not required">
        <cfargument name="doc_letter_rec_date" default="" hint="doc_letter_rec_date is not required">
        <cfargument name="doc_rules_rec_date" default="" hint="doc_rules_rec_date is not required">
        <cfargument name="doc_photos_rec_date" default="" hint="doc_photos_rec_date is not required">
        <cfargument name="doc_school_profile_rec" default="" hint="doc_school_profile_rec is not required">
        <cfargument name="doc_conf_host_rec" default="" hint="doc_conf_host_rec is not required">
        <cfargument name="doc_date_of_visit" default="" hint="doc_date_of_visit is not required">
        <cfargument name="doc_conf_host_rec2" default="" hint="doc_conf_host_rec2 is not required">
        <cfargument name="doc_date_of_visit2" default="" hint="doc_date_of_visit2 is not required">
        <cfargument name="doc_ref_form_1" default="" hint="doc_ref_form_1 is not required">
        <cfargument name="doc_ref_check1" default="" hint="doc_ref_check1 is not required">
        <cfargument name="doc_ref_form_2" default="" hint="doc_ref_form_2 is not required">
        <cfargument name="doc_ref_check2" default="" hint="doc_ref_check2 is not required">
        <cfargument name="doc_income_ver_date" default="" hint="doc_income_ver_date is not required">
        <!--- Arrival Compliance --->
        <cfargument name="doc_school_accept_date" default="" hint="doc_school_accept_date is not required">
        <cfargument name="doc_school_sign_date" default="" hint="doc_school_sign_date is not required">
        <!--- Student Application --->
        <cfargument name="copy_app_school" default="" hint="copy_app_school is not required">
        <!--- Arrival Orientation --->
        <cfargument name="stu_arrival_orientation" default="" hint="stu_arrival_orientation is not required">
        <cfargument name="host_arrival_orientation" default="" hint="host_arrival_orientation is not required">
        <cfargument name="doc_class_schedule" default="" hint="doc_class_schedule is not required">    
        		
        <cfquery 
			datasource="#APPLICATION.DSN#">
                UPDATE
	                smg_students
                SET 
                    <!--- Single Person Placement Paperwork --->
                    doc_single_place_auth = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_single_place_auth#" null="#NOT IsDate(ARGUMENTS.doc_single_place_auth)#">,
                    doc_single_ref_form_1 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_single_ref_form_1#" null="#NOT IsDate(ARGUMENTS.doc_single_ref_form_1)#">,
                    doc_single_ref_check1 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_single_ref_check1#" null="#NOT IsDate(ARGUMENTS.doc_single_ref_check1)#">,
                    doc_single_ref_form_2 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_single_ref_form_2#" null="#NOT IsDate(ARGUMENTS.doc_single_ref_form_2)#">,
                    doc_single_ref_check2 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_single_ref_check2#" null="#NOT IsDate(ARGUMENTS.doc_single_ref_check2)#">,
                    <!--- Placement Paperwork --->
                    date_pis_received = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.date_pis_received#" null="#NOT IsDate(ARGUMENTS.date_pis_received)#">,
                    doc_full_host_app_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_full_host_app_date#" null="#NOT IsDate(ARGUMENTS.doc_full_host_app_date)#">,
                    doc_letter_rec_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_letter_rec_date#" null="#NOT IsDate(ARGUMENTS.doc_letter_rec_date)#">,
                    doc_rules_rec_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_rules_rec_date#" null="#NOT IsDate(ARGUMENTS.doc_rules_rec_date)#">,
                    doc_photos_rec_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_photos_rec_date#" null="#NOT IsDate(ARGUMENTS.doc_photos_rec_date)#">,
                    doc_school_profile_rec = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_school_profile_rec#" null="#NOT IsDate(ARGUMENTS.doc_school_profile_rec)#">,
                    doc_conf_host_rec = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_conf_host_rec#" null="#NOT IsDate(ARGUMENTS.doc_conf_host_rec)#">,
                    doc_date_of_visit = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_date_of_visit#" null="#NOT IsDate(ARGUMENTS.doc_date_of_visit)#">,
                    doc_conf_host_rec2 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_conf_host_rec2#" null="#NOT IsDate(ARGUMENTS.doc_conf_host_rec2)#">,
                    doc_date_of_visit2 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_date_of_visit2#" null="#NOT IsDate(ARGUMENTS.doc_date_of_visit2)#">,
                    doc_ref_form_1 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_ref_form_1#" null="#NOT IsDate(ARGUMENTS.doc_ref_form_1)#">,
                    doc_ref_check1 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_ref_check1#" null="#NOT IsDate(ARGUMENTS.doc_ref_check1)#">,
                    doc_ref_form_2 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_ref_form_2#" null="#NOT IsDate(ARGUMENTS.doc_ref_form_2)#">,
                    doc_ref_check2 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_ref_check2#" null="#NOT IsDate(ARGUMENTS.doc_ref_check2)#">,
                    doc_income_ver_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_income_ver_date#" null="#NOT IsDate(ARGUMENTS.doc_income_ver_date)#">,
                    <!--- Arrival Compliance --->
                    doc_school_accept_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_school_accept_date#" null="#NOT IsDate(ARGUMENTS.doc_school_accept_date)#">,
                    doc_school_sign_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_school_sign_date#" null="#NOT IsDate(ARGUMENTS.doc_school_sign_date)#">,
					<!--- Student Application --->
                    copy_app_school = <cfqueryparam cfsqltype="cf_sql_varchar" value="#YesNoFormat(VAL(ARGUMENTS.copy_app_school))#">,
					<!--- Arrival Orientation --->
                    stu_arrival_orientation = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.stu_arrival_orientation#" null="#NOT IsDate(ARGUMENTS.stu_arrival_orientation)#">,
                    host_arrival_orientation = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.host_arrival_orientation#" null="#NOT IsDate(ARGUMENTS.host_arrival_orientation)#">,
                    doc_class_schedule = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_class_schedule#" null="#NOT IsDate(ARGUMENTS.doc_class_schedule)#">
                WHERE 
                    studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">                    	
		</cfquery>
		
        <cfscript>
			// Update Placement History
			updatePlacementPaperworkHistory(
				studentID = ARGUMENTS.studentID,
				historyID = ARGUMENTS.historyID,
				// Single Person Placement Paperwork
				doc_single_place_auth = ARGUMENTS.doc_single_place_auth,
				doc_single_ref_form_1 = ARGUMENTS.doc_single_ref_form_1,
				doc_single_ref_check1 = ARGUMENTS.doc_single_ref_check1,
				doc_single_ref_form_2 = ARGUMENTS.doc_single_ref_form_2,
				doc_single_ref_check2 = ARGUMENTS.doc_single_ref_check2,
				// Placement Paperwork
				date_pis_received = ARGUMENTS.date_pis_received,
				doc_full_host_app_date = ARGUMENTS.doc_full_host_app_date,
				doc_letter_rec_date = ARGUMENTS.doc_letter_rec_date,
				doc_rules_rec_date = ARGUMENTS.doc_rules_rec_date,
				doc_photos_rec_date = ARGUMENTS.doc_photos_rec_date,
				doc_school_profile_rec = ARGUMENTS.doc_school_profile_rec,
				doc_conf_host_rec = ARGUMENTS.doc_conf_host_rec,
				doc_date_of_visit = ARGUMENTS.doc_date_of_visit,
				doc_conf_host_rec2 = ARGUMENTS.doc_conf_host_rec2,
				doc_date_of_visit2 = ARGUMENTS.doc_date_of_visit2,
				doc_ref_form_1 = ARGUMENTS.doc_ref_form_1,
				doc_ref_check1 = ARGUMENTS.doc_ref_check1,
				doc_ref_form_2 = ARGUMENTS.doc_ref_form_2,
				doc_ref_check2 = ARGUMENTS.doc_ref_check2,
				doc_income_ver_date = ARGUMENTS.doc_income_ver_date,
				// Arrival Compliance
				doc_school_accept_date = ARGUMENTS.doc_school_accept_date,
				doc_school_sign_date = ARGUMENTS.doc_school_sign_date,
				// Original Student
				copy_app_school = ARGUMENTS.copy_app_school,
				// Arrival Orientation
				stu_arrival_orientation = ARGUMENTS.stu_arrival_orientation,
				host_arrival_orientation = ARGUMENTS.host_arrival_orientation,
				doc_class_schedule = ARGUMENTS.doc_class_schedule
			);
		</cfscript>
        
	</cffunction>


	<cffunction name="updatePlacementPaperworkHistory" access="public" returntype="void" output="false" hint="Update Placement Paperwork">
        <cfargument name="studentID" default="0" hint="studentID is not required">
        <cfargument name="historyID" default="0" hint="historyID is not required">
		<!--- Single Person Placement --->
        <cfargument name="doc_single_place_auth" default="" hint="doc_single_place_auth is not required">
        <cfargument name="doc_single_ref_form_1" default="" hint="doc_single_ref_form_1 is not required">
        <cfargument name="doc_single_ref_check1" default="" hint="doc_single_ref_check1 is not required">
        <cfargument name="doc_single_ref_form_2" default="" hint="doc_single_ref_form_2 is not required">
        <cfargument name="doc_single_ref_check2" default="" hint="doc_single_ref_check2 is not required">
        <!--- Placement Paperwork --->
        <cfargument name="date_pis_received" default="" hint="date_pis_received is not required">
        <cfargument name="doc_full_host_app_date" default="" hint="doc_full_host_app_date is not required">
        <cfargument name="doc_letter_rec_date" default="" hint="doc_letter_rec_date is not required">
        <cfargument name="doc_rules_rec_date" default="" hint="doc_rules_rec_date is not required">
        <cfargument name="doc_photos_rec_date" default="" hint="doc_photos_rec_date is not required">
        <cfargument name="doc_school_profile_rec" default="" hint="doc_school_profile_rec is not required">
        <cfargument name="doc_conf_host_rec" default="" hint="doc_conf_host_rec is not required">
        <cfargument name="doc_date_of_visit" default="" hint="doc_date_of_visit is not required">
        <cfargument name="doc_conf_host_rec2" default="" hint="doc_conf_host_rec2 is not required">
        <cfargument name="doc_date_of_visit2" default="" hint="doc_date_of_visit2 is not required">
        <cfargument name="doc_ref_form_1" default="" hint="doc_ref_form_1 is not required">
        <cfargument name="doc_ref_check1" default="" hint="doc_ref_check1 is not required">
        <cfargument name="doc_ref_form_2" default="" hint="doc_ref_form_2 is not required">
        <cfargument name="doc_ref_check2" default="" hint="doc_ref_check2 is not required">
        <cfargument name="doc_income_ver_date" default="" hint="doc_income_ver_date is not required">
        <!--- Arrival Compliance --->
        <cfargument name="doc_school_accept_date" default="" hint="doc_school_accept_date is not required">
        <cfargument name="doc_school_sign_date" default="" hint="doc_school_sign_date is not required">
        <!--- Student Application --->
        <cfargument name="copy_app_school" default="" hint="copy_app_school is not required">
        <!--- Arrival Orientation --->
        <cfargument name="stu_arrival_orientation" default="" hint="stu_arrival_orientation is not required">
        <cfargument name="host_arrival_orientation" default="" hint="host_arrival_orientation is not required">
        <cfargument name="doc_class_schedule" default="" hint="doc_class_schedule is not required">    
        
        <cfscript>
			// Get Current Placement Information
			qGetStudentInfo = getStudentByID(studentID=ARGUMENTS.studentID);
		</cfscript>
        
        <!--- Update Host History Documents --->
        <cfquery 
			datasource="#APPLICATION.DSN#">
                UPDATE
	                smg_hosthistory
                SET 
					datePlaced = <cfqueryparam cfsqltype="cf_sql_date" value="#qGetStudentInfo.datePlaced#" null="#NOT IsDate(qGetStudentInfo.datePlaced)#">,
                    datePISEmailed = <cfqueryparam cfsqltype="cf_sql_date" value="#qGetStudentInfo.datePISEmailed#" null="#NOT IsDate(qGetStudentInfo.datePISEmailed)#">,
					<!--- Single Person Placement Paperwork --->
                    doc_single_place_auth = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_single_place_auth#" null="#NOT IsDate(ARGUMENTS.doc_single_place_auth)#">,
                    doc_single_ref_form_1 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_single_ref_form_1#" null="#NOT IsDate(ARGUMENTS.doc_single_ref_form_1)#">,
                    doc_single_ref_check1 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_single_ref_check1#" null="#NOT IsDate(ARGUMENTS.doc_single_ref_check1)#">,
                    doc_single_ref_form_2 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_single_ref_form_2#" null="#NOT IsDate(ARGUMENTS.doc_single_ref_form_2)#">,
                    doc_single_ref_check2 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_single_ref_check2#" null="#NOT IsDate(ARGUMENTS.doc_single_ref_check2)#">,
                    <!--- Placement Paperwork --->
                    date_pis_received = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.date_pis_received#" null="#NOT IsDate(ARGUMENTS.date_pis_received)#">,
                    doc_full_host_app_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_full_host_app_date#" null="#NOT IsDate(ARGUMENTS.doc_full_host_app_date)#">,
                    doc_letter_rec_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_letter_rec_date#" null="#NOT IsDate(ARGUMENTS.doc_letter_rec_date)#">,
                    doc_rules_rec_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_rules_rec_date#" null="#NOT IsDate(ARGUMENTS.doc_rules_rec_date)#">,
                    doc_photos_rec_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_photos_rec_date#" null="#NOT IsDate(ARGUMENTS.doc_photos_rec_date)#">,
                    doc_school_profile_rec = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_school_profile_rec#" null="#NOT IsDate(ARGUMENTS.doc_school_profile_rec)#">,
                    doc_conf_host_rec = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_conf_host_rec#" null="#NOT IsDate(ARGUMENTS.doc_conf_host_rec)#">,
                    doc_date_of_visit = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_date_of_visit#" null="#NOT IsDate(ARGUMENTS.doc_date_of_visit)#">,
                    doc_conf_host_rec2 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_conf_host_rec2#" null="#NOT IsDate(ARGUMENTS.doc_conf_host_rec2)#">,
                    doc_date_of_visit2 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_date_of_visit2#" null="#NOT IsDate(ARGUMENTS.doc_date_of_visit2)#">,
                    doc_ref_form_1 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_ref_form_1#" null="#NOT IsDate(ARGUMENTS.doc_ref_form_1)#">,
                    doc_ref_check1 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_ref_check1#" null="#NOT IsDate(ARGUMENTS.doc_ref_check1)#">,
                    doc_ref_form_2 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_ref_form_2#" null="#NOT IsDate(ARGUMENTS.doc_ref_form_2)#">,
                    doc_ref_check2 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_ref_check2#" null="#NOT IsDate(ARGUMENTS.doc_ref_check2)#">,
                    doc_income_ver_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_income_ver_date#" null="#NOT IsDate(ARGUMENTS.doc_income_ver_date)#">,
                    <!--- Arrival Compliance --->
                    doc_school_accept_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_school_accept_date#" null="#NOT IsDate(ARGUMENTS.doc_school_accept_date)#">,
                    doc_school_sign_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_school_sign_date#" null="#NOT IsDate(ARGUMENTS.doc_school_sign_date)#">,
					<!--- Student Application --->
                    copy_app_school = <cfqueryparam cfsqltype="cf_sql_varchar" value="#YesNoFormat(VAL(ARGUMENTS.copy_app_school))#">,
					<!--- Arrival Orientation --->
                    stu_arrival_orientation = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.stu_arrival_orientation#" null="#NOT IsDate(ARGUMENTS.stu_arrival_orientation)#">,
                    host_arrival_orientation = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.host_arrival_orientation#" null="#NOT IsDate(ARGUMENTS.host_arrival_orientation)#">,
                    doc_class_schedule = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_class_schedule#" null="#NOT IsDate(ARGUMENTS.doc_class_schedule)#">
                WHERE 
                    historyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.historyID)#"> 
                AND
                    studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">                    	
		</cfquery>
        
	</cffunction>


	<cffunction name="checkPlacementPaperwork" access="public" returntype="string" output="false" hint="Check if placement paperwork was received by deadline">
        <cfargument name="studentID" default="0" hint="studentID is not required">
		<cfargument name="paymentTypeID" default="0" hint="Payment Type ID">
			
        <cfquery 
			name="qCheckPlacementPaperwork" 
			datasource="#APPLICATION.DSN#">
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
                    <!--- Single Person Placement Paperwork --->
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

				// 2nd Confidential Host Family Visit Form
				/*
				if ( NOT LEN(qCheckPlacementPaperwork.doc_conf_host_rec2) OR qCheckPlacementPaperwork.doc_conf_host_rec2 GT setDeadline ) {
					returnMessage = returnMessage & '2nd Confidential Host Family Visit Form has not been received or received after deadline - Date Received: #DateFormat(qCheckPlacementPaperwork.doc_conf_host_rec2, 'mm/dd/yyyy')#. <br />'; 	
				}
				*/
				
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
					
				} // Non-Traditional Placement - Extra Documents

			} // Check if we have a deadline
			
			return returnMessage;
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
                	smg_programs p ON p.programID = s.programID AND p.startDate < ADDDATE(now(), INTERVAL 145 DAY) <!--- Get only programs that are starting 145 days from now --->
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
                        s.companyid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )
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
                    studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#"> 
                
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
			
			// Set Up EmailTo and FlightInfo Link
            if ( ARGUMENTS.sendEmailTo EQ 'currentUser' AND IsValid("email", qGetCurrentUser.email) ) {
				
				// Public Student - Email Current User
				flightEmailTo = qGetCurrentUser.email;
			
			} else if ( APPLICATION.IsServerLocal ) {
				
				// Local Server - Always email support
                flightEmailTo = APPLICATION.EMAIL.support;
			
			} else if ( VAL(ARGUMENTS.isPHPStudent) ) {
            	
				// PHP Student - Email Luke
				flightInfoLink = 'http://www.phpusa.com/internal/index.cfm?curdoc=student/student_info&unqid=#qGetStudentFullInformation.uniqueID#';
                flightEmailTo = APPLICATION.EMAIL.PHPContact;				

			} else if ( ARGUMENTS.sendEmailTo EQ 'regionalManager' AND IsValid("email", qGetRegionalManager.email) AND IsValid("email", qGetCurrentUser.email) ) {
				
				// Public Student - Email Regional Manager and send a copy to the current user
				flightEmailTo = qGetRegionalManager.email;
				flightEmailCC = qGetCurrentUser.email;
                
            } else if ( ARGUMENTS.sendEmailTo EQ 'regionalManager' AND IsValid("email", qGetRegionalManager.email) ) {
				
				// Public Student - Email Regional Manager | Do not send a copy to current user
				flightEmailTo = qGetRegionalManager.email;

			} else if ( IsValid("email", qGetFacilitator.email) ) {
                
				// Public Student - Email Facilitator
                flightEmailTo = qGetFacilitator.email;
                
			} else {
				
				// Not a valid email, use support
                flightEmailTo = APPLICATION.EMAIL.support;
            
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
                            
                            <cfif ARGUMENTS.sendEmailTo NEQ 'regionalManager'>
	                            If it looks good, please feel free to forward to your regional manager.                                                      
                            </cfif>
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

                <cfif VAL(ARGUMENTS.isActive)>
                    AND 
                        s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
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