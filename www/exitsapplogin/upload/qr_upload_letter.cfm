<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Upload Letter</title>
</head>

<body>
<!----
<cftry>
	---->
<cfset directory = 'D:\home\exitsapplication.com\wwwroot\exits\upload\letters/#form.type#'>

<!----Upload File---->
<cffile action = "upload" fileField = "form.letter" destination = "#directory#" nameConflict="MakeUnique" mode="777">
 
<!--- check file size - 2mb limit --->
<cfset newfilesize = #file.FileSize# / 1024>
<cfif newfilesize GT 2048>  
	<cffile action = "delete" file = "#directory#/#cffile.serverfile#">
	<cfoutput>
	<script language="JavaScript">
	<!-- 
	alert("The file you are trying to upload is bigger than 2mb. Files can not be bigger than 2mb. Please resize your file and try again.");
		location.replace("form_upload_letter.cfm?studentid=#form.studentid#&type=#form.type#");
	-->
	</script>
	</cfoutput>
</cfif>

<!--- file type --->
<cfif cffile.clientfileext NEQ 'jpg' AND cffile.clientfileext NEQ 'jpeg' AND cffile.clientfileext NEQ 'gif' AND cffile.clientfileext NEQ 'pdf' AND cffile.clientfileext NEQ 'doc'>  
	<cffile action = "delete" file = "#directory#/#cffile.serverfile#">
	<cfoutput>
	<script language="JavaScript">
	<!-- 
	alert("Unfortunately EXITS Online Application does not accept #cffile.clientfileext# files. \n EXITS only accepts files in the following formats: JPG, JPEG, GIF, PDF AND DOC. Please change the file type and try again.");
		location.replace("form_upload_letter.cfm?studentid=#form.studentid#&type=#form.type#");
	-->
	</script>
	</cfoutput>
</cfif>
	
<!--- Resize Image Files --->
<cfif file.ServerFileExt EQ 'jpg' OR file.ServerFileExt EQ 'gif' OR file.ServerFileExt EQ 'png' OR file.ServerFileExt EQ 'tif' AND cffile.ClientFileExt NEQ 'bmp'> 
	<cfset filename = '#file.ServerFileName#'>
	<cfset uploadedImage = cffile.serverfile>
	
	<!--- Invoke image.cfc component --->
	<cfset imageCFC = createObject("component","image") />
	<!--- scaleX image to 1000px wide --->
	<cfset scaleX1000 = imageCFC.scaleX("", "#directory#/#uploadedImage#", "#directory#/new#uploadedImage#", 1000)>

	<!--- if file has been resized ---->
	<cfif #FileExists("#directory#/new#filename#.#file.ServerFileExt#")#>
		<!--- delete big file --->
		<cffile action = "delete" file = "#directory#/#uploadedImage#">
		<!--- rename new file --->
		<cffile action="rename" source="#directory#/new#filename#.#file.ServerFileExt#" destination="#directory#/#filename#.#file.ServerFileExt#" attributes="normal" mode="777">
	</cfif>
</cfif>

<cffile	action="rename" source="#directory#/#CFFILE.ServerFile#" destination="#directory#/#form.studentid#.#LCase(cffile.clientfileext)#" mode="777" nameconflict="overwrite"> 

<!--- OPEN FROM MAIN SEVER IN ORDER TO REFRESH THE PAGE PROPERLY / JAVASCRIPT WOULD NOT REFRESH IF THEY ARE ON A DIFFERENT DOMAIN--->
<cflocation url="http://www.exitsapplication.com/exits/student_app/querys/reload_window.cfm">
<!----	
<cfcatch type="any">
	<cfinclude template="error_message.cfm">	
</cfcatch>
</cftry>	
---->
</body>
</html>