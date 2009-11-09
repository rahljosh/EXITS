<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Student File Document Checklist</title>
</head>
<body>

<cftransaction action="begin" isolation="serializable">
 	<cftry>
	<cfquery name="update_student" datasource="MySql">
			UPDATE smg_students
				SET other_missing_docs = '#form.other_missing_docs#'
			WHERE studentid = <cfqueryparam value="#form.studentid#" cfsqltype="cf_sql_integer">
			LIMIT 1
		</cfquery>

		<cfquery name="insert_compliance" datasource="MySql">
			INSERT INTO smg_compliance
				(studentid, hostid, application_complete, host_application, school_acceptance, confidential_visit, reference1, reference2,
				student_orientation, host_orientation, progress_reports, double_student, double_natural, double_host, double_school, compliance_notes)
			VALUES ('#form.studentid#', '#form.hostid#',
					<cfif IsDefined('form.application_complete')>1,<cfelse>0,</cfif>
					<cfif form.host_application EQ ''>null,<cfelse>#CreateODBCDate(form.host_application)#,</cfif> 
					<cfif form.school_acceptance EQ ''>null,<cfelse>#CreateODBCDate(form.school_acceptance)#,</cfif>
					<cfif form.confidential_visit EQ ''>null,<cfelse>#CreateODBCDate(form.confidential_visit)#,</cfif>
					<cfif form.reference1 EQ ''>null,<cfelse>#CreateODBCDate(form.reference1)#,</cfif>
					<cfif form.reference2 EQ ''>null,<cfelse>#CreateODBCDate(form.reference2)#,</cfif>
					<cfif form.student_orientation EQ ''>null,<cfelse>#CreateODBCDate(form.student_orientation)#,</cfif> 
					<cfif form.host_orientation EQ ''>null,<cfelse>#CreateODBCDate(form.host_orientation)#,</cfif>
					<cfif IsDefined('form.progress_reports')>1,<cfelse>0,</cfif>
					<cfif form.double_student EQ ''>null,<cfelse>#CreateODBCDate(form.double_student)#,</cfif> 
					<cfif form.double_natural EQ ''>null,<cfelse>#CreateODBCDate(form.double_natural)#,</cfif> 
					<cfif form.double_host EQ ''>null,<cfelse>#CreateODBCDate(form.double_host)#,</cfif>
					<cfif form.double_school EQ ''>null,<cfelse>#CreateODBCDate(form.double_school)#,</cfif>
					'#form.compliance_notes#' )
		</cfquery>	
		
		<cfquery name="get_complianceid" datasource="MySql">
			SELECT max(complianceid) as complianceid
			FROM smg_compliance
		</cfquery>
		
		<cfoutput>
		<html>
		<head>
		<script language="JavaScript">
		<!-- 
		alert("You have successfully updated this page. Thank You.");
			location.replace("student_checklist.cfm?unqid=#form.unqid#&compid=#get_complianceid.complianceid#");
		-->
		</script>
		</head>
		</html> 
		</cfoutput>		
		
  	<cfcatch type="any">
		<cfinclude template="../forms/error_message.cfm">
	</cfcatch>
	</cftry>
</cftransaction>

</body>
</html>