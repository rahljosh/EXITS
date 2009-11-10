<!--- get reps for students region --->
<cfquery name="get_available_reps" datasource="MySQL">
	Select * from smg_users 
	INNER JOIN user_access_rights uar ON uar.userid = smg_users.userid
	WHERE smg_users.active = '1' 
		  AND uar.regionid = '#get_student_info.regionassigned#'
	      AND uar.usertype between '5' and '7'
	ORDER BY lastname
</cfquery>