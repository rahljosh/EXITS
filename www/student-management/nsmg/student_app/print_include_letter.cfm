<cfoutput>

	<cfscript>
        // These are used to set the vStudentAppRelativePath directory for images nsmg/student_app/pics and uploaded files nsmg/uploadedFiles/
        // Param Variables
        param name="vStudentAppRelativePath" default="";
        param name="vUploadedFilesRelativePath" default="../";
        
        if ( LEN(URL.curdoc) ) {
            vStudentAppRelativePath = "";
            vUploadedFilesRelativePath = "../";
        }
    </cfscript>
    
    <cfdirectory directory="#AppPath.onlineApp.letters#/#doc#" name="letter" filter="#get_student_info.studentid#.*">	

	<cfif letter.recordcount NEQ '0' AND ListFind("jpg,peg,gif,bmp,tif", LCase(Right(letter.name, 3)))>
        <div style="page-break-after:always;"></div><br>
        <table width="660" border="0" cellpadding="0" cellspacing="0" align="center">
            <tr><td><img src="#vStudentAppRelativePath#uploadedfiles/letters/#doc#/#letter.name#" width="660" height="820"></td></tr>
        </table>
    </cfif>
    
</cfoutput>