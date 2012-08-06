<!--- This is used to set the relative directory, print_application.cfm sets this to an empty string --->
<cfparam name="relative" default="../">
<cfif LEN(URL.curdoc)>
	<cfset relative = "">
</cfif>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" <cfoutput>href="#relative#app.css"</cfoutput>>
</head>
<body <cfif NOT LEN(URL.curdoc)>onLoad="print()"</cfif>>

<cfinclude template="../querys/get_student_info.cfm">

<cfset doc = 'page19'>

<cfoutput query="get_student_info">

<cfif NOT LEN(URL.curdoc)>
<table align="center" width=90% cellpadding=0 cellspacing=0  border=0 > 
<tr><td>
</cfif>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="#relative#pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="#relative#pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [19] - Personal Interview & English Fluency Assessment</h2></td>
		<cfif LEN(URL.curdoc)>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section4/page19print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		</cfif>
		<td width="42" class="tableside"><img src="#relative#pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>

<cfif LEN(URL.curdoc)>
	<cfinclude template="../check_uploaded_file.cfm">
</cfif>

<table width="660" border=0 cellpadding=2 cellspacing=0 align="center">
	<tr><td><div align="justify">Please complete this section indicating level of student's English comprehension and communication.
			This form should be completed after the mandatory ten (10) minute English language interview is conducted. No other comments should be
			included other than notes about the oral interview.</div></td></tr>	
</table><br><br>

<table width="660" border=0 cellpadding=1 cellspacing=0 align="center">
	<tr>
		<td width="110"><em>Student's Name</em></td>
		<td width="560">#get_student_info.firstname# #get_student_info.familylastname#<br><img src="#relative#pics/line.gif" width="520" height="1" border="0" align="absmiddle"></td>
	</tr>
</table><br>

<table width="660" border=0 cellpadding=2 cellspacing=0 align="center">
	<tr><td valign="top"><em>In my estimation, this student understands and speaks English at the following level:</em></td></tr>
	<tr><td><cfif app_interview_english_level is 'Excellent'><img src="#relative#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#relative#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Excellent
		</td>
	</tr>
	<tr><td><cfif app_interview_english_level is 'Advanced'><img src="#relative#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#relative#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Advanced
		</td>
	</tr>
	<tr><td><cfif app_interview_english_level is 'Intermediate'><img src="#relative#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#relative#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Intermediate
		</td>
	</tr>
	<tr><td><cfif app_interview_english_level is 'Advanced Beginner'><img src="#relative#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#relative#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Advanced Beginner
		</td>
	</tr>
	<tr><td><cfif app_interview_english_level is 'Beginner'><img src="#relative#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#relative#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Beginner
		</td>
	</tr>
</table><br>

<hr class="bar"></hr><br>
<table width="660" border=0 cellpadding=2 cellspacing=0 align="center">
	<tr><td align="center" height="100" valign="top">
		<div align="justify"><em>Please note student's strengths and weaknesses with spoken English: </em></div>
	</td></tr>
	<tr><td align="center" valign="top"><div align="justify">#app_interview_strengths#<br><img src="#relative#pics/line.gif" width="650" height="1" border="0" align="absmiddle"></div></td></tr>
</table><br>

<table width="660" border=0 cellpadding=3 cellspacing=0 align="center">
	<tr><td align="center" height="100" valign="top">
		<cfif ListFind("14,15,16", get_student_info.app_indicated_program)>            	
            <!--- Canada Agreement --->
            <div align="justify"><em>Please note any other factors that could affect student's ability to communicate in English after his/her arrival in Canada: </em></div>	        
        <cfelse>
            <!--- Public High School Agreement --->
            <div align="justify"><em>Please note any other factors that could affect student's ability to communicate in English after his/her arrival in the United States: </em></div>	        
        </cfif>            
	</td></tr>
	<tr><td align="center" valign="top"><div align="justify">#app_interview_other#<br><img src="#relative#pics/line.gif" width="650" height="1" border="0" align="absmiddle"></div></td></tr>
</table><br>

<hr class="bar"></hr><br>
<table width="660" border=0 cellpadding=2 cellspacing=0 align="center">
	<tr><td colspan="2"><em>Interview conducted by:</em></td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td width="315"><em>Name</em></td><td width="40">&nbsp;</td><td width="315"><em>Signature</em></td></tr>
	<tr>
		<td><br><img src="#relative#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
		<td>&nbsp;</td>
		<td><br><img src="#relative#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td colspan="2"><em>Approved by the International Agent:</em></td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td width="315"><em>Name</em></td><td width="40">&nbsp;</td><td width="315"><em>Date</em></td></tr>
	<tr>
		<td><br><img src="#relative#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
		<td>&nbsp;</td>
		<td><br><img src="#relative#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
	</tr>	
</table><br>

</div>

<!--- FOOTER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="8">
		<td width="8"><img src="#relative#pics/p_bottonleft.gif" width="8"></td>
		<td width="100%" class="tablebotton"><img src="#relative#pics/p_spacer.gif"></td>
		<td width="42"><img src="#relative#pics/p_bottonright.gif" width="42"></td>
	</tr>
</table>

</cfoutput>

<cfif NOT LEN(URL.curdoc)>
</td></tr>
</table>
<cfinclude template="../print_include_file.cfm">
</cfif>

</body>
</html>