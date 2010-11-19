<cfif not IsDefined('form.studentid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<cftransaction action="begin" isolation="serializable">

<cftry>

	<cfset newletter = #Replace(form.familyletter,"#chr(10)#","<br>","all")#>
	
	<cfquery name="insert_typed_letter" datasource="mysql">
		UPDATE smg_students
			SET familyletter = <cfqueryparam value = "#newletter#" cfsqltype="cf_sql_longvarchar">
		WHERE studentid = #client.studentid#
	</cfquery>

	<html>
	<head>
	<script language="JavaScript">
	<!-- 
	alert("You have successfully updated this page. Thank You.");
	<cfif NOT IsDefined('url.next')>
		location.replace("?curdoc=section1/page6&id=1&p=6");
	<cfelse>
		location.replace("?curdoc=section2&id=2");
	</cfif>
	//-->
	</script>
	</head>
	</html>
		
	<cfcatch type="any">
		<cfinclude template="../email_error.cfm">
	</cfcatch>
</cftry>

</cftransaction>