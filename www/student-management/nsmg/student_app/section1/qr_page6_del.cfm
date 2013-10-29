<cftransaction action="begin" isolation="serializable">

<cfquery name="delete_letter" datasource="#APPLICATION.DSN#">
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

</cftransaction>
