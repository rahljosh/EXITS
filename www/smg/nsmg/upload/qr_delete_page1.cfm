<cftry>
    
    <cfdirectory directory="#AppPath.onlineApp.picture#" name="file" filter="#url.studentid#.*">	
    
    <cffile action="delete" file="#AppPath.onlineApp.picture##file.name#">
    
    <cfoutput>
    
		<script language="JavaScript">
            <!-- 
            alert("You have successfully deleted the passport photo.");
                location.replace("#AppPath.onlineApp.URL#index.cfm?curdoc=section1/page1&id=1&p=1");
            //-->
        </script>
    
    </cfoutput>
    
    <cfcatch type="any">
        <cfinclude template="error_message.cfm">	
    </cfcatch>
    
</cftry>
