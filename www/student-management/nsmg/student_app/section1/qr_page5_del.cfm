<cftransaction action="begin" isolation="serializable">

<cfquery name="delete_letter" datasource="#APPLICATION.DSN#">
	UPDATE smg_students
	SET letter = ''
	WHERE studentid = #client.studentid#	
</cfquery>

<html>
<head>
<script language="JavaScript">
<!-- 
alert("You have successfully deleted the student's letter.");
	location.replace("?curdoc=section1/page5&id=1&p=5");
//-->
</script>
</head>
</html>

</cftransaction>
