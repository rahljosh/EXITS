<!----
<cftry>
---->
<style type="text/css">
body {font:Arial, Helvetica, sans-serif;}
.thin-border{ border: 1px solid #000000;
			  font:Arial, Helvetica, sans-serif;}
.dashed-border {border: 1px solid #FF9933;}
    </style>
<cfquery name="users_bypass" datasource="mysql">
select userid, bypass_checklist
from smg_users
where userid = #client.userid#
</cfquery>
<cfif users_bypass.bypass_checklist eq 1>
<cfset client.missingitems = 0>
It looks like your applcations do not need to be verified through the checklist.  This happens on some occasions under certain circumstances.<br>The next time you submit an application, the check list my be required.<br><Br>
 <div align="center"><img src="../pics/processing.gif">
<META http-equiv="refresh" content="5;URL=check_app_results.cfm">

<cfabort>
</cfif>
<br><br>
<body bgcolor="#dcdcdc">
<table class=dashed-border align="center" width = 550 bgcolor="white">
	<tr>
		<td><img src="../pics/top-email.gif" width="550" height="75"></td>
	</tr>
	<tr>
		<Td>
		Please wait while your application information is being checked. Do not close this window or click your back button.<br><br>
		While this initial check does not guarantee that your application will not be denyd,
		it will catch many common mistakes.<br><br>
		Your local representative may deny your application and request more information, once that information
		completed, simply submit your app. again.<br>
		<div align="center"><img src="../pics/processing.gif"><br><br>If this page apears for more then 2 minutes, click <A href="check_app_results.cfm">here</A></div>
		</Td>
	</tr>
</table>

<cfset nsmg_directory = '/var/www/html/student-management/nsmg/uploadedfiles'>

<!---- International Rep - EF ACCOUNTS ---->
<cfquery name="smg_students" datasource="MySql">
	SELECT s.*, u.businessname, u.master_accountid, app_indicated_program
	FROM smg_students s
	INNER JOIN smg_users u ON u.userid = s.intrep
	WHERE studentid = <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="smg_student_siblings" datasource="MySql">
	SELECT childid, studentid, birthdate, sex, liveathome, name 
	FROM smg_student_siblings
	WHERE studentid = <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
	ORDER BY childid
</cfquery>

<cfdirectory name="page04_family_album" directory="#nsmg_directory#/online_app/picture_album/#client.studentid#">

<cfquery name="smg_student_app_family_album" datasource="MySql">
	SELECT id, studentid, description, filename
	FROM smg_student_app_family_album
	WHERE studentid = <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="smg_student_app_school_year" datasource="MySql">
	SELECT yearid, studentid, beg_year, end_year, class_year 
	FROM smg_student_app_school_year
	WHERE studentid = <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="smg_student_app_grades" datasource="MySql">
	SELECT gradesid, smg_student_app_grades.yearid, class_name, hours, grade 
	FROM smg_student_app_grades
	INNER JOIN smg_student_app_school_year ON smg_student_app_school_year.yearid = smg_student_app_grades.yearid
	WHERE smg_student_app_school_year.studentid = <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="smg_student_app_health" datasource="MySql">
	SELECT * 
	FROM smg_student_app_health
	WHERE studentid = <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="smg_student_app_state_requested" datasource="MySql">
	SELECT statechoiceid, studentid, state1, state2, state3
	FROM smg_student_app_state_requested
	WHERE studentid =  <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="get_pages" datasource="MySql">
	SELECT DISTINCT page
	FROM smg_student_app_field
	GROUP BY page
	ORDER BY page 
</cfquery>

<cfloop query="get_pages">
	<cfquery name="page#get_pages.page#" datasource="MySql">
		SELECT fieldid, field_label, required, section, page, field_order, field_name, table_located 
		FROM smg_student_app_field
		WHERE page = '#get_pages.page#'
		ORDER BY field_order
	</cfquery>
</cfloop>

	<cfinclude template="../querys/get_student_info.cfm">
		
		
<!--- CHECK FOR UPLOADED FILE --->

<!--- PASSPORT PICTURE --->
<cfdirectory directory="#nsmg_directory#/web-students/" name="check_01_upload" filter="#smg_students.studentid#.*">

<!--- STUDENTS LETTER --->
<cfdirectory directory="#nsmg_directory#/letters/students/" name="check_05_upload" filter="#smg_students.studentid#.*">

<!--- PARENTS LETTER --->
<cfdirectory directory="#nsmg_directory#/letters/parents/" name="check_06_upload" filter="#smg_students.studentid#.*">

<!--- <cfloop from="10" to="21" index="i">  --->
<cfloop list="08,09,10,11,12,13,14,15,16,17,18,19,20,21" index="i">
	<cfdirectory directory="#nsmg_directory#/online_app/page#i#" name="check_#i#_upload" filter="#smg_students.studentid#.*">	
</cfloop>

<cfinclude template="../querys/get_latest_status.cfm">
	
<cfset get_field = ''>
<cfset countred = 0>

<cfoutput>

	<!--- PAGE 01 --->
	<cfif check_01_upload.recordcount EQ 0>
		<cfset countred = countred + 1>
	</cfif>		
	<cfloop query="page1">
		<cfset get_field = #page1.table_located# &"."& #page1.field_name#>
		<cfif Evaluate(get_field) EQ '' AND required EQ 1>
			<cfset countred = countred + 1>
		</cfif>
	</cfloop>
	
	<!--- PAGE 02 --->
	<cfloop query="page2">
		<cfset get_field = #page2.table_located# &"."& #page2.field_name#>
		<cfif Evaluate(get_field) EQ '' AND required EQ 1>
			<cfset countred = countred + 1>		 
		</cfif>
	</cfloop>
	
	<!--- PAGE 03 --->
	<cfloop query="page3">
		<cfset get_field = #page3.table_located# &"."& #page3.field_name#>
		<cfif Evaluate(get_field) EQ '' AND required EQ 1>
			<cfset countred = countred + 1>		 
		</cfif>
	</cfloop>
	
	<!--- PAGE 04 --->
	<cfloop query="page4">
		<cfset get_field = #page4.table_located# &"."& #page4.field_name#>
		<cfif required EQ 1 AND page04_family_album.recordcount EQ 0>
			<cfset countred = countred + 1>
		</cfif>
	</cfloop>
	
	<!--- PAGE 05 --->
	<cfif check_05_upload.recordcount EQ 0>
		<cfloop query="page5">
			<cfset get_field = #page5.table_located# &"."& #page5.field_name#>
			<cfif Evaluate(get_field) EQ '' AND required EQ 1>
				<cfset countred = countred + 1>
			</cfif>
		</cfloop>
	</cfif>
	
	<!--- PAGE 06 --->
	<cfif check_06_upload.recordcount EQ 0>
		<cfloop query="page6">
			<cfset get_field = #page6.table_located# &"."& #page6.field_name#>
			<cfif Evaluate(get_field) EQ '' AND required EQ 1>
				<cfset countred = countred + 1>
			</cfif>
		</cfloop>
	</cfif>

	<!--- PAGE 07 --->
	<cfloop query="page7">
		<cfset get_field = #page7.table_located# &"."& #page7.field_name#>
		<cfif Evaluate(get_field) EQ '' AND required EQ 1>
			<cfset countred = countred + 1>
		</cfif>
	</cfloop>
	
	<!--- PAGE 08 --->
	<cfloop query="page8">
		<cfset get_field = #page8.table_located# &"."& #page8.field_name#>
		<cfif Evaluate(get_field) EQ '' AND required EQ 1>
			<cfset countred = countred + 1>
		</cfif>
	</cfloop>
	<cfif check_08_upload.recordcount EQ 0>
		<cfset countred = countred + 1>
	</cfif>		
	
	<!--- PAGE 09 --->
	<cfloop query="page9">
		<cfset get_field = #page9.table_located# &"."& #page9.field_name#>
		<cfif Evaluate(get_field) EQ '' AND required EQ 1>
			<cfset countred = countred + 1>
		</cfif>
	</cfloop>
	
	<!--- PAGE 10 --->
	<cfloop query="page10">
		<cfset get_field = #page10.table_located# &"."& #page10.field_name#>
		<cfif Evaluate(get_field) EQ '' AND required EQ 1>
			<cfset countred = countred + 1>
		</cfif>
	</cfloop>
	<cfif check_10_upload.recordcount EQ 0>
		<cfset countred = countred + 1>
	</cfif>		
	
	<!--- PAGE 11 --->
	<cfloop query="page11">
		<cfset get_field = #page11.table_located# &"."& #page11.field_name#>
		<cfif Evaluate(get_field) EQ '' AND required EQ 1>
			<cfset countred = countred + 1>
		</cfif>
	</cfloop>

	<!--- PAGE 12 --->
	<cfloop query="page12">
		<cfset get_field = #page12.table_located# &"."& #page12.field_name#>
		<cfif Evaluate(get_field) EQ '' AND required EQ 1>
			<cfset countred = countred + 1>
		</cfif>
	</cfloop>
	<cfif check_12_upload.recordcount EQ 0>
		<cfset countred = countred + 1>
	</cfif>	

	<!--- PAGE 13 --->
	<cfset lastvaccine = ''>
	<cfloop query="page13">
		<cfif lastvaccine NEQ page13.field_label>
			<cfquery name="smg_student_app_shots" datasource="MySql">
				SELECT vaccineid, studentid, vaccine, disease, shot1, shot2, shot3, shot4, shot5, booster  
				FROM smg_student_app_shots
				WHERE vaccine = '#page13.field_label#' AND studentid = <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
			</cfquery>
		</cfif>
		<cfset lastvaccine = page13.field_label>
		
		<cfset get_field = #page13.table_located# &"."& #page13.field_name#>
		<cfif Evaluate(get_field) EQ '' AND page13.required EQ 1>
			<cfset countred = countred + 1>
		</cfif>
	</cfloop>
	<cfif check_13_upload.recordcount EQ 0>
		<cfset countred = countred + 1>
	</cfif>		

	<!--- PAGE 14 --->
	<cfloop query="page14">
		<cfset get_field = #page14.table_located# &"."& #page14.field_name#>
		<cfif Evaluate(get_field) EQ '' AND required EQ 1>
			<cfset countred = countred + 1>
		</cfif>
	</cfloop>
	<cfif check_14_upload.recordcount EQ 0>
		<cfset countred = countred + 1>
	</cfif>	

	<!--- PAGE 15 --->
	<cfif check_15_upload.recordcount EQ 0>
		<cfset countred = countred + 1> 
	</cfif>

	<!--- PAGE 16 --->
	<cfif check_16_upload.recordcount EQ 0>
		<cfset countred = countred + 1> 
	</cfif>
	
	<!--- PAGE 17 --->
	<cfif check_17_upload.recordcount EQ 0>
		<cfset countred = countred + 1> 
	</cfif>
	
	<!--- PAGE 18 --->
	<cfloop query="page18">
		<cfset get_field = #page18.table_located# &"."& #page18.field_name#>
		<cfif Evaluate(get_field) EQ '' AND required is 1>
			<cfset countred = countred + 1>
		<cfelseif Evaluate(get_field) GT 0 AND check_18_upload.recordcount EQ 0>
			<cfset countred = countred + 1> 		
		</cfif>
	</cfloop> 

	<!--- PAGE 19 --->
	<!--- Intl. Representative Documents --->
	<cfif client.usertype LTE 8 AND get_latest_status.status GT '2'>
		<cfloop query="page19">
			<cfset get_field = #page19.table_located# &"."& #page19.field_name#>
			<cfif Evaluate(get_field) EQ '' AND required is 1>
				<cfset count19 = 1> <cfset countred = countred + 1>
			<cfelseif Evaluate(get_field) EQ '' AND required is 0>
				<cfset count19 = 1>
			</cfif>
		</cfloop>
		<cfif check_19_upload.recordcount EQ 0>
			<cfset countred = countred + 1> 
		</cfif>
	</cfif> 		

	<!--- HIDE GUARANTEE FOR EF AND INTERSTUDIES 8318 --->
	<cfif IsDefined('client.usertype') AND client.usertype EQ 10 AND smg_students.master_accountid NEQ 10115 AND smg_students.intrep NEQ 10115 AND smg_students.intrep NEQ 8318>
	
		<!--- PROGRAM TYPES 1 = AYP 10 AUG / 2 = AYP 5 AUG / 3 = AYP 5 JAN / 4 = AYP 12 JAN --->
		<cfif (DateFormat(now(), 'mm') EQ 4 OR dateFormat(now(), 'mm') EQ 5) AND (get_student_info.app_indicated_program EQ 1 OR get_student_info.app_indicated_program EQ '2')> 
			<tr><td><font color="0000FF">This page is not available in April or May.</font><br></td></tr>
		<cfelse>
			<!--- PAGE 20 --->
			<cfloop query="page20">
				<cfset get_field = #page20.table_located# &"."& #page20.field_name#>
				<cfif Evaluate(get_field) EQ '' AND required is 1>
					<cfset countred = countred + 1>
				<cfelseif Evaluate(get_field) GT 0 AND check_20_upload.recordcount EQ 0>
					<cfset countred = countred + 1> 
				</cfif>
			</cfloop> 
		</cfif>
	
		<!--- PAGE 21 --->
		<!--- PROGRAM TYPES 1 = AYP 10 AUG / 2 = AYP 5 AUG / 3 = AYP 5 JAN / 4 = AYP 12 JAN --->
		<cfif (DateFormat(now(), 'mm') EQ 4 OR dateFormat(now(), 'mm') EQ 5) AND (get_student_info.app_indicated_program EQ 1 OR get_student_info.app_indicated_program EQ '2')> 
			<tr><td><font color="0000FF">This page is not available in April or May.</font><br></td></tr> 
		<cfelse>
			<!--- student has choosen state guarantee --->
			<cfif smg_student_app_state_requested.recordcount GT 0 AND smg_student_app_state_requested.state1 GT 0>
				<cfif check_21_upload.recordcount EQ 0>
					<cfset countred = countred + 1>
				</cfif>
			<!--- student has not choosen if accetps state guarantee --->
			<cfelseif smg_student_app_state_requested.recordcount EQ 0>
				<cfloop query="page21">
					<cfset get_field = #page21.table_located# &"."& #page21.field_name#>
				</cfloop>	
				<cfset countred = countred + 1>	
			</cfif>
		</cfif>
		
	</cfif>
</cfoutput>

<!--- marcus testing  <cfset client.missingitems = 0> --->

<cfset client.missingitems = '#countred#'>

<cflocation url="check_app_results.cfm">
</body>
<!----
<cfcatch type="any">
	<cfinclude template="../email_error.cfm">
</cfcatch>
</cftry>	 
---->