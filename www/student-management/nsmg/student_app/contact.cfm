<!----
<cftry>
---->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Email EXIT Support</title>
</head>
<body>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="../pics/students.gif"></td>
		<td class="tablecenter"><h2>Contact EXITS Support</h2></td>
		<td width="42" class="tableside"><img src="pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>

<table width="670" border=0 cellpadding=0 cellspacing=0 align="center">	
	<tr>
		<td colspan=2>Fill out the form below for technical support. Include as much information as you can in describing the problem you 
			are experiencing.  Remember, if you have questions about information that is being requested on the application please contact your 
			local representative <a href="?curdoc=support">here</a>. <br><br></td>
	</tr>
	
	<!--- WE CAN'T CREATE HELP DESK UNDER THE STUDENT'S NAME  --->
	<tr>
	<td width=10%></td>
		<td valign="top" width="80%">
		<form method="post" action="querys/insert_help_desk.cfm">
		<cfquery name="student_info" datasource="mysql">
			SELECT firstname, familylastname, email
			FROM smg_students
			WHERE studentid = #client.studentid#
		</cfquery>
		
		<cfoutput>
		
		<cfquery name="help_desk_items" datasource="mysql">
			SELECT title, text, status, helpdeskid
			FROM smg_help_desk 
			WHERE studentid = #client.studentid#
		</cfquery>
		
		<cfif help_desk_items.recordcount gt 0>
			Does this message pertain to a previous message you have submitted?<br>	If so, SELECT the question:
			<select name="previous_post">
				<option value="none">N/A</option>
				<cfloop query="help_desk_items">
				<option value=#helpdeskid#>#title#</option>
				</cfloop>
			</select><br><br>
		<cfelse>
			<input type="hidden" name="previous_post" value="none">
		</cfif>
		
		TO: Support Staff<br>
		FROM: #student_info.firstname# #student_info.familylastname# -- #student_info.email# 
		<input type="hidden" name="FROM" value="#student_info.email#"><br>
		SUBJECT: <input type="text" size=40 name="title"><br>
		MESSAGE:<br>
		<textarea rows="10" cols=80 name="text"></textarea><br><br>
	
		<input type="image" src="pics/submit.gif"><br>
		<font color="##CCCCCC" size=-1>
		Additional Information<br>
		Browser: #cgi.http_user_agent#<input type="hidden" name="browser" value=#cgi.http_user_agent#><br>
		IP: #cgi.REMOTE_ADDR# <input type="hidden" name="ip" value=#cgi.remote_addr#><br>
		</font>
		<input type="hidden" name="section" value=11>
		<input type="hidden" name="category" value="Request">
		</form>
		</cfoutput>
		</td>		
	</tr>
</table>
<br><br>

</div>

<!--- FOOTER OF TABLE --->
<cfinclude template="footer_table.cfm">
<!----
<cfcatch type="any">
	<cfinclude template="error_message.cfm">
</cfcatch>
</cftry>
---->