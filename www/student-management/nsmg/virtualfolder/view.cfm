
<script src="linked/js/jquery.colorbox.js"></script>
	
<!----open window details---->
<script type="text/javascript">
	$(document).ready(function(){
		//Examples of how to assign the ColorBox event to elements
		
		$(".iframe").colorbox({width:"60%", height:"60%", iframe:true, 
		
		   onClosed:function(){ location.reload(true); } });
	
	});
    
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
	// print images
	function OpenApp(url)
	{ 
		newwindow=window.open(url, 'ViewFile', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); 
		if (window.focus) {newwindow.focus()}
	}
	
	// confirm deletion
	function confirmDelete(id) {
		if (confirm("Are you sure you want to delete this file?")) {
			window.location.href = "qr_internal_delete_file.cfm?fileID="+id;
		}
	}
</script>

<!--- Import CustomTag --->
<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
    
<style type="text/css">    
    .alert{
	width:auto;
	height:20px;
	border:#666;
	background-color:#FFC;
	text-align:center;
	-moz-border-radius: 15px;
	border-radius: 15px;
	vertical-align:center;
	color:#000000;
	text-align:left;

}
</style>

<!--- Param URL Variables --->
<cfparam name="URL.unqID" type="string" default="">
<cfparam name="URL.placement" type="integer" default="0">
<cfparam name="URL.hostid" type="integer" default="0">
<cfparam name="FORM.isDeleted" type="integer" default="0">
<cfparam name="url.vfid" type="integer" default="0">
<cfparam name="url.unDelete" type="integer" default="0">
<cfparam name="url.How" type="string" default="">
<cfparam name="url.deleted" type="string" default="0">
<cfparam name="fileDeleted" type="integer" default="0">
    
<cfif val(url.deleted) and client.usertype lte 2>
	<cfset form.isDeleted = 1>
</cfif>
	
<cfif val(url.vfid)>
	<cfif ((userid eq client.userid) OR (client.usertype lte 2)) AND url.how is not 'auto'>
		<cfquery datasource="#application.dsn#">
            update virtualfolder
            set isDeleted = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            where vfid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.vfid#">
                <Cfset fileDeleted = "#url.vfid#">
        </cfquery>
		<cfif val(url.unDelete)>
            <cfquery datasource="#application.dsn#">
                update virtualfolder
                set isDeleted = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                where vfid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.vfid#">
            </cfquery>
        	<cflocation url="index.cfm?curdoc=virtualFolder/view&unqid=#url.unqid#">
        </cfif>
	</cfif>
</cfif>
    
<cfscript>
	// Get Student Info
	qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(uniqueID=URL.unqID);
</cfscript>
    
<cfif url.unqID is ''>
	<cfset url.unqid =  "#qGetStudentInfo.uniqueID#">
</cfif>
    
<cfscript>
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

	// Get Folder Path 
	flightInfoDirectory = "#APPLICATION.PATH.onlineApp.internalVirtualFolder##qGetStudentInfo.studentid#/#selectedPlacement#/flightInformation";

	// Make sure the folder Exists
	AppCFC.UDF.createFolder(flightInfoDirectory);
</cfscript>

<cfdirectory directory="#flightInfoDirectory#" name="flightDocs" sort="datelastmodified DESC" filter="*.*">
    
    <cfquery name="qGetOtherFiles" datasource="#application.dsn#">
    	SELECT vf.fileName, vf.dateAdded, vf.filePath, vfc.categoryName, vfd.documentType, u.firstname, u.lastname , u.userid, vf.generatedHow, vf.uploadedBy, vf.vfid,
        h.familylastname, vf.fk_hostid, vfd.viewPermissions
        FROM virtualfolder vf
        LEFT JOIN virtualfolderDocuments vfd on vfd.id = vf.fk_documentType
        LEFT JOIN virtualFolderCategory vfc on vfc.categoryID = vfd.fk_category
        LEFT JOIN smg_users u on u.userid = vf.uploadedBy
        LEFT JOIN smg_hosts h on h.hostid = vf.fk_hostID
        WHERE vf.fk_studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.studentID#">
       <cfif val(url.hostID)> AND vf.fk_hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.hostID#"></cfif>
       and isDeleted = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.isDeleted#">
        ORDER by categoryName
    </cfquery>
    <cfif VAL(url.placement)>
    	<cfset currentDirectory = "#AppPath.onlineApp.virtualFolder##qGetStudentInfo.studentID#/#qGetStudentInfo.hostID#">
   	<cfelse>
    	<cfset currentDirectory = "#AppPath.onlineApp.virtualFolder##qGetStudentInfo.studentID#">
    </cfif>
	<!--- Check to see if the Directory exists. --->
    <cfif NOT DirectoryExists(currentDirectory)>
       <!--- If TRUE, create the directory. --->
       <cfdirectory action = "create" directory = "#currentDirectory#" mode="777">
    </cfif>
    <cfdirectory directory="#currentDirectory#" name="mydirectory" sort="datelastmodified DESC" filter="*.*">
    <cfquery name="qGetUploadedFiles" datasource="#APPLICATION.DSN#">
    	SELECT v.fileName, v.dateAdded, v.filePath,  v.generatedHow, v.uploadedBy, v.vfid, v.fk_hostid, u.userID, u.firstName, u.lastName,  vfd.documentType, vfc.categoryName
        FROM virtualfolder v
        LEFT JOIN virtualFolderDocuments vfd on vfd.id = v.fk_documentType
        LEFT JOIN virtualFolderCategory vfc on vfc.categoryID = vfd.fk_category
        LEFT JOIN smg_users u on u.userID = v.uploadedBy
        WHERE v.fk_studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.studentID#">
        <cfif VAL(URL.hostID)>
        	AND v.fk_hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.hostID#">
        </cfif>
        AND <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userType)#"> IN (SELECT categoryAccessList FROM virtualfoldercategory WHERE categoryID = v.fk_categoryID)
    </cfquery>
    <cfquery name="check_allergies" datasource="#application.dsn#">
        select has_an_allergy
        from smg_student_app_health
        where studentid = #qGetStudentInfo.studentID#
    </cfquery>

<!--- Page Header --->
<div class="rdholder" style="width:100%; float:right;"> 

	<cfoutput>
 
		<!--- Page Messages --->
        <cfif val(form.isDeleted)>
            <div class="alert">
                <em>You are viewing files that have been deleted.</em>
            </div>
        </cfif>

		<cfif val(fileDeleted)>
            <div class="alert">
                <em>
                    A file was recently deleted. You can still undelete this file if you didn't mean to delete it. 
                    <a href="index.cfm?curdoc=virtualFolder/view&unqid=#url.unqid#&vfid=#vfid#&unDelete=1">Undo Delete</a>
                </em>
            </div>
        </cfif>
        
        <br />
         
 		<cfset currentCategory = ''>             
    
    	<div class="rdtop"> 
        	<span class="rdtitle">Virtual Folder  &nbsp; - &nbsp; #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentid#) </span> 
        	<cfif client.usertype eq 8>
        		<em><a href="?curdoc=intrep/int_student_info&unqid=#qGetStudentInfo.uniqueid#">back to student profile</a></em>
        	<cfelse>
        		<em><a href="?curdoc=student_info&studentID=#qGetStudentInfo.studentid#">back to student profile</a></em>
    		</cfif>
        	<cfif client.usertype lte 2>
        		<a href="?curdoc=virtualFolder/view&deleted=<cfif form.isDeleted eq 0>1<cfelse>0</cfif>&unqid=#url.unqid#" class="floatRight"><img src="pics/buttons/trash23x23.png" border="0" /></a>
    		</cfif>
    	</div>
    
    	<div class="rdbox">
        	<form method="post" action="index.cfm?curdoc=virtualFolder/createEdit">
				<cfset currentCategory = ''>
				<table>
                    <tr>
                        <td align="left">Host Family</td>
                        <td>
                            <select name="hostFamily" onchange="changePlacement(this)">
                                <option value="0&unqid=#url.unqid#">All</option>
                                <cfloop query="qGetStudentPlacements">
                                    <option value="#historyID#&hostID=#hostID#&unqid=#url.unqid#" <cfif url.hostID eq hostID>selected</cfif>>#familylastname# (#hostid#)</option>
                                </cfloop>
                            </select>
                        </td>
                    </tr>
                </table>

                <br />
                <br />

    			<table cellpadding=4 cellspacing="0" width=100%>
                    <tr>
                        <th align="left">Document Type</th><th align="left">Document Name</th><th align="left">Upload Date</th><Th align="left">Uploaded By</Th><th align="left">Upload Type</Th>
                     </tr>
     				<cfloop query="qGetOtherFiles">
     					<cfif currentCategory neq #categoryName#>
        					<cfset currentCategory = '#categoryName#'>
                            <tr bgcolor="##CCCCCC">
                                <td colspan=6 align="left"><strong>#categoryName#</strong></td>
                            </tr>
       					 </cfif>
   						<cfif listFind(viewPermissions, client.usertype)>
                            <tr>
                                <td>#documentType#</td>
                                <td><a href="#filePath##filename#" target="_blank">#filename# <cfif val(fk_hostID)> - #familyLastName#</cfif></a></td>
                                <td>#DateFormat(dateAdded, 'mmm d, yyyy')#</td>
                                <td><cfif NOT VAL(uploadedBy) AND generatedHow EQ "auto">System<cfelse>#firstname# #lastname#</cfif></td>
                                <td>#generatedHow#</td>
                                <td>
                           			<cfif ((userid eq client.userid) OR (client.usertype lte 4)) AND generatedHow is not 'auto'>
                                		<a href="index.cfm?curdoc=virtualFolder/view&unqid=#url.unqid#&vfid=#vfid#&how=#generatedHow#&undelete=<cfif form.isDeleted eq 0>0<cfelse>1</cfif>">
                                    		<img src="pics/deletex.gif" height="10" border=0/>
                                 		</a>
                                    </cfif>
                              	</td>
                            </tr>
  						</cfif>
    				</cfloop>
					<!----Flight Info that was auto generated prior to new VF (Feb 26, 2013)---->
					<cfif not val(form.isDeleted)>
    					<cfif flightDocs.recordcount gt 0>
                            <tr bgcolor="##CCCCCC">
                                <td colspan=6 align="left" ><strong>Pre-AYP 12/13 Flight Info</strong></td>
                            </tr>
         					<cfloop query="flightDocs">
                				<tr>
                                	<td>Flight Information</td>
                                    <td><a href="uploadedfiles/internalVirtualFolder/#qGetStudentInfo.studentID#/#selectedPlacement#/flightInformation/#name#" target="_blank">#name#</a></td> 	
                                    <td>#DateFormat(dateLastModified,'mmm d, yyyy')#</td>
                                    <td>System</td>
                                    <td>Auto</td>
                              	</tr>
            				</cfloop>
     					</cfif>
                        <cfif VAL(mydirectory.recordcount)>
                            <tr bgcolor="##CCCCCC">
                                <td colspan=6 align="left"><strong>Supplements on Student App</strong></td>
                            </tr> 
							<cfif VAL(check_allergies.has_an_allergy)>
                                <tr>
                                    <td><a href="?curdoc=student_app/section3/allergy_info_request">Allergy Clarification Form</a></td>
                                </tr>
                            </cfif>
           					<cfloop query="qGetUploadedFiles">
                				<tr>
                                    <td>#documentType#</td>
                                    <td><a href="javascript:OpenApp('#filePath#/#fileName#');" target="_blank">#fileName#</a></td>
                                    <td>#DateFormat(dateAdded,'mmm d, yyyy')#</td>
                                    <td>
                                        <cfif generatedHow EQ "auto">
                                            System
                                        <cfelse>
                                            #firstName# #lastName# (###userID#)
                                        </cfif>
                                    </td>
                    				<td>#generatedHow#</td>	
                				</tr>
            				</cfloop>
        				</cfif>
    				</cfif>
				</table>
    
    			<div align="center">
     				<table>
     					<tr>
                        	<td><a href="?curdoc=student_info&studentID=#qGetStudentInfo.studentid#"><img src="pics/buttons/close.png" alt="Close Window" border=0></a></td>
            				<td><a class='iframe' href="virtualFolder/uploadEdit.cfm?unqid=#qGetStudentInfo.uniqueID#"><img src="pics/buttons/uploadNewDoc.png" alt="New Document Type" border=0></a></td>
      					</tr>
    				</table>
     			</div>
  
  				<div align="center">
                	<br />
                </div>
                
         	</form>
            
     	</div>
        
 	</cfoutput>
    
    <div class="rdbottom"></div> <!-- end bottom --> 
    
</div>
