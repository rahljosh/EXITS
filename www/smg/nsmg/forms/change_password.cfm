<cfset errorMsg = ''>

<!--- Process Form Submission --->
<cfif isDefined("form.submitted")>
    
	<cfif trim(form.old_password) EQ ''>
		<cfset errorMsg = "Please enter the Old Password.">
	<cfelseif trim(form.new_password) EQ ''>
		<cfset errorMsg = "Please enter the New Password.">
	<cfelseif trim(form.verify_new_password) EQ ''>
		<cfset errorMsg = "Please verify the New Password.">
	<cfelseif trim(form.old_password) EQ trim(form.new_password)>
		<cfset errorMsg = "New Password cannot be the same as Old Password.">
	<cfelseif len(trim(form.new_password)) LT 6>
		<cfset errorMsg = "New Password must be at least 6 characters.">
	<cfelseif trim(form.new_password) NEQ trim(form.verify_new_password)>
		<cfset errorMsg = "Verify New Password must be the same as New Password.">
	</cfif>
    <cfif errorMsg EQ ''>
		<cfset contains_alpha = 0>
        <cfset contains_numeric = 0>
        <cfloop index="i" from="1" to="#len(trim(form.new_password))#">
        	<cfset character = mid(trim(form.new_password), i, 1)>
            <cfif character GTE 'A' AND character LTE 'Z'>
                <cfset contains_alpha = 1>
            </cfif>
            <cfif isNumeric(character)>
                <cfset contains_numeric = 1>
            </cfif>
        </cfloop>
        <cfif not (contains_alpha AND contains_numeric)>
            <cfset errorMsg = "New Password must include both alphabetic and numeric characters.">
        </cfif>
	</cfif>
    <cfif errorMsg EQ ''>
        <cfquery name="get_user" datasource="#application.dsn#">
            SELECT password, email
            FROM smg_users
            WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
        </cfquery>
		<cfif get_user.password NEQ trim(form.old_password)>
            <cfset errorMsg = "Old Password is invalid.">
		<cfelseif findNoCase(trim(form.new_password), get_user.email)>
            <cfset errorMsg = "New Password cannot be a substring of your Email.">
        </cfif>
	</cfif>
    <cfif errorMsg EQ ''>
        <cfquery datasource="#application.dsn#">
            UPDATE smg_users SET
            password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.new_password#">,
            changepass = 0
            WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
        </cfquery>
        <!--- we were directed here from application.cfm after the user logged in with "force user to change password" checked on their user form. --->
        <cfif isDefined("client.change_password")>
			<cfset temp = DeleteClientVariable("change_password")>
            <cflocation url="index.cfm?curdoc=initial_welcome" addtoken="no">
        <cfelse>
        	<cflocation url="index.cfm?curdoc=user_info&userid=#client.userid#" addtoken="no">
        </cfif>
	</cfif>

<cfelse>

	<cfset form.old_password = ''>
	<cfset form.new_password = ''>
	<cfset form.verify_new_password = ''>

</cfif>

<cfif errorMsg NEQ ''>
	<script language="JavaScript">
        alert('<cfoutput>#errorMsg#</cfoutput>');
    </script>
</cfif>

<script type="text/javascript">
function checkForm() {
	if (document.my_form.old_password.value == document.my_form.new_password.value) {alert("New Password cannot be the same as Old Password."); return false; }
	if (document.my_form.new_password.value.length < 6) {alert("New Password must be at least 6 characters."); return false; }
	if (document.my_form.new_password.value != document.my_form.verify_new_password.value) {alert("Verify New Password must be the same as New Password."); return false; }
	return true;
}
</script>

<!--- this table is so the form is not 100% width. --->
<table align="center">
  <tr>
    <td>

<!--- header of the table --->
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
<tr valign=middle height=24>
	<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
	<td width=26 background="pics/header_background.gif"><img src="pics/user.gif"></td>
	<td background="pics/header_background.gif"><h2>Change Password</h2></td>
	<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfform action="index.cfm?curdoc=forms/change_password" method="post" name="my_form" onSubmit="return checkForm();">
<input type="hidden" name="submitted" value="1">

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td>

Please follow these guidlines when creating your password:<br>
<ol>
<li>Cannot re-use your existing password.</li>
<li>Must be at least 6 characters.</li>
<li>Must include both alphabetic and numeric characters.</li>
<li>Cannot be a substring of your Email.</li>
<li>Should not be easily recognizable passwords, such as your name, birth dates, or names of children.</li>
</ol>

<span class="redtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Required fields</span>
<table border=0 cellpadding=4 cellspacing=0>
    <tr>
    	<td class="label">Old Password: <span class="redtext">*</span></td>
        <td><cfinput type="password" name="old_password" value="#form.old_password#" size="20" maxlength="15" required="yes" validate="noblanks" message="Please enter the Old Password."></td>
    </tr>
    <tr>
    	<td class="label">New Password: <span class="redtext">*</span></td>
        <td><cfinput type="password" name="new_password" value="#form.new_password#" size="20" maxlength="15" required="yes" validate="noblanks" mask="EB-9999-XX-999999" message="Please enter the New Password."></td>
    </tr>
    <tr>
    	<td class="label">Verify New Password: <span class="redtext">*</span></td>
        <td><cfinput type="password" name="verify_new_password" value="#form.verify_new_password#" size="20" maxlength="15" required="yes" validate="noblanks" message="Please verify the New Password."></td>
    </tr>
</table>

	</td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr>
		<td align="right"><input name="Submit" type="image" src="pics/submit.gif" border=0></td>
	</tr>
</table>

</cfform>

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>

    </td>
  </tr>
</table>
<!--- this table is so the form is not 100% width. --->
