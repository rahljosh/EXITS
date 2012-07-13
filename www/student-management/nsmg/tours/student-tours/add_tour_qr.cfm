<cfif NOT DirectoryExists("#APPPATH.UPLOADEDFILES#student-tours")>
	<cfdirectory directory="#APPPATH.UPLOADEDFILES#student-tours" action="create">
</cfif>

<cfset directory = '#AppPath.uploadedFiles#student-tours'>
	
	<!----Upload File---->
	<cffile action="upload" destination="#directory#" fileField="file_upload" nameConflict="overwrite">

	<!--- file type --->
	<cfif cffile.clientfileext NEQ 'jpg'>  
		<cffile action = "delete" file = "#directory#">
		<cfoutput>
			<script language="JavaScript">
            	alert("Please upload a jpg image. EXITS does not accept #cffile.clientfileext# files.");
                location.replace("?curdoc=tours/student-tours\index");
            </script>
		</cfoutput>
	</cfif>

	<!--- Resize Image Files --->
	<cfif file.ServerFileExt EQ 'jpg'> 
		<cfset filename = '#file.ServerFileName#'>
		<cfset uploadedImage = cffile.serverfile>
		<cfset filename = '#file.ServerFileName#'>
		
		<!--- Invoke image.cfc component --->
		<cfset imageCFC = createObject("component","image") />
		<!--- scaleX image to 800px wide --->
		<cfset scaleX800 = imageCFC.scaleX("", "#directory#/#uploadedImage#", "#directory#/new#uploadedImage#", 300)>
	
		<!--- if file has been resized ---->
		<cfif #FileExists("#directory#\new#filename#.#file.ServerFileExt#")#>
			<!--- delete big file --->
			<cffile action = "delete" file = "#directory#/#uploadedImage#">
			<!--- rename new file --->
			<cffile action="rename" source="#directory#/new#filename#.#file.ServerFileExt#" destination="#directory#/#filename#.#file.ServerFileExt#" attributes="normal">
		</cfif>
	</cfif>
	
	<!--- Upload File 2 --->
	<cffile action="upload" destination="#directory#" fileField="file_upload2" nameConflict="overwrite">

	<!--- file type 2 --->
	<cfif cffile.clientfileext NEQ 'jpg'>  
		<cffile action = "delete" file = "#directory#\#cffile.serverfile#">
		<cfoutput>
		<script language="JavaScript">
		<!-- 
		alert("Please upload a jpg image. EXITS does not accept #cffile.clientfileext# files.");
			location.replace("?curdoc=tours/smg_welcome_pictures");
		-->
		</script>
		</cfoutput>
	</cfif>

	<!--- Resize Image Files 2 --->
	<cfif file.ServerFileExt EQ 'jpg'> 
		<cfset filename2 = '#file.ServerFileName#'>
		<cfset uploadedImage = cffile.serverfile>
		<cfset filename2 = '#file.ServerFileName#'>
		
		<!--- Invoke image.cfc component 2 --->
		<cfset imageCFC = createObject("component","image") />
		<!--- scaleX image to 800px wide 2 --->
		<cfset scaleX800 = imageCFC.scaleX("", "#directory#/#uploadedImage#", "#directory#/new#uploadedImage#", 175)>
	
		<!--- if file has been resized 2 ---->
		<cfif #FileExists("#directory#\new#filename2#.#file.ServerFileExt#")#>
			<!--- delete big file 2 --->
			<cffile action = "delete" file = "#directory#/#uploadedImage#">
			<!--- rename new file 2 --->
			<cffile action="rename" source="#directory#/new#filename2#.#file.ServerFileExt#" destination="#directory#/#filename2#.#file.ServerFileExt#" attributes="normal">
		</cfif>
	</cfif>
	
<cfquery name="add_tour" datasource="MySQL">
	INSERT smg_tours
		(
        	tour_name, 
            tour_date, 
            tour_price, 
            tour_description, 
            tour_flights, 
            tour_payment, 
            tour_include, 
            tour_notinclude,
		 	tour_cancelfee, 
            tour_status, 
            tour_img1, 
            tour_img2
  		)
	VALUES 
		(
        	<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.tour_name#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.tour_date#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.tour_price#">,
            <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#FORM.tour_description#">,
            <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#FORM.tour_flights#">,
            <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#FORM.tour_payment#">,
            <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#FORM.tour_include#">,
            <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#FORM.tour_notinclude#">,
            <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#FORM.tour_cancelfee#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.tour_status#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#filename#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#filename2#">
  		)
</cfquery>	

<cflocation url="?curdoc=tours/student-tours/index" addtoken="no">

</body>
</html>
