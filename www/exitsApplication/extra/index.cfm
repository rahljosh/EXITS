<!--- ------------------------------------------------------------------------- ----
	
	File:		index.cfm
	Author:		Marcus Melo
	Date:		August 18, 2010
	Desc:		Login Page - Users and Candidates

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />	
	
	<!--- Param Form Variables --->
    <cfparam name="FORM.type" default="">
    <!--- Login --->
    <cfparam name="FORM.userName" default="">
    <cfparam name="FORM.password" default="">
    <!--- Forgot Password --->
    <cfparam name="FORM.forgotEmail" default="">

	<!--- Param URL Variables --->
    <cfparam name="URL.link" default="">
    <cfparam name="URL.user" default="0">
    
    <!--- SSL --->
    <cfscript>
		if ( NOT APPLICATION.IsServerLocal AND CGI.SERVER_PORT EQ 80 ) {
			location("https://#CGI.HTTP_HOST##CGI.SCRIPT_NAME#", "no");		
		}
		
		if ( LEN(URL.link) ) {
			
			COOKIE.smglink = URL.link;
			
			// relocate if user is logged in
			if ( VAL(CLIENT.companyID) AND CLIENT.companyID NEQ 99 ) {
				location("redirect_link.cfm", "no");	
			}
			
			// location("index.cfm", "no");
		}
	
        // DO LOGIN
        if ( FORM.type EQ 'login' ) {
        
            // FORM Validation
            if ( NOT LEN(FORM.username) ) {
                SESSION.formErrors.Add("Please enter an username");
            }
            
            if ( NOT LEN(FORM.password) ) {
                SESSION.formErrors.Add("Please enter a password");
            }

            // Check if there are no errors
            if ( NOT SESSION.formErrors.length() ) {
        
                // Check User Login
                qAuthenticateUser = APPLICATION.CFC.USER.authenticateUser(
                    username=FORM.username,
                    password=FORM.password
                );
            
                // Check Candidate Login
                qAuthenticateCandidate = APPLICATION.CFC.CANDIDATE.authenticateCandidate(
                    email=FORM.username,
                    password=FORM.password
                );

                // Valid User Login
                if ( qAuthenticateUser.recordcount )  {
                
                    // SET LINKS        
                    getLink = APPLICATION.CFC.onlineApp.setLoginLinks(
                        companyID=qAuthenticateUser.companyID,
                        loginType='user'
                    );
                    
                    // Do Login / Set CLIENT Variables / Update Last Logged in Date
                    APPLICATION.CFC.USER.doLogin(qUser=qAuthenticateUser);

                    // Redirect Candidate to appropriate page
                    location(getLink, "no");

                // Valid Candidate Login 
                } else if ( qAuthenticateCandidate.recordCount ) {

                    // SET LINKS        
                    getLink = APPLICATION.CFC.onlineApp.setLoginLinks(
                        companyID=qAuthenticateCandidate.companyID,
                        loginType='candidate'
                    );

                    // Do Login / Set SESSION variables / Update Last Logged in Date
                    APPLICATION.CFC.ONLINEAPP.doLogin(candidateID=qAuthenticateCandidate.candidateID);

                    // Redirect Candidate to appropriate page
                    location(getLink, "no");

                } else {
                    
                    // User/Candidate does not have access to extra
                    CLIENT.isLoggedIn = "No";
                    
                    SESSION.formErrors.Add("Please check your account credentials");
                    
                }
            
            } // NOT SESSION.formErrors.length()
        
        // RETRIEVE PASSWORD
        } else if ( FORM.type EQ 'forgotPassword' ) {
            
            // FORM Validation
            if ( NOT LEN(FORM.forgotEmail) OR NOT IsValid("email", FORM.forgotEmail) ) {
                SESSION.formErrors.Add("Enter a valid email address");
            }
            
            // Check if there are no errors
            if ( NOT SESSION.formErrors.length() ) {
                
                // Check User Account
                qCheckUserAccount = APPLICATION.CFC.USER.checkEmail(email=FORM.forgotEmail);
            
                // Check Candidate Account
                qCheckCandidateAccount = APPLICATION.CFC.CANDIDATE.checkEmail(email=FORM.forgotEmail);
                
				// EMAIL User Account Information
                if ( qCheckUserAccount.recordCount ) {

					// Send out Email Confirmation
					APPLICATION.CFC.EMAIL.sendEmail(
						emailTo=qCheckUserAccount.email,
						emailTemplate='userForgotPassword',
						userID=qCheckUserAccount.userID
					);

					SESSION.pageMessages.Add("Your login information has been sent");

				// EMAIL Candidate Account Information - If there is a proper account ( email / password )
                } else if ( qCheckCandidateAccount.recordCount AND LEN(qCheckCandidateAccount.password) ) {

					if ( qCheckCandidateAccount.applicationStatusID EQ 1 ) {
						
						// Pending Activation - Send out Activation Email
						APPLICATION.CFC.EMAIL.sendEmail(
							emailTo=qCheckCandidateAccount.email,
							emailTemplate='newAccount',
							candidateID=qCheckCandidateAccount.candidateID
						);

						SESSION.pageMessages.Add("Account activation instructions has been emailed to you");	

					} else {
						
						// Account Active - Send out Email Confirmation
						APPLICATION.CFC.EMAIL.sendEmail(
							emailTo=qCheckCandidateAccount.email,
							emailTemplate='forgotPassword',
							candidateID=qCheckCandidateAccount.candidateID
						);
						
						SESSION.pageMessages.Add("Your login information has been emailed to you");

					}
			
                // Account Not Found
                } else {
                    SESSION.formErrors.Add("Email address is not registered or your account is inactive. Please contact #APPLICATION.EMAIL.support# if you have any questions");
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

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>EXTRA - Exchange Training Abroad</title>
    <link href="internal/style.css" rel="stylesheet" type="text/css" />
    <link href="internal/linked/css/login.css" rel="stylesheet" type="text/css" />
    <link rel="shortcut icon" href="pics/favicon.ico" type="image/x-icon" />
    <cfoutput><script src="#APPLICATION.PATH.jQuery#" type="text/javascript"></script></cfoutput> <!-- jQuery -->
</head>
<body>

<cfoutput>

<table width="720" border="0" align="center" cellpadding="0" cellspacing="0" style="margin-top:150px;">
    <tr>
        <td height="389" background="login.gif">
            
            <table width="91%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
                <tr>
                    <td width="55%">&nbsp;</td>
                    <td width="45%">
                        
                        <table width="285"  border="0" align="center" cellpadding="3" cellspacing="1" bgcolor="##999999">
                            <tr>
                                <td bgcolor="##FFFFFF" class="style1">

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
									
                                    <!--- Login --->
                                    <cfform name="loginForm" id="loginForm" action="#CGI.SCRIPT_NAME#" method="post" class="#loginFormClass#">
                                        <input type="hidden" name="type" value="login" />
                                                                                       
                                        <table width="100%" border="0" align="center" cellpadding="5" cellspacing="1" bordercolor="##DDE0E5">
                                            <cfif VAL(URL.user)>
                                                <tr>
                                                    <td bgcolor="##FF3300">
                                                        <font color="white">Accounts are automatically logged out after 2 hrs of inactivity.<br>  Please re-login to continue.</font>
                                                    </td>
                                                </tr>
                                            </cfif>
                                            <tr>
                                                <td bordercolor="##E9ECF1" bgcolor="##FF7E0D" class="style4">
                                                    <span class="style2" style="margin-left:5px; font-weight:bold">Username:</span> 
                                                </td>
                                            </tr>
                                            <tr>
                                                <td height="19" valign="top" bordercolor="##E9ECF1">
                                                    <cfinput type="text" name="username" id="username" value="#FORM.userName#" message="Username is required to login." required="yes" class="style1" size="45" maxlength="100">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td bordercolor="##E9ECF1" bgcolor="##FF7E0D">
                                                    <span class="style2" style="margin-left:5px; font-weight:bold">Password:</span> 
                                                </td>
                                            </tr>
                                            <tr>
                                                <td height="19" valign="top" bordercolor="##E9ECF1">
                                                    <cfinput type="password" name="password" id="password" value="#FORM.password#" message="Password is required to login." required="yes" class="style1" size="45" maxlength="20"> 
                                                </td>
                                            </tr>
                                            <tr>
                                                <td bordercolor="##E9ECF1">
                                                    
                                                    <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                            <td><a href="javascript:displayForgotPass();" class="style1" title="Forgot Login?">Forgot Login?</a></td>
                                                            <td><input name="Submit" type="submit" class="style1" value="Login" /></td>
                                                        </tr>
                                                    </table>
                                                    
                                                </td>
                                            </tr>
                                        </table>
                                    </cfform>
                                    
                                    
									<!--- Forgot Password --->
                                    <cfform name="forgotPassForm" id="forgotPassForm" action="#cgi.SCRIPT_NAME#" method="post" class="#forgotPassClass#">
                                        <input type="hidden" name="type" value="forgotPassword">
                                        
                                        <table width="100%"  border="0" align="center" cellpadding="5" cellspacing="1" bordercolor="##DDE0E5">
                                            <tr><td class="style1" colspan="2">Your login information will be sent to the email address entered:</td></tr>
                                            <tr>
                                                <td bordercolor="##E9ECF1" bgcolor="##FF7E0D" class="style4">
                                                    <span class="style2" style="margin-left:5px; font-weight:bold">Email Address:</span> 
                                                </td>
                                            </tr>
                                            <tr>
                                                <td height="19" valign="top" bordercolor="##E9ECF1">
                                                    <cfinput type="text" name="forgotEmail" id="forgotEmail" value="#FORM.forgotEmail#" message="Email address is required" required="yes" class="style1" size="45" maxlength="100">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td bordercolor="##E9ECF1">
                                                    
                                                    <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                            <td><a href="javascript:displayForgotPass();" class="style1" title="Back to Login">Back to Login</a></td>
                                                            <td><input name="Submit" type="submit" class="style1" value="Submit" /></td>
                                                        </tr>
                                                    </table>
                                                    
                                                </td>
                                            </tr>
                                        </table>
                                    </cfform>	
                                    
                            	</td>
                            </tr>
                        </table>

                    </td>
                </tr>
            </table>
    
        </td>
    </tr>
</table>

</cfoutput>

<script type="text/JavaScript">
<!--
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

	// Auto Focus - Set cursor to username field
	$(document).ready(function() {
		
		if ( $("#username").val() == '' ) {
			$("#username").focus();
		} else {
			$("#loginPassword").focus();
		}
		
	});	
	
//-->
</script>

</body>
</html>
