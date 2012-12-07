<!--- ------------------------------------------------------------------------- ----
	
	File:		imageUploadPrint.cfm
	Author:		James Griffiths
	Date:		June 8, 2012
	Desc:		Upload an image (for host company authentication files)

----- ------------------------------------------------------------------------- --->

<cfsilent>
	
    <!--- Do not display debug output --->
	<cfsetting showdebugoutput="no">
    
    <!--- Param URL Variable --->
    <cfparam name="URL.option" default="upload">
    <cfparam name="URL.type" default="secretaryOfState">
    <cfparam name="URL.hostCompanyID" default="0">
    <cfparam name="URL.expirationDate" default="">
    <cfparam name="URL.fileID" default="0">
    <!--- These are only needed if the option is set to printAll --->
    <cfparam name="URL.fileID2" default="0">
    <cfparam name="URL.fileID3" default="0">
    <!--- These are for the additional authentication files when the option is set to printAll --->
    <cfparam name="URL.fileID4" default="0">
    <cfparam name="URL.fileID5" default="0">
    <cfparam name="URL.fileID6" default="0">
    <cfparam name="URL.fileID7" default="0">

	<cfscript>
		imagePath = APPLICATION.PATH.authentications;
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
    
    <!--- Set the new name for the file --->
    <cfset fileName = "#URL.hostCompanyID#_#URL.type#_#DateFormat(NOW(),'mm-dd-yyyy')#">

	<!--- Only accept if it is a valid file type --->
    <cfif ListFind("jpg,jpeg,pdf,doc,docx",fileExt) AND URL.type NEQ 'noType'>
    	<cffile action="rename" source="#imagePath##cffile.clientFile#" destination="#imagePath##fileName#.#fileExt#">
        <cfquery datasource="MySql">
        	INSERT INTO extra_hostauthenticationfiles (hostID, authenticationType, dateAdded, dateExpires, fullPath, fileType)
            VALUES (
            	<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.hostCompanyID)#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.type#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#URL.expirationDate#">,
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
        FROM extra_hostauthenticationfiles
        WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.fileID#">
    </cfquery>
    <cfif fileExists(qGetFile.fullPath)>
    	<cffile action="delete" file="#qGetFile.fullPath#">
   	</cfif>
    <cfquery datasource="MySql">
    	DELETE FROM extra_hostauthenticationfiles
        WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.fileID#">
    </cfquery>
    <script type="text/javascript">
		window.close();
	</script>
    
<!--- Print all authentication files --->
<cfelseif URL.option EQ "printAll">
	<cfset mergePath = "">
    <cfset destination = #imagePath# & "authentication" & #URL.hostCompanyID# & ".pdf">
    <cfquery name="qGetAllFiles" datasource="MySql">
    	SELECT *
        FROM extra_hostauthenticationfiles
        WHERE ( id = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.fileID#">
        	OR id = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.fileID2#">
            OR id = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.fileID3#">
            OR id = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.fileID4#">
            OR id = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.fileID5#">
            OR id = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.fileID6#">
            OR id = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.fileID7#"> )
      	AND fileType = <cfqueryparam cfsqltype="cf_sql_varchar" value="pdf">
    </cfquery>
   	<cfif VAL(qGetAllFiles.recordCount)>
    	<cfoutput>
        	<cfloop query="qGetAllFiles">
            	<cfif mergePath EQ "">
                	<cfset mergePath = fullPath>
                <cfelse>
                	<cfset mergePath = mergePath & "," & fullPath>
                </cfif>
            </cfloop>
            <cfpdf action="merge" source="#mergePath#" destination="#destination#" overwrite="yes">
            <cfdocument format="flashpaper">
            	<cfcontent file="#destination#">
            </cfdocument>
        </cfoutput>
        <script type="text/javascript">
            window.print();
        </script>
    <cfelse>
    	<script type="text/javascript">
            alert("There were no valid files found. Please note that the print all option will only work with pdf files.");
			window.close();
        </script>
    </cfif>

<!--- Image Print Screen --->
<cfelse>
	<!--- Get the reference to the file from the database --->
	<cfquery name="qGetFile" datasource="MySql">
    	SELECT *
        FROM extra_hostauthenticationfiles
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