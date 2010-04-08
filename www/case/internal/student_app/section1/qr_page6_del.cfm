<cftransaction action="begin" isolation="serializable">

<cftry>

<cfquery name="delete_letter" datasource="caseusa">
	UPDATE smg_students
	SET familyletter = ''
	WHERE studentid = #client.studentid#	
</cfquery>

<html>
<head>
<script language="JavaScript">
<!-- 
alert("You have successfully deleted the parent's letter.");
	location.replace("?curdoc=section1/page6&id=1&p=6");
//-->
</script>
</head>
</html>

	<cfcatch type="any">
		<cfinclude template="../email_error.cfm">
	</cfcatch>
</cftry>

</cftransaction>
