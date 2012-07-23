<cffile action = "delete" file = "#AppPath.onlineApp.picture##url.student#">

<cfoutput>
	<script type="text/javascript">
    	alert("You have successfully deleted the picture for this student.");
		window.location.href = '../nsmg/index.cfm?curdoc=student_info&studentID=#url.studentID#';
    </script>
</cfoutput>