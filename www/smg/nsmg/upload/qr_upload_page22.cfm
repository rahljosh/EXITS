<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Page [22] - Upload Supplements</title>
</head>

<body>

	<!---- Files are written to the dev server... this path should NOT match the path for reading files.---->
	<cfset directory = "#AppPath.onlineApp.virtualFolder##form.studentid#/page22">

	<!----Upload File---->
	<cffile action="upload" destination="#directory#" fileField="file_upload" nameConflict="makeunique" mode="777">
	
	<!--- check file size - 2mb limit --->
	<cfset newfilesize = file.FileSize / 1024>
	
	<cfif newfilesize GT 2048>  
        <cffile action = "delete" file = "#directory#/#cffile.serverfile#">
		<cfoutput>
			<script language="JavaScript">
                <!-- 
                alert("The file you are trying to upload is bigger than 2mb. Files can not be bigger than 2mb. Please resize your file and try again.");
                    location.replace("form_upload_page22.cfm?studentid=#form.studentid#");
                -->
            </script>
		</cfoutput>
		<cfabort>
	</cfif>
	
	<!--- file type --->
    <cfif NOT ListFind("jpg,peg,gif,tif,png,pdf,doc", LCase(cffile.clientfileext))>
		<cffile action = "delete" file = "#directory#/#cffile.serverfile#">
		<cfoutput>
			<script language="JavaScript">
				<!-- 
				alert("Unfortunately EXITS Online Application does not accept #cffile.clientfileext# files. \n EXITS only accepts files in the following formats: JPG, JPEG, GIF, PDF AND DOC. Please change the file type and try again.");
					location.replace("form_upload_page22.cfm?studentid=#form.studentid#");
				-->
            </script>
		</cfoutput>
		<cfabort>
	</cfif>
`
	<!--- Resize Image Files --->
	<cfif ListFind("jpg,peg,gif,tif,png", LCase(cffile.clientfileext))> 
		<cfset filename = file.ServerFileName>
		<cfset uploadedImage = cffile.serverfile>
	
		<!--- Invoke image.cfc component --->
		<cfset imageCFC = createObject("component","image") />
			
		<!--- scaleX image to 800px wide --->
		<cfset scaleX800 = imageCFC.scaleX("", "#directory#/#uploadedImage#", "#directory#/new#uploadedImage#", 800)>
	
		<!--- if file has been resized ---->
		<cfif FileExists("#directory#/new#filename#.#file.ServerFileExt#")>
			<!--- delete old file --->
			<cffile action = "delete" file = "#directory#/#uploadedImage#">

			<!--- rename new file --->
			<cffile action="rename" source="#directory#/new#filename#.#file.ServerFileExt#" destination="#directory#/#filename#.#file.ServerFileExt#" mode="777" attributes="normal" nameconflict="makeunique">
		</cfif>
	</cfif>

	<!--- Rename File - Lower Case, remove foreign accents, javascript safe and remove blank spaces --->
	<cffile action="rename" source="#directory#/#CFFILE.ServerFile#" destination="#directory#/#LCase(SafeJavascript(CFFILE.ServerFile))#" mode="777" attributes="normal" nameconflict="makeunique">
		 
	<!--- OPEN FROM MAIN SEVER IN ORDER TO REFRESH THE PAGE PROPERLY / JAVASCRIPT WOULD NOT REFRESH IF THEY ARE ON A DIFFERENT DOMAIN --->

	<cflocation url="#AppPath.onlineApp.reloadURL#" addtoken="no">
    
</body>
</html>