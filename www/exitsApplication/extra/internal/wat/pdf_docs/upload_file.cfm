<cftry>
	
    <cffile accept="application/pdf" action="upload" fileField="UploadFile" destination="#form.directory#" nameConflict="MakeUnique">

	<script type="text/javascript">
		alert("You have successfully uploaded this file.");
		location.replace("?curdoc=pdf_docs/docs_forms");
	</script>
    
    <cfcatch type="any">
    	<script type="text/javascript">
			alert("You can only upload PDF files here.");
			location.replace("?curdoc=pdf_docs/docs_forms");
		</script>
    </cfcatch>

</cftry>