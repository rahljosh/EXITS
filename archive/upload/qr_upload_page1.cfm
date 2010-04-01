<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Page [01] - Upload Passport Photo</title>
</head>

<body>

<cftry>

<cfoutput>
	
	<cfset directory = AppPath.onlineApp.picture>
	
	<!----Upload File---->
	<cffile action="upload" fileField="form.passaport" destination="#directory#"  nameconflict="overwrite">
													<!--- accept = "image/jpg, image/gif, image/jpeg, image/pjpeg" --->
	<!--- check file size - 1mb limit --->
	<cfset newfilesize = #file.FileSize# / 1024>
	<cfif newfilesize GT 1024>  
		<cffile action = "delete" file = "#directory#/#cffile.serverfile#">
			<script language="JavaScript">
			<!-- 
			alert("The photo you are trying to upload is bigger than 1mb. Please try again. Files can not be bigger than 1mb.");
			location.replace("form_upload_page1.cfm?studentid=#form.studentid#");
			-->
			</script>
		<cfabort>
	</cfif>
	
	<!--- check image extension --->
	<cfif NOT ListFind("jpg,peg,gif,tif,png", LCase(cffile.clientfileext))>
		<cffile action = "delete" file = "#directory#/#cffile.serverfile#">
			<script language="JavaScript">
			<!-- 
			alert("Only images that are .gif, .jpg, or .jpeg can be uploaded.  Please re-save in the appropriate format, and resubmit.");
			location.replace("form_upload_page1.cfm?studentid=#form.studentid#");
			-->
			</script>
		<cfabort>
	</cfif>

	<!--- Resize Image Files to 150 width --->
	<cfset filename = '#file.ServerFileName#'>
	<cfset uploadedImage = cffile.serverfile>
	<!--- Invoke image.cfc component --->
	<cfset imageCFC = createObject("component","image") />
	<!--- scaleX image to 1000px wide --->
	<cfset scaleX150 = imageCFC.scaleX("", "#directory#/#uploadedImage#", "#directory#/new#uploadedImage#", 150)>
	<!--- if file has been resized ---->
	<cfif #FileExists("#directory#/new#filename#.#file.ServerFileExt#")#>
		<!--- delete big file --->
		<cffile action = "delete" file = "#directory#/#uploadedImage#">
		<!--- rename new file --->
		<cffile action="rename" source="#directory#/new#filename#.#file.ServerFileExt#" destination="#directory#/#filename#.#file.ServerFileExt#" nameconflict="overwrite">
	</cfif>

	<cffile	action="rename" source="#directory#/#CFFILE.ServerFile#" destination="#directory#/#form.studentid#.#LCase(cffile.ClientFileExt)#" nameconflict="overwrite">
	
	<!--- OPEN FROM MAIN SEVER IN ORDER TO REFRESH THE PAGE PROPERLY / JAVASCRIPT WOULD NOT REFRESH IF THEY ARE ON A DIFFERENT DOMAIN--->
	<cflocation url="http://www.student-management.com/nsmg/student_app/querys/reload_window.cfm">

</cfoutput>

<cfcatch type="">
	<cfinclude template="error_message.cfm">
</cfcatch>
</cftry>  

</body>
</html>
