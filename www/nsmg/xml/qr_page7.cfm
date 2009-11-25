<cfquery name="default_grade_conv" datasource="MySQL">

		UPDATE smg_students
		SET
			
				<!----A+---->
				app_grade_1 = 'n/a',
				app_grade_1_com = 'n/a',
			
				<!----A---->
				app_grade_2 = 'n/a',
				app_grade_2_com = 'n/a',
			
			<!----A- or B+---->
			app_grade_3 = 'n/a',
			app_grade_3_com = 'n/a',
			
			<!----B or B+---->
			app_grade_4 = 'n/a',
			app_grade_4_com = 'n/a',
			
			app_grade_5 = 'n/a',
			app_grade_5_com = 'n/a',	
			
			<!----C- ---->
			app_grade_6 = 'n/a',
			app_grade_6_com = 'n/a',

			<!----D ---->
			app_grade_7 = 'n/a',
			app_grade_7_com = 'n/a',
			
			<!----F ---->
			app_grade_8 = 'n/a',
			app_grade_8_com = 'n/a'
			
		WHERE studentid = #client.studentid#
</cfquery>

<!----Set up for looping grade conversion---->
<cfset num_grade_list = ArrayLen(#StudentXMLFile.applications.application[i].page8.nationalgrading.grade#)>
<cfloop from="1" to="#num_grade_list#" index="country_grade">


<cfquery name="grade_conversion" datasource="mysql">

		UPDATE smg_students
		SET
			<cfif '#StudentXMLFile.applications.application[i].page8.nationalgrading.grade[country_grade].xmltext#' is 'A+'>
				<!----A+---->
				app_grade_1 = '#StudentXMLFile.applications.application[i].page8.nationalgrading.countrygrade[country_grade].xmltext#',
				app_grade_1_com = '#StudentXMLFile.applications.application[i].page8.nationalgrading.definition[country_grade].xmltext#'
			<cfelseif '#StudentXMLFile.applications.application[i].page8.nationalgrading.grade[country_grade].xmltext#' is 'A'>
				<!----A---->
				app_grade_2 = '#StudentXMLFile.applications.application[i].page8.nationalgrading.countrygrade[country_grade].xmltext#',
				app_grade_2_com = '#StudentXMLFile.applications.application[i].page8.nationalgrading.definition[country_grade].xmltext#'
			<cfelseif '#StudentXMLFile.applications.application[i].page8.nationalgrading.grade[country_grade].xmltext#' is 'A-'
						or '#StudentXMLFile.applications.application[i].page8.nationalgrading.grade[country_grade].xmltext#' is 'B+'>
			<!----A- or B+---->
			app_grade_3 = '#StudentXMLFile.applications.application[i].page8.nationalgrading.countrygrade[country_grade].xmltext#',
			app_grade_3_com = '#StudentXMLFile.applications.application[i].page8.nationalgrading.definition[country_grade].xmltext#'
			<cfelseif '#StudentXMLFile.applications.application[i].page8.nationalgrading.grade[country_grade].xmltext#' is 'B'
						or '#StudentXMLFile.applications.application[i].page8.nationalgrading.grade[country_grade].xmltext#' is 'B-'>
			<!----B or B+---->
			app_grade_4 = '#StudentXMLFile.applications.application[i].page8.nationalgrading.countrygrade[country_grade].xmltext#',
			app_grade_4_com = '#StudentXMLFile.applications.application[i].page8.nationalgrading.definition[country_grade].xmltext#'
			<cfelseif '#StudentXMLFile.applications.application[i].page8.nationalgrading.grade[country_grade].xmltext#' is 'C'>
			<!----C---->
			app_grade_5 = '#StudentXMLFile.applications.application[i].page8.nationalgrading.countrygrade[country_grade].xmltext#',
			app_grade_5_com = '#StudentXMLFile.applications.application[i].page8.nationalgrading.definition[country_grade].xmltext#'		
			<cfelseif '#StudentXMLFile.applications.application[i].page8.nationalgrading.grade[country_grade].xmltext#' is 'C-'>
			<!----C- ---->
			app_grade_6 = '#StudentXMLFile.applications.application[i].page8.nationalgrading.countrygrade[country_grade].xmltext#',
			app_grade_6_com = '#StudentXMLFile.applications.application[i].page8.nationalgrading.definition[country_grade].xmltext#'
			<cfelseif '#StudentXMLFile.applications.application[i].page8.nationalgrading.grade[country_grade].xmltext#' is 'D'>
			<!----D ---->
			app_grade_7 = '#StudentXMLFile.applications.application[i].page8.nationalgrading.countrygrade[country_grade].xmltext#',
			app_grade_7_com = '#StudentXMLFile.applications.application[i].page8.nationalgrading.definition[country_grade].xmltext#'
			<cfelseif '#StudentXMLFile.applications.application[i].page8.nationalgrading.grade[country_grade].xmltext#' is 'F'>
			<!----F ---->
			app_grade_8 = '#StudentXMLFile.applications.application[i].page8.nationalgrading.countrygrade[country_grade].xmltext#',
			app_grade_8_com = '#StudentXMLFile.applications.application[i].page8.nationalgrading.definition[country_grade].xmltext#'
			</cfif>
		WHERE studentid = #client.studentid#
</cfquery>
</cfloop>
<cfquery name="update_student" datasource="MySql">
		UPDATE smg_students
		SET	
			<!----Set from page 7 of XML Applciation---->
			app_school_name = '#StudentXMLFile.applications.application[i].page7.nameofschool.XmlText#',
			grades = '#StudentXMLFile.applications.application[i].page7.applicantisenrolledingrade.XmlText#',
			app_school_person = '#StudentXMLFile.applications.application[i].page7.schoolofficial.name.XmlText#',
			<cfif client.userid eq 9106>
			app_school_add = 'Na Výsluní 13,100 00 Praha 10, Czech Republic',
			app_school_phone = '+00420-233 322 991',
			<cfelseif client.userid eq 20>
			app_school_add = 'Ostlandstrasse 14, 50858 Cologne, Germany',
			app_school_phone = '+49 2234 946360',
			<cfelseif client.userid eq 115>
			app_school_add = "Victorialaan 15, 5213 JG 's-Hertogenbosch, The Netherlands",
			app_school_phone = '+31 73 594 1435',
			<cfelseif client.userid eq 28>
			app_school_add = 'Horlaubenstrasse 2c, CH-7260 Davos Dorf, Switzerland',
			app_school_phone = '+0041-81-410 30 30',
			<cfelseif client.userid eq 109>
			app_school_add = 'Kanizsai u. 4/C., 1114 Budapest, Hungary',
			app_school_phone = '+36 1 427 1339',
			<cfelseif client.userid eq 21>
			app_school_add = 'Waehringer Strasse 145/15, 1180 Wien, Austria',
			app_school_phone = '+43-1-478-75 15',
			</cfif>
			convalidation_needed = 'no',
			
			
					<!----	Set from page 8 of XML Application---->
			
			
			app_school_type = 'Public'
			
			<!----
			<cfif IsDefined('form.app_completed_school')>app_completed_school = '#form.app_completed_school#',</cfif>			
			
			app_extra_courses = <cfqueryparam value="#form.app_extra_courses#" cfsqltype="cf_sql_varchar">---->
		WHERE studentid = #client.studentid#
		LIMIT 1
	</cfquery>