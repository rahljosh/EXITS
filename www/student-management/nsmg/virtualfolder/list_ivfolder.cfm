<!--- ------------------------------------------------------------------------- ----
	
	File:		list_ivfolder.cfm
	Author:		James Griffiths
	Date:		September 28, 2012
	Desc:		Displays, upload and delete files in internal virtual folder (only available for office users)

----- ------------------------------------------------------------------------- --->

<!--- DO NOT DISPLAY THIS PAGE IF THIS IS NOT AN OFFICE USER --->
<cfif NOT APPLICATION.CFC.USER.isOfficeUser()>
	<link rel="stylesheet" href="../smg.css" type="text/css">    
    <br />
    <table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
        <tr valign=middle height=24>
            <td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
            <td width=26 background="../pics/header_background.gif"><img src="../pics/helpdesk.gif"></td>
            <td background="../pics/header_background.gif"><h2>Students View - Error </h2></td>
            <td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
        </tr>
    </table>
    <table width=100% border=0 cellpadding=4 cellspacing=0 class="section">
        <tr>
            <td align="center">
                <br />
                <div align="justify">
                	<img src="../pics/error_exclamation.gif" align="left">
                    <h3>
                		<p>I am sorry but you do not have the rights to see this page.</p>
                        <p>If you think this is a mistake please contact <cfoutput>#APPLICATION.EMAIL.support#</cfoutput></p>
                 	</h3>
             	</div>
            </td>
        </tr>
    <tr><td align="center"><input type="image" value="Back" onClick="history.go(-1)" src="../pics/back.gif"></td></tr>
    </table>
    <table width=100% cellpadding=0 cellspacing=0 border=0>
        <tr valign="bottom"><td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td>
            <td width=100% background="../pics/header_background_footer.gif"></td>
            <td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td>
        </tr>
    </table>
	<cfabort>
</cfif>

<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
    
    <!--- Param URL Variables --->
    <cfparam name="URL.unqID" type="string" default="">
    <cfparam name="URL.placement" type="integer" default="0">

	<cfscript>
        // Make sure there is a unqID
		if ( NOT LEN(URL.unqID) ) { 
			include "error_message.cfm";
			abort;
		}
		
		// Get Student Info
        qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(uniqueID=URL.unqID);
		
		// Get Student Placements
		qGetStudentPlacements = APPLICATION.CFC.STUDENT.getPlacementHistory(studentID=qGetStudentInfo.studentID);
		
		// Set the currently selected placement
		if (URL.placement EQ 0) {
			selectedPlacement = qGetStudentPlacements.historyID; // Select the first returned placement if nothing is selected.
		} else {
			selectedPlacement = URL.placement;
		}
		
		// Get Selected Placement details
		qGetSelectedPlacementDetails = APPLICATION.CFC.STUDENT.getPlacementHistory(studentID=qGetStudentInfo.studentID,historyID=selectedPlacement);
		
        // Get Category List
        qGetInternalVirtualFolderCategoryList = APPLICATION.CFC.LOOKUPTABLES.getApplicationLookUp(fieldKey='internalVirtualFolderCategory');
    
        // Get Folder Path 
        currentDirectory = "#APPLICATION.PATH.onlineApp.internalVirtualFolder##qGetStudentInfo.studentid#/#selectedPlacement#";
    
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

		<script type="text/javascript">
            function ProcessForm() {
               if (document.Upload.UploadFile.value == '') {
                  alert("You must specify a file.");
                  document.Upload.UploadFile.focus();
                  return false;
               } else if (document.Upload.category.value == 0) {
                  alert("You must select an option to upload your file.");
                  document.Upload.category.focus();
                  return false;
                } else if (document.Upload.category.value == '6' & document.Upload.other_category.value == '') {
                  alert("You've selected 'other' as an option. You must complete the text box.");
                  document.Upload.other_category.focus();
                  return false;
                } else {
                  return true;
                }
            }
            function enableField()
            {
                document.Upload.other_category.disabled=true;
				document.Upload.other_category.required=false;
				document.Upload.other_category.value = '';
            }
            function areYouSure() { 
               if(confirm("You are about to delete this file. Click OK to continue")) { 
                 form.submit(); 
                    return true; 
               } else { 
                    return false; 
               } 
            }
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
			
			// Reloads with the chosen placement (assumes that unqID is the only other url variable)
			function changePlacement(selected) {
				var place = selected.options[selected.selectedIndex].value;
				var newLocation = window.location.href;
				if (window.location.href.indexOf('&') > -1) {
					newLocation = window.location.href.substring(0,window.location.href.indexOf('&'));
				}
				newLocation = newLocation + "&placement=" + place;
				window.location.href = newLocation;
			}
        </script>

		<!--- Table Header --->
        <gui:tableHeader
            imageName="helpdesk.gif"
            tableTitle="Internal Virtual Folder &nbsp; - &nbsp; #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentid#)"
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
            	<th><h2>Welcome to the Internal Virtual Folder</h2></th>
            </tr>
            <tr>
            	<td style="text-align:justify;">
                	<p>
                        In this feature you can upload as many files as you want for your student. For each file upload a notification will be sent out to inform
                        the appropriate people that you have uploaded a file.
                    </p>
                    
                    <p>
    	                Each student has his/her own Internal Virtual Folder so please do not upload a file that does not belong to this record.
                    </p>
                    
                    <p>
                    	The files are organized by the student's placement. Please be sure to select the correct placement when uploading a new file.
                  	</p>
                    
                    <p style="font-weight:bold;">PS: There is a limit of 4mb per file.</p>
                </td>
           </tr>
        </table>

        <table width="98%" border="0" cellpadding="4" cellspacing="0" class="section" align="center" style="padding-bottom:15px;">
        	<tr>
                <th colspan="5" align="center">Placement:
                	<select onchange="changePlacement(this)">
                    	<cfloop query="qGetStudentPlacements">
                        	<option value="#historyID#"<cfif URL.placement EQ #historyID#>selected="selected"</cfif>>#familyLastName# (###hostID#)</option>
                        </cfloop>
                 	</select>
             	</th>
            </tr>
            
     		<cfloop query="qGetInternalVirtualFolderCategoryList">
            
 				<tr>
                	<th colspan="5" align="center" style="border-bottom:thin solid black;">#name#</th>
              	</tr>
                
                <tr bgcolor="##e2efc7" style="font-weight:bold;">
                    <td>Name</td>
                    <td>Size</td>
                    <td>Upload Date</td>
                    <td align="center">View</td>
                    <td align="center">Delete</td>
            	</tr>
                
                <cfquery name="qGetFilesInCategory" datasource="#APPLICATION.DSN#">
                    SELECT 
                        ivf.studentid, 
                        ivf.fileName,
                        ivf.fileSize
                    FROM 
                        smg_internal_virtual_folder ivf
                    WHERE 
                        ivf.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.studentid#">
                    AND 
                        ivf.categoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#fieldID#">
                  	AND
                    	ivf.placementID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(selectedPlacement)#">
                </cfquery>
                
                <cfif NOT VAL(qGetFilesInCategory.recordcount)>
                    <tr><td colspan="5">No file has been uploaded.</td></tr>
                </cfif>
                
                <cfloop query="qGetFilesInCategory">
                
                	<cfquery name="qGetFileInFolder" dbtype="query">
                    	SELECT
                        	*
                       	FROM
                        	qGetStudentFolder
                      	WHERE
                        	name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetFilesInCategory.fileName#">
                   		AND 
                        	size = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetFilesInCategory.fileSize#"> 
                    </cfquery>
                
                    <tr bgcolor="###iif(currentrow MOD 2 ,DE("FFFFE6") ,DE("FFFFFF") )#">
                        <td>#qGetFileInFolder.name#</td>
                        <td>#APPLICATION.CFC.UDF.displayFileSize(qGetFileInFolder.size)#</td>
                        <td>#DateFormat(qGetFileInFolder.dateLastModified,'mmm d, yyyy')#</td>
                        <td align="center">
                            <cfif ListFind("jpg,peg,gif,tif,bmp", LCase(Right(qGetFileInFolder.name, 3)))>
                                <!--- Display Link for Images --->
                                <a href="javascript:PrintFile('print_internal_file.cfm?studentid=#qGetStudentInfo.studentid#&placement=#selectedPlacement#&file=#qGetFileInFolder.name#');">
                                    <img src="vfolderview.gif" border="0" alt="View File"></img>
                                </a>
                            <cfelse>
                                <form method="post" action="view_file.cfm">
                                    <input type="hidden" name="fPath" value="#APPLICATION.PATH.onlineApp.internalVirtualFolder##qGetStudentInfo.studentid#/#selectedPlacement#/#qGetFileInFolder.name#">
                                    <input type="hidden" name="fName" value="#qGetStudentFolder.name#">
                                    <input type="image" src="vfolderview.gif" border="0" alt="View File">
                                </form>
                            </cfif>
                        </td>
                        <td align="center">
                            <form method="post" action="qr_internal_delete_file.cfm" name="Delete">
                                <input type="hidden" name="directory" value="#currentDirectory#">
                                <input type="hidden" name="DeleteFile" value="#qGetFileInFolder.name#">
                                <input type="hidden" name="filesize" value="#qGetFileInFolder.size#">
                                <input type="hidden" name="unqID" value="#qGetStudentInfo.uniqueid#">
                                <input type="image" name="submit" src="vfolderdelete.gif" alt="Delete this file" onclick="return areYouSure(this);"> 
                            </form>				
                        </td>
                    </tr>
                    
              	</cfloop>
            
            </cfloop>
          	
            <!--- School Acceptance Letter --->
            <tr>
                <th colspan="5" align="center" style="border-bottom:thin solid black;">School Acceptance Letter</th>
            </tr>
            
            <tr bgcolor="##e2efc7" style="font-weight:bold;">
                <td colspan="5" align="center">View</td>
            </tr>
            
            <tr bgcolor="##FFFFE6">
                <td colspan="5" align="center">
                    <a href="javascript:PrintFile('school_acceptance.cfm?studentid=#qGetStudentInfo.studentid#&hostID=#qGetSelectedPlacementDetails.hostID#&type=view');">
                        <img src="vfolderview.gif" border="0" alt="View File"></img>
                    </a>
                </td>
            </tr>
            
            <!--- Host Family Application Documents --->
            <!---
            <tr>
                <th colspan="5" align="center" style="border-bottom:thin solid black;">Host Family Application Documents</th>
            </tr>
            
            <tr bgcolor="##e2efc7" style="font-weight:bold;">
                <td>Name</td>
                <td>Size</td>
                <td>Upload Date</td>
                <td colspan="2" align="center">View</td>
            </tr>
            
            <tr bgcolor="##FFFFE6">
                <td></td>
                <td></td>
                <td></td>
                <td colspan="2" align="center">
                    <a href="javascript:PrintFile('school_acceptance.cfm?studentid=#qGetStudentInfo.studentid#&hostID=#qGetSelectedPlacementDetails.hostID#&type=view');">
                        <img src="vfolderview.gif" border="0" alt="View File"></img>
                    </a>
                </td>
            </tr>
			--->
        </table>
<cfset currentDirectory = "#AppPath.onlineApp.internalVirtualFolder##qGetStudentInfo.studentID#">
<!--- Check to see if the Directory exists. --->
<cfif NOT DirectoryExists(currentDirectory)>
   <!--- If TRUE, create the directory. --->
   <cfdirectory action = "create" directory = "#currentDirectory#" mode="777">
</cfif>
<table width="98%" border="0" cellpadding="4" cellspacing="0" class="section" align="center">
        	<Tr>
            	<td><br />
                </td>
            </Tr>
        </table>
   <cfif client.usertype lte 4 or client.usertype eq 8>
		<!--- UPLOADING FILES --->
        <form method="post" action="qr_internal_upload_file.cfm" name="Upload" enctype="multipart/form-data" onSubmit="return ProcessForm()">
        	<input type="hidden" name="unqID" value="#qGetStudentInfo.uniqueid#" />
            <input type="hidden" name="placementID" value="#selectedPlacement#" />
            
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
                        	<cfloop query="qGetInternalVirtualFolderCategoryList">
                        		<option value="#qGetInternalVirtualFolderCategoryList.fieldID#">#qGetInternalVirtualFolderCategoryList.name#</option>
                        	</cfloop>
                        </select>
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