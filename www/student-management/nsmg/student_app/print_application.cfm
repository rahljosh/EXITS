<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <link rel="stylesheet" type="text/css" href="app.css">
        <title>Print Complete Application</title>
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

		<!--- FROM PHP - AXIS --->
        <cfif IsDefined('URL.user')>
            <cfset CLIENT.usertype = '#URL.user#'>
        </cfif>
        
        <cfif IsDefined('url.unqid')>
            <cfquery name="qGetStudentInfoPrint" datasource="#APPLICATION.DSN#">
                SELECT
                    s.firstname,
                    s.familylastname,
                    s.studentid,
                    s.intrep,
                    s.app_indicated_program,
                    u.businessname,
                    u.master_accountid
                FROM
                    smg_students s
                INNER JOIN
                    smg_users u ON u.userid = s.intrep
                WHERE
                    s.uniqueid = <cfqueryparam value="#url.unqid#" cfsqltype="cf_sql_char">
            </cfquery>	
            <cfset CLIENT.studentid = '#qGetStudentInfoPrint.studentid#'>
        <cfelse>
            <cfquery name="qGetStudentInfoPrint" datasource="#APPLICATION.DSN#">
                SELECT
                    s.firstname,
                    s.familylastname,
                    s.studentid,
                    s.intrep,
                    s.uniqueid,
                    s.app_indicated_program,
                    u.businessname,
                    u.master_accountid
                FROM
                    smg_students s
                INNER JOIN
                    smg_users u ON u.userid = s.intrep
                WHERE
                    studentid = <cfqueryparam value="#VAL(client.studentid)#" cfsqltype="cf_sql_integer">
            </cfquery>
            <cfset url.unqid = '#qGetStudentInfoPrint.uniqueid#'>
        </cfif>
        
        <cfif cgi.http_host is 'jan.case-usa.org' or cgi.http_host is 'www.case-usa.org'>
            <cfset client.org_code = 10>
            <cfset bgcolor ='ffffff'>
        <cfelse>
            <cfset client.org_code = 5>
            <cfset bgcolor ='B5D66E'>
        </cfif>
        <cfquery name="org_info" datasource="#APPLICATION.DSN#">
            SELECT
                *
            FROM
                smg_companies
            WHERE
                companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.org_code)#">
        </cfquery>
        
        <!----Check Allergy---->
        <cfquery name="check_allergy" datasource="#APPLICATION.DSN#">
            SELECT
                has_an_allergy
            FROM
                smg_student_app_health
            WHERE
                studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.studentID)#">
        </cfquery>
        <!-----Check Additional Medical---->
        <cfquery name="additional_info" datasource="#APPLICATION.DSN#">
            SELECT
                *
            FROM
                smg_student_app_health_explanations
            WHERE
                studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.studentID)#">
        </cfquery>
        
        <cfscript>
			// This is to set the correct directory for displaying images in the uploaded files
			vStudentAppRelativePath = "";
			vUploadedFilesRelativePath = "../";
        </cfscript>
        
        <!--- SECTION 1 --->				
        <cfinclude template="section1/page1print.cfm">
        <div style="page-break-after:always;"></div>
                    
        <cfinclude template="section1/page2print.cfm">
        <div style="page-break-after:always;"></div>
                        
        <cfinclude template="section1/page3print.cfm">
        <div style="page-break-after:always;"></div>
                    
        <cfinclude template="section1/page4print.cfm">
        <div style="page-break-after:always;"></div>
            
        <cfinclude template="section1/page5print.cfm">
        <div style="page-break-after:always;"></div>
                    
        <cfinclude template="section1/page6print.cfm">
        <div style="page-break-after:always;"></div>
        
        <!--- SECTION 2 --->				
        <cfinclude template="section2/page7print.cfm">
        <div style="page-break-after:always;"></div>
                    
        <cfinclude template="section2/page8print.cfm">
        <div style="page-break-after:always;"></div>
                    
        <cfinclude template="section2/page9print.cfm">
        <div style="page-break-after:always;"></div>
                        
        <cfinclude template="section2/page10print.cfm">
        <div style="page-break-after:always;"></div>
            
        <!--- SECTION 3 --->			
        <cfinclude template="section3/page11print.cfm">
        <div style="page-break-after:always;"></div>
                
        <cfif additional_info.recordcount gt 0>
            <cfinclude template="section3/additional_info_print.cfm">
            <div style="page-break-after:always;"></div>
        </cfif>
        			
        <cfinclude template="section3/page12print.cfm">
        <div style="page-break-after:always;"></div>
                
        <cfif additional_info.recordcount gt 0>
            <cfinclude template="section3/allergy_info_request_print.cfm">
            <div style="page-break-after:always;"></div>
        </cfif>
        			
        <cfinclude template="section3/page13print.cfm">
        <div style="page-break-after:always;"></div>
        
        <cfinclude template="section3/page14print.cfm">
        <div style="page-break-after:always;"></div>
        
        <!--- SECTION 4 --->
        <cfinclude template="section4/page15print.cfm">
        <div style="page-break-after:always;"></div>
        
        <cfinclude template="section4/page16print.cfm">
        <div style="page-break-after:always;"></div>
        
        <cfinclude template="section4/page17print.cfm">
        <div style="page-break-after:always;"></div>
        
        <cfinclude template="section4/page18print.cfm">
        <div style="page-break-after:always;"></div>
        
        <cfinclude template="section4/page19print.cfm">
        <div style="page-break-after:always;"></div>
        
        <cfinclude template="section4/page20print.cfm">
        <div style="page-break-after:always;"></div>
        
        <cfinclude template="section4/page21print.cfm">
        <div style="page-break-after:always;"></div>
        
        <cfset URL.display = "print"> <!--- This is used for the following pages instead of an additional print page --->
        
		<!--- Do not display for Canada --->
		<cfif CLIENT.companyID NEQ 13>
	        <cfinclude template="section4/page23.cfm">
	        <div style="page-break-after:always;"></div>
	        
	        <cfinclude template="section4/page24.cfm">
	        <div style="page-break-after:always;"></div>
	 	</cfif>
        
        <cfscript>
			param name="vStudentAppRelativePath" default="../";
			param name="vUploadedFilesRelativePath" default="../../";
		</cfscript>
        
        <cfset doc="page25">
        <cfinclude template="print_include_file.cfm">
        <div style="page-break-after:always;"></div>
        
        <cfset doc="page26">
        <cfinclude template="print_include_file.cfm">
        <div style="page-break-after:always;"></div>
        
        <cfset doc="page27">
        <cfinclude template="print_include_file.cfm">
        <div style="page-break-after:always;"></div>

	</body>
</html>