<!--- ------------------------------------------------------------------------- ----
	
	File:		_section1.cfm
	Author:		Marcus Melo
	Date:		June 14, 2010
	Desc:		Section 1 of the Online Application

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customtags/gui/" prefix="gui" />	

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
	<cfparam name="FORM.firstLanguage" default="">
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
		qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(ID=FORM.studentID);

		// Get Questions for this section
		qGetQuestions = APPLICATION.CFC.ONLINEAPP.getQuestionByFilter(sectionName='section1');
		
		// Get Answers for this section
		qGetAnswers = APPLICATION.CFC.ONLINEAPP.getAnswerByFilter(sectionName='section1', foreignID=FORM.studentID);

		// Param Online Application Fields 
		for ( i=1; i LTE qGetQuestions.recordCount; i=i+1 ) {
			param name="FORM[qGetQuestions.fieldKey[i]]" default="";
		}

		// Get Current Student Information
		qGetCountry = APPLICATION.CFC.LOOKUPTABLES.getCountry();

		// FORM Submitted
		if ( FORM.submittedType EQ 'section1' ) {

			// Parent Phone
			FORM[qGetQuestions.fieldKey[7]] = APPLICATION.CFC.UDF.formatPhoneNumber(countryCode=FORM.homePhoneCountry, areaCode=FORM.homePhoneArea, prefix=FORM.homePhonePrefix, number=FORM.homePhoneNumber);
			// Parent Fax
			FORM[qGetQuestions.fieldKey[8]] = APPLICATION.CFC.UDF.formatPhoneNumber(countryCode=FORM.faxCountry, areaCode=FORM.faxArea, prefix=FORM.faxPrefix, number=FORM.faxNumber);					

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

			for ( i=1; i LTE qGetQuestions.recordCount; i=i+1 ) {
				if (qGetQuestions.isRequired[i] AND NOT LEN(FORM[qGetQuestions.fieldKey[i]]) ) {
					SESSION.formErrors.Add(qGetQuestions.requiredMessage[i]);
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
					countryCitizenID = FORM.countryCitizenID,
					firstLanguage = FORM.firstLanguage
				);
				
				// Insert/Update Application Fields 
				for ( i=1; i LTE qGetQuestions.recordCount; i=i+1 ) {
					APPLICATION.CFC.ONLINEAPP.insertAnswer(	
						applicationQuestionID=qGetQuestions.ID[i],
						foreignID=FORM.studentID,
						fieldKey=qGetQuestions.fieldKey[i],
						answer=FORM[qGetQuestions.fieldKey[i]]						
					);	
				}
				
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
			FORM.firstLanguage = qGetStudentInfo.firstLanguage;
			FORM.email = qGetStudentInfo.email;

			// Online Application Fields 
			for ( i=1; i LTE qGetAnswers.recordCount; i=i+1 ) {
				FORM[qGetAnswers.fieldKey[i]] = qGetAnswers.answer[i];
			}

			// Break Down Phone Numbers
			stHomePhone = APPLICATION.CFC.UDF.breakDownPhoneNumber(qGetAnswers.answer[7]);
			stFax = APPLICATION.CFC.UDF.breakDownPhoneNumber(qGetAnswers.answer[8]);
			
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
       
    <form action="#CGI.SCRIPT_NAME#?action=initial" method="post">
    <input type="hidden" name="submittedType" value="1" />
    <input type="hidden" name="currentTabID" value="0" />
    
    <p class="legend"><strong>Note:</strong> Required fields are marked with an asterisk (<em>*</em>)</p>
    
    <!--- Student Details --->
    <fieldset>
       
        <legend>Student Details</legend>
            
        <div class="field">
            <label for="firstName">First Name <em>*</em></label> 
            <input type="text" name="firstName" id="firstName" value="#FORM.firstName#" class="largeField" maxlength="100" /> <!--- class="error" --->
        </div>

        <div class="field">
            <label for="middleName">Middle Name</label> 
            <input type="text" name="middleName" id="middleName" value="#FORM.middleName#" class="largeField" maxlength="100" />
        </div>

        <div class="field">
            <label for="lastName">Family Name <em>*</em></label> 
            <input type="text" name="lastName" id="lastName" value="#FORM.lastName#" class="largeField" maxlength="100" />
        </div>

        <div class="field">
            <label for="preferredName">Preferred Name or Nickname</label> 
            <input type="text" name="preferredName" id="preferredName" value="#FORM.preferredName#" class="largeField" maxlength="100" />
        </div>

        <div class="field">
            <label for="gender">Gender <em>*</em></label> 
            <select name="gender" id="gender" class="smallField">
                <option value=""></option> <!--- [select your gender] --->
                <option value="M" <cfif FORM.gender EQ 'M'> selected="selected" </cfif> >Male</option>
                <option value="F" <cfif FORM.gender EQ 'F'> selected="selected" </cfif> >Female</option>
            </select>
        </div>
        
        <div class="field">
            <label for="dobMonth">Date of Birth <em>*</em></label> 
            <select name="dobMonth" id="dobMonth" class="smallField">
                <option value="0"></option>
                <cfloop from="1" to="12" index="i">
                    <option value="#i#" <cfif FORM.dobMonth EQ i> selected="selected" </cfif> >#MonthAsString(i)#</option>
                </cfloop>
            </select>
            /
            <select name="dobDay" id="dobDay" class="xxSmallField">
                <option value="0"></option>
                <cfloop from="1" to="31" index="i">
                    <option value="#i#" <cfif FORM.dobDay EQ i> selected="selected" </cfif> >#i#</option>
                </cfloop>
            </select>
            / 
            <select name="dobYear" id="dobYear" class="xSmallField">
                <option value="0"></option>
                <cfloop from="#Year(now())-10#" to="#Year(now())-90#" index="i" step="-1">
                    <option value="#i#" <cfif FORM.dobYear EQ i> selected="selected" </cfif> >#i#</option>
                </cfloop>
            </select>
            <p class="note">(mm/dd/yyyy)</p>
        </div>

        <div class="field">
            <label for="countryBirthID">Country of Birth <em>*</em></label> 
            <select name="countryBirthID" id="countryBirthID" class="mediumField">
                <option value=""></option> <!--- [select a country] ---->
                <cfloop query="qGetCountry">
                    <option value="#qGetCountry.ID#" <cfif FORM.countryBirthID EQ qGetCountry.ID> selected="selected" </cfif> >#qGetCountry.name#</option>
                </cfloop>
            </select>
        </div>

        <div class="field">
            <label for="countryCitizenID">Country of Citizenship <em>*</em></label> 
            <select name="countryCitizenID" id="countryCitizenID" class="mediumField">
                <option value=""></option>
                <cfloop query="qGetCountry">
                    <option value="#qGetCountry.ID#" <cfif FORM.countryCitizenID EQ qGetCountry.ID> selected="selected" </cfif> >#qGetCountry.name#</option>
                </cfloop>
            </select>
        </div>
        
        <div class="field">
            <label for="firstLanguage">First language other than English </label> 
            <input type="text" name="firstLanguage" id="firstLanguage" value="#FORM.firstLanguage#" class="mediumField" maxlength="100" />
        </div>

    </fieldset>
    
    
    <!--- Complete Home Address --->
    <fieldset>
       
        <legend>Complete Home Address</legend>

        <!--- Address --->
        <div class="field">
            <label for="#qGetQuestions.fieldKey[1]#">#qGetQuestions.displayField[1]# <cfif qGetQuestions.isRequired[1]><em>*</em></cfif></label> 
            <input type="text" name="#qGetQuestions.fieldKey[1]#" id="#qGetQuestions.fieldKey[1]#" value="#FORM[qGetQuestions.fieldKey[1]]#" class="#qGetQuestions.classType[1]#" maxlength="100" />
        </div>

        <!--- Address 2 --->
        <div class="field">
            <label for="#qGetQuestions.fieldKey[2]#">#qGetQuestions.displayField[2]# <cfif qGetQuestions.isRequired[2]><em>*</em></cfif></label> 
            <input type="text" name="#qGetQuestions.fieldKey[2]#" id="#qGetQuestions.fieldKey[2]#" value="#FORM[qGetQuestions.fieldKey[2]]#" class="#qGetQuestions.classType[2]#" maxlength="100" />
        </div>

        <!--- City --->
        <div class="field">
            <label for="#qGetQuestions.fieldKey[3]#">#qGetQuestions.displayField[3]# <cfif qGetQuestions.isRequired[3]><em>*</em></cfif></label> 
            <input type="text" name="#qGetQuestions.fieldKey[3]#" id="#qGetQuestions.fieldKey[3]#" value="#FORM[qGetQuestions.fieldKey[3]]#" class="#qGetQuestions.classType[3]#" maxlength="100" />
        </div>

        <!--- State --->
        <div class="field">
            <label for="#qGetQuestions.fieldKey[4]#">#qGetQuestions.displayField[4]# <cfif qGetQuestions.isRequired[4]><em>*</em></cfif></label> 
            <input type="text" name="#qGetQuestions.fieldKey[4]#" id="#qGetQuestions.fieldKey[4]#" value="#FORM[qGetQuestions.fieldKey[4]]#" class="#qGetQuestions.classType[4]#" maxlength="100" />
        </div>

		<!--- Zip --->
		<div class="field">
			<label for="#qGetQuestions.fieldKey[5]#">#qGetQuestions.displayField[5]# <cfif qGetQuestions.isRequired[5]><em>*</em></cfif></label> 
			<input type="text" name="#qGetQuestions.fieldKey[5]#" id="#qGetQuestions.fieldKey[5]#" value="#FORM[qGetQuestions.fieldKey[5]]#" class="#qGetQuestions.classType[5]#" maxlength="50" />
		</div>
		
		<!--- Coutry --->
		<div class="field">
			<label for="#qGetQuestions.fieldKey[6]#">#qGetQuestions.displayField[6]# <cfif qGetQuestions.isRequired[6]><em>*</em></cfif></label> 
			<select name="#qGetQuestions.fieldKey[6]#" id="#qGetQuestions.fieldKey[6]#" class="mediumField">
				<option value=""></option>
				<cfloop query="qGetCountry">
					<option value="#qGetCountry.ID#" <cfif FORM[qGetQuestions.fieldKey[6]] EQ qGetCountry.ID> selected="selected" </cfif> >#qGetCountry.name#</option>
				</cfloop>
			</select>
		</div>

    </fieldset>
    
    
    <!--- Contact Information --->
    <fieldset>
    
        <legend>Contact Information</legend>

        <div class="field">
            <label for="email">Email Address <em>*</em></label> 
            <input type="text" name="email" id="email" value="#FORM.email#" class="largeField" maxlength="100" disabled="disabled" />
        	<p class="note">Click on Update Login to update your email address.</p>
        </div>

        <div class="field">
            <label for="homePhoneCountry">#qGetQuestions.displayField[7]# <cfif qGetQuestions.isRequired[7]><em>*</em></cfif></label> 
            <input type="text" name="homePhoneCountry" id="homePhoneCountry" value="#FORM.homePhoneCountry#" class="xxSmallField" maxlength="4" /> 
            -
            <input type="text" name="homePhoneArea" id="homePhoneArea" value="#FORM.homePhoneArea#" class="xxSmallField" maxlength="4" />                  
            - 
            <input type="text" name="homePhonePrefix" id="homePhonePrefix" value="#FORM.homePhonePrefix#" class="xxSmallField" maxlength="4" /> 
            - 
            <input type="text" name="homePhoneNumber" id="homePhoneNumber" value="#FORM.homePhoneNumber#" class="xxSmallField" maxlength="6" />
            <p class="note">+#### - (######) - ###### - ########</p>
        </div>

        <div class="field">
            <label for="faxCountry">#qGetQuestions.displayField[8]# <cfif qGetQuestions.isRequired[8]><em>*</em></cfif></label> 
            <input type="text" name="faxCountry" id="faxCountry" value="#FORM.faxCountry#" class="xxSmallField" maxlength="4" /> 
            - 
            <input type="text" name="faxArea" id="faxArea" value="#FORM.faxArea#" class="xxSmallField" maxlength="4" />                  
            - 
            <input type="text" name="faxPrefix" id="faxPrefix" value="#FORM.faxPrefix#" class="xxSmallField" maxlength="4" /> 
            - 
            <input type="text" name="faxNumber" id="faxNumber" value="#FORM.faxNumber#" class="xxSmallField" maxlength="6" />
            <p class="note">+#### - (######) - ###### - ########</p>
        </div>

    </fieldset>
    
    
    <!--- Present School Information --->
    <fieldset>
    
        <legend>Present School Information</legend>
        
        <!--- Present School Name --->
        <div class="field">
            <label for="#qGetQuestions.fieldKey[9]#">#qGetQuestions.displayField[9]# <cfif qGetQuestions.isRequired[9]><em>*</em></cfif></label> 
            <input type="text" name="#qGetQuestions.fieldKey[9]#" id="#qGetQuestions.fieldKey[9]#" value="#FORM[qGetQuestions.fieldKey[9]]#" class="#qGetQuestions.classType[9]#" maxlength="100" />
        </div>
        
        <!--- Present School Address --->
        <div class="field">
            <label for="#qGetQuestions.fieldKey[10]#">#qGetQuestions.displayField[10]# <cfif qGetQuestions.isRequired[10]><em>*</em></cfif></label> 
            <input type="text" name="#qGetQuestions.fieldKey[10]#" id="#qGetQuestions.fieldKey[10]#" value="#FORM[qGetQuestions.fieldKey[10]]#" class="#qGetQuestions.classType[10]#" maxlength="100" />
        </div>
        
        <!--- Present School City --->
        <div class="field">
            <label for="#qGetQuestions.fieldKey[11]#">#qGetQuestions.displayField[11]# <cfif qGetQuestions.isRequired[11]><em>*</em></cfif></label>  
            <input type="text" name="#qGetQuestions.fieldKey[11]#" id="#qGetQuestions.fieldKey[11]#" value="#FORM[qGetQuestions.fieldKey[11]]#" class="#qGetQuestions.classType[11]#" maxlength="100" />
        </div>
        
        <!--- Present School State --->
        <div class="field">
            <label for="#qGetQuestions.fieldKey[12]#">#qGetQuestions.displayField[12]# <cfif qGetQuestions.isRequired[12]><em>*</em></cfif></label> 
            <input type="text" name="#qGetQuestions.fieldKey[12]#" id="#qGetQuestions.fieldKey[12]#" value="#FORM[qGetQuestions.fieldKey[12]]#" class="#qGetQuestions.classType[12]#" maxlength="100" />
        </div>

        <!--- Present School Zip --->
        <div class="field">
            <label for="#qGetQuestions.fieldKey[13]#">#qGetQuestions.displayField[13]# <cfif qGetQuestions.isRequired[13]><em>*</em></cfif></label>  
            <input type="text" name="#qGetQuestions.fieldKey[13]#" id="#qGetQuestions.fieldKey[13]#" value="#FORM[qGetQuestions.fieldKey[13]]#" class="#qGetQuestions.classType[13]#" maxlength="50" />
        </div>
        
        <!--- Present School Country --->
        <div class="field">
            <label for="#qGetQuestions.fieldKey[14]#">#qGetQuestions.displayField[14]# <cfif qGetQuestions.isRequired[14]><em>*</em></cfif></label> 
            <select name="#qGetQuestions.fieldKey[14]#" id="#qGetQuestions.fieldKey[14]#" class="#qGetQuestions.classType[14]#">
                <option value=""></option>
                <cfloop query="qGetCountry">
                    <option value="#qGetCountry.ID#" <cfif FORM[qGetQuestions.fieldKey[14]] EQ qGetCountry.ID> selected="selected" </cfif> >#qGetCountry.name#</option>
                </cfloop>
            </select>
        </div>
        
        <!--- Present School Attendance --->
        <div class="field">
            <label for="#qGetQuestions.fieldKey[15]#">#qGetQuestions.displayField[15]# <cfif qGetQuestions.isRequired[15]><em>*</em></cfif></label>  
            <input type="text" name="#qGetQuestions.fieldKey[15]#" id="#qGetQuestions.fieldKey[15]#" value="#FORM[qGetQuestions.fieldKey[15]]#" class="#qGetQuestions.classType[15]#" maxlength="50" />
        </div>

        <!--- Present School Type --->
        <div class="controlset">
            <span class="label">#qGetQuestions.displayField[16]# <cfif qGetQuestions.isRequired[16]><em>*</em></cfif></span>
            <input type="radio" name="#qGetQuestions.fieldKey[16]#" id="Independent" value="Independent" <cfif FORM[qGetQuestions.fieldKey[16]] EQ 'Independent'> checked="checked" </cfif> /> <label for="Independent">Independent</label>
            <input type="radio" name="#qGetQuestions.fieldKey[16]#" id="Parochial" value="Parochial" <cfif FORM[qGetQuestions.fieldKey[16]] EQ 'Parochial'> checked="checked" </cfif> /> <label for="Parochial">Parochial</label>
            <input type="radio" name="#qGetQuestions.fieldKey[16]#" id="Public" value="Public" <cfif FORM[qGetQuestions.fieldKey[16]] EQ 'Public'> checked="checked" </cfif> /> <label for="Public">Public</label>                
        </div>			

        <!--- Current Grade --->
        <div class="field">
            <label for="#qGetQuestions.fieldKey[17]#">#qGetQuestions.displayField[17]# <cfif qGetQuestions.isRequired[17]><em>*</em></cfif></label>  
            <select name="#qGetQuestions.fieldKey[17]#" id="#qGetQuestions.fieldKey[17]#" class="#qGetQuestions.classType[17]#">
            	<option value=""></option>
                <cfloop from="5" to="12" index="i" step="1">
                    <option value="#i#" <cfif FORM[qGetQuestions.fieldKey[17]] EQ i> selected="selected" </cfif> >#i#th</option>
                </cfloop>
            </select>
        </div>

        <!--- Applying Grade --->
        <div class="field">
            <label for="#qGetQuestions.fieldKey[18]#">#qGetQuestions.displayField[18]# <cfif qGetQuestions.isRequired[18]><em>*</em></cfif></label>  
            <select name="#qGetQuestions.fieldKey[18]#" id="#qGetQuestions.fieldKey[18]#" class="#qGetQuestions.classType[18]#">
            	<option value=""></option>
                <cfloop from="5" to="12" index="i" step="1">
                    <option value="#i#" <cfif FORM[qGetQuestions.fieldKey[18]] EQ i> selected="selected" </cfif> >#i#th</option>
                </cfloop>
            </select>
        </div>

        <!--- Entrance Date --->
        <div class="field">
            <label for="#qGetQuestions.fieldKey[19]#">#qGetQuestions.displayField[19]# <cfif qGetQuestions.isRequired[19]><em>*</em></cfif></label>  
            <input type="text" name="#qGetQuestions.fieldKey[19]#" id="#qGetQuestions.fieldKey[19]#" value="#FORM[qGetQuestions.fieldKey[19]]#" class="#qGetQuestions.classType[19]#" maxlength="10" />
        </div>

        <!--- Present School Type --->
        <div class="controlset">
            <span class="label">#qGetQuestions.displayField[20]# <cfif qGetQuestions.isRequired[20]><em>*</em></cfif></span>
            <input type="radio" name="#qGetQuestions.fieldKey[20]#" id="BoardingStudent" value="BoardingStudent" <cfif FORM[qGetQuestions.fieldKey[20]] EQ 'BoardingStudent'> checked="checked" </cfif> /> <label for="BoardingStudent">Boarding Student</label>
            <input type="radio" name="#qGetQuestions.fieldKey[20]#" id="DayStudent" value="DayStudent" <cfif FORM[qGetQuestions.fieldKey[20]] EQ 'DayStudent'> checked="checked" </cfif> /> <label for="DayStudent">Day Student</label>
        </div>			

        <!--- Past Schools --->
        <div class="field">
            <label for="#qGetQuestions.fieldKey[21]#">#qGetQuestions.displayField[21]# <cfif qGetQuestions.isRequired[21]><em>*</em></cfif></label>  
            <textarea name="#qGetQuestions.fieldKey[21]#" id="#qGetQuestions.fieldKey[21]#" class="#qGetQuestions.classType[21]#">#FORM[qGetQuestions.fieldKey[21]]#</textarea>                                    	
        </div>

    </fieldset>

    <div class="buttonrow">
    	<input type="submit" value="Save" class="button ui-corner-top" />
    </div>

    </form>

</div><!-- /form-container -->
   
</cfoutput>
