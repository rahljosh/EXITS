<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>DELETING SCHOOL</title>
</head>

<cfif not IsDefined('url.sc')>
	Sorry, it was not possible to delete the school at this time. Please try again.
</cfif>

<cftransaction action="BEGIN" isolation="SERIALIZABLE">

	<cfquery name="search" datasource="MySql">
		SELECT php_students_in_program.schoolid,
			s.studentid, s.firstname, s.familylastname
		FROM php_students_in_program
		LEFT JOIN smg_students s ON s.studentid = php_students_in_program.studentid
		WHERE php_students_in_program.schoolid = <cfqueryparam value="#url.sc#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfif search.recordcount><br />
		<cfoutput>
		<table width=680 align="center" frame="box">
			<tr><th bgcolor="e9ecf1">DELETING SCHOOL</th></tr>
			<tr><td><br /> Sorry. It is not possible to delete school ###url.sc#.<br />
					One or more students are assigned to this school.<br /><br />
					If you would like to delete it, please re-assign the student(s) below:<br />
					<cfloop query="search">#firstname# #familylastname# (###studentid#) <br /></cfloop><br /><br />
					</td></tr>
			<tr><th bgcolor="e9ecf1"><a href="../index.cfm?curdoc=forms/view_school&sc=#url.sc#"><img src="../pics/back.gif" border="0"></a></th></tr>					
		</table>
		</cfoutput>
		<cfabort>
	</cfif>

	<cfquery name="delete_school" datasource="MySql">
		DELETE 
		FROM php_schools
		WHERE schoolid = <cfqueryparam value="#url.sc#" cfsqltype="cf_sql_integer">
		LIMIT 1
	</cfquery> 
	
	<cfquery name="delete_school_dates" datasource="MySql">
		DELETE
		FROM php_school_dates
		WHERE schoolid = <cfqueryparam value="#url.sc#" cfsqltype="cf_sql_integer">	
	</cfquery>
	
</cftransaction> 

<html>
<head>
<script language="JavaScript">
<!-- 
alert("You have successfully deleted this school.");
	location.replace("../index.cfm?curdoc=lists/schools");
//-->
</script>
</head>
</html>

<body>
</body>
</html>
