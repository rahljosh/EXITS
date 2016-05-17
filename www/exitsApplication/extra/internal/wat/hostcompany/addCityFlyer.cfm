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
    <cfparam name="URL.option" default="upload">
    <cfparam name="URL.type" default="Flyer">
    <cfparam name="URL.stateID" default="0">
    <cfparam name="URL.city" default="">
    <cfparam name="URL.fileID" default="0">

	<cfscript>
		imagePath = APPLICATION.PATH.cityFlyers;
		if ( NOT DirectoryExists(imagePath) ) {
			DirectoryCreate(imagePath);
		}
	</cfscript>

</cfsilent>

<!--- Upload image --->
<cfif  URL.option EQ "upload">
	
    <!--- Upload the file --->
    <cffile action="upload" filefield="image" destination="#imagePath#" nameconflict="overwrite">
    
    <!--- Get the file extension --->
    <cfset fileExt = ListLast(cffile.clientfile,".")>
    <cfset originalFileName = cffile.clientfile>

    <!--- Set the new name for the file --->
    <cfset fileName = "#URL.stateID#_#URL.city#_#DateFormat(NOW(),'mm-dd-yyyy')#">

	<!--- Only accept if it is a valid file type --->
    <cfif ListFind("jpg,jpeg,pdf,doc,docx",fileExt) AND URL.type NEQ 'noType'>
    	<cffile action="rename" source="#imagePath##cffile.clientFile#" destination="#imagePath##fileName#.#fileExt#">
        <cfquery datasource="MySql">
        	INSERT INTO extra_cities (stateID, name, fullPath, fileType)
            VALUES (
            	<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.stateID)#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.city#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#imagePath##fileName#.#fileExt#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#fileExt#"> )
        </cfquery>
    	<script type="text/javascript">
			alert("File uploaded successfully");
		</script>
    <cfelse>
    	<cffile action="delete" file="#imagePath##cffile.clientFile#">
        <script type="text/javascript">
			alert("This file could not be uploaded");
		</script>
    </cfif>

<!--- Delete the file --->
<cfelseif URL.option EQ "delete">
	<cfquery name="qGetFile" datasource="MySql">
    	SELECT *
        FROM extra_cities
        WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.fileID#">
    </cfquery>
    <cfdump var="#qGetFile#" />
    <cfif fileExists(qGetFile.fullPath)>
    	<cffile action="delete" file="#qGetFile.fullPath#">
   	</cfif>
    
    <cfquery datasource="MySql">
    	DELETE FROM extra_hostdocuments
        WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.fileID#">
    </cfquery>
    <script type="text/javascript">
		window.close();
	</script>

<!--- Image Print Screen --->
<cfelse>
	<!--- Get the reference to the file from the database --->
	<cfquery name="qGetFile" datasource="MySql">
    	SELECT *
        FROM extra_cities
        WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.fileID#">
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
			window.close();
		</script>
    </cfif>
    
</cfif>