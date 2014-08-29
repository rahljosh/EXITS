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
<cfif isDefined('url.uniqueid')>
	<cfquery name="get_stu_id3" datasource="#APPLICATION.DSN#">
    select studentid 
    from smg_students
    where uniqueid = '#url.uniqueid#'
    </cfquery>
    <cfset client.studentid = #get_stu_id3.studentid#>
</cfif>
<cfif IsDefined('url.studentid')>
	<cfset client.studentid = '#url.studentid#'>
</cfif>

<cfinclude template="../querys/get_student_info.cfm">

<cfset doc = 'students'>

<cfoutput query="get_student_info">

<cfif NOT LEN(URL.curdoc)>
<table align="center" width=90% cellpadding=0 cellspacing=0  border=0 > 
<tr><td>
</cfif>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="#vStudentAppRelativePath#pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="#vStudentAppRelativePath#pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [05] - Student Letter of Introduction</h2></td>
		<cfif LEN(URL.curdoc)>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section1/page5print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		</cfif>
		<td width="42" class="tableside"><img src="#vStudentAppRelativePath#pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>

<!--- show print page instead of regular page --->
<cfif LEN(URL.curdoc)>
	<cfinclude template="../check_upl_print_letter.cfm">
</cfif>

<table width="660" border="0" cellpadding="1" cellspacing="0" align="center">	
	<tr><td width="5">&nbsp;</td>
		<td><em>In your own words write a letter that will tell about your personal interests. Your letter should be <b>typed in English.</b><br>
				Include comments about you and your hopes and expectations for your stay.
				Describe how you will share your culture. Tell us about your natural family as well as your personality, hobbies and interests.</em></td>
		<td width="5">&nbsp;</td></tr>
	<tr><td colspan="3">&nbsp;</td></tr>
    <cfif LEN(get_student_info.letter)>
        <tr>
            <td width="5">&nbsp;</td>
            <td width="660"><div align="justify" style="width:600px;">#get_student_info.letter#<br><img src="#vStudentAppRelativePath#pics/line.gif" width="650" height="1" border="0" align="absmiddle"></div></td>
            <td width="5">&nbsp;</td>
        </tr>
  	</cfif>
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
<cfinclude template="../print_include_letter.cfm">
</cfif>

</body>
</html>