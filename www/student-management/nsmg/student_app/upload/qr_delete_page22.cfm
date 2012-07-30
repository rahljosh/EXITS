<cfset directory = ExpandPath("../../uploadedFiles/virtualFolder/#form.studentid#/page22")>

<cffile action = "delete" file = "#directory#/#form.deletefile#">

<cfoutput>

	<script type="text/javascript">
    	alert("You have successfully deleted the #form.deletefile# file.");
        location.replace("../index.cfm?curdoc=section4/page22&id=4&p=22");
    </script>

</cfoutput>