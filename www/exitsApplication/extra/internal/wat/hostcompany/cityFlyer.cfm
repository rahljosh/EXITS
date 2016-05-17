<!--- ------------------------------------------------------------------------- ----
	
	File:		addViewRemoveDocumentsSigned.cfm
	Author:		Bruno Lopes
	Date:		November 20, 2014
	Desc:		Upload/Edit/Remove a file (for host company document files)

----- ------------------------------------------------------------------------- --->

<cfsilent>
	
    <!--- Do not display debug output --->
	<cfsetting showdebugoutput="yes">
    
    <!--- Param URL Variable --->
    <cfparam name="URL.stateID" default="0">
    <cfparam name="URL.city" default="">

	<cfscript>
		imagePath = APPLICATION.PATH.cityFlyers;
		if ( NOT DirectoryExists(imagePath) ) {
			DirectoryCreate(imagePath);
		}
	</cfscript>

</cfsilent>

<!--- Get the reference to the file from the database --->
<cfquery name="qGetFile" datasource="MySql">
	SELECT *
    FROM extra_cities
    WHERE stateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.stateID#">
    	AND name = <cfqueryparam cfsqltype="cf_sql_char" value="#URL.city#">
</cfquery>

<!--- Check if the file exists --->
<cfif fileExists(qGetFile.fullPath)>
	<cfif qGetFile.fileType EQ "pdf">
    	<cfdocument format="flashpaper">
        	<cfcontent file="#qGetFile.fullPath#">
       	</cfdocument>
   	<cfelseif qGetFile.fileType EQ "doc" OR qGetFile.fileType EQ "docx">
    	<cfheader name="Content-Disposition" value="attachment; filename=#qGetFile.fullPath#">
		<cfcontent type="text/plain" file="#qGetFile.fullPath#">
   	<cfelseif qGetFile.fileType EQ "jpg" OR qGetFile.fileType EQ "jpeg">
    	<cfimage action="read" source="#qGetFile.fullPath#" name="image">
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
		//window.close();
	</script>
</cfif>
