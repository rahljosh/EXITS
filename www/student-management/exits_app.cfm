<cftry>

<cfsetting requesttimeout="500">

<!--- Param URL Variables --->
<cfparam name="URL.unqID" default="">
<cfparam name="URL.curdoc" default="">

<cfscript>
	vStudentAppRelativePath = "/nsmg/student_app/";
	vUploadedFilesRelativePath = "/nsmg/";
</cfscript>

<cfif NOT LEN(url.unqid)>
	<cfinclude template="nsmg/student_app/error_message.cfm">
</cfif>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="nsmg/student_app/app.css">
	<cfquery name="get_student_info" datasource="MySql">
	 	SELECT 
        	s.firstname, 
        	s.familylastname, 
            s.studentid,
            s.cancelDate,
			u.businessname
		FROM 
        	smg_students s
		INNER JOIN 
        	smg_users u ON u.userid = s.intrep
		WHERE 
        	s.uniqueid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.unqid#">
	</cfquery>
	<cfset CLIENT.studentid = '#get_student_info.studentid#'>
	<title>EXITS Online Application <cfoutput query="get_student_info"> - #firstname# #familylastname# (###studentid#)</cfoutput></title>
</head>

<!--- DOS Request - Link for Fellipe Casale's application 27070 has been shared and it's out of compliance | Block access to canceled students --->
<cfif isDate(get_student_info.cancelDate)>
	<p><h1 align="center">Sorry this application is no longer available.</h1></p>
	<cfabort>
</cfif>

<cfoutput>
<script language="JavaScript" type="text/JavaScript">
<!--
function launch(newURL, newName, newFeatures, orgName) {
  var remote = open(newURL, newName, newFeatures);
  if (remote.opener == null)
	remote.opener = window;
  remote.opener.name = orgName;
  return remote;
}
function launchRemote() {
  myRemote = launch("nsmg/student_app/section4/page22print.cfm?studentid=#get_student_info.studentid#", "Files", "height=450,width=380,dependent=1,directories=0,fullscreen=0,location=0,menubar=0,resizable=0,scrollbars=1,status=0,toolbar=0", "myWindow");
}
-->
</script>
</cfoutput>

<body onLoad="print();launchRemote();"> <!--- onLoad="print()" --->
<input type="Button" name="printit" value="print" onclick="javascript:window.print();">

<cfset url.exits_app = '1'>

<table align="center" width="100%" cellpadding="0" cellspacing="0"  border="0"> 
	<!--- SECTION 1 --->
	<tr><td valign="top">
		<cfinclude template="nsmg/student_app/section1/page1print.cfm">
		<div style="page-break-after:always;"></div>	
	</td></tr>
	<tr><td valign="top">
		<cfinclude template="nsmg/student_app/section1/page2print.cfm">
		<div style="page-break-after:always;"></div>	
	</td></tr>
	<tr><td valign="top">
		<cfinclude template="nsmg/student_app/section1/page3print.cfm">
		<div style="page-break-after:always;"></div>	
	</td></tr>
	<tr><td valign="top">
		<cfinclude template="nsmg/student_app/section1/page4print.cfm">
		<div style="page-break-after:always;"></div>	
	</td></tr>
	<tr><td valign="top">
		<cfinclude template="nsmg/student_app/section1/page5print.cfm">
		<div style="page-break-after:always;"></div>	
	</td></tr>		
	<tr><td valign="top">
		<cfinclude template="nsmg/student_app/section1/page6print.cfm">
		<div style="page-break-after:always;"></div>	
	</td></tr>
	
	<!--- SECTION 2 --->
	<tr><td valign="top">
		<cfinclude template="nsmg/student_app/section2/page7print.cfm">
		<div style="page-break-after:always;"></div>	
	</td></tr>
	<tr><td valign="top">
		<cfinclude template="nsmg/student_app/section2/page8print.cfm">
		<div style="page-break-after:always;"></div>	
	</td></tr>
	<tr><td valign="top">
		<cfinclude template="nsmg/student_app/section2/page9print.cfm">
		<div style="page-break-after:always;"></div>	
	</td></tr>
	<tr><td valign="top">
		<cfinclude template="nsmg/student_app/section2/page10print.cfm">
		<div style="page-break-after:always;"></div>	
	</td></tr>
	
	<!--- SECTION 3 --->
	<tr><td valign="top">
		<cfinclude template="nsmg/student_app/section3/page11print.cfm">
		<div style="page-break-after:always;"></div>	
	</td></tr>	
	<tr><td valign="top">
		<cfinclude template="nsmg/student_app/section3/page12print.cfm">
		<div style="page-break-after:always;"></div>	
	</td></tr>	
	<tr><td valign="top">
		<cfinclude template="nsmg/student_app/section3/page13print.cfm">
		<div style="page-break-after:always;"></div>	
	</td></tr>	
	<tr><td valign="top">
		<!--- DO NOT PRINT PAGES 14 if PDF or DOC is attached --->
		<cfdirectory directory="#AppPath.onlineApp.inserts#page14" name="page14" filter="#get_student_info.studentid#.*">	
		<cfif Right(page14.name, 3) NEQ 'pdf' AND Right(page14.name, 3) NEQ 'doc'>	
			<cfinclude template="nsmg/student_app/section3/page14print.cfm">
			<cfif printpage EQ 'yes'>
				<div style="page-break-after:always;"></div><br>	
			</cfif>
		</cfif>
	</td></tr>
	
	<!--- SECTION 4 --->

	<!--- DO NOT PRINT PAGES 15, 16 AND 17 if PDF or DOC are attached --->
	
	<tr><td valign="top">
		<cfdirectory directory="#AppPath.onlineApp.inserts#page15" name="page15" filter="#get_student_info.studentid#.*">	
		<cfif Right(page15.name, 3) NEQ 'pdf' AND Right(page15.name, 3) NEQ 'doc'>	
			<cfinclude template="nsmg/student_app/section4/page15print.cfm">
			<cfif printpage EQ 'yes'>
				<div style="page-break-after:always;"></div><table cellpadding="0" cellspacing="0"><tr><td>&nbsp;</td></tr></table>
			</cfif>
		</cfif>
	</td></tr>										
	<tr><td valign="top">
		<cfdirectory directory="#AppPath.onlineApp.inserts#page16" name="page16" filter="#get_student_info.studentid#.*">	
		<cfif Right(page16.name, 3) NEQ 'pdf' AND Right(page16.name, 3) NEQ 'doc'>	
			<cfinclude template="nsmg/student_app/section4/page16print.cfm">
			<cfif printpage EQ 'yes'>
				<div style="page-break-after:always;"></div><br>
			</cfif>
		</cfif>
	</td></tr>	
	<tr><td valign="top">
		<cfdirectory directory="#AppPath.onlineApp.inserts#page17" name="page17" filter="#get_student_info.studentid#.*">	
		<cfif Right(page17.name, 3) NEQ 'pdf' AND Right(page17.name, 3) NEQ 'doc'>	
			<cfinclude template="nsmg/student_app/section4/page17print.cfm">
			<cfif printpage EQ 'yes'>
				<div style="page-break-after:always;"></div><br>
			</cfif>
		</cfif>
	</td></tr>		
	<tr><td valign="top">
		<cfinclude template="nsmg/student_app/section4/page18print.cfm">
		<cfif printpage EQ 'yes'>
			<div style="page-break-after:always;"></div><br>
		</cfif>
	</td></tr>		
	<tr><td valign="top">
		<cfinclude template="nsmg/student_app/section4/page19print.cfm">
		<div style="page-break-after:always;"></div>	
	</td></tr>		
	<tr><td valign="top">
		<cfinclude template="nsmg/student_app/section4/page20print.cfm">
		<div style="page-break-after:always;"></div>	
	</td></tr>
	<tr><td valign="top">
		<cfinclude template="nsmg/student_app/section4/page21print.cfm">
	</td></tr>
    
    <tr><td valign="top">
        <cfset fileURL = "nsmg">
        <cfinclude template="nsmg/student_app/section4/page22print.cfm">
	</td></tr>
 	
	<!--- Pages 23 - 24 use this variable instead of a separate print page --->
	<cfset URL.display = "print">
	<tr><td valign="top">
        	<cfinclude template="nsmg/student_app/section4/page23.cfm">
	</td></tr>
	<tr><td valign="top">
        	<cfinclude template="nsmg/student_app/section4/page24.cfm">
	</td></tr>

	<!--- Pages 25 - 27 use these variables for displaying images if there are any --->
    <cfscript>
        param name="vStudentAppRelativePath" default="../";
        param name="vUploadedFilesRelativePath" default="../../";
    </cfscript>
    <tr><td valign="top">
		<cfset doc="page25">
        <cfinclude template="nsmg/student_app/print_include_file.cfm">
	</td></tr>
    <tr><td valign="top">
		<cfset doc="page26">
        <cfinclude template="nsmg/student_app/print_include_file.cfm">
	</td></tr>
    <tr><td valign="top">
		<cfset doc="page27">
        <cfinclude template="nsmg/student_app/print_include_file.cfm">
	</td></tr>
</table>

<cfcatch type="any">
	<cfinclude template="nsmg/student_app/error_message.cfm">
</cfcatch>
</cftry>
