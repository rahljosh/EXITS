
<!--- Kill Extra Output --->

<cfsilent>
	<cfloop list="#GetClientVariablesList()#" index="ThisVarName">
		<cfset temp = DeleteClientVariable(ThisVarName)>
	</cfloop>
	<cfscript>
		
		// redirect to SSL
		//if ( NOT APPLICATION.isServerLocal AND CGI.SERVER_PORT EQ 80 ) {
		//	location("https://#CGI.HTTP_HOST#", "no");
		//}
	</cfscript>

	<!--- Param Form Variables --->
    <cfparam name="FORM.username" default="">
    <cfparam name="FORM.password" default="">
    <cfparam name="FORM.email" default="">
    <cfparam name="URL.forgot" default="0">
    <cfparam name="URL.ref" default="">
    <cfset errorMsg = ''>
        
    <cfquery name="qGetCompany" datasource="mysql">
        SELECT 
        	companyid, 
            companyname,
            support_email,
            url_ref
        FROM 
        	smg_companies 
        WHERE
        	url_ref = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.http_host#">
    </cfquery>
    
    <cfif qGetCompany.recordcount>
        <cfset CLIENT.companyid = qGetCompany.companyid>
        <cfset CLIENT.companyname = qGetCompany.companyname>
        <cfset CLIENT.emailFrom = qGetCompany.support_email>
        <cfset CLIENT.site_url = qGetCompany.url_ref>
    <cfelse>
        <cfset CLIENT.companyid = 0>
        <cfset CLIENT.companyname = 'EXIT Group'>
        <cfset CLIENT.emailFrom = 'support@iseusa.org'>
        <cfset CLIENT.site_url = 'ise.exitsapplication.com'>
    </cfif>

    <cfif APPLICATION.isServerLocal>
		<cfset CLIENT.EXITS_URL = 'http://ise.exitsapplication.com'>
	<cfelse>
		<cfset CLIENT.EXITS_URL = 'https://' & CGI.HTTP_HOST>
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
    		
            <!--- Username - Check email address --->
            <cfquery name="qCheckUsername" datasource="#application.dsn#">
                SELECT 
                	userID,
                    firstName,
                    lastName,
                    userName,
                    password
                FROM 
                	smg_users
                WHERE 
                	email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.email)#">
               	AND
                   	active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            </cfquery>
            
            <!--- Username - Email Login Information --->    
            <cfif VAL(qCheckUsername.recordCount)>
    
                <cfsavecontent variable="email_message">
                    <cfif qCheckUsername.recordCount GT 1>
                        <p>(There were multiple accounts found with the email address entered.)</p>
                    </cfif>
                    <cfoutput query="qCheckUsername">				
                        <p>
                        	#qCheckUsername.firstname# #qCheckUsername.lastname#, a login information retrieval request was made from 
                        	the <a href="#CLIENT.EXITS_URL#">#CLIENT.EXITS_URL#</a> website. <br /><br />
           		            Your login information is: <br /><br />
                            Username: #qCheckUsername.username#<br />
                            Password: #qCheckUsername.password#
                        </p>
                        
                        <p>To login please visit: <a href="#CLIENT.EXITS_URL#">#CLIENT.EXITS_URL#</a> </p>
                    </cfoutput>
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
            
            <!--- Student - Check email address --->
            <cfquery name="qCheckStudentAccount" datasource="#application.dsn#">
                SELECT 
                	studentID,
                    firstName,
                    familyLastName,
                    email,
                    password
                FROM 
                	smg_students
                WHERE 
                	email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.email)#">
                AND
                   	active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            </cfquery>
                         
            <!--- Student - Email Login Information --->      
            <cfif VAL(qCheckStudentAccount.recordCount)>
    
                <cfsavecontent variable="email_message">
                    <cfif qCheckStudentAccount.recordCount GT 1>
                        <p>(There were multiple accounts found with the email address entered.)</p>
                    </cfif>
                    <cfoutput query="qCheckStudentAccount">				
                        <p>
                        	#qCheckStudentAccount.firstname# #qCheckStudentAccount.familyLastName#, a login information retrieval request was made from 
                        	the <a href="#CLIENT.EXITS_URL#">#CLIENT.EXITS_URL#</a> website. <br>
           		            Your login information is:<br />
                            Username: #qCheckStudentAccount.email#<br />
                            Password: #qCheckStudentAccount.password#
                        </p>
                        
                        <p>To login please visit: <a href="#CLIENT.site_url#">#CLIENT.site_url#</a></p>
                    </cfoutput>
                   
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

			<!--- Error Message --->
            <cfif NOT VAL(qCheckUsername.recordCount) AND NOT VAL(qCheckStudentAccount.recordCount)>
                <cfset errorMsg = "The email address entered was not found in our database.">
			</cfif>

        </cfif>
     
    </cfif>
    
</cfsilent><head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title><cfoutput>#CLIENT.companyname#</cfoutput></title>
<cfif CLIENT.companyid eq 11>
	<link href="exitsapp_images/WEP.css" rel="stylesheet" type="text/css" media="screen"/>
<cfelseif CLIENT.companyid eq 13>
	<link href="exitsapp_images/CANADA.css" rel="stylesheet" type="text/css" media="screen"/>
<cfelseif CLIENT.companyid eq 1>
	<link href="exitsapp_images/ISE.css" rel="stylesheet" type="text/css" media="screen"/>
<cfelse>
	<link href="exitsapp_images/STB.css" rel="stylesheet" type="text/css" media="screen"/>
</cfif>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.5.1/jquery.min.js" type="text/javascript"></script> <!-- jQuery -->

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
<cfinclude template="analytics.cfm">
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
        <cfform name="login" action="login.cfm?forgot=1&#cgi.SCRIPT_NAME#" method="post">
        <input type="hidden" name="forgot_submitted" value="1">
        <table border="0" align="center" cellpadding="4" cellspacing="0" width=95%>
            <tr><td class="style3" colspan=2>Your login information will be sent to the address entered:</td></tr>
            <tr>
                <td class="style1">Email:</td>
                <td><cfinput type="text" name="email" id="email" value="#FORM.email#" class="style1" size="25" maxlength="150" required="yes" validate="email" message="Please enter a valid Email."></td>
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
        <cfform name="login" action="login.cfm?#cgi.QUERY_STRING#" method="post">
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
            
            <td><cfinput type="password" name="password" id="password" value="#FORM.password#" class="style1" size="20" maxlength="50" required="yes" validate="noblanks" message="Please enter the Password."></td>
          </tr>
          </table>
          <table border="0" align="center" cellpadding="4" cellspacing="0" width=95%>
          <tr>
            <td><a href="login.cfm?forgot=1" class="style2" valign="middle" align="right">Forgot Login?</a></td><td align="right" width=100> <input type="image" src="exitsapp_images/button.png" alt="Login" /></td>
          </tr>
          <cfif qGetCompany.companyid neq 14>
          <tr>
          	<td colspan=2>Host Families: 
				<cfif qGetCompany.companyid eq 10>  <a href="https://www.case-usa.org/hostApp">
                	<cfelseif qGetCompany.companyID eq 15> <a href="https://dash.exitsapplication.com/hostApplication/index.cfm?section=login">
                    <Cfelse><a href="https://www.iseusa.org/hostApp">
                </cfif>Click Here!</a></td>
          </tr>
          </cfif>
          </tr>
        </table>
        </cfform> 
        
        <script type="text/JavaScript">
			<!--
			// Set cursor to username field
			$(document).ready(function() {
				
				if ( $("##username").val() == '' ) {
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
</body></cfoutput>

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