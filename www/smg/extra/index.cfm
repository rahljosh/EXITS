<!--- ------------------------------------------------------------------------- ----
	
	File:		index.cfm
	Author:		Marcus Melo
	Date:		August 18, 2010
	Desc:		Login Page - Users and Candidates

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="extensions/customtags/gui/" prefix="gui" />	
	
	<!--- Param Form Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.userName" default="">
    <cfparam name="FORM.password" default="">

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
	</cfscript>

	<!--- FORM SUBMITTED --->
    <cfif FORM.submitted>
                
		<cfscript>
			// FORM Validation
			if ( NOT LEN(FORM.username) ) {
				SESSION.formErrors.Add("Please enter an username");
			}
			
			if ( NOT LEN(FORM.password) ) {
				SESSION.formErrors.Add("Please enter a password");
			}
        </cfscript>
		
        <!--- Check if there are no errors --->
        <cfif NOT SESSION.formErrors.length()>
                        
            <!--- User - Authenticate and Get Default Company --->
            <cfquery name="qAuthenticateUser" datasource="mysql">
                SELECT 
                    u.userID,
                    u.firstName,
                    u.lastName,
                    u.lastLogin,
                    u.userType,
                    u.email,
                    uar.companyID
                FROM 
                    smg_users u 
                INNER JOIN
                    user_access_rights uar ON uar.userID = u.userID
                INNER JOIN
                    smg_companies c ON c.companyID = uar.companyID
                WHERE 
                    u.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.username#"> 
                AND 
                    u.password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.password#">
                AND 
                    u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                AND   
                    c.system_id = <cfqueryparam cfsqltype="cf_sql_integer" value="4">
                ORDER BY 
                    uar.default_region DESC
            </cfquery>
    		
            <!--- Candidate - Authenticate and Get Company --->
            <cfscript>
				//Check Candidate Login
                qAuthenticateCandidate = APPLICATION.CFC.CANDIDATE.checkLogin(
                    email=FORM.username,
                    password=FORM.password
                );
			</cfscript>
                                                  
			<!--- Valid User Login --->
            <cfif qAuthenticateUser.recordcount>
                
                <cfquery name="lastLogin" datasource="mysql">
                    UPDATE 
                        smg_users 
                    SET 
                        lastLogin = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    WHERE 
                        userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qAuthenticateUser.userID#">
                </cfquery>

                <cfscript>				
					// Set up Session Variables
					SESSION.auth = structNew();
					
					// Set Up Client Variables
					CLIENT.isLoggedIn = 1;
					CLIENT.loginType = 'user';
					CLIENT.userID = qAuthenticateUser.userID;
					CLIENT.firstName = qAuthenticateUser.firstName;
					CLIENT.lastname =  qAuthenticateUser.lastname;
					CLIENT.lastLogin = qAuthenticateUser.lastLogin;
					CLIENT.userType =  qAuthenticateUser.userType;
					CLIENT.email = qAuthenticateUser.email;
					CLIENT.companyID = qAuthenticateUser.companyID;
						
					// SET LINKS        
					getLink = APPLICATION.CFC.onlineApp.setLoginLinks(
						companyID=qAuthenticateUser.companyID,
						loginType='user'
					);
					
					// Redirect User to appropriate page
					location(getLink, "no");
                </cfscript>		
            
            <!--- Valid Candidate Login --->
            <cfelseif VAL(qAuthenticateCandidate.recordCount)>

				<cfscript>
					// SET LINKS        
					getLink = APPLICATION.CFC.onlineApp.setLoginLinks(
						companyID=qAuthenticateCandidate.companyID,
						loginType='candidate'
					);

					// Do Login / Set SESSION variables / Update Last Logged in Date
                    APPLICATION.CFC.ONLINEAPP.doLogin(candidateID=qAuthenticateCandidate.candidateID);
                    				
					// Redirect Candidate to appropriate page
					location(getLink, "no");
				</cfscript>
                            
                            
            <!--- User does not have access to extra --->    
            <cfelse>
                
                <cfscript>
                    // User does not have access to extra
					CLIENT.isLoggedIn = "No";
					
					SESSION.formErrors.Add("Please check your account credentials");
               </cfscript> 
            
            </cfif>
    
		</cfif> <!--- NOT SESSION.formErrors.length() --->
   
    </cfif> <!--- FORM SUBMITTED --->

</cfsilent>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>EXTRA - Exchange Training Abroad</title>
    <link href="internal/style.css" rel="stylesheet" type="text/css" />
    <link href="internal/linked/css/login.css" rel="stylesheet" type="text/css" />
    <link rel="SHORTCUT ICON" href="pics/favicon.ico">
    <cfoutput><script src="#APPLICATION.PATH.jQuery#" type="text/javascript"></script></cfoutput> <!-- jQuery -->
</head>
<body>

<cfoutput>

<cfform name="login" action="#CGI.SCRIPT_NAME#" method="post">
<input type="hidden" name="submitted" value="1" />
            
<table width="720" border="0" align="center" cellpadding="0" cellspacing="0" style="margin-top:150px;">
    <tr>
        <td height="389" background="login.gif">
            
            <table width="91%" border="0" cellspacing="0" cellpadding="0" style="margin-top:50px;">
                <tr>
                    <td width="55%">&nbsp;</td>
                    <td width="45%">
                        
                        <table width="250"  border="0" align="center" cellpadding="3" cellspacing="1" bgcolor="##999999">
                            <tr>
                                <td bgcolor="##FFFFFF" class="style1">

									<!--- Form Errors --->
                                    <gui:displayFormErrors 
                                        formErrors="#SESSION.formErrors.GetCollection()#"
                                        messageType="login"
                                        />
									                                   
                                    <table width="100%"  border="0" align="center" cellpadding="5" cellspacing="1" bordercolor="##DDE0E5">
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
                                                <cfinput type="text" name="username" id="username" value="#FORM.userName#" message="Username is required to login." required="yes" class="style1" size="40" maxlength="100">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td bordercolor="##E9ECF1" bgcolor="##FF7E0D">
                                                <span class="style2" style="margin-left:5px; font-weight:bold">Password:</span> 
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="19" valign="top" bordercolor="##E9ECF1">
                                                <cfinput type="password" name="password" id="password" value="#FORM.password#" message="Password is required to login." required="yes" class="style1" size="40" maxlength="20"> 
                                            </td>
                                        </tr>
                                        <tr>
                                            <td bordercolor="##E9ECF1">
                                                
                                                <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                        <td><a href="reauthenticate.cfm" target="_top" class="style1">Forgot Login?</a></td>
                                                        <td><input name="Submit" type="submit" class="style1" value="Login" /></td>
                                                    </tr>
                                                </table>
                                                
                                            </td>
                                        </tr>
                                    </table>
                                    
                            	</td>
                            </tr>
                        </table>

                    </td>
                </tr>
            </table>
    
        </td>
    </tr>
</table>

</cfform>

</cfoutput>

<script type="text/JavaScript">
<!--
	// Set cursor to username field
	$(document).ready(function() {
		if ( $("#username").val() == '' ) {
			$("#username").focus();
		} else {
			$("#password").focus();
		}
	});
//-->
</script>

</body>
</html>