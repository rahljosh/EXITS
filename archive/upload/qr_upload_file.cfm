<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Upload File</title>
</head>

<body>
<!----
<cftry>
---->

	<!---- Files are written to the dev server... this path should NOT match the path for reading files.---->
	<cfset directory = '#AppPath.onlineApp.inserts##form.folder#'>

	<!----Upload File---->
	<cffile action = "upload" destination="#directory#" fileField="file_upload" nameConflict="makeunique" mode="777">
	
	<!--- check file size - 2mb limit --->
	<cfset newfilesize = #file.FileSize# / 1024>
	<cfif newfilesize GT 2048>  
		<cffile action = "delete" file = "#directory#/#cffile.serverfile#">
		<cfoutput>
		<script language="JavaScript">
			<!-- 
			alert("The file you are trying to upload is bigger than 2mb. Files can not be bigger than 2mb. Please resize your file and try again.");
				location.replace("form_upload_file.cfm?studentid=#form.studentid#&folder=#form.folder#");
			-->
		</script>
		</cfoutput>
	</cfif>
	
	<!--- file type --->
	<cfif NOT ListFind("jpg,peg,gif,tif,png,pdf,doc", LCase(cffile.clientfileext))>
		<cffile action = "delete" file = "#directory#/#cffile.serverfile#">
		<cfoutput>
		<script language="JavaScript">
			<!-- 
			alert("Unfortunately EXITS Online Application does not accept #cffile.clientfileext# files. \n EXITS only accepts files in the following formats: JPG, JPEG, GIF, PDF AND DOC. Please change the file type and try again.");
				location.replace("form_upload_file.cfm?studentid=#form.studentid#&folder=#form.folder#");
			-->
		</script>
		</cfoutput>
	</cfif>

	<!--- Resize Image Files --->
	<cfif ListFind("jpg,peg,gif,tif,png", LCase(file.ServerFileExt))>
		<cfset filename = '#file.ServerFileName#'>
		<cfset uploadedImage = cffile.serverfile>
		
		
		<!--- Invoke image.cfc component --->
		<cfset imageCFC = createObject("component","image") />
		<!--- scaleX image to 800px wide --->
		<cfset scaleX800 = imageCFC.scaleX("", "#directory#/#uploadedImage#", "#directory#/new#uploadedImage#", 800)>
	
		<!--- if file has been resized ---->
		<cfif #FileExists("#directory#/new#filename#.#file.ServerFileExt#")#>
			<!--- delete big file --->
			<cffile action = "delete" file = "#directory#/#uploadedImage#">
			<!--- rename new file --->
			<cffile action="rename" source="#directory#/new#filename#.#file.ServerFileExt#" destination="#directory#/#filename#.#file.ServerFileExt#" attributes="normal" mode="777" nameconflict="overwrite">
		</cfif>
		
	</cfif>
	<cffile	action="rename" source="#directory#/#CFFILE.ServerFile#" destination="#directory#/#form.studentid#.#LCase(cffile.clientfileext)#" mode="777">
		 
	<!--- OPEN FROM MAIN SEVER IN ORDER TO REFRESH THE PAGE PROPERLY / JAVASCRIPT WOULD NOT REFRESH IF THEY ARE ON A DIFFERENT DOMAIN--->
	<cflocation url="http://www.student-management.com/nsmg/student_app/querys/reload_window.cfm">
    
	<!---- 
<cfcatch type="any">
	<cfinclude template="error_message.cfm">	
</cfcatch>
</cftry>	
---->

</body>
</html>