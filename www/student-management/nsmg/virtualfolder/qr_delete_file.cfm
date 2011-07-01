<cftry>

	<cfif NOT IsDefined("form.DeleteFile") AND NOT IsDefined('form.directory') AND NOT IsDefined('form.unqid')>
		<cfinclude template="error_message.cfm">
		<cfabort>
	</cfif>

	<cfquery name="get_student_info" datasource="MySql">
		SELECT studentid
		FROM smg_students
		WHERE uniqueid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.unqid#">
	</cfquery>

	<cffile action = "delete" file = "#form.directory#/#form.DeleteFile#">
	
	<cfquery name="delete_category" datasource="MySql">
		DELETE FROM smg_virtualfolder
		WHERE studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student_info.studentid#">
			AND filename = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DeleteFile#">
			AND filesize = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.filesize#">
	</cfquery>

    <cfscript>
        // Set Page Message
        SESSION.pageMessages.Add("You have successfully deleted the file #form.DeleteFile# from this Virtual Folder.");
        Location("list_vfolder.cfm?unqid=#FORM.unqid#", "no");
    </cfscript>

    <cfcatch type="any">
        <cfinclude template="error_message.cfm">
    </cfcatch>

</cftry>
