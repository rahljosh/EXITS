<style type="text/css">
body {font:Arial, Helvetica, sans-serif;}
.thin-border{ border: 1px solid #000000;
			  font:Arial, Helvetica, sans-serif;}
.dashed-border {border: 1px dashed #FF9933;}
    </style>
	
<cfif isDefined('form.randid')>
	<cfquery name="check_info" datasource="caseusa">
		SELECT email, uniqueid, randid, phone, studentid, firstname, familylastname
		FROM smg_students
		WHERE randid = '#form.randid#'
		AND email = '#form.email#'
	</cfquery>
	
	<!----If account is not verfied, display verification form with error.---->
	<cfif check_info.recordcount eq 0>
				<table align="center" width=550 class=thin-border border=0>
						<tr>
							<td colspan=2><img src="pics/top-email.gif"></td>
						</tr>
						<tr>
							<td align="center" colspan=2><h1>Account Verification</h1></td>
						</tr>
						<tr>
							<td colspan=2 valign="center" class="dashed-border"><img src="pics/error_exclamation_clear.gif" align="left" >The information you entered does not match
							the information in our system.  Please verify that you entered the correct information.  If you continue to get this 
							error, please contact the representative indicated in your email.</td>
						</tr>
						<tr>
							<td align="right" width=50%>
							<br>
					<cfoutput>
					<cfform method="post" action="verify.cfm?s=#url.s#">
					Please enter your email address: </td><td><cfinput type=text name=email size=25 message="Please enter a valid email address." validateat="onSubmit" validate="email" required="yes"></td>
						</tr>
						<tr>
							<td align="right">Your ID Number sent via email:</td><td> <cfinput type=text name=randid size = 8 message="Please enter the validation code included in your email." required="yes"></td>
						</tr>
					<tr>
						<td colspan=2 align="center"><br><cfinput name="Submit" type="image" src="pics/submit.gif" border=0 alt="Start Application"></td>
					</tr>
					</cfform>
							
					</cfoutput>
				</table><br>
				<cfabort>
				<cfelse>

<script type="text/javascript" language="JavaScript">
<!--
function checkPassword() {
    if (assign_password.password1.value != assign_password.password2.value)
    {
        alert('The passwords you have entered do not match. \n Please re-check and submit this page again.');
        return false;
    } else {
        return true;
    }
}
//-->
</script> 
				<table align="center" width=550 class=thin-border>
			<tr>
				<td colspan=2><img src="pics/top-email.gif"></td>
			</tr>
			<tr>
				<td align="center" colspan=2><h1>Account Verification</h1></td>
			</tr>
						<cfoutput query=check_info>
						<tr>
							<td colspan=2>
							<form action="student_assign_pass.cfm" method="post" name="assign_password">
							#firstname# #familylastname# your account has been verified. <br><br>
							Please enter a password below so you can access your information at a later time.  Your email address will be your username.<br><br>
						<tr>
							<td align="right" width=50%>Username:</td><td><cfoutput>#check_info.email#</cfoutput></td>
						</tr>
												<tr>
							<td align="right" width=50%>New Password:</td><td><input type="password" name="password1" size=10></td>
						</tr>
						<tr>
							<td align="right" width=50%>Verify New Password:</td><td><input type="password" name="password2" size=10></td>
						</tr>
						<tr>
							<td colspan=2 align="center"><br>
								<input name="Submit" type="image" src="pics/submit.gif" border=0 alt="Start Application" onClick="return checkPassword();">
								</form><cfset client.studentid = #check_info.studentid#></td>
							</tr>					
			
			
			</cfoutput>
			</cfif>
 				
<cfelse>	
				
	
	<table align="center" width=550 class=thin-border>
			<tr>
				<td colspan=2><img src="pics/top-email.gif"></td>
			</tr>
			<tr>
				<td align="center" colspan=2><h1>Account Verification</h1></td>
			</tr>
			

	<cfquery name="check_exist" datasource="caseusa">
	select uniqueid
	from smg_students
	where uniqueid = '#url.s#'
	</cfquery> 
	
	<cfif check_exist.recordcount eq 0>
	<tr >
							<td colspan=2 class="dashed-border">
		There is no account on record that matches the ID submitted. There are number of possabilities.<br>
		1) It has been more then 30 days since you account was accessed.  <br>
		2) If you clicked on a link from an email program, the link had a line break in it.  Please double check your
		email and if necessary, copy and paste the entire URL into your browser.<br>
		3) The ID is invalid and an account will need to be set up through your International Agent.<br>
				</td>
						</tr>
	
	<cfelse>
	
			<tr>
				<td align="right" width=50%>
		<cfoutput>
		<cfform method="post" action="verify.cfm?s=#url.s#">
		Please enter your email address: </td><td><cfinput type=text name=email size=25 message="Please enter a valid email address." validateat="onSubmit" validate="email" required="yes"></td>
			</tr>
			<tr>
				<td align="right">Your ID Number sent via email:</td><td> <cfinput type=text name=randid size = 8 message="Please enter the validation code included in your email." required="yes"></td>
			</tr>
		<tr>
			<td colspan=2 align="center"><br><cfinput name="Submit" type="image" src="pics/submit.gif" border=0 alt="Start Application"></td>
		</tr>
		
		</cfform>
				
		</cfoutput>
	</cfif>
	</table><br>

</cfif>