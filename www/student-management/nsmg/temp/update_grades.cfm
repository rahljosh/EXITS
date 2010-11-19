<cfquery datasource="mysql" name="into_students">
SELECT `studentid` , `soid` 
FROM `smg_students` 
WHERE `soid` LIKE CONVERT( _utf8 '%nlh%'
USING latin1 ) 
COLLATE latin1_swedish_ci
</cfquery>

<cfdump var="#into_students#">

<cfloop query="into_students">
	<cfquery name="update_years" datasource="mysql">
	update smg_student_app_school_year
	set class_year = '9th'
	where class_year = '10th' and studentid = #studentid#
	</cfquery>
		<cfquery name="update_years" datasource="mysql">
	update smg_student_app_school_year
	set class_year = '10th'
	where class_year = '11th' and studentid = #studentid#
	</cfquery>
</cfloop>