<!--- ------------------------------------------------------------------------- ----
	
	File:		initialConfidentialVisitForm.cfm
	Author:		Marcus Melo
	Date:		January 18, 2013
	Desc:		Host Family Initial Confidential Visit Form
				
	Updates:
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

    <!--- Param URL Variables --->
    <cfparam name="URL.hostID" default="0">
    <cfparam name="URL.seasonID" default="0">
    
	<!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.pr_ID" default="0">
    <cfparam name="FORM.hostID" default="0">
    <cfparam name="FORM.seasonID" default="0">
    <cfparam name="FORM.studentID" default= "0">
    <cfparam name="FORM.dateofvisit" default= "">
    <cfparam name="FORM.neighborhoodAppearance" default= "">
    <cfparam name="FORM.avoid" default= "">
    <cfparam name="FORM.homeAppearance" default= "">
    <cfparam name="FORM.famImpression" default= "">
    <cfparam name="FORM.typeOfHome" default= "">
    <cfparam name="FORM.numberBedRooms" default= "">
    <cfparam name="FORM.numberBathRooms" default= "">
    <cfparam name="FORM.livingRoom" default= "">
    <cfparam name="FORM.diningRoom" default= "">
    <cfparam name="FORM.kitchen" default= "">
    <cfparam name="FORM.homeDetailsOther" default= "">
    <cfparam name="FORM.famInterested" default= "">
    <cfparam name="FORM.exchangeInterest" default= "">
    <cfparam name="FORM.livingYear" default= "">
    <cfparam name="FORM.famReservations" default= "">
    <cfparam name="FORM.ownBed" default= "">
    <cfparam name="FORM.bathRoom" default= "">
    <cfparam name="FORM.outdoorsFromBedroom" default= "">
    <cfparam name="FORM.storageSpace" default= "">
    <cfparam name="FORM.studySpace" default= "">
    <cfparam name="FORM.privacy" default= "">
    <cfparam name="FORM.pets" default= "">
    <cfparam name="FORM.other" default= "">

    <cfscript>
		// Check if we have a valid URL.hostID
		if ( VAL(URL.hostID) AND NOT VAL(FORM.hostID) ) {
			FORM.hostID = URL.hostID;
		}
		
		// Check if we have a valid URL.seasonID
		if ( VAL(URL.seasonID) AND NOT VAL(FORM.seasonID) ) {
			FORM.seasonID = URL.seasonID;
		}

		// Get List of Host Family Applications
		qGetHostInfo = APPLICATION.CFC.HOST.getApplicationList(hostID=FORM.hostID);	

		// Get Confidential Visit Form
		qGetConfidentialVisitForm = APPLICATION.CFC.PROGRESSREPORT.getVisitInformation(hostID=VAL(FORM.hostID),reportType=5,seasonID=FORM.seasonID);

		// Get Application Approval History for this section
		qGetApprovalHistory = APPLICATION.CFC.HOST.getApplicationApprovalHistory(hostID=qGetHostInfo.hostID, itemID=14,seasonID=FORM.seasonID);

		// This returns the approval fields for the logged in user
		stCurrentUserFieldSet = APPLICATION.CFC.HOST.getApprovalFieldNames();
		
		// This Returns who is the next user approving / denying the report
		stUserOneLevelUpInfo = APPLICATION.CFC.USER.getUserOneLevelUpInfo(currentUserType=qGetHostInfo.applicationStatusID,regionalAdvisorID=qGetHostInfo.regionalAdvisorID);
		
		// This returns the fields that need to be checked
		stOneLevelUpFieldSet = APPLICATION.CFC.HOST.getApprovalFieldNames(userType=stUserOneLevelUpInfo.userType);

		// If report has not been approved by current level or has not been denied by upper level - Edit Report
		if ( qGetApprovalHistory[stCurrentUserFieldSet.statusFieldName][qGetApprovalHistory.currentrow] NEQ 'approved' OR qGetApprovalHistory[stOneLevelUpFieldSet.statusFieldName][qGetApprovalHistory.currentrow] EQ 'denied' ) {
			// Allow edit	
			vIsEditAllowed = true;
		} else {
			// Read only if it has been approved 
			vIsEditAllowed = false;
		}			
	</cfscript>
    
    <!--- FORM Submitted --->
    
      <!----
            // Living Room
            if ( NOT LEN(TRIM(FORM.livingRoom)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please describe the living room.");
            }
            ---->
			<!----
            // Dining Room
            if ( NOT LEN(TRIM(FORM.diningRoom)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please describe the dining room.");
            }
            ---->
            <!----
            // Exchange Interest
            if ( NOT LEN(TRIM(FORM.exchangeInterest)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if family shows interest in the exchange program.");
            }
           ---->
           	<!----
            // Fam Reservations
            if ( NOT LEN(TRIM(FORM.famReservations)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate any reservations you have about this family.");
            }
			---->
			<!----
			// Bedroom
            if ( NOT LEN(TRIM(FORM.ownBed)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if student will have their own bed.");
            }
            ---->
			<!----
            // Bathroom
            if ( NOT LEN(TRIM(FORM.bathRoom)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if student will have access to a bathroom.");
            }
            ---->
            <!----
            // Privacy
            if ( NOT LEN(TRIM(FORM.privacy)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if student will have privacy.");
            }
           ---->
    <cfif FORM.submitted>

		<cfscript>
			// Data Validation
			
			// Check if we have an AR assigned
            if ( NOT VAL(qGetHostInfo.areaRepresentativeID) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please assign an Area Representative before submitting this form.");
            }	

			// Date of Visit
            if ( NOT isDate(FORM.dateOfVisit) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter the date you visited the home.");
            }	
			
            // Date of Visit
            if ( isDate(FORM.dateOfVisit) AND FORM.dateOfVisit GT now() ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter a past date for the date of visit.");
            }	
			
            // Neighborhood Appearance
            if ( NOT LEN(TRIM(FORM.neighborhoodAppearance)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please describe the neighboorhoods appearance.");
            }	
            
            // Avoid Areas
            if ( NOT LEN(TRIM(FORM.avoid)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please describe the neighboorhoods location.");
            }
            
            // Home Appearance
            if ( NOT LEN(TRIM(FORM.homeAppearance)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please describe the homes appearance.");
            }
          
            // Family Impression
            if ( NOT LEN(TRIM(FORM.famImpression)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please describe family impression.");
            }
		  
            // Home Type
            if ( NOT LEN(TRIM(FORM.typeOfHome)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please describe the type of home.");
            }
            
            // Number of Bedrooms
            if ( NOT LEN(TRIM(FORM.numberBedRooms)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate the number of bedrooms.");
            }
            
            // Number of Bathrooms
            if ( NOT LEN(TRIM(FORM.numberBathRooms)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate the number of bathrooms.");
            }
          
            // Kitchen
            if ( NOT LEN(TRIM(FORM.kitchen)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please describe the kitchen.");
            }
            
            // Family Interest
            if ( NOT LEN(TRIM(FORM.famInterested)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if family is affectionate and interested in hosting a student.");
            }
            
            // Living Year
            if ( NOT LEN(TRIM(FORM.livingYear)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if you would feel comfortable having your child live with this family.");
            }
			
		
            // Outdoors from Bedroom
            if ( NOT LEN(TRIM(FORM.outdoorsFromBedroom)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if student will be able to access the outdoors from their bedroom.");
            }
            
            // Storage Space
            if ( NOT LEN(TRIM(FORM.storageSpace)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if student will have adequte storage space.");
            }
			
			  // Privacy
            if ( NOT LEN(TRIM(FORM.studySpace)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if student will have adequte space to study.");
            }
            
			
            //  Pets
            if ( NOT LEN(TRIM(FORM.pets)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if there are any pets in the home.");
            }
			
        </cfscript>
        
		<!--- Check if there are no errors --->
        <cfif NOT SESSION.formErrors.length() AND VAL(FORM.hostID)>			
            	
            <!--- Update --->
            <cfif VAL(FORM.pr_ID)>
            
            	<!--- Check if secondvisitanswers record exists --->
                <cfquery name="qGetSecondVisitAnswersRecord" datasource="#APPLICATION.DSN#">
                	SELECT *
                    FROM secondvisitanswers
                    WHERE fk_reportID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.pr_ID)#">
                </cfquery>
            
            	<cfif VAL(qGetSecondVisitAnswersRecord.recordCount)>
                    <cfquery datasource="#APPLICATION.DSN#">
                        UPDATE 
                            secondvisitanswers 
                        SET
                            dateOfVisit = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.dateOfVisit#">,
                            neighborhoodAppearance= <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.neighborhoodAppearance#">,
                            avoid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.avoid#">,
                            homeAppearance = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.homeAppearance#">,
                            typeOfHome = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.typeOfHome#">,
                            numberBedRooms = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.numberBedRooms)#">,
                            numberBathRooms = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.numberBathRooms)#">,
                            livingRoom = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.livingRoom#">,
                            diningRoom = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.diningRoom#">,
                            kitchen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.kitchen#">,
                            homeDetailsOther = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.homeDetailsOther#">,
                            famImpression = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.famImpression#">,
                            famInterested = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.famInterested#">,
                            famReservations = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.famReservations#">,
                            exchangeInterest =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.exchangeInterest#">,
                            livingYear = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.livingYear#">,
                            ownBed = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ownBed#">,
                            bathRoom =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.bathRoom#">,
                            outdoorsFromBedroom = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.outdoorsFromBedroom#">,
                            storageSpace = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.storageSpace#">,
                            studySpace = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.studySpace#">,
                            privacy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.privacy#">,
                            pets = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.pets#">,
                            other =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.other#">
                        WHERE 
                            fk_reportID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.pr_ID)#">                  
                    </cfquery>
            	<cfelse>
                	<cfquery datasource="#APPLICATION.DSN#">
                        INSERT INTO secondvisitanswers
                        (
                            fk_reportID,
                            dateOfVisit,
                            neighborhoodAppearance,
                            avoid,
                            homeAppearance,
                            typeOfHome,
                            numberBedRooms,
                            numberBathRooms,
                            livingRoom,
                            diningRoom,
                            kitchen,
                            homeDetailsOther,
                            famImpression,
                            famInterested,
                            famReservations,
                            exchangeInterest,
                            livingYear,
                            ownBed,
                            bathRoom,
                            outdoorsFromBedroom,
                            storageSpace,
                            studySpace,
                            privacy,
                            pets,
                            other
                        )
                        VALUES
                        (
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.pr_ID#">,
                            <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.dateOfVisit#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.neighborhoodAppearance#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.avoid#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.homeAppearance#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.typeOfHome#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.numberBedRooms)#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.numberBathRooms)#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.livingRoom#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.diningRoom#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.kitchen#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.homeDetailsOther#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.famImpression#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.famInterested#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.famReservations#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.exchangeInterest#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.livingYear#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ownBed#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.bathRoom#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.outdoorsFromBedroom#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.storageSpace#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.studySpace#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.privacy#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.pets#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.other#">
                        )
                    </cfquery>
                </cfif> 
            
            <!--- Insert --->
            <cfelse>
            
            	<!--- Insert PR --->
                <cfquery datasource="#APPLICATION.DSN#" result="newRecord">
                    INSERT INTO 
                        progress_reports 
                    (
                        fk_reportType, 
                        fk_student,
                        fk_seasonID,
                        pr_uniqueid, 
                        pr_month_of_report, 
                        fk_sr_user, 
                        fk_ra_user, 
                        fk_rd_user, 
                        fk_ny_user, 
                        fk_host
                    )
                    VALUES 
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="5">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="0">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.seasonID)#">,
                        <cfqueryparam cfsqltype="cf_sql_idstamp" value="#createuuid()#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#DateFormat(now(), 'm')#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetHostInfo.areaRepresentativeID)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetHostInfo.regionalManagerID)#" null="#yesNoFormat(TRIM(qGetHostInfo.regionalManagerID) EQ '')#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetHostInfo.regionalManagerID)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetHostInfo.facilitatorID)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.hostID)#">
                    )  
                </cfquery>
                
                <cfscript>
					// Set New PR ID
					FORM.pr_ID = newRecord.GENERATED_KEY;
				</cfscript>
                            
                <!--- Insert Answers --->
                <cfquery datasource="#APPLICATION.DSN#">
                    INSERT INTO
                        secondvisitanswers
                    (
                        fk_reportID,
                        dateOfVisit,
                        neighborhoodAppearance,
                        avoid,
                        homeAppearance,
                        typeOfHome,
                        numberBedRooms,
                        numberBathRooms,
                        livingRoom,
                        diningRoom,
                        kitchen,
                        homeDetailsOther,
                        famImpression,
                        famInterested,
                        famReservations,
                        exchangeInterest,
                        livingYear,
                        ownBed,
                        bathRoom,
                        outdoorsFromBedroom,
                        storageSpace,
                        studySpace,
                        privacy,
                        pets,
                        other
                    )
                    VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.pr_ID#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.dateOfVisit#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.neighborhoodAppearance#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.avoid#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.homeAppearance#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.typeOfHome#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.numberBedRooms)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.numberBathRooms)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.livingRoom#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.diningRoom#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.kitchen#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.homeDetailsOther#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.famImpression#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.famInterested#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.famReservations#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.exchangeInterest#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.livingYear#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ownBed#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.bathRoom#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.outdoorsFromBedroom#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.storageSpace#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.studySpace#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.privacy#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.pets#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.other#">
                    )
                </cfquery>
                
                <cfscript>
					// Refresh Query used in the approval process
					qGetConfidentialVisitForm = APPLICATION.CFC.PROGRESSREPORT.getVisitInformation(hostID=VAL(FORM.hostID),reportType=5,seasonID=FORM.seasonID);
				</cfscript>
            
            </cfif>
            
			<cfscript>
                // Use same approval process of the host family sections
                APPLICATION.CFC.HOST.updateSectionStatus(
                    hostID=FORM.hostID,
                    itemID=14,
					seasonID=FORM.seasonID,
                    action="approved",
                    notes="",
                    areaRepID=qGetHostInfo.areaRepresentativeID,
                    regionalAdvisorID=qGetHostInfo.regionalAdvisorID,
                    regionalManagerID=qGetHostInfo.regionalManagerID
                );
            </cfscript>
        
            <!--- Approved on the PR Table as Well --->
            <cfquery datasource="#APPLICATION.DSN#" result="test">
                UPDATE 
                    progress_reports 
                SET
                    #stCurrentUserFieldSet.prApproveFieldName# = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    pr_rejected_date = <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                WHERE 
                    pr_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.pr_id#">
            </cfquery>
        
            <cfscript>
				// Set Page Message
				SESSION.pageMessages.Add("Report successfully submitted. This window will close shortly.");
			</cfscript>
    
    	</cfif>
            
    <!--- Set Default FORM Values --->
    <cfelse>
		
        <cfscript>
			// Set FORM Values   
			FORM.pr_ID = qGetConfidentialVisitForm.pr_ID;
			FORM.dateOfVisit = qGetConfidentialVisitForm.dateOfVisit;
			FORM.neighborhoodAppearance = qGetConfidentialVisitForm.neighborhoodAppearance;
			FORM.avoid = qGetConfidentialVisitForm.avoid;
			FORM.homeAppearance = qGetConfidentialVisitForm.homeAppearance;
			FORM.typeOfHome = qGetConfidentialVisitForm.typeOfHome;
			FORM.numberBedRooms = qGetConfidentialVisitForm.numberBedRooms;
			FORM.numberBathRooms = qGetConfidentialVisitForm.numberBathRooms;
			FORM.livingRoom = qGetConfidentialVisitForm.livingRoom;
			FORM.diningRoom = qGetConfidentialVisitForm.diningRoom;
			FORM.kitchen = qGetConfidentialVisitForm.kitchen;
			FORM.homeDetailsOther = qGetConfidentialVisitForm.homeDetailsOther;
			FORM.famImpression = qGetConfidentialVisitForm.famImpression;
			FORM.famInterested = qGetConfidentialVisitForm.famInterested;
			FORM.famReservations = qGetConfidentialVisitForm.famReservations;
			FORM.exchangeInterest = qGetConfidentialVisitForm.exchangeInterest;
			FORM.livingYear = qGetConfidentialVisitForm.livingYear;
		    FORM.ownBed = qGetConfidentialVisitForm.ownBed;
			FORM.bathRoom = qGetConfidentialVisitForm.bathRoom;
			FORM.outdoorsFromBedroom = qGetConfidentialVisitForm.outdoorsFromBedroom;
			FORM.storageSpace = qGetConfidentialVisitForm.storageSpace;
			FORM.studySpace = qGetConfidentialVisitForm.studySpace;
			FORM.privacy = qGetConfidentialVisitForm.privacy;
			FORM.pets = qGetConfidentialVisitForm.pets;
			FORM.other = qGetConfidentialVisitForm.other;
    	</cfscript>
        
    </cfif>

</cfsilent>    

<cfoutput>
	
	<!--- Page Header --->
    <gui:pageHeader
        headerType="applicationNoHeader"
        filePath="../"
    />	

		<style type="text/css">
            body{
                font-family:"Lucida Grande", "Lucida Sans Unicode", Verdana, Arial, Helvetica, sans-serif;
                font-size:12px;
            }
            p, h1, form, button{
                border:0; 
                margin:0; 
                padding:0;
            }
            .spacer{
                clear:both; 
                height:1px;
            }
            /* ----------- My Form ----------- */
            .myform{
                margin:0 auto;
                width:700px;
                padding:14px;
            }
            /* ----------- stylized ----------- */
            .stylized{
                border:solid 2px ##b7ddf2;
                background:##ebf4fb;
            }
            .stylized h1 {
                font-size:14px;
                font-weight:bold;
                margin-bottom:8px;
            }
            .stylized p{
                font-size:11px;
                color:##666666;
                border-bottom:solid 1px ##b7ddf2;
				margin-bottom:10px;
				padding-bottom:10px;
            }
            .stylized span.title {
                display:block;
                font-weight:bold;
                text-align:right;
                width:250px;
                float:left;
                padding-right:15px;
            }
            .stylized .small{
                color:##666666;
                display:block;
                font-size:11px;
                font-weight:normal;
                text-align:right;
                width:240px;
            }
            .stylized label {
                padding-right: 15px;
                vertical-align: top;
            }
            .stylized label.rightItem {
				padding-right:0px;
				margin-right:5px;
				margin:2px 5px 5px 0px;
                vertical-align: top;
                width:80px;
				display:inline-block;
				text-align:right;
            }
            .stylized button{
                clear:both;
                margin-left:150px;
                width:125px;
                height:31px;
                background:##666666 no-repeat;
                text-align:center;
                line-height:31px;
                color:##FFFFFF;
                font-size:11px;
                font-weight:bold;
				cursor:pointer;
            }
        </style>
    
    	<!--- Close Window --->
        <cfif VAL(FORM.submitted) AND NOT SESSION.formErrors.length()>
        
			<script language="javascript">
                // Close Window After 1.5 Seconds
                setTimeout(function() { parent.$.fn.colorbox.close(); }, 1500);
            </script>
		
        </cfif>
        
        <form action="#CGI.SCRIPT_NAME#" method="POST"> 
            <input type="hidden" name="submitted" value="1" />
            <input type="hidden" name="pr_ID" value="#FORM.pr_id#" />
            <input type="hidden" name="hostID" value="#FORM.hostID#" />
            <input type="hidden" name="seasonID" value="#FORM.seasonID#" />
        	
            <div class="myform stylized">

	            <h1>Initial Home Visit Report - #FORM.pr_ID#</h1>
                
                <p>
                    <strong>Host Family:</strong> 
                    #APPLICATION.CFC.HOST.displayHostFamilyName(
                        fatherFirstName=qGetHostInfo.fatherFirstName,
                        fatherLastName=qGetHostInfo.fatherLastName,
                        motherFirstName=qGetHostInfo.motherFirstName,
                        motherLastName=qGetHostInfo.motherLastName)# (###qGetHostInfo.hostid#) - 
                        #qGetHostInfo.city#, #qGetHostInfo.state# #qGetHostInfo.zip#
              	</p>
                
                <p>
					<strong>Area Representative:</strong> 
                    
                    <cfif NOT VAL(qGetHostInfo.areaRepresentativeID)>
                    	<span class="required">Please <a href="../index.cfm?curdoc=host_fam_info&hostid=#FORM.hostID#" target="_blank"> click here </a> to assign an area representative before filling out the report</span>
                    <cfelse>
                        #qGetHostInfo.areaRepresentative#
                    </cfif> <br />		
                                        
                    <strong>Regional Advisor:</strong> #qGetHostInfo.regionalAdvisor# <br />
					
                    <strong>Regional Manager:</strong> #qGetHostInfo.regionalManager# <br />

                  	<strong>Facilitator:</strong> #qGetHostInfo.facilitator# <br />
                </p>
                
				<!--- Page Messages --->
                <gui:displayPageMessages 
                    pageMessages="#SESSION.pageMessages.GetCollection()#"
                    messageType="divOnly"
                    width="90%"
                    />
                
                <!--- Form Errors --->
                <gui:displayFormErrors 
                    formErrors="#SESSION.formErrors.GetCollection()#"
                    messageType="divOnly"
                    width="90%"
                    />
            
                <!--- Form Values --->
                <span class="title">
                	Date of Visit <span class="required">*</span>
                	<span class="small">Date you visited the home</span>
                </span>
                
				<cfif vIsEditAllowed>
                    <input type="text" name="dateOfVisit" value="#DateFormat(FORM.dateofvisit, 'mm/dd/yyyy')#" class="datePicker" placeholder='MM/DD/YYYY'>
                <cfelse>
                   	#DateFormat(FORM.dateofvisit, 'mm/dd/yyyy')# 
                </cfif>
                
                <br /><br /><br />
                
                <span class="title">
                    Neighborhood Appearance <span class="required">*</span>
                    <span class="small">General look and feel</span>
                </span>
                
                <cfif vIsEditAllowed>
                    <input type="radio" name="neighborhoodAppearance" id="neighborhoodAppearanceExcellent" value='Excellent' <cfif FORM.neighborhoodAppearance is 'Excellent'>checked</cfif> /> 
                    <label for="neighborhoodAppearanceExcellent">Excellent</label>
                    <input type="radio" name="neighborhoodAppearance" id="neighborhoodAppearanceAverage" value='Average' <cfif FORM.neighborhoodAppearance is 'Average'>checked</cfif> /> 
                    <label for="neighborhoodAppearanceAverage">Average</label>
                    <input type="radio" name="neighborhoodAppearance" id="neighborhoodAppearancePoor" value='Poor' <cfif FORM.neighborhoodAppearance is 'Poor'>checked</cfif> />    
                    <label for="neighborhoodAppearancePoor">Poor</label>
                <cfelse>
                    #FORM.neighborhoodAppearance#
                </cfif>
                
                <br /><br /><br />
                
                <span class="title">
                    Neighborhood Location <span class="required">*</span>
                    <span class="small">Is home in or near an area to be avoided.</span>
                </span>
                
                <cfif vIsEditAllowed>
                    <input type="radio" value='Yes' name="avoid" id="avoidYes" <cfif FORM.avoid is 'Yes'>checked</cfif>/> 
                    <label for="avoidYes" class="avoidYes">Yes</label> 
                    <input type="radio" value='No' name="avoid" id="avoidNo" <cfif FORM.avoid eq 'no'>checked</cfif> /> 
                    <label for="avoidNo" class="avoidNo">No</label>
                <cfelse>
                    #FORM.avoid#
                </cfif>
                
                <br /><br /><br />
                
                <span class="title">
                    Home Appearance <span class="required">*</span>
                    <span class="small">Cleanliness, Maintenance</span>
                </span>
                
                <cfif vIsEditAllowed>
                    <input type="radio" name="homeAppearance" id="homeAppearanceExcellent" value='Excellent' <cfif FORM.homeAppearance is 'Excellent'>checked</cfif> /> 
                    <label for="homeAppearanceExcellent">Excellent</label>
                    <input type="radio" name="homeAppearance" id="homeAppearanceAverage" value='Average' <cfif FORM.homeAppearance is 'Average'>checked</cfif>/> 
                    <label for="homeAppearanceAverage">Average</label> 
                    <input type="radio" name="homeAppearance" id="homeAppearancePoor" value='Poor' <cfif FORM.homeAppearance is 'Poor'>checked</cfif>/> 
                    <label for="homeAppearancePoor">Poor</label>
                <cfelse>
                    #FORM.homeAppearance#
                </cfif>
                
                <br /><br /><br />
                
                <span class="title">
                    Family Impression <span class="required">*</span>
                    <span class="small"></span>
                </span>
                
                <cfif vIsEditAllowed>
                    <input type="radio" name="famImpression" id="famImpressionWarm" value='Warm' <cfif FORM.famImpression is 'Warm'>checked</cfif> /> 
                    <label for="famImpressionWarm">Warm</label>
                    <input type="radio" name="famImpression" id="famImpressionCold" value='Cold' <cfif FORM.famImpression is 'Cold'>checked</cfif>/> 
                    <label for="famImpressionCold">Cold</label> 
                <cfelse>
                    #FORM.famImpression#
                </cfif>
               
                <br /><br /><br />
                
                <span class="title">
                    Type of Home <span class="required">*</span>
                    <span class="small">&nbsp;</span>
                </span>
                
                <cfif vIsEditAllowed>
                    <input type="radio" name="typeOfHome" id="typeOfHomeSingle" value='Single Family' <cfif FORM.typeOfHome is 'Single Family'>checked</cfif> />
                    <label for="typeOfHomeSingle">Single Family</label>
                    <input type="radio" name="typeOfHome" id="typeOfHomeCondominium" value='Condominium' <cfif FORM.typeOfHome is 'Condominium'>checked</cfif> /> 
                    <label for="typeOfHomeCondominium">Condominium</label> 
                    <input type="radio" name="typeOfHome" id="typeOfHomeApartment" value='Apartment' <cfif FORM.typeOfHome is 'Apartment'>checked</cfif> /> 
                    <label for="typeOfHomeApartment">Apartment</label><br />
                    <input type="radio" name="typeOfHome" id="typeOfHomeDuplex" value='Duplex' <cfif FORM.typeOfHome is 'Duplex'>checked</cfif> /> 
                    <label for="typeOfHomeDuplex">Duplex</label>
                    <input type="radio" name="typeOfHome" id="typeOfHomeMobile" value='Mobile Home' <cfif FORM.typeOfHome is 'Mobile Home'>checked</cfif> /> 
                    <label for="typeOfHomeMobile">Mobile Home</label> 
                <cfelse>
                    #FORM.typeOfHome#
                </cfif>
                
                <br /><br /><br />
                
                <span class="title" <cfif vIsEditAllowed> style="height:200px;" <cfelse> style="height:120px;" </cfif>>
                    Home Details <span class="required">*</span>
                    <span class="small">Short Descriptions</span>
                </span>
                
                <label for="numberBedRooms" class="rightItem">Bedrooms <span class="required">*</span></label>
                <cfif vIsEditAllowed>
                    <select name="numberBedRooms" id="numberBedRooms" class="smallField">
                    <option value=""></option>
                    <cfloop from="0" to="10" index="i">
                        <option value=#i# <cfif FORM.numberBedRooms EQ i>selected</cfif>>#i#</option>
                    </cfloop>
                    </select>
                <cfelse>
                	#FORM.numberBedRooms#
                </cfif>
                
                <br />
                
                <label for="numberBathRooms" class="rightItem">Bathrooms <span class="required">*</span></label>     
                <cfif vIsEditAllowed>
                    <select name="numberBathRooms" id="numberBathRooms" class="smallField">
                        <option value=""></option>
                        <cfloop from="0" to="10" index="i">
                            <option value=#i# <cfif FORM.numberBathRooms EQ i>selected</cfif>>#i#</option>
                        </cfloop>
                    </select>
                <cfelse>
                    #FORM.numberBathRooms#
                </cfif>
                
                <br />
                <!----
                <label for="livingRoom" class="rightItem">Living Room <span class="required">*</span></label>
				<cfif vIsEditAllowed>
                    <input type="text" name="livingRoom" id="livingRoom" class="xLargeField" value="#FORM.livingRoom#"/>
                <cfelse>
                    #FORM.livingRoom#
                </cfif>
                
                <br />
                
                <label for="diningRoom" class="rightItem">Dining Room <span class="required">*</span></label>
                <cfif vIsEditAllowed>
                    <input type="text" name="diningRoom" id="diningRoom" class="xLargeField" value="#FORM.diningRoom#"/>
                <cfelse>
                    #FORM.diningRoom#
                </cfif>
                
                <br />
                ---->
                <label for="kitchen" class="rightItem">Kitchen <span class="required">*</span></label>
                <cfif vIsEditAllowed>
                    <input type="text" name="kitchen" id="kitchen" class="xLargeField"  value="#FORM.kitchen#"/>
                <cfelse>
                    #FORM.kitchen#
                </cfif>
                
                <br />
                
                <label for="homeDetailsOther" class="rightItem">Other</label>
                <cfif vIsEditAllowed>
                    <textarea name="homeDetailsOther" id="homeDetailsOther" class="mediumTextArea">#FORM.homeDetailsOther#</textarea>
                <cfelse>
                    #FORM.homeDetailsOther#
                </cfif>
                
                <p style="clear:both;">&nbsp;</p>   
                
                <span class="title">
                	In your opinion is the entire family affectionate and interested in hosting a student? <span class="required">*</span>
                	<span class="small"></span>
                </span>
                <cfif vIsEditAllowed>
                	<input type="text" name="famInterested" class="xLargeField" value="#FORM.famInterested#"/>
                <cfelse>
                	#FORM.famInterested#
                </cfif>
                
                <br /><br /><br /><br />
                <!----
                <span class="title">
                	Do all family members (including children) show interest in the exchange program? <span class="required">*</span>
                	<span class="small"></span>
                </span>
                <cfif vIsEditAllowed>	
                    <input type="text" name="exchangeInterest" class="xLargeField" value="#FORM.exchangeInterest#"/>
                <cfelse>
                    #FORM.exchangeInterest#
                </cfif>
                
                <br /><br /><br /><br />
                ---->
                <span class="title">
                	Would you feel comfortable having your child live with this family for up to one year? <span class="required">*</span>
                    <span class="small"></span>
                </span>
                <cfif vIsEditAllowed>	
                    <input type="text" name="livingYear" class="xLargeField" value="#FORM.livingYear#"/>
                <cfelse>
                    #FORM.livingYear#
                </cfif>
                
                <br /><br /><br /><br />
                <!----
                <span class="title">
                	What reservations do you have, if any, about these people as a potential host family? <span class="required">*</span>
                	<span class="small"></span>
                </span>
                <cfif vIsEditAllowed>	
                    <input type="text" name="famReservations" class="xLargeField" value="#FORM.famReservations#"/>
                <cfelse>
                    #FORM.famReservations#
                </cfif>
                
                <br /><br /><br /><br />
                
                 
                
                  <span class="title">
               Will the exchange student have their own permanent bed?<span class="required">*</span> 
                    <span class="small">Bed may not be a futon or inflatable<br />if two students, two seperate beds</span>
                
                </span>
                <cfif vIsEditAllowed>	
                    
                    <select name="ownBed">
                    <option value=""></option>
                    	<option value="Solo bedroom - permanent bed" <cfif FORM.ownBed eq 'Solo bedroom - permanent bed'>selected</cfif>>Solo bedroom - permanent bed</option>
                        <option value="Shared bedroom - two permanent beds" <cfif FORM.ownBed eq 'Shared bedroom - two permanent beds'>selected</cfif>>Shared bedroom - two permanent beds</option>
                        <option value="No permanent bed" <cfif FORM.ownBed eq 'No permanent bed'>selected</cfif>>No permanent bed</option>
                    </select>
                <cfelse>
                    #FORM.ownBed#
                </cfif>
           
                          <br /><br /><br /><br /><br />
                
                
           <span class="title">
              Will the exchange student have access to a bathroom?<span class="required">*</span>   
           </span>      
                <cfif vIsEditAllowed>	
                    <input type="text" name="bathRoom" class="xLargeField" value="#FORM.bathRoom#"/>
                <cfelse>
                    #FORM.bathRoom#
                </cfif>
         
         <br /><br /><br /><br />
    ---->
          <span class="title">
               Will exchange student have access to the outdoors from their bedroom?<span class="required">*</span> 
                    <span class="small">i.e. a door or window</span>
              
          </span>
                <cfif vIsEditAllowed>	
                    <input type="text" name="outdoorsFromBedroom" class="xLargeField" value="#FORM.outdoorsFromBedroom#"/>
                <cfelse>
                    #FORM.outdoorsFromBedroom#
                </cfif>
                   
         <br /><br /><br /><br />
    
            <span class="title">
               Will the exchange student have a closet and/or dresser that the exchange student can use to store his/her clothing and other belongings?<span class="required">*</span>
            </span>
                <cfif vIsEditAllowed>	
                  
                    <select name="storageSpace">
                    <option value=""></option>
                    	<option value="Yes - in the exchange student's room" <cfif FORM.storageSpace eq "Yes - in the exchange student's room">selected</cfif>>Yes - in the exchange student's room</option>
                        <option value="Yes - adjacent to the exchange student's room" <cfif FORM.storageSpace eq "Yes - adjacent to the exchange student's room">selected</cfif>>Yes - adjacent to the exchange student's room</option>
                        <option value="Yes - in another part of the home" <cfif FORM.storageSpace eq 'Yes - in another part of the home'>selected</cfif>>Yes - in another part of the home</option>
                         <option value="No - no storage for exchange student" <cfif FORM.storageSpace eq 'No - no storage for exchange student'>selected</cfif>>No - no storage for exchange student</option>
                    </select>
                <cfelse>
                    #FORM.storageSpace#
                </cfif>
                     
                 <br /><br /><br /><br />
                 <br /><br />
           <!---- 
           <span class="title">
               Will the exchange student have privacy?<span class="required">*</span>
                    <span class="small">i.e. a door on their room</span>
               
            </span>
                <cfif vIsEditAllowed>	
                    <input type="text" name="privacy" class="xLargeField" value="#FORM.privacy#"/>
                <cfelse>
                    #FORM.privacy#
                </cfif>
          
         <br /><br /><br /><br />
	---->
            <span class="title">
               Will the exchange student have adequate study space?<span class="required">*</span>
            </span>
                <cfif vIsEditAllowed>		
                    
                       <select name="studySpace">
                       <option value=""></option>
                    	<option value="In exchange student's room" <cfif FORM.studySpace eq "In exchange student's room">selected</cfif>>In exchange student's room</option>
                        <option value="In another part of the home" <cfif FORM.studySpace eq 'In another part of the home'>selected</cfif>>In another part of the home</option>
                        <option value="No place in home to study" <cfif FORM.studySpace eq 'No place in home to study'>selected</cfif>>No place in home to study</option>
                    </select>
                <cfelse>
                    #FORM.studySpace#
                </cfif>
       
         <br /><br /><br /><br />
           <span class="title">
               Are there pets present in the home?<span class="required">*</span>
                    <span class="small">How many & what kind</span>
             
            </span>
                <cfif vIsEditAllowed>		
                    <input type="text" name="pets"  value="#FORM.pets#" class="xLargeField"/>
                <cfelse>
                    #FORM.pets#
                </cfif>
        
         <br /><br />
          <!----  
		  <br /><br />
          <span class="title">
               Other Comments
          </span>
                <cfif vIsEditAllowed>	
                    <textarea name="other" class="xLargeTextArea">#FORM.other#</textarea>
                <cfelse>
                    #FORM.other#
                </cfif>
         ---->

    	
                
                
                
                
                <cfif vIsEditAllowed>
                    <p>&nbsp;</p> 
                    
                    <span class="required">* Required fields</span>           
                
                    <div align="right">
                        <input type="hidden" name="submit" />
                        <button type="submit">Submit Information</button>
                    </div>
				</cfif>
                
            </div>  
        
   		</form>
        
        
    <!--- Page Footer --->
    <gui:pageFooter
        footerType="noFooter"
        filePath="../"
    />

</cfoutput>