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
					<p>#firstname# #lastname#, a login information retrieval request was made from the #client.company_submitting# website.
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
<cfoutput>
<h2 align="center">

LOGIN FOR 
<cfif isDefined('session.company_submitting')>
  #client.company_submitting#
    <cfelse>
EXITS Application<br />
</cfif>
</h2>
<cfif session.company_submitting is 'CASE'>
<h3 align="center">Please login here for January Applications / Students. <br />
For previous students, please login at <a href="http://www.case-usa.org/">www.case-usa.org</a><br /></h3>
</cfif>


</cfoutput>
<cfif isDefined('session.userid')>
    <table border="0" align="center" cellpadding="1" cellspacing="0">
     <tr>
        <td class="style3">
            You are already logged in.<br><br>
            <a href="nsmg/">Resume your session</a><br><br>
            <a href="nsmg/logout.cfm">Logout</a>
        </td>
    </tr>
    </table>
<cfelse>
	<!--- forgot password form --->
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
            <cfif session.company_submitting is 'CASE'>
<img src="http://jan.case-usa.org/nsmg/pics/logos/10_header_logo.png" />
</cfif>
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
</cfif>