<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Add New Welcome Picture</title>
</head>

<body>


<cfset directory = '/var/www/html/student-management/nsmg/uploadedfiles/student-tours'>
	
	<!----Upload File---->
	<cffile action="upload" destination="#directory#" fileField="file_upload" nameConflict="overwrite">

	<!--- file type --->
	<cfif cffile.clientfileext NEQ 'jpg'>  
		<cffile action = "delete" file = "#directory#\#cffile.serverfile#">
		<cfoutput>
		<script language="JavaScript">
		<!-- 
		alert("Please upload a jpg image. EXITS does not accept #cffile.clientfileext# files.");
			location.replace("?curdoc=tools/student-tours\index");
		-->
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
	
	<!----<cffile	action="rename" source="#directory#/#CFFILE.ServerFile#" destination="#directory#/#newpictureid#.#cffile.clientfileext#">
	
	Upload File 2---->
	<cffile action="upload" destination="#directory#" fileField="file_upload2" nameConflict="overwrite">

	<!--- file type 2 --->
	<cfif cffile.clientfileext NEQ 'jpg'>  
		<cffile action = "delete" file = "#directory#\#cffile.serverfile#">
		<cfoutput>
		<script language="JavaScript">
		<!-- 
		alert("Please upload a jpg image. EXITS does not accept #cffile.clientfileext# files.");
			location.replace("?curdoc=tools/smg_welcome_pictures");
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


	<!----<cffile	action="rename" source="#directory#/#CFFILE.ServerFile#" destination="#directory#/#newpictureid#.#cffile.clientfileext#"> --->
	
<cfquery name="add_tour" datasource="MySQL">
	INSERT smg_tours
		(tour_name, tour_date, tour_price, tour_description, tour_flights, tour_payment, tour_include, tour_notinclude,
		 tour_cancelfee, tour_status, tour_img1, tour_img2)
	VALUES 
		('#form.tour_name#', '#form.tour_date#', '#form.tour_price#', '#form.tour_description#', '#form.tour_flights#', '#form.tour_payment#',
		'#form.tour_include#', '#form.tour_notinclude#', '#form.tour_cancelfee#', '#form.tour_status#', '#filename#', '#filename2#')
</cfquery>	

<cflocation url="?curdoc=tools/student-tours/index" addtoken="no">

</body>
</html>
