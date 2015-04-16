<!--- ------------------------------------------------------------------------- ----
	
	File:		candidate_info.cfm
	Author:		Marcus Melo
	Date:		June 01, 2010
	Desc:		Candidate Information Screen. 
				PS: This page is viewable by Office and Intl. Reps

	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <!--- Param variables --->
    <cfparam name="URL.uniqueID" default="">
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.candidateID" default="0">
    <cfparam name="FORM.jobID" default="0">
    <cfparam name="FORM.hostCompanyID" default="0">
    <cfparam name="FORM.candCompID" default="0">
    <cfparam name="FORM.cancelStatus" default="">
    
    <cfajaxproxy cfc="extensions.components.hostCompany" jsclassname="HCComponent">
    
    <cfscript>
		
		// Get Candidate Information
		qGetCandidate = APPLICATION.CFC.CANDIDATE.getCandidateByID(uniqueID=URL.uniqueID);
		
		qCandidatePlaceCompany = APPLICATION.CFC.CANDIDATE.getCandidatePlacementInformation(candidateID=qGetCandidate.candidateID);
		
		// Get All Placement Information (Primary and Secondary)
		qGetAllPlacements = APPLICATION.CFC.CANDIDATE.getCandidatePlacementInformation(candidateID=qGetCandidate.candidateID, displayAll="1");
		
		// List of Countries
		qGetCountryList = APPLICATION.CFC.LOOKUPTABLES.getCountry();
		
		// List of Intl. Reps.
		qGetIntlRepList = APPLICATION.CFC.USER.getUsers(userType=8);
		
		// Get Arrival Information
		qGetArrival = APPLICATION.CFC.FLIGHTINFORMATION.getFlightInformationByCandidateID(
			candidateID=qGetCandidate.candidateID,
			flightType='arrival'
		);
	
		// Get Departure Information
		qGetDeparture = APPLICATION.CFC.FLIGHTINFORMATION.getFlightInformationByCandidateID(
			candidateID=qGetCandidate.candidateID,
			flightType='departure'
		);
		
		// Get Incident Report
		qGetIncidentReport = APPLICATION.CFC.CANDIDATE.getIncidentReport(candidateID=qGetCandidate.candidateID);
		
		// Get Cultural Activity Report
		qGetCulturalActivityReport = APPLICATION.CFC.CANDIDATE.getCulturalActivityReport(candidateID=qGetCandidate.candidateID);
		
		/*** Online Application ***/
		
		// Get Uploaded Resume
		qGetUploadedResume = APPLICATION.CFC.DOCUMENT.getDocumentsByFilter(foreignTable=APPLICATION.foreignTable, foreignID=qGetCandidate.candidateID, documentTypeID=9);
		
		// Get Uploaded Job Offer
		qGetUploadedJobOffer = APPLICATION.CFC.DOCUMENT.getDocumentsByFilter(foreignTable=APPLICATION.foreignTable, foreignID=qGetCandidate.candidateID, documentTypeID=7);
		
		// Get Uploaded DS-2019
		qGetUploadedDS2019 = APPLICATION.CFC.DOCUMENT.getDocumentsByFilter(foreignTable=APPLICATION.foreignTable, foreignID=qGetCandidate.candidateID, documentTypeID=36);
		
		// Get Questions for section 1
		qGetQuestionsSection1 = APPLICATION.CFC.ONLINEAPP.getQuestionByFilter(sectionName='section1');
		
		// Get Answers for section 1
		qGetAnswersSection1 = APPLICATION.CFC.ONLINEAPP.getAnswerByFilter(sectionName='section1', foreignTable=APPLICATION.foreignTable, foreignID=qGetCandidate.candidateID);

		// Param Online Application Form Variables 
		for ( i=1; i LTE qGetQuestionsSection1.recordCount; i=i+1 ) {
			param name="FORM[qGetQuestionsSection1.fieldKey[i]]" default="";
		}
		
		// Online Application Fields 
		for ( i=1; i LTE qGetAnswersSection1.recordCount; i=i+1 ) {
			FORM[qGetAnswersSection1.fieldKey[i]] = qGetAnswersSection1.answer[i];
		}

		// Get Questions for section 3
		qGetQuestionsSection3 = APPLICATION.CFC.ONLINEAPP.getQuestionByFilter(sectionName='section3');
		
		// Get Answers for section 3
		qGetAnswersSection3 = APPLICATION.CFC.ONLINEAPP.getAnswerByFilter(sectionName='section3', foreignTable=APPLICATION.foreignTable, foreignID=qGetCandidate.candidateID);

		// Param Online Application Form Variables 
		for ( i=1; i LTE qGetQuestionsSection3.recordCount; i=i+1 ) {
			param name="FORM[qGetQuestionsSection3.fieldKey[i]]" default="";
		}
		
		// Online Application Fields 
		for ( i=1; i LTE qGetAnswersSection3.recordCount; i=i+1 ) {
			FORM[qGetAnswersSection3.fieldKey[i]] = qGetAnswersSection3.answer[i];
		}
		
		// Get check in and evaluations
		qGetCheckIn = APPLICATION.CFC.CANDIDATE.getEvaluationAnswers(candidateID=qGetCandidate.candidateID,evaluationID=0);
		qGetEvaluation1 = APPLICATION.CFC.CANDIDATE.getEvaluationAnswers(candidateID=qGetCandidate.candidateID,evaluationID=1);
		qGetEvaluation2 = APPLICATION.CFC.CANDIDATE.getEvaluationAnswers(candidateID=qGetCandidate.candidateID,evaluationID=2);
		qGetEvaluation3 = APPLICATION.CFC.CANDIDATE.getEvaluationAnswers(candidateID=qGetCandidate.candidateID,evaluationID=3);
		qGetEvaluation4 = APPLICATION.CFC.CANDIDATE.getEvaluationAnswers(candidateID=qGetCandidate.candidateID,evaluationID=4);
	</cfscript>
		
    <cfinclude template="../querys/fieldstudy.cfm">
    <cfinclude template="../querys/program.cfm">
  
    <cfquery name="qGetStateList" datasource="#APPLICATION.DSN.Source#">
        SELECT id, state, stateName
        FROM smg_states
      	ORDER BY stateName
    </cfquery>
	
	<!--- Query of Queries --->
    <cfquery name="qGetProgramInfo" dbtype="query">
        SELECT 
            programID,
            programName,
            extra_sponsor
        FROM 
			program
		WHERE
        	programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCandidate.programID)#">
    </cfquery>

    <cfquery name="qGetHomeCountry" dbtype="query">
        SELECT 
            countryName
        FROM 
			qGetCountryList
		WHERE
        	countryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCandidate.home_country)#">
    </cfquery>

    <cfquery name="qGetBirthCountry" dbtype="query">
        SELECT 
            countryName
        FROM 
			qGetCountryList
		WHERE
        	countryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCandidate.birth_country)#">
    </cfquery>

    <cfquery name="qGetCitizenCountry" dbtype="query">
        SELECT 
            countryName
        FROM 
			qGetCountryList
		WHERE
        	countryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCandidate.citizen_country)#">
    </cfquery>

    <cfquery name="qGetResidenceCountry" dbtype="query">
        SELECT 
            countryName
        FROM 
			qGetCountryList
		WHERE
        	countryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCandidate.residence_country)#">
    </cfquery>

    <!--- Intl Rep. --->
    <cfquery name="qGetIntlRepInfo" datasource="#APPLICATION.DSN.Source#">
        SELECT 
            u.userid, 
            u.businessname, 
            u.extra_insurance_typeid,
            u.extra_accepts_sevis_fee,
            type.type
        FROM 
            smg_users u
        LEFT JOIN 
            smg_insurance_type type ON type.insutypeid = u.extra_insurance_typeid
        WHERE 
            u.userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidate.intrep#">
    </cfquery>
        
    <cfquery name="qHostCompanyList" datasource="#APPLICATION.DSN.Source#">
        SELECT 
        	hostCompanyID,
            name 
        FROM 
        	extra_hostcompany
        WHERE 
            extra_hostcompany.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
        AND 
        	name != <cfqueryparam cfsqltype="cf_sql_varchar" value="">
        ORDER BY 
        	name
    </cfquery>
    
    <cfquery name="qRequestedPlacement" dbtype="query">
        SELECT 
        	hostCompanyID,
            name 
        FROM 
        	qHostCompanyList
        WHERE 
            hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCandidate.requested_placement)#">
    </cfquery>

</cfsilent>

<script type='text/javaScript'>
	$(document).ready(function() {
		
		// Disable forms
		$(".formField").attr("disabled","disabled");
		
		// Display Self Placement Information
		displaySelfPlacementInfo();

		// Display Transfer Information
		displayTransferInfo();
		
		// Only display cancel placement option if this is a secondary placement
		<cfoutput>var #toScript(qCandidatePlaceCompany.isSecondary, "secondary")#;</cfoutput>
		if (secondary == 0) {
			$(".cancelSecondaryPlacement").attr("style", "display:none");
		} else {
			$(".cancelSecondaryPlacement").removeAttr("style");
		}
		
		// Pop Up Application 
		$('.popUpOnlineApplication').popupWindow({ 
			height:600, 
			width:1100,
			centerBrowser:1,
			scrollbars:1,
			resizable:1,
			windowName:'onlineApplication'
		}); 
		
		// Pop Up Flight Information 
		$('.popUpFlightInformation').popupWindow({ 
			height:600, 
			width:1100,
			centerBrowser:1,
			scrollbars:1,
			resizable:1,
			windowName:'flightInformation'
		}); 
			
		// JQuery Modal
		$(".jQueryModal").colorbox( {
			width:"50%", 
			height:"60%", 
			iframe:true,
			overlayClose:false,
			escKey:false,
			onClosed:function(){ window.location.reload(); }
		});		
			
	});

	// Jquery Masks 
	jQuery(function($){
		// SSN
		$("#SSN").mask("***-**-9999");
		
		$("#usPhone").mask("9-999-999-9999");
	});


	var populateDate = function(dateValue) { 
		if ($('#ds2019Check').attr('checked')) {
			$("#verification_received").val(dateValue);
		} else {
			$("#verification_received").val("");
		}
	}
	
	var openWindow = function(url, setHeight, setWidth) { 
		newwindow = window.open(url, 'Application', 'height=' + setHeight + ', width=' + setWidth + ', location=no, scrollbars=yes, menubar=no, toolbars=no, resizable=yes'); 
		if(window.focus) {
			newwindow.focus()
		}
	}
	
	var displayTransferInfo = function() { 
		// Get Transfer Info
		getTransferValue = $("#isTransfer").val();
		if (getTransferValue == 1) {
			// Display All Transfer Information
			$("#trReasonInfo").fadeIn("fast");
			$(".trTransferInfo").fadeIn("fast");
			$(".notReplacement").fadeOut("fast");
			
			// Do not display option to add secondary placement
			$("#secondPlacement option:eq(0)").attr("selected", "selected");
			$("#secondPlacement").fadeOut("fast");
			
			// Fade Out is this a transfer answer
			// $("#readOnlyTransfer").fadeOut("fast");
			
		} else {
			// Hide Transfer Information
			$(".trTransferInfo").fadeOut("fast");
			$(".notReplacement").fadeIn("fast");
			
			// Display option to add secondary placement
			if ($(".trTransferInfo").css("display") != "none") {
				$("#secondPlacement").fadeIn("fast");
			}
			
			// Fade Out is this a transfer answer
			// $("#readOnlyTransfer").fadeOut("fast");
		}
		
		// Display/Hide Self Placemet Info
		displaySelfPlacementInfo();
	}


	var displaySelfPlacementInfo = function(vHideReadOnly) { 
		// Get Placement Info
		getHostID = $("#hostCompanyID").val();
		// Get Transfer Info - Do not display self placement if it's a transfer
		getTransferValue = $("#isTransfer").val();
		// Get Secondary Info
		getSecondaryValue = $("#secondPlacement").val();
		
		if ( getHostID > 0 && getHostID != 195) {
			$(".selfPlacementInfo").fadeIn("fast");

			// Fade out read only values
			if ( vHideReadOnly == 1 ) {
				$(".selfPlacementReadOnly").fadeOut("fast");
			}
			
			// Don't display email confirmation if this is a replacement
			if (getTransferValue == 1) {
				$("#emailConfirmationRow").fadeOut("fast");
			}
			
			// remove deadline if not Seeking Employment
			$("#deadline").fadeOut("fast");
			
			$(".hideForSeeking").fadeIn("fast");

		} else {
			// Erase self placement data
			$(".selfPlacementField").val("");
			$(".selfPlacementInfo").fadeOut("fast");
			// display deadline field for Seeking Employment
			if (getHostID == 195) {
				$("#deadline").fadeIn("fast");
				$(".hideForSeeking").fadeOut("fast");
			} else {
				$("#deadline").fadeOut("fast");		
			}
		}
	}


	var displayCancelation = function(selectedValue) { 
		if (selectedValue == 'canceled') {
			$("#divCancelation").slideDown(1000);
			if ( $("#cancel_date").val() == '' ) {
				$("#cancel_date").val(getCurrentDate());
			}
		} else {			
			$("#cancel_date").val("");
			$("#cancel_reason").val("");
			$("#divCancelation").slideUp(1000);
		}
	}
	
	// This variable is used to prevent using the saved fields to 
	// populate the form if data has not yet been saved to them.
	var haveChanged = 0;
	
	// This function responds to placement selections
	var respondToNewPlacement = function() {
		if ($("#isTransfer").val() == 1) {
			savePlacementData();
			$(".selfPlacementField").val("");
			$(".hostCheckBox").attr("checked", false);
			haveChanged++;
		} else {
			if ($("#isSecondary").val() == 1) {
				savePlacementData();
				$(".selfPlacementField").val("");
				$(".hostCheckBox").attr("checked", false);
				$(".trTransferInfo").fadeIn("fast");
				$(".notReplacement").fadeOut("fast");
				$("#emailConfirmationRow").fadeOut("fast");
				haveChanged++;
			} else if (haveChanged){
				restorePlacementData();
				$(".trTransferInfo").fadeOut("fast");
				$(".notReplacement").fadeIn("fast");
				$("#emailConfirmationRow").fadeIn("fast");
			} else {
				$("#emailConfirmationRow").fadeIn("fast");
			}
		}
	}
	
	// This function saves the placement vetting form information
	var savePlacementData = function() {
		$("#savedJobOfferStatus").val($("#selfJobOfferStatus").val());
		$("#savedName").val($("#selfConfirmationName").val());
		$("#savedEmailConfirmation").val($("#selfEmailConfirmationDate").val());
		$("#savedPhoneConfirmation").val($("#confirmation_phone").val());
		$("#savedJobFound").val($("#selfFindJobOffer").val());
		$("#savedNotes").val($("#selfConfirmationNotes").val());
	}
	
	// This function restores the placement vetting form information
	var restorePlacementData = function() {
		$("#selfJobOfferStatus").val($("#savedJobOfferStatus").val());
		$("#selfConfirmationName").val($("#savedName").val());
		$("#selfEmailConfirmationDate").val($("#savedEmailConfirmation").val());
		$("#confirmation_phone").val($("#savedPhoneConfirmation").val());
		$("#selfFindJobOffer").val($("#savedJobFound").val());
		$("#selfConfirmationNotes").val($("#savedNotes").val());
	}
	
	var displayProgramReason = function(currentProgramID, selectedProgramID) { 
		if ( currentProgramID > '0' && currentProgramID != selectedProgramID && $("#program_history").css("display") == "none" ) {
			$("#program_history").fadeIn("fast");
			$("#reason").focus();
		} else if (currentProgramID == selectedProgramID) {
			$("#program_history").fadeOut("fast");
		}
	}


	var displayHostReason = function(currentHostPlaceID, selectedHostID, candidateID) {
		if ( currentHostPlaceID > '0' && currentHostPlaceID != selectedHostID && $(".trReasonInfo").css("display") == "none" ) {
			$(".trReasonInfo").fadeIn("fast");
			
			// Erase Data
			$("#reason_host").val("");
			$(".transferField").val("");
			$(".transferCheckBox").removeAttr("checked");
			
			// Set Focus
			$("#reason_host").focus();
			
			// Display
			displayTransferInfo();
			
		} else if (currentHostPlaceID == selectedHostID) {
			$(".trReasonInfo").fadeOut("fast");
			$(".secondPlacement").fadeOut("fast");
		}
		
		if (selectedHostID == 195) {
			$("#newJobOffer").fadeOut("fast");
		} else {
			if ($("#newJobOffer").length == 0) {
				$("#tempNewJobOffer").html('<input type="checkbox" name="isTransferJobOfferReceived" id="isTransferJobOfferReceived" value="1" class="formField transferCheckBox"><label for="isTransferJobOfferReceived">New Job Offer</label>')
				$("#tempNewJobOffer").attr("id","newJobOffer");
			} else {
				$("#newJobOffer").fadeIn("fast");
			}
		}
		
		// Set Company Info - first create a host company object to use its functions
		var selectedHC = new HCComponent();
		// Setting a callback handler for the proxy automatically makes the proxy's calls asynchronous. 
		selectedHC.setCallbackHandler(setCompanyInfo); 
		selectedHC.setErrorHandler(getCompanyInfoError);
		selectedHC.getHostCompanyInfo(selectedHostID,candidateID);
	}
	
	var setCompanyInfo = function(companyInfo) {
		var hasCompany = companyInfo.HASCOMPANY;
		if (hasCompany == 1) {
			var authSecretaryOfState = companyInfo.AUTHENTICATIONSECRETARYOFSTATE;
			var authDepartmentOfLabor = companyInfo.AUTHENTICATIONDEPARTMENTOFLABOR;
			var authGoogleEarth = companyInfo.AUTHENTICATIONGOOGLEEARTH;
			var authIncorporation = companyInfo.AUTHENTICATIONINCORPORATION;
			var authCertificateOfExistance = companyInfo.AUTHENTICATIONCERTIFICATEOFEXISTENCE;
			var authCertificateOfReinstatement = companyInfo.AUTHENTICATIONCERTIFICATEOFREINSTATEMENT;
			var authDepartmentOfState = companyInfo.AUTHENTICATIONDEPARTMENTOFSTATE;
			var authBusinessLicenseNotAvailable = companyInfo.AUTHENTICATIONBUSINESSLICENSENOTAVAILABLE;
			var authSecretaryOfStateExpiration = companyInfo.AUTHENTICATIONSECRETARYOFSTATEEXPIRATION;
			var authDepartmentOfLaborExpiration = companyInfo.AUTHENTICATIONDEPARTMENTOFLABOREXPIRATION;
			var authGoogleEarthExpiration = companyInfo.AUTHENTICATIONGOOGLEEARTHEXPIRATION;
			var authIncorporationExpiration = companyInfo.AUTHENTICATIONINCORPORATIONEXPIRATION;
			var authCertificateOfExistenceExpiration = companyInfo.AUTHENTICATIONCERTIFICATEOFEXISTENCEEXPIRATION;
			var authCertificateOfReinstatementExpiration = companyInfo.AUTHENTICATIONCERTIFICATEOFREINSTATEMENTEXPIRATION;
			var authDepartmentOfStateExpiration = companyInfo.AUTHENTICATIONDEPARTMENTOFSTATEEXPIRATION;
			var authEIN = companyInfo.EIN;
			var authWC = companyInfo.WC;
			var authWCE = companyInfo.WCE;
			var WC_carrierName = companyInfo.WC_CARRIERNAME;
			var WC_carrierPhone = companyInfo.WC_CARRIERPHONE;
			var WC_policyNumber = companyInfo.WC_POLICYNUMBER;
			var confirmed = companyInfo.CONFIRMED;
			var numberPositions = companyInfo.POSITIONS;
			var phoneConfirmation = companyInfo.PHONECONFIRMATION;
			var warningStatus = companyInfo.WARNINGSTATUS;
			var warningNotes = companyInfo.WARNINGNOTES;
			
			$("#warningNotes").html("Warning: " + warningNotes);
			if (warningStatus) {
				$("#warningStatus").show();	
			} else {
				$("#warningStatus").hide();		
			}
			
			if (authSecretaryOfState == 1)
				$("#authentication_secretaryOfState").attr("checked", "checked");
			else
				$("#authentication_secretaryOfState").removeAttr("checked");
				
			if (authDepartmentOfLabor == 1)
				$("#authentication_departmentOfLabor").attr("checked", "checked");
			else
				$("#authentication_departmentOfLabor").removeAttr("checked");
				
			if (authGoogleEarth == 1)
				$("#authentication_googleEarth").attr("checked", "checked");
			else
				$("#authentication_googleEarth").removeAttr("checked");
				
			if (authIncorporation == 1)
				$("#authentication_incorporation").attr("checked", "checked");
			else
				$("#authentication_incorporation").removeAttr("checked");
				
			if (authCertificateOfExistance == 1)
				$("#authentication_certificateOfExistence").attr("checked", "checked");
			else
				$("#authentication_certificateOfExistence").removeAttr("checked");
				
			if (authCertificateOfReinstatement == 1)
				$("#authentication_certificateOfReinstatement").attr("checked", "checked");
			else
				$("#authentication_certificateOfReinstatement").removeAttr("checked");
				
			if (authDepartmentOfState == 1)
				$("#authentication_departmentOfState").attr("checked", "checked");
			else
				$("#authentication_departmentOfState").removeAttr("checked");
				
			if (authBusinessLicenseNotAvailable == 1) {
				$("#authentication_businessLicenseNotAvailable").attr("checked", "checked");
				$(".additionalAuthentications").removeAttr("style");
			} else {
				$("#authentication_businessLicenseNotAvailable").removeAttr("checked");
				$(".additionalAuthentications").css("display","none");
			}
			
			$("#authentication_secretaryOfStateExpiration").html(getFormattedDate(authSecretaryOfStateExpiration));
			$("#authentication_departmentOfLaborExpiration").html(getFormattedDate(authDepartmentOfLaborExpiration));
			$("#authentication_googleEarthExpiration").html(getFormattedDate(authGoogleEarthExpiration));
			$("#authentication_incorporationExpiration").html(getFormattedDate(authIncorporationExpiration));
			$("#authentication_certificateOfExistenceExpiration").html(getFormattedDate(authCertificateOfExistenceExpiration));
			$("#authentication_certificateOfReinstatementExpiration").html(getFormattedDate(authCertificateOfReinstatementExpiration));
			$("#authentication_departmentOfStateExpiration").html(getFormattedDate(authDepartmentOfStateExpiration));
				
			if (confirmed == 1) {
				$("#confirmation").val(1);
				$("#confirmationCheckbox").attr("checked","checked");
			} else {
				$("#confirmation").val(0);
				$("#confirmationCheckbox").removeAttr("checked");
			}
				
			$("#EIN").val(authEIN);
			$("#workmensCompensation").val(authWC);
			$("#WCDateExpired").val(authWCE);
			$("#WC_carrierName").val(WC_carrierName);
			$("#WC_carrierPhone").val(WC_carrierPhone);
			$("#WC_policyNumber").val(WC_policyNumber);
			$("#numberPositionsSelect").val(numberPositions);
			$("#confirmation_phone").val(phoneConfirmation);
		} else {
			getCompanyInfoError();
		}
	}
	
	var getFormattedDate = function(inputDate) {
		var returnDate = "";
		if (inputDate != "") {
			var newDate = new Date(inputDate);
			var month = newDate.getMonth()+1;
			var day = newDate.getDate();
			var year = newDate.getFullYear();
			if (month < 10) month = "0" + month;
			if (day < 10) day = "0" + day;
			returnDate = month + "/" + day + "/" + year;
		} else {
			returnDate = "";
		}
		return returnDate;
	}
	
	var getCompanyInfoError = function() {
		alert("Could not retrieve company information");
	}
	
	// Check History
	var checkHistory = function() {
		// PROGRAM HISTORY
		if( $("#program_history").css("display") != "none" && $("#reason").val() == '' ){
			alert("In order to change the program you must enter a reason (for history purpose).");
			$("#reason").focus();
			return false; 
		}
		
		// HOST HISTORY
		if( $("#hostCompanyChangeReason").css("display") != "none" && $("#reason_host").val() == '' ){
			alert("In order to change the host company you must enter a reason (for history purpose).");
			$("#reason_host").focus();
			return false; 
		}
	}
	
	// Change values
	var changeValue = function(id) {
		if ($("#" + id).val() == 0)
			$("#" + id).val(1);
		else
			$("#" + id).val(0);
	}
	
	// To hide or show the additional authentications
	var changeAuthenticationAvailable = function() {
		if ($("#authentication_businessLicenseNotAvailable").attr("checked")) {
			$(".additionalAuthentications").removeAttr("style");
		} else {
			$(".additionalAuthentications").css("display","none");
		}
	}
	
	// To hide or show the additional authentications for secondary placements
	var changeSecondaryAuthenticationAvailable = function(id) {
		if ($("#authentication_businessLicenseNotAvailable_"+id).attr("checked")) {
			$(".additionalAuthentications_"+id).removeAttr("style");
		} else {
			$(".additionalAuthentications_"+id).css("display","none");
		}
	}
	
	function checkHousingDetailsArea(value) {
		if (value == 0) {
			$("#housingDetailsArea").attr("style","display:none;");	
		} else {
			$("#housingDetailsArea").attr("style","");
			$(".readOnly").fadeOut("fast");
		}
	}
	
//-->
</script> 

<!--- candidate does not exist --->
<cfif NOT VAL(qGetCandidate.recordcount)>
	The candidate ID you are looking for was not found. This could be for a number of reasons.<br /><br />
   	<ul>
		<li>the candidate record was deleted or renumbered
		<li>the link you are following is out of date
		<li>you do not have proper access rights to view the candidate
	</ul>
	If you feel this is incorrect, please contact <a href="mailto:support@student-management.com">Support</a>
	<cfabort>
</cfif>

<cfoutput>

	<cfdirectory action="list" directory="#APPLICATION.PATH.ds2019forms#" filter="*#qGetCandidate.ds2019#*" name="dsforms">

<cfform name="CandidateInfo" method="post" action="?curdoc=candidate/qr_edit_candidate&uniqueid=#qGetCandidate.uniqueid#" onsubmit="return checkHistory();">
<input type="hidden" name="candidateID" value="#qGetCandidate.candidateID#">
<input type="hidden" name="submitted" value="1">

<!--- These hidden fields are to save the placement vetting information --->
<input type="hidden" id="savedJobOfferStatus">
<input type="hidden" id="savedName">
<input type="hidden" id="savedEmailConfirmation">
<input type="hidden" id="savedPhoneConfirmation">
<input type="hidden" id="savedJobFound">
<input type="hidden" id="savedNotes">

<!--- TABLE HOLDER --->
<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="##CCCCCC" bgcolor="##F4F4F4">
    <tr>
        <td bordercolor="##FFFFFF">

			<!--- TABLE HEADER --->
            <table width="95%" cellpadding="0" cellspacing="0" border="0" align="center" height="25" bgcolor="##E4E4E4">
                <tr bgcolor="##E4E4E4">
                	<td class="title1"><font size="2">&nbsp; &nbsp; Candidate Information</font></td>
                </tr>
            </table>

			<br />
            
            <!--- TOP SECTION --->
            <table width="80%" border="1" align="center" cellpadding="6" cellspacing="6" bordercolor="##C7CFDC" bgcolor="##ffffff">	
                <tr>
                    <td valign="top">
                    
                    	<!--- CANDIDATE PHOTO --->
                        <table width="20%" align="left" cellpadding="2">
                            <tr>
                                <td valign="top">
                                	<cfif FileExists(ExpandPath("../uploadedfiles/web-candidates/#qGetCandidate.candidateID#.jpg"))>
                                        <img src="../uploadedfiles/web-candidates/#qGetCandidate.candidateID#.jpg" width="135">
                                    <cfelse>
                                        <img src="../pics/no_stupicture.jpg" width="137" height="137">
                                    </cfif>
                                </td>
                            </tr>
						</table>
    
                        <!--- CANDIDATE INFO - READ ONLY --->
                        <table width="50%" align="left" cellpadding="2" class="readOnly" style="margin-left:10px;">
                            <tr>
                                <td align="center" colspan="2" class="title1">#qGetCandidate.firstname# #qGetCandidate.middlename# #qGetCandidate.lastname# (###qGetCandidate.candidateID#)</td>
                            </tr>
                            <tr>
                                <td align="center" colspan="2" class="style1">
                                    <cfif NOT LEN(qGetCandidate.dob)>N/A<cfelse>#dateFormat(qGetCandidate.dob, 'mm/dd/yyyy')# - #datediff('yyyy',qGetCandidate.dob,now())# year old</cfif> 
                                    - 
                                    <cfif qGetCandidate.sex EQ 'm'>Male<cfelse>Female</cfif>
                                </td>
                            </tr> 
                            <tr>
                                <td align="right" class="style1"><strong>Intl. Rep.:</strong></td>
                                <td class="style1">#qGetIntlRepInfo.businessName#</td>
                            </tr>
                            <tr>
                                <td align="right" class="style1"><strong>Date of Entry: </strong></td>
                                <td class="style1">#dateFormat(qGetCandidate.entrydate, 'mm/dd/yyyy')#</td>
                            </tr>
                            <tr>
                                <td align="right">Candidate is</td>
                                <td class="style1">
                                	<strong>
									<cfif qGetCandidate.status EQ 1>
                                        ACTIVE 
                                    <cfelseif qGetCandidate.status EQ 0>
                                        INACTIVE 
                                    <cfelseif qGetCandidate.status EQ 'canceled'>
                                        CANCELED
                                    </cfif>
                                    </strong>
                                </td>
                            </tr>										
                        </table>
                        
                        <!--- CANDIDATE INFO - EDIT PAGE --->
                        <table width="50%" align="left" cellpadding="2" class="editPage" style="margin-left:10px;">
                            <tr>
                                <td align="right" class="style1" width="25%"><strong>Last Name:</strong> </td>
                                <td width="75%"><input type="text" name="lastname" class="style1 xLargeField" value="#qGetCandidate.lastname#" maxlength="100"></td>
                            </tr>
                            <tr>
                                <td align="right" class="style1"><strong>First Name:</strong></td>
                                <td><input type="text" name="firstname" class="style1 xLargeField" value="#qGetCandidate.firstname#" maxlength="100"></td>
                            </tr>
                            <tr>
                                <td align="right" class="style1"><strong>Middle Name:</strong> </td>
                                <td><input type="text" name="middlename" class="style1 xLargeField" value="#qGetCandidate.middlename#" maxlength="100"></td>
                            </tr>
                            <tr>
                                <td align="right" class="style1"><strong>Date of Birth:</strong></td>
                                <td class="style1">
                                    <cfinput 
                                    	type="text" 
                                        name="dob" 
                                        class="datePicker style1" 
                                        size="12" 
                                        value="#dateFormat(qGetCandidate.dob, 'mm/dd/yyyy')#" 
                                        maxlength="35" 
                                        validate="date" 
                                        message="Date of Birth (MM/DD/YYYY)" 
                                        required="yes">
                                    &nbsp; 
                                    <strong>Sex:</strong> 
                                    <input type="radio" name="sex" value="M" required message="You must specify the candidate's sex." <cfif qGetCandidate.sex Eq 'M'>checked="checked"</cfif>>Male 
                                    &nbsp;
                                    <input type="radio" name="sex" value="F" required message="You must specify the candidate's sex." <cfif qGetCandidate.sex Eq 'F'>checked="checked"</cfif>>Female 
                                </td>
                            </tr> 
                            <tr>
                                <td align="right" class="style1"><strong>Intl. Rep.:</strong></td>
                                <td class="style1">
                                    <select name="intrep" class="style1 xxLargeField">
                                        <option value="0"></option>		
                                        <cfloop query="qGetIntlRepList">
                                            <option value="#qGetIntlRepList.userid#" <cfif qGetIntlRepList.userid EQ qGetCandidate.intrep> selected </cfif>>#qGetIntlRepList.businessname#</option>
                                        </cfloop>
                                    </select>
                              </td>
                            </tr>
                            <tr>
                                <td align="right" class="style1"><strong>Date of Entry: </strong></td>
                                <td class="style1">#dateFormat(qGetCandidate.entrydate, 'mm/dd/yyyy')#</td>
                            </tr>

                            <tr>
                                <td align="right" class="style1"><strong>Status:</strong></td>
                                <td class="style1">
                                	<select id="status" name="status" class="style1 smallField" <cfif qGetCandidate.status NEQ 'canceled'> onchange="javascript:displayCancelation(this.value);" </cfif> >
                                        <option value="1" <cfif qGetCandidate.status EQ 1>selected="selected"</cfif>>Active</option>
                                        <option value="0" <cfif qGetCandidate.status EQ 0>selected="selected"</cfif>>Inactive</option>
                                        <option value="canceled" <cfif qGetCandidate.status Eq 'canceled'>selected="selected"</cfif>>Canceled</option>
	                                </select>
                              	</td>
                            </tr>
                        </table>
                        
                    	<!--- LINKS --->
                        <table width="20%" align="right" cellpadding="2">
                            <tr>
                                <td valign="top" align="center">
                                
                                	<!--- Office View Only --->
                                    <cfif ListFind("1,2,3,4", CLIENT.userType)>
                                        <p><a href="candidate/candidate_profile.cfm?uniqueid=#qGetCandidate.uniqueid#" class="style4" target="_blank">[ Profile ]</a></p>
									</cfif>
                                    <cfif VAL(qGetCandidate.applicationStatusID)>
                                    	<p><a href="onlineApplication/index.cfm?action=initial&uniqueID=#qGetCandidate.uniqueID#" class="style4 popUpOnlineApplication">[ Online Application ]</a></p>
                                    </cfif>
                                    
                                    <!--- Office View Only --->
                                    <cfif ListFind("1,2,3,4", CLIENT.userType)>
                                        <p><a href="candidate/employerLetter.cfm?uniqueid=#qGetCandidate.uniqueid#" class="style4" target="_blank">[ Employer Letter ]</a></p>
										<p><a href="candidate/supportLetter.cfm?uniqueid=#qGetCandidate.uniqueid#" class="style4" target="_blank">[ Support Letter ]</a></p>
                                        <p><a href="candidate/sevisFeeLetter.cfm?uniqueid=#qGetCandidate.uniqueid#" class="style4" target="_blank">[ SEVIS Fee Payment Instructions ]</a></p>
									</cfif>
                                    
                                    <!--- Quick Downloads --->
                                    <div>
                                    	<b><u>Quick Downloads</u></b>
                                        <br>
                                        <cfloop query="qGetUploadedResume">
                                        	#downloadLink#<br>
                                        </cfloop>
                                        <cfloop query="qGetUploadedJobOffer">
                                        	#downloadLink#<br>
                                        </cfloop>
                                        <cfloop query="qGetUploadedDS2019">
                                        	#downloadLink#<br>
                                        </cfloop>
										<cfif client.usertype lte 4>
											<cfif val(dsforms.recordcount)>
                                            <a href="../uploadedfiles/2019Forms/#dsforms.name#" class="style4">[ Download DS-2019 ]</a>
                                            </cfif>
                                        </cfif>
                                      
                                    </div>                                    
                                    
                            	</td>
                      		</tr>
						</table>
						
                    </td>
                </tr>
            </table>
            <!--- END OF TOP SECTION --->
            
            <br>                                    
            
			<!--- INFORMATION SECTION --->
            <table width="80%" border="0" cellpadding="0" cellspacing="0" align="center">	
                <tr>
                    <!--- LEFT SECTION --->
                    <td width="49%" valign="top">
                        
                        <!--- PERSONAL INFO --->
                        <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
								<td bordercolor="##FFFFFF">
                                                                	
                                    <table width="100%" cellpadding="4" cellspacing="0" border="0">
                                        <tr bgcolor="C2D1EF" bordercolor="##FFFFFF">
                                            <td colspan="2" class="style2" bgcolor="##8FB6C9">&nbsp;:: Personal Information</td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right" width="30%"><strong>Place of Birth:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF" width="70%">
                                            	<span class="readOnly">#qGetCandidate.birth_city#</span>
                                                <input type="text" class="style1 editPage xLargeField" name="birth_city" value="#qGetCandidate.birth_city#" maxlength="100">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong>Country of Birth:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                                <span class="readOnly">#qGetBirthCountry.countryName#</span>
                                                <select name="birth_country" class="style1 editPage xLargeField">
                                                    <option value="0"></option>		
                                                    <cfloop query="qGetCountryList">
                                                        <option value="#countryid#" <cfif countryid EQ qGetCandidate.birth_country> selected </cfif>>#countryname#</option>
                                                    </cfloop>
                                                </select>
                                            </td>
                                        </tr>		
                                        <tr>
                                            <td class="style1" align="right"><strong>Country of Citizenship:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                                <span class="readOnly">#qGetCitizenCountry.countryName#</span>
                                                <select name="citizen_country" class="style1 editPage xLargeField">
                                                    <option value="0"></option>		
                                                    <cfloop query="qGetCountryList">
                                                        <option value="#countryid#" <cfif countryid EQ qGetCandidate.citizen_country> selected </cfif>>#countryname#</option>
                                                    </cfloop>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong>Country of Permanent Residence:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                                <span class="readOnly">#qGetResidenceCountry.countryName#</span>
                                                <select name="residence_country" class="style1 editPage xLargeField">
                                                    <option value="0"></option>		
                                                    <cfloop query="qGetCountryList">
                                                        <option value="#countryid#" <cfif countryid EQ qGetCandidate.residence_country> selected </cfif>>#countryname#</option>
                                                    </cfloop>
                                                </select>			
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong>Passport Number:</strong></td>
                                            <td class="style1">
                                            	<span class="readOnly">#qGetCandidate.passport_number#</span>
                                            	<input name="passport_number" class="style1 editPage xLargeField" value="#qGetCandidate.passport_number#" type="text" maxlength="100">
                                            </td>
                                        </tr>
                                        <!--- Online App Field - University Name --->
                                        <tr>
                                            <td class="style1" align="right"><strong>#qGetQuestionsSection1.displayField[1]#:</strong></td>
                                            <td class="style1">
                                            	<span class="readOnly">#FORM[qGetQuestionsSection1.fieldKey[1]]# &nbsp;</span>
                                            	<input name="#qGetQuestionsSection1.fieldKey[1]#" class="style1 editPage xLargeField" value="#FORM[qGetQuestionsSection1.fieldKey[1]]#" type="text" maxlength="50">
                                            </td>
                                        </tr>
                                        <tr>				
                                            <td class="style1" colspan="2">
            
                                                <table width="100%" cellpadding="3" cellspacing="3" style="border:1px solid ##C7CFDC; background-color:##F7F7F7;">
                                                    <tr>
                                                    	<td class="style1" align="right" width="30%"><strong>Mailing Address:</strong></td>
                                                        <td class="style1" width="70%">
															<span class="readOnly">#qGetCandidate.home_address#</span>
                                                            <input type="text" class="style1 editPage xLargeField" name="home_address" value="#qGetCandidate.home_address#" maxlength="100">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="style1" align="right"><strong>City:</strong></td>
                                                        <td class="style1">
															<span class="readOnly">#qGetCandidate.home_city#</span>
                                                            <input type="text" class="style1 editPage xLargeField" name="home_city" value="#qGetCandidate.home_city#" maxlength="100">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="style1" align="right"><strong>Zip:</strong></td>
                                                        <td class="style1">
                                                        	<span class="readOnly">#qGetCandidate.home_zip#</span>
                                                            <input type="text" class="style1 editPage smallField" name="home_zip" value="#qGetCandidate.home_zip#" maxlength="15">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="style1" align="right"><strong>Country:</strong></td>
                                                        <td class="style1" colspan="3">                                                        
                                                            <span class="readOnly">#qGetHomeCountry.countryName#</span>
                                                            <select name="home_country" class="style1 editPage xLargeField">
                                                                <option value="0"></option>		
                                                                <cfloop query="qGetCountryList">
                                                                    <option value="#countryid#" <cfif countryid EQ qGetCandidate.home_country> selected </cfif>>
																		<cfif len(countryname) GT 55>
                                                                        	#Left(countryname, 52)#...
                                                                        <cfelse>
                                                                        	#countryname#
                                                                        </cfif>
                                                                    </option>
                                                                </cfloop>
                                                            </select>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="style1" align="right"><strong>Phone:</strong></td>
                                                        <td class="style1" colspan="3">
                                                        	<span class="readOnly">#qGetCandidate.home_phone#</span>
                                                            <input type="text" class="style1 editPage xLargeField" name="home_phone" value="#qGetCandidate.home_phone#" maxlength="50">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="style1" align="right"><strong>Email:</strong></td>
                                                        <td class="style1" colspan="3">
                                                        	<span class="readOnly">#qGetCandidate.email#</span>
                                                            <input type="text" class="style1 editPage xLargeField" name="email" id="email" value="#qGetCandidate.email#" maxlength="100">
                                                        </td>
                                                    </tr>
                                                    
                                                    <!--- Online App Field - Skype ID --->
                                                    <tr>
                                                        <td class="style1" align="right"><strong>#qGetQuestionsSection1.displayField[3]#:</strong></td>
                                                        <td class="style1">
                                                            <span class="readOnly">#FORM[qGetQuestionsSection1.fieldKey[3]]# &nbsp;</span>
                                                            <input 
                                                            	name="#qGetQuestionsSection1.fieldKey[3]#" 
                                                                class="style1 editPage xLargeField" 
                                                                value="#FORM[qGetQuestionsSection1.fieldKey[3]]#" 
                                                                type="text" 
                                                                maxlength="50">
                                                        </td>
                                                    </tr>
                                                </table>
                                            
                                            </td>					
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong>Social Security ##:</strong></td>
                                            <td class="style1">
                                                <span class="readOnly">
                                                    #APPLICATION.CFC.UDF.displaySSN(qGetCandidate.SSN)#
                                                </span>
                                                <input name="SSN" id="SSN" value="#APPLICATION.CFC.UDF.displaySSN(qGetCandidate.SSN)#" type="text" class="style1 editPage xLargeField" maxlength="100">
                                            </td>
                                        </tr>	
                                        <!--- Online App Field - Participant's English Level --->
                                        <tr>
                                            <td class="style1" align="right"><strong><label for="#qGetQuestionsSection3.fieldKey[1]#">#qGetQuestionsSection3.displayField[1]#:</label></strong></td>
                                            <td class="style1">
                                            	<span class="readOnly">#FORM[qGetQuestionsSection3.fieldKey[1]]# &nbsp;</span>
                                                <select name="#qGetQuestionsSection3.fieldKey[1]#" id="#qGetQuestionsSection3.fieldKey[1]#" class="style1 editPage smallField">
                                                    <option value=""></option>
                                                    <cfloop from="1" to="10" index="i">
                                                        <option value="#i#" <cfif FORM[qGetQuestionsSection3.fieldKey[1]] EQ i> selected="selected" </cfif> >#i#</option>
                                                    </cfloop>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong><label for="#qGetQuestionsSection3.fieldKey[2]#">#qGetQuestionsSection3.displayField[2]#:</label></strong></td>
                                            <td class="style1">
                                            	<span class="readOnly">#FORM[qGetQuestionsSection3.fieldKey[2]]# &nbsp;</span>
                                                <input name="#qGetQuestionsSection1.fieldKey[2]#" class="style1 editPage xLargeField" value="#FORM[qGetQuestionsSection1.fieldKey[2]]#" type="text" maxlength="50">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong>English Assessment CSB:</strong></td>
                                            <td class="style1">
                                            	<span class="readOnly">#qGetCandidate.englishAssessment#</span>
                                                <textarea name="englishAssessment" class="style1 editPage mediumTextArea">#qGetCandidate.englishAssessment#</textarea>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong>Date of Interview:</strong></td>
                                            <td class="style1">
                                            	<span class="readOnly">#DateFormat(qGetCandidate.englishAssessmentDate, 'mm/dd/yyyy')#</span>
                                                <input type="text" name="englishAssessmentDate" class="datePicker style1 editPage" value="#DateFormat(qGetCandidate.englishAssessmentDate, 'mm/dd/yyyy')#">
                                                <cfif NOT LEN(qGetCandidate.englishAssessmentDate)><font size="1">(mm/dd/yyyy)</font></cfif>
                                            </td>
                                        </tr>
                                        <!--- Office View Only --->
                                        <cfif ListFind("1,2,3,4", CLIENT.userType)>
                                            <tr>
                                                <td class="style1" align="right"><strong>Comment:</strong></td>
                                                <td class="style1">
                                                    <span class="readOnly">#qGetCandidate.englishAssessmentComment#</span>
                                                    <textarea name="englishAssessmentComment" class="style1 editPage mediumTextArea">#qGetCandidate.englishAssessmentComment#</textarea>
                                                </td>
                                            </tr>
                                        </cfif>
                                    </table>

                                </td>
                            </tr>
                        </table> 
                        
                        <br />

                        <!--- DATES OF VACATION --->
                        <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
                                <td bordercolor="##FFFFFF">
                        
                                    <table width="100%" cellpadding="4" cellspacing="0" border="0">
                                        <tr bgcolor="##C2D1EF">
                                        	<td colspan="2" class="style2" bgcolor="##8FB6C9">&nbsp;:: Dates of the Official Vacation</td>
                                        </tr>
                                        <tr>
                                            <td  width="30%" class="style1" align="right"><strong>Start Date:</strong></td>
                                            <td class="style1" width="70%">
                                            	<span class="readOnly">#dateFormat(qGetCandidate.wat_vacation_start, 'mm/dd/yyyy')#</span>
                                                <input type="text" name="wat_vacation_start" class="datePicker style1 editPage" value="#dateFormat(qGetCandidate.wat_vacation_start, 'mm/dd/yyyy')#" maxlength="10">
                                                <cfif NOT LEN(qGetCandidate.wat_vacation_start)><font size="1">(mm/dd/yyyy)</font></cfif>
                                            </td>
                                        </tr>
                                        <tr>
                                        	<td class="style1" align="right"><strong>End Date:</strong></td>
                                        	<td class="style1">	
                                            	<span class="readOnly">#dateFormat(qGetCandidate.wat_vacation_end, 'mm/dd/yyyy')#</span>
                                                <input type="text" name="wat_vacation_end" class="datePicker style1 editPage" value="#dateFormat(qGetCandidate.wat_vacation_end, 'mm/dd/yyyy')#" maxlength="10"> 
                                                <cfif NOT LEN(qGetCandidate.wat_vacation_end)><font size="1">(mm/dd/yyyy)</font></cfif>
                                        	</td>
                                        </tr>
                                    </table>	
                   
                                </td>
                            </tr>
                        </table> 

						<br />

						<!--- EMERGENCY CONTACT --->
                        <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
                                <td bordercolor="##FFFFFF">
                        
                                    <table width="100%" cellpadding="4" cellspacing="0" border="0">
                                        <tr bgcolor="##C2D1EF">
                                            <td colspan="2" class="style2" bgcolor="##8FB6C9">&nbsp;:: Emergency Contact</td>
                                        </tr>
                                        <tr>
                                            <td width="30%" class="style1" align="right"><strong>Name:</strong></td>
                                            <td class="style1" width="70%">
                                                <span class="readOnly">#qGetCandidate.emergency_name#</span>
                                                <input type="text" name="emergency_name" class="style1 editPage xLargeField" value="#qGetCandidate.emergency_name#" maxlength="100">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong>Phone:</strong></td>
                                            <td class="style1">
                                                <span class="readOnly">#qGetCandidate.emergency_phone#</span>                          
                                                <input type="text" name="emergency_phone" class="style1 editPage xLargeField" value="#qGetCandidate.emergency_phone#" maxlength="50">
                                           </td>
                                        </tr>
                                        <tr>
                                        	<td class="style1" align="right"><strong>Email:</strong></td>
                                            <td class="style1">
                                            	<span class="readOnly">#qGetCandidate.emergency_email#</span>
                                                <input type="text" name="emergency_email" class="style1 editPage xLargeField" value="#qGetCandidate.emergency_email#" maxlength="100">
                                            </td>
                                        </tr>
                                    </table>	
                   
                                </td>
                            </tr>
                        </table> 

						<br />
                        
                        <!--- DOCUMENTS CONTROL --->
                        <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
                                <td bordercolor="##FFFFFF">
                        
                                    <table width="100%" cellpadding="4" cellspacing="0" border="0">
                                        <tr bgcolor="##C2D1EF">
                                            <td colspan="4" class="style2" bgcolor="##8FB6C9">&nbsp;:: Documents Control</td>
                                        </tr>
                                        <tr>
                                            <td width="50%" class="style1">
                                                <input 
                                                	type="checkbox" 
                                                    name="wat_doc_agreement" 
                                                    id="wat_doc_agreement" 
                                                    value="1" 
                                                    class="formField" 
                                                    disabled 
													<cfif VAL(qGetCandidate.wat_doc_agreement)> checked </cfif> > 
                                                <label for="wat_doc_agreement">Agreement</label>
                                            </td>
                                            <td width="50%" class="style1">
                                                <input 
                                                	type="checkbox" 
                                                    name="wat_doc_signed_assessment" 
                                                    id="wat_doc_signed_assessment" 
                                                    value="1" 
                                                    class="formField" 
                                                    disabled 
													<cfif VAL(qGetCandidate.wat_doc_signed_assessment)> checked </cfif> >
                                                <label for="wat_doc_signed_assessment">Signed English Assessment</label>
                                            </td>
                                        </tr>
                                        <tr>
                                        	<!--- Walk-In Agreement - Only Available for Walk-In --->
                                            <td class="style1">
                                                <input 
                                                	type="checkbox" 
                                                    name="wat_doc_walk_in_agreement" 
                                                    id="wat_doc_walk_in_agreement" 
                                                    value="1" 
													<cfif qGetCandidate.wat_placement EQ 'Walk-In'> class="formField" </cfif> 
                                                    disabled 
													<cfif VAL(qGetCandidate.wat_doc_walk_in_agreement)> checked </cfif> > 
                                                <label for="wat_doc_walk_in_agreement">Walk-In Agreement</label>
                                            </td>
                                            <td class="style1">
                                                <input 
                                                	type="checkbox" 
                                                    name="wat_doc_college_letter" 
                                                    id="wat_doc_college_letter" 
                                                    value="1" 
                                                    class="formField" 
                                                    disabled 
													<cfif VAL(qGetCandidate.wat_doc_college_letter)> checked </cfif> >
                                                <label for="wat_doc_college_letter">College Letter</label>
                                            </td>
                                        </tr>
                                        <tr>
                                        	<!--- CV - Only Available for CSB-Placement --->
                                            <td class="style1"> 
                                                <input 
                                                	type="checkbox" 
                                                    name="wat_doc_cv" 
                                                    id="wat_doc_cv" 
                                                    value="1" 
													<cfif qGetCandidate.wat_placement EQ 'CSB-Placement'> class="formField" </cfif> 
                                                    disabled 
													<cfif VAL(qGetCandidate.wat_doc_cv)> checked </cfif> > 
                                                <label for="wat_doc_cv">CV</label>
                                            </td>
                                            <td class="style1">
                                                <input 
                                                	type="checkbox" 
                                                    name="wat_doc_college_letter_translation" 
                                                    id="wat_doc_college_letter_translation" 
                                                    value="1" 
                                                    class="formField" 
                                                    disabled 
													<cfif VAL(qGetCandidate.wat_doc_college_letter_translation)> checked </cfif> > 
                                                <label for="wat_doc_college_letter_translation">College Letter (translation)</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1">
                                                <input 
                                                	type="checkbox" 
                                                    name="wat_doc_passport_copy" 
                                                    id="wat_doc_passport_copy" 
                                                    value="1" 
                                                    class="formField" 
                                                    disabled 
													<cfif VAL(qGetCandidate.wat_doc_passport_copy)> checked </cfif> > 
                                                <label for="wat_doc_passport_copy">Passport Copy</label>
                                            </td>
                                            <td class="style1">
                                                <input 
                                                	type="checkbox" 
                                                    name="wat_doc_job_offer_applicant" 
                                                    id="wat_doc_job_offer_applicant" 
                                                    value="1" 
                                                    class="formField" 
                                                    disabled 
													<cfif VAL(qGetCandidate.wat_doc_job_offer_applicant)> checked </cfif> >
                                                <label for="wat_doc_job_offer_applicant">Job Offer Agreement Applicant</label>
                                                <br />
                                                <div style="font-size:9px; color:##070719;">
                                                	Attention: Upon reviewing the job offer agreement, additional documents may be applicable.  If housing is not provided on premises, a No Housing Form and Housing Arrangements Form must be submitted. If housing and/or pick-up is/are provided by a third party, a Third Party Form (Housing and/or Pick-up)  must be submitted.
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1">
                                                <input 
                                                	type="checkbox" 
                                                    name="wat_doc_orientation" 
                                                    id="wat_doc_orientation" 
                                                    value="1" 
                                                    class="formField" 
                                                    disabled 
													<cfif VAL(qGetCandidate.wat_doc_orientation)> checked </cfif> > 
                                                <label for="wat_doc_orientation">Orientation Sign Off</label>
                                            </td>
                                            <td class="style1">
                                            </td>
                                        </tr>
                                        <tr>
                                        	<td class="style1" colspan="4">
                                            	
                                                <table width="100%" cellpadding="4" cellspacing="0" border="0">
                                                	<tr>
                                                		<td width="35%" class="style1" align="right">
                                                            <strong>Other Documents Received:</strong>
                                            			</td>
                                                        <td width="65%" class="style1" align="left">
                                                        	<span class="readOnly">#qGetCandidate.wat_doc_other_received#</span>
                                                            <input 
                                                            	type="text" 
                                                                name="wat_doc_other_received" 
                                                                class="style1 editPage xLargeField" 
                                                                value="#qGetCandidate.wat_doc_other_received#" 
                                                                maxlength="250">
                                                        </td>
                                                	</tr>
                                               	</table>
                                                     
                                            </td>
										</tr> 
                                        <tr>
                                        	<td class="style1" colspan="4">
                                            	
                                                <table width="100%" cellpadding="4" cellspacing="0" border="0">
                                                    <tr>
                                                        <td width="35%" class="style1" align="right">
                                                            <strong>Other Documents Missing:</strong>
                                            			</td>
                                                        <td width="65%" class="style1" align="left">
                                                        	<span class="readOnly">#qGetCandidate.wat_doc_other#</span> 
                                                            <input 
                                                            	type="text" 
                                                                name="wat_doc_other" 
                                                                class="style1 editPage xLargeField" 
                                                                value="#qGetCandidate.wat_doc_other#" 
                                                                maxlength="250">
                                                        </td>
                                                    </tr>
                               					</table>

                                       		</td>
                                      	</tr>
                                                                              
                                    </table>
                   
                                </td>
                            </tr>
                        </table>

						<br />
                        
                        <!--- PROGRAM INFO --->
                        <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
                                <td bordercolor="##FFFFFF">
                        
                                    <table width="100%" cellpadding="4" cellspacing="0" border="0">
                                        <tr bgcolor="##C2D1EF" bordercolor="##FFFFFF">
                                        	<td class="style2" bgcolor="##8FB6C9" colspan="4">
                                            	&nbsp;:: Program Information &nbsp;
                                                <!--- Office View Only --->  
                                            	<cfif ListFind("1,2,3,4", CLIENT.userType)>    
                                                	<span style="float:right; padding-right:20px;">
                                                    	<a href="javascript:openWindow('candidate/candidate_program_history.cfm?unqid=#uniqueid#', 400, 600);" class="style2">[ History ]</a>
                                                    </span>
                                            	</cfif>
                                            </td>
                                        </tr>						
                                        <tr>
                                        	<td class="style1" align="right" width="30%"><strong>Program:</strong></td>
                                            <td class="style1" width="70%">
                                                <span class="readOnly">#qGetProgramInfo.programName#</span>
                                                <select name="programid" class="style1 editPage xLargeField" onChange="displayProgramReason(#VAL(qGetCandidate.programid)#, this.value);">
                                                    <option value="0">Unassigned</option>
                                                    <cfloop query="program">
                                                        <option value="#program.programid#" <cfif qGetCandidate.programid EQ program.programid> selected </cfif> >#program.programname#</option>
                                                    </cfloop>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr id="program_history" bgcolor="##FFBD9D" class="hiddenField">
                                        	<td class="style1" align="right"><strong>Reason:</strong></td>
                                        	<td class="style1"><input type="text" name="reason" id="reason" class="style1 xLargeField"></td>
                                        </tr>
                                        <tr>
                                        	<!--- Placement--->
                                        	<td class="style1" align="right"><strong>Option:</strong></td>
                                        	<td class="style1">
												<span class="readOnly">#qGetCandidate.wat_placement#</span>
                                                <select name="wat_placement" id="wat_placement" onChange="displaySelfPlacementInfo(1);" class="style1 editPage xLargeField">
                                                    <option value="">Select....</option>
                                                    <option value="Self-Placement" <cfif qGetCandidate.wat_placement EQ 'Self-Placement'>selected="selected"</cfif>>Self-Placement</option>
                                                    <option value="CSB-Placement" <cfif qGetCandidate.wat_placement EQ 'CSB-Placement'>selected="selected"</cfif>>CSB-Placement</option>
                                                    <option value="Walk-In" <cfif qGetCandidate.wat_placement EQ 'Walk-In'>selected="selected"</cfif>>Walk-In</option>
                                                </select>
	                                        </td>
                                        </tr>		
                                        <tr>
                                        	<td class="style1" align="right"><strong>Number of Participation in the Program:</strong>
                                            <td class="style1">
                                        		<span class="readOnly">#qGetCandidate.wat_participation#</span>
                                                <select name="wat_participation" class="style1 editPage smallField">
                                                	<cfloop from="0" to="15" index="i">
                                                    	<option value="#i#" <cfif qGetCandidate.wat_participation EQ i> selected </cfif> >#i#</option>                                                    
                                                    </cfloop>
                                 				</select>               
	                                        </td>
                                        </tr>   
                                        <tr>
                                        	<td class="style1" align="right"><strong>Year(s) and sponsor(s) of previous participation:</strong>
                                            <td class="style1">
                                            	<div class="readOnly">#APPLICATION.CFC.UDF.TextAreaOutput(qGetCandidate.wat_participation_info)#</div>
                                                <textarea name="wat_participation_info" id="wat_participation_info" class="style1 editPage mediumTextArea">#qGetCandidate.wat_participation_info#</textarea>
	                                        </td>
                                        </tr>
                                        <tr>
                                        	<td class="style1" align="right"><strong>Requested Placement:</strong>
                                            <td class="style1">
                                                <span class="readOnly">
                                                	<!--- Office View Only --->
                                                    <cfif ListFind("1,2,3,4", CLIENT.userType)>
	                                                    <a 
                                                        	href="?curdoc=hostcompany/hostCompanyInfo&hostCompanyID=#qRequestedPlacement.hostCompanyID#" 
                                                            class="style4">
                                                            	<strong>#qRequestedPlacement.name#</strong>
                                                     	</a>
                                                    <cfelse>
                                                    	#qRequestedPlacement.name#
                                                    </cfif>
                                                </span>
                                                <select name="requested_placement" class="style1 editPage xLargeField">
                                                    <option value="0"></option>
                                                    <cfloop query="qHostCompanyList">
                                                    	<option value="#qHostCompanyList.hostCompanyID#" <cfif qGetCandidate.requested_placement EQ qHostCompanyList.hostCompanyID>selected</cfif>> 
															<cfif LEN(qHostCompanyList.name) GT 40>
                                                                #Left(qHostCompanyList.name, 52)#...
                                                            <cfelse>
                                                                #qHostCompanyList.name#
                                                            </cfif>
                                                        </option>
                                                    </cfloop>
                                                </select>
 	                                       </td>
                                        </tr>			
                                        <tr>
	                                        <td class="style1" align="right"><strong>Comments:</strong></td>
    	                                    <td class="style1">
        	                                	<span class="readOnly">#qGetCandidate.change_requested_comment#</span>
            		                            <textarea name="change_requested_comment" class="style1 editPage largeTextArea">#qGetCandidate.change_requested_comment#</textarea>
                    	                    </td>
                                        </tr>
                                        <tr>
                                        	<td class="style1" align="right"><strong>Start Date:</strong></td>
                                        	<td class="style1">
                                            	<span class="readOnly">#dateFormat(qGetCandidate.startdate, 'mm/dd/yyyy')#</span>
                                            	<input type="text" class="style1 datePicker editPage" name="program_startdate" value="#dateFormat(qGetCandidate.startdate, 'mm/dd/yyyy')#" maxlength="10"> 
                                                <cfif NOT LEN(qGetCandidate.startdate)><font size="1">(mm/dd/yyyy)</font></cfif>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong>End Date:</strong></td>
                                            <td class="style1">
                                                <span class="readOnly">#dateFormat(qGetCandidate.enddate, 'mm/dd/yyyy')#</span>
                                                <input type="text" class="style1 datePicker editPage" name="program_enddate" value="#dateFormat(qGetCandidate.enddate, 'mm/dd/yyyy')#" maxlength="10"> 
                                                <cfif NOT LEN(qGetCandidate.enddate)><font size="1">(mm/dd/yyyy)</font></cfif>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong>Program Remarks:</strong></td>
                                            <td class="style1">
                                                <span class="readOnly">#qGetCandidate.programRemarks#</span>
                                                <textarea name="programRemarks" class="style1 editPage largeTextArea">#qGetCandidate.programRemarks#</textarea>
                                            </td>
                                        </tr>
                                    </table>
                        
                                </td>
                            </tr>
                        </table> 

						<br />
                        
                        <!--- INSURANCE INFO --->
                        <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
                                <td bordercolor="##FFFFFF">
                        
                                    <table width="100%" cellpadding="4" cellspacing="0" border="0">
                                        <tr bgcolor="##C2D1EF">
                                            <td colspan="3" class="style2" bgcolor="##8FB6C9">
                                                &nbsp;:: Insurance &nbsp; &nbsp; &nbsp; &nbsp; 
                                                <!--- Office View Only --->
												<cfif ListFind("1,2,3,4", CLIENT.userType)>
	                                                <span style="float:right; padding-right:20px;">
                                                    	<a href="javascript:openWindow('insurance/insurance_mgmt.cfm?uniqueid=#uniqueid#', 500, 800);" class="style2">[ Insurance Management ]</a>
                                                    </span>
                                                </cfif>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="30%" class="style1" align="right">
                                            	<strong>Policy Type:</strong>
                                            </td>
                                            <td width="70%" class="style1" align="left">
                                                <cfif qGetIntlRepInfo.extra_insurance_typeid EQ 0>
                                                    <font color="FF0000">Missing Policy Type</font>
                                                <cfelse>
                                                    #qGetIntlRepInfo.type#
                                                </cfif>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong>Filed Date:</strong></td>
                                            <td class="style1">
                                                <cfif qGetIntlRepInfo.extra_insurance_typeid GT 1 AND qGetCandidate.insurance_date EQ ''>
                                                    not insured yet
                                                <cfelseif qGetCandidate.insurance_date NEQ ''>
                                                    #dateFormat(qGetCandidate.insurance_date, 'mm/dd/yyyy')#
                                                <cfelse>
                                                    N/A
                                                </cfif>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong>Cancel Date:</strong></td>
                                            <td class="style1">
                                                <cfif IsDate(qGetCandidate.insurance_cancel_date)>
                                                    #dateFormat(qGetCandidate.insurance_cancel_date, 'mm/dd/yyyy')#
                                                <cfelse>
                                                    N/A
                                                </cfif>
                                            </td>
                                        </tr>
                                    </table>
                   
                                </td>
                            </tr>
                        </table> 

						<br />
                        
                	</td>        
					<!--- END OF LEFT SECTION --->
				
					<!--- DIVIDER --->
                    <td width="2%" valign="top">&nbsp;</td>
                	
                    <!--- RIGHT SECTION --->	    
                    <td width="49%" valign="top">

                    	<!--- CANCELATION --->
                    	<div id="divCancelation" <cfif qGetCandidate.status NEQ 'canceled' AND NOT LEN(qGetCandidate.cancel_date)> style="display:none;" </cfif> >
                            <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                                <tr>
                                    <td bordercolor="##FFFFFF">
                                
                                        <table width="100%" cellpadding="4" cellspacing="0" border="0">
                                            <tr bgcolor="##C2D1EF">
                                                <td colspan="3" class="style2" bgcolor="##8FB6C9">&nbsp;:: Cancelation	</td>
                                            </tr>
                                            <tr>
                                                <td width="12%" class="style1"><strong>Date: </strong></td>
                                                <td colspan="2" class="style1">
                                                    <span class="readOnly">#dateFormat(qGetCandidate.cancel_date, 'mm/dd/yyyy')#</span>
                                                    <input type="text" name="cancel_date" id="cancel_date" class="style1 editPage datePicker"value="#dateFormat(qGetCandidate.cancel_date, 'mm/dd/yyyy')#">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style1" align="right"><strong>Reason:</strong></td>
                                                <td class="style1">
                                                    <span class="readOnly">#qGetCandidate.cancel_reason#</span>
                                                    <input name="cancel_reason" id="cancel_reason" type="text" class="style1 editPage xLargeField" value="#qGetCandidate.cancel_reason#">
                                                </td>								
                                            </tr>
                                        </table>	
                                
                                    </td>
                                </tr>
                            </table> 
							
                            <br />
                        
                        </div>
                        
						<!--- HOST COMPANY INFO / PLACEMENT INFO --->
                        <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
                                <td bordercolor="##FFFFFF">
                        
                                    <table width="100%" cellpadding="4" cellspacing="0" border="0">
                                        <tr bgcolor="##C2D1EF" bordercolor="##FFFFFF">
            	                            <td colspan="2" class="style2" bgcolor="##8FB6C9">
                                            	&nbsp;:: Placement Information
                                                <!--- Office View Only ---> 
                                            	<cfif ListFind("1,2,3,4", CLIENT.userType)>
		                                            <span style="float:right; padding-right:20px;">
                                                    	<a href="javascript:openWindow('candidate/candidate_host_history.cfm?unqid=#qGetCandidate.uniqueid#', 400, 750);" class="style2">[ History ]</a>
                                                    </span>
        										</cfif>
											</td>			                                                
                                        </tr>
                                        <tr>
                                        	<td class="style1" align="right" width="30%"><strong>Company Name:</strong></td>
                                            <td class="style1" align="left" width="70%">
                                            	<span class="readOnly">
                                                    <a 
                                                        href="?curdoc=hostcompany/hostCompanyInfo&hostCompanyID=#qCandidatePlaceCompany.hostCompanyID#" 
                                                        class="style4" 
                                                        target="_blank">
                                                        <strong>#qCandidatePlaceCompany.hostCompanyName#</strong>
                                                    </a>
                                                </span>
                                                <select 
                                                	name="hostCompanyID" 
                                                    id="hostCompanyID" 
                                                    class="style1 editPage xLargeField" 
                                                    onChange="displayHostReason(#VAL(qCandidatePlaceCompany.hostCompanyID)#, this.value, #VAL(qGetCandidate.candidateID)#); displaySelfPlacementInfo(1);">
	                                                <option value="0">Unplaced</option>
                                                    <cfloop query="qHostCompanyList">
                                                    	<option value="#qHostCompanyList.hostCompanyID#" <cfif qCandidatePlaceCompany.hostCompanyID EQ qHostCompanyList.hostCompanyID> selected </cfif> > 
															<cfif LEN(qHostCompanyList.name) GT 55>
                                                                #Left(qHostCompanyList.name, 52)#...
                                                            <cfelse>
                                                                #qHostCompanyList.name#
                                                            </cfif>
                                                        </option>
                                                    </cfloop>
                                                </select>
                                                <span class="editPage" id="warningStatus" style="background-color:red; font-weight:bold; display:none;">
                                                	<br/>
                                                	<span id="warningNotes"></span>
                                                </span>
                                            </td>
                                        </tr>
                                        <tr class="readOnly">
                                        	<td class="style1" align="right" width="30%"><strong>Address:</strong></td>
                                            <td class="style1" align="left" width="70%"><span class="readOnly">#qCandidatePlaceCompany.address#</span></td>
                                        </tr>
                                        <tr class="readOnly">
                                        	<td class="style1" align="right" width="30%"><strong>City:</strong></td>
                                            <td class="style1" align="left" width="70%"><span class="readOnly">#qCandidatePlaceCompany.city#</span></td>
                                        </tr>
                                        <tr class="readOnly">
                                        	<td class="style1" align="right" width="30%"><strong>State:</strong></td>
                                            <td class="style1" align="left" width="70%"><span class="readOnly">#qCandidatePlaceCompany.state#</span></td>
                                        </tr>
                                        <tr class="readOnly">
                                        	<td class="style1" align="right" width="30%"><strong>Zip:</strong></td>
                                            <td class="style1" align="left" width="70%"><span class="readOnly">#qCandidatePlaceCompany.zip#</span></td>
                                        </tr>
                                        <tr>
                                        	<td class="style1" align="right" width="30%"><strong>Job Title:</strong></td>
                                            <td class="style1" align="left" width="70%">
                                            	<span class="readOnly">
                                                	#qCandidatePlaceCompany.jobTitle#, POC: #qCandidatePlaceCompany.supervisor#, POC Phone: #qCandidatePlaceCompany.phone#
                                              	</span>
                                                <cfselect 
                                                    name="jobID"
                                                    id="jobID"
                                                    class="style1 editPage xLargeField"
                                                    multiple="no"
                                                    value="ID"
                                                    display="title"
                                                    selected="#qCandidatePlaceCompany.jobID#"
                                                    bind="cfc:extensions.components.hostCompany.getJobTitle({hostCompanyID})"
                                                    bindonload="true" />
                                            </td>
                                        </tr>
                                        <!--- Housing --->
										<tr>
											<td class="style1" align="right" width="30%"><strong>Is Housing Provided?:</strong></td>
                                            <td class="style1" align="left" width="70%">
												<cfif qCandidatePlaceCompany.isHousingProvided EQ 1>
                                                	Yes
                                             	<cfelseif qCandidatePlaceCompany.isHousingProvided EQ 2>
													Other (third party)
												<cfelse>
													No
												</cfif>
											</td>
										</tr>
                                        <cfif qCandidatePlaceCompany.isHousingProvided NEQ 1>
                                            <tr>
                                                <td class="style1" align="right" width="30%"><strong>Housing Arranged:</strong></td>
                                                <td class="style1" align="left" width="70%">
                                                    <span class="readOnly">
                                                        <cfif VAL(qGetCandidate.housingArrangedPrivately)>
                                                            Yes
                                                        <cfelse>
                                                            No
                                                        </cfif>
                                                    </span>
                                                    <select class="style1 editPage" name="housingArrangedPrivately" onChange="checkHousingDetailsArea(this.value);">
                                                        <option value="0"<cfif NOT VAL(qGetCandidate.housingArrangedPrivately)>selected="selected"</cfif>>No</option>
                                                        <option value="1"<cfif VAL(qGetCandidate.housingArrangedPrivately)>selected="selected"</cfif>>Yes</option>
                                                    </select>
                                                    <strong>Details:</strong>
                                                    <span class="readOnly">
                                                        #qGetCandidate.housingDetails#
                                                    </span>
                                                    <span class="editPage">
                                                        <textarea name="housingDetails" class="style1 editPage largeTextArea">#qGetCandidate.housingDetails#</textarea>
                                                    </span>
                                                </td>
                                            </tr>
                                        </cfif>
                                        
                                        <tr class="notReplacement">
                                        	<td class="style1" align="right" width="30%">
                                            	<label for="wat_doc_job_offer_employer"><strong>Job Offer Agreement Employer:</strong></label>
                                           	</td>
                                            <td class="style1" align="left" width="70%">
                                                <input 
                                                	type="checkbox" 
                                                    name="wat_doc_job_offer_employer" 
                                                    id="wat_doc_job_offer_employer" 
                                                    value="1" 
                                                    class="formField" 
                                                    disabled 
													<cfif VAL(qGetCandidate.wat_doc_job_offer_employer)> checked </cfif> > 
                                            </td>
                                        </tr>
                                        <tr class="editPage">
                                        	<td class="style1 cancelSecondaryPlacement" align="right" width="30%">
                                            	<label for="wat_doc_job_offer_employer"><strong>Cancel Placement?</strong></label>
                                           	</td>
                                            <td class="style1 cancelSecondaryPlacement" align="left" width="70%">
                                                <select name="cancelStatus" id="cancelStatus" class="style1 smallField" style="font-size:10px; vertical-align:middle;">
                                                	<option value="0"> No </option>
                                                    <option value="1"> Yes </option>
                                                </select> 
                                            </td>
                                        </tr>
                                        
                                        <!--- Change Placement --->
                                        <tr id="hostCompanyChangeReason" class="hiddenField trReasonInfo">
                                           	<td class="style1" align="right"><strong>Reason:</strong></td>
                                            <td width="70%" class="style1">
                                            	<textarea name="reason_host" id="reason_host" class="style1 editPage mediumTextArea">#qCandidatePlaceCompany.reason_host#</textarea>
                                            </td>
                                        </tr>
                                        
                                        <!--- Deadline for seeking employment --->
                                        <tr id="deadline">
                                            <td class="style1" align="right" width="30%"><strong>Deadline:</strong></td>
                                            <td class="style1" align="left" width="70%">
                                                <span class="readOnly">#DateFormat(qCandidatePlaceCompany.seekingDeadline,'mm/dd/yyyy')#</span>
                                                <span class="editPage">
                                                	<input type="text" class="datePicker editPage" name="seekingDeadline" value="#DateFormat(qCandidatePlaceCompany.seekingDeadline,'mm/dd/yyyy')#"/>
                                                </span>
                                            </td>
                                        </tr>

                                        <!--- Placement Date --->
                                        <tr class="readOnly">
                                        	<td class="style1" align="right"><strong>Placement Date:</strong></td>
                                            <td class="style1" align="left">
	                                        	#dateFormat(qCandidatePlaceCompany.placement_date, 'mm/dd/yyyy')#
                                            </td>
                                        </tr>
                                        
                                        <tr id="trReasonInfo" class="hiddenField trReasonInfo">
                                        	<td class="style1" align="right" width="30%"><strong>Is this a replacement?</strong></td>
                                            <td class="style1" width="70%">
                                            	<span class="readOnly"><cfif qCandidatePlaceCompany.isTransfer EQ 1>Yes<cfelse>No</cfif></span>
                                                <select name="isTransfer" id="isTransfer" class="style1 editPage transferField smallField" onChange="displayTransferInfo(); respondToNewPlacement();">
                                                    <option value="0" <cfif qCandidatePlaceCompany.isTransfer EQ 0> selected </cfif> > No </option>
                                                    <option value="1" <cfif qCandidatePlaceCompany.isTransfer EQ 1> selected </cfif> > Yes </option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr id="secondPlacement" class="hiddenField trReasonInfo" style="display:none;">
                                        	<td class="style1" align="right" width="30%"><strong>Is this a secondary placement?</strong></td>
                                            <td class="style1" width="70%">
                                                <select name="isSecondary" id="isSecondary" class="style1 editPage transferField smallField" onChange="respondToNewPlacement();">
                                                    <option value="0" <cfif qCandidatePlaceCompany.isSecondary EQ 0> selected </cfif> > No </option>
                                                    <option value="1" <cfif qCandidatePlaceCompany.isSecondary EQ 1> selected </cfif> > Yes </option>
                                                </select>
                                            </td>
                                        </tr>
                                        
                                        <!--- Transfer Info --->
                                        <cfif LEN(qCandidatePlaceCompany.dateTransferConfirmed)>
                                        	<tr class="readOnly">
                                           		<td class="style1" align="right" width="30%"><strong>Confirmation Date:</strong></td>
                                                <td class="style1" width="70%">
                                                    <span class="readOnly">#DateFormat(qCandidatePlaceCompany.dateTransferConfirmed, 'mm/dd/yyyy')#</span>
                                                </td>
                                            </tr>
                                        </cfif>
                                        <tr class="hiddenField trTransferInfo">
                                        	<td colspan="2">
                                                <table cellpadding="0" cellspacing="0" width="100%">
                                                    <tr class="hiddenField trTransferInfo">
                                                    
														<!--- Do not show the new job offer box if the student is seeking employment --->
                                                        <cfif FORM.hostCompanyID EQ 0>
                                                        	<cfif qCandidatePlaceCompany.hostCompanyID NEQ 195>
                                                                <td width="33%" class="style1" align="center" id="newJobOffer">
                                                                    <input 
                                                                    	type="checkbox" 
                                                                        name="isTransferJobOfferReceived" 
                                                                        id="isTransferJobOfferReceived" 
                                                                        value="1" 
                                                                        class="formField transferCheckBox" 
                                                                        disabled 
																		<cfif qCandidatePlaceCompany.isTransferJobOfferReceived EQ 1>checked</cfif> > 
                                                                    <label for="isTransferJobOfferReceived">New Job Offer</label> 
                                                                </td>
                                                            </cfif>
                                                      	<cfelse>
                                                        	<cfif FORM.hostCompanyID NEQ 195>
                                                            	<td width="33%" class="style1" align="center" id="newJobOffer">
                                                                    <input 
                                                                    	type="checkbox" 
                                                                        name="isTransferJobOfferReceived" 
                                                                        id="isTransferJobOfferReceived" 
                                                                        value="1" 
                                                                        class="formField transferCheckBox" 
                                                                        disabled 
																		<cfif qCandidatePlaceCompany.isTransferJobOfferReceived EQ 1>checked</cfif> > 
                                                                    <label for="isTransferJobOfferReceived">New Job Offer</label> 
                                                                </td>
                                                            </cfif>
                                                       	</cfif>
														<cfif (FORM.hostCompanyID EQ 0 AND qCandidatePlaceCompany.hostCompanyID EQ 195) OR (FORM.hostCompanyID EQ 195)>
                                                            <td width="33%" class="style1" align="center" id="tempNewJobOffer">&nbsp;</td>
                                                        </cfif>
                                                    	
                                                        <td width="33%" class="style1" align="center">
                                                            <input 
                                                            	type="checkbox" 
                                                                name="isTransferHousingAddressReceived" 
                                                                id="isTransferHousingAddressReceived" 
                                                                value="1" 
                                                                class="formField transferCheckBox" 
                                                                disabled 
																<cfif qCandidatePlaceCompany.isTransferHousingAddressReceived EQ 1>checked</cfif> > 
                                                            <label for="isTransferHousingAddressReceived">New Housing Address</label> 
                                                        </td>
                                                        <td width="33%" class="style1" align="center">
                                                            <input 
                                                            	type="checkbox" 
                                                                name="isTransferSevisUpdated" 
                                                                id="isTransferSevisUpdated" 
                                                                value="1" 
                                                                class="formField transferCheckBox" 
                                                                disabled 
																<cfif qCandidatePlaceCompany.isTransferSevisUpdated EQ 1>checked</cfif> > 
                                                            <label for="isTransferSevisUpdated">SEVIS Updated</label> 
                                                        </td>
                                                    </tr>
                                                </table>
                                        	
                                            </td>
										</tr> 
                                        <!--- End of Transfer Info ---> 
                                    
                                        <tr bgcolor="##C2D1EF" bordercolor="##FFFFFF" class="hiddenField selfPlacementInfo">
                                            <td colspan="2" class="style2" bgcolor="##8FB6C9">
                                            	&nbsp;:: Placement Vetting
                                            	<!--- Office View Only ---> 
                                            	<cfif ListFind("1,2,3,4", CLIENT.userType)>
		                                            <span class="readOnly" style="float:right; padding-right:20px;">
                                                    	<cfif LEN(qCandidatePlaceCompany.savedPlacementVetting)>
                                                    		<a 
                                                            	href="javascript:openWindow('../uploadedFiles/candidate/#qGetCandidate.candidateID#/#qCandidatePlaceCompany.savedPlacementVetting#',800,900);" 											
                                                                class="style2">
                                                                	[ Saved Vetting - #DateFormat(qCandidatePlaceCompany.dateCreated,'mm/dd/yyyy')# ]
                                                          	</a>
                                                      	</cfif>
                                                        <a 
                                                        	href="
                                                            	javascript:openWindow('candidate/placementVettingPrint.cfm?uniqueid=#qGetCandidate.uniqueid#&candCompID=#qCandidatePlaceCompany.candCompID#',
                                                            	800,
                                                            	900);"
                                                            class="style2">
                                                            	[ Print ]
                                                      	</a>
                                                    </span>
        										</cfif>
                                          	</td>
                                        </tr>
                                        <tr class="hiddenField selfPlacementInfo">
                                            <td class="style1" align="right"><strong>Job Offer Status:</strong></td>
                                            <td class="style1">
                                                <span class="readOnly selfPlacementReadOnly">#qCandidatePlaceCompany.selfJobOfferStatus#</span>
                                                <select name="selfJobOfferStatus" id="selfJobOfferStatus" class="style1 editPage selfPlacementField mediumField"> 
                                                	<option value="" <cfif NOT LEN(qCandidatePlaceCompany.selfJobOfferStatus)>selected</cfif> ></option>
                                                    <option value="Pending" <cfif qCandidatePlaceCompany.selfJobOfferStatus EQ 'Pending'>selected</cfif> >Pending</option>
                                                    <option value="Confirmed" <cfif qCandidatePlaceCompany.selfJobOfferStatus EQ 'Confirmed'>selected</cfif> >Confirmed</option>
                                                    <option value="Rejected" <cfif qCandidatePlaceCompany.selfJobOfferStatus EQ 'Rejected'>selected</cfif> >Rejected</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr class="hiddenField selfPlacementInfo">
                                            <td class="style1" align="right"><strong>Name:</strong></td>
                                            <td class="style1">
                                                <span class="readOnly selfPlacementReadOnly">#qCandidatePlaceCompany.selfConfirmationName#</span>
                                                <input 
                                                	type="text" 
                                                    name="selfConfirmationName" 
                                                    id="selfConfirmationName" 
                                                    value="#qCandidatePlaceCompany.selfConfirmationName#" 
                                                    class="style1 editPage selfPlacementField xLargeField">
                                            </td>
                                        </tr>
                                        <tr class="hiddenField selfPlacementInfo">
                                        	<td class="style1" align="right"><strong>Confirmation of Terms:</strong></td>
                                            <td class="style1">
                                            	<input type="hidden" id="confirmation" name="confirmation" <cfif qCandidatePlaceCompany.confirmed EQ 1>value="1"<cfelse>value="0"</cfif> />
                                                <input class="formField" type="checkbox" class="formField" onclick="changeValue('confirmation')" name="confirmationCheckbox" id="confirmationCheckbox" <cfif qCandidatePlaceCompany.confirmed EQ 1>checked="checked"</cfif> />
                                            </td>
                                        </tr>
                                        <tr class="hiddenField selfPlacementInfo">
                                        	<td class="style1" align="right"><strong>Available J1 Positions:</strong></td>
                                            <td class="style1">
                                            	<span class="readOnly">#qCandidatePlaceCompany.numberPositions#</span>
                                                <select class="editPage" id="numberPositionsSelect" name="numberPositionsSelect">
                                                	<cfloop from="0" to="99" index="i">
                                                    	<option value="#i#" <cfif qCandidatePlaceCompany.numberPositions EQ i>selected</cfif>>#i#</option>
                                                    </cfloop>
                                                </select>
                                            </td>
                                        </tr>
                                        
                                        <!--- Authentications --->
                                        <tr class="hiddenField selfPlacementInfo">
                                        
                                        	<td class="style1" colspan="2">
            
                                                <table width="100%" cellpadding="3" cellspacing="3" align="center" style="border:1px solid ##C7CFDC; background-color:##F7F7F7;">
                                                	
                                                    <tr class="hiddenField selfPlacementInfo">
                                                    	<td colspan="2">
                                                        	<strong><center>Authentication</center></strong>
                                                            <br />
                                                            <span style="margin-left:35%"><u>Expiration Date</u></span>
                                                        </td>
                                                    </tr>
                                                
                                             		<tr class="hiddenField selfPlacementInfo">
                                                        <td class="style1" align="right" width="30%">
                                                        	<label for="authentication_secretaryOfState"><strong>Business License:</strong></label>
                                                            <br />
                                                            <i>Not Available:</i>
                                                            <input
                                                                id="authentication_businessLicenseNotAvailable" 
                                                                name="authentication_businessLicenseNotAvailable" 
                                                                class="formField" 
                                                                disabled="disabled"
                                                                type="checkbox"
                                                                onclick="changeAuthenticationAvailable()"
                                                                value="1"
                                                                <cfif VAL(qCandidatePlaceCompany.authentication_businessLicenseNotAvailable)>checked </cfif> />
                                                       	</td>
                                                        <td class="style1" width="70%">
                                                            <input 
                                                            	type="checkbox" 
                                                                name="authentication_secretaryOfState" 
                                                                id="authentication_secretaryOfState" 
                                                                value="1" 
                                                                class="formField" 
                                                                disabled 
																<cfif VAL(qCandidatePlaceCompany.authentication_secretaryOfState)> checked </cfif> />
                                                         	<span id="authentication_secretaryOfStateExpiration" style="padding-left:3px;">
                                                           		<cfif qCandidatePlaceCompany.authentication_secretaryOfStateExpiration LT NOW()>
                                                                	<font style="color:red;">
                                                                    	#DateFormat(qCandidatePlaceCompany.authentication_secretaryOfStateExpiration,'mm/dd/yyyy')#
                                                                    </font>
                                                               	<cfelse>
                                                                	#DateFormat(qCandidatePlaceCompany.authentication_secretaryOfStateExpiration,'mm/dd/yyyy')#
                                                                </cfif>
                                                            </span>
                                                        </td>
                                                    </tr>
                                                    <!--- Additional Authentications --->
                                                    <tr 
                                                    	class="additionalAuthentications" 
														<cfif NOT VAL(qCandidatePlaceCompany.authentication_businessLicenseNotAvailable)>style="display:none;"</cfif>>
                                                        <td class="style1" align="right"><label for="authentication_incorporation"><strong>Incorporation:</strong></label></td>
                                                        <td class="style1">
                                                            <input 
                                                            	type="checkbox" 
                                                                name="authentication_incorporation" 
                                                                id="authentication_incorporation" 
                                                                value="1" 
                                                                class="formField" 
                                                                disabled 
																<cfif VAL(qCandidatePlaceCompany.authentication_incorporation)> checked </cfif> />
                                                          	<span id="authentication_incorporationExpiration" style="padding-left:3px;">
                                                           		<cfif qCandidatePlaceCompany.authentication_incorporationExpiration LT NOW()>
                                                                	<font style="color:red;">
                                                                    	#DateFormat(qCandidatePlaceCompany.authentication_incorporationExpiration,'mm/dd/yyyy')#
                                                                    </font>
                                                               	<cfelse>
                                                                	#DateFormat(qCandidatePlaceCompany.authentication_incorporationExpiration,'mm/dd/yyyy')#
                                                                </cfif>
                                                            </span>
                                                        </td>
                                                    </tr>
                                                    <tr 
                                                    	class="additionalAuthentications" 
														<cfif NOT VAL(qCandidatePlaceCompany.authentication_businessLicenseNotAvailable)>style="display:none;"</cfif>>
                                                        <td class="style1" align="right"><label for="authentication_certificateOfExistence"><strong>Certificate of Existence:</strong></label></td>
                                                        <td class="style1">
                                                            <input 
                                                            	type="checkbox" 
                                                                name="authentication_certificateOfExistence" 
                                                                id="authentication_certificateOfExistence" 
                                                                value="1" 
                                                                class="formField" 
                                                                disabled 
																<cfif VAL(qCandidatePlaceCompany.authentication_certificateOfExistence)> checked </cfif> />
                                                            <span id="authentication_certificateOfExistenceExpiration" style="padding-left:3px;">
                                                           		<cfif qCandidatePlaceCompany.authentication_certificateOfExistenceExpiration LT NOW()>
                                                                	<font style="color:red;">
                                                                    	#DateFormat(qCandidatePlaceCompany.authentication_certificateOfExistenceExpiration,'mm/dd/yyyy')#
                                                                    </font>
                                                               	<cfelse>
                                                                	#DateFormat(qCandidatePlaceCompany.authentication_certificateOfExistenceExpiration,'mm/dd/yyyy')#
                                                                </cfif>
                                                            </span>
                                                        </td>
                                                    </tr>
                                                    <tr 
                                                    	class="additionalAuthentications" 
														<cfif NOT VAL(qCandidatePlaceCompany.authentication_businessLicenseNotAvailable)>style="display:none;"</cfif>>
                                                        <td class="style1" align="right"><label for="authentication_certificateOfReinstatement"><strong>Certificate of Reinstatement:</strong></label></td>
                                                        <td class="style1">
                                                            <input 
                                                            	type="checkbox"
                                                                name="authentication_certificateOfReinstatement" 
                                                                id="authentication_certificateOfReinstatement" 
                                                                value="1" 
                                                                class="formField" 
                                                                disabled 
																<cfif VAL(qCandidatePlaceCompany.authentication_certificateOfReinstatement)> checked </cfif> />
                                                            <span id="authentication_certificateOfReinstatementExpiration" style="padding-left:3px;">
                                                           		<cfif qCandidatePlaceCompany.authentication_certificateOfReinstatementExpiration LT NOW()>
                                                                	<font style="color:red;">
                                                                    	#DateFormat(qCandidatePlaceCompany.authentication_certificateOfReinstatementExpiration,'mm/dd/yyyy')#
                                                                    </font>
                                                               	<cfelse>
                                                                	#DateFormat(qCandidatePlaceCompany.authentication_certificateOfReinstatementExpiration,'mm/dd/yyyy')#
                                                                </cfif>
                                                            </span>
                                                        </td>
                                                    </tr>
                                                    <tr 
                                                    	class="additionalAuthentications" 
														<cfif NOT VAL(qCandidatePlaceCompany.authentication_businessLicenseNotAvailable)>style="display:none;"</cfif>>
                                                        <td class="style1" align="right"><label for="authentication_departmentOfState"><strong>Department of State:</strong></label></td>
                                                        <td class="style1">
                                                            <input 
                                                            	type="checkbox" 
                                                                name="authentication_departmentOfState" 
                                                                id="authentication_departmentOfState" 
                                                                value="1" 
                                                                class="formField" 
                                                                disabled 
																<cfif VAL(qCandidatePlaceCompany.authentication_departmentOfState)> checked </cfif> />
                                                            <span id="authentication_departmentOfStateExpiration" style="padding-left:3px;">
                                                           		<cfif qCandidatePlaceCompany.authentication_departmentOfStateExpiration LT NOW()>
                                                                	<font style="color:red;">
                                                                    	#DateFormat(qCandidatePlaceCompany.authentication_departmentOfStateExpiration,'mm/dd/yyyy')#
                                                                    </font>
                                                               	<cfelse>
                                                                	#DateFormat(qCandidatePlaceCompany.authentication_departmentOfStateExpiration,'mm/dd/yyyy')#
                                                                </cfif>
                                                            </span>
                                                        </td>
                                                    </tr>
                                                    <!--- End Additional Authentications --->
                                                    <tr class="hiddenField selfPlacementInfo">
                                                        <td class="style1" align="right"><label for="authentication_departmentOfLabor"><strong>Department of Labor:</strong></label></td>
                                                        <td class="style1">
                                                            <input 
                                                            	type="checkbox" 
                                                                name="authentication_departmentOfLabor" 
                                                                id="authentication_departmentOfLabor" 
                                                                value="1" 
                                                                class="formField" 
                                                                disabled 
																<cfif VAL(qCandidatePlaceCompany.authentication_departmentOfLabor)> checked </cfif> />
                                                            <span id="authentication_departmentOfLaborExpiration" style="padding-left:3px;">
                                                           		<cfif qCandidatePlaceCompany.authentication_departmentOfLaborExpiration LT NOW()>
                                                                	<font style="color:red;">
                                                                    	#DateFormat(qCandidatePlaceCompany.authentication_departmentOfLaborExpiration,'mm/dd/yyyy')#
                                                                    </font>
                                                               	<cfelse>
                                                                	#DateFormat(qCandidatePlaceCompany.authentication_departmentOfLaborExpiration,'mm/dd/yyyy')#
                                                                </cfif>
                                                            </span>
                                                        </td>
                                                    </tr>
                                                    <tr class="hiddenField selfPlacementInfo">
                                                        <td class="style1" align="right"><label for="authentication_googleEarth"><strong>Google Earth:</strong></label></td>
                                                        <td class="style1">
                                                            <input 
                                                            	type="checkbox" 
                                                                name="authentication_googleEarth" 
                                                                id="authentication_googleEarth" 
                                                                value="1" 
                                                                class="formField" 
                                                                disabled 
																<cfif VAL(qCandidatePlaceCompany.authentication_googleEarth)> checked </cfif> />
                                                            <span id="authentication_googleEarthExpiration" style="padding-left:3px;">
                                                           		<cfif qCandidatePlaceCompany.authentication_googleEarthExpiration LT NOW()>
                                                                	<font style="color:red;">
                                                                    	#DateFormat(qCandidatePlaceCompany.authentication_googleEarthExpiration,'mm/dd/yyyy')#
                                                                    </font>
                                                               	<cfelse>
                                                                	#DateFormat(qCandidatePlaceCompany.authentication_googleEarthExpiration,'mm/dd/yyyy')#
                                                                </cfif>
                                                            </span>
                                                        </td>
                                                    </tr>
                                                    
                                                </table>
                                           	
                                            </td>
                                            
                                      	</tr>
                                        
                                        <tr class="hiddenField selfPlacementInfo">
                                            <td class="style1" align="right"><strong>EIN:</strong></td>
                                            <td class="style1">
                                                <span class="readOnly selfPlacementReadOnly">#qCandidatePlaceCompany.EIN#</span>
                                                <input type="text" name="EIN" id="EIN" value="#qCandidatePlaceCompany.EIN#" class="style1 editPage mediumField">
                                            </td>
                                        </tr>
                                        <tr class="hiddenField selfPlacementInfo">
                                            <td class="style1" align="right"><strong>Workmen's Compensation:</strong></td>
                                            <td class="style1">
                                                <span class="readOnly selfPlacementReadOnly">
                                                    <cfif qCandidatePlaceCompany.workmensCompensation EQ 0>
                                                        No
                                                    <cfelseif qCandidatePlaceCompany.workmensCompensation EQ 1>
                                                        Yes
                                                    <cfelseif qCandidatePlaceCompany.workmensCompensation EQ 2>
                                                        N/A
                                                    </cfif>
                                                </span>
                                                <select name="workmensCompensation" id="workmensCompensation" class="style1 editPage smallField"> 
                                                    <option value="" <cfif NOT LEN(qCandidatePlaceCompany.workmensCompensation)>selected</cfif> ></option>
                                                    <option value="0" <cfif qCandidatePlaceCompany.workmensCompensation EQ 0>selected</cfif> >No</option>
                                                    <option value="1" <cfif qCandidatePlaceCompany.workmensCompensation EQ 1>selected</cfif> >Yes</option>                                                    
                                                    <option value="2" <cfif qCandidatePlaceCompany.workmensCompensation EQ 2>selected</cfif> >N/A</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <cfif ListFind("1,2,3,4", CLIENT.userType)>
                                            <tr class="hiddenField selfPlacementInfo">
                                                <td class="style1" align="right"><strong>Carrier Name:</strong></td>
                                                <td class="style1">
                                                    <span class="readOnly selfPlacementReadOnly">
                                                        #qCandidatePlaceCompany.WC_carrierName#
                                                    </span>
                                                    <input 
                                                        type="text" 
                                                        name="WC_carrierName" 
                                                        id="WC_carrierName" 
                                                        value="#qCandidatePlaceCompany.WC_carrierName#" 
                                                        class="style1 editPage"
                                                        size="40">
                                                </td>
                                            </tr>
                                            <tr class="hiddenField selfPlacementInfo">
                                                <td class="style1" align="right"><strong>Carrier Phone:</strong></td>
                                                <td class="style1">
                                                    <span class="readOnly selfPlacementReadOnly">
                                                        #qCandidatePlaceCompany.WC_carrierPhone#
                                                    </span>
                                                    <input 
                                                        type="text" 
                                                        name="WC_carrierPhone" 
                                                        id="WC_carrierPhone" 
                                                        value="#qCandidatePlaceCompany.WC_carrierPhone#" 
                                                        class="style1 editPage"
                                                        size="40">
                                                </td>
                                            </tr>
                                            <tr class="hiddenField selfPlacementInfo">
                                                <td class="style1" align="right"><strong>Policy Number:</strong></td>
                                                <td class="style1">
                                                    <span class="readOnly selfPlacementReadOnly">
                                                        #qCandidatePlaceCompany.WC_policyNumber#
                                                    </span>
                                                    <input 
                                                        type="text" 
                                                        name="WC_policyNumber" 
                                                        id="WC_policyNumber" 
                                                        value="#qCandidatePlaceCompany.WC_policyNumber#" 
                                                        class="style1 editPage" 
                                                        size="40">
                                                </td>
                                            </tr>
                                      	</cfif>
                                        <tr class="hideForSeeking">
                                        	<td class="style1" align="right"><strong>WC Expiration Date:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                            	<span class="readOnly selfPlacementReadOnly">
                                                	<cfif IsDate(qCandidatePlaceCompany.WCDateExpired) AND qCandidatePlaceCompany.WCDateExpired GT NOW()>
                                                    	#DateFormat(qCandidatePlaceCompany.WCDateExpired, 'mm/dd/yyyy')#
                                                  	<cfelseif IsDate(qCandidatePlaceCompany.WCDateExpired)>
                                                    	<font color="red">Expired</font>
                                                    <cfelse>
                                                    	Workmen's compensation is missing.
                                                 	</cfif>
                                             	</span>
                                                <input 
                                                    type="text" 
                                                    name="WCDateExpired" 
                                                    id="WCDateExpired" 
                                                    value="#DateFormat(qCandidatePlaceCompany.WCDateExpired, 'mm/dd/yyyy')#" 
                                                    class="style1 datePicker editPage" 
                                                    maxlength="10">
                                            </td>
                                        </tr>
                                        
                                        <!--- Only display if this is not a replacement --->
                                        <tr class="hiddenField selfPlacementInfo" id="emailConfirmationRow">
                                            <td class="style1" align="right"><strong>Email Confirmation:</strong></td>
                                            <td class="style1" colspan="3">
                                                <span class="readOnly selfPlacementReadOnly">#DateFormat(qCandidatePlaceCompany.selfEmailConfirmationDate, 'mm/dd/yyyy')#</span>
                                                <input 
                                                	type="text" 
                                                    name="selfEmailConfirmationDate" 
                                                    id="selfEmailConfirmationDate" 
                                                    class="style1 datePicker editPage selfPlacementField" 
                                                    value="#DateFormat(qCandidatePlaceCompany.selfEmailConfirmationDate, 'mm/dd/yyyy')#" 
                                                    maxlength="10">
                                                <cfif NOT LEN(qCandidatePlaceCompany.selfEmailConfirmationDate)><font size="1">(mm/dd/yyyy)</font></cfif>
                                            </td>
                                        </tr>
                                            
                                        <tr class="hiddenField selfPlacementInfo">
                                            <td class="style1" align="right"><strong>Phone Confirmation:</strong></td>
                                            <td class="style1" colspan="3">
                                                <span class="readOnly selfPlacementReadOnly">#DateFormat(qCandidatePlaceCompany.confirmation_phone, 'mm/dd/yyyy')#</span>
                                                <input type="text" name="confirmation_phone" id="confirmation_phone" class="style1 datePicker editPage selfPlacementField" value="#DateFormat(qCandidatePlaceCompany.confirmation_phone, 'mm/dd/yyyy')#" maxlength="10">
                                                <cfif NOT LEN(qCandidatePlaceCompany.confirmation_phone)><font size="1">(mm/dd/yyyy)</font></cfif>
                                            </td>
                                        </tr>

										<!--- Office View Only --->
                                        <cfif ListFind("1,2,3,4", CLIENT.userType) AND qCandidatePlaceCompany.isTransfer EQ 0>
                                           
                                            <tr class="hiddenField notReplacement hideForSeeking">
                                                <td class="style1" align="right"><strong>Job Found:</strong></td>
                                                <td class="style1">
                                                    <span class="readOnly selfPlacementReadOnly">
                                                        #qCandidatePlaceCompany.selfFindJobOffer#
                                                    </span>
                                                    <select name="selfFindJobOffer" id="selfFindJobOffer" class="style1 editPage selfPlacementField xLargeField"> 
                                                        <option value="" <cfif NOT LEN(qCandidatePlaceCompany.selfFindJobOffer)>selected</cfif> ></option>
                                                        <option value="International Representative" <cfif qCandidatePlaceCompany.selfFindJobOffer EQ 'International Representative'>selected</cfif> >International Representative</option>
                                                        <option value="Employment Agency" <cfif qCandidatePlaceCompany.selfFindJobOffer EQ 'Employment Agency'>selected</cfif> >Employment Agency</option>                                                    
                                                        <option value="Directly with the Employer" <cfif qCandidatePlaceCompany.selfFindJobOffer EQ 'Directly with the Employer'>selected</cfif> >Directly with the Employer</option>
                                                        <option value="Internet" <cfif qCandidatePlaceCompany.selfFindJobOffer EQ 'Internet'>selected</cfif> >Internet</option>
                                                        <option value="Other" <cfif qCandidatePlaceCompany.selfFindJobOffer EQ 'Other'>selected</cfif> >Other</option>
                                                    </select>
                                                </td>
                                            </tr>
                                            <tr class="hiddenField selfPlacementInfo">
                                                <td class="style1" align="right"><strong>Notes:</strong></td>
                                                <td class="style1" colspan="3">
                                                    <span class="readOnly selfPlacementReadOnly">#qCandidatePlaceCompany.selfConfirmationNotes#</span>
                                                    <textarea name="selfConfirmationNotes" id="selfConfirmationNotes" class="style1 editPage selfPlacementField largeTextArea">#qCandidatePlaceCompany.selfConfirmationNotes#</textarea>
                                                </td>
                                            </tr>
                                            
										</cfif>                                            
                                    </table>	
                        
                                </td>
                            </tr>
                        </table> 

						<br />
                        
                        <!--- SHOW ALL SECONDARY PLACEMENTS --->
                        <cfloop query="qGetAllPlacements">
                        
                        	<cfif qGetAllPlacements.isSecondary EQ "1">
                            
                            	<table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##75B1EC">
                            		<tr>
                                    	<td bordercolor="##FFFFFF">
                                        	 <table width="100%" cellpadding="4" cellspacing="0" border="0" bgcolor="##FFFFFF">
                                                <tr bgcolor="##C2D1EF" bordercolor="##FFFFFF">
                                                    <td colspan="2" class="style2" bgcolor="##8FB6C9">
                                                    	&nbsp;:: Secondary Placement Information
                                                        <!--- Office View Only ---> 
														<cfif ListFind("1,2,3,4", CLIENT.userType)>
                                                            <span class="readOnly" style="float:right; padding-right:20px;">
                                                            	<cfif LEN(qGetAllPlacements.savedPlacementVetting)>
                                                                    <a 
                                                                        href="javascript:openWindow('../uploadedFiles/candidate/#qGetCandidate.candidateID#/#qGetAllPlacements.savedPlacementVetting#',800,900);" 											
                                                                        class="style2">
                                                                            [ Saved Vetting - #DateFormat(qGetAllPlacements.dateCreated,'mm/dd/yyyy')# ]
                                                                    </a>
                                                                </cfif>
                                                                <a href="javascript:openWindow('candidate/placementVettingPrint.cfm?uniqueid=#qGetCandidate.uniqueid#&candCompID=#qGetAllPlacements.candCompID#', 800, 900);" class="style2">[ Print ]</a>
                                                            </span>
                                                        </cfif>
                                                    </td>
                                              	</tr>
                                              	<tr>
                                        			<td class="style1" align="right" width="30%"><strong>Company Name:</strong></td>
                                                    <td class="style1" align="left" width="70%">
                                                        <span>
                                                        	<input type="hidden" name="hostCompanyID_#qGetAllPlacements.candCompID#" id="hostCompanyID_#qGetAllPlacements.candCompID#" value="#qGetAllPlacements.hostCompanyID#" />
                                                            <!--- Office View Only --->
                                                            <cfif ListFind("1,2,3,4", CLIENT.userType)>
                                                                <a href="?curdoc=hostcompany/hostCompanyInfo&hostCompanyID=#qGetAllPlacements.hostCompanyID#" class="style4" target="_blank"><strong>#qGetAllPlacements.hostCompanyName#</strong></a>
                                                            <cfelse>
                                                                #qGetAllPlacements.hostCompanyName#
                                                            </cfif>
                                                        </span>
                                                   	</td>
                                               	</tr>
                                                 <tr>
                                                    <td class="style1" align="right" width="30%"><strong>Job Title:</strong></td>
                                                    <td class="style1" align="left" width="70%">
                                                        <span>#qGetAllPlacements.jobTitle#, POC: #qGetAllPlacements.supervisor#, POC Phone: #qGetAllPlacements.phone#</span>
                                                        <cfselect 
                                                            name="jobID_#qGetAllPlacements.candCompID#"
                                                            id="jobID_#qGetAllPlacements.candCompID#"
                                                            class="style1 editPage xLargeField"
                                                            multiple="no"
                                                            value="ID"
                                                            display="title"
                                                            selected="#qGetAllPlacements.jobID#"
                                                            bind="cfc:extensions.components.hostCompany.getJobTitle({hostCompanyID_#qGetAllPlacements.candCompID#})"
                                                            bindonload="true" />
                                                    </td>
                                                </tr>
                                                <tr class="editPage">
                                                    <td class="style1" align="right" width="30%">
                                                        <label for="wat_doc_job_offer_employer"><strong>Cancel Placement?</strong></label>
                                                    </td>
                                                    <td class="style1" align="left" width="70%">
                                                        <select name="cancelStatus_#qGetAllPlacements.candCompID#" id="cancelStatus_#qGetAllPlacements.candCompID#" class="style1 smallField" style="font-size:10px; vertical-align:middle;">
                                                            <option value="0"> No </option>
                                                            <option value="1"> Yes </option>
                                                        </select> 
                                                    </td>
                                                </tr>
                                                <tr class="readOnly">
                                                    <td class="style1" align="right"><strong>Placement Date:</strong></td>
                                                    <td class="style1" align="left">
                                                        #dateFormat(qGetAllPlacements.placement_date, 'mm/dd/yyyy')#
                                                    </td>
                                                </tr>
                                                <tr>
                                                	<td colspan="2">
                                                    	<table cellpadding="0" cellspacing="0" width="100%">
                                                        	<tr>
                                                            	<!--- Do not show the new job offer box if the student is seeking employment --->
                                                            	<cfif qGetAllPlacements.hostCompanyID NEQ 195>
                                                                    <td width="33%" class="style1" align="center">
                                                                        <input type="checkbox" value="1" name="newJobOffer_#qGetAllPlacements.candCompID#" id="cancelStatus_#qGetAllPlacements.candCompID#" class="formField" <cfif qGetAllPlacements.isTransferJobOfferReceived EQ 1>checked</cfif> > New Job Offer
                                                                    </td>
                                                               	</cfif>
                                                                <td width="33%" class="style1" align="center">
                                                                	<input type="checkbox" value="1" name="newHousingAddress_#qGetAllPlacements.candCompID#" id="cancelStatus_#qGetAllPlacements.candCompID#" class="formField" <cfif qGetAllPlacements.isTransferHousingAddressReceived EQ 1>checked</cfif> > New Housing Address
                                                                </td>
                                                                <td width="33%" class="style1" align="center">
                                                                	<input type="checkbox" value="1" name="sevisUpdated_#qGetAllPlacements.candCompID#" id="cancelStatus_#qGetAllPlacements.candCompID#" class="formField" <cfif qGetAllPlacements.isTransferSevisUpdated EQ 1>checked</cfif> > SEVIS Updated
                                                                </td>
                                                            </tr>
                                                        </table>
                                                  	</td>
                                                </tr>
                                                <tr bgcolor="##C2D1EF" bordercolor="##FFFFFF" class="hiddenField selfPlacementInfo">
                                                    <td colspan="2" class="style2" bgcolor="##8FB6C9">
                                                        &nbsp;:: Placement Vetting
                                                   	</td>
                                               	</tr>
                                                <tr class="hiddenField selfPlacementInfo">
                                                    <td class="style1" align="right"><strong>Job Offer Status:</strong></td>
                                                    <td class="style1">
                                                        <span class="readOnly selfPlacementReadOnly">#qGetAllPlacements.selfJobOfferStatus#</span>
                                                        <select name="selfJobOfferStatus_#qGetAllPlacements.candCompID#" id="selfJobOfferStatus_#qGetAllPlacements.candCompID#" class="style1 editPage mediumField"> 
                                                            <option value="" <cfif NOT LEN(qGetAllPlacements.selfJobOfferStatus)>selected</cfif> ></option>
                                                            <option value="Pending" <cfif qGetAllPlacements.selfJobOfferStatus EQ 'Pending'>selected</cfif> >Pending</option>
                                                            <option value="Confirmed" <cfif qGetAllPlacements.selfJobOfferStatus EQ 'Confirmed'>selected</cfif> >Confirmed</option>
                                                            <option value="Rejected" <cfif qGetAllPlacements.selfJobOfferStatus EQ 'Rejected'>selected</cfif> >Rejected</option>
                                                        </select>
                                                    </td>
                                                </tr>
                                                <tr class="hiddenField selfPlacementInfo">
                                                    <td class="style1" align="right"><strong>Name:</strong></td>
                                                    <td class="style1">
                                                        <span class="readOnly selfPlacementReadOnly">#qGetAllPlacements.selfConfirmationName#</span>
                                                        <input type="text" name="selfConfirmationName_#qGetAllPlacements.candCompID#" id="selfConfirmationName_#qGetAllPlacements.candCompID#" value="#qGetAllPlacements.selfConfirmationName#" class="style1 editPage xLargeField">
                                                    </td>
                                                </tr>
                                                <tr class="hiddenField selfPlacementInfo">
                                                    <td class="style1" align="right"><strong>Confirmation of Terms:</strong></td>
                                                    <td class="style1">
                                                    	<input type="hidden" id="confirmation_#qGetAllPlacements.candCompID#" name="confirmation_#qGetAllPlacements.candCompID#" <cfif qGetAllPlacements.confirmed EQ 1>value="1"<cfelse>value="0"</cfif> />
                                                        <input type="checkbox" onClick="changeValue('confirmation_#qGetAllPlacements.candCompID#')" class="formField" name="confirmationCheckbox_#qGetAllPlacements.candCompID#" id="confirmationCheckbox_#qGetAllPlacements.candCompID#" <cfif qGetAllPlacements.confirmed EQ 1>checked="checked"</cfif> />
                                                    </td>
                                                </tr>
                                                <tr class="hiddenField selfPlacementInfo">
                                                    <td class="style1" align="right"><strong>Available J1 Positions:</strong></td>
                                                    <td class="style1">
                                                        <span class="readOnly">#qGetAllPlacements.numberPositions#</span>
                                                        <select class="editPage" id="numberPositionsSelect_#qGetAllPlacements.candCompID#" name="numberPositionsSelect_#qGetAllPlacements.candCompID#">
                                                            <cfloop from="0" to="99" index="i">
                                                                <option value="#i#" <cfif qGetAllPlacements.numberPositions EQ i>selected</cfif>>#i#</option>
                                                            </cfloop>
                                                        </select>
                                                    </td>
                                                </tr>
                                                <tr class="hiddenField selfPlacementInfo">
                                                    <td class="style1" colspan="2">
                                                    	<!--- Secondary Authentications --->
                                                        <table width="100%" cellpadding="3" cellspacing="3" align="center" style="border:1px solid ##C7CFDC; background-color:##F7F7F7;">
                                                            <tr class="hiddenField selfPlacementInfo">
                                                                <td colspan="2">
                                                                    <strong><center>Authentication</center></strong>
                                                                </td>
                                                            </tr>
                                                            <tr class="hiddenField selfPlacementInfo">
                                                                <td class="style1" align="right" width="30%">
                                                                	<label for="authentication_secretaryOfState_#qGetAllPlacements.candCompID#"><strong>Secretary of State:</strong></label>
                                                                    <br />
                                                                    <i>Not Available:</i>
                                                                    <input
                                                                        id="authentication_businessLicenseNotAvailable_#qGetAllPlacements.candCompID#" 
                                                                        name="authentication_businessLicenseNotAvailable_#qGetAllPlacements.candCompID#" 
                                                                        class="formField" 
                                                                        disabled="disabled"
                                                                        type="checkbox"
                                                                        onclick="changeSecondaryAuthenticationAvailable('#qGetAllPlacements.candCompID#')"
                                                                        value="1"
                                                                        <cfif VAL(authentication_businessLicenseNotAvailable)>checked </cfif> />
                                                              	</td>
                                                                <td class="style1" width="70%">
                                                                    <input 
                                                                    	type="checkbox" 
                                                                        name="authentication_secretaryOfState_#qGetAllPlacements.candCompID#" 
                                                                        id="authentication_secretaryOfState_#qGetAllPlacements.candCompID#" 
                                                                        value="1" 
                                                                        class="formField" 
                                                                        disabled 
																		<cfif VAL(qGetAllPlacements.authentication_secretaryOfState)> checked </cfif> />
                                                                  	<span style="padding-left:3px;<cfif qGetAllPlacements.authentication_secretaryOfStateExpiration LT NOW()>color:red;</cfif>">
                                                                        #DateFormat(qGetAllPlacements.authentication_secretaryOfStateExpiration,'mm/dd/yyyy')#
                                                                    </span>
                                                                </td>
                                                            </tr>
                                                            <!--- Additional Secondary Authentications --->
                                                            <tr 
                                                            	class="additionalAuthentications_#qGetAllPlacements.candCompID#"
                                                                <cfif NOT VAL(qGetAllPlacements.authentication_businessLicenseNotAvailable)>style="display:none;"</cfif>>
                                                                <td class="style1" align="right">
                                                                	<label for="authentication_incorporation_#qGetAllPlacements.candCompID#"><strong>Incorporation:</strong></label>
                                                             	</td>
                                                                <td class="style1">
                                                                    <input 
                                                                    	type="checkbox" 
                                                                        name="authentication_incorporation_#qGetAllPlacements.candCompID#" 
                                                                        id="authentication_departmentOfLabor_#qGetAllPlacements.candCompID#" 
                                                                        value="1" 
                                                                        class="formField" 
                                                                        disabled <cfif VAL(qGetAllPlacements.authentication_incorporation)> checked </cfif> />
                                                                  	<span style="padding-left:3px;<cfif qGetAllPlacements.authentication_incorporationExpiration LT NOW()>color:red;</cfif>">
                                                                        #DateFormat(qGetAllPlacements.authentication_incorporationExpiration,'mm/dd/yyyy')#
                                                                    </span>
                                                                </td>
                                                            </tr>
                                                            <tr 
                                                            	class="additionalAuthentications_#qGetAllPlacements.candCompID#"
                                                                <cfif NOT VAL(qGetAllPlacements.authentication_businessLicenseNotAvailable)>style="display:none;"</cfif>>
                                                                <td class="style1" align="right">
                                                                	<label for="authentication_certificationOfExistence_#qGetAllPlacements.candCompID#"><strong>Certification of Existence:</strong></label>
                                                              	</td>
                                                                <td class="style1">
                                                                    <input 
                                                                    	type="checkbox" 
                                                                        name="authentication_certificateOfExistence_#qGetAllPlacements.candCompID#" 
                                                                        id="authentication_certificateOfExistence_#qGetAllPlacements.candCompID#" 
                                                                        value="1" 
                                                                        class="formField" 
                                                                        disabled 
																		<cfif VAL(qGetAllPlacements.authentication_certificateOfExistence)> checked </cfif> />
                                                                   	<span style="padding-left:3px;<cfif qGetAllPlacements.authentication_certificateOfExistenceExpiration LT NOW()>color:red;</cfif>">
                                                                        #DateFormat(qGetAllPlacements.authentication_certificateOfExistenceExpiration,'mm/dd/yyyy')#
                                                                    </span>
                                                                </td>
                                                            </tr>
                                                            <tr 
                                                            	class="additionalAuthentications_#qGetAllPlacements.candCompID#"
                                                                <cfif NOT VAL(qGetAllPlacements.authentication_businessLicenseNotAvailable)>style="display:none;"</cfif>>
                                                                <td class="style1" align="right">
                                                                	<label for="authentication_certificateOfReinstatement_#qGetAllPlacements.candCompID#"><strong>Certification of Reinstatement:</strong></label>
                                                              	</td>
                                                                <td class="style1">
                                                                    <input 
                                                                        type="checkbox" 
                                                                        name="authentication_certificateOfReinstatement_#qGetAllPlacements.candCompID#" 
                                                                        id="authentication_certificateOfReinstatement_#qGetAllPlacements.candCompID#" 
                                                                        value="1" 
                                                                        class="formField" 
                                                                        disabled 
																		<cfif VAL(qGetAllPlacements.authentication_certificateOfReinstatement)> checked </cfif> />
                                                                	<span style="padding-left:3px;<cfif qGetAllPlacements.authentication_certificateOfReinstatementExpiration LT NOW()>color:red;</cfif>">
                                                                        #DateFormat(qGetAllPlacements.authentication_certificateOfReinstatementExpiration,'mm/dd/yyyy')#
                                                                    </span>
                                                                </td>
                                                            </tr>
                                                            <tr 
                                                            	class="additionalAuthentications_#qGetAllPlacements.candCompID#"
                                                                <cfif NOT VAL(qGetAllPlacements.authentication_businessLicenseNotAvailable)>style="display:none;"</cfif>>
                                                                <td class="style1" align="right">
                                                                	<label for="authentication_departmentOfState_#qGetAllPlacements.candCompID#"><strong>Department of State:</strong></label>
                                                              	</td>
                                                                <td class="style1">
                                                                    <input 
                                                                    	type="checkbox" 
                                                                        name="authentication_departmentOfState_#qGetAllPlacements.candCompID#" 
                                                                        id="authentication_departmentOfState_#qGetAllPlacements.candCompID#" 
                                                                        value="1" 
                                                                        class="formField" 
                                                                        disabled 
																		<cfif VAL(qGetAllPlacements.authentication_departmentOfState)> checked </cfif> />
                                                                  	<span style="padding-left:3px;<cfif qGetAllPlacements.authentication_departmentOfStateExpiration LT NOW()>color:red;</cfif>">
                                                                        #DateFormat(qGetAllPlacements.authentication_departmentOfStateExpiration,'mm/dd/yyyy')#
                                                                    </span>
                                                                </td>
                                                            </tr>
                                                            <!--- End Additional Secondary Authentications --->
                                                            <tr class="hiddenField selfPlacementInfo">
                                                                <td class="style1" align="right"><label for="authentication_departmentOfLabor_#qGetAllPlacements.candCompID#"><strong>Department of Labor:</strong></label></td>
                                                                <td class="style1">
                                                                    <input 
                                                                    	type="checkbox" 
                                                                        name="authentication_departmentOfLabor_#qGetAllPlacements.candCompID#" 
                                                                        id="authentication_departmentOfLabor_#qGetAllPlacements.candCompID#" 
                                                                        value="1" 
                                                                        class="formField" 
                                                                        disabled 
																		<cfif VAL(qGetAllPlacements.authentication_departmentOfLabor)> checked </cfif> />
                                                                    <span style="padding-left:3px;<cfif qGetAllPlacements.authentication_departmentOfLaborExpiration LT NOW()>color:red;</cfif>">
                                                                        #DateFormat(qGetAllPlacements.authentication_departmentOfLaborExpiration,'mm/dd/yyyy')#
                                                                    </span>
                                                                </td>
                                                            </tr>
                                                            <tr class="hiddenField selfPlacementInfo">
                                                                <td class="style1" align="right"><label for="authentication_googleEarth_#qGetAllPlacements.candCompID#"><strong>Google Earth:</strong></label></td>
                                                                <td class="style1">
                                                                    <input 
                                                                    	type="checkbox" 
                                                                        name="authentication_googleEarth_#qGetAllPlacements.candCompID#" 
                                                                        id="authentication_googleEarth_#qGetAllPlacements.candCompID#" 
                                                                        value="1" class="formField" 
                                                                        disabled 
																		<cfif VAL(qGetAllPlacements.authentication_googleEarth)> checked </cfif> />
                                                                    <span style="padding-left:3px;<cfif qGetAllPlacements.authentication_googleEarthExpiration LT NOW()>color:red;</cfif>">
                                                                        #DateFormat(qGetAllPlacements.authentication_googleEarthExpiration,'mm/dd/yyyy')#
                                                                    </span>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                        <!--- End Secondary Authentications --->
                                                    </td>
                                                </tr>
                                                <tr class="hiddenField selfPlacementInfo">
                                                    <td class="style1" align="right"><strong>EIN:</strong></td>
                                                    <td class="style1">
                                                        <span class="readOnly selfPlacementReadOnly">#qGetAllPlacements.EIN#</span>
                                                        <input type="text" name="EIN_#qGetAllPlacements.candCompID#" id="EIN_#qGetAllPlacements.candCompID#" value="#qGetAllPlacements.EIN#" class="style1 editPage mediumField">
                                                    </td>
                                                </tr>
                                                <tr class="hiddenField selfPlacementInfo">
                                                    <td class="style1" align="right"><strong>Workmen's Compensation:</strong></td>
                                                    <td class="style1">
                                                        <span class="readOnly selfPlacementReadOnly">
                                                            <cfif qGetAllPlacements.workmensCompensation EQ 0>
                                                                No
                                                            <cfelseif qGetAllPlacements.workmensCompensation EQ 1>
                                                                Yes
                                                            <cfelseif qGetAllPlacements.workmensCompensation EQ 2>
                                                                N/A
                                                            </cfif>
                                                        </span>
                                                        <select name="workmensCompensation_#qGetAllPlacements.candCompID#" id="workmensCompensation_#qGetAllPlacements.candCompID#" class="style1 editPage smallField"> 
                                                            <option value="" <cfif NOT LEN(qGetAllPlacements.workmensCompensation)>selected</cfif> ></option>
                                                            <option value="0" <cfif qGetAllPlacements.workmensCompensation EQ 0>selected</cfif> >No</option>
                                                            <option value="1" <cfif qGetAllPlacements.workmensCompensation EQ 1>selected</cfif> >Yes</option>                                                    
                                                            <option value="2" <cfif qGetAllPlacements.workmensCompensation EQ 2>selected</cfif> >N/A</option>
                                                        </select>
                                                    </td>
                                                </tr>
                                                <cfif ListFind("1,2,3,4", CLIENT.userType)>
                                                    <tr class="hiddenField selfPlacementInfo">
                                                        <td class="style1" align="right"><strong>Carrier Name:</strong></td>
                                                        <td class="style1">
                                                            <span class="readOnly selfPlacementReadOnly">
                                                                #qGetAllPlacements.WC_carrierName#
                                                            </span>
                                                            <input 
                                                                type="text" 
                                                                name="WC_carrierName_#qGetAllPlacements.candCompID#" 
                                                                id="WC_carrierName_#qGetAllPlacements.candCompID#" 
                                                                value="#qGetAllPlacements.WC_carrierName#" 
                                                                class="style1 editPage"
                                                                size="40" />
                                                        </td>
                                                    </tr>
                                                    <tr class="hiddenField selfPlacementInfo">
                                                        <td class="style1" align="right"><strong>Carrier Phone:</strong></td>
                                                        <td class="style1">
                                                            <span class="readOnly selfPlacementReadOnly">
                                                                #qGetAllPlacements.WC_carrierPhone#
                                                            </span>
                                                            <input 
                                                                type="text" 
                                                                name="WC_carrierPhone_#qGetAllPlacements.candCompID#" 
                                                                id="WC_carrierPhone_#qGetAllPlacements.candCompID#" 
                                                                value="#qGetAllPlacements.WC_carrierPhone#" 
                                                                class="style1 editPage"
                                                                size="40" />
                                                        </td>
                                                    </tr>
                                                    <tr class="hiddenField selfPlacementInfo">
                                                        <td class="style1" align="right"><strong>Policy Number:</strong></td>
                                                        <td class="style1">
                                                            <span class="readOnly selfPlacementReadOnly">
                                                                #qGetAllPlacements.WC_policyNumber#
                                                            </span>
                                                            <input 
                                                                type="text" 
                                                                name="WC_policyNumber_#qGetAllPlacements.candCompID#" 
                                                                id="WC_policyNumber_#qGetAllPlacements.candCompID#" 
                                                                value="#qGetAllPlacements.WC_policyNumber#" 
                                                                class="style1 editPage"
                                                                size="40" />
                                                        </td>
                                                    </tr>
                                               	</cfif>
                                                <tr>
                                                    <td class="style1" align="right"><strong>WC Expiration Date:</strong></td>
                                                    <td class="style1" bordercolor="##FFFFFF">
                                                        <span class="readOnly selfPlacementReadOnly">
                                                            <cfif IsDate(qGetAllPlacements.WCDateExpired) AND qGetAllPlacements.WCDateExpired GT NOW()>
                                                                #DateFormat(qGetAllPlacements.WCDateExpired, 'mm/dd/yyyy')#
                                                            <cfelseif IsDate(qGetAllPlacements.WCDateExpired)>
                                                                <font color="red">Expired</font>
                                                            <cfelse>
                                                                Workmen's compensation is missing.
                                                            </cfif>
                                                        </span>
                                                            <input type="text" name="WCDateExpired_#qGetAllPlacements.candCompID#" id="WCDateExpired_#qGetAllPlacements.candCompID#" value="#DateFormat(qGetAllPlacements.WCDateExpired, 'mm/dd/yyyy')#" class="style1 datePicker editPage" maxlength="10">
                                                    </td>
                                                </tr>
                                                <tr class="hiddenField selfPlacementInfo">
                                                    <td class="style1" align="right"><strong>Phone Confirmation:</strong></td>
                                                    <td class="style1" colspan="3">
                                                        <span class="readOnly selfPlacementReadOnly">#DateFormat(qGetAllPlacements.confirmation_phone, 'mm/dd/yyyy')#</span>
                                                        <input type="text" name="confirmation_phone_#qGetAllPlacements.candCompID#" id="confirmation_phone_#qGetAllPlacements.candCompID#" class="style1 datePicker editPage" value="#DateFormat(qGetAllPlacements.confirmation_phone, 'mm/dd/yyyy')#" maxlength="10">
                                                        <cfif NOT LEN(qGetAllPlacements.confirmation_phone)><font size="1">(mm/dd/yyyy)</font></cfif>
                                                    </td>
                                                </tr>
                                                <tr class="hiddenField selfPlacementInfo">
                                           			<td class="style1" align="right"><strong>Notes:</strong></td>
                                                    <td class="style1" colspan="3">
                                                        <span class="readOnly selfPlacementReadOnly">#qGetAllPlacements.selfConfirmationNotes#</span>
                                                        <textarea name="selfConfirmationNotes_#qGetAllPlacements.candCompID#" id="selfConfirmationNotes_#qGetAllPlacements.candCompID#" class="style1 editPage largeTextArea">#qGetAllPlacements.selfConfirmationNotes#</textarea>
                                                    </td>
                                                </tr>
                                          	</table>
                                        </td>
                                    </tr>
                               	</table>
                                
                                <br />
                            
                            </cfif>
                            
                        </cfloop>
                        
                        <!--- DS2019 Form --->
                        <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
                                <td bordercolor="##FFFFFF">
                        
                                    <table width="100%" cellpadding=3 cellspacing="0" border="0">
                                    	<tr bgcolor="##C2D1EF">
                                    		<td colspan="2" class="style2" bgcolor="##8FB6C9">&nbsp;:: Form DS-2019</td>
                                    	</tr>	
                                        <tr>
                                            <td class="style1" width="30%" align="right"><strong>Sponsor:</strong></td>
                                            <td class="style1" width="70%">
                                                <cfif LEN(qGetProgramInfo.extra_sponsor)>
                                                    #qGetProgramInfo.extra_sponsor#
                                                <cfelse>
                                                    n/a
                                                </cfif>	
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong>Verification Report:</strong></td>
                                            <td class="style1">
                                            	<span class="readOnly"><cfif LEN(qGetCandidate.verification_received)> Received on #dateFormat(qGetCandidate.verification_received, 'mm/dd/yyyy')# <cfelse>N/A</cfif> </span>
                                                <input type="text" name="verification_received" id="verification_received" class="datePicker style1 editPage" value="#dateFormat(qGetCandidate.verification_received, 'mm/dd/yyyy')#" maxlength="10">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong>Number:</strong></td>
                                            <td class="style1">
                                            	<span class="readOnly">#qGetCandidate.ds2019#</span>
                                                <input type="text" name="ds2019" class="style1 editPage mediumField" value="#qGetCandidate.ds2019#" maxlength="20">
                                            </td>
                                        </tr>
                                        <tr>	
                                        	<td class="style1" align="right"><strong>Accepts SEVIS Fee:</strong></td>
                                            <td class="style1">#YesNoFormat(VAL(qGetIntlRepInfo.extra_accepts_sevis_fee))#</td>
                                        </tr>
                                        <tr>
                                        	<td class="style1" align="right"><strong>Visa Interview:</strong></td>
                                            <td class="style1">
                                            	<span class="readOnly">#DateFormat(qGetCandidate.visaInterview,'mm/dd/yyyy')#</span>
                                                <input type="text" name="visaInterview" class="editPage datePicker" value="#DateFormat(qGetCandidate.visaInterview,'mm/dd/yyyy')#">
                                            </td>
                                        </tr>
                                        <tr>
                                        	<td class="style1" align="right"><strong>Generic Arrival Package Sent:</strong></td>
                                            <td class="style1">
                                            	<span class="readOnly">#DateFormat(qGetCandidate.dateGenericDocumentsSent,'mm/dd/yyyy')#</span>
                                                <input type="text" name="dateGenericDocumentsSent" class="editPage datePicker" value="#DateFormat(qGetCandidate.dateGenericDocumentsSent,'mm/dd/yyyy')#">
                                            </td>
                                        </tr>
                                        <tr>
                                        	<td class="style1" align="right"><strong>Generic Arrival Package Resent:</strong></td>
                                            <td class="style1">
                                            	<span class="readOnly">#DateFormat(qGetCandidate.dateIDSent,'mm/dd/yyyy')#</span>
                                                <input type="text" name="dateIDSent" class="editPage datePicker" value="#DateFormat(qGetCandidate.dateIDSent,'mm/dd/yyyy')#">
                                            </td>
                                        </tr>
                                    </table>
                        
                                </td>
                            </tr>
                        </table> 

						<br />

						<!---- Flight Information --->
                        <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
                                <td bordercolor="##FFFFFF">
                        
                                    <table width="100%" cellpadding=3 cellspacing="0" border="0">
                                        <tr bgcolor="##C2D1EF">
                                        	<td colspan="4" class="style2" bgcolor="##8FB6C9">
                                            	&nbsp;:: Flight Information
                                                <span style="float:right; padding-right:20px;">
                                                	<a href="onlineApplication/index.cfm?action=flightInfo&uniqueID=#qGetCandidate.uniqueID#&completeApplication=0" class="style2 popUpFlightInformation">[ Add/Edit ]</a>
                                                </span>
                                            </td>
                                        </tr>	
                                        <tr>
                                        	<td class="style1" width="15%" align="right"><label for="verification_address"><strong>Arrival:</strong></label></td>
                                            <td class="style1" width="85%">
												<cfif qGetArrival.recordCount>
	                                                <cfloop query="qGetArrival">
                                                        Arrive on 
                                                        <cfif qGetArrival.isOvernightFlight EQ 1>
                                                            #DateFormat(DateAdd("d", 1, qGetArrival.departDate), 'mm/dd/yyyy')# 
                                                        <cfelse>
                                                            #qGetArrival.departDate#
                                                        </cfif>
                                                            at #qGetArrival.arriveTime#
                                                        - Airport: #qGetArrival.arriveAirportCode# 
                                                        - Flight Number: #qGetArrival.flightNumber# 
                                                        <br />
													</cfloop>                                                        
                                                <cfelse>
                                                	n/a
                                                </cfif>
                                            </td>
                                        </tr>
                                        <tr>
                                        	<td class="style1" align="right"><label for="verification_sevis"><strong>Departure:</strong></label></td>
                                        	<td class="style1">
												<cfif qGetDeparture.recordCount>
                                                    <cfloop query="qGetDeparture">
                                                        Depart on #qGetDeparture.departDate# at #qGetDeparture.departTime#
                                                        - Airport: #qGetDeparture.departAirportCode# 
                                                        - Flight Number: #qGetDeparture.flightNumber# 
                                                        <br />
                                                    </cfloop>    
                                                <cfelse>
                                                	n/a
                                                </cfif>
                                        	</td>
                                        </tr>
                        			</table>
                                    
                                </td>
                            </tr>
                        </table> 

						<br />

						<!---- Arrival Verification --->
                        <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
                                <td bordercolor="##FFFFFF">
                        
                                    <table width="100%" cellpadding=3 cellspacing="0" border="0">
                                        <tr bgcolor="##C2D1EF">
                                        	<td colspan="4" class="style2" bgcolor="##8FB6C9">
                                            	&nbsp;:: Arrival Verification
                                            	<!--- Office View Only --->  
                                            	<cfif ListFind("1,2,3,4", CLIENT.userType)>    
                                                	<span style="float:right; padding-right:20px;">
                                                    	<a href="javascript:openWindow('candidate/arrival_history.cfm?uniqueID=#URL.uniqueid#', 400, 600);" class="style2">[ History ]</a>
                                                    </span>
                                            	</cfif>
                                         	</td>
                                        </tr>
                                        <tr>
                                        	<td class="style1" width="30%" align="right"><label for="watDateCheckedIn"><strong>Check-in/Validation Date:</strong></label></td>
                                        	<td class="style1" width="70%">
                                                <span class="readOnly">#dateFormat(qGetCandidate.watDateCheckedIn, 'mm/dd/yyyy')#</span>
                                                <input type="text" name="watDateCheckedIn" id="watDateCheckedIn" class="datePicker style1 editPage" value="#dateFormat(qGetCandidate.watDateCheckedIn, 'mm/dd/yyyy')#" maxlength="10">
                                        		<cfif NOT LEN(qGetCandidate.watDateCheckedIn)><font size="1">(mm/dd/yyyy)</font></cfif>
                                                <cfif ListFind("1,2,3,4",CLIENT.userType)>
                                                	<font size="1" style="float:right">
                                                    	<a href="candidate/evaluation_answers.cfm?uniqueID=#URL.uniqueid#&evaluationID=0" class="style1 jQueryModal" <cfif NOT VAL(qGetCheckIn.recordCount)>style="color:gray;"</cfif>>[ Answers ]</a>
                                                    	<a href="candidate/evaluation_tracking.cfm?uniqueID=#URL.uniqueid#&id=0" class="style1 jQueryModal">[ Tracking ]</a>
                                                    </font>
                                                </cfif>
                                            </td>
                                        </tr>
                                        <tr>
                                        	<td class="style1" width="30%" align="right"><label for="usPhone"><strong>U.S. Phone:</strong></label></td>
                                        	<td class="style1" width="70%">
                                            	<span class="readOnly">#qGetCandidate.us_phone#</span>
                                                <input type="text" name="usPhone" id="usPhone" class="style1 editPage" value="#qGetCandidate.us_phone#">
                                            </td>
                                        </tr>
                                        <tr>
                                        	<td class="style1" width="30%" align="right"><label for="usPhone"><strong>Address:</strong></label></td>
                                        	<td class="style1" width="70%">
                                            	<span class="readOnly">#qGetCandidate.arrival_address#</span>
                                                <input type="text" name="arrival_address" id="arrival_address" class="style1 editPage" value="#qGetCandidate.arrival_address#">
                                            </td>
                                        </tr>
                                          <tr>
                                        	<td class="style1" width="30%" align="right">&nbsp;</td>
                                        	<td class="style1" width="70%">
                                            	<span class="readOnly">#qGetCandidate.arrival_address_2#</span>
                                                <input type="text" name="arrival_address_2" id="arrival_address_2" class="style1 editPage" value="#qGetCandidate.arrival_address_2#">
                                            </td>
                                        </tr>
                                        <tr>
                                        	<td class="style1" width="30%" align="right"><label for="usPhone"><strong>City:</strong></label></td>
                                        	<td class="style1" width="70%">
                                            	<span class="readOnly">#qGetCandidate.arrival_city#</span>
                                                <input type="text" name="arrival_city" id="arrival_city" class="style1 editPage" value="#qGetCandidate.arrival_city#">
                                            </td>
                                        </tr>
                                        <tr>
                                        	<td class="style1" width="30%" align="right"><label for="usPhone"><strong>State:</strong></label></td>
                                        	<td class="style1" width="70%">
                                            	<span class="readOnly">
                                                	<cfloop query="qGetStateList">
                                                    	<cfif id EQ qGetCandidate.arrival_state>
                                                        	#state#
                                                        </cfif>
                                                   	</cfloop>
                                             	</span>
                                                <select name="arrival_state" id="arrival_state" class="style1 editPage">
                                                	<option value="0"></option>
                                                	<cfloop query="qGetStateList">
                                                    	<option value="#id#" <cfif id EQ qGetCandidate.arrival_state>selected="selected"</cfif>>#state#</option>
                                                    </cfloop>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                        	<td class="style1" width="30%" align="right"><label for="usPhone"><strong>Zip:</strong></label></td>
                                        	<td class="style1" width="70%">
                                            	<span class="readOnly">#qGetCandidate.arrival_zip#</span>
                                                <input type="text" name="arrival_zip" id="arrival_zip" class="style1 editPage" value="#qGetCandidate.arrival_zip#" size="5" maxlength="5">
                                            </td>
                                        </tr>
                        			</table>
                                    
                                </td>
                            </tr>
                        </table> 

						<br />
 
 						<!---- Monthly Evaluations --->
                        <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
                                <td bordercolor="##FFFFFF">
                        
                                    <table width="100%" cellpadding=3 cellspacing="0" border="0">
                                        <tr bgcolor="##C2D1EF">
                                        	<td colspan="4" class="style2" bgcolor="##8FB6C9">&nbsp;:: Monthly Evaluations</td>
                                        </tr>	
                                        <tr>
                                        	<td class="style1" width="30%" align="right"><label for="watDateCheckedIn"><strong>Evaluation 1 Date:</strong></label></td>
                                        	<td class="style1" width="70%">
                                                <span class="readOnly">#dateFormat(qGetCandidate.watDateEvaluation1, 'mm/dd/yyyy')#</span>
                                                <input type="text" name="watDateEvaluation1" id="watDateEvaluation1" class="datePicker style1 editPage" value="#dateFormat(qGetCandidate.watDateEvaluation1, 'mm/dd/yyyy')#" maxlength="10">
                                        		<cfif NOT LEN(qGetcandidate.watDateEvaluation1) AND ListFind("1,2,3,4",CLIENT.userType)>
                                                	<font size="1">
                                                    	<a href="../wat/candidate/sendEvaluation.cfm?candidateID=#qGetCandidate.candidateID#&EvaluationID=1">
                                                        	[ Send Evaluation ]
                                                       	</a>
                                                  	</font>
												</cfif>
                                                
                                                <cfif ListFind("1,2,3,4",CLIENT.userType)>
                                                	<font size="1" style="float:right">
                                                    	<a href="candidate/evaluation_answers.cfm?uniqueID=#URL.uniqueid#&evaluationID=1" class="style1 jQueryModal" <cfif NOT VAL(qGetEvaluation1.recordCount)>style="color:gray;"</cfif>>[ Answers ]</a>
                                                    	<a href="candidate/evaluation_tracking.cfm?uniqueID=#URL.uniqueid#&id=1" class="style1 jQueryModal">[ Tracking ]</a>
                                                    </font>
                                                </cfif>
                                            </td>
                                        </tr>
                                        <tr>
                                        	<td class="style1" align="right"><label for="watDateCheckedIn"><strong>Evaluation 2 Date:</strong></label></td>
                                        	<td class="style1">
                                                <span class="readOnly">#dateFormat(qGetCandidate.watDateEvaluation2, 'mm/dd/yyyy')#</span>
                                                <input type="text" name="watDateEvaluation2" id="watDateEvaluation2" class="datePicker style1 editPage" value="#dateFormat(qGetCandidate.watDateEvaluation2, 'mm/dd/yyyy')#" maxlength="10">
                                        		<cfif NOT LEN(qGetcandidate.watDateEvaluation2) AND ListFind("1,2,3,4",CLIENT.userType)>
                                                	<font size="1">
                                                    	<a href="../wat/candidate/sendEvaluation.cfm?candidateID=#qGetCandidate.candidateID#&EvaluationID=2">
                                                        	[ Send Evaluation ]
                                                       	</a>
                                                  	</font>
												</cfif>
                                                
                                                <cfif ListFind("1,2,3,4",CLIENT.userType)>
                                                	<font size="1" style="float:right">
                                                    	<a href="candidate/evaluation_answers.cfm?uniqueID=#URL.uniqueid#&evaluationID=2" class="style1 jQueryModal" <cfif NOT VAL(qGetEvaluation2.recordCount)>style="color:gray;"</cfif>>[ Answers ]</a>
                                                    	<a href="candidate/evaluation_tracking.cfm?uniqueID=#URL.uniqueid#&id=2" class="style1 jQueryModal">[ Tracking ]</a>
                                                    </font>
                                                </cfif>
                                            </td>
                                        </tr>
                                        <tr>
                                        	<td class="style1" width="30%" align="right"><label for="watDateCheckedIn"><strong>Evaluation 3 Date:</strong></label></td>
                                        	<td class="style1" width="70%">
                                                <span class="readOnly">#dateFormat(qGetCandidate.watDateEvaluation3, 'mm/dd/yyyy')#</span>
                                                <input type="text" name="watDateEvaluation3" id="watDateEvaluation3" class="datePicker style1 editPage" value="#dateFormat(qGetCandidate.watDateEvaluation3, 'mm/dd/yyyy')#" maxlength="10">
                                        		<cfif NOT LEN(qGetcandidate.watDateEvaluation3) AND ListFind("1,2,3,4",CLIENT.userType)>
                                                	<font size="1">
                                                    	<a href="../wat/candidate/sendEvaluation.cfm?candidateID=#qGetCandidate.candidateID#&EvaluationID=3">
                                                        	[ Send Evaluation ]
                                                       	</a>
                                                  	</font>
												</cfif>
                                                
                                                <cfif ListFind("1,2,3,4",CLIENT.userType)>
                                                	<font size="1" style="float:right">
                                                    	<a href="candidate/evaluation_answers.cfm?uniqueID=#URL.uniqueid#&evaluationID=3" class="style1 jQueryModal" <cfif NOT VAL(qGetEvaluation3.recordCount)>style="color:gray;"</cfif>>[ Answers ]</a>
                                                    	<a href="candidate/evaluation_tracking.cfm?uniqueID=#URL.uniqueid#&id=3" class="style1 jQueryModal">[ Tracking ]</a>
                                                    </font>
                                                </cfif>
                                            </td>
                                        </tr>
                                        <tr>
                                        	<td class="style1" width="30%" align="right"><label for="watDateCheckedIn"><strong>Evaluation 4 Date:</strong></label></td>
                                        	<td class="style1" width="70%">
                                                <span class="readOnly">#dateFormat(qGetCandidate.watDateEvaluation4, 'mm/dd/yyyy')#</span>
                                                <input type="text" name="watDateEvaluation4" id="watDateEvaluation4" class="datePicker style1 editPage" value="#dateFormat(qGetCandidate.watDateEvaluation4, 'mm/dd/yyyy')#" maxlength="10">
                                        		<cfif NOT LEN(qGetcandidate.watDateEvaluation4) AND ListFind("1,2,3,4",CLIENT.userType)>
                                                	<font size="1">
                                                    	<a href="../wat/candidate/sendEvaluation.cfm?candidateID=#qGetCandidate.candidateID#&EvaluationID=4">
                                                        	[ Send Evaluation ]
                                                       	</a>
                                                  	</font>
												</cfif>
                                                
                                                <cfif ListFind("1,2,3,4",CLIENT.userType)>
                                                	<font size="1" style="float:right">
                                                    	<a href="candidate/evaluation_answers.cfm?uniqueID=#URL.uniqueid#&evaluationID=4" class="style1 jQueryModal" <cfif NOT VAL(qGetEvaluation4.recordCount)>style="color:gray;"</cfif>>[ Answers ]</a>
                                                    	<a href="candidate/evaluation_tracking.cfm?uniqueID=#URL.uniqueid#&id=4" class="style1 jQueryModal">[ Tracking ]</a>
                                                    </font>
                                                </cfif>
                                            </td>
                                        </tr>
                        			</table>
                                    
                                </td>
                            </tr>
                        </table> 

						<br />
 						
                        <!--- Office View Only --->
                        <cfif ListFind("1,2,3,4", CLIENT.userType)>
                        
							<!---- Incident Report --->
                            <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                                <tr>
                                    <td bordercolor="##FFFFFF">
                            
                                        <table width="100%" cellpadding=3 cellspacing="0" border="0">
                                            <tr bgcolor="##C2D1EF">
                                                <td colspan="4" class="style2" bgcolor="##8FB6C9">
                                                    &nbsp;:: Incident Report
                                                    <span style="float:right; padding-right:20px;">
                                                        <a href="candidate/incidentReport.cfm?uniqueID=#qGetCandidate.uniqueID#" class="style2 jQueryModal">[ New Incident ]</a>
                                                    </span>
                                                </td>
                                            </tr>	
                                            <tr>
                                                <td class="style1"><strong>Date</strong></td>
                                                <td class="style1"><strong>Nature of Complaint</strong></td>
                                                <td class="style1"><strong>Host Company</strong></td>
                                                <td class="style1"><strong>Solved</strong></td>
                                            </tr>
                                            
                                            <cfloop query="qGetIncidentReport">
                                                <tr <cfif qGetIncidentReport.currentRow mod 2>bgcolor="##E4E4E4"</cfif>>     
                                                    <td class="style1">
                                                        <a href="candidate/incidentReport.cfm?uniqueID=#qGetCandidate.uniqueID#&incidentID=#qGetIncidentReport.ID#" class="style4 jQueryModal">
                                                            #DateFormat(qGetIncidentReport.dateIncident, 'mm/dd/yy')#
                                                        </a>
                                                    </td>
                                                    <td class="style1">
                                                        <a href="candidate/incidentReport.cfm?uniqueID=#qGetCandidate.uniqueID#&incidentID=#qGetIncidentReport.ID#" class="style4 jQueryModal">
                                                            #qGetIncidentReport.subject#
                                                        </a>
                                                    </td>
                                                    <td class="style1">#qGetIncidentReport.hostCompanyName#</td>
                                                    <td class="style1">#YesNoFormat(VAL(qGetIncidentReport.isSolved))#</td>
                                                </tr>
                                            </cfloop>
                                            
                                            <cfif NOT VAL(qGetIncidentReport.recordCount)>
                                                <tr bgcolor="##E4E4E4">
                                                    <td colspan="4" class="style1" align="center">There are no incidents recorded</td>                                                
                                                </tr>
                                            </cfif> 
                                                                                           
                                        </table>
                                        
                                    </td>
                                </tr>
                            </table> 
    
                            <br />
                            
							<!---- Cultural Activity Report --->
                            <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                                <tr>
                                    <td bordercolor="##FFFFFF">
                            
                                        <table width="100%" cellpadding=3 cellspacing="0" border="0">
                                            <tr bgcolor="##C2D1EF">
                                                <td colspan="2" class="style2" bgcolor="##8FB6C9">
                                                    &nbsp;:: Cultural Activity
                                                    <span style="float:right; padding-right:20px;">
                                                        <a href="candidate/culturalActivityReport.cfm?uniqueID=#qGetCandidate.uniqueID#" class="style2 jQueryModal">[ New Activity ]</a>
                                                    </span>
                                                </td>
                                            </tr>	
                                            <tr>
                                                <td class="style1"><strong>Date</strong></td>
                                                <td class="style1"><strong>Details</strong></td>
                                            </tr>
                                            
                                            <cfif VAL(qGetCulturalActivityReport.recordCount)>
                                                <cfloop query="qGetCulturalActivityReport">
                                                    <tr <cfif qGetCulturalActivityReport.currentRow mod 2>bgcolor="##E4E4E4"</cfif>>     
                                                        <td class="style1">
                                                            <a href="candidate/culturalActivityReport.cfm?uniqueID=#qGetCandidate.uniqueID#&activityID=#qGetCulturalActivityReport.ID#" class="style4 jQueryModal">
                                                                #DateFormat(qGetCulturalActivityReport.dateActivity, 'mm/dd/yy')#
                                                            </a>
                                                        </td>
                                                        <td class="style1">
                                                            <a href="candidate/culturalActivityReport.cfm?uniqueID=#qGetCandidate.uniqueID#&activityID=#qGetCulturalActivityReport.ID#" class="style4 jQueryModal">
                                                                #qGetCulturalActivityReport.details#
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </cfloop>
                                            <cfelse>
                                                <tr bgcolor="##E4E4E4">
                                                    <td colspan="4" class="style1" align="center">There are no activities recorded</td>                                                
                                                </tr>
                                            </cfif>
                                                                                           
                                        </table>
                                        
                                    </td>
                                </tr>
                            </table> 
    
                            <br />
                        
                        </cfif>
                        
                    </td>
                    <!--- END OF RIGHT SECTION --->
                </tr>
        	</table>
        
            <!--- END OF INFORMATION SECTION ---> 
            
            <br/>

			<!---- EDIT/UPDATE BUTTONS | Office View Only ---->            
            <cfif ListFind("1,2,3,4", CLIENT.userType)>
                
                <table width="80%" border="0" cellpadding="0" cellspacing="0" align="center">	
                    <tr>
                        <td align="center">
                            
                            <!---- EDIT BUTTON ---->
                            <div class="readOnly">                            
                                <img src="../pics/edit.gif" onClick="readOnlyEditPage();">
                            </div>
                            
                            <!---- UPDATE BUTTON ----> 
                            <div class="editPage">                            
                                <input name="Submit" type="image" src="../pics/update.gif" alt="Update Profile" border="0">
                            </div>
                            
                        </td>
                    </tr>
                </table>
                
                <br>
            </cfif>

		</td>		
	</tr>
</table>
<!--- END OF TABLE HOLDER --->

</cfform>

</cfoutput>