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
    	<cfargument name="studentID" default="" hint="studentID is not required">
        <cfargument name="uniqueID" default="" hint="uniqueID is not required">
    	<cfargument name="assignedID" default="" hint="assignedID is not required">
        <cfargument name="programID" default="" hint="programID is not required">
              
        <cfquery 
			name="qGetStudentByID" 
			datasource="#APPLICATION.dsn#">
                SELECT 
                	s.studentid, 
                    s.uniqueid, 
                    s.familylastname, 
                    s.firstname, 
                    s.middlename, 
                    s.fathersname, 
                    s.fatheraddress,
                    s.fatheraddress2, 
                    s.fathercity, 
                    s.fathercountry, 
                    s.fatherzip, 
                    s.fatherDOB, 
                    s.fathercompany, 
                    s.fatherworkphone,
                    s.fatherworkposition, 
                    s.fatherworktype, 
                    s.fatherenglish,
                    s.motherenglish, 
                    s.mothersname, 
                    s.motheraddress,
                    s.motheraddress2, 
                    s.mothercity, 
                    s.mothercountry,
                    s.motherzip,
                    s.motherDOB, 
                    s.mothercompany, 
                    s.motherworkphone,
                    s.motherworkposition, 
                    s.motherworktype, 
                    s.emergency_phone, 
                    s.emergency_name, 
                    s.emergency_address, 
                    s.emergency_country, 
                    s.address, 
                    s.address2, 
                    s.city, 
                    s.country, 
                    s.zip, 
                    s.phone, 
                    s.fax, 
                    s.email, 
                    s.citybirth,
                    s.countrybirth,
                    s.countryresident, 
                    s.countrycitizen, 
                    s.sex, 
                    s.dob, 
                    s.religiousaffiliation, 
                    s.dateapplication, 
                    s.entered_by,
                    s.passportnumber, 
                    s.intrep, 
                    s.current_state, 
                    s.approved, 
                    s.band, 
                    s.orchestra, 
                    s.comp_sports, 
                    s.cell_phone, 
                    s.additional_phone,
                    s.emergency_name, 
                    s.emergency_phone, 
                    s.convalidation_completed,
                    s.familyletter, 
                    s.pictures, 
                    s.interests, 
                    s.interests_other, 
                    s.religious_participation, 
                    s.churchfam, 
                    s.churchgroup,
                    s.smoke, 
                    s.animal_allergies, 
                    s.med_allergies, 
                    s.other_allergies, 
                    s.chores, 
                    s.chores_list, 
                    s.weekday_curfew, 
                    s.weekend_curfew, 
                    s.letter, height, 
                    s.weight, haircolor, 
                    s.eyecolor, graduated, 
                    s.direct_placement, 
                    s.direct_place_nature, 
                    s.termination_date, 
                    s.notes,
                    s.yearsenglish, 
                    s.estgpa, 
                    s.transcript, 
                    s.language_eval, 
                    s.social_skills, 
                    s.health immunization, 
                    s.health,
                    s.minorauthorization, 
                    s.placement_notes, 
                    s.needs_smoking_house, 
                    s.likes_pets, 
                    s.accepts_private_high,
                    s.app_completed_school, 
                    s.visano, 
                    s.grades, 
                    s.slep_Score, 
                    s.convalidation_needed, 
                    s.other_missing_docs, 
                    s.flight_info_notes,
                    s.scholarship, app_current_status, 
                    s.php_wishes_graduate, 
                    s.php_grade_student,  
                    s.php_passport_copy, 
                    <!--- FROM THE PHP_STUDENTS_IN_PROGRAM TABLE --->		
                    php.assignedID, 
                    php.studentID,
                    php.companyID,
                    php.programID,
                    php.hostID,
                    php.isWelcomeFamily,
                    php.schoolID,
                    php.areaRepID,
                    php.placeRepID,
                    php.doublePlace,
                    php.placementNotes,
                    php.datePlaced,
                    php.dateApproved,
                    php.datePISEmailed,
                    php.dateInvoiceReceived,
                    php.dateInvoicePaid,
                    php.doc_evaluation2, 
                    php.doc_evaluation4, 
                    php.doc_evaluation6,
                    php.doc_evaluation9,
                    php.doc_evaluation12, 
                    php.doc_grade1, 
                    php.doc_grade2,
                    php.doc_grade3, 
                    php.doc_grade4, 
                    php.doc_grade5, 
                    php.doc_grade6,
                    php.doc_grade7,
                    php.doc_grade8,
                    php.active,
                    php.canceldate, 
                    php.cancelreason,
					php.canceledBy,
                    php.insurancedate, 
                    php.insuranceCancelDate,
                    php.transfer_type,
                    php.return_student, 
                    php.flightinfo_no, 
                    php.flightinfo_received,
                    php.flightinfo_sent, 
                    php.flightinfo_note,
                    php.welcome_letter_printed,
                    php.school_acceptance,
                    php.original_school_acceptance, 
                    php.sevis_fee_paid, 
                    php.i20no, 
                    php.i20received, 
                    php.i20note,
                    php.i20sent, 
                    php.hf_placement, 
                    php.hf_application, 
					php.doc_letter_rec_date,
                    php.doc_rules_rec_date,
                    php.doc_photos_rec_date,
                    php.doc_school_profile_rec,
                    php.doc_conf_host_rec,
                    php.doc_ref_form_1,
                    php.doc_ref_form_2,
                    php.inputBy,
                    php.dateCreated,
                    php.dateUpdated,
                    php.orientationSignOff_student
                FROM 
                	smg_students s
                INNER JOIN 
                	php_students_in_program php ON php.studentID = s.studentID
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

                <cfif LEN(ARGUMENTS.assignedID)>
                    AND
                        php.assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.assignedID)#">
                </cfif>
                    
                <cfif LEN(ARGUMENTS.programID)>
                    AND
                        php.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.programID)#">
                </cfif>
			
            ORDER BY
            	php.assignedID DESC                
		</cfquery>
		   
		<cfreturn qGetStudentByID>
	</cffunction>


	<cffunction name="getStudentFullInformationByID" access="public" returntype="query" output="false" hint="Returns PHP student">
    	<cfargument name="studentID" default="" hint="studentID is not required">
        <cfargument name="uniqueID" default="" hint="uniqueID is not required">
        <cfargument name="programID" default="" hint="programID is not required">
        <cfargument name="assignedID" default="" hint="assignedID is not required">

        <cfquery 
			name="qGetStudentFullInformationByID" 
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
                    <!--- School --->
                    school.schoolName,
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
                    1 = 1

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
                        php.assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.assignedID#">
                </cfif>
                    
                <cfif VAL(ARGUMENTS.programID)>
                    AND
                        php.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.programID#">
                </cfif>
                                    
        </cfquery>

        <cfreturn qGetStudentFullInformationByID>            
	</cffunction>


	<cffunction name="getAvailableDoublePlacement" access="public" returntype="query" output="false" hint="Gets placed available students for double placement">
        <cfargument name="studentID" default="0" hint="studentID is not required">
              
        <cfquery 
			name="qGetAvailableDoublePlacement" 
			datasource="#APPLICATION.DSN#">
                SELECT 
                	s.studentID, 
                    s.familyLastName,
                    s.firstName,
                    p.programName
                FROM 
                	smg_students s
				INNER JOIN
                	php_students_in_program php ON php.studentID = s.studentID
                    AND
                        php.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                    AND
                        php.hostID != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                        
                    <cfif LEN(ARGUMENTS.studentID)>
                        AND
                            php.studentID != <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">
                    </cfif>
				INNER JOIN
                	smg_programs p ON p.programID = php.programID			                    
               	ORDER BY 
                	s.firstname,
                    s.familylastname
		</cfquery>
		   
		<cfreturn qGetAvailableDoublePlacement>
	</cffunction>


	<!--- ------------------------------------------------------------------------- ----
		
		Placement Management
	
	----- ------------------------------------------------------------------------- --->

	<cffunction name="updatePlacementInformation" access="public" returntype="void" output="false" hint="Update placement information / Approval process must be separate">
        <cfargument name="studentID" hint="studentID is required">
        <cfargument name="assignedID" hint="assignedID is required">
        <cfargument name="hostID" hint="hostID is required">
        <cfargument name="isWelcomeFamily" default="0" hint="isWelcomeFamily is not required">
        <cfargument name="isRelocation" default="0" hint="isRelocation is not required">
        <cfargument name="dateRelocated" default="" hint="Date Relocated is not required">
        <cfargument name="datePlaced" default="#NOW()#" hint="Date Placed is not required">
        <cfargument name="changePlacementExplanation" default="" hint="changePlacementExplanation is not required">
        <cfargument name="schoolID" hint="schoolID is required">   
        <cfargument name="schoolIDReason" default="" hint="schoolIDReason is not required">     
        <cfargument name="placeRepID" hint="placeRepID is required">
        <cfargument name="placeRepIDReason" default="" hint="placeRepIDReason is not required"> 
		<cfargument name="areaRepID" hint="areaRepID is required">
        <cfargument name="areaRepIDReason" default="" hint="areaRepIDReason is not required"> 
		<cfargument name="doublePlace" hint="doublePlace ID is required">
        <cfargument name="doublePlaceReason" default="" hint="doublePlaceReason is not required"> 
        <cfargument name="changedBy" hint="changedBy is required">
        <cfargument name="userType" hint="userType is required">
        <cfargument name="reason" default="" hint="reason is not required">
        <cfargument name="placementStatus" default="" hint="Unplaced/Incomplete/Pending/Approved/Rejected">
            
        <cfscript>	
			// Get Student Info
			var qGetStudentInfo = getStudentByID(assignedID=ARGUMENTS.assignedID);
			
			// Insert-Update Placement History
			insertPlacementHistory(
				studentID = ARGUMENTS.studentID,
				assignedID = ARGUMENTS.assignedID,
				hostID = ARGUMENTS.hostID,
				isWelcomeFamily = ARGUMENTS.isWelcomeFamily,
				isRelocation = ARGUMENTS.isRelocation,
				dateRelocated = ARGUMENTS.dateRelocated,
				datePlaced = ARGUMENTS.datePlaced,
				changePlacementExplanation = ARGUMENTS.changePlacementExplanation,
				schoolID = ARGUMENTS.schoolID,
				schoolIDReason = ARGUMENTS.schoolIDReason,
				placeRepID = ARGUMENTS.placeRepID,
				placeRepIDReason = ARGUMENTS.placeRepIDReason,
				areaRepID = ARGUMENTS.areaRepID,
				areaRepIDReason = ARGUMENTS.areaRepIDReason,
				doublePlace = ARGUMENTS.doublePlace,
				doublePlaceReason = ARGUMENTS.doublePlaceReason,
				changedBy = ARGUMENTS.changedBy,
				userType = ARGUMENTS.userType,
				placementStatus = ARGUMENTS.placementStatus
			);
		</cfscript>
		
        <cfquery 
			datasource="#APPLICATION.DSN#">
                UPDATE
                	php_students_in_program
				SET
                    hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">,
                    isWelcomeFamily = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(ARGUMENTS.isWelcomeFamily)#">,
                    schoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.schoolID)#">,
                    placeRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.placeRepID)#">,
                    areaRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.areaRepID)#">,
                    doublePlace = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.doublePlace)#">,
                    <cfif NOT IsDate(qGetStudentInfo.datePlaced)>
                    	dateplaced = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    </cfif>
                    <!--- Used to track last approval --->
                    dateApproved = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				WHERE
                	assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.assignedID)#">
		</cfquery>
        
        <cfscript>
			/*******************************************************************************
				Double Placement - Automatically assign/remove/update for the second record
			*******************************************************************************/

			// Get Student Info // Get Assigned ID
			var qGetDoublePlacementInfo = getStudentByID(ARGUMENTS.doublePlace);	

			/*******************************************************************************
				Add New Double Placement
			********************************************************************************/
			if ( VAL(ARGUMENTS.doublePlace) AND NOT VAL(qGetStudentInfo.doublePlace) ) {
				
                // Insert-Update Placement History
                insertPlacementHistory(
					studentID = ARGUMENTS.doublePlace,
					assignedID = qGetDoublePlacementInfo.assignedID,
					doublePlace = ARGUMENTS.studentID,
					doublePlaceReason = 'Double placement automatically assigned',
					changedBy = ARGUMENTS.changedBy,
					userType = ARGUMENTS.userType,
					placementAction='setDoublePlacement'
				);
				
				// Update Double Placement Record
				updateDoublePlacement(
					studentID = ARGUMENTS.doublePlace,
					assignedID = qGetDoublePlacementInfo.assignedID,
					doublePlace = ARGUMENTS.studentID,
					userType = ARGUMENTS.userType
				);

			/*******************************************************************************
				Double Placement Assigned to a Different Student 
				Remove previous and add new double placement
			********************************************************************************/
			} else if ( VAL(ARGUMENTS.doublePlace) AND ARGUMENTS.doublePlace NEQ qGetStudentInfo.doublePlace ) {
				
				/*******************************************************************************
					Remove Double Placement
				********************************************************************************/

                // Insert-Update Placement History
                insertPlacementHistory(
					studentID = ARGUMENTS.doublePlace,
					assignedID = qGetDoublePlacementInfo.assignedID,
					doublePlace = 0,
					doublePlaceReason = 'Double placement student assigned to a different student - automatically removed',
					changedBy = ARGUMENTS.changedBy,
					userType = ARGUMENTS.userType,
					placementAction='setDoublePlacement'
				);
				
				// Update Double Placement Record
				updateDoublePlacement(
					studentID = ARGUMENTS.doublePlace,
					assignedID = qGetDoublePlacementInfo.assignedID,
					doublePlace = 0,
					userType = ARGUMENTS.userType
				);
			
				/*******************************************************************************
					Add New Double Placement Automatically
				********************************************************************************/
				
                // Insert-Update Placement History
                insertPlacementHistory(
					studentID = ARGUMENTS.doublePlace,
					assignedID = qGetDoublePlacementInfo.assignedID,
					doublePlace = ARGUMENTS.studentID,
					doublePlaceReason = 'Double placement automatically assigned',
					changedBy = ARGUMENTS.changedBy,
					userType = ARGUMENTS.userType,
					placementAction='setDoublePlacement'
				);
				
				// Update Double Placement Record
				updateDoublePlacement(
					studentID = ARGUMENTS.doublePlace,
					assignedID = qGetDoublePlacementInfo.assignedID,
					doublePlace = ARGUMENTS.studentID,
					userType = ARGUMENTS.userType
				);

			/*******************************************************************************
				Remove Double Placement Automatically
			********************************************************************************/
			} else if ( NOT VAL(ARGUMENTS.doublePlace) AND VAL(qGetStudentInfo.doublePlace) ) {
				
                // Insert-Update Placement History
                insertPlacementHistory(
					studentID = ARGUMENTS.doublePlace,
					assignedID = qGetDoublePlacementInfo.assignedID,
					doublePlace = 0,
					doublePlaceReason = 'Double placement automatically removed',
					changedBy = ARGUMENTS.changedBy,
					userType = ARGUMENTS.userType,
					placementAction='setDoublePlacement'
				);
				
				// Update Double Placement Record on the second record
				updateDoublePlacement(
					studentID = ARGUMENTS.doublePlace,
					assignedID = qGetDoublePlacementInfo.assignedID,
					doublePlace = 0,
					userType = ARGUMENTS.userType
				);
			
			}
		</cfscript>
	
	</cffunction>


	<cffunction name="updateDoublePlacement" access="public" returntype="void" output="false" hint="Updates a Double Placement Record">
        <cfargument name="studentID" hint="studentID is required">
        <cfargument name="assignedID" hint="assignedID is required">
		<cfargument name="doublePlace" hint="doublePlace ID is required">
        <cfargument name="userType" hint="userType is required">

			<cfscript>
				var vHostHistoryID = getPlacementHistory(studentID=ARGUMENTS.studentID, assignedID=ARGUMENTS.assignedID).historyID;
            </cfscript>
            
            <cfquery 
                datasource="#APPLICATION.DSN#">
                    UPDATE
                        php_students_in_program
                    SET
                        doublePlace = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.doublePlace)#">,
						<!--- Used to track last approval --->
                        dateApproved = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    WHERE
                        assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.assignedID)#">
            </cfquery>
			
            <!--- Update History --->
            <cfquery 
                datasource="#APPLICATION.DSN#">
                    UPDATE
                        smg_hostHistory
                    SET
                        <cfif qGetStudentInfo.doublePlace NEQ ARGUMENTS.doublePlace>
	                        hasDoublePlacementIDChanged = <cfqueryparam cfsqltype="cf_sql_bit" value="1">,
                        </cfif>                        
                        doublePlacementID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.doublePlace)#">
                    WHERE
                        historyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(vHostHistoryID)#">
            </cfquery>
            
	</cffunction>


	<cffunction name="updatePlacementNotes" access="public" returntype="void" output="false" hint="Updates placement notes">
        <cfargument name="assignedID" hint="assignedID is required">
		<cfargument name="placementNotes" default="" hint="placementNotes is not required">

            <cfquery 
                datasource="#APPLICATION.DSN#">
                    UPDATE
                        php_students_in_program
                    SET
                        placementNotes = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.placementNotes#">
                    WHERE
                        assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.assignedID)#">
            </cfquery>

	</cffunction>


	<!--- Unplace Student --->
	<cffunction name="unplaceStudent" access="public" returntype="void" output="false" hint="Unplaces a student">
        <cfargument name="studentID" hint="studentID is required">
        <cfargument name="assignedID" hint="assignedID is required">
        <cfargument name="changedBy" hint="changedBy is required">
        <cfargument name="userType" hint="userType is required">
        <cfargument name="reason" default="" hint="reason is not required">
		
        <cfscript>
			// Get Student Info
			var qGetStudentInfo = getStudentByID(assignedID=ARGUMENTS.assignedID);
			
            // Get Current User
            var qGetChangedByUser = APPLICATION.CFC.USER.getUsers(userID=ARGUMENTS.changedBy);
		</cfscript>
        
        <cfquery 
			datasource="#APPLICATION.DSN#">
                UPDATE 
                	php_students_in_program
                SET 
					hostID = <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
                    isWelcomeFamily = <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
                    schoolID = <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
                    placeRepID = <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
                    areaRepID =  <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
                    doubleplace = <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
                    dateApproved = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    datePlaced = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    datePISEmailed = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    <!--- Placement Notes --->
                    placementNotes = <cfqueryparam cfsqltype="cf_sql_varchar" value="no">,
					<!--- Paperwork Received --->
                    school_acceptance = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    hf_placement = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    hf_application = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    doc_letter_rec_date = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    doc_rules_rec_date = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    doc_photos_rec_date = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    doc_school_profile_rec = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    doc_conf_host_rec = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    doc_ref_form_1 = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                    doc_ref_form_2 = <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                WHERE 
                	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">
    	</cfquery>

		<cfscript>
			// Insert History - It tracks placement statuses only, placement updates are tracked on smg_hostHistory
			insertPlacementActionHistory(
				studentID=ARGUMENTS.studentID,
				assignedID=ARGUMENTS.assignedID,
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


    <!--- Set Host Family as Permanent --->
	<cffunction name="setFamilyAsPermanent" access="public" returntype="void" output="false" hint="Sets a host family as permanent">
        <cfargument name="studentID" hint="studentID is required">
        <cfargument name="assignedID" hint="assignedID is required">
        <cfargument name="changedBy" hint="changedBy is required">
        <cfargument name="userType" hint="userType is required">
        <cfargument name="reason" default="" hint="reason is not required">
        <cfargument name="dateSetHostPermanent" default="" hint="dateSetHostPermanent is not required">
        
        <cfscript>
			// Get Student Info
			var qGetStudentInfo = getStudentByID(assignedID=ARGUMENTS.assignedID);
			
			var vHostHistoryID = getPlacementHistory(studentID=ARGUMENTS.studentID, assignedID=ARGUMENTS.assignedID).historyID;
		</cfscript>
        
        <cfquery 
			datasource="#APPLICATION.DSN#">
                UPDATE
                	php_students_in_program
				SET
                    isWelcomeFamily = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
				WHERE
                	assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.assignedID)#">
		</cfquery>
        
        <!--- Update Host History - Insert Permanent Date --->
        <cfquery 
            datasource="#APPLICATION.DSN#">
                UPDATE
                    smg_hosthistory	
                SET
                    isWelcomeFamily = <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
                    dateSetHostPermanent = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.dateSetHostPermanent#">
                WHERE
                    historyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(vHostHistoryID)#">
        </cfquery>
        
		<cfscript>
			// Insert New History - It tracks placement statuses only, placement updates are tracked on smg_hostHistory
			insertPlacementActionHistory(
				studentID=ARGUMENTS.studentID,
				assignedID=ARGUMENTS.assignedID,
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
        <cfargument name="assignedID" hint="assignedID is required">
        <cfargument name="changedBy" hint="changedBy is required">
        <cfargument name="userType" hint="userType is required">
        <cfargument name="reason" default="" hint="Field is used for rejection/resubmit comments">
        <cfargument name="placementAction" default="" hint="Approve/Reject/Resubmit/unplaceStudent">
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
			vHostHistoryID = getPlacementHistory(studentID=ARGUMENTS.studentID, assignedID=ARGUMENTS.assignedID).historyID;
				
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
        <cfargument name="assignedID" hint="assignedID is required">
        <cfargument name="changedBy" hint="changedBy is required">
        <cfargument name="userType" hint="userType is required">
        <cfargument name="hostID" default="0" hint="hostID is not required">
        <cfargument name="changePlacementExplanation" default="" hint="changePlacementExplanation is not required">
        <cfargument name="isWelcomeFamily" default="0" hint="isWelcomeFamily is not required">
        <cfargument name="isRelocation" default="0" hint="isRelocation is not required">
        <cfargument name="dateRelocated" default="" hint="Date Relocated is not required">
        <cfargument name="datePlaced" default="#NOW()#" hint="Date Placed is not required">
        <cfargument name="schoolID" default="0" hint="schoolID is not required">        
        <cfargument name="schoolIDReason" default="" hint="schoolIDReason is not required">     
        <cfargument name="placeRepID" default="0" hint="placeRepID is not required">
        <cfargument name="placeRepIDReason" default="" hint="placeRepIDReason is not required"> 
		<cfargument name="areaRepID" default="0" hint="areaRepID is not required">
        <cfargument name="areaRepIDReason" default="" hint="areaRepIDReason is not required"> 
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
			var vPreviousSchoolName = '';
			
			var hasHostIDChanged = 0;
			var hasSchoolIDChanged = 0;
			var hasPlaceRepIDChanged = 0;
			var hasAreaRepIDChanged = 0;
			var hasDoublePlacementIDChanged = 0;

			// Set to 1 to add an extra line on the history
			var vAddExtraLine = 0;
						
			// Get Current Placement Information
			qGetStudentInfo = getStudentByID(studentID=ARGUMENTS.studentID, assignedID=ARGUMENTS.assignedID);

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
				vActions = vActions & "<strong>New Placement Information</strong> <br /> #CHR(13)#";

				// Welcome Family Information
				if ( VAL(ARGUMENTS.isWelcomeFamily) ) {
					vActions = vActions & "This is a welcome family <br /> #CHR(13)#";
				}
			
			// STUDENT IS PLACED - CHECK FOR UPDATES
			} else {

				// Host Family Updated
				if ( NOT VAL(qGetStudentInfo.hostID) AND VAL(ARGUMENTS.hostID) ) {
					vQueryType = 'update';
					vAddExtraLine = 1;
					hasHostIDChanged = 1;
					
					// Add Message if info has been updated
					vActions = vActions & "<strong>Host Family Updated</strong> <br /> #CHR(13)#";
					
					if ( VAL(ARGUMENTS.isWelcomeFamily) ) {
						vActions = vActions & "<strong>This is a welcome family</strong> <br /> #CHR(13)#";
					}
				
				} else if ( VAL(ARGUMENTS.hostID) AND VAL(qGetStudentInfo.hostID) AND qGetStudentInfo.hostID NEQ ARGUMENTS.hostID ) {
					vQueryType = 'insert';
					vAddExtraLine = 1;
					hasHostIDChanged = 1;
					
					// Start building record
					
					// Add Message if info has been updated
					if ( VAL(qGetStudentInfo.hostID) ) {
						vActions = vActions & "<strong>Host Family Updated</strong> <br /> #CHR(13)#";
					}
					
					if ( VAL(ARGUMENTS.isWelcomeFamily) ) {
						vActions = vActions & "<strong>This is a welcome family</strong> <br /> #CHR(13)#";
					}
	
					if ( VAL(ARGUMENTS.isRelocation) ) {
						
						vActions = vActions & "<strong>This is a relocation</strong> - Student relocated on #DateFormat(ARGUMENTS.dateRelocated, 'mm/dd/yyyy')# <br /> #CHR(13)#";
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
					hasSchoolIDChanged = 1;
					
					// Add Message if info has been updated
					if ( VAL(qGetStudentInfo.schoolID) ) {
						vActions = vActions & "<strong>School Updated</strong> <br /> #CHR(13)#";
						// Previous School for reference
						qGetSchoolInfo = APPLICATION.CFC.SCHOOL.getSchools(schoolID=qGetStudentInfo.schoolID);
						vActions = vActions & "Previous School: #qGetSchoolInfo.schoolName# ###qGetSchoolInfo.schoolID# <br /> #CHR(13)#";
						vPreviousSchoolName = "#qGetSchoolInfo.schoolName# (###qGetSchoolInfo.schoolID#)";
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
				if ( NOT VAL(qGetStudentInfo.placeRepID) AND VAL(ARGUMENTS.placeRepID) OR ( VAL(ARGUMENTS.placeRepID) AND VAL(qGetStudentInfo.placeRepID) AND qGetStudentInfo.placeRepID NEQ ARGUMENTS.placeRepID ) ) {
					if ( NOT LEN(vQueryType) ) { 
						vQueryType = 'update';
					}
					vAddExtraLine = 1;
					hasPlaceRepIDChanged = 1;

					// Add Message if info has been updated
					if ( VAL(qGetStudentInfo.placeRepID) ) {
						vActions = vActions & "<strong>Placing Representative Updated</strong> <br /> #CHR(13)#";
						// Previous Placing Representative for reference
						qGetPlacingRep = APPLICATION.CFC.USER.getUsers(userID=qGetStudentInfo.placeRepID);
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
				if ( NOT VAL(qGetStudentInfo.areaRepID) AND VAL(ARGUMENTS.areaRepID) OR ( VAL(ARGUMENTS.areaRepID) AND VAL(qGetStudentInfo.areaRepID) AND qGetStudentInfo.areaRepID NEQ ARGUMENTS.areaRepID ) ) {
					if ( NOT LEN(vQueryType) ) { 
						vQueryType = 'update';
					}
					vAddExtraLine = 1;
					hasAreaRepIDChanged = 1;

					// Add Message if info has been updated
					if ( VAL(qGetStudentInfo.areaRepID) ) {
						vActions = vActions & "<strong>Supervising Representative Updated</strong> <br /> #CHR(13)#";
						// Previous Supervising Representative for reference
						qGetSupervisingRep = APPLICATION.CFC.USER.getUsers(userID=qGetStudentInfo.areaRepID);
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

				// Update Double Placement 
				if ( VAL(qGetStudentInfo.doublePlace) AND VAL(ARGUMENTS.doublePlace) AND qGetStudentInfo.doublePlace NEQ ARGUMENTS.doublePlace ) {
					if ( NOT LEN(vQueryType) ) { 
						vQueryType = 'update';
					}
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
					if ( NOT LEN(vQueryType) ) { 
						vQueryType = 'update';
					}
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
				} else if ( VAL(qGetStudentInfo.doublePlace) AND NOT VAL(ARGUMENTS.doublePlace) ) { // ARGUMENTS.placementStatus NEQ 'Approved'
					if ( NOT LEN(vQueryType) ) { 
						vQueryType = 'update';
					}
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
                    	php_students_in_program
                    SET
						<!--- School Docs --->
                        school_acceptance = <cfqueryparam cfsqltype="cf_sql_date" null="yes">
	            	WHERE
    					studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">
			</cfquery>
            
            <!--- Send Out Email Notification to Finance Department --->
            <cfscript>
				// Get International Representative
				qIntlRep = APPLICATION.CFC.USER.getUsers(userID=qGetStudentInfo.intrep);

				// Get Program
				qGetProgramInfo = APPLICATION.CFC.PROGRAM.getPrograms(programID=qGetStudentInfo.programID);
				
				// Get New School
				qGetNewSchoolInfo = APPLICATION.CFC.SCHOOL.getSchools(schoolID=ARGUMENTS.schoolID);				
			</cfscript>
            
            <cfsavecontent variable="vEmailMessage">            	
                <cfoutput>
					<h1>School Change Notification</h1>
                    <p>This email is to let you know that a student changed school in the database</p>                                                        
                    
                    <table width="100%" cellpadding="4" cellspacing="0">
                    	<tr>
                        	<td>Intl. Rep.:</td>
                            <td>#qIntlRep.businessname# (###qIntlRep.userID#)</td>
						</tr>                            
                    	<tr>
                        	<td>Student:</td>
                            <td>#qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentID# - Assigned ID ###qGetStudentInfo.assignedID#)</td>
						</tr>                            
                    	<tr>
                        	<td>Program:</td>
                            <td>#qGetProgramInfo.programname# (###qGetProgramInfo.programID#)</td>
						</tr>                            
                    	<tr>
                        	<td>Change Date:</td>
                            <td>#DateFormat(now(), 'mm/dd/yyyy')#</td>
						</tr>                            
                    	<tr>
                        	<td>Previous School:</td>
                            <td>#vPreviousSchoolName#</td>
						</tr>                            
                    	<tr>
                        	<td>New School:</td>
                            <td>#qGetNewSchoolInfo.schoolName# (###qGetNewSchoolInfo.schoolID#)</td>
						</tr>                            
                    	<tr>
                        	<td>Reason:</td>
                            <td>#ARGUMENTS.schoolIDReason#</td>
						</tr>                            
                    	<tr>
                        	<td>Updated by:</td>
                            <td>#qGetEnteredBy.firstName# #qGetEnteredBy.lastName# (###qGetEnteredBy.userID#)</td>
						</tr>
					</table>                                                    
                </cfoutput>
            </cfsavecontent>
            
        	<cfinvoke component="internal.extensions.components.email" method="send_mail">
            	<cfinvokeargument name="email_from" value="#APPLICATION.EMAIL.support#">
                <cfinvokeargument name="email_to" value="#APPLICATION.EMAIL.finance#">
                <cfinvokeargument name="email_subject" value="PHP School Change Notification - #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentID#) - #qGetProgramInfo.programname# (###qGetProgramInfo.programID#) ">
                <cfinvokeargument name="email_message" value="#vEmailMessage#">
           	</cfinvoke>
            <!--- End of Send Out Email Notification to Finance Department --->
                     
		</cfif>
        
        
		<!--- Insert History Information --->
        <cfif vQueryType EQ 'insert'>        
            
            <!--- Host Family Updated | Reset Fields on the Student Table --->
            <cfquery 
                datasource="#APPLICATION.DSN#">
					UPDATE
                    	php_students_in_program
                    SET
                        programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.programID)#">,
                        dateApproved = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                        datePlaced = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                        datePISEmailed = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
						<!--- Placement Notes --->
                        placementNotes = <cfqueryparam cfsqltype="cf_sql_varchar" value="no">,
                        <!--- Paperwork Received --->
                        doc_letter_rec_date = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                        doc_rules_rec_date = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                        doc_photos_rec_date = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                        doc_school_profile_rec = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                        doc_conf_host_rec = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                        doc_ref_form_1 = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                        doc_ref_form_2 = <cfqueryparam cfsqltype="cf_sql_date" null="yes">
	            	WHERE
    					assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.assignedID)#">
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
                        assignedID, 
                        hostID,  
                        hasHostIDChanged,
                        changePlacementExplanation,                   
                        schoolID,
                        hasSchoolIDChanged, 
                        placeRepID, 
                        hasPlaceRepIDChanged,
                        areaRepID,
                        hasAreaRepIDChanged,
                        doublePlacementID,
                        hasDoublePlacementIDChanged,
                        changedBy,
                        isWelcomeFamily,
                        isRelocation,
                        dateRelocated,
                        datePlaced,
                        dateOfChange, 
                        reason,
                        isActive,
                        dateCreated
                    )
                    VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.assignedID)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(hasHostIDChanged)#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.changePlacementExplanation#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.schoolID)#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(hasSchoolIDChanged)#">,   
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.placeRepID)#">, 
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(hasPlaceRepIDChanged)#">, 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.areaRepID)#">, 
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(hasAreaRepIDChanged)#">, 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.doublePlace)#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(hasDoublePlacementIDChanged)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.changedBy)#">, 
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(ARGUMENTS.isWelcomeFamily)#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(ARGUMENTS.isRelocation)#">, 
                        <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.dateRelocated#" null="#NOT IsDate(ARGUMENTS.dateRelocated)#">,
                    	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#ARGUMENTS.datePlaced#" null="#NOT IsDate(ARGUMENTS.dateRelocated)#">,
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
				vHostHistoryID = getPlacementHistory(studentID=ARGUMENTS.studentID, assignedID=ARGUMENTS.assignedID).historyID;
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
        
        <!--- Update History --->
        <cfif vQueryType EQ 'update' AND ARGUMENTS.placementAction NEQ 'setDoublePlacement'>

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
						
                        <cfif VAL(hasDoublePlacementIDChanged)>
                        	hasDoublePlacementIDChanged = <cfqueryparam cfsqltype="cf_sql_bit" value="#hasDoublePlacementIDChanged#">,
                       	</cfif> 

						<cfif NOT IsDate(qGetStudentInfo.datePlaced)>
                            dateplaced = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        </cfif>
                        
                        hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.hostID#">,
                        schoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.schoolID)#">,  
                        placeRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.placeRepID)#">,
                        areaRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.areaRepID)#">,
                        doublePlacementID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.doublePlace)#">
                    WHERE
                        historyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(vHostHistoryID)#">
            </cfquery>
        
		</cfif>
        
        <!--- Send an email to Luke, Joanna, Tina, and Bryan if this a relocation --->
        <cfif VAL(ARGUMENTS.isRelocation) AND (ARGUMENTS.hostID NEQ 0) AND (ARGUMENTS.hostID NEQ qGetStudentInfo.hostID)>
        	
            <!--- The datePlaced field seems to be missing sometimes, to prevent errors surround this with a try catch --->
            <cftry>
            
				<cfscript>
                    // Student's previous placement
                    qGetPlacementHistory = getPlacementHistory(studentID=qGetStudentInfo.studentID);
                    
                    // Set the date as the previous 15th
                    if (DatePart('d',NOW()) GTE 15) {
                        date = CreateDate(DatePart('yyyy',NOW()),DatePart('m',NOW()),15);
                    } else {
                        date = CreateDate(DatePart('yyyy',NOW()),DatePart('m',NOW())-1,15);
                    }
                    
                    // This will find all of the placements for this student since the previous 15'th
                    condition = false;
                    i = 1;
                    while (NOT condition) {
                        if (qGetPlacementHistory.recordCount GTE i) {
                            if (DateDiff('d',date,qGetPlacementHistory.datePlaced[i]) GT 0) {
                                i = i + 1;
                            } else {
                                condition = true;	
                            }
                        } else {
                            condition = true;
                        }
                    }
                    
                    // Create an array that will store the amounts owed to each HF
                    amountsOwed = arrayNew(1);
                    
                    for (j=i; j GT 0; j = j - 1) {
                        if (j EQ i) {
                            daysHere = DateDiff('d',date,qGetPlacementHistory.datePlaced[j-1]);
                        } else if(j NEQ 1) {
                            daysHere = DateDiff('d',qGetPlacementHistory.datePlaced[j],qGetPlacementHistory.datePlaced[j-1]);
                        } else {
                            daysHere = 30 - DateDiff('d',date,qGetPlacementHistory.datePlaced[1]);
                        }
                        amountsOwed[j] = DecimalFormat((daysHere/30)*qGetPlacementHistory.hostFamilyRate);
                    }
                </cfscript>
                <cfsavecontent variable="emailMessage">
                    <cfoutput>
                        <p style="font-size:14px; font-weight:bold;">#qGetStudentInfo.firstName# #qGetStudentInfo.familyLastName# (###qGetStudentInfo.studentID#) - #qGetPlacementHistory.schoolName# Relocation:</p>
                        <cfloop from="#i#" to="1" index="count" step="-1">
                            <cfif count EQ 1>
                                <p><strong>Current Placement - #DateFormat(qGetPlacementHistory.datePlaced[count],'mm/dd/yyy')#</strong></p>
                            <cfelse>
                                <p><strong>Previous Placement - #DateFormat(qGetPlacementHistory.datePlaced[count],'mm/dd/yyy')#</strong></p>
                            </cfif>
                            <p>
                                Host Family: #qGetPlacementHistory.fatherFirstName[count]#
                                <cfif LEN(qGetPlacementHistory.fatherFirstName[count]) AND LEN(qGetPlacementHistory.motherFirstName[count])>
                                    & 
                                </cfif>
                                #qGetPlacementHistory.motherFirstName[count]# #qGetPlacementHistory.familyLastName[count]# (###qGetPlacementHistory.hostID[count]#)<br />
                                Amount Owed: $<cfif VAL(amountsOwed[count])>#amountsOwed[count]#<cfelse>0.00</cfif><br />
                            </p>
                        </cfloop>
                    </cfoutput>
                </cfsavecontent> 
                
         		<cfcatch type="any">
                	<cfsavecontent variable="emailMessage">
						<cfoutput>
                            <p style="font-size:14px; font-weight:bold;">#qGetStudentInfo.firstName# #qGetStudentInfo.familyLastName# (###qGetStudentInfo.studentID#) - #qGetPlacementHistory.schoolName# Relocation:</p>
                            <p>
                                Host Family: #qGetPlacementHistory.fatherFirstName#
                                <cfif LEN(qGetPlacementHistory.fatherFirstName) AND LEN(qGetPlacementHistory.motherFirstName)>
                                    & 
                                </cfif>
                                #qGetPlacementHistory.motherFirstName# #qGetPlacementHistory.familyLastName# (###qGetPlacementHistory.hostID#)<br />
                                Amount Owed: This student is missing placement dates which are required for this calculation.<br />
                            </p>
                        </cfoutput>
                    </cfsavecontent> 
                </cfcatch>
               
         	</cftry>
                       
        	<cfinvoke component="internal.extensions.components.email" method="send_mail">
            	<cfinvokeargument name="email_from" value="#APPLICATION.EMAIL.support#">
                <cfinvokeargument name="email_to" value="luke@phpusa.com,joanna@phpusa.com,tina@phpusa.com,bmccready@student-management.com">
                <cfinvokeargument name="email_subject" value="PHP Student Relocation - #qGetStudentInfo.firstName# #qGetStudentInfo.familyLastName# (###qGetStudentInfo.studentID#) - #qGetPlacementHistory.schoolName#">
                <cfinvokeargument name="email_message" value="#emailMessage#">
           	</cfinvoke>
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
                    AND	
                    	assignedID != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
			</cfquery>                    
    </cffunction>
    

	<!--- Get Placement History --->
	<cffunction name="getPlacementHistory" access="public" returntype="query" output="false" hint="Returns placement history">
    	<cfargument name="studentID" hint="studentID is required">
        <cfargument name="assignedID" default="" hint="assignedID is not required">
        
        <cfquery 
        	name="qGetPlacementHistory" 
            datasource="#APPLICATION.DSN#">
                SELECT 
                    h.historyID,
                    h.studentID,
                    h.hostID,
                    h.hasHostIDChanged,
                    h.schoolID,
                    h.hasSchoolIDChanged,
                    h.placeRepID,
                    h.hasPlaceRepIDChanged,
                    h.areaRepID,
                    h.hasAreaRepIDChanged,
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
                    host.fatherFirstName,
                    host.motherFirstName,
                    <!--- School --->
                    school.schoolName,
                    school.hostFamilyRate,
                    <!--- Place Rep --->
                    place.firstName AS placeFirstName, 
                    place.lastName AS placeLastName,
                    <!--- Area Rep --->
                    area.firstName AS areaFirstName, 
                    area.lastName AS areaLastName,
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
                    php_schools school ON h.schoolID = school.schoolID
                LEFT JOIN 
                    smg_users place ON h.placeRepID = place.userID
                LEFT JOIN 
                    smg_users area ON h.areaRepID = area.userID
                LEFT JOIN
                	smg_students DP ON h.doublePlacementID = DP.studentID   
                LEFT JOIN 
                    smg_users user ON h.changedby = user.userID
                WHERE 
                    h.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">
                
                <cfif LEN(ARGUMENTS.assignedID)>
					AND
                    	h.assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.assignedID)#">
                <cfelse>
					AND
                    	h.assignedID != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
				</cfif>
                
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
                    changePlacementExplanation,
                    datePlaced,
                    datePISEmailed,
                    dateSetHostPermanent,
                    <!--- Placement Paperwork --->
                    doc_letter_rec_date,
                    doc_rules_rec_date,
                    doc_photos_rec_date,
                    doc_school_profile_rec,
                    doc_conf_host_rec,
                    doc_ref_form_1,
                    doc_ref_form_2,
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
        <cfargument name="programID" default="0" hint="programID is not required">
        <cfargument name="historyID" default="0" hint="historyID is not required">
        <!--- Placement Paperwork --->
        <cfargument name="school_acceptance" default="" hint="school_acceptance is not required">
        <cfargument name="original_school_acceptance" default="" hint="original_school_acceptance is not required">
        <cfargument name="dateInvoiceReceived" default="" hint="dateInvoiceReceived is not required">
        <cfargument name="dateInvoicePaid" default="" hint="dateInvoicePaid is not required">
        <cfargument name="sevis_fee_paid" default="" hint="sevis_fee_paid is not required">
        <cfargument name="i20received" default="" hint="i20received is not required">
        <cfargument name="hf_placement" default="" hint="hf_placement is not required">
        <cfargument name="hf_application" default="" hint="hf_application is not required">
        <cfargument name="doc_letter_rec_date" default="" hint="doc_letter_rec_date is not required">
        <cfargument name="doc_rules_rec_date" default="" hint="doc_rules_rec_date is not required">
        <cfargument name="doc_photos_rec_date" default="" hint="doc_photos_rec_date is not required">
        <cfargument name="doc_school_profile_rec" default="" hint="doc_school_profile_rec is not required">
        <cfargument name="doc_conf_host_rec" default="" hint="doc_conf_host_rec is not required">
        <cfargument name="doc_ref_form_1" default="" hint="doc_ref_form_1 is not required">
        <cfargument name="doc_ref_form_2" default="" hint="doc_ref_form_2 is not required">
        <cfargument name="orientationSignOff_student" default="" hint="orientationSignOff_student is not required">
        		
        <cfquery 
			datasource="#APPLICATION.DSN#">
                UPDATE
	                php_students_in_program
                SET 
                    <!--- Placement Paperwork --->
                    school_acceptance = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.school_acceptance#" null="#NOT IsDate(ARGUMENTS.school_acceptance)#">,
                    original_school_acceptance = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.original_school_acceptance#" null="#NOT IsDate(ARGUMENTS.original_school_acceptance)#">,
                    dateInvoiceReceived = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.dateInvoiceReceived#" null="#NOT IsDate(ARGUMENTS.dateInvoiceReceived)#">,
                    dateInvoicePaid = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.dateInvoicePaid#" null="#NOT IsDate(ARGUMENTS.dateInvoicePaid)#">,
                    sevis_fee_paid = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.sevis_fee_paid#" null="#NOT IsDate(ARGUMENTS.sevis_fee_paid)#">,
                    i20received = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.i20received#" null="#NOT IsDate(ARGUMENTS.i20received)#">,
                    hf_placement = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.hf_placement#" null="#NOT IsDate(ARGUMENTS.hf_placement)#">,
                    hf_application = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.hf_application#" null="#NOT IsDate(ARGUMENTS.hf_application)#">,
                    doc_letter_rec_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_letter_rec_date#" null="#NOT IsDate(ARGUMENTS.doc_letter_rec_date)#">,
                    doc_rules_rec_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_rules_rec_date#" null="#NOT IsDate(ARGUMENTS.doc_rules_rec_date)#">,
                    doc_photos_rec_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_photos_rec_date#" null="#NOT IsDate(ARGUMENTS.doc_photos_rec_date)#">,
                    doc_school_profile_rec = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_school_profile_rec#" null="#NOT IsDate(ARGUMENTS.doc_school_profile_rec)#">,
                    doc_conf_host_rec = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_conf_host_rec#" null="#NOT IsDate(ARGUMENTS.doc_conf_host_rec)#">,
                    doc_ref_form_1 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_ref_form_1#" null="#NOT IsDate(ARGUMENTS.doc_ref_form_1)#">,
                    doc_ref_form_2 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_ref_form_2#" null="#NOT IsDate(ARGUMENTS.doc_ref_form_2)#">,
                    orientationSignOff_student = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.orientationSignOff_student#" null="#NOT IsDate(ARGUMENTS.orientationSignOff_student)#">
                WHERE studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">
                AND programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.programID)#">
                                  	
		</cfquery>
		
        <cfscript>
			// Update Placement History
			updatePlacementPaperworkHistory(
				studentID = ARGUMENTS.studentID,
				historyID = ARGUMENTS.historyID,
				// Placement Paperwork
				doc_letter_rec_date = ARGUMENTS.doc_letter_rec_date,
				doc_rules_rec_date = ARGUMENTS.doc_rules_rec_date,
				doc_photos_rec_date = ARGUMENTS.doc_photos_rec_date,
				doc_school_profile_rec = ARGUMENTS.doc_school_profile_rec,
				doc_conf_host_rec = ARGUMENTS.doc_conf_host_rec,
				doc_ref_form_1 = ARGUMENTS.doc_ref_form_1,
				doc_ref_form_2 = ARGUMENTS.doc_ref_form_2
			);
		</cfscript>
        
	</cffunction>


	<cffunction name="updatePlacementPaperworkHistory" access="public" returntype="void" output="false" hint="Update Placement Paperwork">
        <cfargument name="studentID" default="0" hint="studentID is not required">
        <cfargument name="historyID" default="0" hint="historyID is not required">
        <!--- Placement Paperwork --->
        <cfargument name="doc_letter_rec_date" default="" hint="doc_letter_rec_date is not required">
        <cfargument name="doc_rules_rec_date" default="" hint="doc_rules_rec_date is not required">
        <cfargument name="doc_photos_rec_date" default="" hint="doc_photos_rec_date is not required">
        <cfargument name="doc_school_profile_rec" default="" hint="doc_school_profile_rec is not required">
        <cfargument name="doc_conf_host_rec" default="" hint="doc_conf_host_rec is not required">
        <cfargument name="doc_ref_form_1" default="" hint="doc_ref_form_1 is not required">
        <cfargument name="doc_ref_form_2" default="" hint="doc_ref_form_2 is not required">
        
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
                    <!--- Placement Paperwork --->
                    doc_letter_rec_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_letter_rec_date#" null="#NOT IsDate(ARGUMENTS.doc_letter_rec_date)#">,
                    doc_rules_rec_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_rules_rec_date#" null="#NOT IsDate(ARGUMENTS.doc_rules_rec_date)#">,
                    doc_photos_rec_date = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_photos_rec_date#" null="#NOT IsDate(ARGUMENTS.doc_photos_rec_date)#">,
                    doc_school_profile_rec = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_school_profile_rec#" null="#NOT IsDate(ARGUMENTS.doc_school_profile_rec)#">,
                    doc_conf_host_rec = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_conf_host_rec#" null="#NOT IsDate(ARGUMENTS.doc_conf_host_rec)#">,
                    doc_ref_form_1 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_ref_form_1#" null="#NOT IsDate(ARGUMENTS.doc_ref_form_1)#">,
                    doc_ref_form_2 = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.doc_ref_form_2#" null="#NOT IsDate(ARGUMENTS.doc_ref_form_2)#">
                WHERE 
                    historyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.historyID)#"> 
                AND
                    studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">                    	
		</cfquery>
        
	</cffunction>


	<!--- ------------------------------------------------------------------------- ----
		
		End of Placement Management
	
	----- ------------------------------------------------------------------------- --->

</cfcomponent>