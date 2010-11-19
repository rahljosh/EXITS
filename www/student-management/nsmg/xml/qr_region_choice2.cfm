<cfif #StudentXMLFile.applications.application[i].page1.program.regionalwishusa.xmltext# is ''>
	<cfquery name="update_student" datasource="MySql">
			UPDATE smg_students
			SET	app_region_guarantee = 0
				WHERE studentid = '#client.studentid#'
			LIMIT 1
		</cfquery>
<cfelse>

	<cfquery name="get_region" datasource="MySQL">
	select regionid from smg_regions
	where regionname = '#StudentXMLFile.applications.application[i].page1.program.regionalwishusa.xmltext#'
	limit 1
	</cfquery>
	<cfif get_region.recordcount gt 0>
	<cfquery name="update_student" datasource="MySql">
			UPDATE smg_students
			SET	app_region_guarantee = #get_region.regionid#
			WHERE studentid = '#client.studentid#'
			LIMIT 1
	</cfquery>
	</cfif>
</cfif>
