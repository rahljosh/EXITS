<!--- ------------------------------------------------------------------------- ----
	
	File:		exchange-student-trips.cfm
	Author:		Marcus Melo
	Date:		September 26, 2011
	Desc:		MPD Tours
	
	Updates:	
	
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
		       
	<!--- Param local variables --->
	<cfparam name="URL.action" default="">
	<cfparam name="URL.tourID" default="0" />

	<!--- Param FORM Variables --->
	<cfparam name="FORM.action" default="">
	<cfparam name="FORM.subAction" default="">    
    <cfparam name="FORM.submitted" default="0">
	<cfparam name="FORM.tourID" default="0" />
    <!--- LoopUp Account --->
    <cfparam name="FORM.companyID" default="0">
    <cfparam name="FORM.studentID" default="">
    <cfparam name="FORM.hostID" default="">
    <cfparam name="FORM.familyLastName" default="">
    <cfparam name="FORM.dob" default="">
    <cfparam name="FORM.exitsUsername" default="">
    <cfparam name="FORM.exitsPassword" default="">
    <!--- Trip Preferences --->
    <cfparam name="FORM.otherTravelers" default="0">
    <cfparam name="FORM.shareRoomNationality" default="">
    <cfparam name="FORM.shareRoomPerson1" default="">
    <cfparam name="FORM.shareRoomPerson2" default="">
    <cfparam name="FORM.shareRoomPerson3" default="">
    <cfparam name="FORM.medicalInformation" default="">
    <!--- Book Tour --->
    <cfparam name="FORM.emailAddress" default="">
    <cfparam name="FORM.confirmEmailAddress" default="">
	<!--- Credit Card Information --->
    <cfparam name="FORM.totalDue" default="">
    <cfparam name="FORM.paymentMethodID" default="1">
    <cfparam name="FORM.nameOnCard" default="">
	<cfparam name="FORM.creditCardTypeID" default="">
	<cfparam name="FORM.creditCardNumber" default="">
	<cfparam name="FORM.expirationMonth" default="">
    <cfparam name="FORM.expirationYear" default="">
    <cfparam name="FORM.ccvCode" default="">
	<!--- Billing Address --->
    <cfparam name="FORM.billingFirstName" default="">    
    <cfparam name="FORM.billingLastName" default="">    
    <cfparam name="FORM.billingCompany" default="">    
    <cfparam name="FORM.billingAddress" default="">    
    <cfparam name="FORM.billingCity" default="">
    <cfparam name="FORM.billingState" default="">
    <cfparam name="FORM.billingZipCode" default="">
    <cfparam name="FORM.billingCountryID" default="232">
    <!--- Payment Agreement --->
    <cfparam name="FORM.registeringAgreement" default="0" />
	<cfparam name="FORM.airfareAgreement" default="0" />
    
    <cfscript>
		if ( LEN(URL.action) AND NOT LEN(FORM.action) ) {
			FORM.action = URL.action;
		}
		
		// Set Tour
		if ( VAL(FORM.tourID) ) {
			// Set Tour in Session Variable			
			APPLICATION.CFC.SESSION.setTripSessionVariables(tourID=FORM.tourID);											
		}
		
		// Set Student
		if ( VAL(FORM.studentID) ) {
			// Set Tour in Session Variable			
			APPLICATION.CFC.SESSION.setTripSessionVariables(studentID=FORM.studentID);											
		}
	</cfscript>

    <!----Set Default Properties---->
    <Cfquery name="qGetStudentInfo" datasource="#APPLICATION.DSN.Source#">
    	SELECT 
            s.uniqueid, 
            s.studentID, 
            s.companyID, 
            s.hostID,  
            s.regionAssigned,    
        	s.familylastname, 
            s.firstname, 
            s.email, 
            s.sex,
            s.med_allergies,
            s.other_Allergies,
            c.countryname
    	FROM 
        	smg_students s
    	LEFT JOIN 
        	smg_countrylist c on c.countryid = s.countrybirth
     	WHERE	
     		studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(SESSION.TOUR.studentID)#"> 
    </cfquery>

	<!--- Get Total Registrations --->
    <cfquery name="qGetTourList" datasource="#APPLICATION.DSN.Source#">
        SELECT 
            tour_ID,
            tour_name,
            tour_date,
            totalSpots,
            tour_status,
            spotLimit,
            SUM(total) AS total
        FROM
        (
        
            SELECT 
                t.tour_ID,
                t.tour_name,
                t.tour_date,
                t.totalSpots,
                t.tour_status,
                t.spotLimit,
                COUNT(st.studentID) AS total
            FROM 
                smg_tours t
            LEFT OUTER JOIN
                student_tours st ON st.tripID = t.tour_ID
                    AND
                        st.paid IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                    AND
                        st.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
            WHERE
                t.tour_status != <cfqueryparam cfsqltype="cf_sql_varchar" value="inactive">
                
            GROUP BY
                t.tour_ID
    
            UNION
    
            SELECT 
                t.tour_ID,
                t.tour_name,
                t.tour_date,
                t.totalSpots,
                t.tour_status,
                t.spotLimit,
                COUNT(sts.siblingID) AS total
            FROM 
                smg_tours t
            INNER JOIN	
                student_tours_siblings sts ON sts.tripID = t.tour_ID
                    AND
                        sts.paid IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes">
            WHERE
                t.tour_status != <cfqueryparam cfsqltype="cf_sql_varchar" value="inactive">
                        
            GROUP BY
                t.tour_ID
        
        ) AS deviredTable
        
        GROUP BY
        	tour_ID
        
        ORDER BY
        	tour_name
    </cfquery>

    <cfquery name="qGetTourDetails" datasource="#APPLICATION.DSN.Source#">
        SELECT 
        	* 
        FROM 
        	smg_tours 
        WHERE 
        	tour_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(SESSION.TOUR.tourID)#">
    </cfquery>
	
    <cfquery name="qGetStudentPendingRegistration" datasource="#APPLICATION.DSN.Source#">
        SELECT 
        	* 
        FROM 
        	student_tours 
        WHERE 
     		studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.studentID)#"> 
        AND
        	tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(SESSION.TOUR.tourID)#">
        AND
        	paid IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
    </cfquery>
	   
    <cfquery name="qGetSiblingsPendingRegistration" datasource="#APPLICATION.DSN.Source#">
        SELECT 
        	sts.ID,
            sts.masterTripID,
            sts.fk_studentID,
            sts.siblingID,
            sts.tripID,
            sts.paid,
            shc.name,
            shc.sex,
            shc.lastName,
            shc.birthDate
        FROM 
        	student_tours_siblings sts
        INNER JOIN	
			smg_host_children shc ON shc.childID = sts.siblingID
        WHERE 
     		sts.fk_studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.studentID)#"> 
        AND
        	sts.tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentPendingRegistration.tripID)#">
        AND
        	sts.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
    </cfquery>
    
    <cfscript>
		// Check if there is a valid student, if not go back to the tours selection page
		/*
		if ( NOT VAL(SESSION.TOUR.studentID) AND listFind("lookUpAccount,preference,bookTrip,confirmation", FORM.action) ) {
			// Set Action to Home
			FORM.action = 'home';
		}
		*/
		
		// Check if there is a valid tour, if not go back to the tours selection page
		if ( NOT VAL(SESSION.TOUR.tourID) AND listFind("tripDetails,lookUpAccount,preferences,bookTrip,confirmation", FORM.action) ) {
			// Set Action to Home
			FORM.action = 'home';
		}
		
		if (FORM.action EQ 'logOut') {			
			// Logout student
			APPLICATION.CFC.SESSION.tripSectionLogout();
			
			// Go to Book Trip - CC Processing
			Location('#CGI.SCRIPT_NAME#', 'no');
		}
	</cfscript>
    
</cfsilent>

<cfoutput>
    
    <!--- Include Header ---> 
    <cfinclude template="extensions/includes/header.cfm">
    
		<!--- 
            Check to see which action we are taking. 
        --->
        <cfswitch expression="#FORM.action#">
        
            <cfcase value="home,tripDetails,lookUpAccount,preferences,myTripDetails,bookTrip,confirmation" delimiters=",">
        
                <!--- Include template --->
                <cfinclude template="_#FORM.action#.cfm" />
        
            </cfcase>
        
            <!--- The default case is the login page --->
            <cfdefaultcase>
                
                <!--- Include template --->
                <cfinclude template="_home.cfm" />
        
            </cfdefaultcase>
        
        </cfswitch>
                            
    <!--- Include Header ---> 
    <cfinclude template="extensions/includes/footer.cfm">
        
</cfoutput>