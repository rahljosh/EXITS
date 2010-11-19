<cfif not IsDefined('form.studentid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<cftry>

<cftransaction action="begin" isolation="serializable">
		<!--- INSERT 9th SCHOOL YEAR --->
		<cfif IsDefined('form.new_9class')>
			<cfquery name="Insert_Year" datasource="MySql">
				INSERT INTO smg_student_app_school_year (studentid, beg_year, end_year, class_year)
				VALUES ('#form.studentid#', 
						<cfif form.new9_beg_year is ''>null,<cfelse>'#form.new9_beg_year#',</cfif>
						<cfif form.new9_end_year is ''>null,<cfelse>'#form.new9_end_year#',</cfif> '#form.new_9class#')
			</cfquery>
			<cfquery name="get_year" datasource="MySql">
				SELECT max(yearid) as yearid FROM smg_student_app_school_year
			</cfquery>
			<cfset form.new_9class_yearid = '#get_year.yearid#'>
		</cfif>
		<!--- INSERT 9th CLASSES UP TO 13 PER TIME --->
		<cfif IsDefined('form.new_9class_count') and form.new_9class_yearid NEQ '0'>
			<cfloop From = "1" To = "#form.new_9class_count#" Index = "x">
				<cfif form["new_9class_name" & x] NEQ ''>
					<cfquery name="insert_classes" datasource="MySQL">
						INSERT INTO smg_student_app_grades(yearid, class_name, hours, grade)
						VALUES ('#form.new_9class_yearid#', '#form["new_9class_name" & x]#',
								'#form["new_9class_hour" & x]#', '#form["new_9class_grade" & x]#')
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
		<!--- UPDATE 9th YEAR --->
		<cfif IsDefined('form.upd_9yearid')>
			<cfquery name="update_year" datasource="MySql">
				UPDATE smg_student_app_school_year
				SET beg_year = <cfif form.upd9_beg_year is ''>null,<cfelse>#form.upd9_beg_year#,</cfif>
					end_year = <cfif form.upd9_end_year is ''>null,<cfelse>#form.upd9_end_year#,</cfif>
					class_year = '#upd_9class#'
				WHERE yearid = '#upd_9yearid#'
				LIMIT 1				
			</cfquery>
		</cfif>
		<!--- UPDATE 9th CLASSES --->
		<cfif IsDefined('form.upd_9class_count')>
			<cfloop from="1" to="#form.upd_9class_count#" index="x">
				<cfquery name="update_classes" datasource="MySQL">
					UPDATE smg_student_app_grades
					SET class_name = '#form["upd_9class_name" & x]#', 
						hours = '#form["upd_9class_hour" & x]#',			
						grade = '#form["upd_9class_grade" & x]#'
					WHERE gradesid = '#form["upd_9class_gradesid" & x]#' 
					LIMIT 1 
				</cfquery>
			</cfloop>
		</cfif>
		

		<!--- INSERT 10th SCHOOL YEAR --->
		<cfif IsDefined('form.new_10class')>
			<cfquery name="Insert_Year" datasource="MySql">
				INSERT INTO smg_student_app_school_year (studentid, beg_year, end_year, class_year)
				VALUES ('#form.studentid#', 
						<cfif form.new10_beg_year is ''>null,<cfelse>'#form.new10_beg_year#',</cfif>
						<cfif form.new10_end_year is ''>null,<cfelse>'#form.new10_end_year#',</cfif> '#form.new_10class#')
			</cfquery>
			<cfquery name="get_year" datasource="MySql">
				SELECT max(yearid) as yearid FROM smg_student_app_school_year
			</cfquery>
			<cfset form.new_10class_yearid = '#get_year.yearid#'>
		</cfif>
		<!--- INSERT 10th CLASSES UP TO 13 PER TIME --->
		<cfif IsDefined('form.new_10class_count')>
			<cfloop From = "1" To = "#form.new_10class_count#" Index = "x">
				<cfif form["new_10class_name" & x] NEQ ''>
					<cfquery name="insert_classes" datasource="MySQL">
						INSERT INTO smg_student_app_grades(yearid, class_name, hours, grade)
						VALUES ('#form.new_10class_yearid#', '#form["new_10class_name" & x]#',
								'#form["new_10class_hour" & x]#', '#form["new_10class_grade" & x]#')
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
		<!--- UPDATE 10th YEAR --->
		<cfif IsDefined('form.upd_10yearid')>
			<cfquery name="update_year" datasource="MySql">
				UPDATE smg_student_app_school_year
				SET beg_year = <cfif form.upd10_beg_year is ''>null,<cfelse>#form.upd10_beg_year#,</cfif>
					end_year = <cfif form.upd10_end_year is ''>null,<cfelse>#form.upd10_end_year#,</cfif>
					class_year = '#upd_10class#'
				WHERE yearid = '#upd_10yearid#'
				LIMIT 1				
			</cfquery>
		</cfif>
		<!--- UPDATE 10th CLASSES --->
		<cfif IsDefined('form.upd_10class_count')>
			<cfloop from="1" to="#form.upd_10class_count#" index="x">
				<cfquery name="update_classes" datasource="MySQL">
					UPDATE smg_student_app_grades
					SET class_name = '#form["upd_10class_name" & x]#', 
						hours = '#form["upd_10class_hour" & x]#',
						grade = '#form["upd_10class_grade" & x]#'
					WHERE gradesid = '#form["upd_10class_gradesid" & x]#' 
					LIMIT 1 
				</cfquery>
			</cfloop>
		</cfif>


		<!--- INSERT 11th SCHOOL YEAR --->
		<cfif IsDefined('form.new_11class')>
			<cfquery name="Insert_Year" datasource="MySql">
				INSERT INTO smg_student_app_school_year (studentid, beg_year, end_year, class_year)
				VALUES ('#form.studentid#', 
						<cfif form.new11_beg_year is ''>null,<cfelse>'#form.new11_beg_year#',</cfif>
						<cfif form.new11_end_year is ''>null,<cfelse>'#form.new11_end_year#',</cfif> '#form.new_11class#')
			</cfquery>
			<cfquery name="get_year" datasource="MySql">
				SELECT max(yearid) as yearid FROM smg_student_app_school_year
			</cfquery>
			<cfset form.new_11class_yearid = '#get_year.yearid#'>
		</cfif>
		<!--- INSERT 11th CLASSES UP TO 13 PER TIME --->
		<cfif IsDefined('form.new_11class_count')>
			<cfloop From = "1" To = "#form.new_11class_count#" Index = "x">
				<cfif form["new_11class_name" & x] NEQ ''>
					<cfquery name="insert_classes" datasource="MySQL">
						INSERT INTO smg_student_app_grades(yearid, class_name, hours, grade)
						VALUES ('#form.new_11class_yearid#', '#form["new_11class_name" & x]#',
								'#form["new_11class_hour" & x]#', '#form["new_11class_grade" & x]#')
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
		<!--- UPDATE 11th YEAR --->
		<cfif IsDefined('form.upd_11yearid')>
			<cfquery name="update_year" datasource="MySql">
				UPDATE smg_student_app_school_year
				SET beg_year = <cfif form.upd11_beg_year is ''>null,<cfelse>#form.upd11_beg_year#,</cfif>
					end_year = <cfif form.upd11_end_year is ''>null,<cfelse>#form.upd11_end_year#,</cfif>
					class_year = '#upd_11class#'
				WHERE yearid = '#upd_11yearid#'
				LIMIT 1				
			</cfquery>
		</cfif>
		<!--- UPDATE 11th CLASSES --->
		<cfif IsDefined('form.upd_11class_count')>
			<cfloop from="1" to="#form.upd_11class_count#" index="x">
				<cfquery name="update_classes" datasource="MySQL">
					UPDATE smg_student_app_grades
					SET class_name = '#form["upd_11class_name" & x]#', 
						hours = '#form["upd_11class_hour" & x]#',
						grade = '#form["upd_11class_grade" & x]#'
					WHERE gradesid = '#form["upd_11class_gradesid" & x]#' 
					LIMIT 1 
				</cfquery>
			</cfloop>
		</cfif>


		<!--- INSERT 12th SCHOOL YEAR --->
		<cfif IsDefined('form.new_12class')>
			<cfquery name="Insert_Year" datasource="MySql">
				INSERT INTO smg_student_app_school_year (studentid, beg_year, end_year, class_year)
				VALUES ('#form.studentid#', 
						<cfif form.new12_beg_year is ''>null,<cfelse>'#form.new12_beg_year#',</cfif>
						<cfif form.new12_end_year is ''>null,<cfelse>'#form.new12_end_year#',</cfif> '#form.new_12class#')
			</cfquery>
			<cfquery name="get_year" datasource="MySql">
				SELECT max(yearid) as yearid FROM smg_student_app_school_year
			</cfquery>
			<cfset form.new_12class_yearid = '#get_year.yearid#'>
		</cfif>
		<!--- INSERT 12th CLASSES UP TO 13 PER TIME --->
		<cfif IsDefined('form.new_12class_count')>
			<cfloop From = "1" To = "#form.new_12class_count#" Index = "x">
				<cfif form["new_12class_name" & x] NEQ ''>
					<cfquery name="insert_classes" datasource="MySQL">
						INSERT INTO smg_student_app_grades(yearid, class_name, hours, grade)
						VALUES ('#form.new_12class_yearid#', '#form["new_12class_name" & x]#',
								'#form["new_12class_hour" & x]#', '#form["new_12class_grade" & x]#')
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
		<!--- UPDATE 12th YEAR --->
		<cfif IsDefined('form.upd_12yearid')>
			<cfquery name="update_year" datasource="MySql">
				UPDATE smg_student_app_school_year
				SET beg_year = <cfif form.upd12_beg_year is ''>null,<cfelse>#form.upd12_beg_year#,</cfif>
					end_year = <cfif form.upd12_end_year is ''>null,<cfelse>#form.upd12_end_year#,</cfif>
					class_year = '#upd_12class#'
				WHERE yearid = '#upd_12yearid#'
				LIMIT 1				
			</cfquery>
		</cfif>
		<!--- UPDATE 12th CLASSES --->
		<cfif IsDefined('form.upd_12class_count')>
			<cfloop from="1" to="#form.upd_12class_count#" index="x">
				<cfquery name="update_classes" datasource="MySQL">
					UPDATE smg_student_app_grades
					SET class_name = '#form["upd_12class_name" & x]#', 
						hours = '#form["upd_12class_hour" & x]#',
						grade = '#form["upd_12class_grade" & x]#'
					WHERE gradesid = '#form["upd_12class_gradesid" & x]#' 
					LIMIT 1 
				</cfquery>
			</cfloop>
		</cfif>

		<html>
		<head>
		<script language="JavaScript">
		<!-- 
		alert("You have successfully updated this page. Thank You.");
		<cfif NOT IsDefined('url.next')>
			location.replace("?curdoc=section2/page8&id=2&p=8");
		<cfelse>
			location.replace("?curdoc=section2/page9&id=2&p=9");
		</cfif>
		//-->
		</script>
		</head>
		</html>

</cftransaction>

	<cfcatch type="any">
		<cfinclude template="../email_error.cfm">
	</cfcatch>
</cftry>