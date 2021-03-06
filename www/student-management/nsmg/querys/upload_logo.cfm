<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Upload File</title>
</head>

<body>

<cfoutput>

<!----Upload File---->
<cffile action="upload" destination="#AppPath.companyLogo#" fileField="UploadFile" nameConflict="makeunique" charset="utf-8" mode="777">
	
	<cffile action="rename" source="#AppPath.companyLogo#/#cffile.serverfile#" destination="#AppPath.companyLogo#/#form.userid#.#file.ServerFileExt#">	
		
	<!--- check file size - 1mb limit --->
	<cfset newfilesize = file.FileSize / 1024>
	<cfif newfilesize GT 1024>  
		<cffile action = "delete" file = "#AppPath.companyLogo#/#cffile.serverfile#">
			<script language="JavaScript">
			<!-- 
			alert("The logo you are trying to upload is bigger than 1mb. Logos can not be bigger than 1mb. Please try again.");
			location.replace("../index.cfm?curdoc=user_info&userid=#form.userid#");
			-->
			</script>
		<cfabort>
	</cfif>

	<!--- check image extension --->
	<cfif NOT ListFind("jpg,peg,gif,tif,png", LCase(cffile.clientfileext))>
		<cffile action = "delete" file = "#AppPath.companyLogo#/#cffile.serverfile#">
			<script language="JavaScript">
			<!-- 
			alert("You can only upload logos on the following formats: .gif, .jpg, or .jpeg.");
			location.replace("../index.cfm?curdoc=user_info&userid=#form.userid#");
			-->
			</script>
		<cfabort>
	</cfif>

	<!---
	<!--- Resize Image Files to 800 width --->
	<cfset filename = '#file.ServerFileName#'>
	<cfset uploadedImage = cffile.serverfile>
	<!--- Invoke image.cfc component --->
	<cfset imageCFC = createObject("component","image") />
	<!--- scaleY image to 71px height --->
	<cfset scaleY71 = imageCFC.scaleY("", "#AppPath.companyLogo#/#uploadedImage#", "#AppPath.companyLogo#/new#uploadedImage#", 71)>
	<!--- if file has been resized ---->
	<cfif #FileExists("#AppPath.companyLogo#/new#filename#.#file.ServerFileExt#")#>
		<!--- delete big file --->
		<cffile action = "delete" file = "#AppPath.companyLogo#/#uploadedImage#">
		<!--- rename new file --->
		<cffile action="rename" source="#AppPath.companyLogo#/new#filename#.#file.ServerFileExt#" destination="#AppPath.companyLogo#/#filename#.#file.ServerFileExt#">
	</cfif>
	--->

	<!----Check if file has been uploaded---->
	<cfquery name="insert_logo" datasource="MySQL">
		UPDATE 
        	smg_users
		SET 
        	logo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.userid#.#file.ServerFileExt#">
		WHERE 
        	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.userid#">
		LIMIT 1
	</cfquery>

	<script language="JavaScript">
	<!-- 
	alert("Logo Upload Successfully.");
	location.replace("../index.cfm?curdoc=user_info&userid=#form.userid#");
	-->
	</script>
	 
	<!--- <cflocation url="../index.cfm?curdoc=user_info&userid=#form.userid#"> --->

</cfoutput>

</body>
</html>