<!--- ------------------------------------------------------------------------- ----
	
	File:		upload_picture.cfm
	Author:		Marcus Melo
	Date:		February 2, 2011
	Desc:		Uploads a school picture for PHP front end

	Updated:	
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Param URL Variables --->
    <cfparam name="URL.schoolID" default="0">

	<!--- Param FORM Variables --->
	<cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.schoolID" default="0">
    <cfparam name="FORM.schoolFile" default="">

	<cfscript>
		// Store errors
		errors = '';
	</cfscript>

	<cfif FORM.submitted AND VAL(FORM.schoolID) AND LEN(FORM.schoolFile)>

		<!----Upload File---->
		<cffile action = "upload"
				destination = "#APPLICATION.PATH.PHP.schools#"
				fileField = "FORM.schoolFile"
				nameConflict = "makeunique">

		
		<!----Rename Image According to School ID--->
        <cffile	
            action="Move" 
            source="#APPLICATION.PATH.PHP.schools##CFFILE.ServerFile#" 
            destination="#APPLICATION.PATH.PHP.schools##FORM.schoolID#.#CFFILE.clientfileext#"> 
		
        <!--- <cffile action="delete" file="#APPLICATION.PATH.PHP.schools##CFFILE.ServerFile#"> --->
	
    <cfelseif FORM.submitted>
    	
		<cfscript>
            // Store errors
            Errors = 'An error has occurred. Please make sure you upload a valid JPG file.';
        </cfscript>
    
	</cfif>
		
</cfsilent>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>School Image Upload</title>
<link rel="stylesheet" href="../phpusa.css" type="text/css">
</head>

<body>

<cfoutput>

<cfform action="#cgi.SCRIPT_NAME#?#cgi.QUERY_STRING#" method="post" enctype="multipart/form-data" preloader="no">
<input type="hidden" name="submitted" value="1" />
<input type="hidden" name="schoolID" value="#URL.schoolID#" />

<!----End of School Includes---->
<table width="90%" border="1" align="center" cellpadding="8" cellspacing="8" bordercolor="##C7CFDC" bgcolor="##ffffff">
	<tr>
        <td colspan="10"  class="box">
            <table border="0" cellpadding="3" cellspacing="0" width="100%">
				<tr bgcolor="##C2D1EF"><th><b>School Image Upload</b></th></tr>
                <cfif FORM.submitted AND NOT LEN(errors)>
					<tr>
                    	<td align="center">
		                    <h3>The picture was succesfully  uploaded. Close this window to continue entering information.</h3><br>
		                    <input type="image" value="close window" src="../pics/close.gif" alt="Close Window" onClick="javascript:window.close()">
						</td>
                    </tr>                    
                <cfelseif FORM.submitted AND LEN(errors)>
					<tr>
                    	<td align="center" style="color:##F00">#errors#<cfdump var="#form#"></td>
                    </tr>                    
				</cfif>
			</table>
            <br /><br />
            <table border="0" cellpadding="3" cellspacing="0" width="100%">
                <tr>
                    Use this form to assign the picture that will show on the school profile page. 
                    Picture must be in .JPG format. 
                    <br><br>
                    <div align="center">
                        Browse for the file... <input type="file" name="schoolFile" size=35  enctype="multipart/form-data">
                        <br>
                        *image type needs to be a .jpg
                    	<br><br>
                    	<Input type="image" src="../pics/save.gif" alt="Upload Picture to Server">
                    </div>
                </tr>
			</table>
		</td>
	</tr>
</table>

</cfform>

</cfoutput>

</body>
</html>