<!--- Kill Extra Output --->
<cfsilent>

	<!--- Param Form Variables --->
    <cfparam name="FORM.username" default="">
    <cfparam name="FORM.password" default="">
    <cfparam name="FORM.email" default="">
    <cfparam name="url.forgot" default="0">
    <cfset errorMsg = ''>
    
	<cfif CGI.http_host is 'jan.case-usa.org'>
        <cflocation url="http://case.exitsapplication.com">
    </cfif>
    
    <cfquery name="qGetCompany" datasource="mysql">
        SELECT 
        	companyid, 
            companyname,
            support_email
        FROM 
        	smg_companies 
        WHERE
        	url_ref = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.http_host#">
    </cfquery>
    
    <cfif qGetCompany.recordcount>
        <cfset CLIENT.companyid = qGetCompany.companyid>
        <cfset CLIENT.companyname = qGetCompany.companyname>
        <cfset CLIENT.emailFrom = qGetCompany.support_email>
    <cfelse>
        <cfset CLIENT.companyid = 0>
        <cfset CLIENT.companyname = 'EXIT Group'>
        <cfset CLIENT.emailFrom = 'support@iseusa.com'>
    </cfif>
    
    <!--- Process Form Submission - login --->
    <cfif isDefined("FORM.login_submitted")>
    
        <cfif TRIM(FORM.username) EQ "">
            <cfset errorMsg = "Please enter the Username.">
        <cfelseif TRIM(FORM.password) EQ "">
            <cfset errorMsg = "Please enter the Password.">
        <cfelse>
        
            <cfinvoke component="nsmg.cfc.user" method="login" returnvariable="errorMsg">
                <cfinvokeargument name="username" value="#FORM.username#">
                <cfinvokeargument name="password" value="#FORM.password#">
            </cfinvoke>
            
        </cfif>
    
    <!--- Process Form Submission - forgot password --->
    <cfelseif isDefined("FORM.forgot_submitted")>
    
        <cfif not isValid("email", TRIM(FORM.email))>
            <cfset errorMsg = "Please enter a valid Email.">
        <cfelse>
    
            <cfquery name="qCheckUsername" datasource="#application.dsn#">
                SELECT 
                	userID,
                    firstName,
                    lastName,
                    userName,
                    password
                FROM 
                	smg_users
                WHERE email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.email)#">
                	AND
                    	active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            </cfquery>
                
            <cfif NOT VAL(qCheckUsername.recordCount)>
                <cfset errorMsg = "The email address entered was not found in our database.">
            <cfelse>
    
                <cfsavecontent variable="email_message">
                    <cfif qCheckUsername.recordCount GT 1>
                        <p>(There were multiple accounts found with the email address entered.)</p>
                    </cfif>
                    <cfoutput query="qCheckUsername">				
                        <p>
                        	#qCheckUsername.firstname# #qCheckUsername.lastname#, a login information retrieval request was made from 
                        	the <a href="http://#CGI.http_host#">http://#CGI.http_host#</a> website. <br>
           		            Your login information is:<br />
                            Username: #qCheckUsername.username#<br />
                            Password: #qCheckUsername.password#
                        </p>
                    </cfoutput>
                    <!----
                    <p>To login please visit: <cfoutput><a href="#application.site_url#">#application.site_url#</a></cfoutput></p>
                    ---->
                </cfsavecontent>
                
                <!--- send email --->
                <cfinvoke component="nsmg.cfc.email" method="send_mail">
                    <cfinvokeargument name="email_to" value="#FORM.email#">
                    <cfinvokeargument name="email_subject" value="EXITS - Login Information">
                    <cfinvokeargument name="email_message" value="#email_message#">
                    <cfinvokeargument name="email_from" value="#CLIENT.emailFrom#">
                </cfinvoke>
                
                <!--- return to the login form, not forgot password FORM. --->
                <cfset url.forgot = 0>
                    
                <script language="JavaScript">
                	<cfset errorMsg = "Your login information has been sent to the email address entered.">
                </script>
            
            </cfif>
                
        </cfif>
     
    </cfif>
    
</cfsilent><head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title><cfoutput>#CLIENT.companyname#</cfoutput></title>
<cfif CLIENT.companyid eq 11>
	<link href="exitsapp_images/WEP.css" rel="stylesheet" type="text/css" media="screen"/>
<cfelseif CLIENT.companyid eq 1>
	<link href="exitsapp_images/ISE.css" rel="stylesheet" type="text/css" media="screen"/>
<cfelse>
	<link href="exitsapp_images/STB.css" rel="stylesheet" type="text/css" media="screen"/>
</cfif>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js" type="text/javascript"></script> <!-- jQuery -->
<script src="SpryAssets/SpryValidationTextField.js" type="text/javascript"></script>
<script src="SpryAssets/SpryValidationPassword.js" type="text/javascript"></script>
<link href="SpryAssets/SpryValidationTextField.css" rel="stylesheet" type="text/css" />
<link href="SpryAssets/SpryValidationPassword.css" rel="stylesheet" type="text/css" />
</head>


<style type="text/css">
<!--
.style1 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
	font-weight: bold;
}
.style2 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
	font-weight: bold;
	color: #003300;
}
.style3 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 9px;
}
a:link {
	text-decoration: none;
}
a:visited {
	text-decoration: none;
}
a:hover {
	text-decoration: underline;
}
a:active {
	text-decoration: none;
}

-->
</style>

<cfoutput>

<cfif errorMsg NEQ ''>
	<script language="JavaScript">
        alert('#errorMsg#');
    </script>
</cfif>

<body>

<div id="mainContent">
<div id="loginBox">
  <div class="loginTop"></div>
  <div id="logoContent">
    <table width="557" height="72" border="0">
      <tr>
        <td width="478" height="96" class="clientcompanyname">
			<Cfif CLIENT.companyid eq 15>
                <font size = px>#CLIENT.companyname#</font>
            <cfelse>
                <cfif CLIENT.companyid eq 11><font color="##000000"></cfif>#CLIENT.companyname#<cfif CLIENT.companyid eq 11></font></cfif>
            </Cfif>
        </td>
        <td align="right" width=100><img src="exitsapp_images/#CLIENT.companyid#.png" ></td>
      </tr>
    </table>
  </div>
  <div class="loginMain"></div>
  <div class="exitLogo"></div>
  <div class="form1">
   <cfif url.forgot>
        <cfform name="login" action="login.cfm?forgot=1" method="post">
        <input type="hidden" name="forgot_submitted" value="1">
        <table border="0" align="center" cellpadding="4" cellspacing="0" width=95%>
            <tr><td class="style3" colspan=2>Your login information will be sent to the address entered:</td></tr>
            <tr>
                <td class="style1">Email:</td>
                <td><cfinput type="text" name="email" id="email" value="#FORM.email#" class="style1" size="30" maxlength="150" required="yes" validate="email" message="Please enter a valid Email."></td>
            </tr>
            <tr>
	            <td>&nbsp;</td>
            </tr>
        </table>
        <table border="0" align="center" cellpadding="4" cellspacing="0" width=95%>
			<tr><td><a href="login.cfm" class="style2">Back to Login</a></td><td align="right"><input type="image" src="exitsapp_images/send.png" alt="Login" /></td></tr>          
        </table>
		</cfform>	
        <script type="text/JavaScript">
			<!--
			// Set cursor to username field
			$(document).ready(function() {
				$("##email").focus();
			});
			//-->
        </script>
	
	<!--- login form --->
    <cfelse>
        <cfform name="login" action="login.cfm" method="post">
        <input type="hidden" name="login_submitted" value="1">
        <table border="0" align="center" cellpadding="4" cellspacing="0" width=95%>
          <tr>
          	<td rowspan=8 valign="top">
           
            </td>
            <td class="style1">Username:</td>
          
            <td ><cfinput type="text" name="username" id="username" value="#FORM.username#" class="style1" size="20" maxlength="100" required="yes" validate="noblanks" message="Please enter the Username."></td>
          </tr>
          <tr>
            <td class="style1">Password:</td>
            
            <td><cfinput type="password" name="password" id="password" value="#FORM.password#" class="style1" size="20" maxlength="15" required="yes" validate="noblanks" message="Please enter the Password."></td>
          </tr>
          </table>
          <table border="0" align="center" cellpadding="4" cellspacing="0" width=95%>
          <tr>
            <td><a href="login.cfm?forgot=1" class="style2" valign="middle" align="right">Forgot Login?</a></td><td align="right" width=100> <input type="image" src="exitsapp_images/button.png" alt="Login" /></td>
          </tr>
        </table>
        </cfform> 
        
        <script type="text/JavaScript">
			<!--
			// Set cursor to username field
			$(document).ready(function() {
				
				if ( $("##username").val() != '' ) {
					$("##username").focus();
				} else {
					$("##password").focus();
				}
				
			});
			//-->
        </script>
        
	</cfif>


  </div>
</div>
<div class="mainContent">
    <div class="boxContainer">
      <div class="boxTop"></div>
      <div class="boxTile"></div>
      <div class="boxBot"></div>
    </div>
  </div>
</div>


<!------ Main Content ------->
<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
try {
var pageTracker = _gat._getTracker("UA-11484433-1");
pageTracker._trackPageview();
} catch(err) {}</script>
</cfoutput>
</body>
</html>

<script type="text/javascript">
<!--
var sprytextfield1 = new Spry.Widget.ValidationTextField("sprytextfield1");
//-->
</script>
<script type="text/javascript">
<!--
var sprypassword1 = new Spry.Widget.ValidationPassword("sprypassword1");
//-->
</script>