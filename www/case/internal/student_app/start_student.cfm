<cfif isDefined('url.r')>
<cfelse>
	<cfset url.r = 'n'>
</cfif>

<script type="text/javascript" language="JavaScript">
<!--
function checkEmail() {
    if (start_student.email1.value != start_student.email2.value)
    {
        alert('The email addresses you have entered do not match. \n Please re-check and submit again.');
        return false;
    } else {
        return true;
    }
}
//-->
</script> 

<cfquery name="app_programs" datasource="caseusa">
	SELECT app_programid, app_program 
	FROM smg_student_app_programs
	WHERE app_type = 'regular'
</cfquery>
 
<cfquery name="app_other_programs" datasource="caseusa">
	SELECT app_programid, app_program 
	FROM smg_student_app_programs
	WHERE app_type = 'additional'
</cfquery> 

<cfquery name="intl_rep" datasource="caseusa">
	SELECT userid, intrepid, usertype
	FROM smg_users
	WHERE userid = '#client.userid#' 
</cfquery>

<cfif intl_rep.usertype EQ '11'> 
	<!--- BRANCH --->
	<cfquery name="get_intl_country" datasource="caseusa">
		SELECT userid, intrepid, country, continent
		FROM smg_users
		LEFT JOIN smg_countrylist ON smg_countrylist.countryid = smg_users.country
		WHERE userid = '#intl_rep.intrepid#' 
	</cfquery>
<cfelse> 
	<!--- Main Office --->
	<cfquery name="get_intl_country" datasource="caseusa">
		SELECT userid, intrepid, country, continent
		FROM smg_users
		LEFT JOIN smg_countrylist ON smg_countrylist.countryid = smg_users.country
		WHERE userid = '#intl_rep.userid#' 
	</cfquery>
</cfif>

<!--- deadlines --->
<!--- 10 month and 1st semester programs - 04/15 ASIANS - 05/01 NON ASIANS --->
<!--- 12 month and 2nd semester programs --->

<!---
<cfif get_intl_country.continent EQ 'asia'>
	<cfset deadline = '04/15/07 23:59:59'>
<cfelse>
	<cfset deadline = '05/01/07 23:59:59'>
</cfif>
--->

<!--- DEFAULT APPLICATION DAYS --->
<cfset appdays = 15> 
<cfset remainingdays = 15>

<!---
<cfset maxdeadline = #DateDiff('d', now(), deadline)#>
<cfif maxdeadline LT appdays>
	<cfset appdays = maxdeadline>
</cfif>
<cfset remainingdays = maxdeadline - appdays> 
--->

<!---Aplicant Information---->
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/news.gif"></td>
		<td background="pics/header_background.gif"><h2>Applicant Information </td><td background="pics/header_background.gif" width=16></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>
<cfform name="start_student" action="student_app/querys/start_student.cfm?r=#url.r#" method="post">

<cfoutput>
<table width="100%" border=0 cellpadding=2 cellspacing=0 align="center" class="section">	
	<tr>
		<td width="2%">&nbsp;</td>
		<td colspan=3>
			<cfif url.r is 'y'>
			Please enter the basic information to create the students application.  This basic information is needed to set up the 
			next screens where you will fill out the remainder of the students application. <br><br>
			<strong> The student will not receive an automated email with account information.</strong><br><br>
			Once you have completed the complete online application, you will have the option to notify the student by email
			that their application has been submitted.  Students will need this account info if you want them to have access to 
			their host family profile after they have been placed.
			<br><br>
			<cfelse>
			To start a students application, please fill out the following.  An email will be sent to the student
			providing them a link to create an account and fill out an applilcation.  The student will have 30 days to 'activate'
			their account. After that time, the account will expire and you will need to re-create an account for them to submit an application. <br><br>
			You can always see the status of incoming apps under 'Incoming Apps' on your welcome page.   
			<br><br>
			</cfif>
		</td>
		<td width="2%">&nbsp;</td>
	</tr>
	<tr><td>&nbsp;</td><td colspan="3"><b>Student Information</b></td><td>&nbsp;</td></tr>
	<tr>
		<td>&nbsp;</td>
		<td><em>Family Name</em></td>
		<td><em>First Name</em></td>
		<td><em>Middle Name</em></td>	
		<td>&nbsp;</td>	
	</tr>

	<tr>
		<td>&nbsp;</td>
		<td valign="top"><cfinput type="text" name="familylastname" size="25" required="yes" message="Family name is required."></td>
		<td valign="top"><cfinput type="text" name="firstname" size="25" required="yes" message="First name is required."></td>
		<td valign="top"><cfinput type="text" name="middlename" size="25"></td>
		<td>&nbsp;</td>
	</tr>
		<cfif url.r is 'n'>
	<tr>
		<td>&nbsp;</td>
		<td><em>Email Address &nbsp; <font color="000099">* Username</font></td>
		<td><em>Confirm Email Address</td>
		<td><em>Phone Number</em></td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td><cfinput type="text" name="email1" size=30 required="yes" message="Email address is required."></td>
		<td><cfinput type="text" name="email2" size=30 required="yes" message="Confirmation email address is required."></td>
		<td><cfinput type="text" name="phone" size=30></td>
		<td>&nbsp;</td>
	</tr>
	</cfif>
	<tr><td colspan="3">&nbsp;</td></tr>
	<tr><td>&nbsp;</td><td colspan="3"><b>Program Information</b></td><td>&nbsp;</td></tr>
	<tr>
		<td>&nbsp;</td>
		<td colspan=2><em>Select Program</em></td>
		<td><em>Additional Programs</em></td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td colspan=2>
			<cfselect name="program">
				<cfloop query="app_programs">
				<option value="#app_programid#">#app_program#</option>
				</cfloop>
			</cfselect>
		</td>
		<td>
			<cfselect name="add_program">
				<cfloop query="app_other_programs">
				<option value="#app_programid#">#app_program#</option>
				</cfloop>
			</cfselect>
		</td>
		<td>&nbsp;</td>
	</tr>
		<tr><td colspan="3">&nbsp;</td></tr>
		<tr><td >&nbsp;</td><td colspan="3"><b>Deadline</b></td><td>&nbsp;</td></tr>

	<tr>
		<td></td>
		<td colspan=3>
			<b>Current Expiration: #DateFormat(DateAdd('d','#appdays#','#now()#'), 'yyyy-mm-dd')# #TimeFormat(DateAdd('d','#appdays#','#now()#'), 'HH:mm:ss')#
			<input type="hidden" name="expiration_date" value="#DateFormat(DateAdd('d','#appdays#','#now()#'), 'yyyy-mm-dd')# #TimeFormat(DateAdd('d','#appdays#','#now()#'), 'HH:mm:ss')#"></b>
			<br>Student has #appdays# days to fill out and submit application.
			<br>Extend Deadline by:
			<cfif remainingdays GT 1>
				<select name="extdeadline">
				<cfloop index=i from=0 to="#remainingdays#" step="1">
					<option value="#i#">#i#</option>
				</cfloop>
				</select>
				days.
			<cfelse>
				You can not extend the deadline.
				<cfinput type="hidden" name="extdeadline" value="0">
			</cfif>
		</td>
		<Td></Td>
	</tr>
	<!---
	<tr><td></td>
		<td colspan=10>The system will not allow students to submit an application for approval after #deadline#.<br> Application must be submitted to SMG by #deadline# <br></td>
	</tr>
	--->
	<tr>
		<td>&nbsp;</td>
		<td colspan=3 ><cfif url.r is 'y'><br><strong>
			From this point on, you will be accessing the student application as if you are the student. 
			At any time you can click save and exit back to your regular welcome page. 
			You can also get back into the application at any time.</strong><br></cfif><br>
			<div align="center"><cfinput type="submit" name="submit" value=" Start Application Process " onClick="return checkEmail();"></div>
		</td>
		<td>&nbsp;</td>
	</tr>
</table>
</cfoutput>
</cfform>

<!----footer of table---->
<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>

</body>
</html>