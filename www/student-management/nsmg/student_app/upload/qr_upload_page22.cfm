<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Page [22] - Upload Supplements</title>
</head>

<body>

	<!---- Files are written to the dev server... this path should NOT match the path for reading files.---->
	<cfset directory = ExpandPath("../../uploadedFiles/virtualFolder/#form.studentid#/page22")>

	  <cfif NOT DirectoryExists('#directory#')>
        <cfdirectory action="create" directory="#directory#">
    </cfif>

	<!----Upload File---->
	<cffile action="upload" destination="#directory#" fileField="file_upload" nameConflict="makeunique">
	
	<!--- check file size - 2mb limit --->
	<cfset newfilesize = file.FileSize / 1024>
	
	<cfif newfilesize GT 2048>  
        <cffile action = "delete" file = "#directory#/#CFFILE.serverfile#">
		<cfoutput>
			<script type="text/javascript">
                alert("The file you are trying to upload is bigger than 2mb. Files can not be bigger than 2mb. Please resize your file and try again.");
                    location.replace("form_upload_page22.cfm?studentid=#form.studentid#");
            </script>
		</cfoutput>
		<cfabort>
	</cfif>
	
	<!--- file type --->
    <cfif NOT ListFind("jpg,jpeg,gif,tif,tiff,png,pdf", LCase(CFFILE.clientfileext))>
		<cffile action = "delete" file = "#directory#/#CFFILE.serverfile#">
		<cfoutput>
			<script type="text/javascript">
				alert("Unfortunately EXITS Online Application does not accept #CFFILE.clientfileext# files. \n EXITS only accepts files in the following formats: JPG, JPEG, GIF, TIF, TIFF PNG, AND PDF. Please change the file type and try again.");
					location.replace("form_upload_page22.cfm?studentid=#form.studentid#");
            </script>
		</cfoutput>
		<cfabort>
	</cfif>

	<cfscript>
        //Resize Image Files
        if ( ListFind("jpg,jpeg,gif,tif,tiff,png", LCase(CFFILE.clientfileext)) )  {
        
            // Invoke image.cfc component to resize image
            imageCFC = createObject("component","image");
            
            // scaleX image to 1000px wide
            scaleX1000 = imageCFC.scaleX("", "#directory#/#CFFILE.serverfile#", "#directory#/#CFFILE.serverfile#", 1000);
        }
    </cfscript>

	<cffile action="rename" source="#directory#/#CFFILE.ServerFile#" destination="#directory#/#LCase(CFFILE.ServerFile)#" attributes="normal" nameconflict="makeunique">
		  <cfquery datasource="#application.dsn#">
               insert into virtualfolder (fk_documentType,fileName,filePath,fk_studentID,generatedHow,  uploadedBy, dateAdded)
                            values (<cfqueryparam cfsqltype="cf_sql_integer" value="44">,
                            		<cfqueryparam cfsqltype="cf_sql_varchar" value="#file.serverfile#">,
                            		<cfqueryparam cfsqltype="cf_sql_varchar" value="uploadedFiles/virtualfolder/#form.studentid#/page22/">,
                                    
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.studentid#">,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="manual">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userID#">,
                                    <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">)
                
                </cfquery>
         
	<script type="text/javascript">
		opener.location.reload(true);
   		self.close();
	</script>
    
</body>
</html>