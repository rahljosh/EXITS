<cfset directory = ExpandPath('../../uploadedFiles/online_app/#url.doc#/')>

<cfdirectory directory="#directory#" name="file" filter="#url.student#.*">	

<cfset exists=1>

<cftry>
	<cffile action="delete" file="#directory##file.name#">
	<cfcatch type="any">
		<cfset exists=0>
   	</cfcatch>
</cftry>

<cfoutput>
	<cfif VAL(exists)>
        <script type="text/javascript">
            alert("You have successfully deleted the uploaded file.");
            location.replace("../index.cfm?curdoc=#url.ref#&id=#url.id#&p=#url.p#");
        </script>
   	<cfelse>
    	<script type="text/javascript">
            alert("That file could not be found.");
            location.replace("../index.cfm?curdoc=#url.ref#&id=#url.id#&p=#url.p#");
        </script>
    </cfif>
</cfoutput>
