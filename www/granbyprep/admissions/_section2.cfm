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

	<!--- It is set to 1 for the print application page --->
	<cfparam name="printApplication" default="0">

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
    <cfparam name="FORM.hasAddFamInfo" default="">

    <cfscript>
		// Get Current Student Information
		qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(ID=FORM.studentID);

		// Gets a List of States
		qGetStates = APPLICATION.CFC.LOOKUPTABLES.getState();

		// Get Current Student Information
		qGetCountry = APPLICATION.CFC.LOOKUPTABLES.getCountry();

		// Get Questions for this section
		qGetQuestions = APPLICATION.CFC.ONLINEAPP.getQuestionByFilter(sectionName='section2');
		
		// Get Answers for this section
		qGetAnswers = APPLICATION.CFC.ONLINEAPP.getAnswerByFilter(sectionName='section2', foreignTable='student', foreignID=FORM.studentID);

		// Param Online Application Form Variables 
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

			if ( NOT LEN(FORM.hasAddFamInfo) ) {
				SESSION.formErrors.Add("Please check if you would like to enter an additional family information");
			}

			// Check if there are no errors
			if ( NOT SESSION.formErrors.length() ) {				
				
				// Insert/Update Application Fields 
				for ( i=1; i LTE qGetQuestions.recordCount; i=i+1 ) {
					APPLICATION.CFC.ONLINEAPP.insertAnswer(	
						applicationQuestionID=qGetQuestions.ID[i],
						foreignTable='student',
						foreignID=FORM.studentID,
						fieldKey=qGetQuestions.fieldKey[i],
						answer=FORM[qGetQuestions.fieldKey[i]]						
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
			for ( i=1; i LTE qGetAnswers.recordCount; i=i+1 ) {
				FORM[qGetAnswers.fieldKey[i]] = qGetAnswers.answer[i];
			}

			FORM.hasAddFamInfo = qGetStudentInfo.hasAddFamInfo;

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
			FORM.businessPhoneCountry = stBusinessPhone.countryCode;
			FORM.businessPhoneArea = stBusinessPhone.areaCode;
			FORM.businessPhonePrefix = stBusinessPhone.prefix;
			FORM.businessPhoneNumber = stBusinessPhone.number;

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
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestions.fieldKey[1]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestions.fieldKey[1]#" id="#qGetQuestions.fieldKey[1]#" value="#FORM[qGetQuestions.fieldKey[1]]#" class="#qGetQuestions.classType[1]#" maxlength="100" />
            </cfif>
		</div>
		
		<!--- Parent First Name --->
		<div class="field">
			<label for="#qGetQuestions.fieldKey[2]#">#qGetQuestions.displayField[2]# <cfif qGetQuestions.isRequired[2]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestions.fieldKey[2]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestions.fieldKey[2]#" id="#qGetQuestions.fieldKey[2]#" value="#FORM[qGetQuestions.fieldKey[2]]#" class="#qGetQuestions.classType[2]#" maxlength="100" />
            </cfif>
		</div>
		
		<!--- Parent Middle Name --->
		<div class="field">
			<label for="#qGetQuestions.fieldKey[3]#">#qGetQuestions.displayField[3]# <cfif qGetQuestions.isRequired[3]><em>*</em></cfif></label>  
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestions.fieldKey[3]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestions.fieldKey[3]#" id="#qGetQuestions.fieldKey[3]#" value="#FORM[qGetQuestions.fieldKey[3]]#" class="#qGetQuestions.classType[3]#" maxlength="100" />
            </cfif>
		</div>
		
		<!--- Parent Last Name --->
		<div class="field">
			<label for="#qGetQuestions.fieldKey[4]#">#qGetQuestions.displayField[4]# <cfif qGetQuestions.isRequired[4]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestions.fieldKey[4]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestions.fieldKey[4]#" id="#qGetQuestions.fieldKey[4]#" value="#FORM[qGetQuestions.fieldKey[4]]#" class="#qGetQuestions.classType[4]#" maxlength="100" />
            </cfif>
		</div>
		
		<!--- Parent Preferred Name ---> 
		<div class="field">
			<label for="#qGetQuestions.fieldKey[5]#">#qGetQuestions.displayField[5]# <cfif qGetQuestions.isRequired[5]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestions.fieldKey[5]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestions.fieldKey[5]#" id="#qGetQuestions.fieldKey[5]#" value="#FORM[qGetQuestions.fieldKey[5]]#" class="#qGetQuestions.classType[5]#" maxlength="100" />
            </cfif>
		</div>
		
	</fieldset>


	<!--- Complete Home Address --->
	<fieldset>
	   
		<legend>Complete Home Address</legend>

		<!--- Parent Country --->
		<div class="field">
			<label for="#qGetQuestions.fieldKey[10]#">#qGetQuestions.displayField[10]# <cfif qGetQuestions.isRequired[10]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#APPLICATION.CFC.LOOKUPTABLES.getCountryByID(ID=FORM[qGetQuestions.fieldKey[10]]).name# &nbsp;</div>
        	<cfelse>
                <select name="#qGetQuestions.fieldKey[10]#" id="#qGetQuestions.fieldKey[10]#" class="mediumField" onchange="displayStateField(this.value, 'sec2HomeUsStDiv', 'sec2HomeNonUsStDiv', 'sec2HomeUsStField', 'sec2HomeNonUsStField');">
                    <option value=""></option>
                    <cfloop query="qGetCountry">
                        <option value="#qGetCountry.ID#" <cfif FORM[qGetQuestions.fieldKey[10]] EQ qGetCountry.ID> selected="selected" </cfif> >#qGetCountry.name#</option>
                    </cfloop>
                </select>
            </cfif>
		</div>

		<!--- Parent Address --->
		<div class="field">
			<label for="#qGetQuestions.fieldKey[6]#">#qGetQuestions.displayField[6]# <cfif qGetQuestions.isRequired[6]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestions.fieldKey[6]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestions.fieldKey[6]#" id="#qGetQuestions.fieldKey[6]#" value="#FORM[qGetQuestions.fieldKey[6]]#" class="#qGetQuestions.classType[6]#" maxlength="100" />
            </cfif>
		</div>
		
		<!--- Parent City --->
		<div class="field">
			<label for="#qGetQuestions.fieldKey[7]#">#qGetQuestions.displayField[7]# <cfif qGetQuestions.isRequired[7]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestions.fieldKey[7]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestions.fieldKey[7]#" id="#qGetQuestions.fieldKey[7]#" value="#FORM[qGetQuestions.fieldKey[7]]#" class="#qGetQuestions.classType[7]#" maxlength="100" />
            </cfif>
		</div>

		<!--- Parent US State --->
        <div class="field hiddenField" id="sec2HomeUsStDiv">
            <label for="#qGetQuestions.fieldKey[8]#">State/Province <em>*</em></label> 
            <select name="#qGetQuestions.fieldKey[8]#" id="#qGetQuestions.fieldKey[8]#" class="mediumField sec2HomeUsStField">
                <option value=""></option> <!--- [select a state] ---->
                <cfloop query="qGetStates">
                    <option value="#qGetStates.code#" <cfif FORM[qGetQuestions.fieldKey[8]] EQ qGetStates.code> selected="selected" </cfif> >#qGetStates.name#</option>
                </cfloop>
            </select>
        </div>
		
		<!--- Parent Non US State --->
		<div class="field hiddenField" id="sec2HomeNonUsStDiv">
			<label for="#qGetQuestions.fieldKey[8]#">#qGetQuestions.displayField[8]# <cfif qGetQuestions.isRequired[8]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestions.fieldKey[8]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestions.fieldKey[8]#" id="#qGetQuestions.fieldKey[8]#" value="#FORM[qGetQuestions.fieldKey[8]]#" class="#qGetQuestions.classType[8]# sec2HomeNonUsStField" maxlength="100" />
            </cfif>
		</div>
		
		<!--- Parent Zip --->
		<div class="field">
			<label for="#qGetQuestions.fieldKey[9]#">#qGetQuestions.displayField[9]# <cfif qGetQuestions.isRequired[9]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestions.fieldKey[9]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestions.fieldKey[9]#" id="#qGetQuestions.fieldKey[9]#" value="#FORM[qGetQuestions.fieldKey[9]]#" class="#qGetQuestions.classType[9]#" maxlength="50" />
            </cfif>
		</div>
		
		<!--- Parent Home Telephone --->
		<div class="field">
			<label for="homePhoneCountry">#qGetQuestions.displayField[11]# <cfif qGetQuestions.isRequired[11]><em>*</em></cfif></label> 
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

		<!--- Parent Fax Telephone --->
		<div class="field">
			<label for="faxCountry">#qGetQuestions.displayField[12]# <cfif qGetQuestions.isRequired[12]><em>*</em></cfif></label> 
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

		<!--- Parent Email --->
		<div class="field">
			<label for="#qGetQuestions.fieldKey[13]#">#qGetQuestions.displayField[13]# <cfif qGetQuestions.isRequired[13]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestions.fieldKey[13]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestions.fieldKey[13]#" id="#qGetQuestions.fieldKey[13]#" value="#FORM[qGetQuestions.fieldKey[13]]#" class="#qGetQuestions.classType[13]#" maxlength="50" />
            </cfif>
		</div>

	</fieldset>
	
	
	<!--- Business Information --->
	<fieldset>
	   
		<legend>Business Information</legend>
		
		<!--- Company Name --->
		<div class="field">
			<label for="#qGetQuestions.fieldKey[14]#">#qGetQuestions.displayField[14]# <cfif qGetQuestions.isRequired[14]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestions.fieldKey[14]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestions.fieldKey[14]#" id="#qGetQuestions.fieldKey[14]#" value="#FORM[qGetQuestions.fieldKey[14]]#" class="#qGetQuestions.classType[14]#" maxlength="100" />
            </cfif>
		</div>
		
		<!--- Business Position --->
		<div class="field">
			<label for="#qGetQuestions.fieldKey[15]#">#qGetQuestions.displayField[15]# <cfif qGetQuestions.isRequired[15]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestions.fieldKey[15]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestions.fieldKey[15]#" id="#qGetQuestions.fieldKey[15]#" value="#FORM[qGetQuestions.fieldKey[15]]#" class="#qGetQuestions.classType[15]#" maxlength="100" />
            </cfif>
		</div>

		<!--- Business Country --->
		<div class="field">
			<label for="#qGetQuestions.fieldKey[20]#">#qGetQuestions.displayField[20]# <cfif qGetQuestions.isRequired[20]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#APPLICATION.CFC.LOOKUPTABLES.getCountryByID(ID=FORM[qGetQuestions.fieldKey[20]]).name# &nbsp;</div>
        	<cfelse>
                <select name="#qGetQuestions.fieldKey[20]#" id="#qGetQuestions.fieldKey[20]#" class="mediumField" onchange="displayStateField(this.value, 'sec2BusUsStDiv', 'sec2BusNonUsStDiv', 'sec2UsBusStField', 'sec2BusNonUsStField');">
                    <option value=""></option>
                    <cfloop query="qGetCountry">
                        <option value="#qGetCountry.ID#" <cfif FORM[qGetQuestions.fieldKey[20]] EQ qGetCountry.ID> selected="selected" </cfif> >#qGetCountry.name#</option>
                    </cfloop>
                </select>
            </cfif>
		</div>

		<!--- Business Address --->
		<div class="field">
			<label for="#qGetQuestions.fieldKey[16]#">#qGetQuestions.displayField[16]# <cfif qGetQuestions.isRequired[16]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestions.fieldKey[16]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestions.fieldKey[16]#" id="#qGetQuestions.fieldKey[16]#" value="#FORM[qGetQuestions.fieldKey[16]]#" class="#qGetQuestions.classType[16]#" maxlength="100" />
            </cfif>
		</div>
		
		<!--- Business City --->
		<div class="field">
			<label for="#qGetQuestions.fieldKey[17]#">#qGetQuestions.displayField[17]# <cfif qGetQuestions.isRequired[17]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestions.fieldKey[17]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestions.fieldKey[17]#" id="#qGetQuestions.fieldKey[17]#" value="#FORM[qGetQuestions.fieldKey[17]]#" class="#qGetQuestions.classType[17]#" maxlength="50" />
            </cfif>
		</div>

		<!--- Business US State --->
        <div class="field hiddenField" id="sec2BusUsStDiv">
            <label for="#qGetQuestions.fieldKey[18]#">State/Province <em>*</em></label> 
            <select name="#qGetQuestions.fieldKey[18]#" id="#qGetQuestions.fieldKey[18]#" class="mediumField sec2UsBusStField">
                <option value=""></option> <!--- [select a state] ---->
                <cfloop query="qGetStates">
                    <option value="#qGetStates.code#" <cfif FORM[qGetQuestions.fieldKey[18]] EQ qGetStates.code> selected="selected" </cfif> >#qGetStates.name#</option>
                </cfloop>
            </select>
        </div>

		<!--- Business Non Us State --->
		<div class="field hiddenField" id="sec2BusNonUsStDiv">
			<label for="#qGetQuestions.fieldKey[18]#">#qGetQuestions.displayField[18]# <cfif qGetQuestions.isRequired[18]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestions.fieldKey[18]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestions.fieldKey[18]#" id="#qGetQuestions.fieldKey[18]#" value="#FORM[qGetQuestions.fieldKey[18]]#" class="#qGetQuestions.classType[18]# sec2BusNonUsStField" maxlength="50" />
            </cfif>
		</div>

		<!--- Business Zip --->
		<div class="field">
			<label for="#qGetQuestions.fieldKey[19]#">#qGetQuestions.displayField[19]# <cfif qGetQuestions.isRequired[19]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestions.fieldKey[19]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestions.fieldKey[19]#" id="#qGetQuestions.fieldKey[19]#" value="#FORM[qGetQuestions.fieldKey[19]]#" class="#qGetQuestions.classType[19]#" maxlength="50" />
            </cfif>
		</div>
		
		<!--- Business Telephone --->
		<div class="field">
			<label for="businessPhoneCountry">#qGetQuestions.displayField[21]# <cfif qGetQuestions.isRequired[21]><em>*</em></cfif></label> 
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
		sec2GetHomeCountry = $("###qGetQuestions.fieldKey[10]#").val();
		displayStateField(sec2GetHomeCountry, 'sec2HomeUsStDiv', 'sec2HomeNonUsStDiv', 'sec2HomeUsStField', 'sec2HomeNonUsStField');

		// Get Current Country Value
		sec2GetBusCountry = $("###qGetQuestions.fieldKey[20]#").val();
		displayStateField(sec2GetBusCountry, 'sec2BusUsStDiv', 'sec2BusNonUsStDiv', 'sec2UsBusStField', 'sec2BusNonUsStField');

	});
</script>

</cfoutput>