<cffile action = "delete" file = "#AppPath.onlineApp.picture##url.student#">

<cfoutput>
<script language="JavaScript">
<!-- 
alert("You have successfully deleted the picture for this student.");
	location.replace("?curdoc=student_info&studentid=#url.studentid#");
-->
</script>
</cfoutput>

<!----

<cffile action="rename" destination="#AppPath.onlineApp.picture##url.student#_delete" source="#AppPath.onlineApp.picture##url.student#"> 
<cflocation url="index.cfm?curdoc=student_info&studentid=#url.studentid#">

---->