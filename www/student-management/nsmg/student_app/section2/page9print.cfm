<cfscript>
	// These are used to set the vStudentAppRelativePath directory for images nsmg/student_app/pics and uploaded files nsmg/uploadedFiles/
	// Param Variables
	param name="vStudentAppRelativePath" default="../";
	param name="vUploadedFilesRelativePath" default="../../";
	
	if ( LEN(URL.curdoc) ) {
		vStudentAppRelativePath = "";
		vUploadedFilesRelativePath = "../";
	}
</cfscript>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" <cfoutput>href="#vStudentAppRelativePath#app.css"</cfoutput>>
</head>
<body <cfif NOT LEN(URL.curdoc)>onLoad="print()"</cfif>>

<cfinclude template="../querys/get_student_info.cfm">

<cfoutput query="get_student_info">

<cfset doc = 'page09'>

<cfif NOT LEN(URL.curdoc)>
<table align="center" width=90% cellpadding=0 cellspacing=0  border=0 > 
<tr><td>
</cfif>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="#vStudentAppRelativePath#pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="#vStudentAppRelativePath#pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [09] - Language Evaluation</h2></td>
		<cfif LEN(URL.curdoc)>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section2/page9print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		</cfif>
		<td width="42" class="tableside"><img src="#vStudentAppRelativePath#pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>

<cfif LEN(URL.curdoc)>
	<cfinclude template="../check_upl_print_file.cfm">
</cfif>

<table width="660" border="0" cellpadding="3" cellspacing="0" align="center">
	<tr><td align="center"><b>Pages 9 and 10 must be completed by Present English teacher</b></td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td align="center">
			<div align="justify">
			The purpose of this form is to help us evaluate this student’s reading, writing, and verbal English language skills.
			It is crucial that your evaluation be as accurate as possible. 
			<i><u>Rating a student better than his or her actual ability may result in serious problems for the student 
			and the host school.</u></i>
			We trust you will be conscientious during this interview and will complete our form carefully, 
			accurately and honestly. Thank you.
			</div>
	</td></tr>
</table><br><br>

<table width="660" border="0" cellpadding="3" cellspacing="0" align="center">
	<tr><td valign="top"><b>Reading:</b></td>
		<td colspan="2"><div align="justify"><em>When asked to read aloud in English from a book, magazine, or newspaper, the student is able to:</em></div></td></tr>
	<tr><td>&nbsp;</td>
		<td valign="top" width="90">
			<cfif app_reading_skills is 'Excellent'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Excellent</td>
		<td><div align="justify">Read with few errors and can easily explain its meaning.</div></td></tr>
	<tr><td>&nbsp;</td>
		<td valign="top" width="90">
			<cfif app_reading_skills is 'Good'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Good</td>
		<td><div align="justify">Read well except for very difficult terms and can explain most of the ideas.</div></td></tr>
	<tr><td>&nbsp;</td>
		<td valign="top" width="90">
			<cfif app_reading_skills is 'Fair'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Fair</td>
		<td><div align="justify">Read most of the vocabulary and explain the basic idea.</div></td></tr>
	<tr><td>&nbsp;</td>
		<td valign="top" width="90">
			<cfif app_reading_skills is 'Poor'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Poor</td>
		<td><div align="justify">Read and understand only the simplest words, and can explain little or none of the meaning.</div></td></tr>	

	<tr><td>&nbsp;</td></tr>	<tr><td>&nbsp;</td></tr>
	
	<tr><td valign="top"><b>Writing:</b></td>
		<td colspan="2"><div align="justify"><em>When asked to write a short essay in English stating what he or she hopes to gain from being an 
			exchange student, the student:</em></div></td></tr>
	<tr><td>&nbsp;</td>
		<td valign="top">
			<cfif app_writing_skills is 'Excellent'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Excellent</td>
		<td><div align="justify">Writes fluently using lengthy sentences and abstract terms, with a good English vocabulary and sentence structure.</div></td></tr>
	<tr><td>&nbsp;</td>
		<td valign="top" width="90">
			<cfif app_writing_skills is 'Good'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Good</td>
		<td><div align="justify">May use irregular grammar, but uses fair vocabulary in lengthy sentences.</div> <br></td></tr>
	<tr><td>&nbsp;</td>
		<td valign="top" width="90">
			<cfif app_writing_skills is 'Fair'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Fair</td>
		<td><div align="justify">Writes only simple sentences with elementary vocabulary. Grammar is extremely irregular, but understandable.</div></td></tr>
	<tr><td>&nbsp;</td>
		<td valign="top" width="90">
			<cfif app_writing_skills is 'Poor'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Poor</td>
		<td><div align="justify">Uses very limited vocabulary and is difficult to understand.</div></td></tr>	
			
	<tr><td>&nbsp;</td></tr>	<tr><td>&nbsp;</td></tr>
	
	<tr><td valign="top"><b>Verbal:</b></td>
		<td colspan="2"><div align="justify"><em>Estimate the student’s ability to understand and speak English after engaging the student in English-only 
			conversation about current events.</em></div></td></tr>
	<tr><td>&nbsp;</td>
		<td valign="top">
			<cfif app_verbal_skills is 'Excellent'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Excellent</td>
		<td><div align="justify">Student is nearly fluent and can understand and respond to difficult questions including abstract terms. 
			Will have no problem communicating upon arrival.</div></td></tr>	
	<tr><td>&nbsp;</td>
		<td valign="top" width="90">
			<cfif app_verbal_skills is 'Good'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Good</td>
		<td><div align="justify">Student can understand most conversation. Responds slowly at times, but with appropriate answers. 
			Is inquisitive and is able to pose necessary questions correctly.</div></td></tr>
	<tr><td>&nbsp;</td>
		<td valign="top" width="90">
			<cfif app_verbal_skills is 'Fair'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Fair</td>
		<td><div align="justify">Student’s speaking ability is limited to a few basic words or phrases. Comprehension is limited. 
			Student gets frustrated and easily reverts to his/her native language.</div></td></tr>
	<tr><td>&nbsp;</td>
		<td valign="top" width="90">
			<cfif app_verbal_skills is 'Poor'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0">
			<cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"></cfif> Poor</td>
		<td><div align="justify">Student can understand basic English, but is translating. Makes mistakes, but can be understood.</div></td></tr>	

</table><br><br>


<table width="660" border=0 cellpadding=3 cellspacing=0 align="center">
	<tr><td width="315"><em>Signature of Teacher</em></td><td width="40">&nbsp;</td><td width="315"><em>Date</em></td></tr>
	<tr>
		<td><br><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
		<td>&nbsp;</td>
		<td><br><img src="#vStudentAppRelativePath#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
	</tr>
</table><br><br>
</div>

<!--- FOOTER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="8">
		<td width="8"><img src="#vStudentAppRelativePath#pics/p_bottonleft.gif" width="8"></td>
		<td width="100%" class="tablebotton"><img src="#vStudentAppRelativePath#pics/p_spacer.gif"></td>
		<td width="42"><img src="#vStudentAppRelativePath#pics/p_bottonright.gif" width="42"></td>
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