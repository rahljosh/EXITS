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
        
        // Function to check if there are invalid characters in the file name.
        // This function will only check for characters that will prevent uploading onto the server.
        // Other invalid characters such as "#" are stripped after they are uploaded.
        function checkFileName(input) {
            var fileName = input.substring(input.lastIndexOf("\\")+1);
            var pattern = /[?:*<>|"#]/g;
            if (pattern.test(fileName)) {
                $("#fileToUpload").attr("value","");
                alert("The file name cannot contain the following characters: ? : * < > | \" ");	
            }
        }
    </script>
</head>

<cfparam name="emailRecipient" default="josh@pokytrails.com">

<!--- Import CustomTag Used for Page Messages and Form Errors --->
<cfimport taglib="/extensions/customTags/gui/" prefix="gui" />	

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
	// Make sure there is a uniqueID
	if ( NOT LEN(URL.uniqueid) ) { 
		include "error_message.cfm";
		abort;
	}
	
	// Get User Info
	qGetUserInfo = APPLICATION.CFC.USER.getUserByUniqueID(uniqueID=URL.uniqueID);
	
</cfscript>

<cfif val(url.docID)>
	<cfset form.docExists = "#url.docID#">
</cfif>

<!----Catagories that are available for documents---->
<cfquery name="qDocuments"  datasource="MySql">
    select vfc.categoryName, vfd.documentType, vfd.id, vfc.categoryid, vfd.uploadPermissions
    from extra_virtualfolderdocuments vfd
    left join extra_virtualfoldercategory vfc on vfc.categoryid = vfd.fk_category
	where isActive = <Cfqueryparam cfsqltype="cf_sql_integer" value="1">
    and 
        id NOT IN (
        select fk_documentType as id
        from extra_virtualfolder
        where fk_studentid = <Cfqueryparam cfsqltype="cf_sql_integer" value="#qGetUserInfo.userid#"> 
        and expires >= now() 
        )
</cfquery>

<!----List of UsersTypes---->
<cfquery name="userTypes"  datasource="MySql">
    select *
    from smg_usertype
    where usertypeid <= <cfqueryparam cfsqltype="cf_sql_integer" value="8">
    or usertypeid = <cfqueryparam cfsqltype="cf_sql_integer" value="14">
</cfquery>

<!---Check if able to delete---->
<cfquery name="checkDocCount"  datasource="MySql">
    SELECT count(vfid) as docCount 
    FROM extra_virtualfolder
    where fk_documentType = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(FORM.docExists)#">
</cfquery>

<cfquery name="HostFamDocs"  datasource="MySql">
    select id
    from extra_virtualfolderdocuments
    where fk_category = <cfqueryparam cfsqltype="cf_sql_integer" value="2">
</cfquery>

<cfset hostFamDocID = ''>

<cfloop query="hostFamDocs">
	<cfset hostFamDocID = "#ListAppend(hostFamDocID, id)#">
</cfloop>

<cfif len(form.subAction) and form.subAction is not 'Cancel'>
    <cfquery name="catCheck"  datasource="MySql">
        select fk_category
        from extra_virtualfolderdocuments
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
            currentDirectory = "#Application.Path.virtualFolder##qGetUserInfo.userID#";
            APPLICATION.CFC.UDF.createFolder(currentDirectory);
        </cfscript>
	
    	<cffile action="upload" filefield="fileToUpload" destination="#currentDirectory#" nameconflict="makeunique" mode="777">

		
        
        	<!--- Change the name of the file if it has invalid characters --->
            <cfscript>
				vFileName = REReplace(file.ServerFile,"[^0-9A-Za-z .,-_(){}!$&=+']","","all");
			</cfscript>
            <cffile action="rename" source="#file.ServerDirectory#\#file.ServerFile#" destination="#file.ServerDirectory#\#vFileName#">
        	
            <!--- Insert new file --->
			<cfquery  datasource="MySql">
            	INSERT INTO extra_virtualfolder (
                	fk_documentType,
                    fileName,
                    filePath,
                    fk_studentID,
                    generatedHow,
                    uploadedBy,
                    dateAdded
             	)
                VALUES (
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#form.docType#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#vFileName#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="uploadedFiles/virtualfolder/#qGetUserInfo.userid#/">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetUserInfo.userID#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="manual">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userID#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
             	)
			</cfquery>
                
	 		<!--- Email Local Person --->
       		<!--- EMAIL FACILITATORS TO LET THEM KNOW THERE IS A DOCUMENT ---->
       		<cfquery name="qGetCategory"  datasource="MySql">
         		select documenttype, viewPermissions
               	from virtualfolderdocuments
               	where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.docType#">
       		</cfquery>
        	<cfquery name="qGetUser"  datasource="MySql">
                SELECT 
                    userid, 
                    firstname, 
                    lastname, 
                    businessname, 
                    email
                FROM 
                    smg_users
                WHERE 
                    userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
    		</cfquery>   
    
		
   
    		<cfoutput>
        		<cfsavecontent variable="email_message">
            		Document has been added to document control.
                    
                    <!----This e-mail is just to let you know a new document has been uploaded into 
                    #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname#'s (###qGetStudentInfo.studentid#) 
                    virtual folder by #qGetUser.businessname# #qGetUser.firstname# #qGetUser.lastname#.
            		The document has been recorded in the category #qGetCategory.documenttype#.<br><br>
            		Please click <a href="#studentProfileLink#">here</a> and click on "virtual folder" in the right menu. <br><br>
            		Sincerely,<br>
            		EXITS - #CLIENT.companyname#<br><br>
					---->
        		</cfsavecontent>
        	</cfoutput>            
        
			<!--- send email 
            <cfinvoke component="nsmg.cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="#emailRecipient#">
                <cfinvokeargument name="email_subject" value="Virtual Folder - Upload Notification for #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentid#)">
                <cfinvokeargument name="email_message" value="#email_message#">
                <cfinvokeargument name="email_from" value="#CLIENT.support_email#">
            </cfinvoke>
    		<!----End of Email---->
			
			--->
    
    
    	
            <!---- End of Email to Intl. Representative --->
		
     
       
		<cfif FORM.subAction is 'Save and Close'>
    		<body onLoad="parent.$.fn.colorbox.close();">
       		<cfabort>
        </cfif>
        
       	<cfif FORM.subAction is 'Save and New'>
			<cfscript>
        		// Set Page Message
				SESSION.pageMessages.Add("Document was successfully uploaded.");
				FORM.docType = '';
				FORM.docID = '';
         	</cfscript>
    	</cfif>

	</cfif>

</cfif>

<cfif val(form.docExists)>
	<cfquery name="qCurrentDoc"  datasource="MySql">
		select *
     	from extra_virtualfolderdocuments
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
                            messageType="section"
                            />
                        
                        <!--- Form Errors --->
                        <gui:displayFormErrors 
                            formErrors="#SESSION.formErrors.GetCollection()#"
                            messageType="section"
                            />
			<cfset vCurrentDoc = ''>
        
            <form method="post" action="uploadEdit.cfm?uniqueID=#url.uniqueID#" name="Upload" enctype="multipart/form-data">
                <input type="hidden" name="docExists" value="#url.docID#">
                <table cellpadding=4 cellspacing="0" width=60% align=center>
                    <tr>
                        <th align="left">Select Document</th>
                        <td><input name="fileToUpload" id="fileToUpload" type="file" size="35" onChange="checkFileName(this.value);"/></td>
                    </tr>
                    <tr>
                        <th align="left">Document Type</th>
                        <td>
                            <select name="docType" id="docType" onCHange="displayHosts();">
                                <option value=0  disabled selected><font color="##CCCCCC">Select a Document Type</font></option>
                                <cfloop query="qDocuments">
                                    <cfif vCurrentDoc neq "#categoryName#">
                                        <option value="" disabled>#categoryName#</option>
                                        <cfset vCurrentDoc = "#categoryName#">
                                    </cfif>
                                    <cfif listFind(#uploadPermissions#,#client.userType#)>
                                   
                                        <option value="#id#" <cfif form.docID eq id>selected</cfif>> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#documentType#</option>
                                    </cfif>
                                </cfloop>
                            </select>
                        </td>
                    </tr>
              
                </table>
                <br><br>
                <table align="center"width=60%>
                    <tr>
                        <td></td>
                    </tr>
                    <tr>
                        <Td><input name="subAction" id="submitCancel" type="submit" alt="Cancel" border=0 value='Cancel' class="buttonRed"></Td>
                        <td><input name="subAction" id="submitClose" type="submit" alt="Save and Close" border=0 value='Save and Close' class="buttonBlue"></td>
                        <td><input name="subAction" id="submitNew" type="submit" alt="Save and Create New" border=0 value='Save and New' class="buttonGreen"></td>
                    </tr>
                </table>
            </form>
            
    	</div>

		<div class="rdbottom"></div> <!-- end bottom --> 
    
    </div>
 
</cfoutput>