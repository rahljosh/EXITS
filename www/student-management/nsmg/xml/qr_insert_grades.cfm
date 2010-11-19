

<!----Determine the number of classes to enter for a given year---->
<cfset countyearsdef =ArrayLen(#StudentXMLFile.applications.application[i].page8.courseslasttwoyears.year#)>
<cfloop from="1" to=#countyearsdef# index="countyears">

<!----Set class year---->
<cfif countyears is 1>
	<cfset class_year = '9th'>
<cfelse>
	<cfset class_year = '10th'>
</cfif>
	
	
<!----Insert Year of classes---->
			<cfquery name="Insert_Year" datasource="MySql">
				INSERT INTO smg_student_app_school_year (studentid, beg_year, end_year, class_year)
				VALUES (#client.studentid#, '20#StudentXMLFile.applications.application[1].page8.courseslasttwoyears.year[countyears].yearfrom.xmltext#',
'20#StudentXMLFile.applications.application[1].page8.courseslasttwoyears.year[countyears].yearto.xmltext#','#class_year#')
			</cfquery>
			<!----Get ID to link up to classes and grades query gets the last line entered into to DB.---->
			<cfquery name="get_year" datasource="MySql">
				SELECT max(yearid) as yearid FROM smg_student_app_school_year
			</cfquery>
			<cfset yearid = #get_year.yearid#>
			<!----Insert Grades---->
<cfset countsubjects = ArrayLen(#StudentXMLFile.applications.application[i].page8.courseslasttwoyears.year[countyears].subject#)>
	<cfloop from="1" to=#countsubjects# index="subjects">
	<cfquery name="insert_classes" datasource="MySQL">
						INSERT INTO smg_student_app_grades(yearid, class_name, hours, grade)
						VALUES (#yearid#, '#StudentXMLFile.applications.application[1].page8.courseslasttwoyears.year[countyears].subject[subjects].xmltext#',
								'#StudentXMLFile.applications.application[1].page8.courseslasttwoyears.year[countyears].hoursweek[subjects].xmltext#', '#StudentXMLFile.applications.application[1].page8.courseslasttwoyears.year[countyears].finalgrade[subjects].xmltext#')
					</cfquery>
	</cfloop>
</cfloop>