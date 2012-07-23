<cfif url.insert eq 1>
	<cfquery name="add_description" datasource="MySQL">
		UPDATE
        	smg_student_app_family_album
       	SET
        	description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.pic_description#">
      	WHERE
        	filename = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.img#">
      	AND
        	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.studentID#">
	</cfquery>
<cfelse>
	<cfquery name="add_description" datasource="MySQL">
    	INSERT INTO
        	smg_student_app_family_album
            (
            	description,
                filename,
                studentID
         	)
      	VALUES
        	(
            	<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.pic_description#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.img#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.studentID#">
            )
	</cfquery>
</cfif>

<cflocation url="reload_window.cfm">