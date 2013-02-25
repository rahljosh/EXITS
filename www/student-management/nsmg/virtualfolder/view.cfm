

<script src="linked/js/jquery.colorbox.js"></script>
	<!----open window details---->
	<script>
        $(document).ready(function(){
            //Examples of how to assign the ColorBox event to elements
            
            $(".iframe").colorbox({width:"60%", height:"60%", iframe:true, 
            
               onClosed:function(){ location.reload(true); } });

        });
    </script>
    <script type="text/javascript">
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
<!--- Kill extra output --->


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
    <Cfparam name="url.How" type="string" default="">
    <Cfparam name="fileDeleted" type="integer" default="0">
    
	<cfif val(url.vfid)>
    <cfif ((userid eq client.userid) OR (client.usertype lte 2)) AND url.how is not 'auto'>
        <cfquery datasource="#application.dsn#">
            update virtualFolder
            set isDeleted = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            where vfid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.vfid#">
                <Cfset fileDeleted = "#url.vfid#">
        </cfquery>
    
    
		<cfif val(url.unDelete)>
        <cfquery datasource="#application.dsn#">
            update virtualFolder
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
    	SELECT vf.fileName, vf.dateAdded, vf.filePath, vfc.categoryName, vfd.documentType, u.firstname, u.lastname , u.userid, vf.generatedHow, vf.vfid,
        h.familylastname, vf.fk_hostid, vfd.viewPermissions
        FROM virtualFolder vf
        LEFT JOIN virtualFolderDocuments vfd on vfd.id = vf.fk_documentType
        LEFT JOIN virtualFolderCategory vfc on vfc.categoryID = vfd.fk_category
        LEFT JOIN smg_users u on u.userid = vf.uploadedBy
        LEFT JOIN smg_hosts h on h.hostid = vf.fk_hostID
        WHERE vf.fk_studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.studentID#">
       <cfif val(url.placement)> AND vf.fk_hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.placement#"></cfif>
       and isDeleted = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.isDeleted#">
        ORDER by categoryName
    </cfquery>
    


<!--- Page Header --->
  


        
<div class="rdholder" style="width:100%; float:right;"> 
 <!--- Page Messages --->
   <cfif val(fileDeleted)>
   <cfoutput>
     <div class="alert">
        
        <em>A file was recently deleted.  You can still undelete this file if you didn't mean to delete it.  <A href="index.cfm?curdoc=virtualFolder/view&unqid=#url.unqid#&vfid=#vfid#&unDelete=1">Undo Delete</a></em> </div>
        <br />
        </cfoutput>
        
   </cfif>
 <cfoutput>  
 <cfset currentCategory = ''>             
    <div class="rdtop"> 
        <span class="rdtitle">Virtual Folder  &nbsp; - &nbsp; #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentid#) </span> 
        <em><a href="?curdoc=student_info&studentID=#qGetStudentInfo.studentid#">back to student profile</a></em>
    </div>
    
    <div class="rdbox">
    
  
    <!--- Form Errors 
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="section"
        />
        
      <!--- Form Errors --->
    <gui:displayPageMessages 
        formErrors="#SESSION.pageMessages.GetCollection()#"
        messageType="section"
        />--->

		
<form method="post" action="index.cfm?curdoc=virtualFolder/createEdit">
<cfset currentCategory = ''>


<table>
     <tr>
        	<th align="left">Host Family</th>
            <td><select name="hostFamily" onchange="changePlacement(this)">
            	<option value="0&unqid=#url.unqid#">All</option>
                
                <cfloop query="qGetStudentPlacements">
                    <option value="#hostid#&unqid=#url.unqid#" <cfif url.placement eq hostid>selected</cfif>>#familylastname# (#hostid#)</option>
                </cfloop>
           	   </select>
               </td>
              
        </tr>
 </td>
<br>
<br />
    <table cellpadding=4 cellspacing="0" width=100%>
    	<Tr>
        	<th align="left">Document Type</th><th align="left">Document Name</th><th align="left">Upload Date</th><Th align="left">Uploaded By</Th><th align="left">Upload Type</Th>
         </Tr>
     <Cfloop query="qGetOtherFiles">
     <cfif currentCategory neq #categoryName#>
        <Cfset currentCategory = '#categoryName#'>
        <tr bgcolor="##CCCCCC">
        	<Td colspan=6 align="left"><strong>#categoryName#</strong></Td>
        </tr>
        </cfif>
   		<cfif listFind(viewPermissions, client.usertype)>
 		<Tr>
        	<td>#documentType#</td><td><a href="#filePath##filename#" target="_blank">#filename# <cfif val(fk_hostID)> - #familyLastName#</cfif></td><td>#DateFormat(dateAdded, 'mmm d, yyyy')#</td><td>#firstname# #lastname#</td>
        	<Td>#generatedHow#</Td>
            <td>
            	<cfif ((userid eq client.userid) OR (client.usertype lte 2)) AND generatedHow is not 'auto'>
            <A href="index.cfm?curdoc=virtualFolder/view&unqid=#url.unqid#&vfid=#vfid#&how=#generatedHow#">
            	<img src="pics/deletex.gif" height="10" border=0/>
             </A>   
                </cfif>
        </tr>
  		</cfif>
    </cfloop>
     </table> 
     <br><br>
     <div align="center">
     <table>
     	<Tr>
        	
            <Td><a href="?curdoc=student_info&studentID=#qGetStudentInfo.studentid#"><img src="pics/buttons/close.png" alt="Close Window" border=0></a></Td>
            <td> <a class='iframe' href="virtualFolder/uploadEdit.cfm?unqid=#qGetStudentInfo.uniqueID#"><img src="pics/buttons/uploadNewDoc.png" alt="New Document Type" border=0></a>
     	</Td>
      </Tr>
    </table>
     </div>
  <div align="center">   <br>
</div>
</cfoutput>
</form>
    </div>
    
    <div class="rdbottom"></div> <!-- end bottom --> 
    
</div>
