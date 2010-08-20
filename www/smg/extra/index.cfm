<!--- ------------------------------------------------------------------------- ----
	
	File:		index.cfm
	Author:		Marcus Melo
	Date:		August 18, 2010
	Desc:		Login Page

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
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
			// Data Validation
					
            FORM.username = Replace(FORM.username, '"', "", "all");
            FORM.username = Replace(FORM.username, "'", "", "all");
            FORM.password = Replace(FORM.password, '"', "", "all");
            FORM.password = Replace(FORM.password, "'", "", "all");
        </cfscript>
		
        <cfif LEN(FORM.userName) AND LEN(FORM.password)>
            
            <!--- Authenticate and Get Default Company --->
            <cfquery name="qAuthenticate" datasource="mysql">
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
    		                          
			<!--- Valid Login --->
            <cfif qAuthenticate.recordcount>
                
                <cfquery name="lastLogin" datasource="mysql">
                    UPDATE 
                        smg_users 
                    SET 
                        lastLogin = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    WHERE 
                        userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qAuthenticate.userID#">
                </cfquery>

                <cfscript>				
					// Set up Session Variables
					SESSION.auth = structNew();
					
					// Set Up Client Variables
					CLIENT.isLoggedIn = 'Yes';
					CLIENT.userID = qAuthenticate.userID;
					CLIENT.firstName = qAuthenticate.firstName;
					CLIENT.lastname =  qAuthenticate.lastname;
					CLIENT.lastLogin = qAuthenticate.lastLogin;
					CLIENT.userType =  qAuthenticate.userType;
					CLIENT.email = qAuthenticate.email;
					CLIENT.companyID = qAuthenticate.companyID;
	
					// If user is following a link and they are already logged in, bypass login info-
					//if ( isDefined('cookie.smglink') AND CLIENT.companyID NEQ 99 ) {
					//	location("redirect_link.cfm", "no");
					//}

                    // SET LINKS                    
					switch(qAuthenticate.companyID) {
						case 7: {
							location("internal/trainee/index.cfm", "no");
							break;
						}
						case 8: {
							location("internal/wat/index.cfm", "no");
							break;
						}
						case 9: {
							location("internal/h2b/index.cfm", "no");
							break;
						}
						default: {
							location("index.cfm", "no");
							break;
						}
					}
					
					// Once more of site is complete, change this to an appropriate welcome page.
					// location("internal/index.cfm?curdoc=initial_welcome", "no");
                </cfscript>		
                            
            <!--- User does not have access to extra --->    
            <cfelse>
                
                <cfscript>
                    // User does not have access to extra
                    CLIENT.isLoggedIn = "No";
                    
                    location("index.cfm", "no");	
               </cfscript> 
            
            </cfif>
    
		</cfif> <!--- LEN(FORM.userName) AND LEN(FORM.password) --->
   
    </cfif> <!--- FORM SUBMITTED --->

</cfsilent>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>EXTRA - Exchange Training Abroad</title>
    <link href="internal/style.css" rel="stylesheet" type="text/css" />
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
                                                <cfinput type="text" name="username" id="username" message="Username is required to login." required="yes" class="style1" size="40" maxlength="100">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td bordercolor="##E9ECF1" bgcolor="##FF7E0D">
                                                <span class="style2" style="margin-left:5px; font-weight:bold">Password:</span> 
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="19" valign="top" bordercolor="##E9ECF1">
                                                <cfinput type="password" name="password" id="password" message="Password is required to login." required="yes" class="style1" size="40" maxlength="20"> 
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