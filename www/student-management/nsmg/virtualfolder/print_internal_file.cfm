<cftry>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>EXITS - INTERNAL VIRTUAL FOLDER</title>
</head>

<body>

<cfif NOT IsDefined('url.fileID')>
	Sorry, an error has occurred. Please try again.<br>
	If this error persists please contact the system administrator support@student-management.com
	<cfabort>
</cfif>

<cfquery name="qGetFile" datasource="MySql">
	SELECT *
    FROM smg_internal_virtual_folder
    WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.fileID#">
</cfquery>

<cfoutput query="qGetFile">
	<cfif fileType EQ "pdf">
    	<cfdocument format="flashpaper">
            <cfcontent file="#fullPath#">
        </cfdocument>
    <cfelseif fileType EQ "jpg" OR fileType EQ "jpeg" OR fileType EQ "png">
    	<cfimage action="writetobrowser" source="#fullPath#">
    </cfif>
</cfoutput>

</body>
</html>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>