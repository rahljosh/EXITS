<!--- ------------------------------------------------------------------------- ----
	
	File:		_section2.cfm
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
	<!--- Parent Information ---> 
    <cfparam name="FORM.homePhoneCountry" default="">
    <cfparam name="FORM.homePhoneArea" default="">
    <cfparam name="FORM.homePhonePrefix" default="">
    <cfparam name="FORM.homePhoneNumber" default="">
    <cfparam name="FORM.faxCountry" default="">
    <cfparam name="FORM.faxArea" default="">
    <cfparam name="FORM.faxPrefix" default="">
    <cfparam name="FORM.faxNumber" default="">
    <cfparam name="FORM.businessPhoneCountry" default="">
    <cfparam name="FORM.businessPhoneArea" default="">
    <cfparam name="FORM.businessPhonePrefix" default="">
    <cfparam name="FORM.businessPhoneNumber" default="">

    <cfscript>
		// Get Current Student Information
		qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(ID=FORM.studentID);

		// Get Current Student Information
		qGetCountry = APPLICATION.CFC.LOOKUPTABLES.getCountry();

		// Get Questions for this section
		qGetQuestions = APPLICATION.CFC.ONLINEAPP.getQuestionByFilter(sectionName='section2');
		
		// Get Answers for this section
		qGetAnswers = APPLICATION.CFC.ONLINEAPP.getAnswerByFilter(sectionName='section2', foreignID=FORM.studentID);

		// Param Online Application Fields 
		for ( i=1; i LTE qGetQuestions.recordCount; i=i+1 ) {
			param name="FORM[qGetQuestions.fieldKey[i]]" default="";
		}
	
		// FORM Submitted
		if ( FORM.submittedType EQ 'section2' ) {

			// Parent Phone
			FORM[qGetQuestions.fieldKey[11]] = APPLICATION.CFC.UDF.formatPhoneNumber(countryCode=FORM.homePhoneCountry, areaCode=FORM.homePhoneArea, prefix=FORM.homePhonePrefix, number=FORM.homePhoneNumber);
			// Parent Fax
			FORM[qGetQuestions.fieldKey[12]] = APPLICATION.CFC.UDF.formatPhoneNumber(countryCode=FORM.faxCountry, areaCode=FORM.faxArea, prefix=FORM.faxPrefix, number=FORM.faxNumber);					
			// Parent Business Phone
			FORM[qGetQuestions.fieldKey[21]] = APPLICATION.CFC.UDF.formatPhoneNumber(countryCode=FORM.businessPhoneCountry, areaCode=FORM.businessPhoneArea, prefix=FORM.businessPhonePrefix, number=FORM.businessPhoneNumber);									

			// FORM Validation
			for ( i=1; i LTE qGetQuestions.recordCount; i=i+1 ) {
				if (qGetQuestions.isRequired[i] AND NOT LEN(FORM[qGetQuestions.fieldKey[i]]) ) {
					SESSION.formErrors.Add(qGetQuestions.requiredMessage[i]);
				}
			}
			
			// Check if there are no errors
			if ( NOT SESSION.formErrors.length() ) {				
				
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

			// Online Application Fields 
			for ( i=1; i LTE qGetAnswers.recordCount; i=i+1 ) {
				FORM[qGetAnswers.fieldKey[i]] = qGetAnswers.answer[i];
			}

			// Break Down Phone Numbers
			stHomePhone = APPLICATION.CFC.UDF.breakDownPhoneNumber(qGetAnswers.answer[11]);
			stFax = APPLICATION.CFC.UDF.breakDownPhoneNumber(qGetAnswers.answer[12]);
			stBusinessPhone = APPLICATION.CFC.UDF.breakDownPhoneNumber(qGetAnswers.answer[21]);

			FORM.homePhoneCountry = stHomePhone.countryCode;
			FORM.homePhoneArea = stHomePhone.areaCode;
			FORM.homePhonePrefix = stHomePhone.prefix;
			FORM.homePhoneNumber = stHomePhone.number;
			FORM.faxCountry = stFax.countryCode;
			FORM.faxArea = stFax.areaCode;
			FORM.faxPrefix = stFax.prefix;
			FORM.faxNumber = stFax.number;
			FORM.businessPhoneCountry = stHomePhone.countryCode;
			FORM.businessPhoneArea = stHomePhone.areaCode;
			FORM.businessPhonePrefix = stHomePhone.prefix;
			FORM.businessPhoneNumber = stHomePhone.number;
			
		}
	</cfscript>
    
</cfsilent>

<cfoutput>

<!--- Application Body --->
<div class="form-container">
	
    <!--- Only Display Messages if Current tab is updated --->
  	<cfif currentTabID EQ 1>
    
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
	<input type="hidden" name="submittedType" value="section2" />
    <input type="hidden" name="currentTabID" value="1" />
	
	<p class="legend"><strong>Note:</strong> Required fields are marked with an asterisk (<em>*</em>)</p>
	
	<!--- Parent/Guardian --->
	<fieldset>
	   
		<legend>Parent/Guardian</legend>
		
		<!--- Parent Relationship --->
		<div class="field">
			<label for="#qGetQuestions.fieldKey[1]#">#qGetQuestions.displayField[1]# <cfif qGetQuestions.isRequired[1]><em>*</em></cfif></label> 
			<input type="text" name="#qGetQuestions.fieldKey[1]#" id="#qGetQuestions.fieldKey[1]#" value="#FORM[qGetQuestions.fieldKey[1]]#" class="#qGetQuestions.classType[1]#" maxlength="100" />
		</div>
		
		<!--- Parent First Name --->
		<div class="field">
			<label for="#qGetQuestions.fieldKey[2]#">#qGetQuestions.displayField[2]# <cfif qGetQuestions.isRequired[2]><em>*</em></cfif></label> 
			<input type="text" name="#qGetQuestions.fieldKey[2]#" id="#qGetQuestions.fieldKey[2]#" value="#FORM[qGetQuestions.fieldKey[2]]#" class="#qGetQuestions.classType[2]#" maxlength="100" />
		</div>
		
		<!--- Parent Middle Name --->
		<div class="field">
			<label for="#qGetQuestions.fieldKey[3]#">#qGetQuestions.displayField[3]# <cfif qGetQuestions.isRequired[3]><em>*</em></cfif></label>  
			<input type="text" name="#qGetQuestions.fieldKey[3]#" id="#qGetQuestions.fieldKey[3]#" value="#FORM[qGetQuestions.fieldKey[3]]#" class="#qGetQuestions.classType[3]#" maxlength="100" />
		</div>
		
		<!--- Parent Last Name --->
		<div class="field">
			<label for="#qGetQuestions.fieldKey[4]#">#qGetQuestions.displayField[4]# <cfif qGetQuestions.isRequired[4]><em>*</em></cfif></label> 
			<input type="text" name="#qGetQuestions.fieldKey[4]#" id="#qGetQuestions.fieldKey[4]#" value="#FORM[qGetQuestions.fieldKey[4]]#" class="#qGetQuestions.classType[4]#" maxlength="100" />
		</div>
		
		<!--- Parent Preferred Name ---> 
		<div class="field">
			<label for="#qGetQuestions.fieldKey[5]#">#qGetQuestions.displayField[5]# <cfif qGetQuestions.isRequired[5]><em>*</em></cfif></label> 
			<input type="text" name="#qGetQuestions.fieldKey[5]#" id="#qGetQuestions.fieldKey[5]#" value="#FORM[qGetQuestions.fieldKey[5]]#" class="#qGetQuestions.classType[5]#" maxlength="100" />
		</div>
		
	</fieldset>


	<!--- Complete Home Address --->
	<fieldset>
	   
		<legend>Complete Home Address</legend>
		
		<!--- Parent Address --->
		<div class="field">
			<label for="#qGetQuestions.fieldKey[6]#">#qGetQuestions.displayField[6]# <cfif qGetQuestions.isRequired[6]><em>*</em></cfif></label> 
			<input type="text" name="#qGetQuestions.fieldKey[6]#" id="#qGetQuestions.fieldKey[6]#" value="#FORM[qGetQuestions.fieldKey[6]]#" class="#qGetQuestions.classType[6]#" maxlength="100" />
		</div>
		
		<!--- Parent City --->
		<div class="field">
			<label for="#qGetQuestions.fieldKey[7]#">#qGetQuestions.displayField[7]# <cfif qGetQuestions.isRequired[7]><em>*</em></cfif></label> 
			<input type="text" name="#qGetQuestions.fieldKey[7]#" id="#qGetQuestions.fieldKey[7]#" value="#FORM[qGetQuestions.fieldKey[7]]#" class="#qGetQuestions.classType[7]#" maxlength="100" />
		</div>
		
		<!--- Parent State --->
		<div class="field">
			<label for="#qGetQuestions.fieldKey[8]#">#qGetQuestions.displayField[8]# <cfif qGetQuestions.isRequired[8]><em>*</em></cfif></label> 
			<input type="text" name="#qGetQuestions.fieldKey[8]#" id="#qGetQuestions.fieldKey[8]#" value="#FORM[qGetQuestions.fieldKey[8]]#" class="#qGetQuestions.classType[8]#" maxlength="100" />
		</div>
		
		<!--- Parent Zip --->
		<div class="field">
			<label for="#qGetQuestions.fieldKey[9]#">#qGetQuestions.displayField[9]# <cfif qGetQuestions.isRequired[9]><em>*</em></cfif></label> 
			<input type="text" name="#qGetQuestions.fieldKey[9]#" id="#qGetQuestions.fieldKey[9]#" value="#FORM[qGetQuestions.fieldKey[9]]#" class="#qGetQuestions.classType[9]#" maxlength="50" />
		</div>
		
		<!--- Parent Coutry --->
		<div class="field">
			<label for="#qGetQuestions.fieldKey[10]#">#qGetQuestions.displayField[10]# <cfif qGetQuestions.isRequired[10]><em>*</em></cfif></label> 
			<select name="#qGetQuestions.fieldKey[10]#" id="#qGetQuestions.fieldKey[10]#" class="mediumField">
				<option value=""></option>
				<cfloop query="qGetCountry">
					<option value="#qGetCountry.ID#" <cfif FORM[qGetQuestions.fieldKey[10]] EQ qGetCountry.ID> selected="selected" </cfif> >#qGetCountry.name#</option>
				</cfloop>
			</select>
		</div>

		<!--- Parent Home Telephone --->
		<div class="field">
			<label for="homePhoneCountry">#qGetQuestions.displayField[11]# <cfif qGetQuestions.isRequired[11]><em>*</em></cfif></label> 
			<input type="text" name="homePhoneCountry" id="homePhoneCountry" value="#FORM.homePhoneCountry#" class="xxSmallField" maxlength="4" /> 
			-
			<input type="text" name="homePhoneArea" id="homePhoneArea" value="#FORM.homePhoneArea#" class="xxSmallField" maxlength="4" />                  
			- 
			<input type="text" name="homePhonePrefix" id="homePhonePrefix" value="#FORM.homePhonePrefix#" class="xxSmallField" maxlength="4" /> 
			- 
			<input type="text" name="homePhoneNumber" id="homePhoneNumber" value="#FORM.homePhoneNumber#" class="xxSmallField" maxlength="6" />
			<p class="note">+#### - (######) - ###### - ########</p>
		</div>

		<!--- Parent Fax Telephone --->
		<div class="field">
			<label for="faxCountry">#qGetQuestions.displayField[12]# <cfif qGetQuestions.isRequired[12]><em>*</em></cfif></label> 
			<input type="text" name="faxCountry" id="faxCountry" value="#FORM.faxCountry#" class="xxSmallField" maxlength="4" /> 
			- 
			<input type="text" name="faxArea" id="faxArea" value="#FORM.faxArea#" class="xxSmallField" maxlength="4" />                  
			- 
			<input type="text" name="faxPrefix" id="faxPrefix" value="#FORM.faxPrefix#" class="xxSmallField" maxlength="4" /> 
			- 
			<input type="text" name="faxNumber" id="faxNumber" value="#FORM.faxNumber#" class="xxSmallField" maxlength="6" />
			<p class="note">+#### - (######) - ###### - ########</p>
		</div>

		<!--- Parent Email --->
		<div class="field">
			<label for="#qGetQuestions.fieldKey[13]#">#qGetQuestions.displayField[13]# <cfif qGetQuestions.isRequired[13]><em>*</em></cfif></label> 
			<input type="text" name="#qGetQuestions.fieldKey[13]#" id="#qGetQuestions.fieldKey[13]#" value="#FORM[qGetQuestions.fieldKey[13]]#" class="#qGetQuestions.classType[13]#" maxlength="50" />
		</div>

	</fieldset>
	
	
	<!--- Business Information --->
	<fieldset>
	   
		<legend>Business Information</legend>
		
		<!--- Company Name --->
		<div class="field">
			<label for="#qGetQuestions.fieldKey[14]#">#qGetQuestions.displayField[14]# <cfif qGetQuestions.isRequired[14]><em>*</em></cfif></label> 
			<input type="text" name="#qGetQuestions.fieldKey[14]#" id="#qGetQuestions.fieldKey[14]#" value="#FORM[qGetQuestions.fieldKey[14]]#" class="#qGetQuestions.classType[14]#" maxlength="100" />
		</div>
		
		<!--- Business Position --->
		<div class="field">
			<label for="#qGetQuestions.fieldKey[15]#">#qGetQuestions.displayField[15]# <cfif qGetQuestions.isRequired[15]><em>*</em></cfif></label> 
			<input type="text" name="#qGetQuestions.fieldKey[15]#" id="#qGetQuestions.fieldKey[15]#" value="#FORM[qGetQuestions.fieldKey[15]]#" class="#qGetQuestions.classType[15]#" maxlength="100" />
		</div>
		
		<!--- Business Address --->
		<div class="field">
			<label for="#qGetQuestions.fieldKey[16]#">#qGetQuestions.displayField[16]# <cfif qGetQuestions.isRequired[16]><em>*</em></cfif></label> 
			<input type="text" name="#qGetQuestions.fieldKey[16]#" id="#qGetQuestions.fieldKey[16]#" value="#FORM[qGetQuestions.fieldKey[16]]#" class="#qGetQuestions.classType[16]#" maxlength="100" />
		</div>
		
		<!--- Business City --->
		<div class="field">
			<label for="#qGetQuestions.fieldKey[17]#">#qGetQuestions.displayField[17]# <cfif qGetQuestions.isRequired[17]><em>*</em></cfif></label> 
			<input type="text" name="#qGetQuestions.fieldKey[17]#" id="#qGetQuestions.fieldKey[17]#" value="#FORM[qGetQuestions.fieldKey[17]]#" class="#qGetQuestions.classType[17]#" maxlength="50" />
		</div>

		<!--- Business State --->
		<div class="field">
			<label for="#qGetQuestions.fieldKey[18]#">#qGetQuestions.displayField[18]# <cfif qGetQuestions.isRequired[18]><em>*</em></cfif></label> 
			<input type="text" name="#qGetQuestions.fieldKey[18]#" id="#qGetQuestions.fieldKey[18]#" value="#FORM[qGetQuestions.fieldKey[18]]#" class="#qGetQuestions.classType[18]#" maxlength="50" />
		</div>

		<!--- Business Zip --->
		<div class="field">
			<label for="#qGetQuestions.fieldKey[19]#">#qGetQuestions.displayField[19]# <cfif qGetQuestions.isRequired[19]><em>*</em></cfif></label> 
			<input type="text" name="#qGetQuestions.fieldKey[19]#" id="#qGetQuestions.fieldKey[19]#" value="#FORM[qGetQuestions.fieldKey[19]]#" class="#qGetQuestions.classType[19]#" maxlength="50" />
		</div>
		
		<!--- Business Coutry --->
		<div class="field">
			<label for="#qGetQuestions.fieldKey[20]#">#qGetQuestions.displayField[20]# <cfif qGetQuestions.isRequired[20]><em>*</em></cfif></label> 
			<select name="#qGetQuestions.fieldKey[20]#" id="#qGetQuestions.fieldKey[20]#" class="mediumField">
				<option value=""></option>
				<cfloop query="qGetCountry">
					<option value="#qGetCountry.ID#" <cfif FORM[qGetQuestions.fieldKey[20]] EQ qGetCountry.ID> selected="selected" </cfif> >#qGetCountry.name#</option>
				</cfloop>
			</select>
		</div>

		<!--- Business Telephone --->
		<div class="field">
			<label for="businessPhoneCountry">#qGetQuestions.displayField[21]# <cfif qGetQuestions.isRequired[21]><em>*</em></cfif></label> 
			<input type="text" name="businessPhoneCountry" id="businessPhoneCountry" value="#FORM.homePhoneCountry#" class="xxSmallField" maxlength="4" /> 
			-
			<input type="text" name="businessPhoneArea" id="businessPhoneArea" value="#FORM.homePhoneArea#" class="xxSmallField" maxlength="4" />                  
			- 
			<input type="text" name="businessPhonePrefix" id="businessPhonePrefix" value="#FORM.homePhonePrefix#" class="xxSmallField" maxlength="4" /> 
			- 
			<input type="text" name="businessPhoneNumber" id="businessPhoneNumber" value="#FORM.homePhoneNumber#" class="xxSmallField" maxlength="6" />
			<p class="note">+#### - (######) - ###### - ########</p>
		</div>

	</fieldset>
	

	<!--- Other Information --->
	<fieldset>
	   
		<legend>Other Information</legend>
		
		<!--- Applicant Lives --->
		<div class="controlset">
			<span class="label">#qGetQuestions.displayField[22]# <cfif qGetQuestions.isRequired[22]><em>*</em></cfif></span>
            <input type="checkbox" name="#qGetQuestions.fieldKey[22]#" id="livesFather" value="Father" <cfif ListFind(FORM[qGetQuestions.fieldKey[22]], 'Father')> checked="checked" </cfif> /> <label for="livesFather">Father</label>
            <input type="checkbox" name="#qGetQuestions.fieldKey[22]#" id="livesMother" value="Mother" <cfif ListFind(FORM[qGetQuestions.fieldKey[22]], 'Mother')> checked="checked" </cfif> /> <label for="livesMother">Mother</label>
            <input type="checkbox" name="#qGetQuestions.fieldKey[22]#" id="livesGuardian" value="Guardian" <cfif ListFind(FORM[qGetQuestions.fieldKey[22]], 'Guardian')> checked="checked" </cfif> /> <label for="livesGuardian">Guardian</label>
            <input type="checkbox" name="#qGetQuestions.fieldKey[22]#" id="livesOther" value="Other" <cfif ListFind(FORM[qGetQuestions.fieldKey[22]], 'Other')> checked="checked" </cfif> /> <label for="livesOther">Other</label>
            <p class="note">(Mark all that apply)</p>
		</div>			

		<!--- Admission Materials --->
		<div class="controlset">
			<span class="label">#qGetQuestions.displayField[23]# <cfif qGetQuestions.isRequired[23]><em>*</em></cfif></span>
			<div class="field">
                <input type="radio" name="#qGetQuestions.fieldKey[23]#" id="materialFather" value="Father" <cfif FORM[qGetQuestions.fieldKey[23]] EQ 'Father'> checked="checked" </cfif> /> <label for="materialFather">Father</label>
                <input type="radio" name="#qGetQuestions.fieldKey[23]#" id="materialMother" value="Mother" <cfif FORM[qGetQuestions.fieldKey[23]] EQ 'Mother'> checked="checked" </cfif> /> <label for="materialMother">Mother</label>
                <input type="radio" name="#qGetQuestions.fieldKey[23]#" id="materialGuardian" value="Guardian" <cfif FORM[qGetQuestions.fieldKey[23]] EQ 'Guardian'> checked="checked" </cfif> /> <label for="materialGuardian">Guardian</label>
                <input type="radio" name="#qGetQuestions.fieldKey[23]#" id="materialOther" value="Other" <cfif FORM[qGetQuestions.fieldKey[23]] EQ 'Other'> checked="checked" </cfif> /> <label for="materialOther">Other</label>
			</div>
        </div>
		
        <div style="clear:both;"></div>
        	
		<!--- Parent Lives --->
        <div class="controlset">
			<span class="label">#qGetQuestions.displayField[24]# <cfif qGetQuestions.isRequired[24]><em>*</em></cfif></span>
            <div class="field">
                <input type="checkbox" name="#qGetQuestions.fieldKey[24]#" id="fatherDeceased" value="fatherDeceased" <cfif ListFind(FORM[qGetQuestions.fieldKey[24]], 'fatherDeceased')> checked="checked" </cfif> /> <label for="fatherDeceased">Father Deceased</label>
                <input type="checkbox" name="#qGetQuestions.fieldKey[24]#" id="motherDeceased" value="motherDeceased" <cfif ListFind(FORM[qGetQuestions.fieldKey[24]], 'motherDeceased')> checked="checked" </cfif> /> <label for="motherDeceased">Mother Deceased</label>
                <input type="checkbox" name="#qGetQuestions.fieldKey[24]#" id="parentsDivorced" value="parentsDivorced" <cfif ListFind(FORM[qGetQuestions.fieldKey[24]], 'parentsDivorced')> checked="checked" </cfif> /> <label for="parentsDivorced">Parents Divorced</label>
                <input type="checkbox" name="#qGetQuestions.fieldKey[24]#" id="parentsSeparated" value="parentsSeparated" <cfif ListFind(FORM[qGetQuestions.fieldKey[24]], 'parentsSeparated')> checked="checked" </cfif> /> <label for="parentsSeparated">Parents Separated</label> 
                <br />        	
                <input type="checkbox" name="#qGetQuestions.fieldKey[24]#" id="fatherRemarried" value="fatherRemarried" <cfif ListFind(FORM[qGetQuestions.fieldKey[24]], 'fatherRemarried')> checked="checked" </cfif> /> <label for="fatherRemarried">Father Remarried</label>
                <input type="checkbox" name="#qGetQuestions.fieldKey[24]#" id="motherRemarried" value="motherRemarried" <cfif ListFind(FORM[qGetQuestions.fieldKey[24]], 'motherRemarried')> checked="checked" </cfif> /> <label for="motherRemarried">Mother Remarried</label>
                <input type="checkbox" name="#qGetQuestions.fieldKey[24]#" id="livingOutside" value="livingOutside" <cfif ListFind(FORM[qGetQuestions.fieldKey[24]], 'livingOutside')> checked="checked" </cfif> /> <label for="livingOutside">Living Outside U.S.</label>
            </div>
        </div>

		<!--- Parent Custody --->
        <div class="field">
			<label for="#qGetQuestions.fieldKey[25]#">#qGetQuestions.displayField[25]# <cfif qGetQuestions.isRequired[25]><em>*</em></cfif></label> 
			<input type="text" name="#qGetQuestions.fieldKey[25]#" id="#qGetQuestions.fieldKey[25]#" value="#FORM[qGetQuestions.fieldKey[25]]#" class="#qGetQuestions.classType[25]#" maxlength="50" />
		</div>

		<div style="clear:both;"></div>

		<!--- Financial Aid --->
        <div class="controlset">
			<span class="label">#qGetQuestions.displayField[26]# <cfif qGetQuestions.isRequired[26]><em>*</em></cfif></span>
            <input type="radio" name="#qGetQuestions.fieldKey[26]#" id="financialYes" value="1" <cfif FORM[qGetQuestions.fieldKey[26]] EQ 1> checked="checked" </cfif> /> <label for="financialYes">Yes</label>
			<input type="radio" name="#qGetQuestions.fieldKey[26]#" id="financialNo" value="0" <cfif FORM[qGetQuestions.fieldKey[26]] EQ 0> checked="checked" </cfif> /> <label for="financialNo">No</label>
        </div>

	</fieldset>

	<div class="buttonrow">
		<input type="submit" value="Save" class="button ui-corner-top" />
	</div>

	</form>

</div><!-- /form-container -->

</cfoutput>