<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Upload Letter</title>
</head>

<body>

<cfoutput>

<cfscript>
	// Set Directory	
	directory = '#AppPath.onlineApp.letters##FORM.type#';

	// Make Sure Directory Exists
	createFolder(directory);
</cfscript>

<!----Upload File---->
<cffile action="upload" fileField="FORM.letter" destination="#directory#" nameConflict="MakeUnique">
  
<cfscript>
	// Get File Size
	newfilesize = file.FileSize / 1024;
</cfscript>

<!--- File Validation - check file size - 2mb limit --->
<cfif newfilesize GT 2048>  

	<!--- Delete File --->
	<cffile action="delete" file="#directory#/#CFFILE.serverfile#">
    
	<script language="JavaScript">
        <!-- 
        alert("The file you are trying to upload is bigger than 2mb. Files can not be bigger than 2mb. Please resize your file and try again.");
            location.replace("form_upload_letter.cfm?studentid=#FORM.studentid#&type=#FORM.type#");
        -->
    </script>

<!--- File Validation - file type --->    
<cfelseif NOT ListFind("jpg,jpeg,gif,tif,tiff,png,pdf,doc", LCase(CFFILE.clientfileext))>

	<!--- Delete File --->
	<cffile action="delete" file="#directory#/#CFFILE.serverfile#">

	<script language="JavaScript">
        <!-- 
        alert("Unfortunately EXITS Online Application does not accept #CFFILE.clientfileext# files. \n EXITS only accepts files in the following formats: JPG, JPEG, GIF, PDF AND DOC. Please change the file type and try again.");
            location.replace("form_upload_letter.cfm?studentid=#FORM.studentid#&type=#FORM.type#");
        -->
   </script>

<cfelse>

	<!--- Resize Image Files --->
    <cfif ListFind("jpg,peg,gif,tif,tiff,png", LCase(file.ServerFileExt))>
        
        <cfscript>
            // Invoke image.cfc component
            imageCFC = createObject("component","image");
            
            // scaleX image to 1000px wide
            scaleX1000 = imageCFC.scaleX("", "#directory#/#CFFILE.serverfile#", "#directory#/new#CFFILE.serverfile#", 1000);
        </cfscript>
        
        <!--- if file has been resized ---->
        <cfif FileExists("#directory#/new#CFFILE.ServerFileName#.#CFFILE.ServerFileExt#")>
            
            <!--- delete original file --->
            <cffile action="delete" file="#directory#/#CFFILE.serverfile#">
            
            <!--- rename resized file --->
            <cffile action="rename" source="#directory#/new#CFFILE.ServerFileName#.#CFFILE.ServerFileExt#" destination="#directory#/#FORM.studentid#.#LCase(CFFILE.ServerFileExt)#" attributes="normal">
    
        </cfif>
    
    </cfif>

	<cffile	action="rename" source="#directory#/#CFFILE.ServerFile#" destination="#directory#/#FORM.studentid#.#LCase(cffile.ClientFileExt)#" nameconflict="overwrite">

	<!--- OPEN FROM MAIN SEVER IN ORDER TO REFRESH THE PAGE PROPERLY / JAVASCRIPT WOULD NOT REFRESH IF THEY ARE ON A DIFFERENT DOMAIN--->
    <cflocation url="#AppPath.onlineApp.reloadURL#" addtoken="no">

</cfif>

</cfoutput>

</body>
</html>