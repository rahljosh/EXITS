<!--- Param Form Variables ---> 
    <cfparam name="FORM.file" default="">
    <cfparam name="FORM.type" default="">
    <cfparam name="FORM.placementID" default="0">
    <cfparam name="FORM.studentID" default="0">
	<cfparam name="emailRecipient" default="#APPLICATION.EMAIL.support#">

<!--- Kill Extra Output --->
<cfsilent>

	<cfscript>
        // Get Folder Path and make sure it exists
        currentDirectory = "#APPLICATION.PATH.onlineApp.internalVirtualFolder##FORM.studentID#/#FORM.placementID#";
        AppCFC.UDF.createFolder(currentDirectory);
	</cfscript>
	
</cfsilent>

<cfif NOT LEN(FORM.file) OR NOT LEN (FORM.type)>
	<script type="text/javascript">
        alert("Please select a file and specify a type before uploading.");
		window.location.href = document.referrer;
    </script>
    <cfabort>
</cfif>

<cffile action="upload" filefield="file" destination="#currentDirectory#" nameconflict="makeunique" mode="777">

<cfset fileName = ListFirst(cffile.serverfile, ".")>
<cfset fileType = ListLast(cffile.serverfile, ".")>
<cfset fullPath = currentDirectory & "/" & cffile.serverfile>

<cfif NOT ListFind("pdf,png,jpg,jpeg",fileType)>
	<cffile action="delete" file="#fullPath#">
	<script type="text/javascript">
        alert("That is not a valid file type, valid file types are: pdf, png, jpg, and jpeg.");
		window.location.href = document.referrer;
    </script>
<cfelse>
    <cfquery datasource="MySql">
        INSERT INTO 
            smg_internal_virtual_folder (
                placementID, 
                type, 
                fullPath, 
                fileType, 
                fileName )
        VALUES (
            <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.placementID#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.type#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#fullPath#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#fileType#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#fileName#"> )
    </cfquery>
</cfif>

<script type="text/javascript">
	alert("File uploaded successfully.");
	window.location.href = document.referrer;
</script>