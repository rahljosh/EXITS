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
    
        <cfinvoke component="nsmg.cfc.user" method="login" returnvariable="errorMsg">
            <cfinvokeargument name="username" value="#TRIM(form.username)#">
            <cfinvokeargument name="password" value="#TRIM(form.password)#">
        </cfinvoke>
        
	</cfif>

<!--- Process Form Submission - forgot password --->
<cfelseif isDefined("form.forgot_submitted")>

	<cfif not isValid("email", trim(form.email))>
		<cfset errorMsg = "Please enter a valid Email.">
	<cfelse>

		<cfquery name="check_user" datasource="#application.dsn#">
			SELECT *
			FROM smg_users
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
					<p>#firstname# #lastname#, a login information retrieval request was made from the SMG website.
					Your login information is:<br />
					Username: #username#<br />
					Password: #password#</p>
				</cfoutput>
				<p>To login please visit: <cfoutput><a href="#application.site_url#">#application.site_url#</a></cfoutput></p>
			</cfsavecontent>
			
			<!--- send email --->
            <cfinvoke component="nsmg.cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="#form.email#">
                <cfinvokeargument name="email_subject" value="Login Information">
                <cfinvokeargument name="email_message" value="#email_message#">
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

<cfif isDefined('client.userid')>
    <table width="90%"  border="0" align="center" cellpadding="1" cellspacing="0">
     <tr>
        <td class="style3">
            You are already logged in.<br><br>
            <a href="../nsmg/">Resume your session</a><br><br>
            <a href="../nsmg/logout.cfm">Logout</a>
        </td>
    </tr>
    </table>
<cfelse>
	<!--- forgot password form --->
    <cfif url.forgot>
        <table width="90%" border="0" align="center" cellpadding="1" cellspacing="0">
        <cfform name="login" action="index.cfm?forgot=1" method="post">
        <input type="hidden" name="forgot_submitted" value="1">
          <tr>
            <td class="style3">Your login information will be sent to the address entered:</td>
          </tr>
          <tr>
            <td class="style1">Email:</td>
          </tr>
          <tr>
            <td><cfinput type="text" name="email" value="#form.email#" class="style1" size="20" maxlength="150" required="yes" validate="email" message="Please enter a valid Email."></td>
          </tr>
          <tr>
            <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
              <tr>
               <td><a href="index.cfm" class="style2">Login</a></td>
                <td><input name="submit" type="submit" class="style2" value="Submit"></td>
              </tr>
            </table></td>
          </tr>
        </cfform>
        </table>
	<!--- login form --->
    <cfelse>
        <table width="90%" border="0" align="center" cellpadding="1" cellspacing="0">
        <cfform name="login" action="index.cfm" method="post">
        <input type="hidden" name="login_submitted" value="1">
          <tr>
            <td class="style1">Username:</td>
          </tr>
          <tr>
            <td><cfinput type="text" name="username" value="#form.username#" class="style1" size="20" maxlength="100" required="yes" validate="noblanks" message="Please enter the Username."></td>
          </tr>
          <tr>
            <td class="style1">Password:</td>
            </tr>
          <tr>
            <td><cfinput type="password" name="password" value="#form.password#" class="style1" size="20" maxlength="100" required="yes" validate="noblanks" message="Please enter the Password."></td>
          </tr>
          <tr>
            <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
              <tr>
               <td><a href="index.cfm?forgot=1" class="style2">Forgot Login?</a></td>
                <td><input name="submit" type="submit" class="style2" value="Login"></td>
              </tr>
            </table></td>
          </tr>
        </cfform>
        </table>
	</cfif>
</cfif>