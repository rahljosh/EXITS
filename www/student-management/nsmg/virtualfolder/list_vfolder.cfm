<!--- ------------------------------------------------------------------------- ----
	
	File:		list_vfolder.cfm
	Author:		Marcus Melo
	Date:		July 1, 2011
	Desc:		Displays, upload and delete files in virtual folder

	Updated:  	07/01/2011 - Phasing out table smg_virtual_folder_cat

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
    
    <!--- Param URL Variables --->
    <cfparam name="URL.unqID" type="string" default="">

	<cfscript>
        // Make sure there is a unqID
		if ( NOT LEN(URL.unqID) ) { 
			include "error_message.cfm";
			abort;
		}
		
		// Get Student Info
        qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(uniqueID=URL.unqID);
        
        // Get Category List
        qGetVirtualFolderCategoryList = APPLICATION.CFC.LOOKUPTABLES.getApplicationLookUp(fieldKey='virtualFolderCategory', sortBy='name');
    
        // Get Folder Path 
        currentDirectory = "#APPLICATION.PATH.onlineApp.virtualFolder##qGetStudentInfo.studentid#";
    
        // Make sure the folder Exists
        AppCFC.UDF.createFolder(currentDirectory);
    </cfscript>

	<cfdirectory directory="#currentDirectory#" name="qGetStudentFolder" sort="datelastmodified DESC" filter="*.*">
    
</cfsilent>    

<cfoutput>

	<!--- Page Header --->
    <gui:pageHeader
        headerType="applicationNoHeader"
    />	

		<script language="JavaScript">
            <!--
            function ProcessForm() {
               if (document.Upload.UploadFile.value == '') {
                  alert("You must specify a file.");
                  document.Upload.UploadFile.focus();
                  return false;
               } else if (document.Upload.category.value == 0) {
                  alert("You must select an option to upload your file.");
                  document.Upload.category.focus();
                  return false;
                } else if (document.Upload.category.value == '4' & document.Upload.other_category.value == '') {
                  alert("You've selected 'other' as an option. You must complete the text box.");
                  document.Upload.other_category.focus();
                  return false;
                } else {
                  return true;
                }
            }
            function enableField()
            {
                if (document.Upload.category.value == '4') {
                    document.Upload.other_category.disabled=false;
                    document.Upload.other_category.required=true;
                    document.Upload.other_category.focus();
                    document.Upload.other_category.value = '';
                } else {
                    document.Upload.other_category.disabled=true;
                    document.Upload.other_category.required=false;
                    document.Upload.other_category.value = '';
                }
            }
            function areYouSure() { 
               if(confirm("You are about to delete this file. Click OK to continue")) { 
                 form.submit(); 
                    return true; 
               } else { 
                    return false; 
               } 
            } 
            <!--
            // print images
            function PrintFile(url)
            {
                newwindow=window.open(url, 'PrintFile', 'height=580, width=790, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); 
                if (window.focus) {newwindow.focus()}
            }
			function OpenApp(url)
			{ 
				newwindow=window.open(url, 'ViewFile', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); 
				if (window.focus) {newwindow.focus()}
			}
            // -->
        </script>

		<!--- Table Header --->
        <gui:tableHeader
            imageName="helpdesk.gif"
            tableTitle="Virtual Folder &nbsp; - &nbsp; #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentid#)"
            tableRightTitle="#qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentID#)"
            width="98%"
            imagePath="../"
        />    
        
		<!--- Page Messages --->
        <gui:displayPageMessages 
            pageMessages="#SESSION.pageMessages.GetCollection()#"
            messageType="tableSection"
            width="98%"
            />

        <!--- Form Errors --->
        <gui:displayFormErrors 
            formErrors="#SESSION.formErrors.GetCollection()#"
            messageType="tableSection"
            width="98%"
            />

        <table width="98%" border="0" cellpadding="4" cellspacing="0" class="section" align="center" style="padding-top:10px; padding-bottom:15px;">
            <tr>
            	<th><h2>Welcome to the Virtual Folder</h2></th>
            </tr>
            <tr>
            	<td style="text-align:justify;">
                	<p>
                        In this new feature you can upload as many files as you want for your student. For each file upload a notification will be sent out to inform
                        the appropriate people that you have uploaded a file.
                    </p>
                    
                    <p>
	                    The students international representative will also receive an email with notification that a file was added the virtual folder.<br />
    	                Each student has his/her own Virtual Folder so please do not upload a file that does not belong to this record.
                    </p>
                    
                    <p style="font-weight:bold;">PS: There is a limit of 4mb per file.</p>
                </td>
           </tr>
        </table>

        <table width="98%" border="0" cellpadding="4" cellspacing="0" class="section" align="center" style="padding-bottom:15px;">
        	<tr>
            	<th colspan=6>Upload through Virtual Folder</th>
            </tr>
                
            <tr bgcolor="##e2efc7" style="font-weight:bold;">
                <td>Name</td>
                <td>Size</td>
                <td>Upload Date</td>
                <td>Category</td>
                <td align="center">View</td>
                <cfif ListFind("1,2,3,4,8", CLIENT.userType)>
                	<td align="center">Delete</td>
                </cfif>
            </tr>
            
            <cfif NOT VAL(qGetStudentFolder.recordcount)>
                <tr><td colspan="5">No file has been uploaded.</td></tr>
            </cfif>
            
            <cfloop query="qGetStudentFolder">
            
                <cfquery name="qGetFileInformation" datasource="MySql">
                    SELECT 
                        vf.studentid, 
                        vf.other_category,
                        alk.name AS category
                    FROM 
                        smg_virtualfolder vf
                    LEFT OUTER JOIN
                        applicationlookup alk ON alk.fieldID = vf.categoryID
                            AND 
                                alk.fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="virtualFolderCategory">
                    WHERE 
                        vf.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.studentid#">
                    AND 
                        vf.filename = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetStudentFolder.name#">
                    AND 
                        vf.filesize = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetStudentFolder.size#"> 
                </cfquery>
                
                <tr bgcolor="###iif(currentrow MOD 2 ,DE("FFFFE6") ,DE("FFFFFF") )#">
                    <td>#qGetStudentFolder.name#</td>
                    <td>#APPLICATION.CFC.UDF.displayFileSize(qGetStudentFolder.size)#</td>
                    <td>#DateFormat(qGetStudentFolder.dateLastModified,'mmm d, yyyy')#</td>
                    <td>#qGetFileInformation.category# <cfif LEN(qGetFileInformation.other_category)> &nbsp; - &nbsp; #qGetFileInformation.other_category#</cfif></td>
                    <td align="center">
                        <cfif ListFind("jpg,peg,gif,tif,bmp", LCase(Right(qGetStudentFolder.name, 3)))>
                            <!--- Display Link for Images --->
                            <a href="javascript:PrintFile('print_file.cfm?studentid=#qGetStudentInfo.studentid#&file=#qGetStudentFolder.name#');">
                                <img src="vfolderview.gif" border="0" alt="View File"></img>
                            </a>
                        <cfelse>
                            <form method="post" action="view_file.cfm">
                                <input type="hidden" name="fPath" value="#APPLICATION.PATH.onlineApp.virtualFolder##qGetStudentInfo.studentid#/#qGetStudentFolder.name#">
                                <input type="hidden" name="fName" value="#qGetStudentFolder.name#">
                                <input type="image" src="vfolderview.gif" border="0" alt="View File">
                            </form>
                        </cfif>
                    </td>
					<cfif ListFind("1,2,3,4,8", CLIENT.userType)>
                        <td align="center">
                            <form method="post" action="qr_delete_file.cfm" name="Delete">
                                <input type="hidden" name="directory" value="#currentDirectory#">
                                <input type="hidden" name="DeleteFile" value="#qGetStudentFolder.name#">
                                <input type="hidden" name="filesize" value="#qGetStudentFolder.size#">
                                <input type="hidden" name="unqID" value="#qGetStudentInfo.uniqueid#">
                                <input type="image" name="submit" src="vfolderdelete.gif" alt="Delete this file" onclick="return areYouSure(this);"> 
                            </form>				
                        </td>
                    </cfif>	
                </tr>
            </cfloop>
		
        </table>
<cfset currentDirectory = "#AppPath.onlineApp.virtualFolder##qGetStudentInfo.studentID#/page22">
<!--- Check to see if the Directory exists. --->
<cfif NOT DirectoryExists(currentDirectory)>
   <!--- If TRUE, create the directory. --->
   <cfdirectory action = "create" directory = "#currentDirectory#" mode="777">
</cfif>

<cfdirectory directory="#currentDirectory#" name="mydirectory" sort="datelastmodified DESC" filter="*.*">
<cfquery name="check_allergies" datasource="#application.dsn#">
select has_an_allergy
from smg_student_app_health
where studentid = #qGetStudentInfo.studentID#
</cfquery>
		<table width="98%" border="0" cellpadding="4" cellspacing="0" class="section" align="center">
        	<Tr>
            	<td><br />
                </td>
            </Tr>
        </table>
		   <table width="98%" border="0" cellpadding="4" cellspacing="0" class="section" align="center">
        	<tr>
            	<th colspan=6>Uploaded through Supplements on Student App</th>
            </tr>
      
	<tr bgcolor="##e2efc7" style="font-weight:bold;">
	  <td><em>Name</em></td>
	  <td><em>Size</em></td>
	  <td><em>Modified</em></td>
	  <td><em>View</em></td>
	  <td><!----<em>Delete</em>----></td>
	</tr>
    <cfif VAL(check_allergies.has_an_allergy)>
        <tr>
            <td><a href="?curdoc=section3/allergy_info_request">Allergy Clarification Form</a></td>
        </tr>
    </cfif>
    
	<cfif NOT VAL(mydirectory.recordcount)>
		<tr><td colspan="5">No file has been uploaded.</td></tr>
	</cfif>

	<cfloop query="mydirectory">
		<cfset newsize = mydirectory.size / '1024'>
        <tr bgcolor="#iif(mydirectory.currentrow MOD 2 ,DE("white") ,DE("CCCCCC") )#">
          <td><a href="javascript:OpenApp('../uploadedfiles/virtualfolder/#qGetStudentInfo.studentID#/page22/#name#');">#mydirectory.name#</a></td>
          <td>#Round(newsize)# kb</td>
          <td>#mydirectory.dateLastModified#</td>
          <td>
            <cfif ListFind("jpg,peg,gif,tif,png", Right(name, 3))>
                <a href="javascript:OpenApp('../student_app/section4/page22printfile.cfm?studentid=#qGetStudentInfo.studentID#&page=page22&file=#URLEncodedFormat(name)#');"><img src="vfolderview.gif" border="0" alt="View File"></img></a>
            <cfelse>
                <a href="javascript:OpenApp('../uploadedfiles/virtualfolder/#qGetStudentInfo.studentID#/page22/#name#');"><img src="vfolderview.gif" border="0" alt="View File"></img></a>
            </cfif>
          </td>	
        </tr>
	</cfloop>
</table>
<table width="98%" border="0" cellpadding="4" cellspacing="0" class="section" align="center">
        	<Tr>
            	<td><br />
                </td>
            </Tr>
        </table>
   <cfif client.usertype lte 4 or client.usertype eq 8>
		<!--- UPLOADING FILES --->
        <form method="post" action="qr_upload_file.cfm" name="Upload" enctype="multipart/form-data" onSubmit="return ProcessForm()">
        	<input type="hidden" name="unqID" value="#qGetStudentInfo.uniqueid#">	
            
            <table width="98%" border="0" cellpadding="4" cellspacing="0" class="section" align="center" style="padding-bottom:15px;">
                <tr><th bgcolor="e2efc7">U P L O A D I N G &nbsp; F I L E S </th></tr>
                <tr><td>Please upload your file here:</td></tr>
                <tr>
                    <td> 
                        Browse for the file..<br />
                        <input type="file" name="UploadFile" size="40"><br />
                    </td>
                </tr>
                <tr>
                    <td>
                        Please select a reason why are you uploading this file: (It will help our team to proccess it faster)<br />
                        <select name="category" onChange="enableField()">
                        	<option value="0">Select an Option</option>
                        	<cfloop query="qGetVirtualFolderCategoryList">
                        		<option value="#qGetVirtualFolderCategoryList.fieldID#">#qGetVirtualFolderCategoryList.name#</option>
                        	</cfloop>
                        </select>
                        &nbsp; &nbsp; 
                        Other: <input type="text" name="other_category" size="40" maxlength="45" value="" disabled>
                    </td>
                </tr>
                <tr><td align="center"><input name="submit" type="image" src="vfolderupload.gif" alt="Upload File"></td></tr>
                
                </tr>
            </table>
            
		</form>            
	</cfif>
        <table width="98%" border="0" cellpadding="4" cellspacing="0" class="section" align="center" style="padding-bottom:15px;">
            <tr><td align="center"><input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></td></tr>
        </table>
            
        <!--- Table Footer --->
        <gui:tableFooter 
  	        width="98%"
			imagePath="../"
        />

	<!--- Page Footer --->
    <gui:pageFooter
        footerType="application"
    />

</cfoutput>