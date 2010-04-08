<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Add New Welcome Picture</title>
</head>

<body>

<cftransaction action="BEGIN" isolation="serializable">

	<cfquery name="add_picture" datasource="caseusa">
		INSERT smg_pictures
			(title, description, active)
		VALUES (<cfqueryparam value="#form.title#" cfsqltype="cf_sql_longvarchar">,
				<cfqueryparam value="#form.description#" cfsqltype="cf_sql_longvarchar">, 
				'#form.active#')
	</cfquery>

	<cfquery name="get_pictureid" datasource="caseusa">
		SELECT max(pictureid) as newpictureid
		FROM smg_pictures
	</cfquery>

	<cfset directory = '/var/www/html/student-management/nsmg/uploadedfiles/welcome_pics'>
	
	<!----Upload File---->
	<cffile action="upload" destination="#directory#" fileField="file_upload" nameConflict="overwrite">

	<!--- file type --->
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

	<!--- Resize Image Files --->
	<cfif file.ServerFileExt EQ 'jpg'> 
		<cfset filename = '#file.ServerFileName#'>
		<cfset uploadedImage = cffile.serverfile>
		<cfset filename = '#file.ServerFileName#'>
		
		<!--- Invoke image.cfc component --->
		<cfset imageCFC = createObject("component","image") />
		<!--- scaleX image to 800px wide --->
		<cfset scaleX800 = imageCFC.scaleX("", "#directory#/#uploadedImage#", "#directory#/new#uploadedImage#", 240)>
	
		<!--- if file has been resized ---->
		<cfif #FileExists("#directory#\new#filename#.#file.ServerFileExt#")#>
			<!--- delete big file --->
			<cffile action = "delete" file = "#directory#/#uploadedImage#">
			<!--- rename new file --->
			<cffile action="rename" source="#directory#/new#filename#.#file.ServerFileExt#" destination="#directory#/#filename#.#file.ServerFileExt#" attributes="normal">
		</cfif>
	</cfif>

	<cffile	action="rename" source="#directory#/#CFFILE.ServerFile#" destination="#directory#/#get_pictureid.newpictureid#.#cffile.clientfileext#">
	
</cftransaction>

<cflocation url="?curdoc=tools/smg_welcome_pictures" addtoken="no">

</body>
</html>
