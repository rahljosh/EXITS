<cfquery name="update_student" datasource="MySql">
		UPDATE smg_students
		SET	
			<!----Set from page 7 of XML Applciation---->
			app_school_name = '#StudentXMLFile.applications.application[i].page7.nameofschool.XmlText#',
			grades = '#StudentXMLFile.applications.application[i].page7.applicantisenrolledingrade.XmlText#',
			app_school_person = '#StudentXMLFile.applications.application[i].page7.schoolofficial.name.XmlText#',
			convalidation_needed = 'no',
					<!----	Set from page 8 of XML Application---->
			
			
			app_school_type = 'Public',
			app_grade_1 = 1,
			app_grade_1_com = 'Sehr Gut',
			app_grade_2 = '/',
			app_grade_2_com = '/',
			app_grade_3 = 2,
			app_grade_3_com = 'Gut',
			app_grade_4 = 2,
			app_grade_4_com = 'Gut',
			app_grade_5 = 3,
			app_grade_5_com = 'Befriedigend',		
			app_grade_6 = '/',
			app_grade_6_com = '/',
			app_grade_7 = 4,
			app_grade_7_com = 'Genuegend',
			app_grade_8 = 5,
			app_grade_8_com = 'Nicht genuegend'
			<!----
			<cfif IsDefined('form.app_completed_school')>app_completed_school = '#form.app_completed_school#',</cfif>			
			
			app_extra_courses = <cfqueryparam value="#form.app_extra_courses#" cfsqltype="cf_sql_varchar">---->
		WHERE studentid = #client.studentid#
		LIMIT 1
	</cfquery>