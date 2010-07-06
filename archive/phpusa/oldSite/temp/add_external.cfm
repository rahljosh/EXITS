<cfquery name="ext_school_info" datasource="php">
select *
from school
</cfquery>


<cfloop query="ext_school_info">

	<cfquery name="update_internal" datasource="mysql">
	update schools
	set ext_school_type = '#school_type#',
		exact_tuition = #school_year_price#,
		ext_school_grade_offer = '#school_grade_offer#',
		ext_school_religion = '#school_religious#',
		ext_school_number_students = <cfif school_number_stu is ''>0<Cfelse>#school_number_stu#</cfif> ,
		ext_school_int_students = <cfif school_number_intl_Stu is ''>0<Cfelse>#school_number_intl_stu#</cfif>,
		ext_ratio = <cfif school_teacher_ratio is ''>0<Cfelse>'#school_teacher_ratio#'</cfif>,
		ext_uniform = <cfif school_uniform is 'no'>0<cfelse>1</cfif>,
		ext_esl = <cfif school_esl is 'no' or school_esl is ''>0<cfelse>1</cfif>,
		ext_school_about = '#school_about#',
		ext_school_location = '#school_location#',
		ext_courses = '#school_courses#',
		ext_dress_code = '#school_dress_code#',
		ext_housing = '#school_housing#',
		ext_athletics = '#school_athletics#',
		ext_sat = <cfif school_sat is ''>0<Cfelse>#school_sat#</cfif>
	where name = '#school_name#'
	</cfquery>
</cfloop>