<cfoutput>

	<cfscript>
        // These are used to set the vStudentAppRelativePath directory for images nsmg/student_app/pics and uploaded files nsmg/uploadedFiles/
        // Param Variables
        param name="vStudentAppRelativePath" default="";
        param name="vUploadedFilesRelativePath" default="";
        
        if ( LEN(URL.curdoc) ) {
            vStudentAppRelativePath = "";
            vUploadedFilesRelativePath = "";
        }
    </cfscript>
    
    <cfdirectory directory="#AppPath.onlineApp.inserts#/#doc#" name="file" filter="#client.studentid#.*">	
    
    <cfif ListFind("jpg,peg,gif,tif,png", LCase(Right(file.name, 3)))>
        <table width="660" border="0" cellpadding="0" cellspacing="0" align="center">
            <tr><td><img src="#vUploadedFilesRelativePath#uploadedfiles/online_app/#doc#/#file.name#" width="660" height="820"></td></tr>
        </table>
        <cfset printpage = 'no'>
    <cfelse>
        <cfset printpage = 'yes'>
    </cfif>

</cfoutput>