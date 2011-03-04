<!--- ------------------------------------------------------------------------- ----
	
	File:		login.cfm
	Author:		Marcus Melo
	Date:		November 08, 2010
	Desc:		Granby Prep - AdminTool Login

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
                qCheckLogin = APPLICATION.CFC.USER.checkLogin(
                    email=FORM.loginEmail,
                    password=FORM.loginPassword
                );
            	
                if ( qCheckLogin.recordcount EQ 1 ) {
                    // Do Login
                    APPLICATION.CFC.ADMINTOOL.doLogin(userID=qCheckLogin.ID);
                    
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
				qCheckEmail = APPLICATION.CFC.USER.checkEmail(email=FORM.forgotEmail);
				
				// Valid Account
				if (qCheckEmail.recordCount) {
					// Email Password
					APPLICATION.CFC.EMAIL.sendEmail(
						emailTo=FORM.forgotEmail,						
						emailType='forgotPassword',
						userID=qCheckEmail.ID
					);

					// Set Page Message
					SESSION.pageMessages.Add("Your login information has been sent");

				} else {
					// Set email is not registered error message
					SESSION.formErrors.Add("Email is not registered. <br /> Please create an account");
				}
				
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
	headerType="adminToolLogin"
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
                        #APPLICATION.SETTINGS.adminToolVersion#
                    </td>
                    <td align="right" width="100px"><img src="../images/onlineApp/logo.gif"></td>
                </tr>
            </table>
        </div>
        
        <div class="loginMain"></div>
               
        <!--- Login / Fogot Password --->
        <div class="returningUserBox">
			
            <div class="userTypeBox">
            	<h1>Log In</h1>
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
                
					<!--- Form Errors --->
                    <gui:displayFormErrors 
                        formErrors="#SESSION.formErrors.GetCollection()#"
                        messageType="login"
                        />

                </cfif>
                
                <table border="0" align="center" cellpadding="4" cellspacing="0" width="90%">
                    <tr>
                        <td class="formTitle"><label for="loginEmail">Email Address:</label></td>
                        <td><input type="text" name="loginEmail" id="loginEmail" value="#FORM.loginEmail#" class="largeField" maxlength="100"></td>
                    </tr>
                    <tr>
                        <td class="formTitle"><label for="loginPassword">Password:</label></td>
                        <td><input type="password" name="loginPassword" id="loginPassword" value="#FORM.loginPassword#" class="largeField" maxlength="20"></td>
                    </tr>
                </table>
                <table border="0" align="center" cellpadding="4" cellspacing="0" width="90%">
                    <tr>
                        <td><a href="javascript:displayForgotPass();" class="style2" title="Forgot Login?">Forgot Login?</a></td>
                        <td align="left" width="250"><input type="image" src="../images/onlineApp/button.png" alt="Login" /></td>
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
                        formErrors="#SESSION.pageMessages.GetCollection()#"
                        messageType="login"
                    />
                
                </cfif>
                
                <table border="0" align="center" cellpadding="4" cellspacing="0" width="90%">
					<tr><td class="style2" colspan="2">Your login information will be sent to the address entered:</td></tr>
                    <tr>
                        <td class="formTitle"><label for="forgotEmail">Email:</label></td>
                        <td><input type="text" name="forgotEmail" id="forgotEmail" value="#FORM.forgotEmail#" class="largeField" maxlength="100"></td>
                    </tr>
				</table>
				<table border="0" align="center" cellpadding="4" cellspacing="0" width="90%">
					<tr>
                    	<td><a href="javascript:displayForgotPass();" class="style2" title="Back to Login">Back to Login</a></td>
	                    <td align="left" width="250"><input type="image" src="../images/onlineApp/send.png" alt="Login" /></td>
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

<script type="text/JavaScript">
<!--
	// Auto Focus - Set cursor to loginEmail field
	$(document).ready(function() {
		
		if ( $("#loginEmail").val() == '' ) {
			$("#loginEmail").focus();
		} else {
			$("#loginPassword").focus();
		}
		
	});	

	// Slide down form field div
	var displayForgotPass = function() { 
		
		if ($("#forgotPassForm").css("display") == "none") {
			$("#loginForm").slideToggle(500);
			$("#forgotPassForm").slideToggle(500);	
			$("#forgotEmail").focus();
		} else {
			$("#forgotPassForm").slideToggle(500);	
			$("#loginForm").slideToggle(500);
			$("#loginEmail").focus();
		}
		
	}
//-->
</script>
