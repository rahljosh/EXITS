<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>STB Pacific</title>
<link href="STB.css" rel="stylesheet" type="text/css" />
<script src="SpryAssets/SpryValidationTextField.js" type="text/javascript"></script>
<script src="SpryAssets/SpryValidationPassword.js" type="text/javascript"></script>
<link href="SpryAssets/SpryValidationTextField.css" rel="stylesheet" type="text/css" />
<link href="SpryAssets/SpryValidationPassword.css" rel="stylesheet" type="text/css" />
</head>

<!--- this login page is for the new layout, and is the same as the flash/login.cfm include but modified to work as a separate page. --->



<cfparam name="form.username" default="">
<cfparam name="form.password" default="">
<cfparam name="form.email" default="">
<cfparam name="url.forgot" default="0">
<cfset errorMsg = ''>

<!--- Process Form Submission - login --->
<cfif isDefined("form.login_submitted")>

	<cfif trim(form.username) EQ "">
		<cfset errorMsg = "Please enter the Username.">
	<cfelseif trim(form.password) EQ "">
		<cfset errorMsg = "Please enter the Password.">
	<cfelse>
    
        <cfinvoke component="exits.cfc.user" method="login" returnvariable="errorMsg">
            <cfinvokeargument name="username" value="#form.username#">
            <cfinvokeargument name="password" value="#form.password#">
        </cfinvoke>
        
	</cfif>

<!--- Process Form Submission - forgot password --->
<cfelseif isDefined("form.forgot_submitted")>

	<cfif not isValid("email", trim(form.email))>
		<cfset errorMsg = "Please enter a valid Email.">
	<cfelse>

		<cfquery name="check_user" datasource="#application.dsn#">
			SELECT *
			FROM users
			WHERE email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.email)#">
		</cfquery>
	 		
		<cfif check_user.recordCount EQ 0>
			<cfset errorMsg = "The email address entered was not found in our database.">
		<cfelse>

			<cfsavecontent variable="email_message">
            	<cfif check_user.recordCount GT 1>
                	<p>(There were multiple accounts found with the email address entered.)</p>
                </cfif>
				<cfoutput query="check_user">				
					<p>#firstname# #lastname#, a login information retrieval request was made from the #session.company_submitting# website.
					Your login information is:<br />
					Username: #username#<br />
					Password: #password#</p>
				</cfoutput>
                <!----
				<p>To login please visit: <cfoutput><a href="#application.site_url#">#application.site_url#</a></cfoutput></p>
				---->
			</cfsavecontent>
			
			<!--- send email --->
            <cfinvoke component="exits.cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="#form.email#">
                <cfinvokeargument name="email_subject" value="Login Information">
                <cfinvokeargument name="email_message" value="#email_message#">
                <cfinvokeargument name="email_from" value="#email_from#">
            </cfinvoke>
            
            <!--- return to the login form, not forgot password form. --->
            <cfset url.forgot = 0>
				
			<script language="JavaScript">
                alert('Your login information has been sent to the email address entered.');
            </script>
		
		</cfif>
            
	</cfif>
 
</cfif>

<cfif errorMsg NEQ ''>
	<script language="JavaScript">
        alert('<cfoutput>#errorMsg#</cfoutput>');
    </script>
</cfif>

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


<body>
<div id="mainContent">
<div id="loginBox">
  <div class="loginTop"></div>
  <div id="logoContent">
    <table width="557" height="72" border="0">
      <tr>
        <td width="189" height="68">STB Pacific</td>
        <td width="311">&nbsp;</td>
        <td width="43"><img src="images/logoInd.png" width="74" height="97" /></td>
      </tr>
    </table>
  </div>
  <div class="loginMain"></div>
  <div class="exitLogo"></div>
  <div class="form1">
   <cfif url.forgot>
        <table border="0" align="center" cellpadding="1" cellspacing="0">
        <cfform name="login" action="login.cfm?forgot=1" method="post">
        <input type="hidden" name="forgot_submitted" value="1">
          <tr>
            <td class="style3">Your login information will be sent to the address entered:</td>
          </tr>
          <tr>
            <td class="style1">Email:</td>
          </tr>
          <tr>
            <td><cfinput type="text" name="email" value="#form.email#" class="style1" size="30" maxlength="150" required="yes" validate="email" message="Please enter a valid Email."></td>
          </tr>
          <tr>
            <td><input name="submit" type="submit" class="style2" value="Submit"></td>
          </tr>
        </cfform>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td><a href="login.cfm" class="style2">Login</a></td>
          </tr>
        </table>
	<!--- login form --->
    <cfelse>
        <table border="0" align="center" cellpadding="1" cellspacing="0">
        <cfform name="login" action="login.cfm" method="post">
        <input type="hidden" name="login_submitted" value="1">
          <tr>
          	<td rowspan=8 valign="top">
           
            </td>
            <td class="style1">Username:</td>
          </tr>
          <tr>
            <td><cfinput type="text" name="username" value="#form.username#" class="style1" size="30" maxlength="100" required="yes" validate="noblanks" message="Please enter the Username."></td>
          </tr>
          <tr>
            <td class="style1">Password:</td>
            </tr>
          <tr>
            <td><cfinput type="password" name="password" value="#form.password#" class="style1" size="20" maxlength="15" required="yes" validate="noblanks" message="Please enter the Password."></td>
          </tr>
          <tr>
            <td><input name="submit" type="submit" class="style2" value="Login"></td>
          </tr>
        </cfform>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td><a href="login.cfm?forgot=1" class="style2">Forgot Login?</a></td>
          </tr>
        </table>
	</cfif>

  
  <form id="form1" name="form1" method="post" action=""><span id="sprytextfield1">Username:
        <input type="text" name="Username" id="Username" />
        <span class="textfieldRequiredMsg">A value is required.</span></span>
      <br />
      <br/>
    </form>
    <span id="sprypassword1">Password:&nbsp;
    <input type="password" name="Password" id="Password" />
    <span class="passwordRequiredMsg">A value is required.</span></span>
      <div class="button">Forgot your Password?</div>
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
