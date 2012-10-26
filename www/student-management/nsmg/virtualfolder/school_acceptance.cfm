<!--- ------------------------------------------------------------------------- ----
	
	File:		school_acceptance.cfm
	Author:		James Griffiths
	Date:		October 12, 2012
	Desc:		Allows viewing of school acceptance letters.
				-they are stored in a different folder than the other internal virtual folder documents

----- ------------------------------------------------------------------------- --->

<cfsilent>
	
    <cfparam name="URL.studentID" default="0">
    <cfparam name="URL.hostID" default="0">
    
    <cfquery name="checkAcceptance" datasource="#APPLICATION.DSN#">
    	SELECT *
      	FROM smg_documents
      	WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.hostID)#">
      	AND shortDesc = 'School Acceptance'
    </cfquery>
    
    <cfscript>
		// Set the type of files that are accepted
		acceptedFiles = 'jpg,JPG,jpeg,JPEG';
		
		// Get Folder Path
		currentDirectory = "#APPLICATION.PATH.uploadedFiles#hosts/#URL.hostID#";
		
		// Make sure the folder Exists
        AppCFC.UDF.createFolder(currentDirectory);
		
	</cfscript>
    
</cfsilent>

<cfsavecontent variable="letter">

	<cfoutput>
    	<h2 align="center">School Acceptance Letter</h2>
        <hr width=80% align="center" height=1px />
        <cfif checkAcceptance.recordcount gt 0>
            <table width=50% align="center">
                <tr>
                    <td colspan=2 align="center">
                     #checkAcceptance.description#
                   </td>
                </tr>
            </table>
        </cfif>
        <div id="slidingDiv" display:"none" align="center"> 
            <img src="#currentDirectory#/#checkAcceptance.fileName#">
        </div>
    </cfoutput>

</cfsavecontent>

<cfoutput>
	<cfset fileName="SchoolAcceptance#CLIENT.studentID#_#DateFormat(NOW(),'mm-dd-yyyy')#-#TimeFormat(NOW(),'hh-mm')#.pdf">
    <cfdocument format="pdf" filename="#fileName#" overwrite="yes" orientation="portrait" name="uploadFile">
        #letter#
    </cfdocument>
    <cfheader name="Content-Disposition" value="attachment; filename=#fileName#">
    <cfcontent type="application/pdf" file="#GetDirectoryFromPath(GetCurrentTemplatePath())##fileName#" deletefile="yes">
</cfoutput>