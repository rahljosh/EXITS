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
			app_teacher_name = 'Einschatzer',
			app_teacher_school = 'Bewerber Stelle',
			app_teacher_address = 'Ostlandstrasse 14',
			app_teacher_phone = '492234946360',
			app_interview_date = '2008-11-30',
			app_evaluation_date = '2008-11-30',
			<!---Religious Participation---->
			religious_participation = '#StudentXMLFile.applications.application[i].page2.religion.howoftenattendchurch.XmlText#'
		WHERE studentid = #client.studentid#
		LIMIT 1
	</cfquery>
	
