<!--- Kill Extra Output --->
<cfsilent>
	
    <cfparam name="URL.unqID" default="0">
    <cfparam name="URL.assignedID" default="0">

	<!--- IF STUDENTS IN PROGRAM IS NOT DEFINED --->
    <cfif NOT VAL(URL.assignedID)>
        
        <cfquery name="qGetAssignedID" datasource="#application.dsn#">
            SELECT 
            	s.studentid,
                st.assignedID
            FROM 
            	smg_students s
            INNER JOIN 
            	php_students_in_program st ON st.studentid = s.studentid
            WHERE 
            	s.uniqueid = <cfqueryparam value="#URL.unqID#" cfsqltype="cf_sql_char">
            ORDER BY 
            	st.active DESC, 
                assignedID
        </cfquery>
        
        <cfset URL.assignedID = qGetAssignedID.assignedID>
        
    </cfif>

    <cfquery name="get_student_info" datasource="mysql">
        SELECT 
            s.studentid, uniqueid, familylastname, firstname, middlename, fathersname, fatheraddress,
            fatheraddress2, fathercity, fathercountry, fatherzip, fatherbirth, fathercompany, fatherworkphone,
            fatherworkposition, fatherworktype, fatherenglish, motherenglish, mothersname, motheraddress,
            motheraddress2, mothercity, mothercountry, motherzip, motherbirth, mothercompany, motherworkphone,
            motherworkposition, motherworktype, emergency_phone, emergency_name, emergency_address, 
            emergency_country, address, address2, city, country, zip, phone, fax, email, citybirth, countrybirth,
            countryresident, countrycitizen, sex, dob, religiousaffiliation, dateapplication, entered_by,
            passportnumber, intrep, current_state, approved, band, orchestra, comp_sports, 
            familyletter, pictures, interests, interests_other, religious_participation, churchfam, churchgroup,
            smoke, animal_allergies, med_allergies, other_allergies, chores, chores_list, weekday_curfew, 
            weekend_curfew, letter, height, weight, haircolor, eyecolor, graduated, direct_placement, 
            direct_place_nature, termination_date, 
            notes, yearsenglish, estgpa, transcript, language_eval, social_skills, health immunization, health,
            minorauthorization, needs_smoking_house, likes_pets, accepts_private_high,
            app_completed_school, visano, grades, slep_Score, convalidation_needed, other_missing_docs, 
            flight_info_notes, scholarship, app_current_status, php_wishes_graduate, php_grade_student,  
            php_passport_copy,
            <!--- FROM THE NEW TABLE PHP_STUDENTS_IN_PROGRAM --->		
            st.assignedid, st.studentid, st.companyid, st.programid, st.hostid, st.schoolid, st.placerepid, st.arearepid,
            st.dateplaced, st.school_acceptance, st.active, st.i20no, st.i20received, st.placementNotes,
            st.i20sent, st.doubleplace, st.canceldate, st.cancelreason, st.insurancedate, st.insurancecanceldate,
            st.hf_placement, st.hf_application, st.sevis_fee_paid, st.transfer_type,
            st.doc_evaluation9, st.doc_evaluation12, st.doc_evaluation2, st.doc_evaluation4, st.doc_evaluation6, 
            st.doc_grade1, st.doc_grade2, st.doc_grade3, st.doc_grade4, st.return_student		
        FROM 
            smg_students s
        INNER JOIN 
            php_students_in_program st ON st.studentid = s.studentid
        WHERE 
            uniqueid = <cfqueryparam value="#URL.unqid#" cfsqltype="cf_sql_char">
        AND 
            st.assignedid = <cfqueryparam value="#URL.assignedid#" cfsqltype="cf_sql_integer" maxlength="5">
    </cfquery>

</cfsilent>
