<!--- ------------------------------------------------------------------------- ----
	
	File:		index.cfc
	Author:		Marcus Melo
	Date:		June 14, 2010
	Desc:		Online Application Index Page

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

    <!--- Param FORM Variables --->
    <cfparam name="FORM.type" default="">
    <!--- Login --->
    <cfparam name="FORM.loginEmail" default="">
    <cfparam name="FORM.loginPassword" default="">
    <!--- Forgot Password --->
    <cfparam name="FORM.forgotEmail" default="">
	<!--- New Account --->
    <cfparam name="FORM.lastName" default="">
	<cfparam name="FORM.firstName" default="">
	<cfparam name="FORM.email" default="">
    <cfparam name="FORM.password" default="">
    <cfparam name="FORM.confirmPassword" default="">
       
	<cfscript>
       // FORM Submitted - Login
       if ( FORM.type EQ 'login' ) {
           // Data Validation
            
            // Email
            if ( NOT LEN(FORM.loginEmail) OR NOT IsValid("email", FORM.loginEmail) ) {
				SESSION.formErrors.Add("Enter a valid email address");
            }

            // Password
            if ( NOT LEN(FORM.loginPassword) ) {
				SESSION.formErrors.Add("Enter a password");
            }
            
            // There are no errors
            if ( NOT SESSION.formErrors.length() ) {
                
				//Check Login
                qCheckLogin = APPLICATION.CFC.STUDENT.checkLogin(
                    email=FORM.loginEmail,
                    password=FORM.loginPassword
                );
            	
                if ( qCheckLogin.recordcount EQ 1 ) {
                    // Do Login
                    APPLICATION.CFC.ONLINEAPP.doLogin(studentID=qCheckLogin.ID);
                    
                    // Redirect User
                    location("#CGI.SCRIPT_NAME#?action=home", "no");

                } else {
                    // Set Login Error Message
					SESSION.formErrors.Add("Invalid login. If you would like to retrieve your password, please click on forgot password below");
                }
            }
       
	   
	   // FORM Submitted - forgotPassword
       } else if ( FORM.type EQ 'forgotPassword' ) {
            // Data Validation
            
            // Email
            if ( NOT LEN(FORM.forgotEmail) OR NOT IsValid("email", FORM.forgotEmail) ) {
				SESSION.formErrors.Add("Enter a valid email address");
            }
			
            // There are no errors
            if ( NOT SESSION.formErrors.length() ) {
				
				// Check if we have a record with the same email address
				qCheckEmail = APPLICATION.CFC.STUDENT.checkEmail(email=FORM.forgotEmail);

				// Valid Account
				if (qCheckEmail.recordCount) {
					// Email Password
					APPLICATION.CFC.EMAIL.sendEmail(
						emailTo=FORM.forgotEmail,						
						emailType='forgotPassword',
						studentID=qCheckEmail.ID
					);
				} else {
					// Set email is not registered error message
					SESSION.formErrors.Add("Email is not registered. <br /> Please create an account.");
				}
				
				// Set Page Message
				SESSION.pageMessages.Add("Your login information has been emailed successfully");

            }
       
	   // FORM Submitted - newApplicant
       } else if ( FORM.type EQ 'newApplicant' ) {
            // Data Validation

            // First Name
            if ( NOT LEN(FORM.firstName) ) {
				SESSION.formErrors.Add("Enter a first name");
            }

            // Last Name
            if ( NOT LEN(FORM.lastName) ) {
				SESSION.formErrors.Add("Enter a last name");
            }
            
            // Email
            if ( NOT LEN(FORM.email) OR NOT IsValid("email", FORM.email) ) {
				SESSION.formErrors.Add("Enter a valid email address");
            }

			// Check if Email has been registered
			if ( IsValid("email", FORM.email) AND APPLICATION.CFC.STUDENT.checkEmail(email=FORM.email).recordCount ) {
				SESSION.formErrors.Add("Email address already registered. <br /> Please click on forgot password to retrieve your information");
			}

            // Password
            if ( NOT LEN(FORM.password) ) {
				SESSION.formErrors.Add("Enter a password");
            }

            // Password
            if ( LEN(FORM.password) AND LEN(FORM.password) NEQ LEN(FORM.confirmPassword) ) {
				SESSION.formErrors.Add("Confirm password does not match");
            }
            
            // Validate Password
			stValPassword = APPLICATION.CFC.UDF.isValidPassword(password=FORM.password);
			if ( LEN(FORM.password) AND NOT stValPassword.isValidPassword ) {
				SESSION.formErrors.Add(stValPassword.Errors);
            }

			// There are no errors
            if ( NOT SESSION.formErrors.length() ) {
				// Create Student Account
				newID = APPLICATION.CFC.STUDENT.insertStudent(
					firstName=FORM.firstName,
					lastName=FORM.lastName,
					email=FORM.email,
					password=FORM.password													  
				);
				
				// Email Student
				APPLICATION.CFC.EMAIL.sendEmail(
					emailTo=FORM.email,
					emailType='newAccount',
					studentID=newID
				);
                
				// Do Login
				APPLICATION.CFC.ONLINEAPP.doLogin(studentID=newID);
                    
				// Redirect User
				location("#CGI.SCRIPT_NAME#?action=initial", "no");
            }

		}

		
		// Set which form needs to be displayed
		if (FORM.type EQ "forgotPassword" ) {
			loginFormClass = 'hiddenDiv';
			forgotPassClass = '';
		} else {
			loginFormClass = '';
			forgotPassClass = 'hiddenDiv';
		}
	</cfscript>
    
</cfsilent>

<!--- Page Header --->
<gui:pageHeader
	headerType="login"
/>

<cfoutput>

<div id="mainContent">
   <div id="loginBox">
        
        <div class="loginTop"></div>
        
        <div id="logoContent">
            <table border="0">
                <tr>
                    <td width="478px" height="96px">
                    	<span class="schoolName">#APPLICATION.SCHOOL.name#</span>
                        Application for Admission
                    </td>
                    <td align="right" width="100px"><img src="../images/onlineApp/logo.gif"></td>
                </tr>
            </table>
        </div>
        
        <div class="loginMain"></div>
        
        <!--- New User --->
        <div class="newUserBox">
			
            <div class="userTypeBox">
            	<h1>Are you a new user?</h1>
            </div>
            
            <!--- New User Form --->
            <form name="newUserForm" id="newUserForm" action="#cgi.SCRIPT_NAME#" method="post">
                <input type="hidden" name="type" value="newApplicant">

			  <cfif FORM.type EQ 'newApplicant'>

					<!--- Page Messages --->
                    <gui:displayPageMessages 
                        pageMessages="#SESSION.pageMessages.GetCollection()#"
                        messageType="login"
                        />

                    <!--- Display Form Errors --->
                    <gui:displayFormErrors 
                        formErrors="#SESSION.formErrors.GetCollection()#"
                        messageType="login"
                    />
                
                </cfif>
                
                <table border="0" align="center" cellpadding="4" cellspacing="0" width="95%">
                    <tr>
                        <td class="style1"><label for="firstName">First Name :</label></td>
                        <td><input type="text" name="firstName" id="firstName" value="#FORM.firstName#" class="largeField" maxlength="100" /></td>
                    </tr>
                    <tr>
                        <td class="style1"><label for="lastName">Last Name:</label></td>
                        <td><input type="text" name="lastName" id="lastName" value="#FORM.lastName#" class="largeField" maxlength="100"></td>
                    </tr>
                    <tr>
                        <td class="style1"><label for="email">Email Address:</label></td>
                        <td><input type="text" name="email" id="email" value="#FORM.email#" class="largeField" maxlength="100"></td>
                    </tr>
                    <tr>
                        <td class="style1" valign="top">
                        	<label for="password">Password:</label>
							<!--- <cftooltip toolTip="Password tip here">
								<img src="../images/onlineApp/questionMarkButton.jpg" border="0" alt="Password Help" /> 
							</cftooltip> --->
                        </td>
                        <td><input type="password" name="password" id="password" value="#FORM.password#" class="password largeField" maxlength="20"></td>
                    </tr>
                    <tr>
                        <td class="style1"><label for="confirmPassword">Confirm Password:</label></td>
                        <td><input type="password" name="confirmPassword" id="confirmPassword" value="#FORM.confirmPassword#" class="largeField" maxlength="20"></td>
                    </tr>
                </table>
                <table border="0" align="center" cellpadding="4" cellspacing="0" width="95%">
                    <tr>
                        <td><a href="../privacy.cfm" class="style2" title="Forgot Login?" target="_blank">Privacy Policy</a></td>
                        <td align="right" width="100"> <input type="image" src="../images/onlineApp/button.png" alt="Login" /></td>
                    </tr>
                </table>
            </form> 
        
        </div>
        
        <!--- Login / Fogot Password --->
        <div class="returningUserBox">
			
            <div class="userTypeBox">
            	<h1>Are you a returning user?</h1>
            </div>
            
            <!--- Login Form --->
            <form name="loginForm" id="loginForm" action="#cgi.SCRIPT_NAME#" method="post" class="#loginFormClass#">
                <input type="hidden" name="type" value="login">

				<cfif FORM.type EQ 'login'>

					<!--- Page Messages --->
                    <gui:displayPageMessages 
                        pageMessages="#SESSION.pageMessages.GetCollection()#"
                        messageType="login"
                        />
                
                    <!--- Display Form Errors --->
                    <gui:displayFormErrors 
                        formErrors="#SESSION.formErrors.GetCollection()#"
                        messageType="login"
                    />
                
                </cfif>
                
                <table border="0" align="center" cellpadding="4" cellspacing="0" width="95%">
                    <tr>
                        <td class="style1"><label for="loginEmail">Email Address:</label></td>
                        <td><input type="text" name="loginEmail" id="loginEmail" value="#FORM.loginEmail#" class="largeField" maxlength="100"></td>
                    </tr>
                    <tr>
                        <td class="style1"><label for="loginPassword">Password:</label></td>
                        <td><input type="password" name="loginPassword" id="loginPassword" value="#FORM.loginPassword#" class="largeField" maxlength="20"></td>
                    </tr>
                </table>
                <table border="0" align="center" cellpadding="4" cellspacing="0" width="95%">
                    <tr>
                        <td><a href="javascript:displayForgotPass();" class="style2" title="Forgot Login?">Forgot Login?</a></td>
                        <td align="right" width="100"> <input type="image" src="../images/onlineApp/button.png" alt="Login" /></td>
                    </tr>
                </table>
                
            </form> 
                 
                       
            <!--- Forgot Password --->
            <form name="forgotPassForm" id="forgotPassForm" action="#cgi.SCRIPT_NAME#" method="post" class="#forgotPassClass#">
				<input type="hidden" name="type" value="forgotPassword">
				
				<cfif FORM.type EQ 'forgotPassword'>

					<!--- Page Messages --->
                    <gui:displayPageMessages 
                        pageMessages="#SESSION.pageMessages.GetCollection()#"
                        messageType="login"
                        />
                
                    <!--- Display Form Errors --->
                    <gui:displayFormErrors 
                        formErrors="#SESSION.formErrors.GetCollection()#"
                        messageType="login"
                    />
                
                </cfif>
                
                <table border="0" align="center" cellpadding="4" cellspacing="0" width="95%">
					<tr><td class="style2" colspan="2">Your login information will be sent to the address entered:</td></tr>
                    <tr>
                        <td class="style1"><label for="forgotEmail">Email:</label></td>
                        <td><input type="text" name="forgotEmail" id="forgotEmail" value="#FORM.forgotEmail#" class="largeField" maxlength="100"></td>
                    </tr>
				</table>
				<table border="0" align="center" cellpadding="4" cellspacing="0" width="95%">
					<tr>
                    	<td><a href="javascript:displayForgotPass();" class="style2" title="Back to Login">Back to Login</a></td>
	                    <td align="right"><input type="image" src="../images/onlineApp/send.png" alt="Login" /></td>
					</tr>          
				</table>
                
            </form>	

        </div>
    </div>

    <div class="boxContainer">
        
        <div class="boxTop"></div>
        
        <div class="boxTile"></div>
        
        <div class="boxBot"></div>
        
    </div>
</div>

<!--- Page Footer --->
<gui:pageFooter
	footerType="login"
/>

</cfoutput>
