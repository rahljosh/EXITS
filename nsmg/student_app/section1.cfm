<cftry>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Student Application Section</title>
</head>
<body>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="../pics/students.gif"></td>
		<td class="tablecenter"><h2>Student Application Section</h2></td>
		<td width="42" class="tableside"><img src="pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>

<table width="670" border=0 cellpadding=0 cellspacing=0 align="center">	
	<tr>
		<td><br><br>
			<div align="justify">
			The <b>Student Application</b> section contains six (6) pages.  
			It is one of the most important sections to assist the American organization in finding a host family for you.
			Pages [01], [02] and [03] must be filled out with your personal information, interests, experiences and preferences.
			Page [04] is photo album that allows you to upload up to ten (10) pictures.  
			Pages [05] and [06] require you and your parents to submit a letter.  
			Letters can be typed into the application pages or a printed letter can also be uploaded.
			</div>
			<br><br>
		</td>
	</tr>
</table>
</div>

<table width=100% border=0 cellpadding=0 cellspacing=0 class="section" align="center">
	<tr>
		<td align="center" valign="bottom" class="buttontop">
			<a href="index.cfm?curdoc=section1/page1&id=1&p=1"><img src="pics/next.gif" border="0"></a>
		</td>
	</tr>
</table>

<!--- FOOTER OF TABLE --->
<cfinclude template="footer_table.cfm">

<cfcatch type="any">
	<cfinclude template="error_message.cfm">
</cfcatch>
</cftry>