<cfset errorMessage = ''>

<!--- Process Form Submission --->
<cfif isDefined("form.submitted")>
    
	<cfif trim(form.currentPassword) EQ ''>
		<cfset errorMessage = "Please enter the Old Password.">
	<cfelseif trim(form.newPassword) EQ ''>
		<cfset errorMessage = "Please enter the New Password.">
	<cfelseif trim(form.verifyNewPassword) EQ ''>
		<cfset errorMessage = "Please verify the New Password.">
	<cfelseif trim(form.currentPassword) EQ trim(form.newPassword)>
		<cfset errorMessage = "New Password cannot be the same as Old Password.">
	<cfelseif len(trim(form.newPassword)) LT 8>
		<cfset errorMessage = "New Password must be at least 8 characters.">
	<cfelseif trim(form.newPassword) NEQ trim(form.verifyNewPassword)>
		<cfset errorMessage = "Verify New Password must be the same as New Password.">
	</cfif>
    
    <cfif errorMessage EQ ''>
		<cfset contains_alpha = 0>
        <cfset contains_numeric = 0>
        <cfloop index="i" from="1" to="#len(trim(form.newPassword))#">
        	<cfset character = mid(trim(form.newPassword), i, 1)>
            <cfif character GTE 'A' AND character LTE 'Z'>
                <cfset contains_alpha = 1>
            </cfif>
            <cfif isNumeric(character)>
                <cfset contains_numeric = 1>
            </cfif>
        </cfloop>
        <cfif not (contains_alpha AND contains_numeric)>
            <cfset errorMessage = "New Password must include both alphabetic and numeric characters.">
        </cfif>
	</cfif>
    
    <cfif errorMessage EQ ''>
        <cfinclude template="../querys/get_user.cfm">
		<cfif get_user.password NEQ trim(form.currentPassword)>
            <cfset errorMessage = "Old Password is invalid.">
		<cfelseif findNoCase(trim(form.newPassword), get_user.email)>
            <cfset errorMessage = "New Password cannot be a substring of your Email.">
        </cfif>
	</cfif>
    
    <cfif errorMessage EQ ''>
    	<cfquery name="changePassword" datasource="MySql">
        	UPDATE smg_users SET
            password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.newPassword#">,
            changepass = 0
            WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
        </cfquery>
	</cfif>
    
<cfelse>
	<cfset form.currentPassword = ''>
	<cfset form.newPassword = ''>
	<cfset form.verifyNewPassword = ''>
</cfif>

<cfif errorMessage NEQ ''>
	<script language="JavaScript">
        alert('<cfoutput>#errorMessage#</cfoutput>');
    </script>
<cfelseif errorMessage EQ '' AND IsDefined('form.submitted')>
	<cflocation url="index.cfm?curdoc=user/user_info&uniqueid=#get_user.uniqueid#">
</cfif>

<cfform action="index.cfm?curdoc=user/password_reset" method="post" name="my_form" onSubmit="return checkForm();">
<input type="hidden" name="submitted" value="1">

<table width="30%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="CCCCCC" bgcolor="f4f4f4">
	<tr>
		<td bordercolor="FFFFFF">
			<!----Header Table---->
			<table width=50% cellpadding=0 cellspacing=0 border=0 align="center" height="25" bgcolor="E4E4E4">
				<tr bgcolor="E4E4E4">
					<td class="title1">&nbsp; &nbsp; Change Password</td>
				</tr>
			</table>
			<br>
			<table width="90%" border="0" cellpadding="0" cellspacing="0" align="center" bordercolor="C7CFDC">	
                <tr>
					<td width="50%" valign="top">
						<!--- Password Reset --->
						<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF">
									<table width="100%" cellpadding=3 cellspacing=0 border=0>
                                    	<tr>
                                            Please follow these guidlines when creating your password:<br>
                                            <ol>
                                            <li>Cannot re-use your existing password.</li>
                                            <li>Must be at least 8 characters.</li>
                                            <li>Must include both alphabetic and numeric characters.</li>
                                            <li>Cannot be a substring of your Email.</li>
                                            <li>Should not be easily recognizable passwords, such as your name, birth dates, or names of children.</li>
                                            </ol>
                                        </tr>
										<tr bgcolor="C2D1EF">
											<td colspan="2" class="style2" bgcolor="8FB6C9"></td>
										</tr>
										<tr>
											<td class="style1"><b>Current Password:</b></td>
											<td class="style1"><cfinput name="currentPassword" type="password" /></td>
										</tr>
										<tr>
											<td class="style1"><b>New Password:</b></td>
											<td class="style1"><cfinput name="newPassword" type="password" /></td>
										</tr>
											<td class="style1"><b>Verify New Password:</b></td>
											<td colspan="3" class="style1"><cfinput name="verifyNewPassword" type="password" /></td>
										</tr>
									</table>
                                    <table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
										<tr>
                                    		<td align="center"><br><cfinput name="Submit" type="image" value="  save  " src="../pics/save.gif" alt="Save" border="0"></td>
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
