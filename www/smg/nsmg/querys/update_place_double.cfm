<link rel="stylesheet" href="../smg.css" type="text/css">

<!--- Student Info --->
<cfinclude template="../querys/get_student_info.cfm">

<cfif form.double_place EQ 'none'>
	<!--- include template page header --->
	<cfinclude template="../forms/placement_status_header.cfm">
	<table width="480" align="center">
	<tr><td align="center"><h3>No Student was selected. Please go back and make sure you select a student.</h3></td></tr>
	</table>
	<br>
	<table width="480" align="center">
	<tr><td align="center">
			<input type="image" value="close window" src="../pics/back.gif" onClick="javascript:history.back()">
		</td></tr>
	</table>
<cfabort>
</cfif>

<cfif IsDefined('form.reason') AND form.reason EQ ''>
	<!--- include template page header --->
	<cfinclude template="../forms/placement_status_header.cfm">
	<table width="480" align="center">
	<tr><td align="center"><h3>Please enter a reason in order to continue.</h3></td></tr>
	</table>
	<br>
	<table width="480" align="center">
	<tr><td align="center">
			<input type="image" value="close window" src="../pics/back.gif" onClick="javascript:history.back()">
		</td></tr>
	</table>
<cfabort>
</cfif>

<cftransaction action="BEGIN" isolation="SERIALIZABLE">

<!--- CREATE DOC HISTORY AND CLEAN UP DOCUMENTS --->
<cfquery name="get_student_info" datasource="MySql">
	SELECT studentid, doubleplace, dblplace_doc_stu, dblplace_doc_fam, dblplace_doc_host, dblplace_doc_school, dblplace_doc_dpt
	FROM smg_students
	WHERE studentid = '#form.studentid#'
</cfquery>	

<!--- UPDATING DOUBLE PLACEMENT --->
<cfif get_student_info.doubleplace NEQ 0>
	<cfquery name="create_history" datasource="MySql">
		INSERT INTO smg_doubleplace_history
			(studentid, doubleplaceid, userid, date_change, reason, doc_student, doc_naturalfamily, doc_hostfamily, doc_school, doc_dpt)
		VALUES
			('#get_student_info.studentid#', '#get_student_info.doubleplace#', '#client.userid#', #CreateODBCDate(now())#, 
			 '#form.reason#', 
			 <cfif get_student_info.dblplace_doc_stu NEQ ''>#CreateODBCDate(get_student_info.dblplace_doc_stu)#<cfelse>NULL</cfif>, 
			 <cfif get_student_info.dblplace_doc_fam NEQ ''>#CreateODBCDate(get_student_info.dblplace_doc_fam)#<cfelse>NULL</cfif>, 
			 <cfif get_student_info.dblplace_doc_host NEQ ''>#CreateODBCDate(get_student_info.dblplace_doc_host)#<cfelse>NULL</cfif>, 
			 <cfif get_student_info.dblplace_doc_school NEQ ''>#CreateODBCDate(get_student_info.dblplace_doc_school)#<cfelse>NULL</cfif>, 
			 <cfif get_student_info.dblplace_doc_dpt NEQ ''>#CreateODBCDate(get_student_info.dblplace_doc_dpt)#<cfelse>NULL</cfif>) 
	</cfquery>
</cfif>

<cfquery name="update_double" datasource="MySql">
	UPDATE smg_students
	SET doubleplace = '#form.double_place#',
		dblplace_doc_stu = NULL,
		dblplace_doc_fam = NULL,
		dblplace_doc_host = NULL,
		dblplace_doc_school = NULL,
		dblplace_doc_dpt  = NULL
	WHERE studentid = '#form.studentid#'
	LIMIT 1
</cfquery>

</cftransaction>
<cflocation url="../forms/place_double.cfm">