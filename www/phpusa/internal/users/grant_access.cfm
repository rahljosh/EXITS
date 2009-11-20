<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Grant Access</title>
</head>

<body>
<cfparam name="form.lastname" default="">
<cfparam name="form.firstname" default="">
<cfparam name="form.id" default="">
<cfparam name="form.email" default="">

<cfquery name="find_user" datasource="mysql">
	select firstname, lastname, email, phone, userid, uniqueid
	from smg_users
	where 
	<cfif form.lastname is not ''>lastname = '#form.lastname#'<cfelse>1=1</cfif>
	AND
	<Cfif form.firstname is not ''>firstname = '#form.firstname#'<cfelse>1=1</Cfif>
	AND
	<Cfif form.email is not ''>email = '#form.email#'<cfelse>1=1</Cfif>
</cfquery>

<cfoutput>
<form action="?curdoc=users/grant_access" method="post">
<TABLE cellSpacing="0" cellPadding="0" align="center" class="regContainer" border=0>
	<TR vAlign="top">
		<TD colspan=4 align="center">
			<h3>Please enter any information on the person you would like to give access to, once you have found the persons, click the "Grant Access" link to give them access to AXIS.<br><br>
			Once you click Grant Access, you will verify there information and under User Type & Access you will have an option to verify that this person should have acces to AXIS and what there access level should be. <strong><em>The 
			user will not have access until you click submit on that form. </em></strong></h3>
		</td>
		<td>&nbsp;&nbsp;&nbsp;</td>
	</tr>
	<tr><td colSpan="3" height="8"><img height=8 src="spacer.gif" width=1></td></tr>
	<tr><td class="orangeLine" colSpan="8" height="11"><img height=11 src="spacer.gif" width=1></td></tr>
	<tr>
		<td>
			<table>
				<tr>
					<td>First Name:</td>
					<td><input tpe="text" name="firstname" size=20 value="#form.firstname#"></td>
					<td rowspan=4 valign="top">
						<cfif form.lastname is '' and form.email is '' and form.id is '' and form.firstname is ''>
							Please fill in one of the items to the left and click on search.
						<cfelseif find_user.recordcount eq 0>
							No matches found, please try again. 
						<cfelse>
							<table>
								<tr>
								<cfloop query="find_user">
									<td>Name: #find_user.firstname# #find_user.lastname#<br>
										Email: #find_user.email#<br>
										Phone: #find_user.phone#<br>
										ID: #find_user.userid#<br>
										<a href="?curdoc=users/user_info&uniqueid=#find_user.uniqueid#&access=AXIS"><img src="pics/grant-acess.jpg"  border=0></a></td>
								<cfif (find_user.currentrow MOD 4 ) is 0></tr><tr></tr></cfif>
								</cfloop>
							</table>
						</cfif>
					</td>
				</tr>
				<tr>
					<td>Last Name: </td>
					<td><input tpe="text" name="lastname" size=20 value="#form.lastname#"></td>
					<td></td>
				</tr>
				<tr>
					<td> Email: </td>
					<td><input type="text" name="email" size=20 value="#form.email#"></td>
					<td></td>
				</tr>
				<tr><td></td><td><input type="submit" value="Search"></td></tr>
			</table>
		</td>
	</tr>
</table>	
</cfoutput>
</form>
<br><br> 
</body>
</html>
