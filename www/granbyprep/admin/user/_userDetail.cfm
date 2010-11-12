<!--- ------------------------------------------------------------------------- ----
	
	File:		_userDetail.cfm
	Author:		Marcus Melo
	Date:		November 11, 2010
	Desc:		User Detail Page - Add/Edit User

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../extensions/customtags/gui/" prefix="gui" />	

	<!--- Param URL Variables --->	
    <cfparam name="URL.ID" default="0">
    
    <cfscript>
		// Get Current User Information
		qGetUserInfo = APPLICATION.CFC.USER.getUserByID(ID=VAL(URL.ID));
	</cfscript>
    
	<!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">    
    <!--- User Details --->
    <cfparam name="FORM.ID" default="#VAL(qGetUserInfo.ID)#">
    <cfparam name="FORM.firstName" default="">
    <cfparam name="FORM.middleName" default="">    
    <cfparam name="FORM.lastName" default="">
    <cfparam name="FORM.email" default="">
    <cfparam name="FORM.password" default="">
    <cfparam name="FORM.newPassword" default="">
    <cfparam name="FORM.confirmNewPassword" default="">
    <cfparam name="FORM.gender" default="">
    <cfparam name="FORM.dobMonth" default="">
    <cfparam name="FORM.dobDay" default="">
    <cfparam name="FORM.dobYear" default="">
    <cfparam name="FORM.isActive" default="1">
    <cfparam name="FORM.dateCanceled" default="">
    <cfparam name="FORM.dateLastLoggedIn" default="">
    
    <cfscript>	
		// FORM Submitted
		if (FORM.submitted) {
			// Data Validation
			
			// First Name
			if ( NOT LEN(FORM.firstName) ) {
				SESSION.formErrors.Add("Please enter a first name");	
			}

			// Last Name
			if ( NOT LEN(FORM.lastName) ) {
				SESSION.formErrors.Add("Please enter a last name");	
			}
		
			// New Account - Check Login Information
			if ( NOT VAL(FORM.ID) ) {
			
				// Email
				if ( NOT LEN(FORM.email) OR NOT IsValid("email", FORM.email) ) {
					SESSION.formErrors.Add("Enter a valid email address");			
				}
	
				// Check if Email has been registered
				if ( LEN(FORM.email) AND APPLICATION.CFC.USER.checkEmail(email=FORM.email,ID=FORM.ID).recordCount ) {
					SESSION.formErrors.Add("Email already registered");		
				}

				// Password
				if ( NOT LEN(FORM.password) ) {
					SESSION.formErrors.Add("Enter a password");			
				}

				// Password
				if ( LEN(FORM.password) AND LEN(FORM.password) LT 6 ) {
					SESSION.formErrors.Add("Password must have at least 6 characters");			
				}

				// Password
				if ( NOT LEN(FORM.password) ) {
					SESSION.formErrors.Add("Enter a password");				
				}
	
				// Validate Password
				stValPassword = APPLICATION.CFC.UDF.isValidPassword(password=FORM.password);
				if ( LEN(FORM.password) AND NOT stValPassword.isValidPassword ) {
					SESSION.formErrors.Add(stValPassword.Errors);		
				}
				
			}
		
			// Check if there are no errors
			if ( NOT SESSION.formErrors.length() ) {				
				
				// Insert / Update User
				APPLICATION.CFC.USER.insertEditUser(
					ID=FORM.ID,
					firstName=FORM.firstName,
					middleName=FORM.middleName,
					lastName=FORM.lastName,
					email=FORM.email,
					password=FORM.password,
					gender=FORM.gender,
					dob = FORM.dobMonth & "/" & FORM.dobDay & "/" & FORM.dobYear
				);													
				
				if ( VAL(FORM.ID) ) {
					// Set Page Message
					SESSION.pageMessages.Add("Form successfully submitted");
					// Reload page with updated information
					location("#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#", "no");
				} else {
					// Set Page Message
					SESSION.pageMessages.Add("User successfully created");
					// Reload page with updated information
					location("#CGI.SCRIPT_NAME#?action=userList", "no");
				}
				
			}

		} else {
		
			if ( VAL(FORM.ID) ) {
				// Set the default values of the FORM 
				FORM.firstName = qGetUserInfo.firstName;
				FORM.middleName = qGetUserInfo.middleName;
				FORM.lastName = qGetUserInfo.lastName;
				FORM.email = qGetUserInfo.email;
				FORM.password = qGetUserInfo.password;
				FORM.gender = qGetUserInfo.gender;
				if ( IsDate(qGetUserInfo.dob) ) {
					FORM.dobMonth = Month(qGetUserInfo.dob);
					FORM.dobDay = Day(qGetUserInfo.dob);
					FORM.dobYear = Year(qGetUserInfo.dob);
				}
				FORM.isActive = qGetUserInfo.isActive;
				FORM.dateCanceled = qGetUserInfo.dateCanceled;		  
				FORM.dateLastLoggedIn = qGetUserInfo.dateLastLoggedIn;
			}
			
		}	
	</cfscript>
    
</cfsilent>

<cfoutput>

<!--- Page Header --->
<gui:pageHeader
	headerType="adminTool"
/>

    <!--- Side Bar --->
    <div class="fullContent ui-corner-all">
        
        <div class="insideBar">
			
            <!--- Application Body --->
			<div class="form-container-noBorder">
            
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
                    
                <form action="#CGI.SCRIPT_NAME#?#cgi.QUERY_STRING#" method="post">
                <input type="hidden" name="submitted" value="1" />
                <input type="hidden" name="ID" value="#FORM.ID#" />
            
				<p class="legend"><strong>Note:</strong> Required fields are marked with an asterisk (<em>*</em>)</p>            
            
                <fieldset>
                   
                    <legend>User Details</legend>

                    <div class="field">
                        <label for="firstName">First Name <em>*</em></label> 
                        <input type="text" name="firstName" id="firstName" value="#FORM.firstName#" class="largeField" maxlength="100" />
                    </div>

                    <div class="field">
                        <label for="middleName">Middle Name</label> 
                        <input type="text" name="middleName" id="middleName" value="#FORM.middleName#" class="largeField" maxlength="100" />
                    </div>

                    <div class="field">
                        <label for="lastName">Last Name <em>*</em></label> 
                        <input type="text" name="lastName" id="lastName" value="#FORM.lastName#" class="largeField" maxlength="100" />
                    </div>

                    <div class="field">
                        <label for="gender">Gender </label> 
                        <select name="gender" id="gender" class="smallField {validate:{required:true}}">
                            <option value=""></option> <!--- [select your gender] --->
                            <option value="M" <cfif FORM.gender EQ 'M'> selected="selected" </cfif> >Male</option>
                            <option value="F" <cfif FORM.gender EQ 'F'> selected="selected" </cfif> >Female</option>
                        </select>
                    </div>
    
                    <div class="field">
                        <label for="dobMonth">Date of Birth </label> 
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
                    </div>
                     
                    <div class="field controlset">
                        <span class="label">Status</span>
                        <input type="radio" name="isActive" id="active" value="1" <cfif FORM.isActive EQ 1> checked="checked" </cfif> /> <label for="active">Active</label>
                        <input type="radio" name="isActive" id="inactive" value="0" <cfif FORM.isActive EQ 0> checked="checked" </cfif> /> <label for="inactive">Inactive</label>
                    </div>			
    
                    <div class="field">
                        <label for="departDate">Canceled Date </label> 
                        <input type="text" name="dateCanceled" id="dateCanceled" value="#DateFormat(FORM.dateCanceled, 'mm/dd/yyyy')#" class="smallField datePicker" maxlength="10" readonly="readonly" />
                        <p class="note">(mm/dd/yyyy)</p>
                    </div>

                    <div class="field">
                        <label for="dateLastLoggedIn">Last Logged In Date <em>*</em></label> 
                        <div class="adminPrintField">
                        	<cfif LEN(FORM.dateLastLoggedIn)>
                            	#DateFormat(FORM.dateLastLoggedIn, 'mm/dd/yyyy')# at #TimeFormat(FORM.dateLastLoggedIn, 'hh:mm:ss tt')# 
                            </cfif> &nbsp;
                        </div>
                    </div>

                </fieldset>

                <fieldset>
                   
                    <legend>Login Information</legend>
					
                    <!--- New Account --->
                    <cfif NOT VAL(FORM.ID)>

                        <div class="field">
                            <label for="email">Email <em>*</em></label> 
                            <input type="text" name="email" id="email" value="#FORM.email#" class="largeField" maxlength="100" />
                        </div>
    
                        <div class="field">
                            <label for="Password">Password <em>*</em></label> 
                            <input type="text" name="Password" id="Password" value="#FORM.Password#" class="largeField" maxlength="100" />
                        </div>

                    <!--- Display Protect Password --->
                    <cfelse>
                    
                        <div class="field">
                            <label for="Email">Email <em>*</em></label> 
                            <div class="adminPrintField">#FORM.email# &nbsp;</div>  
                        </div>
    
                        <div class="field">
                            <label for="password">Password <em>*</em></label> 
                            <div class="adminPrintField">xxxxxxxx &nbsp;</div> 
                            <p class="note">PS: <a href="#CGI.SCRIPT_NAME#?action=myAccount">Click here</a> to change your login information.</p> 
                        </div>
					
                    </cfif>
                    
				</fieldset>
                            
                <div class="buttonrow">
                    <input type="submit" value="Save" class="button ui-corner-top" />
                </div>
                
                </form>
                
            </div>
            
		</div><!-- /insideBar -->
        
	</div><!-- rightSideContent -->        

<!--- Page Footer --->
<gui:pageFooter
	footerType="application"
/>

</cfoutput>
