<link href="../menu.css" rel="stylesheet" type="text/css">
<body link="#000000">
<cfif not isDefined('url.placed')>
	<cfset url.placed = 'no'>
</cfif>
<cfquery name="students" datasource="mysql">
select students.firstname, students.familylastname, students.sex, students.country, students.primarysport, students.studentid, 
students.programid, countrylist.countryname, sports.name as primarysportname, programs.programname, students.dateapplication,
users.businessname
from smg_students
LEFT JOIN smg_countrylist ON smg_countrylist.countryid = smg_students.country  
LEFT JOIN smg_sports ON smg_sports.sportid = smg_students.primarysport  
LEFT JOIN smg_programs ON smg_programs.programid = smg_students.programid  
LEFT JOIN smg_users on smg_users.userid = smg_students.intrep
where smg_students.active = 1
</cfquery>
<table width=100% cellpadding=0 cellspacing=0 border=0 align="center">
	<tr valign=middle height=24>
		
		<td bgcolor="#e9ecf1"><h2 align="center">S t u d e n t s</h2></td>
		<td bgcolor="#e9ecf1" align="right" valign="top">
		<cfoutput>#students.recordcount# student<cfif students.recordcount eq 1><cfelse>s</cfif> found</cfoutput><br>
		
	  </td></td>
		
	</tr>
</table>
<table border=0 cellpadding=4 cellspacing=0 class="section" align="center" width=95% background="../images/back_menu.gif">
	<tr>
	<cfoutput>
		<td width=30><a href="?curdoc=lists/students&student_order=studentid" class="menu">ID</a></td>
		<td width=100><a href="?curdoc=lists/students&student_order=firstname" class="menu">First Name</a></td>
		<td width=100><a href="?curdoc=lists/students&student_order=familylastname" class="menu">Last Name</a></td>
		<td width=40><a href="?curdoc=lists/students&student_order=sex" class="menu">Sex</a></td>
		<td width=120><a href="?curdoc=lists/students&student_order=country" class="menu">Country</a></td>
		<td width=100><a href="?curdoc=lists/students&student_order=primarysport" class="menu">Primary Sport</a></td>
		<td width=60><a href="?curdoc=lists/students&student_order=programid" class="menu">Program</a></td>
		<td width=60><u  class="menu">Agent</u></td>
		<td width=60><u  class="menu">Date Input</u></td>
</cfoutput>
  </tr>
<cfoutput query="students">
	<cfif students.currentrow mod 2>
		<tr bgcolor=##ffffff>
	<cfelse>
		<tr>
	</cfif>
		<td>#studentid#</td>
		<td>#firstname#</td>
		<td>#familylastname#</td>
		<td>#sex#</td>
		<td>#countryname#</td>
		<td>#primarysportname#</td>
		<td>#programname#</td>
		<td>#businessname#</td>
		<td>#DateFormat(dateapplication, 'mm/dd/yyyy')#</td>

	</tr>
</cfoutput>

</table>
<br><br><br>
<table width=100% cellpadding=0 cellspacing=0 border=0 align="center">
	<tr valign=middle height=24>
		
		<td bgcolor="#e9ecf1" align="center"><img src="http://www.exitgroup.org/logo/exits_small.gif"> </td>
		
		
			</td></td>
		
	</tr>
</table>
<br>
