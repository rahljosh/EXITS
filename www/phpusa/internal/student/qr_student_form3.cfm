<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<title>Student Information - Page 3</title>
</head>
<body>

<cftry>

<cfif NOT IsDefined('form.studentid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

	<!--- UPDATE SIBLINGS --->
	<cfif IsDefined('form.count')>
		<cfloop from="1" to="#form.count#" index="x">
			<cfif form["name" & x] NEQ ''>
				<cfquery name="insert_kids" datasource="mysql">
					UPDATE smg_student_siblings
					SET name = '#form["name" & x]#', studentid = '#form.studentid#', 
						<cfif form["birthdate" & x] is ''><cfelse>birthdate = #CreateODBCDate(form["birthdate" & x])#,</cfif>
						sex = '#form["sex" & x]#',
						liveathome = '#form["liveathome" & x]#'
					WHERE childid = '#form["childid" & x]#'
					LIMIT 1 
				</cfquery>
			</cfif>
		</cfloop>
	</cfif>
	
	<!--- NEW SIBLINGS UP TO 5 PER TIME --->
	<cfif IsDefined('form.newcount')>
		<cfloop From = "1" To = "#form.newcount#" Index = "x">
			<cfif form["newname" & x] NEQ ''>
				<cfquery name="insert_kids" datasource="mysql">
					INSERT INTO smg_student_siblings(name, studentid, <cfif form["newbirthdate" & x] is ''><cfelse>birthdate, </cfif>sex, liveathome)
					VALUES(	'#form["newname" & x]#',
							'#form.studentid#',
							<cfif form["newbirthdate" & x] is ''><cfelse>#CreateODBCDate(form["newbirthdate" & x])#,</cfif>
							'#form["newsex" & x]#',
							'#form["newliveathome" & x]#')
				</cfquery>
			</cfif>
		</cfloop>
	</cfif>

<cfquery name="get_uniqueid" datasource="mysql">
	SELECT uniqueid
	FROM smg_students
	WHERE studentid = <cfqueryparam value="#form.studentid#" cfsqltype="cf_sql_integer">
</cfquery>

<cflocation url="?curdoc=student/student_form4&unqid=#get_uniqueid.uniqueid#" addtoken="no">
<!---
<cfoutput>
<html>
<head>
<script language="JavaScript">
<!-- 
alert("You have successfully updated this student information. Thank You.");
	location.replace("?curdoc=student/student_form2&unqid=#get_uniqueid.uniqueid#");
-->
</script>
</head>
</html>
</cfoutput>
---> 		

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>

</body>
</html>