<!--- ------------------------------------------------------------------------- ----
	
	File:		_createApplication.cfc
	Author:		Marcus Melo
	Date:		August 26, 2010
	Desc:		Create Online Application Accounts

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../../extensions/customTags/gui/" prefix="gui" />	
	
    <!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.type" default="">
    <cfparam name="FORM.lastName" default="">
    <cfparam name="FORM.firstName" default="">
    <cfparam name="FORM.middleName" default="">
    <cfparam name="FORM.gender" default="">
    <cfparam name="FORM.email" default="">
    <cfparam name="FORM.emailConfirm" default="">

    <cfscript>	
		// FORM Submitted
		if ( FORM.submitted ) {

			// FORM Validation
			if ( NOT LEN(FORM.type) ) {
				SESSION.formErrors.Add("Please select an application type");
			}
			
			if ( NOT LEN(FORM.firstName) ) {
				SESSION.formErrors.Add("Please enter a first name");
			}
			
			if ( NOT LEN(FORM.lastName) ) {
				SESSION.formErrors.Add("Please enter a last name");
			}
			
			if ( NOT LEN(FORM.gender) ) {
				SESSION.formErrors.Add("Please select a gender");
			}
			
			// Candidate - Check Email Fields 
			if ( FORM.type EQ 'Candidate' ) {
			
				if ( NOT LEN(FORM.email) OR NOT IsValid("email", FORM.email) ) {
					SESSION.formErrors.Add("Enter a valid email address");
				}
			
				if ( LEN(FORM.email) AND LEN(FORM.email) NEQ LEN(FORM.emailConfirm) ) {
					SESSION.formErrors.Add("Confirm email does not match.");			
				}
				
				// Check if there is an account with the same email address
				if ( VAL(APPLICATION.CFC.candidate.doesAccountExist(email=FORM.email)) ) {
					SESSION.formErrors.Add("Email address is already registered");			
				}
				
			}
						
			// Check if there are no errors
			if ( NOT SESSION.formErrors.length() ) {				
				
				// Create Application
				APPLICATION.CFC.CANDIDATE.createApplication(
					type = FORM.type,
					companyID = CLIENT.companyID,
					userType = CLIENT.userType,
					intlRepID = CLIENT.userID,
					branchID = 0,
					firstName = FORM.firstName,
					middleName = FORM.middleName,
					lastName = FORM.lastName,
					gender = FORM.gender,
					email = FORM.email
				);			
				
				// Set Page Message
				SESSION.pageMessages.Add("Candidate successfully created.");
							
				// Reload page with updated information
				location("index.cfm?curdoc=initial_welcome", "no");
				
			}

		}
	</cfscript>

</cfsilent>

<script type="text/javascript">
	// JQuery Validator
	$().ready(function() {
		var container = $('div.errorContainer');
		// validate the form when it is submitted
		var validator = $("#createApplication").validate({
			errorContainer: container,
			errorLabelContainer: $("ol", container),
			wrapper: 'li',
			meta: "validate"
		});
	
	});
	
	// Display Email Fields
	$(document).ready(function() {
		// Get Current Country Value
		selectedType = $("#type").val();
		//startApplicationType(selectedType);
		
	});
</script>

<cfoutput>


<div class="divPageBox">
	  
    <div class="pageTitle title1">Create Application</div>

	<!---  Our jQuery error container --->
    <div class="errorContainer">
        <p><em>Oops... the following errors were encountered:</em></p>
                        
        <ol>
            <li><label for="type" class="error">Please select an application type</label></li>  
            <li><label for="firstName" class="error">Please enter a first name</label></li>  
            <li><label for="lastName" class="error">Please enter a last name</label></li>  
            <li><label for="gender" class="error">Please select a gender</label></li>  
        </ol>
        
        <p>Data has <strong>not</strong> been saved.</p>
    </div>
    
    <div class="form-container">
        
        <form name="createApplication" id="createApplication" action="#CGI.SCRIPT_NAME#?#cgi.QUERY_STRING#" method="post">
        <input type="hidden" name="submitted" value="1" />
        
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
        
        <p class="legend"><strong>Note:</strong> Required fields are marked with an asterisk (<em>*</em>)</p>
        
        <!--- Student Details --->
        <fieldset>
                               
            <legend>Personal Data</legend>
			
            <div class="divInformation">
            
                <span class="title">Candidate Application</span> 
                <span class="text">
					If you choose Candidate under the Application type, an account will be created for the particular candidate, who must have a valid email account and Internet access. 
                    He/she will receive the login information and will further be able to login, fill-out the application and upload all required documents. 
                    Once the application is ready, you will be able to check it and Approve/Deny it. By approving it, the application will be submitted to CSB for the review.                     
				</span>
                
                <span class="title">Office Application</span>
                <span class="text">
                    If you choose Office under the Application type, you (the International Representative) and your staff will directly fill-out the application for a candidate and 
                    submit it to CSB for the review. <br />
                </span>

				<span class="title"></span>
                <span class="text">
					PS: You will have access to all candidates submitted to CSB. You will be able to check their status and information (no edit).
                </span>
                
                <span class="title">New user in EXTRA?</span>
                <span class="text">
                	<a href="onlineApplication/tutorial.cfm" style="color:red;">Click here for a breif tutorial</a>
                </span>

            </div>
            
            <div class="field">
                <label for="gender">Application Type <em>*</em></label> 
                <select name="type" id="type" class="smallField {validate:{required:true}}" onchange="startApplicationType(this.value);">
                    <option value=""></option>
                    <option value="Candidate" <cfif FORM.type EQ 'Candidate'> selected="selected" </cfif> >Candidate</option>
                    <option value="Office" <cfif FORM.type EQ 'Office'> selected="selected" </cfif> >Office</option>
                </select>
            </div>
                
            <div class="field">
                <label for="firstName">First Name <em>*</em></label> 
                <input type="text" name="firstName" id="firstName" value="#FORM.firstName#" class="largeField {validate:{required:true}}" maxlength="100" /> <!--- class="error" --->
            </div>
    
            <div class="field">
                <label for="middleName">Middle Name</label> 
                <input type="text" name="middleName" id="middleName" value="#FORM.middleName#" class="largeField" maxlength="100" />
            </div>
    
            <div class="field">
                <label for="lastName">Family Name <em>*</em></label> 
                <input type="text" name="lastName" id="lastName" value="#FORM.lastName#" class="largeField {validate:{required:true}}" maxlength="100" />
            </div>
    
            <div class="field">
                <label for="gender">Gender <em>*</em></label> 
                <select name="gender" id="gender" class="smallField {validate:{required:true}}">
                    <option value=""></option> <!--- [select your gender] --->
                    <option value="M" <cfif FORM.gender EQ 'M'> selected="selected" </cfif> >Male</option>
                    <option value="F" <cfif FORM.gender EQ 'F'> selected="selected" </cfif> >Female</option>
                </select>
            </div>
    
            <div class="field ">
                <label for="lastName">Email Address <em>*</em></label> 
                <input type="text" name="email" id="email" value="#FORM.email#" class="largeField" maxlength="100" />
            </div>
    
            <div class="field ">
                <label for="lastName">Confirm Email Address <em>*</em></label> 
                <input type="text" name="emailConfirm" id="emailConfirm" value="#FORM.emailConfirm#" class="largeField" maxlength="100" />
            </div>

            <div class="submit" align="center">
                <input type="image" name="Submit" src="../pics/onlineApp/start-application.gif">
            </div>
            
        </fieldset>
    
    	</form>
    
    </div>
    
</div>

</cfoutput>
