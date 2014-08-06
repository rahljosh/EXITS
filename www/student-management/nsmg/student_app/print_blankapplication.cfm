<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Print Blank Application</title>
	<style type="text/css">
		@page {
			margin: 0px auto;
			padding: 0px;
		}
		table, table tr, table tr td {
			margin: 0px;
			padding: 0px;
		}
	</style>
</head>
<body onLoad="print()">

<cfset url.path = "">

<cfquery name="qGetIntlRepInfo" datasource="#APPLICATION.DSN#">
	SELECT 
    	s.studentID,
        s.app_indicated_program,
    	u.userID,
    	u.businessname, 
        u.master_accountid
	FROM
		smg_students s
    INNER JOIN 
    	 smg_users u ON u.userid = s.intrep
	WHERE 
    	s.studentid = <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfif cgi.http_host is 'jan.case-usa.org' or cgi.http_host is 'www.case-usa.org'>
	<cfset client.org_code = 10>
	<cfset bgcolor ='ffffff'>    
<cfelse>
    <cfset client.org_code = 5>
    <cfset bgcolor ='B5D66E'>  
</cfif>
<cfquery name="org_info" datasource="#APPLICATION.DSN#">
select *
from smg_companies
where companyid = #client.org_code#
</cfquery>

<!--- SECTION 1 --->
<div style="page-break-after:always;"><cfinclude template="section1/page1printblank.cfm"></div>
<div style="page-break-after:always;"><cfinclude template="section1/page2printblank.cfm"></div>
<div style="page-break-after:always;"><cfinclude template="section1/page3printblank.cfm"></div>
<div style="page-break-after:always;"><cfinclude template="section1/page4printblank.cfm"></div>
<div style="page-break-after:always;"><cfinclude template="section1/page5printblank.cfm"></div>
<div style="page-break-after:always;"><cfinclude template="section1/page6printblank.cfm"></div>

<!--- SECTION 2 --->
<div style="page-break-after:always;"><cfinclude template="section2/page7printblank.cfm"></div>
<div style="page-break-after:always;"><cfinclude template="section2/page8printblank.cfm"></div>
<div style="page-break-after:always;"><cfinclude template="section2/page9printblank.cfm"></div>
<div style="page-break-after:always;"><cfinclude template="section2/page10printblank.cfm"></div>

<!--- SECTION 3 --->
<div style="page-break-after:always;"><cfinclude template="section3/page11printblank.cfm"></div>
<div style="page-break-after:always;"><cfinclude template="section3/page12printblank.cfm"></div>
<div style="page-break-after:always;"><cfinclude template="section3/page13printblank.cfm"></div>
<div style="page-break-after:always;"><cfinclude template="section3/page14printblank.cfm"></div>

<!--- SECTION 4 --->
<div style="page-break-after:always;"><cfinclude template="section4/page15printblank.cfm"></div>
<div style="page-break-after:always;"><cfinclude template="section4/page16printblank.cfm"></div>
<div style="page-break-after:always;"><cfinclude template="section4/page17printblank.cfm"></div>

<!--- Do not display for ESI or Canada Application --->
<cfif CLIENT.companyID NEQ 14 AND NOT ListFind("14,15,16", get_student_info.app_indicated_program)> 
	<div style="page-break-after:always;"><cfinclude template="section4/page18printblank.cfm"></div>									
</cfif>

<div style="page-break-after:always;"><cfinclude template="section4/page19printblank.cfm"></div>

<!--- Do not print guarantees for EF or Canada --->
<cfif (qGetIntlRepInfo.userID NEQ '10111' AND qGetIntlRepInfo.master_accountid NEQ '10111') OR client.companyid NEQ 13>
	<!----We don't need to include 20 for ESI---->
    <cfif (CLIENT.companyID NEQ 14 AND CLIENT.companyID NEQ 13)>
		<div style="page-break-after:always;"><cfinclude template="section4/page20printblank.cfm"></div>								
  	</cfif>
<CFIF client.companyid NEQ 13>
	<div style="page-break-after:always;"><cfinclude template="section4/page21printblank.cfm"></div>
 </CFIF>
</cfif>

<cfset URL.display = "print">
<cfset URL.printBlank = 1>

<!--- Do not display for canada --->
<cfif CLIENT.companyID NEQ 13 AND CLIENT.companyID NEQ 14>
	<div style="page-break-after:always;"><cfinclude template="section4/page23blank.cfm"></div>
</cfif>


</body></html>


