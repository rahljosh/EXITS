<!--- ------------------------------------------------------------------------- ----
	
	File:		clearTempFolder.cfm
	Author:		Marcus Melo
	Date:		March 1, 2011
	Desc:		Scheduled Task - Clear files in temp folder
				It should be run weekly

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <cfdirectory action="List" directory="#APPLICATION.PATH.uploadDocumentTemp#" name="tempFileList">
    
    <cfloop query="tempFileList">
    
		<!--- Delete File --->
        <cffile action="delete" file="#APPLICATION.PATH.uploadDocumentTemp##tempFileList.name#">            
	
    </cfloop>

</cfsilent>

<cfoutput>

    <p>Files Successfully Deleted from #APPLICATION.PATH.uploadDocumentTemp# folder.</p>    

</cfoutput>