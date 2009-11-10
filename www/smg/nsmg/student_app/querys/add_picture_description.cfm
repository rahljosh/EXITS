<cfif url.insert eq 1>
	<cfquery name="add_description" datasource="MySQL">
		update smg_student_app_family_album
		set description = '#form.pic_description#'
		where filename = '#url.img#' and studentid = #client.studentid#	
	</cfquery>
<cfelse>
	<cfquery name="add_description" datasource="MySQL">
		insert into  smg_student_app_family_album (description, filename, studentid)
			values( '#form.pic_description#' , '#url.img#', #client.studentid#	)
	
	</cfquery>
</cfif>

<cflocation url="reload_window.cfm">