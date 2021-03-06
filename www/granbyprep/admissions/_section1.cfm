<!--- ------------------------------------------------------------------------- ----
	
	File:		_section1.cfm
	Author:		Marcus Melo
	Date:		June 14, 2010
	Desc:		Section 1 of the Online Application

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
    
	<!--- It is set to 1 for the print application page --->
	<cfparam name="printApplication" default="0">
    
	<!--- Param FORM Variables --->
    <cfparam name="FORM.submittedType" default="">
    <cfparam name="FORM.currentTabID" default="0">
    <!--- Student Details --->
    <cfparam name="FORM.studentID" default="#APPLICATION.CFC.STUDENT.getStudentID()#">
	<cfparam name="FORM.firstName" default="">
	<cfparam name="FORM.middleName" default="">
	<cfparam name="FORM.lastName" default="">
	<cfparam name="FORM.preferredName" default="">
    <cfparam name="FORM.gender" default="">
    <cfparam name="FORM.dobMonth" default="">
    <cfparam name="FORM.dobDay" default="">
    <cfparam name="FORM.dobYear" default="">
    <cfparam name="FORM.countryBirthID" default="">
    <cfparam name="FORM.countryCitizenID" default="">
	<!--- Contact Information ---> 
    <cfparam name="FORM.email" default="">
    <cfparam name="FORM.homePhoneCountry" default="">
    <cfparam name="FORM.homePhoneArea" default="">
    <cfparam name="FORM.homePhonePrefix" default="">
    <cfparam name="FORM.homePhoneNumber" default="">
    <cfparam name="FORM.faxCountry" default="">
    <cfparam name="FORM.faxArea" default="">
    <cfparam name="FORM.faxPrefix" default="">
    <cfparam name="FORM.faxNumber" default="">

    <cfscript>
		// Get Current Student Information
		// qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(ID=FORM.studentID);

		// Get Questions for this section
		qGetQuestionsSection1 = APPLICATION.CFC.ONLINEAPP.getQuestionByFilter(sectionName='section1');
		
		// Get Answers for this section
		qGetAnswersSection1 = APPLICATION.CFC.ONLINEAPP.getAnswerByFilter(sectionName='section1', foreignTable='student', foreignID=FORM.studentID);

		// Param Online Application Form Variables 
		for ( i=1; i LTE qGetQuestionsSection1.recordCount; i=i+1 ) {
			param name="FORM[qGetQuestionsSection1.fieldKey[i]]" default="";
		}

		// Gets a List of States
		qGetStates = APPLICATION.CFC.LOOKUPTABLES.getState();

		// Get Current Student Information
		qGetCountry = APPLICATION.CFC.LOOKUPTABLES.getCountry();

		// FORM Submitted
		if ( FORM.submittedType EQ 'section1' ) {

			// Parent Phone
			FORM[qGetQuestionsSection1.fieldKey[8]] = APPLICATION.CFC.UDF.formatPhoneNumber(countryCode=FORM.homePhoneCountry, areaCode=FORM.homePhoneArea, prefix=FORM.homePhonePrefix, number=FORM.homePhoneNumber);
			// Parent Fax
			FORM[qGetQuestionsSection1.fieldKey[9]] = APPLICATION.CFC.UDF.formatPhoneNumber(countryCode=FORM.faxCountry, areaCode=FORM.faxArea, prefix=FORM.faxPrefix, number=FORM.faxNumber);					

			// FORM Validation
			if ( NOT LEN(FORM.firstName) ) {
				SESSION.formErrors.Add("Please enter your first name");
			}

			if ( NOT LEN(FORM.lastName) ) {
				SESSION.formErrors.Add("Please enter your last name");
			}

			if ( NOT LEN(FORM.gender) ) {
				SESSION.formErrors.Add("Please select a gender");
			}

			if ( NOT LEN(FORM.dobMonth) OR NOT LEN(FORM.dobDay) OR NOT LEN(FORM.dobYear) ) {
				SESSION.formErrors.Add("Please select your date of birth");
			}
			
			if ( NOT IsDate(FORM.dobMonth & '/' & FORM.dobDay & '/' & FORM.dobYear) ) {
				SESSION.formErrors.Add("Please select a valid date of birth");
			}

			if ( NOT VAL(FORM.countryBirthID) ) {
				SESSION.formErrors.Add("Please select a country of birth");
			}

			if ( NOT VAL(FORM.countryCitizenID) ) {
				SESSION.formErrors.Add("Please select a country of citizenship");
			}

			for ( i=1; i LTE qGetQuestionsSection1.recordCount; i=i+1 ) {
				if (qGetQuestionsSection1.isRequired[i] AND NOT LEN(FORM[qGetQuestionsSection1.fieldKey[i]]) ) {
					SESSION.formErrors.Add(qGetQuestionsSection1.requiredMessage[i]);
				}
			}

			// Check if there are no errors
			if ( NOT SESSION.formErrors.length() ) {				
				
				// Update Student Information
				APPLICATION.CFC.STUDENT.updateStudent(
					ID = FORM.studentID,
					firstName = FORM.firstName,
					middleName = FORM.middleName,
					lastName = FORM.lastName,
					preferredName = FORM.preferredName,
					gender = FORM.gender,
					dob = FORM.dobMonth & "/" & FORM.dobDay & "/" & FORM.dobYear,
					countryBirthID = FORM.countryBirthID,
					countryCitizenID = FORM.countryCitizenID
				);
				
				// Insert/Update Application Fields 
				for ( i=1; i LTE qGetQuestionsSection1.recordCount; i=i+1 ) {
					APPLICATION.CFC.ONLINEAPP.insertAnswer(	
						applicationQuestionID=qGetQuestionsSection1.ID[i],
						foreignTable='student',
						foreignID=FORM.studentID,
						fieldKey=qGetQuestionsSection1.fieldKey[i],
						answer=FORM[qGetQuestionsSection1.fieldKey[i]]						
					);	
				}
				
				// Update Student Session Variables
				APPLICATION.CFC.STUDENT.setStudentSession(ID=FORM.studentID);
				
				// Set Page Message
				SESSION.pageMessages.Add("Form successfully submitted.");
				
				// Reload page with updated information
				location("#CGI.SCRIPT_NAME#?action=initial&currentTabID=#FORM.currentTabID#", "no");
				
			}
			
		} else {
			
			// Set the default values of the FORM 
			FORM.firstName = qGetStudentInfo.firstName;
			FORM.middleName = qGetStudentInfo.middleName;
			FORM.lastName = qGetStudentInfo.lastName;
			FORM.preferredName = qGetStudentInfo.preferredName;
			FORM.gender = qGetStudentInfo.gender;
			if ( IsDate(qGetStudentInfo.dob) ) {
				FORM.dobMonth = Month(qGetStudentInfo.dob);
				FORM.dobDay = Day(qGetStudentInfo.dob);
				FORM.dobYear = Year(qGetStudentInfo.dob);
			}
			FORM.countryBirthID = qGetStudentInfo.countryBirthID;
			FORM.countryCitizenID = qGetStudentInfo.countryCitizenID;
			FORM.email = qGetStudentInfo.email;

			// Online Application Fields 
			for ( i=1; i LTE qGetAnswersSection1.recordCount; i=i+1 ) {
				FORM[qGetAnswersSection1.fieldKey[i]] = qGetAnswersSection1.answer[i];
			}

			// Break Down Phone Numbers
			stHomePhone = APPLICATION.CFC.UDF.breakDownPhoneNumber(qGetAnswersSection1.answer[8]);
			stFax = APPLICATION.CFC.UDF.breakDownPhoneNumber(qGetAnswersSection1.answer[9]);
			
			FORM.homePhoneCountry = stHomePhone.countryCode;
			FORM.homePhoneArea = stHomePhone.areaCode;
			FORM.homePhonePrefix = stHomePhone.prefix;
			FORM.homePhoneNumber = stHomePhone.number;
			FORM.faxCountry = stFax.countryCode;
			FORM.faxArea = stFax.areaCode;
			FORM.faxPrefix = stFax.prefix;
			FORM.faxNumber = stFax.number;
			
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
		var container = $('div.errorContainer');
		// validate the form when it is submitted
		var validator = $("#section1Form").validate({
			errorContainer: container,
			errorLabelContainer: $("ol", container),
			wrapper: 'li',
			meta: "validate"
		});
	
	});
</script>

<cfoutput>

<!---  Our jQuery error container --->
<div class="errorContainer">
	<p><em>Oops... the following errors were encountered:</em></p>
					
	<ol>
		<li><label for="firstName" class="error">Please enter your first name</label></li>  
		<li><label for="lastName" class="error">Please enter your last name</label></li>  
		<li><label for="gender" class="error">Please select a gender</label></li>  
		<li><label for="dobMonth" class="error">Please select your month of birth</label></li>  
		<li><label for="dobDay" class="error">Please select your day of birth</label></li>  
		<li><label for="dobYear" class="error">Please select your year of birth</label></li>                  
		<li><label for="countryBirthID" class="error">Please select a country of birth</label></li>                  
		<li><label for="countryCitizenID" class="error">Please select a country of citizenship</label></li>                  
		<cfloop query="qGetQuestionsSection1">
        	<cfif qGetQuestionsSection1.isRequired>
				<li><label for="#qGetQuestionsSection1.fieldKey#" class="error">#qGetQuestionsSection1.requiredMessage#</label></li>
            </cfif>
		</cfloop>
	</ol>
	
	<p>Data has <strong>not</strong> been saved.</p>
</div>

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
    
    <p class="legend"><strong>Note:</strong> Required fields are marked with an asterisk (<em>*</em>)</p>
    
    <!--- Student Details --->
    <fieldset>
       
        <legend>Student Details</legend>
            
        <div class="field">
            <label for="firstName">First Name <em>*</em></label> 
            <cfif printApplication>
            	<div class="printField">#FORM.firstName# &nbsp;</div>
        	<cfelse>
            	<input type="text" name="firstName" id="firstName" value="#FORM.firstName#" class="largeField {validate:{required:true}}" maxlength="100" /> <!--- class="error" --->
            </cfif>
        </div>

        <div class="field">
            <label for="middleName">Middle Name</label> 
            <cfif printApplication>
				<div class="printField">#FORM.middleName# &nbsp;</div>
        	<cfelse>
				<input type="text" name="middleName" id="middleName" value="#FORM.middleName#" class="largeField" maxlength="100" />
            </cfif>            
        </div>

        <div class="field">
            <label for="lastName">Family Name <em>*</em></label> 
            <cfif printApplication>
				<div class="printField">#FORM.lastName# &nbsp;</div>
        	<cfelse>
				<input type="text" name="lastName" id="lastName" value="#FORM.lastName#" class="largeField {validate:{required:true}}" maxlength="100" />
            </cfif>            
        </div>

        <div class="field">
            <label for="preferredName">Preferred Name or Nickname</label> 
            <cfif printApplication>
				<div class="printField">#FORM.preferredName# &nbsp;</div>
        	<cfelse>
                <input type="text" name="preferredName" id="preferredName" value="#FORM.preferredName#" class="largeField" maxlength="100" />
            </cfif>            
        </div>

        <div class="field">
            <label for="gender">Gender <em>*</em></label> 
            <cfif printApplication>
				<div class="printField">
					<cfif FORM.gender EQ 'M'>
                        Male
                    <cfelseif FORM.gender EQ 'F'>
                        Female
                    </cfif> &nbsp;
                </div>
        	<cfelse>
                <select name="gender" id="gender" class="smallField {validate:{required:true}}">
                    <option value=""></option> <!--- [select your gender] --->
                    <option value="M" <cfif FORM.gender EQ 'M'> selected="selected" </cfif> >Male</option>
                    <option value="F" <cfif FORM.gender EQ 'F'> selected="selected" </cfif> >Female</option>
                </select>
            </cfif>            
        </div>
        
        <div class="field">
            <label for="dobMonth">Date of Birth <em>*</em></label> 
            <cfif printApplication>
				<div class="printField">
                	<cfif VAL(FORM.dobMonth)>
	                    #MonthAsString(FORM.dobMonth)#/#FORM.dobDay#/#FORM.dobYear#
                    </cfif> &nbsp;
                </div>
        	<cfelse>
                <select name="dobMonth" id="dobMonth" class="smallField {validate:{required:true}}">
                    <option value=""></option>
                    <cfloop from="1" to="12" index="i">
                        <option value="#i#" <cfif FORM.dobMonth EQ i> selected="selected" </cfif> >#MonthAsString(i)#</option>
                    </cfloop>
                </select>
                /
                <select name="dobDay" id="dobDay" class="xxSmallField {validate:{required:true}}">
                    <option value=""></option>
                    <cfloop from="1" to="31" index="i">
                        <option value="#i#" <cfif FORM.dobDay EQ i> selected="selected" </cfif> >#i#</option>
                    </cfloop>
                </select>
                / 
                <select name="dobYear" id="dobYear" class="xSmallField {validate:{required:true}}">
                    <option value=""></option>
                    <cfloop from="#Year(now())-10#" to="#Year(now())-90#" index="i" step="-1">
                        <option value="#i#" <cfif FORM.dobYear EQ i> selected="selected" </cfif> >#i#</option>
                    </cfloop>
                </select> 
                <p class="note">(mm/dd/yyyy)</p>               
            </cfif>            
        </div>

        <div class="field">
            <label for="countryBirthID">Country of Birth <em>*</em></label> 
            <cfif printApplication>
				<div class="printField">#APPLICATION.CFC.LOOKUPTABLES.getCountryByID(ID=FORM.countryBirthID).name# &nbsp;</div>
        	<cfelse>
                <select name="countryBirthID" id="countryBirthID" class="mediumField {validate:{required:true}}">
                    <option value=""></option> <!--- [select a country] ---->
                    <cfloop query="qGetCountry">
                        <option value="#qGetCountry.ID#" <cfif FORM.countryBirthID EQ qGetCountry.ID> selected="selected" </cfif> >#qGetCountry.name#</option>
                    </cfloop>
                </select>
            </cfif>            
        </div>

        <div class="field">
            <label for="countryCitizenID">Country of Citizenship <em>*</em></label> 
            <cfif printApplication>
				<div class="printField">#APPLICATION.CFC.LOOKUPTABLES.getCountryByID(ID=FORM.countryCitizenID).name# &nbsp;</div>
        	<cfelse>
                <select name="countryCitizenID" id="countryCitizenID" class="mediumField {validate:{required:true}}">
                    <option value=""></option>
                    <cfloop query="qGetCountry">
                        <option value="#qGetCountry.ID#" <cfif FORM.countryCitizenID EQ qGetCountry.ID> selected="selected" </cfif> >#qGetCountry.name#</option>
                    </cfloop>
                </select>
            </cfif>            
        </div>

        <!--- First Language --->
        <div class="field">
            <label for="#qGetQuestionsSection1.fieldKey[1]#">#qGetQuestionsSection1.displayField[1]# <cfif qGetQuestionsSection1.isRequired[1]><em>*</em></cfif></label> 
            <cfif printApplication>
				<div class="printField">#FORM[qGetQuestionsSection1.fieldKey[1]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestionsSection1.fieldKey[1]#" id="#qGetQuestionsSection1.fieldKey[1]#" value="#FORM[qGetQuestionsSection1.fieldKey[1]]#" class="#qGetQuestionsSection1.classType[1]#" maxlength="100" />
            </cfif>            
        </div>

    </fieldset>
    
    
    <!--- Complete Home Address --->
    <fieldset>
       
        <legend>Complete Home Address</legend>

		<!--- Country --->
		<div class="field">
			<label for="#qGetQuestionsSection1.fieldKey[7]#">#qGetQuestionsSection1.displayField[7]# <cfif qGetQuestionsSection1.isRequired[7]><em>*</em></cfif></label> 
            <cfif printApplication>
				<div class="printField">#APPLICATION.CFC.LOOKUPTABLES.getCountryByID(ID=FORM[qGetQuestionsSection1.fieldKey[7]]).name# &nbsp;</div>
        	<cfelse>
                <select name="#qGetQuestionsSection1.fieldKey[7]#" id="#qGetQuestionsSection1.fieldKey[7]#" class="mediumField" onchange="displayStateField(this.value, 'Section1HomeUsStDiv', 'Section1HomeNonUsStDiv', 'Section1UsHomeStField', 'Section1HomeNonUsStField');">
                    <option value=""></option>
                    <cfloop query="qGetCountry">
                        <option value="#qGetCountry.ID#" <cfif FORM[qGetQuestionsSection1.fieldKey[7]] EQ qGetCountry.ID> selected="selected" </cfif> >#qGetCountry.name#</option>
                    </cfloop>
                </select>
            </cfif>            
		</div>

        <!--- Address --->
        <div class="field">
            <label for="#qGetQuestionsSection1.fieldKey[2]#">#qGetQuestionsSection1.displayField[2]# <cfif qGetQuestionsSection1.isRequired[2]><em>*</em></cfif></label> 
            <cfif printApplication>
				<div class="printField">#FORM[qGetQuestionsSection1.fieldKey[2]]# &nbsp;</div>
        	<cfelse>
	            <input type="text" name="#qGetQuestionsSection1.fieldKey[2]#" id="#qGetQuestionsSection1.fieldKey[2]#" value="#FORM[qGetQuestionsSection1.fieldKey[2]]#" class="#qGetQuestionsSection1.classType[2]#" maxlength="100" />
            </cfif>            
        </div>

        <!--- Address 2 --->
        <div class="field">
            <label for="#qGetQuestionsSection1.fieldKey[3]#">#qGetQuestionsSection1.displayField[3]# <cfif qGetQuestionsSection1.isRequired[3]><em>*</em></cfif></label> 
            <cfif printApplication>
				<div class="printField">#FORM[qGetQuestionsSection1.fieldKey[3]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestionsSection1.fieldKey[3]#" id="#qGetQuestionsSection1.fieldKey[3]#" value="#FORM[qGetQuestionsSection1.fieldKey[3]]#" class="#qGetQuestionsSection1.classType[3]#" maxlength="100" />
            </cfif>            
        </div>

        <!--- City --->
        <div class="field">
            <label for="#qGetQuestionsSection1.fieldKey[4]#">#qGetQuestionsSection1.displayField[4]# <cfif qGetQuestionsSection1.isRequired[4]><em>*</em></cfif></label> 
            <cfif printApplication>
				<div class="printField">#FORM[qGetQuestionsSection1.fieldKey[4]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestionsSection1.fieldKey[4]#" id="#qGetQuestionsSection1.fieldKey[4]#" value="#FORM[qGetQuestionsSection1.fieldKey[4]]#" class="#qGetQuestionsSection1.classType[4]#" maxlength="100" />
            </cfif>            
        </div>

        <cfif printApplication>
	        <!--- State Print Application --->	
            <div class="field">
                <label for="#qGetQuestionsSection1.fieldKey[5]#">#qGetQuestionsSection1.displayField[5]# <cfif qGetQuestionsSection1.isRequired[5]><em>*</em></cfif></label> 
                <div class="printField">#FORM[qGetQuestionsSection1.fieldKey[5]]# &nbsp;</div>
            </div>
		<cfelse>
			<!--- US State --->
            <div class="field hiddenField" id="Section1HomeUsStDiv">
                <label for="#qGetQuestionsSection1.fieldKey[5]#">State/Province <em>*</em></label> 
                <select name="#qGetQuestionsSection1.fieldKey[5]#" id="#qGetQuestionsSection1.fieldKey[5]#" class="mediumField Section1UsHomeStField">
                    <option value=""></option> <!--- [select a state] ---->
                    <cfloop query="qGetStates">
                        <option value="#qGetStates.code#" <cfif FORM[qGetQuestionsSection1.fieldKey[5]] EQ qGetStates.code> selected="selected" </cfif> >#qGetStates.name#</option>
                    </cfloop>
                </select>
            </div>
    
            <!--- Non US State --->
            <div class="field hiddenField" id="Section1HomeNonUsStDiv">
                <label for="#qGetQuestionsSection1.fieldKey[5]#">#qGetQuestionsSection1.displayField[5]# <cfif qGetQuestionsSection1.isRequired[5]><em>*</em></cfif></label> 
                <input type="text" name="#qGetQuestionsSection1.fieldKey[5]#" id="#qGetQuestionsSection1.fieldKey[5]#" value="#FORM[qGetQuestionsSection1.fieldKey[5]]#" class="#qGetQuestionsSection1.classType[5]# Section1HomeNonUsStField" maxlength="100" />
            </div>
		</cfif>

		<!--- Zip --->
		<div class="field">
			<label for="#qGetQuestionsSection1.fieldKey[6]#">#qGetQuestionsSection1.displayField[6]# <cfif qGetQuestionsSection1.isRequired[6]><em>*</em></cfif></label> 
            <cfif printApplication>
				<div class="printField">#FORM[qGetQuestionsSection1.fieldKey[6]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestionsSection1.fieldKey[6]#" id="#qGetQuestionsSection1.fieldKey[6]#" value="#FORM[qGetQuestionsSection1.fieldKey[6]]#" class="#qGetQuestionsSection1.classType[6]#" maxlength="20" />
            </cfif>            
		</div>

    </fieldset>
    
    
    <!--- Contact Information --->
    <fieldset>
    
        <legend>Contact Information</legend>

        <div class="field">
            <label for="email">Email Address <em>*</em></label> 
            <cfif printApplication>
				<div class="printField">#FORM.email# &nbsp;</div>
        	<cfelse>
                <input type="text" name="email" id="email" value="#FORM.email#" class="largeField" maxlength="100" disabled="disabled" />
                <p class="note">Click on Update Login to update your email address.</p>
            </cfif>            
        </div>

        <div class="field">
            <label for="homePhoneCountry">#qGetQuestionsSection1.displayField[8]# <cfif qGetQuestionsSection1.isRequired[8]><em>*</em></cfif></label> 
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
                <!---
                <p class="note">+#### - (######) - ###### - ########</p>
                --->
                <p class="note"> 
                    <span class="phoneNote">country</span> 
                    <span class="phoneNote">area</span>  
                    <span class="phoneNote">prefix</span> 
                    <span class="phoneNote">number</span>
                </p>
            </cfif>            
        </div>

        <div class="field">
            <label for="faxCountry">#qGetQuestionsSection1.displayField[9]# <cfif qGetQuestionsSection1.isRequired[9]><em>*</em></cfif></label> 
            <cfif printApplication>
				<div class="printField">
                	#APPLICATION.CFC.UDF.formatPhoneNumber(
                    	countryCode=FORM.faxCountry, 
                        areaCode=FORM.faxArea, 
                        prefix=FORM.faxPrefix, 
                        number=FORM.faxNumber)# &nbsp;
                </div>
        	<cfelse>
                <input type="text" name="faxCountry" id="faxCountry" value="#FORM.faxCountry#" class="xxSmallField" maxlength="4" /> 
                - 
                <input type="text" name="faxArea" id="faxArea" value="#FORM.faxArea#" class="xxSmallField" maxlength="4" />                  
                - 
                <input type="text" name="faxPrefix" id="faxPrefix" value="#FORM.faxPrefix#" class="xxSmallField" maxlength="4" /> 
                - 
                <input type="text" name="faxNumber" id="faxNumber" value="#FORM.faxNumber#" class="xxSmallField" maxlength="6" />
                <p class="note"> 
                    <span class="phoneNote">country</span> 
                    <span class="phoneNote">area</span>  
                    <span class="phoneNote">prefix</span> 
                    <span class="phoneNote">number</span>
                </p>
            </cfif>            
        </div>

    </fieldset>
    
    
    <!--- Present School Information --->
    <fieldset>
    
        <legend>Present School Information</legend>
        
        <!--- Present School Name --->
        <div class="field">
            <label for="#qGetQuestionsSection1.fieldKey[10]#">#qGetQuestionsSection1.displayField[10]# <cfif qGetQuestionsSection1.isRequired[10]><em>*</em></cfif></label> 
            <cfif printApplication>
				<div class="printField">#FORM[qGetQuestionsSection1.fieldKey[10]]# &nbsp;</div>
        	<cfelse>
 	           <input type="text" name="#qGetQuestionsSection1.fieldKey[10]#" id="#qGetQuestionsSection1.fieldKey[10]#" value="#FORM[qGetQuestionsSection1.fieldKey[10]]#" class="#qGetQuestionsSection1.classType[10]#" maxlength="100" />			
            </cfif>            
        </div>

        <!--- Present School Country --->
        <div class="field">
            <label for="#qGetQuestionsSection1.fieldKey[15]#">#qGetQuestionsSection1.displayField[15]# <cfif qGetQuestionsSection1.isRequired[15]><em>*</em></cfif></label> 
            <cfif printApplication>
				<div class="printField">#APPLICATION.CFC.LOOKUPTABLES.getCountryByID(ID=FORM[qGetQuestionsSection1.fieldKey[15]]).name# &nbsp;</div>
        	<cfelse>
                <select name="#qGetQuestionsSection1.fieldKey[15]#" id="#qGetQuestionsSection1.fieldKey[15]#" class="#qGetQuestionsSection1.classType[15]#" onchange="displayStateField(this.value, 'Section1SchoolUsStDiv', 'Section1SchoolNonUsStDiv', 'Section1SchoolUsStField', 'Section1SchoolNonUsStField');">
                    <option value=""></option>
                    <cfloop query="qGetCountry">
                        <option value="#qGetCountry.ID#" <cfif FORM[qGetQuestionsSection1.fieldKey[15]] EQ qGetCountry.ID> selected="selected" </cfif> >#qGetCountry.name#</option>
                    </cfloop>
                </select>
            </cfif>            
        </div>
        
        <!--- Present School Address --->
        <div class="field">
            <label for="#qGetQuestionsSection1.fieldKey[11]#">#qGetQuestionsSection1.displayField[11]# <cfif qGetQuestionsSection1.isRequired[11]><em>*</em></cfif></label> 
            <cfif printApplication>
				<div class="printField">#FORM[qGetQuestionsSection1.fieldKey[11]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestionsSection1.fieldKey[11]#" id="#qGetQuestionsSection1.fieldKey[11]#" value="#FORM[qGetQuestionsSection1.fieldKey[11]]#" class="#qGetQuestionsSection1.classType[11]#" maxlength="100" />
            </cfif>                        
        </div>
        
        <!--- Present School City --->
        <div class="field">
            <label for="#qGetQuestionsSection1.fieldKey[12]#">#qGetQuestionsSection1.displayField[12]# <cfif qGetQuestionsSection1.isRequired[12]><em>*</em></cfif></label> 
            <cfif printApplication>
				<div class="printField">#FORM[qGetQuestionsSection1.fieldKey[12]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestionsSection1.fieldKey[12]#" id="#qGetQuestionsSection1.fieldKey[12]#" value="#FORM[qGetQuestionsSection1.fieldKey[12]]#" class="#qGetQuestionsSection1.classType[12]#" maxlength="100" />
            </cfif>            
        </div>
        		
        <cfif printApplication>
	        <!--- State Print Application --->	
            <div class="field">
                <label for="#qGetQuestionsSection1.fieldKey[13]#">#qGetQuestionsSection1.displayField[13]# <cfif qGetQuestionsSection1.isRequired[13]><em>*</em></cfif></label> 
                <div class="printField">#FORM[qGetQuestionsSection1.fieldKey[13]]# &nbsp;</div>
            </div>
		<cfelse>
			<!--- Present School US State --->
            <div class="field hiddenField" id="Section1SchoolUsStDiv">
                <label for="#qGetQuestionsSection1.fieldKey[13]#">State/Province <em>*</em></label> 
                <select name="#qGetQuestionsSection1.fieldKey[13]#" id="#qGetQuestionsSection1.fieldKey[13]#" class="mediumField Section1SchoolUsStField">
                    <option value=""></option> <!--- [select a state] ---->
                    <cfloop query="qGetStates">
                        <option value="#qGetStates.code#" <cfif FORM[qGetQuestionsSection1.fieldKey[13]] EQ qGetStates.code> selected="selected" </cfif> >#qGetStates.name#</option>
                    </cfloop>
                </select>
            </div>
            
            <!--- Present School Non Us State --->
            <div class="field hiddenField" id="Section1SchoolNonUsStDiv">
                <label for="#qGetQuestionsSection1.fieldKey[13]#">#qGetQuestionsSection1.displayField[13]# <cfif qGetQuestionsSection1.isRequired[13]><em>*</em></cfif></label> 
                <input type="text" name="#qGetQuestionsSection1.fieldKey[13]#" id="#qGetQuestionsSection1.fieldKey[13]#" value="#FORM[qGetQuestionsSection1.fieldKey[13]]#" class="#qGetQuestionsSection1.classType[13]# Section1SchoolNonUsStField" maxlength="100" />
            </div>
		</cfif>
                
        <!--- Present School Zip --->
        <div class="field">
            <label for="#qGetQuestionsSection1.fieldKey[14]#">#qGetQuestionsSection1.displayField[14]# <cfif qGetQuestionsSection1.isRequired[14]><em>*</em></cfif></label> 
            <cfif printApplication>
				<div class="printField">#FORM[qGetQuestionsSection1.fieldKey[14]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestionsSection1.fieldKey[14]#" id="#qGetQuestionsSection1.fieldKey[14]#" value="#FORM[qGetQuestionsSection1.fieldKey[14]]#" class="#qGetQuestionsSection1.classType[14]#" maxlength="50" />
            </cfif>            
        </div>
        
        <!--- Present School Attendance --->
        <div class="field">
            <label for="#qGetQuestionsSection1.fieldKey[16]#">#qGetQuestionsSection1.displayField[16]# <cfif qGetQuestionsSection1.isRequired[16]><em>*</em></cfif></label>  
            <cfif printApplication>
				<div class="printField">#FORM[qGetQuestionsSection1.fieldKey[16]]# &nbsp;</div>
        	<cfelse>
	            <input type="text" name="#qGetQuestionsSection1.fieldKey[16]#" id="#qGetQuestionsSection1.fieldKey[16]#" value="#FORM[qGetQuestionsSection1.fieldKey[16]]#" class="#qGetQuestionsSection1.classType[16]#" maxlength="50" />
            </cfif>            
        </div>

        <!--- Present School Type --->
        <div class="field controlset">
            <span class="label">#qGetQuestionsSection1.displayField[17]# <cfif qGetQuestionsSection1.isRequired[17]><em>*</em></cfif></span>
            <cfif printApplication>
				<div class="printField">#FORM[qGetQuestionsSection1.fieldKey[17]]# &nbsp;</div>
        	<cfelse>
                <input type="radio" name="#qGetQuestionsSection1.fieldKey[17]#" id="Independent" value="Independent" <cfif FORM[qGetQuestionsSection1.fieldKey[17]] EQ 'Independent'> checked="checked" </cfif> /> <label for="Independent">Independent</label>
                <input type="radio" name="#qGetQuestionsSection1.fieldKey[17]#" id="Parochial" value="Parochial" <cfif FORM[qGetQuestionsSection1.fieldKey[17]] EQ 'Parochial'> checked="checked" </cfif> /> <label for="Parochial">Parochial</label>
                <input type="radio" name="#qGetQuestionsSection1.fieldKey[17]#" id="Public" value="Public" <cfif FORM[qGetQuestionsSection1.fieldKey[17]] EQ 'Public'> checked="checked" </cfif> /> <label for="Public">Public</label>                
            </cfif>            
        </div>			

        <!--- Current Grade --->
        <div class="field">
            <label for="#qGetQuestionsSection1.fieldKey[18]#">#qGetQuestionsSection1.displayField[18]# <cfif qGetQuestionsSection1.isRequired[18]><em>*</em></cfif></label>  
            <cfif printApplication>
				<div class="printField">#FORM[qGetQuestionsSection1.fieldKey[18]]#<cfif LEN(FORM[qGetQuestionsSection1.fieldKey[18]])>th</cfif> &nbsp;</div>
        	<cfelse>
                <select name="#qGetQuestionsSection1.fieldKey[18]#" id="#qGetQuestionsSection1.fieldKey[18]#" class="#qGetQuestionsSection1.classType[18]#">
                    <option value=""></option>
                    <cfloop from="5" to="12" index="i" step="1">
                        <option value="#i#" <cfif FORM[qGetQuestionsSection1.fieldKey[18]] EQ i> selected="selected" </cfif> >#i#th</option>
                    </cfloop>
                </select>
            </cfif>            
        </div>

        <!--- Applying Grade --->
        <div class="field">
            <label for="#qGetQuestionsSection1.fieldKey[19]#">#qGetQuestionsSection1.displayField[19]# <cfif qGetQuestionsSection1.isRequired[19]><em>*</em></cfif></label>  
            <cfif printApplication>
				<div class="printField">#FORM[qGetQuestionsSection1.fieldKey[19]]#<cfif LEN(FORM[qGetQuestionsSection1.fieldKey[19]])>th</cfif> &nbsp;</div>
        	<cfelse>
                <select name="#qGetQuestionsSection1.fieldKey[19]#" id="#qGetQuestionsSection1.fieldKey[19]#" class="#qGetQuestionsSection1.classType[19]#">
                    <option value=""></option>
                    <cfloop from="5" to="12" index="i" step="1">
                        <option value="#i#" <cfif FORM[qGetQuestionsSection1.fieldKey[19]] EQ i> selected="selected" </cfif> >#i#th</option>
                    </cfloop>
                </select>
            </cfif>            
        </div>

        <!--- Entrance Date --->
        <div class="field">
            <label for="#qGetQuestionsSection1.fieldKey[20]#">#qGetQuestionsSection1.displayField[20]# <cfif qGetQuestionsSection1.isRequired[20]><em>*</em></cfif></label>  
            <cfif printApplication>
				<div class="printField">#FORM[qGetQuestionsSection1.fieldKey[20]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestionsSection1.fieldKey[20]#" id="#qGetQuestionsSection1.fieldKey[20]#" value="#FORM[qGetQuestionsSection1.fieldKey[20]]#" class="#qGetQuestionsSection1.classType[20]#" maxlength="10" />
            </cfif>            
        </div>

        <!--- Present School Type --->
        <div class="field controlset">
            <span class="label">#qGetQuestionsSection1.displayField[21]# <cfif qGetQuestionsSection1.isRequired[21]><em>*</em></cfif></span>
            <cfif printApplication>
				<cfif FORM[qGetQuestionsSection1.fieldKey[21]] EQ 'BoardingStudent'>
                	<div class="printField">Boarding Student</div>
                <cfelseif FORM[qGetQuestionsSection1.fieldKey[21]] EQ 'DayStudent'>
                	<div class="printField">Day Student</div>
                <cfelse>
                	<div class="printField">n/a</div>
				</cfif>
        	<cfelse>
                <input type="radio" name="#qGetQuestionsSection1.fieldKey[21]#" id="BoardingStudent" value="BoardingStudent" <cfif FORM[qGetQuestionsSection1.fieldKey[21]] EQ 'BoardingStudent'> checked="checked" </cfif> /> <label for="BoardingStudent">Boarding Student</label>
                <input type="radio" name="#qGetQuestionsSection1.fieldKey[21]#" id="DayStudent" value="DayStudent" <cfif FORM[qGetQuestionsSection1.fieldKey[21]] EQ 'DayStudent'> checked="checked" </cfif> /> <label for="DayStudent">Day Student</label>
            </cfif>            
        </div>			

        <!--- Past Schools --->
        <div class="field">
            <label for="#qGetQuestionsSection1.fieldKey[22]#">#qGetQuestionsSection1.displayField[22]# <cfif qGetQuestionsSection1.isRequired[22]><em>*</em></cfif></label>  
            <cfif printApplication>
				<div class="printFieldText">#FORM[qGetQuestionsSection1.fieldKey[22]]# &nbsp;</div>
        	<cfelse>
                <textarea name="#qGetQuestionsSection1.fieldKey[22]#" id="#qGetQuestionsSection1.fieldKey[22]#" class="#qGetQuestionsSection1.classType[22]#">#FORM[qGetQuestionsSection1.fieldKey[22]]#</textarea>                                    	
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

<script type="text/javascript">
	// Display State Fields
	$(document).ready(function() {
		// Get Current Country Value
		Section1GetHomeCountry = $("###qGetQuestionsSection1.fieldKey[7]#").val();
		displayStateField(Section1GetHomeCountry, 'Section1HomeUsStDiv', 'Section1HomeNonUsStDiv', 'Section1UsHomeStField', 'Section1HomeNonUsStField');
		
		// Get Current Country Value
		Section1GetSchoolCountry = $("###qGetQuestionsSection1.fieldKey[15]#").val();
		displayStateField(Section1GetSchoolCountry, 'Section1SchoolUsStDiv', 'Section1SchoolNonUsStDiv', 'Section1SchoolUsStField', 'Section1SchoolNonUsStField');
	});
</script>
  
</cfoutput>