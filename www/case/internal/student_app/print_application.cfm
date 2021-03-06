<cftry>

<cfsetting requesttimeout="300">

<!--- OPENING FROM PHP - AXIS --->
<cfif IsDefined('url.user')>
	<cfset client.usertype = '#url.user#'>
</cfif>

<cfif IsDefined('url.unqid')>
	<cfquery name="get_student_info2" datasource="caseusa">
	 	SELECT s.firstname, s.familylastname, s.studentid, s.intrep, smg_id,
			u.businessname, u.master_accountid
		FROM smg_students s
		INNER JOIN smg_users u ON u.userid = s.intrep
		WHERE s.uniqueid = <cfqueryparam value="#url.unqid#" cfsqltype="cf_sql_char">
	</cfquery>	
	<cfset client.studentid = '#get_student_info2.studentid#'>
<cfelse>
	<cfquery name="get_student_info2" datasource="caseusa">
	 	SELECT s.firstname, s.familylastname, s.studentid, s.intrep, smg_id,
			u.businessname, u.master_accountid
		FROM smg_students s
		INNER JOIN smg_users u ON u.userid = s.intrep
		WHERE studentid = <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
	</cfquery>
</cfif>
<cfif #get_student_info2.smg_id# eq 0>
	<cfset attach_directory = 'student-management/nsmg/'>
	<cfset correct_studentid = #get_student_info2.smg_id#>
<cfelse>
	<cfset attach_directory = 'case/internal/'>
	<cfset correct_studentid = #get_student_info2.studentid#>
</cfif>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>EXITS Online Application <cfoutput query="get_student_info2"> - #firstname# #familylastname# (###studentid#) - #businessname#</cfoutput></title>
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
	  myRemote = launch("section4/page22print.cfm", "Files", "height=450,width=380,dependent=1,directories=0,fullscreen=0,location=0,menubar=0,resizable=0,scrollbars=1,status=0,toolbar=0", "myWindow");
	}
	-->
	</script>
	<style type="text/css">
	<!--
	body {
		margin-left: 0.3in;
		margin-top: 0.3in;
		margin-right: 0.3in;
		margin-bottom: 0.3in;
	}
	-->
	</style>
</head>

<!--- check for attached files ---->
<body onLoad="print();launchRemote();"> 

<input type="Button" name="printit" value="print" onclick="javascript:window.print();">

<cfset url.path = "">

<table align="center" width="100%" cellpadding="0" cellspacing="0"  border="0"> 
	<!--- SECTION 1 --->
	<tr><td valign="top">
			<cfinclude template="section1/page1print.cfm">
			<div style="page-break-after:always;"></div>
	</td></tr>
	<tr><td valign="top">
			<cfinclude template="section1/page2print.cfm">
			<div style="page-break-after:always;"></div>
	</td></tr>
	<tr><td valign="top">
			<cfinclude template="section1/page3print.cfm">
			<div style="page-break-after:always;"></div>
	</td></tr>
	<tr><td valign="top">
			<cfinclude template="section1/page4print.cfm">
			<div style="page-break-after:always;"></div>
	</td></tr>
	<tr><td valign="top">
			<!--- DO NOT PRINT PAGES 5 IF PDF or DOC is attached --->
			<cfdirectory directory="/var/www/html/#attach_directory#uploadedfiles/letters/students" name="page5" filter="#get_student_info2.studentid#.*">	
			<cfif Right(page5.name, 3) NEQ 'pdf' AND Right(page5.name, 3) NEQ 'doc'>	
				<cfinclude template="section1/page5print.cfm">
				<div style="page-break-after:always;"></div>	
			</cfif>
	</td></tr>
	<tr><td valign="top">
			<!--- DO NOT PRINT PAGES 5 IF PDF or DOC is attached --->
			<cfdirectory directory="/var/www/html/#attach_directory#uploadedfiles/letters/parents" name="page6" filter="#get_student_info2.studentid#.*">
			<cfif Right(page6.name, 3) NEQ 'pdf' AND Right(page6.name, 3) NEQ 'doc'>	
				<cfinclude template="section1/page6print.cfm">
				<div style="page-break-after:always;"></div>
			</cfif>
	</td></tr>

	<!--- SECTION 2 --->
	<tr><td valign="top">
			<cfinclude template="section2/page7print.cfm">
			<div style="page-break-after:always;"></div>	
	</td></tr>		
	<tr><td valign="top">			
			<cfinclude template="section2/page8print.cfm">
			<div style="page-break-after:always;"></div>	
	</td></tr>		
	<tr><td valign="top">		
			<cfinclude template="section2/page9print.cfm">
			<div style="page-break-after:always;"></div>	
	</td></tr>		
	<tr><td valign="top">		
			<cfinclude template="section2/page10print.cfm">
			<div style="page-break-after:always;"></div>	
	</td></tr>

	<!--- SECTION 3 --->
	<tr><td valign="top">	
			<cfinclude template="section3/page11print.cfm">
			<div style="page-break-after:always;"></div>	
	</td></tr>		
	<tr><td valign="top">		
			<cfinclude template="section3/page12print.cfm">
			<div style="page-break-after:always;"></div>	
	</td></tr>
	<tr><td valign="top">				
			<cfinclude template="section3/page13print.cfm">
			<div style="page-break-after:always;"></div>	
	</td></tr>
	<tr><td valign="top">			
			<!--- DO NOT PRINT PAGE 14 if PDF or DOC is attached --->
			<cfdirectory directory="/var/www/html/#attach_directory#uploadedfiles/online_app/page14" name="page14" filter="#correct_studentid#.*">	
			<cfif Right(page14.name, 3) NEQ 'pdf' AND Right(page14.name, 3) NEQ 'doc'>	
				<cfinclude template="section3/page14print.cfm">
				<cfif printpage EQ 'yes'>
					<div style="page-break-after:always;"></div>	
				</cfif>
			</cfif>
	</td></tr>

	<!--- SECTION 4 --->
	<!--- DO NOT PRINT PAGES 15, 16 AND 17 if PDF or DOC are attached --->
	<tr><td valign="top">
			<cfdirectory directory="/var/www/html/#attach_directory#uploadedfiles/online_app/page15" name="page15" filter="#correct_studentid#.*">	
			<cfif Right(page15.name, 3) NEQ 'pdf' AND Right(page15.name, 3) NEQ 'doc'>	
				<cfinclude template="section4/page15print.cfm">
				<cfif printpage EQ 'yes'>
					<div style="page-break-after:always;"></div>
				</cfif>
			</cfif>
	</td></tr>
	<tr><td valign="top">
			<cfdirectory directory="/var/www/html/#attach_directory#uploadedfiles/online_app/page16" name="page16" filter="#correct_studentid#.*">	
			<cfif Right(page16.name, 3) NEQ 'pdf' AND Right(page16.name, 3) NEQ 'doc'>	
				<cfinclude template="section4/page16print.cfm">
				<cfif printpage EQ 'yes'>
					<div style="page-break-after:always;"></div>
				</cfif>
			</cfif>
	</td></tr>
	<tr><td valign="top">		
			<cfdirectory directory="/var/www/html/#attach_directory#uploadedfiles/online_app/page17" name="page17" filter="#correct_studentid#.*">	
			<cfif Right(page17.name, 3) NEQ 'pdf' AND Right(page17.name, 3) NEQ 'doc'>	
				<cfinclude template="section4/page17print.cfm">
				<cfif printpage EQ 'yes'>
					<div style="page-break-after:always;"></div>
				</cfif>
			</cfif>
	</td></tr>
	<tr><td valign="top">	
			<cfinclude template="section4/page18print.cfm">
			<cfif printpage EQ 'yes'>
				<div style="page-break-after:always;"></div>
			</cfif>
	</td></tr>
	<tr><td valign="top">			
			<cfinclude template="section4/page19print.cfm">
			<div style="page-break-after:always;"></div>	
	</td></tr>
			
	<!--- HIDE GUARANTEE FOR EF AND INTERSTUDIES 8318 STUDENTS --->
	<cfif IsDefined('client.usertype') AND client.usertype NEQ 10 AND get_student_info2.master_accountid NEQ 10115 AND get_student_info2.intrep NEQ 10115 AND get_student_info2.intrep NEQ 8318>
		<tr><td valign="top">		
				<cfdirectory directory="/var/www/html/#attach_directory#uploadedfiles/online_app/page20" name="page20" filter="#correct_studentid#.*">
				<cfif Right(page20.name, 3) NEQ 'pdf' AND Right(page20.name, 3) NEQ 'doc'>
					<cfinclude template="section4/page20print.cfm">
					<cfif printpage EQ 'yes'>
						<div style="page-break-after:always;"></div>
					</cfif>
				</cfif>
		</td></tr>
		<tr><td valign="top">
				<cfdirectory directory="/var/www/html/#attach_directory#uploadedfiles/online_app/page21" name="page21" filter="#correct_studentid#.*">
				<cfif Right(page21.name, 3) NEQ 'pdf' AND Right(page21.name, 3) NEQ 'doc'>
					<cfinclude template="section4/page21print.cfm">
				</cfif>
		</td></tr>
	</cfif>
</table>

<!--- PRINT PAGE 22 SUPPLEMENTS --->

<cfif #get_student_info2.smg_id# eq 0>
	<cfset nsmg_directory = '/var/www/html/#attach_directory#uploadedfiles'>
<cfelse>
	<cfset nsmg_directory = '/var/www/html/case/internal/uploadedfiles'>
</cfif>




<cfset currentDirectory = "#nsmg_directory#/virtualfolder/#correct_studentid#/page22">

<cfdirectory directory="#currentDirectory#" name="mydirectory" sort="datelastmodified DESC" filter="*.*">

<cfoutput query="mydirectory">
	<cfif (#Right(name, 3)# EQ 'jpg' OR #Right(name, 3)# EQ 'gif' OR #Right(name, 3)# EQ 'bmp' OR #Right(name, 3)# EQ 'peg')>
	<div style="page-break-after:always;"></div><br>
	<table width="660" border="0" cellpadding="3" cellspacing="0" align="center">
		<tr><td><img src="../uploadedfiles/virtualfolder/#correct_studentid#/page22/#name#" width="660" height="820"></td></tr>
	</table>
	</cfif>
</cfoutput>	

</body>
</html>

<cfcatch type="any">
	<cfinclude template="error_message.cfm">
</cfcatch>
</cftry>