<cftry>

<cfif LEN(URL.curdoc) OR IsDefined('url.path')>
	<cfset path = "">
<cfelse>
	<cfset path = "../">
</cfif>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" <cfoutput>href="#path#app.css"</cfoutput>>
	<title>Page [07] - School Information</title>
	<style type="text/css">
	<!--
	body {
		margin-left: 0.3in;
		margin-top: 0.3in;
		margin-right: 0.3in;
		margin-bottom: 0.3in;
	}
	-->
	</style>		
</head>
<body <cfif NOT LEN(URL.curdoc)>onLoad="print()"</cfif>>

<cfif NOT LEN(URL.curdoc)>
<table align="center" width=90% cellpadding=0 cellspacing=0  border=0 > 
<tr><td>&nbsp;</td></tr>
<tr><td>
</cfif>

<cfoutput>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="#path#pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="#path#pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [07] - School Information</h2></td>
		<cfif LEN(URL.curdoc)>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section2/page7printblank.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="#path#pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		</cfif>
        <td  class="tablecenter"><cfinclude template="../datestamp.cfm"></td>
		<td width="42" class="tableside"><img src="#path#pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>
<table width="670" border="0" cellpadding="2" cellspacing="0" align="center">
	<tr><td align="center"><b>TRANSCRIPT OF GRADES</b></td></tr>
	<tr><td align="center"><b>This side is to be completed and signed by the School Administrator</b></td></tr>
	<tr><td>&nbsp;</td></tr>
</table>

<table width="670" border="0" cellpadding="2" cellspacing="0" align="center">
	<tr><td width="120"><em>School's Name</em></td>
		<td><br><img src="#path#pics/line.gif" width="350" height="1" border="0" align="absmiddle"></td></tr>
	<tr><td><em>Address</em></td>
		<td><br><img src="#path#pics/line.gif" width="350" height="1" border="0" align="absmiddle"></td></tr>	
	<tr><td><em>Telephone</em></td>
		<td><br><img src="#path#pics/line.gif" width="350" height="1" border="0" align="absmiddle"></td></tr>
	<tr><td><em>Public or Private</em></td>
		<td>
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Public &nbsp; &nbsp;
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Private
			<br><img src="#path#pics/line.gif" width="350" height="1" border="0" align="absmiddle">	
		</td>
	</tr>
	<tr><td><em>Administrator's Name</em></td>
		<td><br><img src="#path#pics/line.gif" width="350" height="1" border="0" align="absmiddle"></td></tr>
	<tr><td>&nbsp;</td></tr>
</table>

<hr class="bar"></hr><br>

<table width="670" border="0" cellpadding="2" cellspacing="0" align="center">
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
		<td><br><img src="#path#pics/line.gif" width="170" height="1" border="0" align="absmiddle"></td>
		<td><br><img src="#path#pics/line.gif" width="230" height="1" border="0" align="absmiddle"></td>
	</tr>
	<tr>
		<td>Excellent</td>
		<td>A</td>
		<td><br><img src="#path#pics/line.gif" width="170" height="1" border="0" align="absmiddle"></td>
		<td><br><img src="#path#pics/line.gif" width="230" height="1" border="0" align="absmiddle"></td>
	</tr>
	<tr>
		<td>Very Good</td>
		<td>A- or B+</td>
		<td><br><img src="#path#pics/line.gif" width="170" height="1" border="0" align="absmiddle"></td>
		<td><br><img src="#path#pics/line.gif" width="230" height="1" border="0" align="absmiddle"></td>		
	</tr>
	<tr>
		<td>Good</td>
		<td>B or B-</td>
		<td><br><img src="#path#pics/line.gif" width="170" height="1" border="0" align="absmiddle"></td>
		<td><br><img src="#path#pics/line.gif" width="230" height="1" border="0" align="absmiddle"></td>
	</tr>
	<tr>
		<td>Average</td>
		<td>C</td>
		<td><br><img src="#path#pics/line.gif" width="170" height="1" border="0" align="absmiddle"></td>
		<td><br><img src="#path#pics/line.gif" width="230" height="1" border="0" align="absmiddle"></td>
	</tr>
	<tr>
		<td>Sufficient</td>
		<td>C-</td>
		<td><br><img src="#path#pics/line.gif" width="170" height="1" border="0" align="absmiddle"></td>
		<td><br><img src="#path#pics/line.gif" width="230" height="1" border="0" align="absmiddle"></td>
	</tr>
	<tr>
		<td>Poor</td>
		<td>D</td>
		<td><br><img src="#path#pics/line.gif" width="170" height="1" border="0" align="absmiddle"></td>
		<td><br><img src="#path#pics/line.gif" width="230" height="1" border="0" align="absmiddle"></td>
	</tr>
	<tr>
		<td>Fail</td>
		<td>F</td>
		<td><br><img src="#path#pics/line.gif" width="170" height="1" border="0" align="absmiddle"></td>
		<td><br><img src="#path#pics/line.gif" width="230" height="1" border="0" align="absmiddle"></td>
	</tr>
	<tr><td>&nbsp;</td></tr>
</table>                

<table width="670" border="0" cellpadding="2" cellspacing="0" align="center">
	<tr>
        <cfif ListFind("14,15,16", get_student_info.app_indicated_program)>     
        	<!--- Canada Application --->       	
	        <td><em>What grade level will student have completed upon arrival in Canada?</em></td>
		<cfelse>
        	<!--- USA - Public High School --->
	        <td><em>What grade level will student have completed upon arrival in the USA?</em></td>
        </cfif>	
        <td>
			<cfif companyID EQ 6 OR companyID EQ 14>
				<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> 8<sup>th</sup> 
			</cfif>
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> 9<sup>th</sup> 
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> 10<sup>th</sup>
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> 11<sup>th</sup>
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> 12<sup>th</sup>
			<br><img src="#path#pics/line.gif" width="210" height="1" border="0" align="absmiddle">
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td><em>Upon arrival, will the student have completed secondary school in his/her home country?</em></td>
		<td>
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp; &nbsp;
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<br><img src="#path#pics/line.gif" width="210" height="1" border="0" align="absmiddle">	
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>			
	<tr>
		<td><em>Does the student need to have his/her transcript convalidated?</em></td>
		<td>
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp; &nbsp;
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<br><img src="#path#pics/line.gif" width="210" height="1" border="0" align="absmiddle">	
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
</table>

<table width="670" border="0" cellpadding="2" cellspacing="0" align="center">
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
		<td width="48%" valign="bottom" height="180" valign="bottom"><br><img src="#path#pics/line.gif" width="300" height="1" border="0" align="absmiddle"></td>
	</tr>
</table><br><br>

<table width="670" border="0" cellpadding="2" cellspacing="0" align="center">
	<tr>
		<td width="155"><em>Administrator's Name:</em></td>
		<td width="160"><br><img src="#path#pics/line.gif" width="185" height="1" border="0" align="absmiddle"></td>
		<td width="40">&nbsp;</td>
		<td width="315"><em>Official School Stamp:</em></td>
	</tr>
	<tr>
		<td><em>Administrator's Signature:</em></td>
		<td><br><img src="#path#pics/line.gif" width="185" height="1" border="0" align="absmiddle"></td>
		<td colspan="2">&nbsp;</td>
	</tr>
</table>
<table width="670" border=0 cellpadding=3 cellspacing=0 align="center">
	<tr>
		<td width="45"><em>Date:</em></td>
		<td width="270"><br><img src="#path#pics/line.gif" width="150" height="1" border="0" align="absmiddle"></td>
		<td width="315">&nbsp;</td>
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

<cfif NOT LEN(URL.curdoc)>
</td></tr>
</table>
</cfif>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</body>
</html>

</cftry>