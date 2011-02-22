<!--- ------------------------------------------------------------------------- ----
	
	File:		_section2.cfm
	Author:		Marcus Melo
	Date:		June 14, 2010
	Desc:		Section 2 of the Online Application - Family Information

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customtags/gui/" prefix="gui" />	

	<!--- It is set to 1 for the print application page --->
	<cfparam name="printApplication" default="0">

	<!--- Param FORM Variables --->
    <cfparam name="FORM.submittedType" default="">
    <cfparam name="FORM.currentTabID" default="0">
    <!--- Student Details --->
    <cfparam name="FORM.studentID" default="#APPLICATION.CFC.STUDENT.getStudentID()#">
	<!--- Parent Information ---> 
    <cfparam name="FORM.parentHomePhoneCountry" default="">
    <cfparam name="FORM.parentHomePhoneArea" default="">
    <cfparam name="FORM.parentHomePhonePrefix" default="">
    <cfparam name="FORM.parentHomePhoneNumber" default="">
    <cfparam name="FORM.parentFaxCountry" default="">
    <cfparam name="FORM.parentFaxArea" default="">
    <cfparam name="FORM.parentFaxPrefix" default="">
    <cfparam name="FORM.parentFaxNumber" default="">
    <cfparam name="FORM.businessPhoneCountry" default="">
    <cfparam name="FORM.businessPhoneArea" default="">
    <cfparam name="FORM.businessPhonePrefix" default="">
    <cfparam name="FORM.businessPhoneNumber" default="">
    <cfparam name="FORM.hasAddFamInfo" default="">

    <cfscript>
		// Get Current Student Information
		// qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(ID=FORM.studentID);

		// Gets a List of States
		qGetStates = APPLICATION.CFC.LOOKUPTABLES.getState();

		// Get Current Student Information
		qGetCountry = APPLICATION.CFC.LOOKUPTABLES.getCountry();

		// Get Questions for this section
		qGetQuestionsSection2 = APPLICATION.CFC.ONLINEAPP.getQuestionByFilter(sectionName='section2');
		
		// Get Answers for this section
		qGetAnswersSection2 = APPLICATION.CFC.ONLINEAPP.getAnswerByFilter(sectionName='section2', foreignTable='student', foreignID=FORM.studentID);

		// Param Online Application Form Variables 
		for ( i=1; i LTE qGetQuestionsSection2.recordCount; i=i+1 ) {
			param name="FORM[qGetQuestionsSection2.fieldKey[i]]" default="";
		}
	
		// FORM Submitted
		if ( FORM.submittedType EQ 'section2' ) {

			// Parent Phone
			FORM[qGetQuestionsSection2.fieldKey[11]] = APPLICATION.CFC.UDF.formatPhoneNumber(countryCode=FORM.parentHomePhoneCountry, areaCode=FORM.parentHomePhoneArea, prefix=FORM.parentHomePhonePrefix, number=FORM.parentHomePhoneNumber);
			// Parent parentFax
			FORM[qGetQuestionsSection2.fieldKey[12]] = APPLICATION.CFC.UDF.formatPhoneNumber(countryCode=FORM.parentFaxCountry, areaCode=FORM.parentFaxArea, prefix=FORM.parentFaxPrefix, number=FORM.parentFaxNumber);					
			// Parent Business Phone
			FORM[qGetQuestionsSection2.fieldKey[21]] = APPLICATION.CFC.UDF.formatPhoneNumber(countryCode=FORM.businessPhoneCountry, areaCode=FORM.businessPhoneArea, prefix=FORM.businessPhonePrefix, number=FORM.businessPhoneNumber);									

			// FORM Validation
			for ( i=1; i LTE qGetQuestionsSection2.recordCount; i=i+1 ) {
				if (qGetQuestionsSection2.isRequired[i] AND NOT LEN(FORM[qGetQuestionsSection2.fieldKey[i]]) ) {
					SESSION.formErrors.Add(qGetQuestionsSection2.requiredMessage[i]);
				}
			}

			if ( NOT LEN(FORM.hasAddFamInfo) ) {
				SESSION.formErrors.Add("Please check if you would like to enter an additional family information");
			}

			// Check if there are no errors
			if ( NOT SESSION.formErrors.length() ) {				
				
				// Insert/Update Application Fields 
				for ( i=1; i LTE qGetQuestionsSection2.recordCount; i=i+1 ) {
					APPLICATION.CFC.ONLINEAPP.insertAnswer(	
						applicationQuestionID=qGetQuestionsSection2.ID[i],
						foreignTable='student',
						foreignID=FORM.studentID,
						fieldKey=qGetQuestionsSection2.fieldKey[i],
						answer=FORM[qGetQuestionsSection2.fieldKey[i]]						
					);	
				}
				
				// Update hasAddFamInfo
				APPLICATION.CFC.STUDENT.updateHasAddFamInfo(
					ID=FORM.studentID,
					hasAddFamInfo=FORM.hasAddFamInfo
				);
				
				// Update Student Session Variables
				APPLICATION.CFC.STUDENT.setStudentSession(ID=FORM.studentID);
				
				// Set Page Message
				SESSION.pageMessages.Add("Form successfully submitted.");
				
				// Reload page with updated information
				if ( FORM.hasAddFamInfo ) {
					location("#CGI.SCRIPT_NAME#?action=initial&currentTabID=#FORM.currentTabID + 1#", "no");
				} else {
					location("#CGI.SCRIPT_NAME#?action=initial&currentTabID=#FORM.currentTabID#", "no");
				}
				
			}
			
		} else {

			// Online Application Fields 
			for ( i=1; i LTE qGetAnswersSection2.recordCount; i=i+1 ) {
				FORM[qGetAnswersSection2.fieldKey[i]] = qGetAnswersSection2.answer[i];
			}

			FORM.hasAddFamInfo = qGetStudentInfo.hasAddFamInfo;

			// Break Down Phone Numbers
			stparentHomePhone = APPLICATION.CFC.UDF.breakDownPhoneNumber(qGetAnswersSection2.answer[11]);
			stparentFax = APPLICATION.CFC.UDF.breakDownPhoneNumber(qGetAnswersSection2.answer[12]);
			stBusinessPhone = APPLICATION.CFC.UDF.breakDownPhoneNumber(qGetAnswersSection2.answer[21]);
			
			FORM.parentHomePhoneCountry = stparentHomePhone.countryCode;
			FORM.parentHomePhoneArea = stparentHomePhone.areaCode;
			FORM.parentHomePhonePrefix = stparentHomePhone.prefix;
			FORM.parentHomePhoneNumber = stparentHomePhone.number;
			FORM.parentFaxCountry = stparentFax.countryCode;
			FORM.parentFaxArea = stparentFax.areaCode;
			FORM.parentFaxPrefix = stparentFax.prefix;
			FORM.parentFaxNumber = stparentFax.number;
			FORM.businessPhoneCountry = stBusinessPhone.countryCode;
			FORM.businessPhoneArea = stBusinessPhone.areaCode;
			FORM.businessPhonePrefix = stBusinessPhone.prefix;
			FORM.businessPhoneNumber = stBusinessPhone.number;

		}
	</cfscript>
    
</cfsilent>

<script type="text/javascript">
	// JQuery Validator
	$().ready(function() {
		var container = $('div.errorContainer');
		// validate the form when it is submitted
		var validator = $("#section2Form").validate({
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
		<cfloop query="qGetQuestionsSection2">
        	<cfif qGetQuestionsSection2.isRequired>
				<li><label for="#qGetQuestionsSection2.fieldKey#" class="error">#qGetQuestionsSection2.requiredMessage#</label></li>
            </cfif>
		</cfloop>
	</ol>
	
	<p>Data has <strong>not</strong> been saved.</p>
</div>

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

	<form id="section2Form" action="#CGI.SCRIPT_NAME#?action=initial" method="post">
	<input type="hidden" name="submittedType" value="section2" />
    <input type="hidden" name="currentTabID" value="1" />
	
	<p class="legend"><strong>Note:</strong> Required fields are marked with an asterisk (<em>*</em>)</p>
	
	<!--- Parent/Guardian --->
	<fieldset>
	   
		<legend>Parent/Guardian</legend>
		
		<!--- Parent Relationship --->
		<div class="field">
			<label for="#qGetQuestionsSection2.fieldKey[1]#">#qGetQuestionsSection2.displayField[1]# <cfif qGetQuestionsSection2.isRequired[1]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestionsSection2.fieldKey[1]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestionsSection2.fieldKey[1]#" id="#qGetQuestionsSection2.fieldKey[1]#" value="#FORM[qGetQuestionsSection2.fieldKey[1]]#" class="#qGetQuestionsSection2.classType[1]#" maxlength="100" />
            </cfif>
		</div>
		
		<!--- Parent First Name --->
		<div class="field">
			<label for="#qGetQuestionsSection2.fieldKey[2]#">#qGetQuestionsSection2.displayField[2]# <cfif qGetQuestionsSection2.isRequired[2]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestionsSection2.fieldKey[2]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestionsSection2.fieldKey[2]#" id="#qGetQuestionsSection2.fieldKey[2]#" value="#FORM[qGetQuestionsSection2.fieldKey[2]]#" class="#qGetQuestionsSection2.classType[2]#" maxlength="100" />
            </cfif>
		</div>
		
		<!--- Parent Middle Name --->
		<div class="field">
			<label for="#qGetQuestionsSection2.fieldKey[3]#">#qGetQuestionsSection2.displayField[3]# <cfif qGetQuestionsSection2.isRequired[3]><em>*</em></cfif></label>  
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestionsSection2.fieldKey[3]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestionsSection2.fieldKey[3]#" id="#qGetQuestionsSection2.fieldKey[3]#" value="#FORM[qGetQuestionsSection2.fieldKey[3]]#" class="#qGetQuestionsSection2.classType[3]#" maxlength="100" />
            </cfif>
		</div>
		
		<!--- Parent Last Name --->
		<div class="field">
			<label for="#qGetQuestionsSection2.fieldKey[4]#">#qGetQuestionsSection2.displayField[4]# <cfif qGetQuestionsSection2.isRequired[4]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestionsSection2.fieldKey[4]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestionsSection2.fieldKey[4]#" id="#qGetQuestionsSection2.fieldKey[4]#" value="#FORM[qGetQuestionsSection2.fieldKey[4]]#" class="#qGetQuestionsSection2.classType[4]#" maxlength="100" />
            </cfif>
		</div>
		
		<!--- Parent Preferred Name ---> 
		<div class="field">
			<label for="#qGetQuestionsSection2.fieldKey[5]#">#qGetQuestionsSection2.displayField[5]# <cfif qGetQuestionsSection2.isRequired[5]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestionsSection2.fieldKey[5]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestionsSection2.fieldKey[5]#" id="#qGetQuestionsSection2.fieldKey[5]#" value="#FORM[qGetQuestionsSection2.fieldKey[5]]#" class="#qGetQuestionsSection2.classType[5]#" maxlength="100" />
            </cfif>
		</div>
		
	</fieldset>


	<!--- Complete Home Address --->
	<fieldset>
	   
		<legend>Complete Home Address</legend>

		<!--- Parent Country --->
		<div class="field">
			<label for="#qGetQuestionsSection2.fieldKey[10]#">#qGetQuestionsSection2.displayField[10]# <cfif qGetQuestionsSection2.isRequired[10]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#APPLICATION.CFC.LOOKUPTABLES.getCountryByID(ID=FORM[qGetQuestionsSection2.fieldKey[10]]).name# &nbsp;</div>
        	<cfelse>
                <select name="#qGetQuestionsSection2.fieldKey[10]#" id="#qGetQuestionsSection2.fieldKey[10]#" class="mediumField" onchange="displayStateField(this.value, 'Section2HomeUsStDiv', 'Section2HomeNonUsStDiv', 'Section2HomeUsStField', 'Section2HomeNonUsStField');">
                    <option value=""></option>
                    <cfloop query="qGetCountry">
                        <option value="#qGetCountry.ID#" <cfif FORM[qGetQuestionsSection2.fieldKey[10]] EQ qGetCountry.ID> selected="selected" </cfif> >#qGetCountry.name#</option>
                    </cfloop>
                </select>
            </cfif>
		</div>

		<!--- Parent Address --->
		<div class="field">
			<label for="#qGetQuestionsSection2.fieldKey[6]#">#qGetQuestionsSection2.displayField[6]# <cfif qGetQuestionsSection2.isRequired[6]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestionsSection2.fieldKey[6]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestionsSection2.fieldKey[6]#" id="#qGetQuestionsSection2.fieldKey[6]#" value="#FORM[qGetQuestionsSection2.fieldKey[6]]#" class="#qGetQuestionsSection2.classType[6]#" maxlength="100" />
            </cfif>
		</div>
		
		<!--- Parent City --->
		<div class="field">
			<label for="#qGetQuestionsSection2.fieldKey[7]#">#qGetQuestionsSection2.displayField[7]# <cfif qGetQuestionsSection2.isRequired[7]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestionsSection2.fieldKey[7]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestionsSection2.fieldKey[7]#" id="#qGetQuestionsSection2.fieldKey[7]#" value="#FORM[qGetQuestionsSection2.fieldKey[7]]#" class="#qGetQuestionsSection2.classType[7]#" maxlength="100" />
            </cfif>
		</div>

        <cfif printApplication>
	        <!--- State Print Application --->	
            <div class="field">
                <label for="#qGetQuestionsSection2.fieldKey[8]#">#qGetQuestionsSection2.displayField[8]# <cfif qGetQuestionsSection2.isRequired[8]><em>*</em></cfif></label> 
                <div class="printField">#FORM[qGetQuestionsSection2.fieldKey[8]]# &nbsp;</div>
            </div>
		<cfelse>
			<!--- Parent US State --->
            <div class="field hiddenField" id="Section2HomeUsStDiv">
                <label for="#qGetQuestionsSection2.fieldKey[8]#">State/Province <em>*</em></label> 
                <select name="#qGetQuestionsSection2.fieldKey[8]#" id="#qGetQuestionsSection2.fieldKey[8]#" class="mediumField Section2HomeUsStField">
                    <option value=""></option> <!--- [select a state] ---->
                    <cfloop query="qGetStates">
                        <option value="#qGetStates.code#" <cfif FORM[qGetQuestionsSection2.fieldKey[8]] EQ qGetStates.code> selected="selected" </cfif> >#qGetStates.name#</option>
                    </cfloop>
                </select>
            </div>
            
            <!--- Parent Non US State --->
            <div class="field hiddenField" id="Section2HomeNonUsStDiv">
                <label for="#qGetQuestionsSection2.fieldKey[8]#">#qGetQuestionsSection2.displayField[8]# <cfif qGetQuestionsSection2.isRequired[8]><em>*</em></cfif></label> 
                <input type="text" name="#qGetQuestionsSection2.fieldKey[8]#" id="#qGetQuestionsSection2.fieldKey[8]#" value="#FORM[qGetQuestionsSection2.fieldKey[8]]#" class="#qGetQuestionsSection2.classType[8]# Section2HomeNonUsStField" maxlength="100" />
            </div>
		</cfif>

		<!--- Parent Zip --->
		<div class="field">
			<label for="#qGetQuestionsSection2.fieldKey[9]#">#qGetQuestionsSection2.displayField[9]# <cfif qGetQuestionsSection2.isRequired[9]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestionsSection2.fieldKey[9]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestionsSection2.fieldKey[9]#" id="#qGetQuestionsSection2.fieldKey[9]#" value="#FORM[qGetQuestionsSection2.fieldKey[9]]#" class="#qGetQuestionsSection2.classType[9]#" maxlength="50" />
            </cfif>
		</div>
		
		<!--- Parent Home Telephone --->
		<div class="field">
			<label for="parentHomePhoneCountry">#qGetQuestionsSection2.displayField[11]# <cfif qGetQuestionsSection2.isRequired[11]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField"> 
                	#APPLICATION.CFC.UDF.formatPhoneNumber(
                    	countryCode=FORM.parentHomePhoneCountry, 
                        areaCode=FORM.parentHomePhoneArea, 
                        prefix=FORM.parentHomePhonePrefix, 
                        number=FORM.parentHomePhoneNumber)# &nbsp;
                </div>
        	<cfelse>
                <input type="text" name="parentHomePhoneCountry" id="parentHomePhoneCountry" value="#FORM.parentHomePhoneCountry#" class="xxSmallField" maxlength="4" /> 
                -
                <input type="text" name="parentHomePhoneArea" id="parentHomePhoneArea" value="#FORM.parentHomePhoneArea#" class="xxSmallField" maxlength="4" />                  
                - 
                <input type="text" name="parentHomePhonePrefix" id="parentHomePhonePrefix" value="#FORM.parentHomePhonePrefix#" class="xxSmallField" maxlength="4" /> 
                - 
                <input type="text" name="parentHomePhoneNumber" id="parentHomePhoneNumber" value="#FORM.parentHomePhoneNumber#" class="xxSmallField" maxlength="6" />
                <p class="note"> 
                    <span class="phoneNote">country</span> 
                    <span class="phoneNote">area</span>  
                    <span class="phoneNote">prefix</span> 
                    <span class="phoneNote">number</span>
                </p>
            </cfif>
		</div>

		<!--- Parent Fax Telephone --->
		<div class="field">
			<label for="parentFaxCountry">#qGetQuestionsSection2.displayField[12]# <cfif qGetQuestionsSection2.isRequired[12]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField"> 
                	#APPLICATION.CFC.UDF.formatPhoneNumber(
                    	countryCode=FORM.parentFaxCountry, 
                        areaCode=FORM.parentFaxArea, 
                        prefix=FORM.parentFaxPrefix, 
                        number=FORM.parentFaxNumber)# &nbsp;
                </div>
        	<cfelse>
                <input type="text" name="parentFaxCountry" id="parentFaxCountry" value="#FORM.parentFaxCountry#" class="xxSmallField" maxlength="4" /> 
                - 
                <input type="text" name="parentFaxArea" id="parentFaxArea" value="#FORM.parentFaxArea#" class="xxSmallField" maxlength="4" />                  
                - 
                <input type="text" name="parentFaxPrefix" id="parentFaxPrefix" value="#FORM.parentFaxPrefix#" class="xxSmallField" maxlength="4" /> 
                - 
                <input type="text" name="parentFaxNumber" id="parentFaxNumber" value="#FORM.parentFaxNumber#" class="xxSmallField" maxlength="6" />
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
			<label for="#qGetQuestionsSection2.fieldKey[13]#">#qGetQuestionsSection2.displayField[13]# <cfif qGetQuestionsSection2.isRequired[13]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestionsSection2.fieldKey[13]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestionsSection2.fieldKey[13]#" id="#qGetQuestionsSection2.fieldKey[13]#" value="#FORM[qGetQuestionsSection2.fieldKey[13]]#" class="#qGetQuestionsSection2.classType[13]#" maxlength="50" />
            </cfif>
		</div>

	</fieldset>
	
	
	<!--- Business Information --->
	<fieldset>
	   
		<legend>Business Information</legend>
		
		<!--- Company Name --->
		<div class="field">
			<label for="#qGetQuestionsSection2.fieldKey[14]#">#qGetQuestionsSection2.displayField[14]# <cfif qGetQuestionsSection2.isRequired[14]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestionsSection2.fieldKey[14]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestionsSection2.fieldKey[14]#" id="#qGetQuestionsSection2.fieldKey[14]#" value="#FORM[qGetQuestionsSection2.fieldKey[14]]#" class="#qGetQuestionsSection2.classType[14]#" maxlength="100" />
            </cfif>
		</div>
		
		<!--- Business Position --->
		<div class="field">
			<label for="#qGetQuestionsSection2.fieldKey[15]#">#qGetQuestionsSection2.displayField[15]# <cfif qGetQuestionsSection2.isRequired[15]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestionsSection2.fieldKey[15]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestionsSection2.fieldKey[15]#" id="#qGetQuestionsSection2.fieldKey[15]#" value="#FORM[qGetQuestionsSection2.fieldKey[15]]#" class="#qGetQuestionsSection2.classType[15]#" maxlength="100" />
            </cfif>
		</div>

		<!--- Business Country --->
		<div class="field">
			<label for="#qGetQuestionsSection2.fieldKey[20]#">#qGetQuestionsSection2.displayField[20]# <cfif qGetQuestionsSection2.isRequired[20]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#APPLICATION.CFC.LOOKUPTABLES.getCountryByID(ID=FORM[qGetQuestionsSection2.fieldKey[20]]).name# &nbsp;</div>
        	<cfelse>
                <select name="#qGetQuestionsSection2.fieldKey[20]#" id="#qGetQuestionsSection2.fieldKey[20]#" class="mediumField" onchange="displayStateField(this.value, 'Section2BusUsStDiv', 'Section2BusNonUsStDiv', 'Section2UsBusStField', 'Section2BusNonUsStField');">
                    <option value=""></option>
                    <cfloop query="qGetCountry">
                        <option value="#qGetCountry.ID#" <cfif FORM[qGetQuestionsSection2.fieldKey[20]] EQ qGetCountry.ID> selected="selected" </cfif> >#qGetCountry.name#</option>
                    </cfloop>
                </select>
            </cfif>
		</div>

		<!--- Business Address --->
		<div class="field">
			<label for="#qGetQuestionsSection2.fieldKey[16]#">#qGetQuestionsSection2.displayField[16]# <cfif qGetQuestionsSection2.isRequired[16]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestionsSection2.fieldKey[16]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestionsSection2.fieldKey[16]#" id="#qGetQuestionsSection2.fieldKey[16]#" value="#FORM[qGetQuestionsSection2.fieldKey[16]]#" class="#qGetQuestionsSection2.classType[16]#" maxlength="100" />
            </cfif>
		</div>
		
		<!--- Business City --->
		<div class="field">
			<label for="#qGetQuestionsSection2.fieldKey[17]#">#qGetQuestionsSection2.displayField[17]# <cfif qGetQuestionsSection2.isRequired[17]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestionsSection2.fieldKey[17]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestionsSection2.fieldKey[17]#" id="#qGetQuestionsSection2.fieldKey[17]#" value="#FORM[qGetQuestionsSection2.fieldKey[17]]#" class="#qGetQuestionsSection2.classType[17]#" maxlength="50" />
            </cfif>
		</div>

        <cfif printApplication>
	        <!--- State Print Application --->	
            <div class="field">
                <label for="#qGetQuestionsSection2.fieldKey[18]#">#qGetQuestionsSection2.displayField[18]# <cfif qGetQuestionsSection2.isRequired[18]><em>*</em></cfif></label> 
                <div class="printField">#FORM[qGetQuestionsSection2.fieldKey[18]]# &nbsp;</div>
            </div>
		<cfelse>
			<!--- Business US State --->
            <div class="field hiddenField" id="Section2BusUsStDiv">
                <label for="#qGetQuestionsSection2.fieldKey[18]#">State/Province <em>*</em></label> 
                <select name="#qGetQuestionsSection2.fieldKey[18]#" id="#qGetQuestionsSection2.fieldKey[18]#" class="mediumField Section2UsBusStField">
                    <option value=""></option> <!--- [select a state] ---->
                    <cfloop query="qGetStates">
                        <option value="#qGetStates.code#" <cfif FORM[qGetQuestionsSection2.fieldKey[18]] EQ qGetStates.code> selected="selected" </cfif> >#qGetStates.name#</option>
                    </cfloop>
                </select>
            </div>
    
            <!--- Business Non Us State --->
            <div class="field hiddenField" id="Section2BusNonUsStDiv">
                <label for="#qGetQuestionsSection2.fieldKey[18]#">#qGetQuestionsSection2.displayField[18]# <cfif qGetQuestionsSection2.isRequired[18]><em>*</em></cfif></label> 
                <input type="text" name="#qGetQuestionsSection2.fieldKey[18]#" id="#qGetQuestionsSection2.fieldKey[18]#" value="#FORM[qGetQuestionsSection2.fieldKey[18]]#" class="#qGetQuestionsSection2.classType[18]# Section2BusNonUsStField" maxlength="50" />
            </div>
		</cfif>

		<!--- Business Zip --->
		<div class="field">
			<label for="#qGetQuestionsSection2.fieldKey[19]#">#qGetQuestionsSection2.displayField[19]# <cfif qGetQuestionsSection2.isRequired[19]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestionsSection2.fieldKey[19]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestionsSection2.fieldKey[19]#" id="#qGetQuestionsSection2.fieldKey[19]#" value="#FORM[qGetQuestionsSection2.fieldKey[19]]#" class="#qGetQuestionsSection2.classType[19]#" maxlength="50" />
            </cfif>
		</div>
		
		<!--- Business Telephone --->
		<div class="field">
			<label for="businessPhoneCountry">#qGetQuestionsSection2.displayField[21]# <cfif qGetQuestionsSection2.isRequired[21]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">
                	#APPLICATION.CFC.UDF.formatPhoneNumber(
                    	countryCode=FORM.businessPhoneCountry, 
                        areaCode=FORM.businessPhoneArea, 
                        prefix=FORM.businessPhonePrefix, 
                        number=FORM.businessPhoneNumber)# &nbsp;
                </div>
        	<cfelse>
                <input type="text" name="businessPhoneCountry" id="businessPhoneCountry" value="#FORM.businessPhoneCountry#" class="xxSmallField" maxlength="4" /> 
                -
                <input type="text" name="businessPhoneArea" id="businessPhoneArea" value="#FORM.businessPhoneArea#" class="xxSmallField" maxlength="4" />                  
                - 
                <input type="text" name="businessPhonePrefix" id="businessPhonePrefix" value="#FORM.businessPhonePrefix#" class="xxSmallField" maxlength="4" /> 
                - 
                <input type="text" name="businessPhoneNumber" id="businessPhoneNumber" value="#FORM.businessPhoneNumber#" class="xxSmallField" maxlength="6" />
                <p class="note"> 
                    <span class="phoneNote">country</span> 
                    <span class="phoneNote">area</span>  
                    <span class="phoneNote">prefix</span> 
                    <span class="phoneNote">number</span>
                </p>
            </cfif>
		</div>

		<!--- Additional Family Information --->
        <div class="field controlset">
            <span class="label">Would you like to add an additional Parent/Guardian? <em>*</em> </span>
            <cfif printApplication>
				<div class="printField">#YesNoFormat(FORM.hasAddFamInfo)#</div>
        	<cfelse>
                <input type="radio" name="hasAddFamInfo" id="hasAddFamInfo1" value="1" <cfif FORM.hasAddFamInfo EQ 1> checked="checked" </cfif> /> <label for="hasAddFamInfo1">Yes</label>
                <input type="radio" name="hasAddFamInfo" id="hasAddFamInfo0" value="0" <cfif FORM.hasAddFamInfo EQ 0> checked="checked" </cfif> /> <label for="hasAddFamInfo0">No</label>
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
		Section2GetHomeCountry = $("###qGetQuestionsSection2.fieldKey[10]#").val();
		displayStateField(Section2GetHomeCountry, 'Section2HomeUsStDiv', 'Section2HomeNonUsStDiv', 'Section2HomeUsStField', 'Section2HomeNonUsStField');

		// Get Current Country Value
		Section2GetBusCountry = $("###qGetQuestionsSection2.fieldKey[20]#").val();
		displayStateField(Section2GetBusCountry, 'Section2BusUsStDiv', 'Section2BusNonUsStDiv', 'Section2UsBusStField', 'Section2BusNonUsStField');

	});
</script>

</cfoutput>