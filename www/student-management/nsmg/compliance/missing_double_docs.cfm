<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Missing Double Placement Paperwork</title>
</head>

<body>

<link rel="stylesheet" href="../reports/reports.css" type="text/css">

<cfsetting requesttimeout="300">

<cfif not IsDefined('form.programid')>
	<cfinclude template="../forms/error_message.cfm">
</cfif>

<!--- Get Program --->
<cfquery name="get_program" datasource="MYSQL">
	SELECT	*
	FROM 	smg_programs 
	LEFT JOIN smg_program_type ON type = programtypeid
	WHERE 	(<cfloop list=#form.programid# index='prog'>
			programid = #prog# 
			<cfif prog EQ #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
</cfquery>

<cfquery name="get_students" datasource="MySql">
	SELECT s.studentid, s.countryresident, s.firstname, s.familylastname, s.dateplaced, s.hostid as stuhost, s.doubleplace, s.active,
		  c.hostid, c.double_student, c.double_natural, c.double_host, c.double_school 
	FROM smg_students s
	LEFT JOIN smg_compliance c ON s.studentid = c.studentid
	WHERE s.hostid != '0'
		AND s.doubleplace != '0'
		AND (<cfloop list="#form.programid#" index="prog">
			s.programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
		AND (c.double_student IS NULL OR c.double_natural IS NULL OR c.double_host IS NULL OR c.double_school IS NULL) 
	ORDER BY s.familylastname, s.firstname			
</cfquery>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfoutput>
<table width='100%' cellpadding=3 cellspacing="0" align="center">
	<tr><td><span class="application_section_header">#companyshort.companyshort# - Missing Compliance Double Placement Paperwork</span></td></tr>
</table><br>

<table width='100%' cellpadding=3 cellspacing="0" align="center" frame="box">
	<tr><td align="center">
		Program(s) Included in this Report:<br>
		<cfloop query="get_program"><b>#programname# &nbsp; (#ProgramID#)</b><br></cfloop><br />
		Total of #get_students.recordcount# student(s)
		</td>
	</tr>
</table><br>

<!--- table header --->
<table width='100%' frame=below cellpadding=3 cellspacing="0" align="center" frame="border">
	<tr>
		<td><b>Student</b></td>
		<td width="10%"><b>Status</b></td>
		<td width="15%"><b>Double with</b></td>
		<td width="50%"><b>Missing Double Placement Paperwork</b></td>
	</tr>	
	<cfloop query="get_students">			 
		<tr bgcolor="#iif(get_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
			<td>#firstname# #familylastname# (###studentid#)</td>
			<td><cfif active EQ 1>Active<cfelse>Inactive</cfif></td>
			<td>(###doubleplace#)</td>
			<td><font size="-2" style="font-style:italic">
				<cfif double_student EQ ''>Student &nbsp; &nbsp; &nbsp; </cfif>
				<cfif double_natural EQ ''>Natural Family &nbsp; &nbsp; &nbsp; </cfif>
				<cfif double_host EQ ''>Host Family &nbsp; &nbsp; &nbsp; </cfif>
				<cfif double_school EQ ''>School &nbsp; &nbsp; &nbsp; </cfif>
				</font>
		</tr>								
	</cfloop>			
</table><br>	

</cfoutput>

</body>
</html>
