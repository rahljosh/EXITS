<!--- ------------------------------------------------------------------------- ----
	
	File:		candidate_info.cfm
	Author:		Marcus Melo
	Date:		June 01, 2010
	Desc:		Candidate Information Screen.

	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <!--- Param variables --->
    <cfparam name="URL.uniqueID" default="">
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.candidateID" default="0">

    <cfscript>
		// Get Candidate Information
		qGetCandidate = APPLICATION.CFC.CANDIDATE.getCandidateByID(uniqueID=URL.uniqueID);
		
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
		
		/*** Online Application ***/

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
	</cfscript>
		
    <cfinclude template="../querys/fieldstudy.cfm">
    <cfinclude template="../querys/program.cfm">
	
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
    <cfquery name="qGetIntlRepInfo" datasource="MySQL">
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
    
    <cfquery name="qCandidatePlaceCompany" datasource="MySQL">
        SELECT 
        	<!--- Host Company Specific --->
            eh.hostCompanyID,
            eh.name,            
            eh.authenticationType,
            eh.EIN,
            eh.workmensCompensation,
            <!--- Candidate Place Company --->
            ecpc.status,
            ecpc.placement_date,
            ecpc.startDate,
            ecpc.endDate,
            ecpc.selfJobOfferStatus,
            ecpc.selfConfirmationName,
            ecpc.selfConfirmationMethod,
            ecpc.selfJobOfferStatus,
            ecpc.selfConfirmationDate,
            ecpc.selfFindJobOffer,
            ecpc.selfConfirmationNotes,
            ecpc.reason_host,
            ecpc.isTransfer,
            ecpc.isTransferHousingAddressReceived,
            ecpc.isTransferJobOfferReceived,
            ecpc.isTransferSevisUpdated,
            ecpc.dateTransferConfirmed
        FROM
        	extra_candidate_place_company ecpc
        INNER JOIN
        	extra_hostcompany eh ON eh.hostCompanyID = ecpc.hostCompanyID
        WHERE 
        	ecpc.candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidate.candidateID#">
        AND 	
        	ecpc.status = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
    </cfquery>
    
    <cfquery name="qHostCompanyList" datasource="MySQL">
        SELECT 
        	hostcompanyID,
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
        	hostcompanyID,
            name 
        FROM 
        	qHostCompanyList
        WHERE 
            hostcompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCandidate.requested_placement)#">
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
			
			// Reset Transfer Data
			
		} else {
			// Hide Transfer Information
			$(".trTransferInfo").fadeOut("fast");
		}	
		
		// Display/Hide Self Placemet Info
		displaySelfPlacementInfo();
	}


	var displaySelfPlacementInfo = function() { 
		// Get Placement Info
		getHostID = $("#hostcompanyID").val();
		// Get Program Option
		getProgramOption = $("#wat_placement").val();
		// Get Transfer Info - Do not display self placement if it's a transfer
		getTransferValue = $("#isTransfer").val();
		
		if ( getHostID > 0 && getProgramOption == 'Self-Placement' && getTransferValue == 0) {
			$(".selfPlacementInfo").fadeIn("fast");
		} else {
			// Erase self placement data
			$(".selfPlacementField").val("");
			$(".selfPlacementInfo").fadeOut("fast");
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
			$("#divCancelation").fadeOut("fast");
		}
	}
	
	
	var displayProgramReason = function(currentProgramID, selectedProgramID) { 
		if ( currentProgramID > '0' && currentProgramID != selectedProgramID && $("#program_history").css("display") == "none" ) {
			$("#program_history").fadeIn("fast");
			$("#reason").focus();
		} else if (currentProgramID == selectedProgramID) {
			$("#program_history").fadeOut("fast");
		}
	}


	var displayHostReason = function(currentHostPlaceID, selectedHostID) {
		if ( currentHostPlaceID > '0' && currentHostPlaceID != selectedHostID && $(".trReasonInfo").css("display") == "none" ) {
			$(".trReasonInfo").fadeIn("fast");
			$("#host_startdate").val("");
			$("#host_enddate").val("");
			$("#reason_host").focus();
			// Erase self placement data
			$(".selfPlacementField").val("");
		} else if (currentHostPlaceID == selectedHostID) {
			$(".trReasonInfo").fadeOut("fast");
		}
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
//-->
</script> 

<!--- candidate does not exist --->
<cfif NOT VAL(qGetCandidate.recordcount)>
	The candidate ID you are looking for was not found. This could be for a number of reasons.<br /><br />
	<ul>
		<li>the candidate record was deleted or renumbered
		<li>the link you are following is out of date
		<li>you do not have proper access lefts to view the candidate
	</ul>
	If you feel this is incorrect, please contact <a href="mailto:support@student-management.com">Support</a>
	<cfabort>
</cfif>

<cfoutput>

<cfform name="CandidateInfo" method="post" action="?curdoc=candidate/qr_edit_candidate&uniqueid=#qGetCandidate.uniqueid#" onsubmit="return checkHistory();">
<input type="hidden" name="candidateID" value="#qGetCandidate.candidateID#">
<input type="hidden" name="submitted" value="1">


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
            <table width="1000px" border="1" align="center" cellpadding="8" cellspacing="8" bordercolor="##C7CFDC" bgcolor="##ffffff">	
                <tr>
                    <td valign="top">
                    
                    	<!--- CANDIDATE PHOTO --->
                        <table width="135px" align="left" cellpadding="2">
                            <tr>
                                <td valign="top">
                                    <cfif FileExists(expandPath("../uploadedfiles/web-candidates/#qGetCandidate.candidateID#.jpg"))>
                                        <img src="../uploadedfiles/web-candidates/#qGetCandidate.candidateID#.jpg" width="135">
                                    <cfelse>
                                        <img src="../pics/no_stupicture.jpg" width="137" height="137">
                                    </cfif>
                                </td>
                            </tr>
						</table>
    
                        <!--- CANDIDATE INFO - READ ONLY --->
                        <table width="600px" align="right" cellpadding="2" class="readOnly">
                            <tr>
                                <td align="center" colspan="2" class="title1">#qGetCandidate.firstname# #qGetCandidate.middlename# #qGetCandidate.lastname# (###qGetCandidate.candidateID#)</td>
                            </tr>
                            <tr>
                                <td align="center" colspan="2">
                                    <cfif VAL(qGetCandidate.applicationStatusID)>
                                    	<a href="onlineApplication/index.cfm?action=initial&uniqueID=#qGetCandidate.uniqueID#" class="style4 popUpOnlineApplication">[ Online Application ]</a> &nbsp;
                                    </cfif>
                                    <cfif ListFind("1,2,3,4", CLIENT.userType)>
                                        <a href="candidate/candidate_profile.cfm?uniqueid=#qGetCandidate.uniqueid#" class="style4" target="_blank">[ profile ]</span></a> &nbsp;
                                        <a href="candidate/immigrationLetter.cfm?uniqueid=#qGetCandidate.uniqueid#" class="style4" target="_blank">[ Immigration Letter ]</span></a>
									</cfif>
                                </td>
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
                        <table width="600px" align="right" cellpadding="2" class="editPage">
                            <tr>
                                <td align="right" class="style1"><strong>Last Name:</strong> </td>
                                <td><input type="text" name="lastname" class="style1" size="32" value="#qGetCandidate.lastname#" maxlength="100"></td>
                            </tr>
                            <tr>
                                <td align="right" class="style1"><strong>First Name:</strong></td>
                                <td><input type="text" name="firstname" class="style1" size="32" value="#qGetCandidate.firstname#" maxlength="100"></td>
                            </tr>
                            <tr>
                                <td align="right" class="style1"><strong>Middle Name:</strong> </td>
                                <td><input type="text" name="middlename" class="style1" size="32" value="#qGetCandidate.middlename#" maxlength="100"></td>
                            </tr>
                            <tr>
                                <td align="center" class="style1"><strong>Date of Birth:</strong></td>
                                <td class="style1">
                                    <cfinput type="text" name="dob" class="datePicker style1" size="12" value="#dateFormat(qGetCandidate.dob, 'mm/dd/yyyy')#" maxlength="35" validate="date" message="Date of Birth (MM/DD/YYYY)" required="yes">
                                    &nbsp; 
                                    <strong>Sex:</strong> 
                                    <input type="radio" name="sex" value="M" required="yes" message="You must specify the candidate's sex." <cfif qGetCandidate.sex Eq 'M'>checked="checked"</cfif>>Male &nbsp; &nbsp;
                                    <input type="radio" name="sex" value="F" required="yes" message="You must specify the candidate's sex." <cfif qGetCandidate.sex Eq 'F'>checked="checked"</cfif>>Female 
                                </td>
                            </tr> 
                            <tr>
                                <td width="18%" align="right" class="style1"><strong>Intl. Rep.:</strong></td>
                                <td width="82%" class="style1">
                                    <select name="intrep" class="style1">
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
                                <td align="right" class="style1"><strong>Status: </strong></td>
                                <td class="style1">
                                	<select id="status" name="status" <cfif qGetCandidate.status NEQ 'canceled'> onchange="javascript:displayCancelation(this.value);" </cfif> >
                                        <option value="1" <cfif qGetCandidate.status EQ 1>selected="selected"</cfif>>Active</option>
                                        <option value="0" <cfif qGetCandidate.status EQ 0>selected="selected"</cfif>>Inactive</option>
                                        <option value="canceled" <cfif qGetCandidate.status Eq 'canceled'>selected="selected"</cfif>>Canceled</option>
	                                </select>
                                </td>
                            </tr>													
                        </table>
						
                    </td>
                </tr>													
            </table>
            <!--- END OF TOP SECTION --->
            
            <br>                                    
            
			<!--- INFORMATION SECTION --->
            <table width="1000px" border="0" cellpadding="0" cellspacing="0" align="center">	
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
                                            <td class="style1" align="right" width="50%"><strong>Place of Birth:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF" width="50%">
                                            	<span class="readOnly">#qGetCandidate.birth_city#</span>
                                                <input type="text" class="style1 editPage" name="birth_city" size="32" value="#qGetCandidate.birth_city#" maxlength="100">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong>Country of Birth:</strong></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                                <span class="readOnly">#qGetBirthCountry.countryName#</span>
                                                <select name="birth_country" class="style1 editPage">
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
                                                <select name="citizen_country" class="style1 editPage">
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
                                                <select name="residence_country" class="style1 editPage">
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
                                            	<input name="passport_number" class="style1 editPage" value="#qGetCandidate.passport_number#" type="text" size=32 maxlength="100">
                                            </td>
                                        </tr>
                                        <!--- Online App Field - University Name --->
                                        <tr>
                                            <td class="style1" align="right"><strong>#qGetQuestionsSection1.displayField[1]#:</strong></td>
                                            <td class="style1">
                                            	<span class="readOnly">#FORM[qGetQuestionsSection1.fieldKey[1]]# &nbsp;</span>
                                            	<input name="#qGetQuestionsSection1.fieldKey[1]#" class="style1 editPage" value="#FORM[qGetQuestionsSection1.fieldKey[1]]#" type="text" size=32 maxlength="50">
                                            </td>
                                        </tr>
                                        <tr>				
                                            <td class="style1" colspan="2">
            
                                                <table width="100%" cellpadding="3" cellspacing="3" style="border:1px solid ##C7CFDC; background-color:##F7F7F7;">
                                                    <tr>
                                                    	<td class="style1" align="right"><strong>Mailing Address:</strong></td>
                                                        <td class="style1">
															<span class="readOnly">#qGetCandidate.home_address#</span>
                                                            <input type="text" class="style1 editPage" name="home_address" size="38" value="#qGetCandidate.home_address#" maxlength="100">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="style1" align="right"><strong>City:</strong></td>
                                                        <td class="style1">
															<span class="readOnly">#qGetCandidate.home_city#</span>
                                                            <input type="text" class="style1 editPage" name="home_city" size="38" value="#qGetCandidate.home_city#" maxlength="100">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="style1" align="right"><strong>Zip:</strong></td>
                                                        <td class="style1">
                                                        	<span class="readOnly">#qGetCandidate.home_zip#</span>
                                                            <input type="text" class="style1 editPage" name="home_zip" size=11 value="#qGetCandidate.home_zip#" maxlength="15">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="style1" align="right"><strong>Country:</strong></td>
                                                        <td class="style1" colspan="3">                                                        
                                                            <span class="readOnly">#qGetHomeCountry.countryName#</span>
                                                            <select name="home_country" class="style1 editPage">
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
                                                            <input type="text" class="style1 editPage" name="home_phone" size="38" value="#qGetCandidate.home_phone#" maxlength="50">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="style1" align="right"><strong>Email:</strong></td>
                                                        <td class="style1" colspan="3">
                                                        	<span class="readOnly">#qGetCandidate.email#</span>
                                                            <input type="text" class="style1 editPage" name="email" size="38" value="#qGetCandidate.email#" maxlength="100">
                                                        </td>
                                                    </tr>
                                                </table>
                                            
                                            </td>					
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong>Social Security ##:</strong></td>
                                            <td class="style1">
                                            	<span class="readOnly">
                                                	<cfif ListFind("1,2,3,4", CLIENT.userType)>
                                                    	#APPLICATION.CFC.UDF.decryptVariable(qGetCandidate.SSN)#
                                                    <cfelse>
                                                    	XXX-XX-XX#Right(APPLICATION.CFC.UDF.decryptVariable(qGetCandidate.SSN), 2)#
                                                    </cfif>                                                    
                                                </span>
                                                <input name="ssn" value="#APPLICATION.CFC.UDF.decryptVariable(qGetCandidate.SSN)#" type="text" class="style1 editPage" size="32" maxlength="100">
                                            </td>
                                        </tr>	
                                        <!--- Online App Field - Participant's English Level --->
                                        <tr>
                                            <td class="style1" align="right"><strong><label for="#qGetQuestionsSection3.fieldKey[1]#">#qGetQuestionsSection3.displayField[1]#:</label></strong></td>
                                            <td class="style1">
                                            	<span class="readOnly">#FORM[qGetQuestionsSection3.fieldKey[1]]# &nbsp;</span>
                                                <select name="#qGetQuestionsSection3.fieldKey[1]#" id="#qGetQuestionsSection3.fieldKey[1]#" class="style1 editPage">
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
                                                <input name="#qGetQuestionsSection1.fieldKey[2]#" class="style1 editPage" value="#FORM[qGetQuestionsSection1.fieldKey[2]]#" type="text" size=32 maxlength="50">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right" valign="top"><strong>English Assessment CSB:</strong></td>
                                            <td class="style1">
                                            	<span class="readOnly">#qGetCandidate.englishAssessment#</span>
                                                <textarea name="englishAssessment" class="style1 editPage" cols="30" rows="3">#qGetCandidate.englishAssessment#</textarea>
                                            </td>
                                        </tr>
                                        
                                        <tr>
                                            <td class="style1" align="right"><strong>Date of Interview:</strong></td>
                                            <td class="style1">
                                            	<span class="readOnly">#DateFormat(qGetCandidate.englishAssessmentDate, 'mm/dd/yyyy')#</span>
                                                <input type="text" name="englishAssessmentDate" class="datePicker style1 editPage" value="#DateFormat(qGetCandidate.englishAssessmentDate, 'mm/dd/yyyy')#">
                                                <font size="1">(mm/dd/yyyy)</font>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right" valign="top"><strong>Comment:</strong></td>
                                            <td class="style1">
                                            	<span class="readOnly">#qGetCandidate.englishAssessmentComment#</span>
                                                <textarea name="englishAssessmentComment" class="style1 editPage" cols="30" rows="6">#qGetCandidate.englishAssessmentComment#</textarea>
                                            </td>
                                        </tr>
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
                                            <td width="23%" class="style1" align="right"><strong>Start Date:</strong></td>
                                            <td class="style1">
                                            	<span class="readOnly">#dateFormat(qGetCandidate.wat_vacation_start, 'mm/dd/yyyy')#</span>
                                                <input type="text" name="wat_vacation_start" class="datePicker style1 editPage" value="#dateFormat(qGetCandidate.wat_vacation_start, 'mm/dd/yyyy')#" maxlength="10">
                                                <font size="1">(mm/dd/yyyy)</font>
                                            </td>
                                        </tr>
                                        <tr>
                                        	<td class="style1" align="right"><strong>End Date:</strong></td>
                                        	<td class="style1">	
                                            	<span class="readOnly">#dateFormat(qGetCandidate.wat_vacation_end, 'mm/dd/yyyy')#</span>
                                                <input type="text" name="wat_vacation_end" class="datePicker style1 editPage" value="#dateFormat(qGetCandidate.wat_vacation_end, 'mm/dd/yyyy')#" maxlength="10"> 
                                                <font size="1">(mm/dd/yyyy)</font>
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
                                            <td width="15%" class="style1" align="right"><strong>Name:</strong></td>
                                            <td class="style1">
                                                <span class="readOnly">#qGetCandidate.emergency_name#</span>
                                                <input type="text" name="emergency_name" class="style1 editPage" size="32" value="#qGetCandidate.emergency_name#" maxlength="100">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong>Phone:</strong></td>
                                            <td class="style1">
                                                <span class="readOnly">#qGetCandidate.emergency_phone#</span>                          
                                                <input type="text" name="emergency_phone" class="style1 editPage" size="32" value="#qGetCandidate.emergency_phone#" maxlength="50">
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
                                                <input type="checkbox" name="wat_doc_agreement" id="wat_doc_agreement" value="1" class="formField" disabled <cfif VAL(qGetCandidate.wat_doc_agreement)> checked </cfif> > 
                                                <label for="wat_doc_agreement">Agreement</label>
                                            </td>
                                            <td width="50%" class="style1">
                                                <input type="checkbox" name="wat_doc_signed_assessment" id="wat_doc_signed_assessment" value="1" class="formField" disabled <cfif VAL(qGetCandidate.wat_doc_signed_assessment)> checked </cfif> >
                                                <label for="wat_doc_signed_assessment">Signed English Assessment</label>
                                            </td>
                                        </tr>
                                        <tr>
                                        	<!--- Walk-In Agreement - Only Available for Walk-In --->
                                            <td class="style1">
                                                <input type="checkbox" name="wat_doc_walk_in_agreement" id="wat_doc_walk_in_agreement" value="1" <cfif qGetCandidate.wat_placement EQ 'Walk-In'> class="formField" </cfif> disabled <cfif VAL(qGetCandidate.wat_doc_walk_in_agreement)> checked </cfif> > 
                                                <label for="wat_doc_walk_in_agreement">Walk-In Agreement</label>
                                            </td>
                                            <td class="style1">
                                                <input type="checkbox" name="wat_doc_college_letter" id="wat_doc_college_letter" value="1" class="formField" disabled <cfif VAL(qGetCandidate.wat_doc_college_letter)> checked </cfif> >
                                                <label for="wat_doc_college_letter">College Letter</label>
                                            </td>
                                        </tr>
                                        <tr>
                                        	<!--- CV - Only Available for CSB-Placement --->
                                            <td class="style1"> 
                                                <input type="checkbox" name="wat_doc_cv" id="wat_doc_cv" value="1" <cfif qGetCandidate.wat_placement EQ 'CSB-Placement'> class="formField" </cfif> disabled <cfif VAL(qGetCandidate.wat_doc_cv)> checked </cfif> > 
                                                <label for="wat_doc_cv">CV</label>
                                            </td>
                                            <td class="style1">
                                                <input type="checkbox" name="wat_doc_college_letter_translation" id="wat_doc_college_letter_translation" value="1" class="formField" disabled <cfif VAL(qGetCandidate.wat_doc_college_letter_translation)> checked </cfif> > 
                                                <label for="wat_doc_college_letter_translation">College Letter (translation)</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1">
                                                <input type="checkbox" name="wat_doc_passport_copy" id="wat_doc_passport_copy" value="1" class="formField" disabled <cfif VAL(qGetCandidate.wat_doc_passport_copy)> checked </cfif> > 
                                                <label for="wat_doc_passport_copy">Passport Copy</label>
                                            </td>
                                            <td class="style1">
                                                <input type="checkbox" name="wat_doc_job_offer_applicant" id="wat_doc_job_offer_applicant" value="1" class="formField" disabled <cfif VAL(qGetCandidate.wat_doc_job_offer_applicant)> checked </cfif> >
                                                <label for="wat_doc_job_offer_applicant">Job Offer Agreement Applicant</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1">
                                                <input type="checkbox" name="wat_doc_orientation" id="wat_doc_orientation" value="1" class="formField" disabled <cfif VAL(qGetCandidate.wat_doc_orientation)> checked </cfif> > 
                                                <label for="wat_doc_orientation">Orientation Sign Off</label>
                                            </td>
                                            <td class="style1">
                                                <input type="checkbox" name="wat_doc_job_offer_employer" id="wat_doc_job_offer_employer" value="1" class="formField" disabled <cfif VAL(qGetCandidate.wat_doc_job_offer_employer)> checked </cfif> >
                                                <label for="wat_doc_job_offer_employer">Job Offer Agreement Employer</label>
                                            </td>
                                        </tr>
                                        <tr>
                                        	<td class="style1" colspan="2">
                                            	<strong>Other:</strong>
                                                <span class="readOnly">#qGetCandidate.wat_doc_other#</span>                          
                                                <input type="text" name="wat_doc_other" class="style1 editPage" size="50" value="#qGetCandidate.wat_doc_other#" maxlength="250">
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
                                                <cfif ListFind("1,2,3,4", CLIENT.userType)>
	                                                [ <a href="javascript:openWindow('insurance/insurance_mgmt.cfm?uniqueid=#uniqueid#', 500, 800);"><font class="style2" color="##FFFFFF">Insurance Management</font></a> ]
                                                </cfif>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="2%" align="right">
                                                <input type="checkbox" name="insurance_check" disabled <cfif qGetIntlRepInfo.extra_insurance_typeid GT 1> checked </cfif> >
                                            </td>
                                            <td width="25%" class="style1" align="right"><strong>Policy Type:</strong></td>
                                            <td width="73%" class="style1">
                                                <cfif qGetIntlRepInfo.extra_insurance_typeid EQ 0>
                                                    <font color="FF0000">Missing Policy Type</font>
                                                <cfelse>
                                                    #qGetIntlRepInfo.type#
                                                </cfif>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <input type="checkbox" name="insurance_date" disabled <cfif LEN(qGetCandidate.insurance_date)> checked </cfif>>
                                            </td>
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
                                            <td>
                                                <input type="checkbox" name="insurance_Cancel" disabled="disabled" <cfif LEN(qGetCandidate.insurance_cancel_date)> checked </cfif> >
                                            </td>
                                            <td class="style1" align="right"><strong>Cancel Date:</strong></td>
                                            <td class="style1">#dateFormat(qGetCandidate.insurance_cancel_date, 'mm/dd/yyyy')#</td>
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
                                                <td class="style1" align="right" valign="top"><strong>Reason:</strong></td>
                                                <td class="style1">
                                                    <span class="readOnly">#qGetCandidate.cancel_reason#</span>
                                                    <input name="cancel_reason" id="cancel_reason" type="text" class="style1 editPage" size="50" value="#qGetCandidate.cancel_reason#">
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
                                            	<cfif ListFind("1,2,3,4", CLIENT.userType)>
		                                            [<a href="javascript:openWindow('candidate/candidate_host_history.cfm?unqid=#qGetCandidate.uniqueid#', 400, 750);" class="style2"> History </a> ]</span>
        										</cfif>
											</td>			                                                
                                        </tr>
                                        <tr>
                                        	<td class="style1" align="Left" colspan="2"><strong>Company Name:</strong></td>
                                        </tr>
                                        <tr>
                                            <td class="style1" colspan="2" align="left">
                                            	<span class="readOnly">
                                                    <cfif ListFind("1,2,3,4", CLIENT.userType)>
	                                                    <a href="?curdoc=hostcompany/hostCompanyInfo&hostcompanyID=#qCandidatePlaceCompany.hostcompanyID#" class="style4"><strong>#qCandidatePlaceCompany.name#</strong></a>
                                                	<cfelse>
                                                    	#qCandidatePlaceCompany.name#
                                                    </cfif>
                                                </span>
                                                
                                                <select name="hostcompanyID" id="hostcompanyID" class="style1 editPage" onChange="displayHostReason(#VAL(qCandidatePlaceCompany.hostCompanyID)#, this.value); displaySelfPlacementInfo();"> 
	                                                <option value="0">Unplaced</option>
                                                    <cfloop query="qHostCompanyList">
                                                    	<option value="#qHostCompanyList.hostcompanyID#" <cfif qCandidatePlaceCompany.hostCompanyID EQ qHostCompanyList.hostcompanyID>selected</cfif> > 
															<cfif LEN(qHostCompanyList.name) GT 55>
                                                                #Left(qHostCompanyList.name, 52)#...
                                                            <cfelse>
                                                                #qHostCompanyList.name#
                                                            </cfif>
                                                        </option>
                                                    </cfloop>
                                                </select>
                                            </td>
                                        </tr>
                                        
                                        <!--- Change Placement --->
                                        <tr id="hostCompanyChangeReason" class="hiddenField trReasonInfo">
                                           	<td width="35%" class="style1" align="right" valign="top"><strong>Reason:</strong></td>
                                            <td width="65%" class="style1">
                                            	<textarea name="reason_host" id="reason_host" class="style1 editPage" cols="60" rows="8">#qCandidatePlaceCompany.reason_host#</textarea>
                                            </td>
                                        </tr>  

                                        <!--- Placement Date --->
                                        <tr class="readOnly">
                                        	<td class="style1" align="right" width="35%"><strong>Placement Date:</strong></td>
                                            <td class="style1" align="left" width="65%">
	                                        	#dateFormat(qCandidatePlaceCompany.placement_date, 'mm/dd/yyyy')#
                                            </td>
                                        </tr>
                                        
                                        <tr id="trReasonInfo" class="hiddenField trReasonInfo">
                                        	<td class="style1" align="right" width="35%" valign="top"><strong>Is this a transfer?</strong></td>
                                            <td class="style1" width="65%">
                                                <span class="readOnly">#YesNoFormat(VAL(qCandidatePlaceCompany.isTransfer))#</span>
                                                <select name="isTransfer" id="isTransfer" class="style1 editPage" onChange="displayTransferInfo();">
                                                	<option value=""> </option>
                                                    <option value="1" <cfif qCandidatePlaceCompany.isTransfer EQ 1> selected </cfif> > Yes </option>
                                                    <option value="0" <cfif qCandidatePlaceCompany.isTransfer EQ 0> selected </cfif> > No </option>
                                                </select>
                                            </td>
                                        </tr>
                                        
                                        <!--- Transfer Info --->
                                        <tr class="hiddenField trTransferInfo">
                                            <td class="style1" align="right" width="35%" valign="top"><strong>Confirmation Date:</strong></td>
                                            <td class="style1" width="65%">
	                                            <span class="readOnly">#DateFormat(qCandidatePlaceCompany.dateTransferConfirmed, 'mm/dd/yyyy')#</span>
                                                <input type="text" class="style1 datePicker editPage" name="dateTransferConfirmed" id="dateTransferConfirmed" value="#DateFormat(qCandidatePlaceCompany.dateTransferConfirmed, 'mm/dd/yyyy')#">
                                            </td>
                                        </tr>
                                        <tr class="hiddenField trTransferInfo">
                                        	<td colspan="2">
                                            	
                                                <table cellpadding="0" cellspacing="0" width="100%">
                                                    <tr class="hiddenField trTransferInfo">
                                                        <td width="33%" class="style1" align="center">
                                                            <input type="checkbox" name="isTransferJobOfferReceived" id="isTransferJobOfferReceived" value="1" class="formField" disabled <cfif qCandidatePlaceCompany.isTransferJobOfferReceived EQ 1>checked</cfif> > 
                                                            <label for="isTransferJobOfferReceived">New Job Offer</label> 
                                                        </td>
                                                        <td width="33%" class="style1" align="center">
                                                            <input type="checkbox" name="isTransferHousingAddressReceived" id="isTransferHousingAddressReceived" value="1" class="formField" disabled <cfif qCandidatePlaceCompany.isTransferHousingAddressReceived EQ 1>checked</cfif> > 
                                                            <label for="isTransferHousingAddressReceived">New Housing Address</label> 
                                                        </td>
                                                        <td width="33%" class="style1" align="center">
                                                            <input type="checkbox" name="isTransferSevisUpdated" id="isTransferSevisUpdated" value="1" class="formField" disabled <cfif qCandidatePlaceCompany.isTransferSevisUpdated EQ 1>checked</cfif> > 
                                                            <label for="isTransferSevisUpdated">SEVIS Updated</label> 
                                                        </td>
                                                    </tr>
                                                </table>
                                        	
                                            </td>
										</tr> 
                                        <!--- End of Transfer Info ---> 

                                    
                                        <!--- Only for Self Placement with Active Placement Information --->
                                        <tr bgcolor="##C2D1EF" bordercolor="##FFFFFF" class="hiddenField selfPlacementInfo">
                                            <td colspan="2" class="style2" bgcolor="##8FB6C9">&nbsp;:: Self Placement Confirmation</td>
                                        </tr>
                                        <tr class="hiddenField selfPlacementInfo">
                                            <td class="style1" align="right"><strong>Job Offer Status:</strong></td>
                                            <td class="style1">
                                                <span class="readOnly">#qCandidatePlaceCompany.selfJobOfferStatus#</span>
                                                <select name="selfJobOfferStatus" id="selfJobOfferStatus" class="style1 editPage selfPlacementField"> 
                                                	<option value="" <cfif qCandidatePlaceCompany.selfJobOfferStatus EQ ''>selected</cfif> ></option>
                                                    <option value="Pending" <cfif qCandidatePlaceCompany.selfJobOfferStatus EQ 'Pending'>selected</cfif> >Pending</option>
                                                    <option value="Approved" <cfif qCandidatePlaceCompany.selfJobOfferStatus EQ 'Approved'>selected</cfif> >Approved</option>
                                                    <option value="Rejected" <cfif qCandidatePlaceCompany.selfJobOfferStatus EQ 'Rejected'>selected</cfif> >Rejected</option>
                                                </select>
                                            </td>
                                        </tr>
										<!---- ONLY OFFICE USERS ---->
                                        <cfif ListFind("1,2,3,4", CLIENT.userType)>
                                            <tr class="hiddenField selfPlacementInfo">
                                                <td class="style1" align="right"><strong>Date:</strong></td>
                                                <td class="style1" colspan="3">
                                                    <span class="readOnly">#DateFormat(qCandidatePlaceCompany.selfConfirmationDate, 'mm/dd/yyyy')#</span>
                                                    <input type="text" name="selfConfirmationDate" id="selfConfirmationDate" class="style1 datePicker editPage selfPlacementField" value="#DateFormat(qCandidatePlaceCompany.selfConfirmationDate, 'mm/dd/yyyy')#" maxlength="10"><font size="1">(mm/dd/yyyy)</font>
                                                </td>
                                            </tr>
                                            <tr class="hiddenField selfPlacementInfo">
                                                <td class="style1" align="right"><strong>Name:</strong></td>
                                                <td class="style1">
                                                    <span class="readOnly">#qCandidatePlaceCompany.selfConfirmationName#</span>
                                                    <input type="text" name="selfConfirmationName" id="selfConfirmationName" value="#qCandidatePlaceCompany.selfConfirmationName#" size="45" class="style1 editPage selfPlacementField">
                                                </td>
                                            </tr>
                                            <tr class="hiddenField selfPlacementInfo">
                                                <td class="style1" align="right"><strong>Method:</strong></td>
                                                <td class="style1">
                                                    <span class="readOnly">#qCandidatePlaceCompany.selfConfirmationMethod#</span>
                                                    <select name="selfConfirmationMethod" id="selfConfirmationMethod" class="style1 editPage selfPlacementField"> 
                                                        <option value=""></option>
                                                        <option value="Email" <cfif qCandidatePlaceCompany.selfConfirmationMethod EQ 'Email'>selected</cfif> >Email</option>
                                                        <option value="Phone" <cfif qCandidatePlaceCompany.selfConfirmationMethod EQ 'Phone'>selected</cfif> >Phone</option>
                                                        <option value="Fax" <cfif qCandidatePlaceCompany.selfConfirmationMethod EQ 'Fax'>selected</cfif> >Fax</option>
                                                    </select>
                                                </td>
                                            </tr>
                                            <tr class="hiddenField selfPlacementInfo">
                                                <td class="style1" align="right"><strong>Authentication:</strong></td>
                                                <td class="style1">
                                                    <span class="readOnly">#qCandidatePlaceCompany.authenticationType#</span>
                                                    <select name="authenticationType" id="authenticationType" class="style1 editPage selfPlacementField"> 
                                                        <option value="" <cfif NOT LEN(qCandidatePlaceCompany.authenticationType)>selected</cfif> ></option>
                                                        <option value="Secretary of State website" <cfif qCandidatePlaceCompany.authenticationType EQ 'Secretary of State website'>selected</cfif> >Secretary of State website</option>
                                                        <option value="US Department of Labor website" <cfif qCandidatePlaceCompany.authenticationType EQ 'US Department of Labor website'>selected</cfif> >US Department of Labor website</option>
                                                        <option value="Google Earth" <cfif qCandidatePlaceCompany.authenticationType EQ 'Google Earth'>selected</cfif> >Google Earth</option>
                                                    </select>
												</td>	                                                    
                                            </tr>
                                            <tr class="hiddenField selfPlacementInfo">
                                                <td class="style1" align="right"><strong>EIN:</strong></td>
                                                <td class="style1">
                                                    <span class="readOnly">#qCandidatePlaceCompany.EIN#</span>
                                                    <input type="text" name="EIN" id="EIN" value="#qCandidatePlaceCompany.EIN#" size="45" class="style1 editPage selfPlacementField">
                                                </td>
                                            </tr>
                                            <tr class="hiddenField selfPlacementInfo">
                                                <td class="style1" align="right"><strong>Workmen's Compensation:</strong></td>
                                                <td class="style1">
                                                    <span class="readOnly">
                                                        <cfif qCandidatePlaceCompany.workmensCompensation EQ 0>
                                                            No
                                                        <cfelseif qCandidatePlaceCompany.workmensCompensation EQ 1>
                                                            Yes
                                                        <cfelseif qCandidatePlaceCompany.workmensCompensation EQ 2>
                                                            N/A
                                                        </cfif>
                                                    </span>
                                                    <select name="workmensCompensation" id="workmensCompensation" class="style1 editPage selfPlacementField"> 
                                                        <option value="" <cfif NOT LEN(qCandidatePlaceCompany.workmensCompensation)>selected</cfif> ></option>
                                                        <option value="0" <cfif qCandidatePlaceCompany.workmensCompensation EQ 0>selected</cfif> >No</option>
                                                        <option value="1" <cfif qCandidatePlaceCompany.workmensCompensation EQ 1>selected</cfif> >Yes</option>                                                    
                                                        <option value="2" <cfif qCandidatePlaceCompany.workmensCompensation EQ 2>selected</cfif> >N/A</option>
                                                    </select>
                                                </td>
                                            </tr>
                                            <tr class="hiddenField selfPlacementInfo">
                                                <td class="style1" align="right"><strong>Job Found:</strong></td>
                                                <td class="style1">
                                                    <span class="readOnly">
                                                        #qCandidatePlaceCompany.selfFindJobOffer#
                                                    </span>
                                                    <select name="selfFindJobOffer" id="selfFindJobOffer" class="style1 editPage selfPlacementField"> 
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
                                                <td class="style1" align="right" valign="top"><strong>Notes:</strong></td>
                                                <td class="style1" colspan="3">
                                                    <span class="readOnly">#qCandidatePlaceCompany.selfConfirmationNotes#</span>
                                                    <textarea name="selfConfirmationNotes" id="selfConfirmationNotes" class="style1 editPage selfPlacementField" cols="60" rows="8">#qCandidatePlaceCompany.selfConfirmationNotes#</textarea>
                                                </td>
                                            </tr>
										</cfif>                                            
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
                                            	<cfif ListFind("1,2,3,4", CLIENT.userType)>    
                                                	[ <a href="javascript:openWindow('candidate/candidate_program_history.cfm?unqid=#uniqueid#', 400, 600);"> <font class="style2" color="##FFFFFF"> History </font> </a> ]</span>
                                            	</cfif>
                                            </td>
                                        </tr>						
                                        <tr>
                                        	<td class="style1" align="right" width="27%"><strong>Program:</strong></td>
                                            <td class="style1" colspan="3">
                                                <span class="readOnly">#qGetProgramInfo.programName#</span>
                                                <select name="programid" class="style1 editPage" onChange="displayProgramReason(#VAL(qGetCandidate.programid)#, this.value);">
                                                    <option value="0">Unassigned</option>
                                                    <cfloop query="program">
                                                        <option value="#program.programid#" <cfif qGetCandidate.programid EQ program.programid> selected </cfif> >#program.programname#</option>
                                                    </cfloop>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr id="program_history" bgcolor="##FFBD9D" class="hiddenField">
                                        	<td class="style1" align="right"><strong>Reason:</strong></td>
                                        	<td class="style1" colspan="3"><input type="text" name="reason" id="reason" size="50" class="style1"></td>
                                        </tr>
                                        <tr>
                                        	<!--- Placement--->
                                        	<td class="style1" align="right"><strong>Option:</strong></td>
                                        	<td class="style1" colspan="3">
												<span class="readOnly">#qGetCandidate.wat_placement#</span>
                                                <select name="wat_placement" id="wat_placement" onChange="displaySelfPlacementInfo();" class="style1 editPage">
                                                    <option value="">Select....</option>
                                                    <option value="Self-Placement" <cfif qGetCandidate.wat_placement EQ 'Self-Placement'>selected="selected"</cfif>>Self-Placement</option>
                                                    <option value="CSB-Placement" <cfif qGetCandidate.wat_placement EQ 'CSB-Placement'>selected="selected"</cfif>>CSB-Placement</option>
                                                    <option value="Walk-In" <cfif qGetCandidate.wat_placement EQ 'Walk-In'>selected="selected"</cfif>>Walk-In</option>
                                                </select>
	                                        </td>
                                        </tr>		
                                        <tr>
                                        	<td class="style1" align="left" colspan="4">
                                            	<strong>Number of Participation in the Program:</strong>
                                        		<span class="readOnly">#qGetCandidate.wat_participation#</span>
                                                <select name="wat_participation" class="style1 editPage">
                                                	<cfloop from="0" to="15" index="i">
                                                    	<option value="#i#" <cfif qGetCandidate.wat_participation EQ i> selected </cfif> >#i#</option>                                                    
                                                    </cfloop>
                                 				</select>               
	                                        </td>
                                        </tr>
                                        <tr>
    	                                    <td class="style1" align="left" colspan="2"><strong>Requested Placement:</strong>
                                        </tr>
                                        <tr>
                                        	<td class="style1" colspan="4"> 
                                            	<span class="readOnly">
                                                    <cfif ListFind("1,2,3,4", CLIENT.userType)>
	                                                    <a href="?curdoc=hostcompany/hostCompanyInfo&hostcompanyID=#qRequestedPlacement.hostcompanyID#" class="style4"><strong>#qRequestedPlacement.name#</strong></a>
                                                    <cfelse>
                                                    	#qRequestedPlacement.name#
                                                    </cfif>
                                                </span>
                                                <select name="requested_placement" class="style1 editPage">
                                                    <option value="0"></option>
                                                    <cfloop query="qHostCompanyList">
                                                    	<option value="#qHostCompanyList.hostcompanyID#" <cfif qGetCandidate.requested_placement EQ qHostCompanyList.hostcompanyID>selected</cfif>> 
															<cfif LEN(qHostCompanyList.name) GT 55>
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
	                                        <td class="style1" align="right" valign="top"><strong>Comments:</strong></td>
    	                                    <td class="style1" colspan="3">
        	                                	<span class="readOnly">#qGetCandidate.change_requested_comment#</span>
            		                            <textarea name="change_requested_comment" class="style1 editPage" cols="60" rows="8">#qGetCandidate.change_requested_comment#</textarea>
                    	                    </td>
                                        </tr>
                                        <tr>
                                        	<td class="style1" align="right"><strong>Start Date:</strong></td>
                                        	<td class="style1" colspan="3">
                                            	<span class="readOnly">#dateFormat(qGetCandidate.startdate, 'mm/dd/yyyy')#</span>
                                            	<input type="text" class="style1 datePicker editPage" name="program_startdate" value="#dateFormat(qGetCandidate.startdate, 'mm/dd/yyyy')#" maxlength="10"><font size="1">(mm/dd/yyyy)</font>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong>End Date:</strong></td>
                                            <td class="style1" colspan="3">
                                                <span class="readOnly">#dateFormat(qGetCandidate.enddate, 'mm/dd/yyyy')#</span>
                                                <input type="text" class="style1 datePicker editPage" name="program_enddate" value="#dateFormat(qGetCandidate.enddate, 'mm/dd/yyyy')#" maxlength="10"><font size="1">(mm/dd/yyyy)</font>
                                            </td>
                                        </tr>
                                    </table>
                        
                                </td>
                            </tr>
                        </table> 

						<br />
                        
						<!--- DS2019 Form --->
                        <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
                                <td bordercolor="##FFFFFF">
                        
                                    <table width="100%" cellpadding=3 cellspacing="0" border="0">
                                    	<tr bgcolor="##C2D1EF">
                                    		<td colspan="2" class="style2" bgcolor="##8FB6C9">&nbsp;:: Form DS-2019</td>
                                    	</tr>	
                                        <tr>
                                            <td class="style1" width="50%" align="right"><strong>Sponsor:</strong></td>
                                            <td class="style1">
                                                <cfif LEN(qGetProgramInfo.extra_sponsor)>
                                                    #qGetProgramInfo.extra_sponsor#
                                                <cfelse>
                                                    n/a
                                                </cfif>	
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong><label for="ds2019Check">DS-2019 Verification Report</label></strong></td>
                                            <td class="style1">
                                            	<input type="checkbox" name="ds2019Check" id="ds2019Check" class="formField" disabled onClick="populateDate('#DateFormat(now(), 'mm/dd/yyyy')#');" <cfif LEN(qGetCandidate.verification_received)> checked </cfif> > Received 
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong>Date:</strong></td>
                                            <td class="style1">
                                            	<span class="readOnly">#dateFormat(qGetCandidate.verification_received, 'mm/dd/yyyy')#</span>
                                                <input type="text" name="verification_received" id="verification_received" class="datePicker style1 editPage" value="#dateFormat(qGetCandidate.verification_received, 'mm/dd/yyyy')#" maxlength="10">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong>DS-2019 Number:</strong></td>
                                            <td class="style1">
                                            	<span class="readOnly">#qGetCandidate.ds2019#</span>
                                                <input type="text" name="ds2019" class="style1 editPage" value="#qGetCandidate.ds2019#" size="20" maxlength="20">
                                            </td>
                                        </tr>
                                        <tr>	
                                        	<td class="style1" align="right"><strong>Accepts SEVIS Fee:</strong></td>
                                            <td class="style1">#YesNoFormat(VAL(qGetIntlRepInfo.extra_accepts_sevis_fee))#</td>
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
                                        	<td colspan="4" class="style2" bgcolor="##8FB6C9">&nbsp;:: Arrival Verification</td>
                                        </tr>	
                                        <tr>
                                        	<td class="style1" width="50%" align="right"><label for="verification_address"><strong>House Address Verified:</strong></label></td>
                                            <td class="style1">
                                            	<input type="checkbox" name="verification_address" id="verification_address" value="1" class="formField" disabled <cfif VAL(qGetCandidate.verification_address)>checked="checked"</cfif> >
                                            </td>
                                        </tr>
                                        <tr>
                                        	<td class="style1" align="right"><label for="verification_sevis"><strong>SEVIS Activated:</strong></label></td>
                                        	<td class="style1">
                                        		<input type="checkbox" name="verification_sevis" id="verification_sevis" value="1" class="formField" disabled <cfif VAL(qGetCandidate.verification_sevis)>checked="checked"</cfif> >
                                        	</td>
                                        </tr>
                                        <tr>
                                        	<td class="style1" align="right"><label for="watDateCheckedIn"><strong>Checked-In Date:</strong></label></td>
                                        	<td class="style1">
                                                <span class="readOnly">#dateFormat(qGetCandidate.watDateCheckedIn, 'mm/dd/yyyy')#</span>
                                                <input type="text" name="watDateCheckedIn" id="watDateCheckedIn" class="datePicker style1 editPage" value="#dateFormat(qGetCandidate.watDateCheckedIn, 'mm/dd/yyyy')#" maxlength="10">
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
                                            	&nbsp;:: Flight Information  &nbsp;
                                                <a href="onlineApplication/index.cfm?action=flightInfo&uniqueID=#qGetCandidate.uniqueID#&completeApplication=0" class="style2 popUpFlightInformation">[ Add/Edit ]</a>
                                            </td>
                                        </tr>	
                                        <tr>
                                        	<td class="style1" width="20%" align="right" valign="top"><label for="verification_address"><strong>Arrival:</strong></label></td>
                                            <td class="style1">
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
                                        	<td class="style1" align="right" valign="top"><label for="verification_sevis"><strong>Departure:</strong></label></td>
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
                        
                    </td>
                    <!--- END OF RIGHT SECTION --->
                </tr>
        	</table>
        
            <!--- END OF INFORMATION SECTION ---> 
            
            <br/>

			<!---- EDIT/UPDATE BUTTONS ---->
            <cfif ListFind("1,2,3,4", CLIENT.userType)>
                
                <table width="1000px" border="0" cellpadding="0" cellspacing="0" align="center">	
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