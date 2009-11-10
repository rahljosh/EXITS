	<cfquery name="update_student" datasource="MySql">
		UPDATE smg_students
		SET	app_reading_skills = 'Good',
			app_writing_skills = 'Good',
			app_verbal_skills =  'Good', 
			app_social_skills1 = 'Good',
			app_social_skills2 = 'Good',
			app_social_skills3 = 'Good',
			app_social_skills4 = 'Good',
			app_social_skills5 = 'Good',
			app_social_skills6 = 'Good',
			app_social_reason = 'Well motivated to get to know other cultures.',
			app_teacher_name = '#StudentXMLFile.applications.application[i].page7.schoolofficial.name.XmlText#',
			app_teacher_school = '#StudentXMLFile.applications.application[i].page7.nameofschool.XmlText#',
		
		
			<cfif client.userid eq 9106>
			app_teacher_address = 'Na Výsluní 13,100 00 Praha 10, Czech Republic',
			app_teacher_phone = '+00420-233 322 991',
			<cfelseif client.userid eq 20>
			app_teacher_address = 'Ostlandstrasse 14, 50858 Cologne, Germany',
			app_teacher_phone = '+49 2234 946360',
			<cfelseif client.userid eq 115>
			app_teacher_address = "Victorialaan 15, 5213 JG 's-Hertogenbosch, The Netherlands",
			app_teacher_phone = '+31 73 594 1435',
			<cfelseif client.userid eq 28>
			app_teacher_address = 'Horlaubenstrasse 2c, CH-7260 Davos Dorf, Switzerland',
			app_teacher_phone = '+0041-81-410 30 30',
			<cfelseif client.userid eq 109>
			app_teacher_address = 'Kanizsai u. 4/C., 1114 Budapest, Hungary',
			app_teacher_phone = '+36 1 427 1339',
			<cfelseif client.userid eq 21>
			app_teacher_address = 'Waehringer Strasse 145/15, 1180 Wien, Austria',
			app_teacher_phone = '+43-1-478-75 15',
			</cfif>
			app_interview_date = #now()#,
			app_evaluation_date = #now()#
			
			
		WHERE studentid = #client.studentid#
		LIMIT 1
	</cfquery>
	
