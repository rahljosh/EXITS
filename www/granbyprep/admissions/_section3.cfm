<!--- ------------------------------------------------------------------------- ----
	
	File:		_section3.cfm
	Author:		Marcus Melo
	Date:		June 14, 2010
	Desc:		Section 3 of the Online Application - Additional Family Information

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
	<!--- Parent Information ---> 
    <cfparam name="FORM.addParentHomePhoneCountry" default="">
    <cfparam name="FORM.addParentHomePhoneArea" default="">
    <cfparam name="FORM.addParentHomePhonePrefix" default="">
    <cfparam name="FORM.addParentHomePhoneNumber" default="">
    <cfparam name="FORM.addParentaddParentFaxCountry" default="">
    <cfparam name="FORM.addParentFaxArea" default="">
    <cfparam name="FORM.addParentFaxPrefix" default="">
    <cfparam name="FORM.addParentFaxNumber" default="">
    <cfparam name="FORM.addParentBusinessPhoneCountry" default="">
    <cfparam name="FORM.addParentBusinessPhoneArea" default="">
    <cfparam name="FORM.addParentBusinessPhonePrefix" default="">
    <cfparam name="FORM.addParentBusinessPhoneNumber" default="">

    <cfscript>
		// Get Current Student Information
		// qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(ID=FORM.studentID);

		// Gets a List of States
		qGetStates = APPLICATION.CFC.LOOKUPTABLES.getState();

		// Get Current Student Information
		qGetCountry = APPLICATION.CFC.LOOKUPTABLES.getCountry();

		// Get Questions for this section
		qGetQuestionsSection3 = APPLICATION.CFC.ONLINEAPP.getQuestionByFilter(sectionName='section3');
		
		// Get Answers for this section
		qGetAnswersSection3 = APPLICATION.CFC.ONLINEAPP.getAnswerByFilter(sectionName='section3', foreignTable='student', foreignID=FORM.studentID);

		// Param Online Application Form Variables 
		for ( i=1; i LTE qGetQuestionsSection3.recordCount; i=i+1 ) {
			param name="FORM[qGetQuestionsSection3.fieldKey[i]]" default="";
		}
	
		// FORM Submitted
		if ( FORM.submittedType EQ 'section3' ) {

			// Parent Phone
			FORM[qGetQuestionsSection3.fieldKey[11]] = APPLICATION.CFC.UDF.formatPhoneNumber(countryCode=FORM.addParentHomePhoneCountry, areaCode=FORM.addParentHomePhoneArea, prefix=FORM.addParentHomePhonePrefix, number=FORM.addParentHomePhoneNumber);
			// Parent addParentFax
			FORM[qGetQuestionsSection3.fieldKey[12]] = APPLICATION.CFC.UDF.formatPhoneNumber(countryCode=FORM.addParentFaxCountry, areaCode=FORM.addParentFaxArea, prefix=FORM.addParentFaxPrefix, number=FORM.addParentFaxNumber);					
			// Parent Business Phone
			FORM[qGetQuestionsSection3.fieldKey[21]] = APPLICATION.CFC.UDF.formatPhoneNumber(countryCode=FORM.addParentBusinessPhoneCountry, areaCode=FORM.addParentBusinessPhoneArea, prefix=FORM.addParentBusinessPhonePrefix, number=FORM.addParentBusinessPhoneNumber);									

			// FORM Validation
			for ( i=1; i LTE qGetQuestionsSection3.recordCount; i=i+1 ) {
				if (qGetQuestionsSection3.isRequired[i] AND NOT LEN(FORM[qGetQuestionsSection3.fieldKey[i]]) ) {
					SESSION.formErrors.Add(qGetQuestionsSection3.requiredMessage[i]);
				}
			}
			
			// Check if there are no errors
			if ( NOT SESSION.formErrors.length() ) {				
				
				// Insert/Update Application Fields 
				for ( i=1; i LTE qGetQuestionsSection3.recordCount; i=i+1 ) {
					APPLICATION.CFC.ONLINEAPP.insertAnswer(	
						applicationQuestionID=qGetQuestionsSection3.ID[i],
						foreignTable='student',
						foreignID=FORM.studentID,
						fieldKey=qGetQuestionsSection3.fieldKey[i],
						answer=FORM[qGetQuestionsSection3.fieldKey[i]]						
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

			// Online Application Fields 
			for ( i=1; i LTE qGetAnswersSection3.recordCount; i=i+1 ) {
				FORM[qGetAnswersSection3.fieldKey[i]] = qGetAnswersSection3.answer[i];
			}

			// Break Down Phone Numbers
			staddParentHomePhone = APPLICATION.CFC.UDF.breakDownPhoneNumber(qGetAnswersSection3.answer[11]);
			staddParentFax = APPLICATION.CFC.UDF.breakDownPhoneNumber(qGetAnswersSection3.answer[12]);
			staddParentBusinessPhone = APPLICATION.CFC.UDF.breakDownPhoneNumber(qGetAnswersSection3.answer[21]);

			FORM.addParentHomePhoneCountry = staddParentHomePhone.countryCode;
			FORM.addParentHomePhoneArea = staddParentHomePhone.areaCode;
			FORM.addParentHomePhonePrefix = staddParentHomePhone.prefix;
			FORM.addParentHomePhoneNumber = staddParentHomePhone.number;
			FORM.addParentFaxCountry = staddParentFax.countryCode;
			FORM.addParentFaxArea = staddParentFax.areaCode;
			FORM.addParentFaxPrefix = staddParentFax.prefix;
			FORM.addParentFaxNumber = staddParentFax.number;
			FORM.addParentBusinessPhoneCountry = staddParentBusinessPhone.countryCode;
			FORM.addParentBusinessPhoneArea = staddParentBusinessPhone.areaCode;
			FORM.addParentBusinessPhonePrefix = staddParentBusinessPhone.prefix;
			FORM.addParentBusinessPhoneNumber = staddParentBusinessPhone.number;
			
		}
	</cfscript>
    
</cfsilent>

<script type="text/javascript">
	// JQuery Validator
	$().ready(function() {
		var container = $('div.errorContainer');
		// validate the form when it is submitted
		var validator = $("#section3Form").validate({
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
		<cfloop query="qGetQuestionsSection3">
        	<cfif qGetQuestionsSection3.isRequired>
				<li><label for="#qGetQuestionsSection3.fieldKey#" class="error">#qGetQuestionsSection3.requiredMessage#</label></li>
            </cfif>
		</cfloop>
	</ol>
	
	<p>Data has <strong>not</strong> been saved.</p>
</div>

<!--- Application Body --->
<div class="form-container">
	
    <!--- Only Display Messages if Current tab is updated --->
  	<cfif currentTabID EQ 2>
    
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

	<form id="section3Form" action="#CGI.SCRIPT_NAME#?action=initial" method="post">
	<input type="hidden" name="submittedType" value="section3" />
    <input type="hidden" name="currentTabID" value="2" />
	
	<p class="legend"><strong>Note:</strong> Required fields are marked with an asterisk (<em>*</em>)</p>
	
	<!--- Parent/Guardian --->
	<fieldset>
	   
		<legend>Parent/Guardian</legend>
		
		<!--- Parent Relationship --->
		<div class="field">
			<label for="#qGetQuestionsSection3.fieldKey[1]#">#qGetQuestionsSection3.displayField[1]# <cfif qGetQuestionsSection3.isRequired[1]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestionsSection3.fieldKey[1]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestionsSection3.fieldKey[1]#" id="#qGetQuestionsSection3.fieldKey[1]#" value="#FORM[qGetQuestionsSection3.fieldKey[1]]#" class="#qGetQuestionsSection3.classType[1]#" maxlength="100" />
            </cfif>
		</div>
		
		<!--- Parent First Name --->
		<div class="field">
			<label for="#qGetQuestionsSection3.fieldKey[2]#">#qGetQuestionsSection3.displayField[2]# <cfif qGetQuestionsSection3.isRequired[2]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestionsSection3.fieldKey[2]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestionsSection3.fieldKey[2]#" id="#qGetQuestionsSection3.fieldKey[2]#" value="#FORM[qGetQuestionsSection3.fieldKey[2]]#" class="#qGetQuestionsSection3.classType[2]#" maxlength="100" />
            </cfif>
		</div>
		
		<!--- Parent Middle Name --->
		<div class="field">
			<label for="#qGetQuestionsSection3.fieldKey[3]#">#qGetQuestionsSection3.displayField[3]# <cfif qGetQuestionsSection3.isRequired[3]><em>*</em></cfif></label>  
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestionsSection3.fieldKey[3]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestionsSection3.fieldKey[3]#" id="#qGetQuestionsSection3.fieldKey[3]#" value="#FORM[qGetQuestionsSection3.fieldKey[3]]#" class="#qGetQuestionsSection3.classType[3]#" maxlength="100" />
            </cfif>
		</div>
		
		<!--- Parent Last Name --->
		<div class="field">
			<label for="#qGetQuestionsSection3.fieldKey[4]#">#qGetQuestionsSection3.displayField[4]# <cfif qGetQuestionsSection3.isRequired[4]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestionsSection3.fieldKey[4]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestionsSection3.fieldKey[4]#" id="#qGetQuestionsSection3.fieldKey[4]#" value="#FORM[qGetQuestionsSection3.fieldKey[4]]#" class="#qGetQuestionsSection3.classType[4]#" maxlength="100" />
            </cfif>
		</div>
		
		<!--- Parent Preferred Name ---> 
		<div class="field">
			<label for="#qGetQuestionsSection3.fieldKey[5]#">#qGetQuestionsSection3.displayField[5]# <cfif qGetQuestionsSection3.isRequired[5]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestionsSection3.fieldKey[5]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestionsSection3.fieldKey[5]#" id="#qGetQuestionsSection3.fieldKey[5]#" value="#FORM[qGetQuestionsSection3.fieldKey[5]]#" class="#qGetQuestionsSection3.classType[5]#" maxlength="100" />
            </cfif>
		</div>
		
	</fieldset>


	<!--- Complete Home Address --->
	<fieldset>
	   
		<legend>Complete Home Address</legend>

		<!--- Parent Country --->
		<div class="field">
			<label for="#qGetQuestionsSection3.fieldKey[10]#">#qGetQuestionsSection3.displayField[10]# <cfif qGetQuestionsSection3.isRequired[10]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#APPLICATION.CFC.LOOKUPTABLES.getCountryByID(ID=FORM[qGetQuestionsSection3.fieldKey[10]]).name# &nbsp;</div>
        	<cfelse>
                <select name="#qGetQuestionsSection3.fieldKey[10]#" id="#qGetQuestionsSection3.fieldKey[10]#" class="mediumField" onchange="displayStateField(this.value, 'Section3HomeUsStDiv', 'Section3HomeNonUsStDiv', 'Section3HomeUsStField', 'Section3HomeNonUsStField');">
                    <option value=""></option>
                    <cfloop query="qGetCountry">
                        <option value="#qGetCountry.ID#" <cfif FORM[qGetQuestionsSection3.fieldKey[10]] EQ qGetCountry.ID> selected="selected" </cfif> >#qGetCountry.name#</option>
                    </cfloop>
                </select>
            </cfif>
		</div>

		<!--- Parent Address --->
		<div class="field">
			<label for="#qGetQuestionsSection3.fieldKey[6]#">#qGetQuestionsSection3.displayField[6]# <cfif qGetQuestionsSection3.isRequired[6]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestionsSection3.fieldKey[6]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestionsSection3.fieldKey[6]#" id="#qGetQuestionsSection3.fieldKey[6]#" value="#FORM[qGetQuestionsSection3.fieldKey[6]]#" class="#qGetQuestionsSection3.classType[6]#" maxlength="100" />
            </cfif>
		</div>
		
		<!--- Parent City --->
		<div class="field">
			<label for="#qGetQuestionsSection3.fieldKey[7]#">#qGetQuestionsSection3.displayField[7]# <cfif qGetQuestionsSection3.isRequired[7]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestionsSection3.fieldKey[7]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestionsSection3.fieldKey[7]#" id="#qGetQuestionsSection3.fieldKey[7]#" value="#FORM[qGetQuestionsSection3.fieldKey[7]]#" class="#qGetQuestionsSection3.classType[7]#" maxlength="100" />
            </cfif>
		</div>
		
        <cfif printApplication>
	        <!--- State Print Application --->	
            <div class="field">
                <label for="#qGetQuestionsSection3.fieldKey[8]#">#qGetQuestionsSection3.displayField[8]# <cfif qGetQuestionsSection3.isRequired[8]><em>*</em></cfif></label> 
                <div class="printField">#FORM[qGetQuestionsSection3.fieldKey[8]]# &nbsp;</div>
            </div>
		<cfelse>
			<!--- Parent US State --->
            <div class="field hiddenField" id="Section3HomeUsStDiv">
                <label for="#qGetQuestionsSection3.fieldKey[8]#">State/Province <em>*</em></label> 
                <select name="#qGetQuestionsSection3.fieldKey[8]#" id="#qGetQuestionsSection3.fieldKey[8]#" class="mediumField sec2HomeUsStField">
                    <option value=""></option> <!--- [select a state] ---->
                    <cfloop query="qGetStates">
                        <option value="#qGetStates.code#" <cfif FORM[qGetQuestionsSection3.fieldKey[8]] EQ qGetStates.code> selected="selected" </cfif> >#qGetStates.name#</option>
                    </cfloop>
                </select>
            </div>
            
            <!--- Parent Non US State --->
            <div class="field hiddenField" id="Section3HomeNonUsStDiv">
                <label for="#qGetQuestionsSection3.fieldKey[8]#">#qGetQuestionsSection3.displayField[8]# <cfif qGetQuestionsSection3.isRequired[8]><em>*</em></cfif></label> 
                <input type="text" name="#qGetQuestionsSection3.fieldKey[8]#" id="#qGetQuestionsSection3.fieldKey[8]#" value="#FORM[qGetQuestionsSection3.fieldKey[8]]#" class="#qGetQuestionsSection3.classType[8]# sec2HomeNonUsStField" maxlength="100" />
            </div>
		</cfif>
		
		<!--- Parent Zip --->
		<div class="field">
			<label for="#qGetQuestionsSection3.fieldKey[9]#">#qGetQuestionsSection3.displayField[9]# <cfif qGetQuestionsSection3.isRequired[9]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestionsSection3.fieldKey[9]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestionsSection3.fieldKey[9]#" id="#qGetQuestionsSection3.fieldKey[9]#" value="#FORM[qGetQuestionsSection3.fieldKey[9]]#" class="#qGetQuestionsSection3.classType[9]#" maxlength="50" />
            </cfif>
		</div>
		
		<!--- Parent Home Telephone --->
		<div class="field">
			<label for="addParentHomePhoneCountry">#qGetQuestionsSection3.displayField[11]# <cfif qGetQuestionsSection3.isRequired[11]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField"> 
                	#APPLICATION.CFC.UDF.formatPhoneNumber(
                    	countryCode=FORM.addParentHomePhoneCountry, 
                        areaCode=FORM.addParentHomePhoneArea, 
                        prefix=FORM.addParentHomePhonePrefix, 
                        number=FORM.addParentHomePhoneNumber)# &nbsp;
                </div>
        	<cfelse>
                <input type="text" name="addParentHomePhoneCountry" id="addParentHomePhoneCountry" value="#FORM.addParentHomePhoneCountry#" class="xxSmallField" maxlength="4" /> 
                -
                <input type="text" name="addParentHomePhoneArea" id="addParentHomePhoneArea" value="#FORM.addParentHomePhoneArea#" class="xxSmallField" maxlength="4" />                  
                - 
                <input type="text" name="addParentHomePhonePrefix" id="addParentHomePhonePrefix" value="#FORM.addParentHomePhonePrefix#" class="xxSmallField" maxlength="4" /> 
                - 
                <input type="text" name="addParentHomePhoneNumber" id="addParentHomePhoneNumber" value="#FORM.addParentHomePhoneNumber#" class="xxSmallField" maxlength="6" />
                <p class="note"> 
                    <span class="phoneNote">country</span> 
                    <span class="phoneNote">area</span>  
                    <span class="phoneNote">prefix</span> 
                    <span class="phoneNote">number</span>
                </p>
            </cfif>
		</div>

		<!--- Parent addParentFax Telephone --->
		<div class="field">
			<label for="addParentFaxCountry">#qGetQuestionsSection3.displayField[12]# <cfif qGetQuestionsSection3.isRequired[12]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField"> 
                	#APPLICATION.CFC.UDF.formatPhoneNumber(
                    	countryCode=FORM.addParentFaxCountry, 
                        areaCode=FORM.addParentFaxArea, 
                        prefix=FORM.addParentFaxPrefix, 
                        number=FORM.addParentFaxNumber)# &nbsp;
                </div>
        	<cfelse>
                <input type="text" name="addParentFaxCountry" id="addParentFaxCountry" value="#FORM.addParentFaxCountry#" class="xxSmallField" maxlength="4" /> 
                - 
                <input type="text" name="addParentFaxArea" id="addParentFaxArea" value="#FORM.addParentFaxArea#" class="xxSmallField" maxlength="4" />                  
                - 
                <input type="text" name="addParentFaxPrefix" id="addParentFaxPrefix" value="#FORM.addParentFaxPrefix#" class="xxSmallField" maxlength="4" /> 
                - 
                <input type="text" name="addParentFaxNumber" id="addParentFaxNumber" value="#FORM.addParentFaxNumber#" class="xxSmallField" maxlength="6" />
                <p class="note"> 
                    <span class="phoneNote">country</span> 
                    <span class="phoneNote">area</span>  
                    <span class="phoneNote">prefix</span> 
                    <span class="phoneNote">number</span>
                </p>
            </cfif>
		</div>

		<!--- Parent Email --->
		<div class="field">
			<label for="#qGetQuestionsSection3.fieldKey[13]#">#qGetQuestionsSection3.displayField[13]# <cfif qGetQuestionsSection3.isRequired[13]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestionsSection3.fieldKey[13]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestionsSection3.fieldKey[13]#" id="#qGetQuestionsSection3.fieldKey[13]#" value="#FORM[qGetQuestionsSection3.fieldKey[13]]#" class="#qGetQuestionsSection3.classType[13]#" maxlength="50" />
            </cfif>
		</div>

	</fieldset>
	
	
	<!--- Business Information --->
	<fieldset>
	   
		<legend>Business Information</legend>
		
		<!--- Company Name --->
		<div class="field">
			<label for="#qGetQuestionsSection3.fieldKey[14]#">#qGetQuestionsSection3.displayField[14]# <cfif qGetQuestionsSection3.isRequired[14]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestionsSection3.fieldKey[14]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestionsSection3.fieldKey[14]#" id="#qGetQuestionsSection3.fieldKey[14]#" value="#FORM[qGetQuestionsSection3.fieldKey[14]]#" class="#qGetQuestionsSection3.classType[14]#" maxlength="100" />
            </cfif>
		</div>
		
		<!--- Business Position --->
		<div class="field">
			<label for="#qGetQuestionsSection3.fieldKey[15]#">#qGetQuestionsSection3.displayField[15]# <cfif qGetQuestionsSection3.isRequired[15]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestionsSection3.fieldKey[15]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestionsSection3.fieldKey[15]#" id="#qGetQuestionsSection3.fieldKey[15]#" value="#FORM[qGetQuestionsSection3.fieldKey[15]]#" class="#qGetQuestionsSection3.classType[15]#" maxlength="100" />
            </cfif>
		</div>

		<!--- Business Country --->
		<div class="field">
			<label for="#qGetQuestionsSection3.fieldKey[20]#">#qGetQuestionsSection3.displayField[20]# <cfif qGetQuestionsSection3.isRequired[20]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#APPLICATION.CFC.LOOKUPTABLES.getCountryByID(ID=FORM[qGetQuestionsSection3.fieldKey[20]]).name# &nbsp;</div>
        	<cfelse>
                <select name="#qGetQuestionsSection3.fieldKey[20]#" id="#qGetQuestionsSection3.fieldKey[20]#" class="mediumField" onchange="displayStateField(this.value, 'Section3BusUsStDiv', 'Section3BusNonUsStDiv', 'Section3UsBusStField', 'Section3BusNonUsStField');">
                    <option value=""></option>
                    <cfloop query="qGetCountry">
                        <option value="#qGetCountry.ID#" <cfif FORM[qGetQuestionsSection3.fieldKey[20]] EQ qGetCountry.ID> selected="selected" </cfif> >#qGetCountry.name#</option>
                    </cfloop>
                </select>
            </cfif>
		</div>
		
		<!--- Business Address --->
		<div class="field">
			<label for="#qGetQuestionsSection3.fieldKey[16]#">#qGetQuestionsSection3.displayField[16]# <cfif qGetQuestionsSection3.isRequired[16]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestionsSection3.fieldKey[16]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestionsSection3.fieldKey[16]#" id="#qGetQuestionsSection3.fieldKey[16]#" value="#FORM[qGetQuestionsSection3.fieldKey[16]]#" class="#qGetQuestionsSection3.classType[16]#" maxlength="100" />
            </cfif>
		</div>
		
		<!--- Business City --->
		<div class="field">
			<label for="#qGetQuestionsSection3.fieldKey[17]#">#qGetQuestionsSection3.displayField[17]# <cfif qGetQuestionsSection3.isRequired[17]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestionsSection3.fieldKey[17]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestionsSection3.fieldKey[17]#" id="#qGetQuestionsSection3.fieldKey[17]#" value="#FORM[qGetQuestionsSection3.fieldKey[17]]#" class="#qGetQuestionsSection3.classType[17]#" maxlength="50" />
            </cfif>
		</div>

        <cfif printApplication>
	        <!--- State Print Application --->	
            <div class="field">
                <label for="#qGetQuestionsSection3.fieldKey[18]#">#qGetQuestionsSection3.displayField[18]# <cfif qGetQuestionsSection3.isRequired[18]><em>*</em></cfif></label> 
                <div class="printField">#FORM[qGetQuestionsSection3.fieldKey[18]]# &nbsp;</div>
            </div>
		<cfelse>
			<!--- Business US State --->
            <div class="field hiddenField" id="sec2BusUsStDiv">
                <label for="#qGetQuestionsSection3.fieldKey[18]#">State/Province <em>*</em></label> 
                <select name="#qGetQuestionsSection3.fieldKey[18]#" id="#qGetQuestionsSection3.fieldKey[18]#" class="mediumField sec2UsBusStField">
                    <option value=""></option> <!--- [select a state] ---->
                    <cfloop query="qGetStates">
                        <option value="#qGetStates.code#" <cfif FORM[qGetQuestionsSection3.fieldKey[18]] EQ qGetStates.code> selected="selected" </cfif> >#qGetStates.name#</option>
                    </cfloop>
                </select>
            </div>
    
            <!--- Business Non Us State --->
            <div class="field hiddenField" id="sec2BusNonUsStDiv">
                <label for="#qGetQuestionsSection3.fieldKey[18]#">#qGetQuestionsSection3.displayField[18]# <cfif qGetQuestionsSection3.isRequired[18]><em>*</em></cfif></label> 
                <input type="text" name="#qGetQuestionsSection3.fieldKey[18]#" id="#qGetQuestionsSection3.fieldKey[18]#" value="#FORM[qGetQuestionsSection3.fieldKey[18]]#" class="#qGetQuestionsSection3.classType[18]# sec2BusNonUsStField" maxlength="50" />
            </div>
		</cfif>

		<!--- Business Zip --->
		<div class="field">
			<label for="#qGetQuestionsSection3.fieldKey[19]#">#qGetQuestionsSection3.displayField[19]# <cfif qGetQuestionsSection3.isRequired[19]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestionsSection3.fieldKey[19]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestionsSection3.fieldKey[19]#" id="#qGetQuestionsSection3.fieldKey[19]#" value="#FORM[qGetQuestionsSection3.fieldKey[19]]#" class="#qGetQuestionsSection3.classType[19]#" maxlength="50" />
            </cfif>
		</div>

		<!--- Business Telephone --->
		<div class="field">
			<label for="addParentBusinessPhoneCountry">#qGetQuestionsSection3.displayField[21]# <cfif qGetQuestionsSection3.isRequired[21]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">
                	#APPLICATION.CFC.UDF.formatPhoneNumber(
                    	countryCode=FORM.addParentBusinessPhoneCountry, 
                        areaCode=FORM.addParentBusinessPhoneArea, 
                        prefix=FORM.addParentBusinessPhonePrefix, 
                        number=FORM.addParentBusinessPhoneNumber)# &nbsp;
                </div>
        	<cfelse>
                <input type="text" name="addParentBusinessPhoneCountry" id="addParentBusinessPhoneCountry" value="#FORM.addParentBusinessPhoneCountry#" class="xxSmallField" maxlength="4" /> 
                -
                <input type="text" name="addParentBusinessPhoneArea" id="addParentBusinessPhoneArea" value="#FORM.addParentBusinessPhoneArea#" class="xxSmallField" maxlength="4" />                  
                - 
                <input type="text" name="addParentBusinessPhonePrefix" id="addParentBusinessPhonePrefix" value="#FORM.addParentBusinessPhonePrefix#" class="xxSmallField" maxlength="4" /> 
                - 
                <input type="text" name="addParentBusinessPhoneNumber" id="addParentBusinessPhoneNumber" value="#FORM.addParentBusinessPhoneNumber#" class="xxSmallField" maxlength="6" />
                <p class="note"> 
                    <span class="phoneNote">country</span> 
                    <span class="phoneNote">area</span>  
                    <span class="phoneNote">prefix</span> 
                    <span class="phoneNote">number</span>
                </p>
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
	// Display State Field
	$(document).ready(function() {
		
		// Get Current Country Value
		Section3GetHomeCountry = $("###qGetQuestionsSection3.fieldKey[10]#").val();
		displayStateField(Section3GetHomeCountry, 'Section3HomeUsStDiv', 'Section3HomeNonUsStDiv', 'Section3HomeUsStField', 'Section3HomeNonUsStField');

		// Get Current Country Value
		Section3GetBusCountry = $("###qGetQuestionsSection3.fieldKey[20]#").val();
		displayStateField(Section3GetBusCountry, 'Section3BusUsStDiv', 'Section3BusNonUsStDiv', 'Section3UsBusStField', 'Section3BusNonUsStField');

	});
</script>

</cfoutput>