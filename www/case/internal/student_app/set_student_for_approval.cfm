<cfif isDefined('url.unqid')>
	<cfquery name="get_student_id" datasource="caseusa">
	select studentid from smg_students
	where uniqueid = '#url.unqid#'
	</cfquery>
</cfif>

<cfset client.studentid = #get_student_id.studentid#>

<cflocation url="index.cfm?curdoc=section1/page1&id=1&p=1" addtoken="no">