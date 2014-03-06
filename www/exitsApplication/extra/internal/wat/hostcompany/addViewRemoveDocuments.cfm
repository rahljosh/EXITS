<!--- ------------------------------------------------------------------------- ----
	
	File:		addViewRemoveDocuments.cfm
	Author:		James Griffiths
	Date:		March 6, 2014
	Desc:		Upload, display, or delete a document (For host companies)

----- ------------------------------------------------------------------------- --->

<!--- Param URL Variable --->
<cfparam name="URL.option" default="upload">
<cfparam name="URL.hostCompanyID" default="0">
<cfparam name="URL.documentID" default="0">

<cfscript>
	if (URL.option EQ "upload") {
		APPLICATION.CFC.DOCUMENT.upload(
			foreignTable="extra_hostCompany",
			foreignID=URL.hostCompanyID,
			uploadPath="#APPLICATION.PATH.uploadedFiles#hostCompany/#URL.hostCompanyID#/",
			documentTypeID=42);
	} else if (URL.option EQ "delete") {
		APPLICATION.CFC.DOCUMENT.delete(
			documentID=URL.documentID);
	}
</cfscript>

<cfif URL.option EQ "view">
	<cfoutput>
        <cfquery name="qGetFile" datasource="#APPLICATION.DSN.Source#">
            SELECT *
            FROM document
            WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.documentID#">
        </cfquery>
        
        <!--- Check if the file exists --->
        <cfset fullPath = qGetFile.location & qGetFile.serverName & "." & qGetFile.serverExt>
        <cfif fileExists(fullPath)>
            <cfif qGetFile.serverExt EQ "pdf">
                <cfdocument format="flashpaper">
                    <cfcontent file="#fullPath#">
                </cfdocument>
            <cfelseif qGetFile.serverExt EQ "doc" OR qGetFile.serverExt EQ "docx">
                <cfheader name="Content-Disposition" value="attachment; filename=#fullPath#">
                <cfcontent type="text/plain" file="#fullPath#">
            <cfelseif qGetFile.serverExt EQ "jpg" OR qGetFile.serverExt EQ "jpeg">
                <cfimage action="read" source="#fullPath#" name="image">
                <cfcontent type="image/jpeg" variable="#imageGetBlob(image)#">
            <cfelse>
                <script type="text/javascript">
                    alert("The file is not in a supported format");
                    window.close();
                </script>
            </cfif>
        <cfelse>
            <script type="text/javascript">
                alert("The file could not be found");
                window.close();
            </script>
        </cfif>
   	</cfoutput>
<cfelse>
	<script type="text/javascript">
        window.opener.location.reload(false);
        window.close();
    </script>
</cfif>