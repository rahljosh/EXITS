	<cfset newletter = #Replace(StudentXMLFile.applications.application[i].page3.studentlettertohostfamily,"#chr(10)#","<br>","all")#>
	
	<cfquery name="insert_typed_letter" datasource="mysql">
		UPDATE smg_students
			SET letter = <cfqueryparam value = "#newletter#" cfsqltype="cf_sql_longvarchar">
		WHERE studentid = #client.studentid#
	</cfquery>