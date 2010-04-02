<cftry>

    <cfdirectory directory="#AppPath.onlineApp.inserts##url.doc#" name="file" filter="#url.studentid#.*">	
    
    <cffile action="delete" file="#AppPath.onlineApp.inserts##url.doc#/#file.name#">

    <cfoutput>
    
		<script language="JavaScript">
			<!-- 
			alert("You have successfully deleted the uploaded file.");
				location.replace("#AppPath.onlineApp.URL#index.cfm?curdoc=#url.ref#&id=#url.id#&p=#url.p#");
			//-->
        </script>

	</cfoutput>
    
    <cfcatch type="any">
        <cfinclude template="error_message.cfm">	
    </cfcatch>

</cftry>	
