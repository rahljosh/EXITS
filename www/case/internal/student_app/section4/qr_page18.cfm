<cfif not IsDefined('form.studentid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<cftransaction action="begin" isolation="serializable">
	<cftry>

	<cfif IsDefined('form.privateschool')>
		<cfquery name="update_student" datasource="caseusa">
			UPDATE smg_students
			SET	<cfif form.privateschool EQ '0'>
					privateschool = 0
				<!--- TUITION RANGE --->
				<cfelseif form.privateschool EQ 1 AND form.tuitionprivateschool NEQ 0>
					privateschool = '#form.tuitionprivateschool#'
				<cfelseif form.privateschool EQ 5>
					privateschool = '#form.privateschool#'
				<cfelse>
					privateschool = NULL
				</cfif>
				<!--- Three Choices of School --->
			WHERE studentid = '#form.studentid#'
			LIMIT 1
		</cfquery>
	</cfif>

		<html>
		<head>
		<script language="JavaScript">
		<!-- 
		alert("You have successfully updated this page. Thank You.");
		<cfif NOT IsDefined('url.next')>
			location.replace("?curdoc=section4/page18&id=4&p=18");
		<cfelse>
			location.replace("?curdoc=section4/page19&id=4&p=19");
		</cfif>
		-->
		</script>
		</head>
		</html> 		
		
	<cfcatch type="any">
		<cfinclude template="../email_error.cfm">
	</cfcatch>
	</cftry>

</cftransaction>
