

<cfset nsmg_directory = '/var/www/html/student-management/nsmg/uploadedfiles'>

<cfquery name="smg_students" datasource="MySql">
	SELECT s.* <!----, u.businessname, u.businessname, u.master_accountid, app_indicated_program---->
	FROM smg_students s
	<!----
	INNER JOIN smg_users u ON u.userid = s.intrep
	---->
	WHERE soid = '#client.checkstudent#'
</cfquery>

<cfquery name="smg_student_siblings" datasource="MySql">
	SELECT childid, studentid, birthdate, sex, liveathome, name 
	FROM smg_student_siblings
	WHERE studentid = #smg_students.studentid#
	ORDER BY childid
</cfquery>

<cfquery name="smg_student_app_family_album" datasource="MySql">
	SELECT id, studentid, description, filename
	FROM smg_student_app_family_album
	WHERE studentid = #smg_students.studentid#
</cfquery>

<cfdirectory name="page04_family_album" directory="#nsmg_directory#/online_app/picture_album/#client.studentid#">

<cfquery name="smg_student_app_school_year" datasource="MySql">
	SELECT yearid, studentid, beg_year, end_year, class_year 
	FROM smg_student_app_school_year
	WHERE studentid = #smg_students.studentid#
</cfquery>

<cfquery name="smg_student_app_grades" datasource="MySql">
	SELECT gradesid, smg_student_app_grades.yearid, class_name, hours, grade 
	FROM smg_student_app_grades
	INNER JOIN smg_student_app_school_year ON smg_student_app_school_year.yearid = smg_student_app_grades.yearid
	WHERE smg_student_app_school_year.studentid = #smg_students.studentid#
</cfquery>

<cfquery name="smg_student_app_health" datasource="MySql">
	SELECT * 
	FROM smg_student_app_health
	WHERE studentid = #smg_students.studentid#
</cfquery>

<cfquery name="smg_student_app_state_requested" datasource="MySql">
	SELECT statechoiceid, studentid, state1, state2, state3
	FROM smg_student_app_state_requested
	WHERE studentid =  #smg_students.studentid#
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

<!--- CHECK FOR UPLOADED FILE --->

<!--- PASSPORT PICTURE --->
<cfdirectory directory="#nsmg_directory#/web-students/" name="check_01_upload" filter="#client.studentid#.*">

<!--- STUDENTS LETTER --->
<cfdirectory directory="#nsmg_directory#/letters/students/" name="check_05_upload" filter="#smg_students.studentid#.*">

<!--- PARENTS LETTER --->
<cfdirectory directory="#nsmg_directory#/letters/parents/" name="check_06_upload" filter="#smg_students.studentid#.*">

<!--- <cfloop from="10" to="21" index="i">  --->
<cfloop list="08,09,10,11,12,13,14,15,16,17,18,19,20,21" index="i">
	<cfdirectory directory="#nsmg_directory#/online_app/page#i#" name="check_#i#_upload" filter="#client.studentid#.*">	
</cfloop>

<cfinclude template="get_latest_status.cfm">
	
<cfset get_field = ''>
<cfset countred = 0>

<!--- HEADER OF TABLE --->


<cfoutput>


	<!--- PAGE 01 --->
	
	<cfif check_01_upload.recordcount EQ 0>

		<cfset count1 = 1> <cfset countred = countred + 1>
	</cfif>		
	<cfloop query="page1">
		<cfset get_field = #page1.table_located# &"."& #page1.field_name#>
		<cfif Evaluate(get_field) EQ '' AND required EQ 1>
			
			<cfset count1 = 1> <cfset countred = countred + 1>
		<cfelseif Evaluate(get_field) EQ '' AND required EQ 0>
	
			<cfset count1 = 1>
		</cfif>
	</cfloop>
	<cfif not IsDefined('count1')></cfif>

	
	<!--- PAGE 02 --->

	<cfloop query="page2">
		<cfset get_field = #page2.table_located# &"."& #page2.field_name#>
		<cfif Evaluate(get_field) EQ '' AND required EQ 1>
			
			<cfset count2 = 1> <cfset countred = countred + 1>		 
		<cfelseif Evaluate(get_field) EQ '' AND required EQ 0>
		
			<cfset count2 = 1>		
		</cfif>
	</cfloop>
	<cfif not IsDefined('count2')></cfif>
	
	
	<!--- PAGE 03 --->
	
	<cfloop query="page3">
		<cfset get_field = #page3.table_located# &"."& #page3.field_name#>
		<cfif Evaluate(get_field) EQ '' AND required EQ 1>
			
			<cfset count3 = 1> <cfset countred = countred + 1>		 
		<cfelseif Evaluate(get_field) EQ '' AND required EQ 0>
		
			<cfset count3 = 1>		
		</cfif>
	</cfloop>
	<cfif not IsDefined('count3')></cfif>
	
	
	<!--- PAGE 04 --->
	
	<cfloop query="page4">
		<cfset get_field = #page4.table_located# &"."& #page4.field_name#>
		<cfif required EQ 1 AND page04_family_album.recordcount EQ 0>
			
			<cfset count4 = 1> <cfset countred = countred + 1>
		<cfelse>
			
			<cfset count4 = 1>
		</cfif>
	</cfloop>
	<cfif not IsDefined('count4')></cfif>	
	
	
	<!--- PAGE 05 --->

	<cfif check_05_upload.recordcount EQ 0>
		<cfloop query="page5">
			<cfset get_field = #page5.table_located# &"."& #page5.field_name#>
			<cfif Evaluate(get_field) EQ '' AND required EQ 1>
		
				<cfset count5 = 1> <cfset countred = countred + 1>
			<cfelseif Evaluate(get_field) EQ '' AND required EQ 0>
			
				<cfset count5 = 1>
			</cfif>
		</cfloop>
	</cfif>
	<cfif not IsDefined('count5')></cfif>	

	
	<!--- PAGE 06 --->
	
	<cfif check_06_upload.recordcount EQ 0>
		<cfloop query="page6">
			<cfset get_field = #page6.table_located# &"."& #page6.field_name#>
			<cfif Evaluate(get_field) EQ '' AND required EQ 1>
				
				<cfset count6 = 1> <cfset countred = countred + 1>
			<cfelseif Evaluate(get_field) EQ '' AND required EQ 0>
		
				<cfset count6 = 1>
			</cfif>
		</cfloop>
	</cfif>
	<cfif not IsDefined('count6')></cfif>
	
	
	<!--- PAGE 07 --->
	
	<cfloop query="page7">
		<cfset get_field = #page7.table_located# &"."& #page7.field_name#>
		<cfif Evaluate(get_field) EQ '' AND required EQ 1>
		
			<cfset count7 = 1> <cfset countred = countred + 1>
		<cfelseif Evaluate(get_field) EQ '' AND required EQ 0>
		
			<cfset count7 = 1>
		</cfif>
	</cfloop>
	<cfif not IsDefined('count7')></cfif>
		
	
	<!--- PAGE 08 --->

	<cfloop query="page8">
		<cfset get_field = #page8.table_located# &"."& #page8.field_name#>
		<cfif Evaluate(get_field) EQ '' AND required EQ 1>
		
			<cfset count8 = 1> <cfset countred = countred + 1>
		<cfelseif Evaluate(get_field) EQ '' AND required EQ 0>

			<cfset countred = countred + 1>
		</cfif>
	</cfloop>
	<cfif check_08_upload.recordcount EQ 0>
		
		<cfset countred = countred + 1>
	<cfelse>	
		<cfif not IsDefined('count8')></cfif>
	</cfif>		
	
	
	<!--- PAGE 09 --->
	
	<cfloop query="page9">
		<cfset get_field = #page9.table_located# &"."& #page9.field_name#>
		<cfif Evaluate(get_field) EQ '' AND required EQ 1>
			
			<cfset count9 = 1> <cfset countred = countred + 1>
		<cfelseif Evaluate(get_field) EQ '' AND required EQ 0>
			
			<cfset count9 = 1>
		</cfif>
	</cfloop>
	<cfif not IsDefined('count9')></cfif>
	
	
	<!--- PAGE 10 --->
	
	<cfloop query="page10">
		<cfset get_field = #page10.table_located# &"."& #page10.field_name#>
		<cfif Evaluate(get_field) EQ '' AND required EQ 1>
			
			<cfset count10 = 1> <cfset countred = countred + 1>
		<cfelseif Evaluate(get_field) EQ '' AND required EQ 0>
		
			<cfset count10 = 1>
		</cfif>
	</cfloop>
	<cfif check_10_upload.recordcount EQ 0>
		
		<cfset countred = countred + 1>
	</cfif>		
	<cfif not IsDefined('count10')></cfif>
	
	
	<!--- PAGE 11 --->
	
	<cfloop query="page11">
		<cfset get_field = #page11.table_located# &"."& #page11.field_name#>
		<cfif Evaluate(get_field) EQ '' AND required EQ 1>
		
			<cfset count11 = 1> <cfset countred = countred + 1>
		<cfelseif Evaluate(get_field) EQ '' AND required EQ 0>
		
			<cfset count11 = 1>
		</cfif>
	</cfloop>
	<cfif not IsDefined('count11')></cfif>
	

	<!--- PAGE 12 --->
	
	<cfloop query="page12">
		<cfset get_field = #page12.table_located# &"."& #page12.field_name#>
		<cfif Evaluate(get_field) EQ '' AND required EQ 1>
			
			<cfset count12 = 1> <cfset countred = countred + 1>
		<cfelseif Evaluate(get_field) EQ '' AND required EQ 0>
			
			<cfset count12 = 1>
		</cfif>
	</cfloop>
	<cfif check_12_upload.recordcount EQ 0>
		
		<cfset countred = countred + 1>
	</cfif>	
	<cfif not IsDefined('count12')></cfif>
	

	<!--- PAGE 13 --->
	
	<cfset lastvaccine = ''>
	<cfloop query="page13">
		<cfif lastvaccine NEQ #page13.field_label#>
			<cfquery name="smg_student_app_shots" datasource="MySql">
				SELECT vaccineid, studentid, vaccine, disease, shot1, shot2, shot3, shot4, shot5, booster  
				FROM smg_student_app_shots
				WHERE vaccine = '#page13.field_label#' AND studentid = <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
			</cfquery>
		</cfif>
		<cfset lastvaccine = #page13.field_label#>
		
		<cfset get_field = #page13.table_located# &"."& #page13.field_name#>
		<cfif Evaluate(get_field) EQ '' AND page13.required EQ 1>
			
			<cfset count13 = 1> <cfset countred = countred + 1>
		<cfelseif Evaluate(get_field) EQ '' AND page13.required EQ 0>
		
			<cfset count13 = 1> 
		</cfif>
	</cfloop>
	<cfif check_13_upload.recordcount EQ 0>
	
		<cfset countred = countred + 1>
	</cfif>		
	<cfif not IsDefined('count13')></cfif>
	

	<!--- PAGE 14 --->
	
	<cfloop query="page14">
		<cfset get_field = #page14.table_located# &"."& #page14.field_name#>
		<cfif Evaluate(get_field) EQ '' AND required EQ 1>
			
			<cfset count14 = 1> <cfset countred = countred + 1>
		<cfelseif Evaluate(get_field) EQ '' AND required EQ 0>
			
			<cfset count14 = 1>
		</cfif>
	</cfloop>
	<cfif check_14_upload.recordcount EQ 0>
		
		<cfset count14 = 1>
		<cfset countred = countred + 1>
	</cfif>	
	<cfif not IsDefined('count14')></cfif>
	
	
	<!--- PAGE 15 --->
	
	<cfif check_15_upload.recordcount EQ 0>
		
		<cfset countred = countred + 1> 
	<cfelse>
		
	</cfif>
		
	
	<!--- PAGE 16 --->
	
	<cfif check_16_upload.recordcount EQ 0>
		
		<cfset countred = countred + 1> 
	<cfelse>
		
	</cfif>
			

	<!--- PAGE 17 --->
	
	<cfif check_17_upload.recordcount EQ 0>
		
		<cfset countred = countred + 1> 
	<cfelse>
		
	</cfif>
	
	
	<!--- PAGE 18 --->
	
	<cfloop query="page18">
		<cfset get_field = #page18.table_located# &"."& #page18.field_name#>
		<cfif Evaluate(get_field) EQ '' AND required EQ 1>
			
			<cfset countred = countred + 1>
		<cfelseif Evaluate(get_field) GT 0 AND check_18_upload.recordcount EQ 0>
		
			<cfset countred = countred + 1> 
		<cfelseif (Evaluate(get_field) EQ 0) OR (Evaluate(get_field) GT 0 AND check_20_upload.recordcount NEQ 0)>
			
		</cfif>
	</cfloop> 


	<!--- PAGE 19 --->
	
	<!--- Intl. Representative Documents --->
	<cfif (client.usertype LTE 8 AND get_latest_status.status GT 2) OR (client.usertype EQ 11 AND get_latest_status.status GT 2)>
		<cfloop query="page19">
			<cfset get_field = #page19.table_located# &"."& #page19.field_name#>
			<cfif Evaluate(get_field) EQ '' AND required EQ 1>
				
				<cfset count19 = 1> <cfset countred = countred + 1>
			<cfelseif Evaluate(get_field) EQ '' AND required EQ 0>
				
				<cfset count19 = 1>
			</cfif>
		</cfloop>
		<cfif check_19_upload.recordcount NEQ 0>
			
		<cfelse>
			
		</cfif>
	<!--- Intl. Representative Documents --->				
	<cfelse>
		
	</cfif> 	
	<cfinclude template="get_student_info.cfm">	
		
	
	<!--- PAGE 20 --->
	
	<!--- Not Available in April or May - PROGRAM TYPES 1 = AYP 10 AUG / 2 = AYP 5 AUG / 3 = AYP 5 JAN / 4 = AYP 12 JAN --->
	
	<cfif (DateFormat(now(), 'mm') EQ 4 OR dateFormat(now(), 'mm') EQ 5) AND (get_student_info.app_indicated_program EQ 1 OR get_student_info.app_indicated_program EQ '2')> 
		
	<cfelse>
		<!--- HIDE GUARANTEE FOR EF AND INTERSTUDIES 8318 --->
		<cfif IsDefined('client.usertype') AND client.usertype EQ 10 AND (smg_students.master_accountid EQ 10115 OR smg_students.intrep EQ 10115 OR smg_students.intrep EQ 8318)>
			 
		<cfelse>
			<cfloop query="page20">
				<cfset get_field = #page20.table_located# &"."& #page20.field_name#>
				<cfif Evaluate(get_field) EQ '' AND required EQ 1>
					
					<cfset countred = countred + 1>
				<cfelseif Evaluate(get_field) GT 0 AND check_20_upload.recordcount EQ 0>
				
					<cfset countred = countred + 1> 
				<cfelseif (Evaluate(get_field) EQ 0) OR (Evaluate(get_field) GT 0 AND check_20_upload.recordcount NEQ 0)>
					
				</cfif>
			</cfloop> 
		</cfif>
	</cfif>
	

	<!--- PAGE 21 --->
	
	<!--- Not Available in April or May - PROGRAM TYPES 1 = AYP 10 AUG / 2 = AYP 5 AUG / 3 = AYP 5 JAN / 4 = AYP 12 JAN --->
	<cfif (DateFormat(now(), 'mm') EQ 4 OR dateFormat(now(), 'mm') EQ 5)<!---- AND (get_student_info.app_indicated_program EQ 1 OR get_student_info.app_indicated_program EQ '2')---->> 
		 
	<cfelse>
		<!--- HIDE GUARANTEE FOR EF AND INTERSTUDIES 8318 --->
		<cfif IsDefined('client.usertype') AND client.usertype EQ 10 AND (smg_students.master_accountid EQ 10115 OR smg_students.intrep EQ 10115 OR smg_students.intrep EQ 8318)>
			
		<cfelse>
			<!--- student has choosen state guarantee --->
			<cfif smg_student_app_state_requested.recordcount GT 0 AND smg_student_app_state_requested.state1 GT 0>
				<cfif check_21_upload.recordcount EQ 0>
						
						<cfset countred = countred + 1>
				<cfelse>
						
				</cfif>
			<!--- student has not choosen if accetps state guarantee --->
			<cfelseif smg_student_app_state_requested.recordcount EQ 0>
				<cfloop query="page21">
					<cfset get_field = #page21.table_located# &"."& #page21.field_name#>
					<cfif Evaluate(get_field) EQ '' AND required EQ 1>
						 
					</cfif>
				</cfloop>		
				<cfset countred = countred + 1>
			<cfelseif smg_student_app_state_requested.state1 EQ 0 AND smg_student_app_state_requested.state2 EQ 0 AND smg_student_app_state_requested.state3 EQ 0>
				
			</cfif>
		</cfif>
	</cfif>
	
	
	<!--- Application has been submitted --->

		<cfset client.countred = #countred#>
	
</cfoutput>

<!--- FOOTER OF TABLE --->


