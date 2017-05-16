<cfscript>
	// These are used to set the vStudentAppRelativePath directory for images nsmg/student_app/pics and uploaded files nsmg/uploadedFiles/
	// Param Variables
	param name="vStudentAppRelativePath" default="../";
	param name="vUploadedFilesRelativePath" default="../../";
	param name="URL.photos" default="1";
	
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

<cfset doc = 'page07'>

<cfif NOT LEN(URL.curdoc)>
<table align="center" width=90% cellpadding=0 cellspacing=0  border=0 > 
<tr><td>
</cfif>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="#vStudentAppRelativePath#pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="#vStudentAppRelativePath#pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [07] - School Information</h2></td>
		<cfif LEN(URL.curdoc)>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section2/page7print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		</cfif>
		<td width="42" class="tableside"><img src="#vStudentAppRelativePath#pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>

<cfif LEN(URL.curdoc)>
	<cfinclude template="../check_upl_print_file.cfm">
</cfif>

<table width="660" border="0" cellpadding="2" cellspacing="0" align="center">
	<tr><td align="center"><b>TRANSCRIPT OF GRADES</b></td></tr>
	<tr><td align="center"><b>This side is to be completed and signed by the School Administrator</b></td></tr>
	<tr><td>&nbsp;</td></tr>
</table>

<table width="660" border="0" cellpadding="2" cellspacing="0" align="center">
	<tr><td width="120"><em>School's Name</em></td>
		<td>#app_school_name#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="350" height="1" border="0" align="absmiddle"></td></tr>
	<tr><td><em>Address</em></td>
		<td>#app_school_add#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="350" height="1" border="0" align="absmiddle"></td></tr>	
	<tr><td><em>Telephone</em></td>
		<td>#app_school_phone#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="350" height="1" border="0" align="absmiddle"></td></tr>
	<tr><td><em>Public or Private</em></td>
		<td>
			<cfif app_school_type is 'Public'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> Public<cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> Public</cfif>&nbsp; &nbsp;
			<cfif app_school_type is 'Private'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> Private<cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> Private</cfif>
			<br><img src="#vStudentAppRelativePath#pics/line.gif" width="350" height="1" border="0" align="absmiddle">	
		</td>
	</tr>
	<tr><td><em>Administrator's Name</em></td>
		<td>#app_school_person#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="350" height="1" border="0" align="absmiddle"></td></tr>
	<tr><td>&nbsp;</td></tr>
</table>

<hr class="bar"></hr><br>

<table width="660" border="0" cellpadding="2" cellspacing="0" align="center">
	<tr><td colspan="4" ><b>GRADE CONVERSION CHART</b></td></tr>
	<tr><td colspan="4" ><em>Please explain your grading system.</em></td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td width="130"><em>American Grades</em></td>
		<td width="100">&nbsp;</td>
		<td width="180"><em>Country Equivalent</em></td>
		<td width="260"><em>Comments or explanations</em></td>
	</tr>		
	<tr>
		<td>Superior</td>
		<td>A+</td>
		<td>#app_grade_1#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="170" height="1" border="0" align="absmiddle"></td>
		<td>#app_grade_1_com#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="230" height="1" border="0" align="absmiddle"></td>
	</tr>
	<tr>
		<td>Excellent</td>
		<td>A</td>
		<td>#app_grade_2#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="170" height="1" border="0" align="absmiddle"></td>
		<td>#app_grade_2_com#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="230" height="1" border="0" align="absmiddle"></td>
	</tr>
	<tr>
		<td>Very Good</td>
		<td>A- or B+</td>
		<td>#app_grade_3#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="170" height="1" border="0" align="absmiddle"></td>
		<td>#app_grade_3_com#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="230" height="1" border="0" align="absmiddle"></td>		
	</tr>
	<tr>
		<td>Good</td>
		<td>B or B-</td>
		<td>#app_grade_4#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="170" height="1" border="0" align="absmiddle"></td>
		<td>#app_grade_4_com#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="230" height="1" border="0" align="absmiddle"></td>
	</tr>
	<tr>
		<td>Average</td>
		<td>C</td>
		<td>#app_grade_5#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="170" height="1" border="0" align="absmiddle"></td>
		<td>#app_grade_5_com#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="230" height="1" border="0" align="absmiddle"></td>
	</tr>
	<tr>
		<td>Sufficient</td>
		<td>C-</td>
		<td>#app_grade_6#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="170" height="1" border="0" align="absmiddle"></td>
		<td>#app_grade_6_com#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="230" height="1" border="0" align="absmiddle"></td>
	</tr>
	<tr>
		<td>Poor</td>
		<td>D</td>
		<td>#app_grade_7#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="170" height="1" border="0" align="absmiddle"></td>
		<td>#app_grade_7_com#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="230" height="1" border="0" align="absmiddle"></td>
	</tr>
	<tr>
		<td>Fail</td>
		<td>F</td>
		<td>#app_grade_8#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="170" height="1" border="0" align="absmiddle"></td>
		<td>#app_grade_8_com#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="230" height="1" border="0" align="absmiddle"></td>
	</tr>
	<tr><td>&nbsp;</td></tr>
</table>                

<table width="660" border="0" cellpadding="2" cellspacing="0" align="center">
	<tr>
        <cfif ListFind("14,15,16", get_student_info.app_indicated_program)>     
        	<!--- Canada Application --->       	
	        <td><em>What grade level will student have completed upon arrival in Canada?</em></td>
		<cfelse>
        	<!--- USA - Public High School --->
	        <td><em>What grade level will student have completed upon arrival in the USA?</em></td>
        </cfif>	
		<td>
			<!---<cfif companyID EQ 6 OR companyID EQ 14>--->
				<cfif grades is '8'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> <cfelse> <img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> </cfif>  8<sup>th</sup>
			<!---</cfif>--->
			<cfif grades is '9'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> <cfelse> <img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> </cfif>  9<sup>th</sup> 
			<cfif grades is '10'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> </cfif> 10<sup>th</sup>
			<cfif grades is '11'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> </cfif> 11<sup>th</sup>
			<cfif grades is '12'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> <cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> </cfif> 12<sup>th</sup>
			<br><img src="#vStudentAppRelativePath#pics/line.gif" width="210" height="1" border="0" align="absmiddle">
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td><em>Upon arrival, will the student have completed secondary school in his/her home country?</em></td>
		<td>
			<cfif app_completed_school is 'Yes'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> Yes<cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif>&nbsp; &nbsp;
			<cfif app_completed_school is 'No'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> No<cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<br><img src="#vStudentAppRelativePath#pics/line.gif" width="210" height="1" border="0" align="absmiddle">	
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>	
	<tr>
		<td><em>Does the student need to have his/her transcript convalidated?</em></td>
		<td>
			<cfif convalidation_needed is 'Yes'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> Yes<cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> Yes</cfif>&nbsp; &nbsp;
			<cfif convalidation_needed is 'No'><img src="#vStudentAppRelativePath#pics/RadioY.gif" width="13" height="13" border="0"> No<cfelse><img src="#vStudentAppRelativePath#pics/RadioN.gif" width="13" height="13" border="0"> No</cfif>
			<br><img src="#vStudentAppRelativePath#pics/line.gif" width="210" height="1" border="0" align="absmiddle">	
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
</table>

<table width="660" border="0" cellpadding="2" cellspacing="0" align="center">
	<tr>
		<td width="48%"><div align="justify">
				<u>Enrollment in the exchange program is primarily for a cultural exchange.
				A high school diploma or graduation is not guaranteed to any student.</u>
				Credit for academic achievements earned while abroad shall be determined solely 
				by the student's native school upon the completion of the program. While the
				program cannot guarantee specific courses will be available for this student, 
				please list any	courses you recommend this student be enrolled in while partipating
				in the exchange program, especially for those who need to convalidate their grades.</div>
		</td>
		<td width="4%">&nbsp;</td>
		<td width="48%" valign="top">#app_extra_courses#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="300" height="1" border="0" align="absmiddle"></td>
	</tr>
</table><br>

<table width="660" border="0" cellpadding="2" cellspacing="0" align="center">
	<tr>
		<td width="155"><em>Administrator's Name:</em></td>
		<td width="160"><br><img src="#vStudentAppRelativePath#pics/line.gif" width="185" height="1" border="0" align="absmiddle"></td>
		<td width="40">&nbsp;</td>
		<td width="315"><em>Official School Stamp:</em></td>
	</tr>
	<tr>
		<td><em>Administrator's Signature:</em></td>
		<td><br><img src="#vStudentAppRelativePath#pics/line.gif" width="185" height="1" border="0" align="absmiddle"></td>
		<td colspan="2">&nbsp;</td>
	</tr>
</table>
<table width="660" border=0 cellpadding=3 cellspacing=0 align="center">
	<tr>
		<td width="45"><em>Date:</em></td>
		<td width="270"><br><img src="#vStudentAppRelativePath#pics/line.gif" width="150" height="1" border="0" align="absmiddle"></td>
		<td width="315">&nbsp;</td>
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

<cfif NOT LEN(URL.curdoc) AND VAL(URL.photos)>
</td></tr>
</table>
<cfinclude template="../print_include_file.cfm">
</cfif>

</body>
</html>