<cfif not isDefined('url.placed')>
	<cfset url.placed = 'no'>
</cfif>

<cfif NOT IsDefined('url.order')>
	<cfset url.order = 'studentid'>
</cfif>

<cfquery name="students" datasource="mysql">
	SELECT students.firstname, students.familylastname, students.notes, students.sex, students.country, students.primarysport, students.studentid, 
		students.programid, countrylist.countryname, sports.name as primarysportname, programs.programname,
		u.businessname
	FROM smg_students
	LEFT JOIN smg_countrylist ON smg_countrylist.countryid = smg_students.country  
	LEFT JOIN smg_sports ON smg_sports.sportid = smg_students.primarysport  
	LEFT JOIN smg_programs ON smg_programs.programid = smg_students.programid 
	LEFT JOIN smg_users u on u.userid = smg_students.intrep 
	WHERE students.active = <cfif isdefined('url.inactive')>0<cfelse>1</cfif>
	ORDER BY #url.order#
</cfquery>
<cfoutput>
<h2>All Active Students</h2>
<table cellpadding=4 cellspacing=0>
	<Tr>
<cfloop query="students">
	<tr bgcolor="#iif(students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
		<td><A href="?curdoc=forms/student_info&studentid=#studentid#">#studentid#</td>
		<td><A href="?curdoc=forms/student_info&studentid=#studentid#">#firstname#</td>
		<td><A href="?curdoc=forms/student_info&studentid=#studentid#">#familylastname#</td>
		<td>#sex#</td>
		<td>#countryname#</td>
		<td>#primarysportname#</td>
		<td>#programname#</td>
		<td>#businessname#</td>
	</tr>
	<tr bgcolor="#iif(students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
		<td colspan=8>Notes:<br>#notes#<br>
		<hr width=80%>
		
		</td>
	</tr>
</cfloop>
</table>
</cfoutput>