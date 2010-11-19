<!--- ------------------------------------------------------------------------- ----
	
	File:		_section1.cfm
	Author:		Marcus Melo
	Date:		August 09, 2010
	Desc:		Section 1 of the Online Application

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../../extensions/customtags/gui/" prefix="gui" />	
    
	<!--- It is set to 1 for the print application page --->
	<cfparam name="printApplication" default="#APPLICATION.CFC.CANDIDATE.getCandidateSession().isReadOnly#">
    
	<!--- Param FORM Variables --->
    <cfparam name="FORM.submittedType" default="">
    <cfparam name="FORM.currentTabID" default="0">
    <!--- Candidate Details --->
    <cfparam name="FORM.candidateID" default="#APPLICATION.CFC.CANDIDATE.getCandidateID()#">
	<!--- Personal Data --->
    <cfparam name="FORM.lastName" default="">
    <cfparam name="FORM.firstName" default="">
	<cfparam name="FORM.middleName" default="">
    <cfparam name="FORM.sex" default="">
    <cfparam name="FORM.dob" default="">
    <cfparam name="FORM.dobMonth" default="">
    <cfparam name="FORM.dobDay" default="">
    <cfparam name="FORM.dobYear" default="">
    <cfparam name="FORM.birth_city" default="">
    <cfparam name="FORM.birth_country" default="">
    <cfparam name="FORM.residence_country" default="">
    <cfparam name="FORM.citizen_country" default="">
    <cfparam name="FORM.home_address" default="">
    <cfparam name="FORM.home_city" default="">
    <cfparam name="FORM.home_country" default="">
    <cfparam name="FORM.home_zip" default="">
    <cfparam name="FORM.home_phone" default="">
    <cfparam name="FORM.homePhoneCountry" default="">
    <cfparam name="FORM.homePhoneArea" default="">
    <cfparam name="FORM.homePhonePrefix" default="">
    <cfparam name="FORM.homePhoneNumber" default="">
    <cfparam name="FORM.email" default="">
    <cfparam name="FORM.passport_number" default="">
    <cfparam name="FORM.emergency_name" default="">
    <cfparam name="FORM.emergency_phone" default="">
    <cfparam name="FORM.emergencyPhoneCountry" default="">
    <cfparam name="FORM.emergencyPhoneArea" default="">
    <cfparam name="FORM.emergencyPhonePrefix" default="">
    <cfparam name="FORM.emergencyPhoneNumber" default="">
	<!--- Dates of Official Vacation --->
    <cfparam name="FORM.watStartVacation" default="">
    <cfparam name="FORM.watStartVacationMonth" default="">
    <cfparam name="FORM.watStartVacationDay" default="">
    <cfparam name="FORM.watStartVacationYear" default="">
    <cfparam name="FORM.watEndVacation" default="">    
    <cfparam name="FORM.watEndVacationMonth" default="">
    <cfparam name="FORM.watEndVacationDay" default="">
    <cfparam name="FORM.watEndVacationYear" default="">
    <!--- Program Information --->
    <cfparam name="FORM.programStart" default="">
    <cfparam name="FORM.programStartMonth" default="">
    <cfparam name="FORM.programStartDay" default="">
    <cfparam name="FORM.programStartYear" default="">
    <cfparam name="FORM.programEnd" default="">
    <cfparam name="FORM.programEndMonth" default="">
    <cfparam name="FORM.programEndDay" default="">
    <cfparam name="FORM.programEndYear" default="">
	<!--- Program Program Option --->
    <cfparam name="FORM.wat_placement" default="">
    <cfparam name="FORM.wat_participation" default="">
    <cfparam name="FORM.SSN" default="">
    <cfparam name="FORM.ssnAreaNumber" default="">
    <cfparam name="FORM.ssnGroupNumber" default="">
    <cfparam name="FORM.ssnSerialNumber" default="">

	<!--- Candidate Picture --->
    <cfdirectory name="candidatePicture" directory="#APPLICATION.PATH.uploadCandidatePicture#" filter="#FORM.candidateID#.*">
    
    <cfscript>
		// Get Current Candidate Information
		// qGetCandidateInfo = APPLICATION.CFC.CANDIDATE.getCandidateByID(candidateID=FORM.candidateID);

		// Get Current Candidate Information
		qGetCountry = APPLICATION.CFC.LOOKUPTABLES.getCountry();

		// Get Questions for this section
		qGetQuestions = APPLICATION.CFC.ONLINEAPP.getQuestionByFilter(sectionName='section1');
		
		// Get Answers for this section
		qGetAnswers = APPLICATION.CFC.ONLINEAPP.getAnswerByFilter(sectionName='section1', foreignTable=APPLICATION.foreignTable, foreignID=FORM.candidateID);

		// Param Online Application Form Variables 
		for ( i=1; i LTE qGetQuestions.recordCount; i=i+1 ) {
			param name="FORM[qGetQuestions.fieldKey[i]]" default="";
		}

		// FORM Submitted
		if ( FORM.submittedType EQ 'section1' ) {
			
			// Home Phone
			FORM.home_phone = APPLICATION.CFC.UDF.formatPhoneNumber(countryCode=FORM.homePhoneCountry, areaCode=FORM.homePhoneArea, prefix=FORM.homePhonePrefix, number=FORM.homePhoneNumber);
			// Emergency Phone
			FORM.emergency_phone = APPLICATION.CFC.UDF.formatPhoneNumber(countryCode=FORM.emergencyPhoneCountry, areaCode=FORM.emergencyPhoneArea, prefix=FORM.emergencyPhonePrefix, number=FORM.emergencyPhoneNumber);					
			// SSN
			FORM.SSN = APPLICATION.CFC.UDF.formatSSN(areaNumber=FORM.ssnAreaNumber, groupNumber=FORM.ssnGroupNumber, serialNumber=FORM.ssnSerialNumber);
			// WAT Start and End Dates
			FORM.watStartVacation = FORM.watStartVacationMonth & "/" & FORM.watStartVacationDay & "/" & FORM.watStartVacationYear;
			FORM.watEndVacation = FORM.watEndVacationMonth & "/" & FORM.watEndVacationDay & "/" & FORM.watEndVacationYear;
			// Program Start and End Dates
			FORM.programStart = FORM.programStartMonth & "/" & FORM.programStartDay & "/" & FORM.programStartYear;
			FORM.programEnd = FORM.programEndMonth & "/" & FORM.programEndDay & "/" & FORM.programEndYear;
			
			// Check required Fields
			if ( NOT LEN(FORM.lastName) ) {
				// Get all the missing items in a list
				SESSION.formErrors.Add('Please enter your last name');
			}
  
			if ( NOT LEN(FORM.firstName) ) {
				SESSION.formErrors.Add('Please enter your first name');
			}
			
			// Vacation Dates
			if ( isDate(FORM.watStartVacation) AND isDate(FORM.watEndVacation) AND (FORM.watStartVacation GTE FORM.watEndVacation) ) {
				SESSION.formErrors.Add('Vacation must end after start date');
			}
			
			// Program Dates
			if ( isDate(FORM.programStart) AND isDate(FORM.programEnd) AND (FORM.programStart GTE FORM.programEnd) ) {
				SESSION.formErrors.Add('Program must end after start date');
			}
			
			// Check if there are no errors
			if ( NOT SESSION.formErrors.length() ) {				
				
				// Update Candidate Information
				APPLICATION.CFC.CANDIDATE.updateCandidate(
					candidateID = FORM.candidateID,
					lastName = FORM.lastName,
					firstName = FORM.firstName,
					middleName = FORM.middleName,
					sex = FORM.sex,
					dob = FORM.dobMonth & "/" & FORM.dobDay & "/" & FORM.dobYear,
					birth_city = FORM.birth_city,
					birth_country = FORM.birth_country,
					residence_country = FORM.residence_country,
					citizen_country = FORM.citizen_country,
					home_address = FORM.home_address,
					home_city = FORM.home_city,
					home_country = FORM.home_country,
					home_zip = FORM.home_zip,
					home_phone = FORM.home_phone,
					passport_number = FORM.passport_number,
					emergency_name = FORM.emergency_name,
					emergency_phone = FORM.emergency_phone,
					wat_vacation_start = FORM.watStartVacation,
					wat_vacation_end = FORM.watEndVacation,
					startDate = FORM.programStart,
					endDate = FORM.programEnd,
					wat_placement = FORM.wat_placement,
					wat_participation = FORM.wat_participation,
					ssn = APPLICATION.CFC.UDF.encryptVariable(FORM.SSN)
				);
				
				// Insert/Update Application Fields 
				for ( i=1; i LTE qGetQuestions.recordCount; i=i+1 ) {
					APPLICATION.CFC.ONLINEAPP.insertAnswer(	
						applicationQuestionID=qGetQuestions.ID[i],
						foreignTable=APPLICATION.foreignTable,
						foreignID=FORM.candidateID,
						fieldKey=qGetQuestions.fieldKey[i],
						answer=FORM[qGetQuestions.fieldKey[i]]						
					);	
				}
				
				// Update Candidate Session Variables
				APPLICATION.CFC.CANDIDATE.setCandidateSession(candidateID=FORM.candidateID);
				
				// Set Page Message
				SESSION.pageMessages.Add("Form successfully submitted.");
				
				// Reload page with updated information
				location("#CGI.SCRIPT_NAME#?action=initial&currentTabID=#FORM.currentTabID#", "no");
				
			}
			
		} else {
			
			// Set the default values of the FORM 
			// Personal Data
			FORM.firstName = qGetCandidateInfo.firstName;
			FORM.middleName = qGetCandidateInfo.middleName;
			FORM.lastName = qGetCandidateInfo.lastName;
			FORM.sex = qGetCandidateInfo.sex;
			FORM.dob = qGetCandidateInfo.dob;
			if ( IsDate(qGetCandidateInfo.dob) ) {
				FORM.dobMonth = Month(qGetCandidateInfo.dob);
				FORM.dobDay = Day(qGetCandidateInfo.dob);
				FORM.dobYear = Year(qGetCandidateInfo.dob);
			}
			FORM.birth_city = qGetCandidateInfo.birth_city;
			FORM.birth_country = qGetCandidateInfo.birth_country;
			FORM.residence_country = qGetCandidateInfo.residence_country;
			FORM.citizen_country = qGetCandidateInfo.citizen_country;
			FORM.home_address = qGetCandidateInfo.home_address;
			FORM.home_city = qGetCandidateInfo.home_city;
			FORM.home_country = qGetCandidateInfo.home_country;
			FORM.home_zip = qGetCandidateInfo.home_zip;
			// Break Down Phone Number
			stHomePhone = APPLICATION.CFC.UDF.breakDownPhoneNumber(qGetCandidateInfo.home_phone);
			FORM.homePhoneCountry = stHomePhone.countryCode;
			FORM.homePhoneArea = stHomePhone.areaCode;
			FORM.homePhonePrefix = stHomePhone.prefix;
			FORM.homePhoneNumber = stHomePhone.number;
			FORM.email = qGetCandidateInfo.email;
			FORM.passport_number = qGetCandidateInfo.passport_number;
			FORM.emergency_name = qGetCandidateInfo.emergency_name;
			// Break Down Phone Number
			stEmergencyPhone = APPLICATION.CFC.UDF.breakDownPhoneNumber(qGetCandidateInfo.emergency_phone);
			FORM.emergencyPhoneCountry = stEmergencyPhone.countryCode;
			FORM.emergencyPhoneArea = stEmergencyPhone.areaCode;
			FORM.emergencyPhonePrefix = stEmergencyPhone.prefix;
			FORM.emergencyPhoneNumber = stEmergencyPhone.number;
			// Dates of Official Vacation
			FORM.watStartVacation = qGetCandidateInfo.wat_vacation_start;
			if ( IsDate(qGetCandidateInfo.wat_vacation_start) ) {
				FORM.watStartVacationMonth = Month(qGetCandidateInfo.wat_vacation_start);
				FORM.watStartVacationDay = Day(qGetCandidateInfo.wat_vacation_start);
				FORM.watStartVacationYear = Year(qGetCandidateInfo.wat_vacation_start);
			}
			FORM.watEndVacation = qGetCandidateInfo.wat_vacation_end;
			if ( IsDate(qGetCandidateInfo.wat_vacation_end) ) {
				FORM.watEndVacationMonth = Month(qGetCandidateInfo.wat_vacation_end);
				FORM.watEndVacationDay = Day(qGetCandidateInfo.wat_vacation_end);
				FORM.watEndVacationYear = Year(qGetCandidateInfo.wat_vacation_end);
			}
			// Program Information
			FORM.programStart = qGetCandidateInfo.startDate;
			if ( IsDate(qGetCandidateInfo.startDate) ) {
				FORM.programStartMonth = Month(qGetCandidateInfo.startDate);
				FORM.programStartDay = Day(qGetCandidateInfo.startDate);
				FORM.programStartYear = Year(qGetCandidateInfo.startDate);
			}
			FORM.programEnd = qGetCandidateInfo.endDate;
			if ( IsDate(qGetCandidateInfo.endDate) ) {
				FORM.programEndMonth = Month(qGetCandidateInfo.endDate);
				FORM.programEndDay = Day(qGetCandidateInfo.endDate);
				FORM.programEndYear = Year(qGetCandidateInfo.endDate);
			}
			// Program Option
			FORM.wat_placement = qGetCandidateInfo.wat_placement;
			FORM.wat_participation = qGetCandidateInfo.wat_participation;
			FORM.emergency_phone = qGetCandidateInfo.emergency_phone;
			FORM.SSN = APPLICATION.CFC.UDF.decryptVariable(qGetCandidateInfo.SSN);
			// Break Down SSN
			stSSN = APPLICATION.CFC.UDF.breakDownSSN(FORM.SSN);
			FORM.ssnAreaNumber = stSSN.areaNumber;
			FORM.ssnGroupNumber = stSSN.groupNumber;
			FORM.ssnSerialNumber = stSSN.serialNumber;
			
			// Online Application Fields 
			for ( i=1; i LTE qGetAnswers.recordCount; i=i+1 ) {
				FORM[qGetAnswers.fieldKey[i]] = qGetAnswers.answer[i];
			}
			
		}
	</cfscript>
	
</cfsilent>

<script type="text/javascript">
	// Date picker
	$(function() {
		$(".datepicker").datepicker();
	});	

	// JQuery Validator
	$().ready(function() {
		
		// Get current program option
		selectedOption = $(":radio[name=wat_placement]").filter(":checked").val();
		// Display Request Placement
		showHideRequestPlacement(selectedOption);
	
		// Ajax Image Upload
		var thumb = $('img#thumb');	
		var candidateID = $('#candidateID').val();
		
		new AjaxUpload('imageUpload', {
			action: 'imageUploadPreview.cfm?candidateID='+candidateID,
			name: 'image',
			onSubmit: function(file, extension) {
				$('.pictureMessage').html("<p class='loading'>Uploading Image...</p>");
				$(".pictureMessage").fadeIn();
			},
			onComplete: function(file, response) {
				thumb.load(function(){
					$('.pictureMessage').html("<p>Image successfully uploaded</p>");
					$(".pictureMessage").fadeOut(5000);
					thumb.unbind();
				});				
				response = $.trim(response)
				
				// Not a valid image file
				if ( response == '' ) {
					$('.pictureMessage').html("<p class='error'>Error - Please upload a valid image file</p>");
					$(".pictureMessage").fadeOut(5000);				
				} else {
					//console.log('thumbnailpreview.cfm?file='+escape(response))
					// hack about adding a query string on an image src to force it to reload instead of using the cached version.
					var timestamp = new Date().getTime();
					$("#thumb").attr("src", 'imageUploadPreview.cfm?file='+escape(response)+'&'+timestamp );
				}
			}
		});
	
	});
</script>

<cfoutput>

<!--- Application Body --->
<div class="form-container">
  
  	<!--- Only Display Messages if Current tab is updated --->
  	<cfif currentTabID EQ 0>
    
		<!--- Page Messages --->
        <gui:displayPageMessages 
            pageMessages="#SESSION.pageMessages.GetCollection()#"
            messageType="section"
            />
        
        <!--- Form Errors --->
        <gui:displayFormErrors 
            formErrors="#SESSION.formErrors.GetCollection()#"
            messageType="section"
            />
		
	</cfif>
       
    <form id="section1Form" action="#CGI.SCRIPT_NAME#?action=initial" method="post">
    <input type="hidden" name="submittedType" value="section1" />
    <input type="hidden" name="currentTabID" value="0" />
    <input type="hidden" name="candidateID" id="candidateID" value="#FORM.candidateID#" />
    
    <p class="legend"><strong>Note:</strong> Required fields are marked with an asterisk (<em>*</em>)</p>
        
    <!--- Personal Data --->
    <fieldset>
       
        <legend>Personal Data</legend>
		
        <!--- Picture --->	
        <div class="field">
        	<label for="lastName">Picture <em>*</em></label> 
        	            
            <div class="pictureMessage"></div>
            
            <div class="divPicture">	            
				<cfif candidatePicture.recordCount>
                    <img id="thumb" src="../../uploadedfiles/web-candidates/#candidatePicture.name#">
                <cfelse>
                    <img id="thumb" width="150" height="150" src="../../pics/onlineApp/noPicture.jpg">
                </cfif>            
            </div>

            <p class="note">(smiling - max size 2mb)</p>
            
            <div class="divUploadPicture" <cfif printApplication> style="display:none;" </cfif> >
                <input type="image" name="imageUpload" id="imageUpload" src="../../pics/onlineApp/uploadpic.gif"><br/>
            </div>
                         
        </div>
        
        <!--- Family Name --->
        <div class="field">
            <label for="lastName">Family Name <em>*</em></label> 
            <cfif printApplication>
				<div class="printField">#FORM.lastName# &nbsp;</div>
        	<cfelse>
				<input type="text" name="lastName" id="lastName" value="#FORM.lastName#" class="largeField" maxlength="100" />
            </cfif>            
        </div>

        <!--- First Name --->
        <div class="field">
            <label for="firstName">First Name <em>*</em></label> 
            <cfif printApplication>
            	<div class="printField">#FORM.firstName# &nbsp;</div>
        	<cfelse>
            	<input type="text" name="firstName" id="firstName" value="#FORM.firstName#" class="largeField" maxlength="100" /> <!--- class="error" --->
            </cfif>
        </div>

        <!--- Middle Name --->
        <div class="field">
            <label for="middleName">Middle Name</label> 
            <cfif printApplication>
				<div class="printField">#FORM.middleName# &nbsp;</div>
        	<cfelse>
				<input type="text" name="middleName" id="middleName" value="#FORM.middleName#" class="largeField" maxlength="100" />
            </cfif>            
        </div>

        <!--- Gender --->
        <div class="field">
            <label for="sex">Gender <em>*</em></label> 
            <cfif printApplication>
				<cfif FORM.sex EQ 'M'>
                	<div class="printField">Male &nbsp;</div>
                <cfelseif FORM.sex EQ 'F'>
                	<div class="printField">Female &nbsp;</div>
                </cfif>
        	<cfelse>
                <select name="sex" id="sex" class="smallField">
                    <option value=""></option> <!--- [select your gender] --->
                    <option value="M" <cfif FORM.sex EQ 'M'> selected="selected" </cfif> >Male</option>
                    <option value="F" <cfif FORM.sex EQ 'F'> selected="selected" </cfif> >Female</option>
                </select>
            </cfif>            
        </div>
        
        <!--- Date of Birth --->
        <div class="field">
            <label for="dobMonth">Date of Birth <em>*</em></label> 
            <cfif printApplication>
				<div class="printField">
                	<cfif isDate(FORM.dob)>
                    	#MonthAsString(FORM.dobMonth)#/#FORM.dobDay#/#FORM.dobYear#
                    </cfif> &nbsp;
                </div>
        	<cfelse>
                <select name="dobMonth" id="dobMonth" class="smallField">
                    <option value=""></option>
                    <cfloop from="1" to="12" index="i">
                        <option value="#i#" <cfif FORM.dobMonth EQ i> selected="selected" </cfif> >#MonthAsString(i)#</option>
                    </cfloop>
                </select>
                /
                <select name="dobDay" id="dobDay" class="xxSmallField">
                    <option value=""></option>
                    <cfloop from="1" to="31" index="i">
                        <option value="#i#" <cfif FORM.dobDay EQ i> selected="selected" </cfif> >#i#</option>
                    </cfloop>
                </select>
                / 
                <select name="dobYear" id="dobYear" class="xSmallField">
                    <option value=""></option>
                    <cfloop from="#Year(now())-10#" to="#Year(now())-90#" index="i" step="-1">
                        <option value="#i#" <cfif FORM.dobYear EQ i> selected="selected" </cfif> >#i#</option>
                    </cfloop>
                </select> 
                <!--- <p class="note">(mm/dd/yyyy)</p> --->               
            </cfif>            
        </div>
		
        <!--- Place of Birth --->
        <div class="field">
            <label for="birth_city">Place of Birth <em>*</em></label> 
            <cfif printApplication>
				<div class="printField">#FORM.birth_city# &nbsp;</div>
        	<cfelse>
				<input type="text" name="birth_city" id="birth_city" value="#FORM.birth_city#" class="largeField" maxlength="100" />
            </cfif>            
        </div>
        
        <!--- Country of Birth --->
        <div class="field">
            <label for="birth_country">Country of Birth <em>*</em></label> 
            <cfif printApplication>
				<div class="printField">#APPLICATION.CFC.LOOKUPTABLES.getCountryByID(ID=FORM.birth_country).countryName# &nbsp;</div>
        	<cfelse>
                <select name="birth_country" id="birth_country" class="mediumField">
                    <option value=""></option> <!--- [select a country] ---->
                    <cfloop query="qGetCountry">
                        <option value="#qGetCountry.countryID#" <cfif FORM.birth_country EQ qGetCountry.countryID> selected="selected" </cfif> >#qGetCountry.countryName#</option>
                    </cfloop>
                </select>
            </cfif>            
        </div>

        <!--- Country of Legal Permanent Residence --->
        <div class="field">
            <label for="residence_country">Country of Legal Permanent Residence <em>*</em></label> 
            <cfif printApplication>
				<div class="printField">#APPLICATION.CFC.LOOKUPTABLES.getCountryByID(ID=FORM.residence_country).countryName# &nbsp;</div>
        	<cfelse>
                <select name="residence_country" id="residence_country" class="mediumField">
                    <option value=""></option>
                    <cfloop query="qGetCountry">
                        <option value="#qGetCountry.countryID#" <cfif FORM.residence_country EQ qGetCountry.countryID> selected="selected" </cfif> >#qGetCountry.countryName#</option>
                    </cfloop>
                </select>
            </cfif>            
        </div>

		<div style="clear:both;"></div>
		
        <!--- Country of Citizenship --->
        <div class="field">
            <label for="citizen_country">Country of Citizenship <em>*</em></label> 
            <cfif printApplication>
				<div class="printField">#APPLICATION.CFC.LOOKUPTABLES.getCountryByID(ID=FORM.citizen_country).countryName# &nbsp;</div>
        	<cfelse>
                <select name="citizen_country" id="citizen_country" class="mediumField">
                    <option value=""></option>
                    <cfloop query="qGetCountry">
                        <option value="#qGetCountry.countryID#" <cfif FORM.citizen_country EQ qGetCountry.countryID> selected="selected" </cfif> >#qGetCountry.countryName#</option>
                    </cfloop>
                </select>
            </cfif>            
        </div>

        <!--- Mailing Address --->
        <div class="field">
            <label for="home_address">Mailing Address <em>*</em></label> 
            <cfif printApplication>
            	<div class="printField">#FORM.home_address# &nbsp;</div>
        	<cfelse>
            	<input type="text" name="home_address" id="home_address" value="#FORM.home_address#" class="largeField" maxlength="100" />
            </cfif>
        </div>

        <!--- City --->
        <div class="field">
            <label for="home_city">City <em>*</em></label> 
            <cfif printApplication>
            	<div class="printField">#FORM.home_city# &nbsp;</div>
        	<cfelse>
            	<input type="text" name="home_city" id="home_city" value="#FORM.home_city#" class="largeField" maxlength="100" />
            </cfif>
        </div>

        <!--- Country --->
        <div class="field">
            <label for="home_country">Country <em>*</em></label> 
            <cfif printApplication>
				<div class="printField">#APPLICATION.CFC.LOOKUPTABLES.getCountryByID(ID=FORM.birth_country).countryName# &nbsp;</div>
        	<cfelse>
                <select name="home_country" id="home_country" class="mediumField">
                    <option value=""></option>
                    <cfloop query="qGetCountry">
                        <option value="#qGetCountry.countryID#" <cfif FORM.home_country EQ qGetCountry.countryID> selected="selected" </cfif> >#qGetCountry.countryName#</option>
                    </cfloop>
                </select>
            </cfif>            
        </div>

        <!--- Zip Code --->
        <div class="field">
            <label for="home_zip">Zip Code </label> 
            <cfif printApplication>
            	<div class="printField">#FORM.home_zip# &nbsp;</div>
        	<cfelse>
            	<input type="text" name="home_zip" id="home_zip" value="#FORM.home_zip#" class="smallField" maxlength="20" />
            </cfif>
        </div>

        <!--- Telephone Number --->
        <div class="field">
            <label for="homePhoneCountry">Telephone Number </label> 
            <cfif printApplication>
				<div class="printField">
                	#APPLICATION.CFC.UDF.formatPhoneNumber(
                    	countryCode=FORM.homePhoneCountry, 
                        areaCode=FORM.homePhoneArea, 
                        prefix=FORM.homePhonePrefix, 
                        number=FORM.homePhoneNumber)# &nbsp;
				</div>
        	<cfelse>
                <input type="text" name="homePhoneCountry" id="homePhoneCountry" value="#FORM.homePhoneCountry#" class="xxSmallField" maxlength="4" /> 
                -
                <input type="text" name="homePhoneArea" id="homePhoneArea" value="#FORM.homePhoneArea#" class="xxSmallField" maxlength="4" />                  
                - 
                <input type="text" name="homePhonePrefix" id="homePhonePrefix" value="#FORM.homePhonePrefix#" class="xxSmallField" maxlength="4" /> 
                - 
                <input type="text" name="homePhoneNumber" id="homePhoneNumber" value="#FORM.homePhoneNumber#" class="xxSmallField" maxlength="6" />
                <p class="note"> 
                    <span class="phoneNote">country</span> 
                    <span class="phoneNote">area</span>  
                    <span class="phoneNote">prefix</span> 
                    <span class="phoneNote">number</span>
                </p>
            </cfif>            
        </div>

        <!--- Email Address --->
        <div class="field">
            <label for="email">Email Address <em>*</em></label> 
            <cfif printApplication>
				<div class="printField">#FORM.email# &nbsp;</div>
        	<cfelse>
                <input type="text" name="email" id="email" value="#FORM.email#" class="largeField" maxlength="100" disabled="disabled" />
                <p class="note">Click on Update Login to update your email address.</p>
            </cfif>            
        </div>

        <!--- Passport Number --->
        <div class="field">
            <label for="passport_number">Passport Number <em>*</em></label> 
            <cfif printApplication>
				<div class="printField">#FORM.passport_number# &nbsp;</div>
        	<cfelse>
				<input type="text" name="passport_number" id="passport_number" value="#FORM.passport_number#" class="largeField" maxlength="100" />
            </cfif>            
        </div>
		
        <!--- University Name | Original Key [8] --->
        <div class="field">
            <label for="#qGetQuestions.fieldKey[1]#">#qGetQuestions.displayField[1]# <cfif qGetQuestions.isRequired[1]><em>*</em></cfif></label>  
            <cfif printApplication>
				<div class="printField">#FORM[qGetQuestions.fieldKey[1]]# &nbsp;</div>
        	<cfelse>
	            <input type="text" name="#qGetQuestions.fieldKey[1]#" id="#qGetQuestions.fieldKey[1]#" value="#FORM[qGetQuestions.fieldKey[1]]#" class="#qGetQuestions.classType[1]#" maxlength="50" />
            </cfif>            
        </div>

		<!--- Emergency Contact Name --->
        <div class="field">
            <label for="emergency_name">Emergency Contact Name <em>*</em></label> 
            <cfif printApplication>
				<div class="printField">#FORM.emergency_name# &nbsp;</div>
        	<cfelse>
				<input type="text" name="emergency_name" id="emergency_name" value="#FORM.emergency_name#" class="largeField " maxlength="100" />
            </cfif>            
        </div>
		
        <!--- Emergency Telephone Number --->
        <div class="field">
            <label for="emergencyPhoneCountry">Emergency Telephone Number <em>*</em></label> 
            <cfif printApplication>
				<div class="printField">
                	#APPLICATION.CFC.UDF.formatPhoneNumber(
                    	countryCode=FORM.emergencyPhoneCountry, 
                        areaCode=FORM.emergencyPhoneArea, 
                        prefix=FORM.emergencyPhonePrefix, 
                        number=FORM.emergencyPhoneNumber)# &nbsp;
				</div>
        	<cfelse>
                <input type="text" name="emergencyPhoneCountry" id="emergencyPhoneCountry" value="#FORM.emergencyPhoneCountry#" class="xxSmallField" maxlength="4" /> 
                -
                <input type="text" name="emergencyPhoneArea" id="emergencyPhoneArea" value="#FORM.emergencyPhoneArea#" class="xxSmallField" maxlength="4" />                  
                - 
                <input type="text" name="emergencyPhonePrefix" id="emergencyPhonePrefix" value="#FORM.emergencyPhonePrefix#" class="xxSmallField" maxlength="4" /> 
                - 
                <input type="text" name="emergencyPhoneNumber" id="emergencyPhoneNumber" value="#FORM.emergencyPhoneNumber#" class="xxSmallField" maxlength="6" />
                <p class="note"> 
                    <span class="phoneNote">country</span> 
                    <span class="phoneNote">area</span>  
                    <span class="phoneNote">prefix</span> 
                    <span class="phoneNote">number</span>
                </p>
            </cfif>            
        </div>

    </fieldset>
    

    <!--- Dates of Official Vacation --->
    <fieldset>
       
        <legend>DATES OF OFFICIAL VACATION</legend>

        <!--- Start Date --->
        <div class="field">
            <label for="watStartVacationMonth">Start Date <em>*</em></label> 
            <cfif printApplication>
				<div class="printField">
                	<cfif isDate(FORM.watStartVacation)>
                    	#MonthAsString(FORM.watStartVacationMonth)#/#FORM.watStartVacationDay#/#FORM.watStartVacationYear# 
                    </cfif>    
                    &nbsp;
                </div>
        	<cfelse>
                <select name="watStartVacationMonth" id="watStartVacationMonth" class="smallField">
                    <option value=""></option>
                    <cfloop from="1" to="12" index="i">
                        <option value="#i#" <cfif FORM.watStartVacationMonth EQ i> selected="selected" </cfif> >#MonthAsString(i)#</option>
                    </cfloop>
                </select>
                /
                <select name="watStartVacationDay" id="watStartVacationDay" class="xxSmallField">
                    <option value=""></option>
                    <cfloop from="1" to="31" index="i">
                        <option value="#i#" <cfif FORM.watStartVacationDay EQ i> selected="selected" </cfif> >#i#</option>
                    </cfloop>
                </select>
                / 
                <select name="watStartVacationYear" id="watStartVacationYear" class="xSmallField">
                    <option value=""></option>
                    <cfloop from="#Year(now())+3#" to="#Year(now())#" index="i" step="-1">
                        <option value="#i#" <cfif FORM.watStartVacationYear EQ i> selected="selected" </cfif> >#i#</option>
                    </cfloop>
                </select> 
                <!--- <p class="note">(mm/dd/yyyy)</p> --->               
            </cfif>            
        </div>

        <!--- End Date  --->
        <div class="field">
            <label for="watEndVacationMonth">End Date <em>*</em></label> 
            <cfif printApplication>
				<div class="printField">
                	<cfif isDate(FORM.watEndVacation)>
                    	#MonthAsString(FORM.watEndVacationMonth)#/#FORM.watEndVacationDay#/#FORM.watEndVacationYear# 
                    </cfif>
                    &nbsp;
                </div>
        	<cfelse>
                <select name="watEndVacationMonth" id="watEndVacationMonth" class="smallField">
                    <option value=""></option>
                    <cfloop from="1" to="12" index="i">
                        <option value="#i#" <cfif FORM.watEndVacationMonth EQ i> selected="selected" </cfif> >#MonthAsString(i)#</option>
                    </cfloop>
                </select>
                /
                <select name="watEndVacationDay" id="watEndVacationDay" class="xxSmallField">
                    <option value=""></option>
                    <cfloop from="1" to="31" index="i">
                        <option value="#i#" <cfif FORM.watEndVacationDay EQ i> selected="selected" </cfif> >#i#</option>
                    </cfloop>
                </select>
                / 
                <select name="watEndVacationYear" id="watEndVacationYear" class="xSmallField">
                    <option value=""></option>
                    <cfloop from="#Year(now())+3#" to="#Year(now())#" index="i" step="-1">
                        <option value="#i#" <cfif FORM.watEndVacationYear EQ i> selected="selected" </cfif> >#i#</option>
                    </cfloop>
                </select> 
                <!--- <p class="note">(mm/dd/yyyy)</p> --->               
            </cfif>            
        </div>

    </fieldset>    
    
    
    <!--- Program Information --->
    <fieldset>
       
        <legend>PROGRAM INFORMATION</legend>

        <!--- Start Date --->
        <div class="field">
            <label for="programStartMonth">Start Date <em>*</em></label> 
            <cfif printApplication>
				<div class="printField">
                	<cfif isDate(FORM.programStart)>
                    	#MonthAsString(FORM.programStartMonth)#/#FORM.programStartDay#/#FORM.programStartYear# 
                    </cfif>
                	&nbsp;
                </div>
        	<cfelse>
                <select name="programStartMonth" id="programStartMonth" class="smallField">
                    <option value=""></option>
                    <cfloop from="1" to="12" index="i">
                        <option value="#i#" <cfif FORM.programStartMonth EQ i> selected="selected" </cfif> >#MonthAsString(i)#</option>
                    </cfloop>
                </select>
                /
                <select name="programStartDay" id="programStartDay" class="xxSmallField">
                    <option value=""></option>
                    <cfloop from="1" to="31" index="i">
                        <option value="#i#" <cfif FORM.programStartDay EQ i> selected="selected" </cfif> >#i#</option>
                    </cfloop>
                </select>
                / 
                <select name="programStartYear" id="programStartYear" class="xSmallField">
                    <option value=""></option>
                    <cfloop from="#Year(now())+3#" to="#Year(now())#" index="i" step="-1">
                        <option value="#i#" <cfif FORM.programStartYear EQ i> selected="selected" </cfif> >#i#</option>
                    </cfloop>
                </select> 
                <!--- <p class="note">(mm/dd/yyyy)</p> --->               
            </cfif>            
        </div>

        <!--- End Date --->
        <div class="field">
            <label for="programEndMonth">End Date <em>*</em></label> 
            <cfif printApplication>
				<div class="printField">
                	<cfif isDate(FORM.programEnd)>
                    	#MonthAsString(FORM.programEndMonth)#/#FORM.programEndDay#/#FORM.programEndYear# 
                    </cfif>
                    &nbsp;
                </div>
        	<cfelse>
                <select name="programEndMonth" id="programEndMonth" class="smallField">
                    <option value=""></option>
                    <cfloop from="1" to="12" index="i">
                        <option value="#i#" <cfif FORM.programEndMonth EQ i> selected="selected" </cfif> >#MonthAsString(i)#</option>
                    </cfloop>
                </select>
                /
                <select name="programEndDay" id="programEndDay" class="xxSmallField">
                    <option value=""></option>
                    <cfloop from="1" to="31" index="i">
                        <option value="#i#" <cfif FORM.programEndDay EQ i> selected="selected" </cfif> >#i#</option>
                    </cfloop>
                </select>
                / 
                <select name="programEndYear" id="programEndYear" class="xSmallField">
                    <option value=""></option>
                    <cfloop from="#Year(now())+3#" to="#Year(now())#" index="i" step="-1">
                        <option value="#i#" <cfif FORM.programEndYear EQ i> selected="selected" </cfif> >#i#</option>
                    </cfloop>
                </select> 
                <!--- <p class="note">(mm/dd/yyyy)</p> --->               
            </cfif>            
        </div>

    </fieldset>    


    <!--- Program Option --->
    <fieldset>
       
        <legend>PROGRAM OPTION</legend>

		<!--- Program Option --->
		<div class="field controlset">
			<span class="label">Program Option <em>*</em></span>
            <cfif printApplication>
            	<div class="printFieldOption">
                    <span class="printFieldCheck#YesNoFormat(ListFind(FORM.wat_placement, 'CSB-Placement'))#"> CSB-Placement </span>
                    <span class="printFieldCheck#YesNoFormat(ListFind(FORM.wat_placement, 'Self-Placement'))#"> Self-Placement </span>
                    <span class="printFieldCheck#YesNoFormat(ListFind(FORM.wat_placement, 'Walk-In'))#"> Walk-In </span>
                </div>
        	<cfelse>
        		<div class="field">
                    <input type="radio" name="wat_placement" id="CSB-Placement" value="CSB-Placement" onclick="showHideRequestPlacement(this.value);" class="{validate:{required:true}}" <cfif ListFind(FORM.wat_placement, 'CSB-Placement')> checked="checked" </cfif> /> 
                    <label for="CSB-Placement">CSB International, Inc. - Placement</label>
                </div>
				
				<!--- Requested Placement | Original Key [16] --->
                <div id="divRequestPlacement" class="field hiddenField">
                    <label for="#qGetQuestions.fieldKey[2]#">#qGetQuestions.displayField[2]# <cfif qGetQuestions.isRequired[2]><em>*</em></cfif></label>  
                    <cfif printApplication>
                        <div class="printField">#FORM[qGetQuestions.fieldKey[2]]# &nbsp;</div>
                    <cfelse>
                        <input type="text" name="#qGetQuestions.fieldKey[2]#" id="#qGetQuestions.fieldKey[2]#" value="#FORM[qGetQuestions.fieldKey[2]]#" class="#qGetQuestions.classType[2]#" maxlength="50" />
                    </cfif>            
                </div>

        		<div class="field">
                    <input type="radio" name="wat_placement" id="Self-Placement" value="Self-Placement" onclick="showHideRequestPlacement(this.value);" class="{validate:{required:true}}" <cfif ListFind(FORM.wat_placement, 'Self-Placement')> checked="checked" </cfif> /> 
                    <label for="Self-Placement">Self-Placement - Please attach the signed job offer form for verification of your employment</label>
                </div>
        		
                <div class="field">
                    <input type="radio" name="wat_placement" id="Walk-In" value="Walk-In" onclick="showHideRequestPlacement(this.value);" class="{validate:{required:true}}" <cfif ListFind(FORM.wat_placement, 'Walk-In')> checked="checked" </cfif> /> 
                    <label for="Walk-In">Walk-In - (Limited - Valid solely for Argentina and Brazil)</label>
                </div>
            </cfif>
		</div>			

        <!--- Number of previous participations in the program --->
        <div class="field">
            <label for="wat_participation">Number of previous participations in the program <em>*</em></label> 
            <cfif printApplication>
				<div class="printField"><cfif LEN(FORM.wat_participation)>#FORM.wat_participation# time(s)</cfif> &nbsp;</div>
        	<cfelse>
                <select name="wat_participation" id="wat_participation" class="smallField">
                    <option value=""></option>
                    <cfloop from="0" to="15" index="i">
                        <option value="#i#" <cfif FORM.wat_participation EQ i> selected="selected" </cfif> >#i# time(s)</option>
                    </cfloop>
                </select>
            </cfif>            
        </div>
        <p class="note">(Regardless of sponsor - Please select 0 if this is the first one)</p>

        <!--- Social Security Number --->
        <div class="field">
            <label for="ssnAreaNumber">Social Security Number </label> 
            <cfif printApplication>
				<div class="printField">
                	<cfif LEN(FORM.SSN)> #FORM.SSN# <cfelse> n/a </cfif> &nbsp;
				</div>
        	<cfelse>
                <input type="text" name="ssnAreaNumber" id="ssnAreaNumber" value="#FORM.ssnAreaNumber#" class="xxSmallField" maxlength="3" /> 
                -
                <input type="text" name="ssnGroupNumber" id="ssnGroupNumber" value="#FORM.ssnGroupNumber#" class="xxxSmallField" maxlength="2" />                  
                - 
                <input type="text" name="ssnSerialNumber" id="ssnSerialNumber" value="#FORM.ssnSerialNumber#" class="xxSmallField" maxlength="4" /> 
                <p class="note">(if applicable - xxx - xx - xxxx )</p>
            </cfif>            
        </div>

    </fieldset>    
    	
    <!--- Save Button --->
    <cfif NOT printApplication>
        <div class="buttonrow">
            <input type="submit" value="Save" class="button ui-corner-top" />
        </div>
	</cfif>
    
    </form>

</div><!-- /form-container -->

</cfoutput>