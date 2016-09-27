<script src="linked/js/jquery.colorbox.js"></script>
	
<!----open window details---->
<script type="text/javascript">
	$(document).ready(function(){
		//Examples of how to assign the ColorBox event to elements
		
		$(".iframe").colorbox({width:"60%", height:"60%", iframe:true, 
		
		   onClosed:function(){ location.reload(true); } });
	
	});
    
	// Reloads with the chosen placement (assumes that uniqueid is the only other url variable)
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
<cfimport taglib="/extensions/customTags/gui/" prefix="gui" />	
    
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
<cfparam name="URL.uniqueid" type="string" default="">
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
		<cfquery datasource="MySql">
            update extra_virtualfolder
            set isDeleted = <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
            	expires = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
            where vfid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.vfid#">
                <Cfset fileDeleted = "#url.vfid#">
        </cfquery>
		<cfif val(url.unDelete)>
            <cfquery datasource="MySql">
                update extra_virtualfolder
                set isDeleted = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                where vfid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.vfid#">
            </cfquery>
        	<cflocation url="index.cfm?curdoc=virtualFolder/view&uniqueid=#url.uniqueid#">
        </cfif>
	</cfif>
</cfif>
    
<cfscript>
	// Get User Info
	qGetUserInfo = APPLICATION.CFC.USER.getUserByUniqueID(uniqueID=URL.uniqueID);
</cfscript>
    
<cfif url.uniqueid is ''>
	<cfset url.uniqueid =  "#qGetUserInfo.uniqueID#">
</cfif>
    
<cfscript>
	// Get Student Placements
	//qGetStudentPlacements = APPLICATION.CFC.STUDENT.getPlacementHistory(studentID=qGetUserInfo.studentID);
	
	// Set the currently selected placement
	//if (URL.placement EQ 0) {
	//	selectedPlacement = qGetStudentPlacements.historyID; // Select the first returned placement if nothing is selected.
	//} else {
	//		selectedPlacement = URL.placement;
	//}
	
	// Get Selected Placement details
	//qGetSelectedPlacementDetails = APPLICATION.CFC.STUDENT.getPlacementHistory(studentID=qGetUserInfo.studentID,historyID=selectedPlacement);

	// Get Folder Path 
	//flightInfoDirectory = "#APPLICATION.PATH.onlineApp.internalVirtualFolder##qGetUserInfo.userID#/#selectedPlacement#/flightInformation";

	// Make sure the folder Exists
	//AppCFC.UDF.createFolder(flightInfoDirectory);
</cfscript>

<!----<cfdirectory directory="#flightInfoDirectory#" name="flightDocs" sort="datelastmodified DESC" filter="*.*">---->
 
    <cfquery name="qGetOtherFiles" datasource="MySql">
    	SELECT vf.fileName, vf.dateAdded, vf.expires, vf.filePath, vfc.categoryName, vfd.documentType, u.firstname, u.lastname , u.userid, vf.generatedHow, vf.uploadedBy, vf.vfid,
         vf.fk_hostid, vfd.viewPermissions, approved.firstname as approvedFirst, approved.lastname as approvedLast, vf.approvedBy
        FROM extra_virtualfolder vf
        LEFT JOIN extra_virtualfolderdocuments vfd on vfd.id = vf.fk_documentType
        LEFT JOIN extra_virtualfoldercategory vfc on vfc.categoryID = vfd.fk_category
        LEFT JOIN smg_users u on u.userid = vf.uploadedBy
        LEFT JOIN smg_users approved on approved.userid = vf.approvedBy
        WHERE vf.fk_studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetUserInfo.userID#">
       
       and isDeleted = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.isDeleted#">
        ORDER by categoryName
    </cfquery>
    <cfif VAL(url.placement)>
    	<cfset currentDirectory = "#Application.Path.virtualFolder##qGetUserInfo.userid#/#qGetUserInfo.hostID#">
   	<cfelse>
    	<cfset currentDirectory = "#Application.Path.virtualFolder##qGetUserInfo.userID#">
    </cfif>
	<!--- Check to see if the Directory exists. --->
    <cfif NOT DirectoryExists(currentDirectory)>
       <!--- If TRUE, create the directory. --->
       <cfdirectory action = "create" directory = "#currentDirectory#" mode="777">
    </cfif>
    <cfdirectory directory="#currentDirectory#" name="mydirectory" sort="datelastmodified DESC" filter="*.*">
    <cfquery name="qGetUploadedFiles"datasource="MySql">
    	SELECT v.fileName, v.dateAdded, v.filePath, v.expires, v.generatedHow, v.uploadedBy, v.vfid, v.fk_hostid, u.userID, u.firstName, u.lastName,  vfd.documentType, vfc.categoryName, approved.firstname as approvedFirst, approved.lastname as approvedLast
        FROM extra_virtualfolder v
        LEFT JOIN extra_virtualfolderdocuments vfd on vfd.id = v.fk_documentType
        LEFT JOIN extra_virtualfoldercategory vfc on vfc.categoryID = vfd.fk_category
        LEFT JOIN smg_users u on u.userID = v.uploadedBy
        LEFT JOIN smg_users approved on approved.userid = v.approvedby
        WHERE v.fk_studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetUserInfo.userID#">
        <cfif VAL(URL.hostID)>
        	AND v.fk_hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.hostID#">
        </cfif>
        AND <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userType)#"> IN (SELECT categoryAccessList FROM virtualfoldercategory WHERE categoryID = v.fk_categoryID)
    </cfquery>
   

<!--- Page Header --->
<div class="rdholder" style="width:100%; float:right;"> 

	<cfoutput>
 
		<!--- Page Messages --->
        <cfif val(form.isDeleted)>
            <div class="alert">
                <em>You are viewing files that have been deleted or expired.</em>
            </div>
        </cfif>

		<cfif val(fileDeleted)>
            <div class="alert">
                <em>
                    A file was recently deleted. You can still undelete this file if you didn't mean to delete it. 
                    <a href="index.cfm?curdoc=virtualFolder/view&uniqueid=#url.uniqueid#&vfid=#vfid#&unDelete=1">Undo Delete</a>
                </em>
            </div>
        </cfif>
        
        <br />
         
 		<cfset currentCategory = ''>             
    
    	<div class="rdtop"> 
        	<span class="rdtitle">#qGetUserInfo.firstname# #qGetUserInfo.lastname# (###qGetUserInfo.userID#) - #qGetUserInfo.businessname#  </span> 
        	
        		<em>
                <cfif client.usertype eq 8>
                <a href="?curdoc=user/user_info&uniqueid=#qGetUserInfo.uniqueid#">back to  profile</a>
                <cfelse>
                <a href="?curdoc=intRep/intlRepInfo&uniqueid=#qGetUserInfo.uniqueid#">back to  profile</a>
                </cfif>
                </em>
        	
        	<cfif client.usertype lt 8>
        		<a href="?curdoc=virtualFolder/view&deleted=<cfif form.isDeleted eq 0>1<cfelse>0</cfif>&uniqueid=#url.uniqueid#" class="floatRight"><img src="pics/hour_glass.png" border="0" height=23 /></a>
    		</cfif>
    	</div>
    
    	<div class="rdbox">
        	<form method="post" action="index.cfm?curdoc=virtualFolder/createEdit">
				<cfset currentCategory = ''>
				<!----<table>
                    <tr>
                        <td align="left">Host Family</td>
                        <td>
                            <select name="hostFamily" onchange="changePlacement(this)">
                                <option value="0&uniqueid=#url.uniqueid#">All</option>
                                <cfloop query="qGetStudentPlacements">
                                    <option value="#historyID#&hostID=#hostID#&uniqueid=#url.uniqueid#" <cfif url.hostID eq hostID>selected</cfif>>#familylastname# (#hostid#)</option>
                                </cfloop>
                            </select>
                        </td>
                    </tr>
                </table>---->

                <br />
                <br />

    			<table cellpadding=4 cellspacing="0" width=100%>
                    <tr>
                        <th align="left">Document Type</th><Th align="left">Expires</Th><th align="left">Document Name</th><th align="left">Upload Date</th><Th align="left">Uploaded By</Th><th align="left">Approved By</Th>
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
                                <td><cfif val(expires)>#DateFormat(expires, 'mm/dd/yyyy')#<cfelse><font color=##ccc>Awaiting Review</font></cfif></td>
                                <td><a href="../#filePath##filename#" target="_blank">#filename# </a></td>
                                <td>#DateFormat(dateAdded, 'mmm d, yyyy')#</td>
                                <td><cfif NOT VAL(uploadedBy) AND generatedHow EQ "auto">System<cfelse>#firstname# #lastname#</cfif></td>
                                <td><cfif val(approvedBy)>#approvedFirst# #approvedLast#<cfelse><font color=##ccc>Awaiting Review</font></cfif></td>
                                <td>
                           			<cfif ((userid eq client.userid) OR (client.usertype lte 4)) AND generatedHow is not 'auto'>
                                		<a href="index.cfm?curdoc=virtualFolder/view&uniqueid=#url.uniqueid#&vfid=#vfid#&how=#generatedHow#&undelete=<cfif form.isDeleted eq 0>0<cfelse>1</cfif>">
                                    		<img src="pics/deletex.gif" height="10" border=0/>
                                 		</a>
                                    </cfif>
                              	</td>
                            </tr>
  						
  						</cfif>
                 
    				</cfloop>
					<!----Flight Info that was auto generated prior to new VF (Feb 26, 2013)---->
					<cfif not val(form.isDeleted)>
    				<!----	<cfif flightDocs.recordcount gt 0>
                            <tr bgcolor="##CCCCCC">
                                <td colspan=6 align="left" ><strong>Pre-AYP 12/13 Flight Info</strong></td>
                            </tr>
         					<cfloop query="flightDocs">
                				<tr>
                                	<td>Flight Information</td>
                                    <td><a href="uploadedfiles/internalVirtualFolder/#qGetUserInfo.userID#/#selectedPlacement#/flightInformation/#name#" target="_blank">#name#</a></td> 	
                                    <td>#DateFormat(dateLastModified,'mmm d, yyyy')#</td>
                                    <td>System</td>
                                    <td>Auto</td>
                              	</tr>
            				</cfloop>
     					</cfif>---->
                       
    				</cfif>
				</table>
    
    			<div align="center">
     				<table>
     					<tr>
                        	<td>
                            <cfif client.usertype eq 8>
                             <a href="?curdoc=user/user_info&uniqueID=#qGetUserInfo.uniqueID#"><img src="pics/buttons/close.png" alt="Close Window" border=0></a>
                            <cfelse>
                             <a href="?curdoc=intRep/intlRepInfo&uniqueID=#qGetUserInfo.uniqueID#"><img src="pics/buttons/close.png" alt="Close Window" border=0></a>
                            </cfif>
                           </td>
            				<td><a class='iframe' href="virtualFolder/uploadEdit.cfm?uniqueid=#qGetUserInfo.uniqueID#"><img src="pics/buttons/uploadNewDoc.png" alt="New Document Type" border=0></a></td>
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
