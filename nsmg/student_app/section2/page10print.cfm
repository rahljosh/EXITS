<cftry>

<cfif IsDefined('url.curdoc') OR IsDefined('url.path')>
	<cfset path = "">
<cfelseif IsDefined('url.exits_app')>
	<cfset path = "nsmg/student_app/">
<cfelse>
	<cfset path = "../">
</cfif>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" <cfoutput>href="#path#app.css"</cfoutput>>
	<title>Page [10] - Social Skills</title>	
</head>
<body <cfif not IsDefined('url.curdoc')>onLoad="print()"</cfif>>

<cfinclude template="../querys/get_student_info.cfm">

<cfoutput query="get_student_info">

<cfset doc = 'page10'>

<cfif not IsDefined('url.curdoc')>
<table align="center" width=90% cellpadding=0 cellspacing=0  border=0 > 
<tr><td>
</cfif>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="#path#pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="#path#pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [10] - Social Skills</h2></td>
		<cfif IsDefined('url.curdoc')>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section2/page10print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		</cfif>
		<td width="42" class="tableside"><img src="#path#pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>

<cfif IsDefined('url.curdoc')>
	<cfinclude template="../check_upl_print_file.cfm">
</cfif>

<table width="660" border=0 cellpadding=0 cellspacing=0 align="center">
	<tr><td align="center" colspan="7"><b>Pages 9 and 10 must be completed by Present English teacher</b></td></tr>
	<tr><td colspan="7">&nbsp;</td></tr>
	<tr><td valign="top"><em>Ability to express oneself</em></td>
		<td>
			<cfif app_social_skills1 is 'Excellent'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Excellent
		</td>
		<td>
			<cfif app_social_skills1 is 'Very Good'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Very Good
		</td>
		<td>
			<cfif app_social_skills1 is 'Good'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Good
		</td>
		<td>
			<cfif app_social_skills1 is 'Fair'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Fair
		</td>
		<td>
			<cfif app_social_skills1 is 'Poor'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Poor
		</td>
		<td>
			<cfif app_social_skills1 is 'Inadequate'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Inadequate
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	
	<tr><td valign="top"><em>Emotional stability and maturity</em></td>
		<td>
			<cfif app_social_skills2 is 'Excellent'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Excellent
		</td>
		<td>
			<cfif app_social_skills2 is 'Very Good'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Very Good
		</td>
		<td>
			<cfif app_social_skills2 is 'Good'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Good
		</td>
		<td>
			<cfif app_social_skills2 is 'Fair'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Fair
		</td>
		<td>
			<cfif app_social_skills2 is 'Poor'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Poor
		</td>
		<td>
			<cfif app_social_skills2 is 'Inadequate'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Inadequate
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>

	<tr><td valign="top"><em>Self-reliance and independence</em></td>
		<td>
			<cfif app_social_skills3 is 'Excellent'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Excellent
		</td>
		<td>
			<cfif app_social_skills3 is 'Very Good'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Very Good
		</td>
		<td>
			<cfif app_social_skills3 is 'Good'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Good
		</td>
		<td>
			<cfif app_social_skills3 is 'Fair'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Fair
		</td>
		<td>
			<cfif app_social_skills3 is 'Poor'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Poor
		</td>
		<td>
			<cfif app_social_skills3 is 'Inadequate'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Inadequate
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>

	<tr><td valign="top"><em>Effectiveness with people</em></td>
		<td>
			<cfif app_social_skills4 is 'Excellent'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Excellent
		</td>
		<td>
			<cfif app_social_skills4 is 'Very Good'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Very Good
		</td>
		<td>
			<cfif app_social_skills4 is 'Good'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Good
		</td>
		<td>
			<cfif app_social_skills4 is 'Fair'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Fair
		</td>
		<td>
			<cfif app_social_skills4 is 'Poor'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Poor
		</td>
		<td>
			<cfif app_social_skills4 is 'Inadequate'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Inadequate
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>

	<tr><td valign="top"><em>General knowledge</em></td>
		<td>
			<cfif app_social_skills5 is 'Excellent'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Excellent
		</td>
		<td>
			<cfif app_social_skills5 is 'Very Good'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Very Good
		</td>
		<td>
			<cfif app_social_skills5 is 'Good'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Good
		</td>
		<td>
			<cfif app_social_skills5 is 'Fair'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Fair
		</td>
		<td>
			<cfif app_social_skills5 is 'Poor'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Poor
		</td>
		<td>
			<cfif app_social_skills5 is 'Inadequate'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Inadequate
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>

	<tr><td valign="top"><em>Impression he/she will make abroad</em></td>
		<td>
			<cfif app_social_skills6 is 'Excellent'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Excellent
		</td>
		<td>
			<cfif app_social_skills6 is 'Very Good'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Very Good
		</td>
		<td>
			<cfif app_social_skills6 is 'Good'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Good
		</td>
		<td>
			<cfif app_social_skills6 is 'Fair'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Fair
		</td>
		<td>
			<cfif app_social_skills6 is 'Poor'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Poor
		</td>
		<td>
			<cfif app_social_skills6 is 'Inadequate'><img src="#path#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Inadequate
		</td>
	</tr>
</table><br>

<hr class="bar"></hr><br>

<table width="660" border="0" cellpadding="3" cellspacing="0" align="center">
	<tr><td align="center">
		<div align="justify">
		<em>Please briefly comment about this student’s motivation, reason for wanting to be an exchange student, 
		potential for success, study habits, and any other information you think will assist us in evaluating this individual.</em>
		</div>
	</td></tr>
	<tr><td align="center" height="150" valign="top"><div align="justify">#app_social_reason#</div><!--- <img src="#path#pics/line.gif" width="650" height="1" border="0" align="absmiddle"> ---></td></tr>
</table><br>

<hr class="bar"></hr><br>

<table width="660" border="0" cellpadding="3" cellspacing="0" align="center">
	<tr><td colspan="2">English Teacher's</td></tr>
	<tr><td width="315"><em>Name</em></td><td width="40">&nbsp;</td><td width="315"><!--- <em>Signature</em> ---></td></tr>
	<tr>
		<td>#app_teacher_name#<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
		<td>&nbsp;</td>
		<td><!--- <br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"> ---></td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td><em>School</em></td><td>&nbsp;</td></tr>
	<tr>
		<td colspan="3">#app_teacher_school#<br><img src="#path#pics/line.gif" width="650" height="1" border="0" align="absmiddle"></td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td><em>Address</em></td><td>&nbsp;</td><td><em>Phone Number</em></td></tr>
	<tr>
		<td>#app_teacher_address#<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
		<td>&nbsp;</td>
		<td>#app_teacher_phone#<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td><em>Date of Interview (mm/dd/yyyy)</em></td><td>&nbsp;</td><td><em>Date of Evaluation (mm/dd/yyyy)</em></td></tr>
	<tr>
		<td>#DateFormat(app_interview_date, 'mm/dd/yyyy')#<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
		<td>&nbsp;</td>
		<td>#DateFormat(app_evaluation_date, 'mm/dd/yyyy')#<br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
	</tr>
</table><br><br>

<table width="660" border=0 cellpadding=3 cellspacing=0 align="center">
	<tr><td width="315"><em>Signature of Teacher</em></td><td width="40">&nbsp;</td><td width="315"><em>Date</em></td></tr>
	<tr>
		<td><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
		<td>&nbsp;</td>
		<td><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
	</tr>
</table><br><br>

</div>

<!--- FOOTER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="8">
		<td width="8"><img src="#path#pics/p_bottonleft.gif" width="8"></td>
		<td width="100%" class="tablebotton"><img src="#path#pics/p_spacer.gif"></td>
		<td width="42"><img src="#path#pics/p_bottonright.gif" width="42"></td>
	</tr>
</table>

</cfoutput>

<cfif not IsDefined('url.curdoc')>
</td></tr>
</table>
<cfinclude template="../print_include_file.cfm">
</cfif>

</body>
</html>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>