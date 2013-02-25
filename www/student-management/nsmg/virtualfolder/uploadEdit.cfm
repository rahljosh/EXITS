<head>
<script>
function displayHosts() {
		// Get canada list from the query
		hostFamList = '#hostFamDocID#';
		currentHost = $("##docType").val();

		if ( $.ListFind(hostFamList, currentHost, ',') ) {
			$(".hostFamAreaDiv").fadeIn("slow");															
		} else {
			$("##hostFamily").val(0);
			$(".hostFamAreaDiv").fadeOut("slow");			
		}
	}
</script>
</head>

<!--- Import CustomTag Used for Page Messages and Form Errors --->
<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

<!----Default Paramaters---->
<cfparam name="FORM.subAction" default="">
<cfparam name="URL.docID" default="0">
<cfparam name="FORM.docExists" default="0">
<Cfparam name="FORM.docID" default="0">
<Cfparam name="FORM.docType" default="0">
<!---Close the window if its cancel---->
<cfif FORM.subAction is 'Cancel'>
    <body onLoad="parent.$.fn.colorbox.close();">
    <cfabort>
</cfif>


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
</cfscript>
<Cfif val(url.docID)>
	<cfset form.docExists = "#url.docID#">
</Cfif>


<!----Catagories that are available for documents---->
<cfquery name="qDocuments" datasource="#application.dsn#">
    select vfc.categoryName, vfd.documentType, vfd.id, vfc.categoryid, vfd.uploadPermissions
    from virtualfolderdocuments vfd
    left join virtualfoldercategory vfc on vfc.categoryid = vfd.fk_category
	where isActive = <Cfqueryparam cfsqltype="cf_sql_integer" value=1>
</cfquery>


<!----List of UsersTypes---->
<cfquery name="userTypes" datasource="#application.dsn#">
select *
from smg_userType
where usertypeid <= <cfqueryparam cfsqltype="cf_sql_integer" value="8">
or usertypeid = <cfqueryparam cfsqltype="cf_sql_integer" value="14">
</cfquery>

<!---Check if able to delete---->
<cfquery name="checkDocCount" datasource="#application.dsn#">
SELECT count(vfid) as docCount 
FROM virtualFolder
where fk_documentType = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(FORM.docExists)#">
</cfquery>

<Cfquery name="HostFamDocs" datasource="#application.dsn#">
select id
from virtualFolderDocuments
where fk_category = <cfqueryparam cfsqltype="cf_sql_integer" value="2">
</Cfquery>
<cfset hostFamDocID = ''>
<Cfloop query="#hostFamDocs#">
	<cfset hostFamDocID = "#ListAppend(hostFamDocID, id)#">
</Cfloop>



<Cfif len(form.subAction) and form.subAction is not 'Cancel'>
<cfquery name="catCheck" datasource="#application.dsn#">
select fk_category
from virtualFolderDocuments
where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.docType#">
</cfquery>

<!---Error Checking---->
         <cfscript>
            // Data Validation
			// Family Last Name
            if ( NOT val(FORM.docType) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please select which type of document this is. ");
            }		
			if ( NOT len(FORM.fileToUpload) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please select a file to upload. ");
            }	
			 if (val(catCheck.fk_category) eq 2 and NOT val(form.hostFamily)){
				SESSION.formErrors.Add("You indicated this is a Host Family document, but did not choose a host family.");
			 }
        	</cfscript>
<cfif NOT SESSION.formErrors.length()>
	<cfscript>
        // Get Folder Path and make sure it exists
        currentDirectory = "#APPLICATION.PATH.onlineApp.virtualFolder##qGetStudentInfo.studentID#";
        AppCFC.UDF.createFolder(currentDirectory);
	</cfscript>
	
    <cffile action="upload" filefield="fileToUpload" destination="#currentDirectory#" nameconflict="makeunique" mode="777">

	<!----Check if Already  Doc Type---->
    <cfquery name="qCheckExists" datasource="#application.dsn#">
        select documentType, id
        from virtualFolderDocuments
        where documentType = <Cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fileToUpload#">
    </cfquery>
	

	
		<cfif val(form.docExists)>
                <cfquery datasource="#application.dsn#">
                UPDATE virtualfolder
                    set documentType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.docName#"> , 
                       
                        viewPermissions = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.whoCanView#">, 
                        uploadPermissions = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.whoCanUpload#">
                    WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.docExists#">
                
                </cfquery>
            <cfelse>

            
                <cfquery datasource="#application.dsn#">
               insert into virtualfolder (fk_documentType,fileName,filePath,fk_hostID,fk_studentID,generatedHow,  uploadedBy, dateAdded)
                            values (<cfqueryparam cfsqltype="cf_sql_integer" value="#form.docType#">,
                            		<cfqueryparam cfsqltype="cf_sql_varchar" value="#file.serverfile#">,
                            		<cfqueryparam cfsqltype="cf_sql_varchar" value="#currentDirectory#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.hostfamily)#">,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetStudentInfo.studentid#">,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="manual">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userID#">,
                                    <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">)
                
                </cfquery>
        </cfif>
       
		<cfif FORM.subAction is 'Save and Close'>
              <body onLoad="parent.$.fn.colorbox.close();">
                        <cfabort>
        </cfif>
       	<cfif FORM.subAction is 'Save and New'>
         <cfscript>
        // Set Page Message
				SESSION.pageMessages.Add("Document was successfully uploaded.");
		</cfscript>
    	  <cfscript>
			FORM.docType = '';
			FORM.docID = '';
	
	</cfscript>
    </cfif>
  </cfif>
</Cfif>


<cfif val(form.docExists)>
	<cfquery name="qCurrentDoc" datasource="#application.dsn#">
     select *
     from virtualFolderDocuments
     where id = <Cfqueryparam cfsqltype="cf_sql_integer" value = "#form.docExists#"> 
    </cfquery>
    <cfscript>
	FORM.documentType = qCurrentDoc.documentType;
	FORM.fk_category = qCurrentDoc.fk_category;
	FORM.viewPermissions = qCurrentDoc.viewPermissions;
	FORM.uploadPermissions = qCurrentDoc.uploadPermissions;
	</cfscript>
</cfif>
 <cfoutput>

 <gui:pageHeader
        headerType="applicationNoHeader"
    />	
<div class="rdholder" style="width:100%; float:right;"> 
                
    <div class="rdtop"> 
        <span class="rdtitle">Upload/Edit Document</span> 
        <em></em>
    </div>
    
    <div class="rdbox">
  <!--- Page Messages --->
    <gui:displayPageMessages 
        pageMessages="#SESSION.pageMessages.GetCollection()#"
        messageType="divOnly"
        width="98%"
        />
    
    <!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="divOnly"
        width="98%"
        />
 <Cfset vCurrentDoc = ''>
<form method="post" action="uploadEdit.cfm?unqid=#url.unqid#" name="Upload" enctype="multipart/form-data">
<input type="hidden" name="docExists" value="#url.docID#">

    <table cellpadding=4 cellspacing="0" width=60% align=center>
    	<Tr>
        	<th align="left">Select Document</th>
         
         	<Td><input name="fileToUpload" type="file" size=35/></Td>
           
		</tr>
        <tr>
        	<th align="left">Document Type</th>
        	
            <Td><select name="docType" id="docType" onCHange="displayHosts();">
                <option value=0  disabled selected><font color="##CCCCCC">Select a Document Type</font></option>
                <cfloop query="qDocuments">
                <Cfif vCurrentDoc neq "#categoryName#">
                <option value="" disabled>#categoryName#</option>
                <Cfset vCurrentDoc = "#categoryName#">
                </Cfif>
               <cfif listFind(#uploadPermissions#,#client.userType#)>
                <option value="#id#" <cfif form.docID eq id>selected</cfif>> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#documentType#</option>
                </cfif>
                </cfloop>
            </Td>
        
		</tr>
    
        <tr>
        	<th align="left">Host Family</th>
            <td><select name="hostFamily" id="hostFamily">
            	<option value="">Not Applicable</option>
                
                <cfloop query="qGetStudentPlacements">
                    <option value="#hostid#">#familylastname# (#hostid#)</option>
                </cfloop>
           	   </select>
        </tr>
        
      </table>
      
      <br><br>
      
      <Table align="center"width=60%>
        <tr>
      		<Td></Td>
        </tr>
      	<tr>
        	<Td><input name="subAction" id="submitCancel" type="submit" alt="Cancel" border=0 value='Cancel' class="buttonRed"></Td>
            <td><input name="subAction" id="submitClose" type="submit" alt="Save and Close" border=0 value='Save and Close' class="buttonBlue"></td>
            <td><input name="subAction" id="submitNew" type="submit" alt="Save and Create New" border=0 value='Save and New' class="buttonGreen"></td>
          
         </tr>
        
      </Table>
      
</cfoutput>
</form>
    </div>
    
    <div class="rdbottom"></div> <!-- end bottom --> 
    
</div>
