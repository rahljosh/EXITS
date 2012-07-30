<cfset directory = ExpandPath('../../uploadedFiles/online_app/#url.doc#/')>

<cfdirectory directory="#directory#" name="file" filter="#url.student#.*">	

<cffile action="delete" file="#directory##file.name#">

<cfoutput>

        <script type="text/javascript">
            alert("You have successfully deleted the uploaded file.");
            location.replace("../index.cfm?curdoc=#url.ref#&id=#url.id#&p=#url.p#");
        </script>

</cfoutput>
