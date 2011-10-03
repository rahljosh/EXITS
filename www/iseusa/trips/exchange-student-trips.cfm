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
    <!--- Login --->
    <cfparam name="FORM.studentID" default="">
    <cfparam name="FORM.hostID" default="">
    <cfparam name="FORM.familyLastName" default="">
    <cfparam name="FORM.dob" default="">
    <cfparam name="FORM.hostLastName" default="">
    <cfparam name="FORM.hostZip" default="">
    <cfparam name="FORM.hostCity" default="">
    <cfparam name="FORM.hostEmail" default="">
    <!--- Trip Preferences --->
    <cfparam name="FORM.otherTravelers" default="">
    <cfparam name="FORM.shareRoomNationality" default="">
    <cfparam name="FORM.shareRoomPerson1" default="">
    <cfparam name="FORM.shareRoomPerson2" default="">
    <cfparam name="FORM.shareRoomPerson3" default="">
    <cfparam name="FORM.medicalInformation" default="">
    <!--- Book Tour --->
    <cfparam name="FORM.emailAddress" default="">
    <cfparam name="FORM.confirmEmailAddress" default="">
	<!--- Credit Card Information --->
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
			APPLICATION.CFC.SESSION.setTripSessionVariables(tourID = FORM.tourID);											
		}
		
		// Set Student
		if ( VAL(FORM.studentID) ) {
			// Set Tour in Session Variable			
			APPLICATION.CFC.SESSION.setTripSessionVariables(studentID = FORM.studentID);											
		}
		
		// Force SSL
		if ( NOT APPLICATION.isServerLocal AND NOT CGI.SERVER_PORT_SECURE ) {
			Location("https://#CGI.SERVER_NAME##CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" "no");
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

	<cfquery name="qGetTourList" datasource="#APPLICATION.DSN.Source#">
		SELECT 
        	* 
        FROM 
        	smg_tours 
        WHERE 
        	tour_status != <cfqueryparam cfsqltype="cf_sql_varchar" value="inactive">
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
		if ( NOT VAL(SESSION.TOUR.studentID) AND listFind("lookUpAccount,preference,BookTrip,confirmation", FORM.action) ) {
			// Set Action to Home
			FORM.action = 'home';
		}
		*/
		
		// Check if there is a valid tour, if not go back to the tours selection page
		if ( NOT VAL(SESSION.TOUR.tourID) AND listFind("lookUpAccount,preference,BookTrip,confirmation", FORM.action) ) {
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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /><cfoutput>
<title>#APPLICATION.METADATA.pageTitle#</title>
<meta name="description" content="#APPLICATION.METADATA.pageDescription#" />
<meta name="keywords" content="#APPLICATION.METADATA.pageKeywords#" />
<link href="../css/ISEstyle.css" rel="stylesheet" type="text/css" />
<link href="../css/baseStyle.css" rel="stylesheet" type="text/css" />
<link href="../css/trips.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="#APPLICATION.PATH.jQueryTheme#" type="text/css" /> <!-- JQuery UI 1.8 Tab Style Sheet --> 
<script type="text/javascript" src="#APPLICATION.PATH.jQuery#"></script> <!-- jQuery -->
<script type="text/javascript" src="#APPLICATION.PATH.jQueryUI#"></script> <!-- JQuery UI 1.8 Tab --></cfoutput>                      
<script type="text/javascript" src="../linked/js/jquery.maskedinput-1.2.2.min.js"></script>
</head>
<body class="oneColFixCtr">

	<cfoutput>
    
        <div id="topBar">
            <cfinclude template="../topBarLinks.cfm">
            <div id="logoBox">
                <a href="/"><img src="../images/ISElogo.png" width="214" height="165" alt="ISE logo" border="0" /></a>
            </div>
        </div><!-- end topBar -->
            
        <div id="container">
        
            <div class="spacer2"></div>
            
            <div class="title"><cfinclude template="titleTrips.cfm"></div><!-- end title -->
            
            <div class="tabsBar">
                <cfinclude template="../tabsBar.cfm">
            </div><!-- end tabsBar -->
            
            <div id="mainContent">
            
                <div id="subPages">
                
                    <div class="whtTop"></div>
                    
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
                            
    				<div class="whtBottom"></div>
                    
    			</div><!-- end subPages -->
                
    		</div><!-- end mainContent -->
            
    	</div><!-- end container -->
        
        <div id="main" class="clearfix"></div>
        
        <div id="footer">
        
            <div class="clear"></div>
            
            <cfinclude template="../bottomLinks.cfm">
            
    	</div><!-- end footer -->
        
	</cfoutput>
    
</body>
</html>