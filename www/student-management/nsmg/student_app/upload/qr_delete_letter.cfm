<cfset directory = ExpandPath('../../uploadedFiles/letters/')>

<cfdirectory directory="#directory##url.type#" name="file" filter="#url.student#.*">	
<cffile action="delete" file="#directory##url.type#/#file.name#">

<cfoutput>

	<script type="text/javascript">
		alert("You have successfully deleted the uploaded file.");
		location.replace("../index.cfm?curdoc=#url.ref#&id=#url.id#&p=#url.p#");
    </script>
    
</cfoutput>
