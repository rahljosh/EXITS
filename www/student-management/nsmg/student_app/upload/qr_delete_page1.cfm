<cfset directory = ExpandPath('../../uploadedFiles/web-students/')>

<cfdirectory directory="#directory#" name="file" filter="#url.studentid#.*">	

<cffile action="delete" file="#directory##file.name#">

<cfoutput>

	<script type="text/javascript">
		alert("You have successfully deleted the passport photo.");
			location.replace("../index.cfm?curdoc=section1/page1&id=1&p=1");
	</script>

</cfoutput>