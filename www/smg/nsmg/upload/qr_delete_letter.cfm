<cfdirectory directory="#AppPath.onlineApp.letters##url.type#" name="file" filter="#url.student#.*">	

<cffile action="delete" file="#AppPath.onlineApp.letters##url.type#/#file.name#">

<cfoutput>

	<script language="JavaScript">
		<!-- 
		alert("You have successfully deleted the uploaded file.");
			location.replace("#AppPath.onlineApp.URL#index.cfm?curdoc=#url.ref#&id=#url.id#&p=#url.p#");
		//-->
    </script>
    
</cfoutput>
