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

<!--- querys to get 8, 9, 10, 11 and 12th years and grades --->
<cfloop from="8" to="12" index="i">
	<cfquery name="get_#i#class" datasource="#APPLICATION.DSN#">
		SELECT yearid, studentid, beg_year, end_year, class_year
		FROM smg_student_app_school_year 
		WHERE studentid = <cfqueryparam value="#get_student_info.studentid#" cfsqltype="cf_sql_integer">
			  AND class_year = '#i#th'
		ORDER BY class_year
	</cfquery>
	<cfquery name="get_#i#grades" datasource="#APPLICATION.DSN#">
		SELECT gradesid, yearid, class_name, hours, grade
		FROM smg_student_app_grades
		WHERE yearid = '#Evaluate("get_" & i & "class.yearid")#'
		ORDER BY yearid
	</cfquery>
</cfloop>

<cfoutput query="get_student_info">

<cfset doc = 'page08'>

<cfif NOT LEN(URL.curdoc)>
<table align="center" width=90% cellpadding=0 cellspacing=0  border=0 > 
<tr><td>
</cfif>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="#vStudentAppRelativePath#pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="#vStudentAppRelativePath#pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [08] - Transcript of Grades</h2></td>
		<cfif LEN(URL.curdoc)>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section2/page8print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		</cfif>
		<td width="42" class="tableside"><img src="#vStudentAppRelativePath#pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>

<cfif LEN(URL.curdoc)>
	<cfinclude template="../check_upl_print_file.cfm">
</cfif>

<table width="660" border="0" cellpadding="0" cellspacing="0" align="center">
	<tr><td align="center" colspan="3"><b>TRANSCRIPT OF GRADES continued</b></td></tr>
	<tr><td align="center" colspan="3">
		<div align="justify">
			In English type names, hours per week, and the final <b>(American-equivalent)</b> grade for the classes you attended
			in the 8<sup>th</sup>, 9<sup>th</sup>, 10<sup>th</sup>, 11<sup>th</sup> and 12<sup>th</sup> grades. Indicate the grade in which you 
			are presently enrolled. In addition to this translation, please also attach a copy of each year’s transcript of grades 
			issued by your school.
		</div>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>

	<tr>
	<td width="48%" valign="top">
	<!--- 8th grade --->
		<table border=1 cellpadding=0 cellspacing=0  bordercolor="CCCCCC" width="100%">
		<cfif get_8class.recordcount EQ 0>  <!--- year has not been entered --->
			<tr><td colspan="3"><em>&nbsp; School Year &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; to &nbsp;</em></td></tr>
		<cfelse>
			<tr><td colspan="3">
					<em>&nbsp; School Year &nbsp; 
					#DateFormat(get_8class.beg_year, 'yyyy')# 
					&nbsp; to &nbsp; 
					#DateFormat(get_8class.end_year, 'yyyy')#</em></td></tr>
		</cfif>
		<tr>
			<td align="center" style="font-size:11px;line-height:9px"><em>8<sup>th</sup> year classes</em></td>
			<td align="center" style="font-size:11px;line-height:9px"><em>Hours <br>per week</em></td>
			<td align="center" style="font-size:11px;line-height:9px"><em>Final Grade<br> (Am. Equivalent)</em></td>
		</tr>
		<cfif get_8class.recordcount NEQ 0>
			<cfloop query="get_8grades">
			<tr>
				<td align="center" style="font-size:11px;line-height:11px"> &nbsp; #class_name#</td>
				<td align="center" style="font-size:11px;line-height:11px"> &nbsp; #hours# </td>
				<td align="center" style="font-size:11px;line-height:11px"> &nbsp; #grade# </td>
			</tr>			
			</cfloop>
		</cfif>			
		<!--- NEW CLASSES UP TO 14 --->
		<cfset new8classes = 14 - get_8grades.recordcount>
			<cfloop from="1" to="#new8classes#" index="i">
			<tr>
				<td align="center" style="font-size:11px;line-height:11px">&nbsp;</td>
				<td align="center" style="font-size:11px;line-height:11px">&nbsp;</td>
				<td align="center" style="font-size:11px;line-height:11px">&nbsp;</td>
			</tr>
			</cfloop>		
		</table>	
	</td>
	
	<td width="4%">&nbsp;</td>

	<td width="48%" valign="top">
	<!--- 9th grade --->
		<table border=1 cellpadding=0 cellspacing=0  bordercolor="CCCCCC" width="100%">
		<cfif get_9class.recordcount EQ 0>  <!--- year has not been entered --->
			<tr><td colspan="3"><em>&nbsp; School Year &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; to &nbsp;</em></td></tr>
		<cfelse>
			<tr><td colspan="3">
					<em>&nbsp; School Year &nbsp; 
					#DateFormat(get_9class.beg_year, 'yyyy')# 
					&nbsp; to &nbsp; 
					#DateFormat(get_9class.end_year, 'yyyy')#</em></td></tr>
		</cfif>
		<tr>
			<td align="center" style="font-size:11px;line-height:9px"><em>9<sup>th</sup> year classes</em></td>
			<td align="center" style="font-size:11px;line-height:9px"><em>Hours <br>per week</em></td>
			<td align="center" style="font-size:11px;line-height:9px"><em>Final Grade<br> (Am. Equivalent)</em></td>
		</tr>
		<cfif get_9class.recordcount NEQ 0>
			<cfloop query="get_9grades">
			<tr>
				<td align="center" style="font-size:11px;line-height:11px"> &nbsp; #class_name#</td>
				<td align="center" style="font-size:11px;line-height:11px"> &nbsp; #hours# </td>
				<td align="center" style="font-size:11px;line-height:11px"> &nbsp; #grade# </td>
			</tr>			
			</cfloop>
		</cfif>			
		<!--- NEW CLASSES UP TO 14 --->
		<cfset new9classes = 14 - get_9grades.recordcount>
			<cfloop from="1" to="#new9classes#" index="i">
			<tr>
				<td align="center">&nbsp;</td>
				<td align="center">&nbsp;</td>
				<td align="center">&nbsp;</td>
			</tr>
			</cfloop>		
		</table>	
	</td>
</table>


<table width="660" border="0" cellpadding="0" cellspacing="0" align="center" style="margin-top:10px">
<tr>

	<td width="48%" valign="top" align="left">
	<!--- 10th grade --->
		<table border=1 cellpadding=0 cellspacing=0  bordercolor="CCCCCC" width="100%">
		<cfif get_10class.recordcount EQ 0>  <!--- year has not been entered --->
			<tr><td colspan="3"><em>&nbsp; School Year &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; to &nbsp;</em></td></tr>
		<cfelse>
			<tr><td colspan="3">
					<em>&nbsp; School Year &nbsp; 
					#DateFormat(get_10class.beg_year, 'yyyy')# 
					&nbsp; to &nbsp; 
					#DateFormat(get_10class.end_year, 'yyyy')#</em></td></tr>
		</cfif>
		<tr>
			<td align="center" style="font-size:11px;line-height:9px"><em>10<sup>th</sup> year classes</em></td>
			<td align="center" style="font-size:11px;line-height:9px"><em>Hours <br>per week</em></td>
			<td align="center" style="font-size:11px;line-height:9px"><em>Final Grade<br> (Am. Equivalent)</em></td>
		</tr>
		<cfif get_10class.recordcount NEQ 0>
			<cfloop query="get_10grades">
			<tr>
				<td align="center" style="font-size:11px;line-height:11px"> &nbsp; #class_name#</td>
				<td align="center" style="font-size:11px;line-height:11px"> &nbsp; #hours# </td>
				<td align="center" style="font-size:11px;line-height:11px"> &nbsp; #grade# </td>
			</tr>			
			</cfloop>
		</cfif>			
		<!--- NEW CLASSES UP TO 14 --->
		<cfset new10classes = 14 - get_10grades.recordcount>
			<cfloop from="1" to="#new10classes#" index="i">
			<tr>
				<td align="center">&nbsp;</td>
				<td align="center">&nbsp;</td>
				<td align="center">&nbsp;</td>
			</tr>
			</cfloop>		
		</table>	
	</td>

	<td width="4%">&nbsp;</td>

	<td width="48%" valign="top">
	<!--- 11th grade --->
		<table border=1 cellpadding=0 cellspacing=0  bordercolor="CCCCCC" width="100%">
		<cfif get_11class.recordcount EQ 0>  <!--- year has not been entered --->
			<tr><td colspan="3"><em>&nbsp; School Year &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; to &nbsp;</em></td></tr>
		<cfelse>
			<tr><td colspan="3">
					<em>&nbsp; School Year &nbsp; 
					#DateFormat(get_11class.beg_year, 'yyyy')# 
					&nbsp; to &nbsp; 
					#DateFormat(get_11class.end_year, 'yyyy')#</em></td></tr>
		</cfif>
		<tr>
			<td align="center" style="font-size:11px;line-height:9px"><em>11<sup>th</sup> year classes</em></td>
			<td align="center" style="font-size:11px;line-height:9px"><em>Hours <br>per week</em></td>
			<td align="center" style="font-size:11px;line-height:9px"><em>Final Grade<br> (Am. Equivalent)</em></td>
		</tr>
		<cfif get_11class.recordcount NEQ 0>
			<cfloop query="get_11grades">
			<tr>
				<td align="center" style="font-size:11px;line-height:11px"> &nbsp; #class_name#</td>
				<td align="center" style="font-size:11px;line-height:11px"> &nbsp; #hours# </td>
				<td align="center" style="font-size:11px;line-height:11px"> &nbsp; #grade# </td>
			</tr>			
			</cfloop>
		</cfif>			
		<!--- NEW CLASSES UP TO 14 --->
		<cfset new11classes = 14 - get_11grades.recordcount>
			<cfloop from="1" to="#new11classes#" index="i">
			<tr>
				<td align="center">&nbsp;</td>
				<td align="center">&nbsp;</td>
				<td align="center">&nbsp;</td>
			</tr>
			</cfloop>		
		</table>	
	</td>
	
	
</tr>
</table>



<table width="660" border="0" cellpadding="0" cellspacing="0" align="center" style="margin-top:10px">
<tr>	
	<td width="48%" valign="top" align="left">
	<!--- 12th grade --->
		<table border=1 cellpadding=0 cellspacing=0  bordercolor="CCCCCC" width="100%">
		<cfif get_12class.recordcount EQ 0>  <!--- year has not been entered --->
			<tr><td colspan="3"><em>&nbsp; School Year &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; to &nbsp;</em></td></tr>
		<cfelse>
			<tr><td colspan="3">
					<em>&nbsp; School Year &nbsp; 
					#DateFormat(get_12class.beg_year, 'yyyy')# 
					&nbsp; to &nbsp; 
					#DateFormat(get_12class.end_year, 'yyyy')#</em></td></tr>
		</cfif>
		<tr>
			<td align="center" style="font-size:11px;line-height:9px"><em>12<sup>th</sup> year classes</em></td>
			<td align="center" style="font-size:11px;line-height:9px"><em>Hours <br>per week</em></td>
			<td align="center" style="font-size:11px;line-height:9px"><em>Final Grade<br> (Am. Equivalent)</em></td>
		</tr>
		<cfif get_12class.recordcount NEQ 0>
			<cfloop query="get_12grades">
			<tr>
				<td align="center" style="font-size:11px;line-height:11px"> &nbsp; #class_name#</td>
				<td align="center" style="font-size:11px;line-height:11px"> &nbsp; #hours# </td>
				<td align="center" style="font-size:11px;line-height:11px"> &nbsp; #grade# </td>
			</tr>			
			</cfloop>
		</cfif>			
		<!--- NEW CLASSES UP TO 14 --->
		<cfset new12classes = 14 - get_12grades.recordcount>
			<cfloop from="1" to="#new12classes#" index="i">
			<tr>
				<td align="center">&nbsp;</td>
				<td align="center">&nbsp;</td>
				<td align="center">&nbsp;</td>
			</tr>
			</cfloop>		
		</table>	
	</td>
	<td width="4%" valign="top" align="left">&nbsp;</td>
	<td width="48%" valign="top" align="left">&nbsp;</td>
</tr>
</table><br>

<table width="660" border="0" cellpadding="0" cellspacing="0" align="center">
	<tr>
		<td align="center">
			Please attach a copy of each year's transcript of grades.
		</td>
	</tr>	
	<tr>
		<td align="center">
			Students must bring an official transcript with them for scheduling purposes in the American School. <br>
			All documents must be translated into English.
		</td>
	</tr>
</table>

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