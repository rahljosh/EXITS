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

<cfparam name="emailRecipient" default="#client.support_email#">

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
	
	studentProfileLink = '#CLIENT.exits_url#/nsmg/index.cfm?curdoc=student_info&studentID=#qGetStudentInfo.studentID#';		
	//studentProfileLink = '#CLIENT.exits_url#/nsmg/virtualfolder/#qGetStudentInfo.uniqueID#';
	
	studentProfileIntLink = '#client.exits_url#/nsmg/index.cfm?curdoc=intrep/int_student_info&unqid=#qGetStudentInfo.uniqueID#';
</cfscript>

<cfif val(url.docID)>
	<cfset form.docExists = "#url.docID#">
</cfif>

<!----Catagories that are available for documents---->
<cfquery name="qDocuments" datasource="#application.dsn#">
    select vfc.categoryName, vfd.documentType, vfd.id, vfc.categoryid, vfd.uploadPermissions
    from virtualfolderdocuments vfd
    left join virtualfoldercategory vfc on vfc.categoryid = vfd.fk_category
	where isActive = <Cfqueryparam cfsqltype="cf_sql_integer" value="1">
</cfquery>

<!----List of UsersTypes---->
<cfquery name="userTypes" datasource="#application.dsn#">
    select *
    from smg_usertype
    where usertypeid <= <cfqueryparam cfsqltype="cf_sql_integer" value="8">
    or usertypeid = <cfqueryparam cfsqltype="cf_sql_integer" value="14">
</cfquery>

<!---Check if able to delete---->
<cfquery name="checkDocCount" datasource="#application.dsn#">
    SELECT count(vfid) as docCount 
    FROM virtualfolder
    where fk_documentType = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(FORM.docExists)#">
</cfquery>

<cfquery name="HostFamDocs" datasource="#application.dsn#">
    select id
    from virtualfolderdocuments
    where fk_category = <cfqueryparam cfsqltype="cf_sql_integer" value="2">
</cfquery>

<cfset hostFamDocID = ''>

<cfloop query="hostFamDocs">
	<cfset hostFamDocID = "#ListAppend(hostFamDocID, id)#">
</cfloop>

<cfif len(form.subAction) and form.subAction is not 'Cancel'>
    <cfquery name="catCheck" datasource="#application.dsn#">
        select fk_category
        from virtualfolderdocuments
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
            from virtualfolderdocuments
            where documentType = <Cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fileToUpload#">
        </cfquery>
	
		<cfif val(form.docExists)>
   			<cfquery datasource="#application.dsn#">
       			UPDATE virtualfolder
           		SET documentType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.docName#"> , 
              		viewPermissions = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.whoCanView#">, 
                 	uploadPermissions = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.whoCanUpload#">
           		WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.docExists#">
    		</cfquery>
		<cfelse>
        
        	<!--- Change the name of the file if it has invalid characters --->
            <cfscript>
				vFileName = REReplace(file.ServerFile,"[^0-9A-Za-z .,-_(){}!$&=+']","","all");
			</cfscript>
            <cffile action="rename" source="#file.ServerDirectory#\#file.ServerFile#" destination="#file.ServerDirectory#\#vFileName#">
        	
            <!--- Insert new file --->
			<cfquery datasource="#application.dsn#">
            	INSERT INTO virtualfolder (
                	fk_documentType,
                    fileName,
                    filePath,
                    fk_hostID,
                    fk_studentID,
                    generatedHow,
                    uploadedBy,
                    dateAdded
             	)
                VALUES (
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#form.docType#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#vFileName#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="uploadedFiles/virtualfolder/#qGetStudentInfo.studentid#/">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.hostfamily)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetStudentInfo.studentid#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="manual">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userID#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
             	)
			</cfquery>
                
	 		<!--- Email Local Person --->
       		<!--- EMAIL FACILITATORS TO LET THEM KNOW THERE IS A DOCUMENT ---->
       		<cfquery name="qGetCategory" datasource="#application.dsn#">
         		select documenttype, viewPermissions
               	from virtualfolderdocuments
               	where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.docType#">
       		</cfquery>
        	<cfquery name="qGetUser" datasource="#application.dsn#">
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

            <cfquery name="qIntlRep" datasource="#application.dsn#">
                SELECT 
                    email
                FROM 
                    smg_users 
                WHERE 
                    userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.intrep#">
            </cfquery>
    
        	<cfquery name="qGetRegionInfo" datasource="#application.dsn#">
                SELECT 
                    s.regionassigned, 
                    r.regionname, 
                    r.regionfacilitator, 
                    r.regionid, 
                    r.company,
                    u.firstname, 
                    u.lastname, 
                    u.email 
                FROM 
                    smg_students s 
                INNER JOIN 
                    smg_regions r ON s.regionassigned = r.regionid
                LEFT JOIN 
                    smg_users u ON r.regionfacilitator = u.userid
                WHERE 
                    s.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.studentid#">
        	</cfquery>
            
		   	<cfscript>
				// Dev - Always Email Support
				if ( APPLICATION.isServerLocal ) {
					emailRecipient = APPLICATION.EMAIL.support; 	
				// Check if is a PHP student - Email PHP
				} else if ( qGetStudentInfo.companyid EQ 6 ) {
					emailRecipient = APPLICATION.EMAIL.PHPContact; 	
				}
				// Check if there is a valid facilitator email address and only email the facilitator if they are not the ones uploading the file.
				else if ( IsValid("email", qGetRegionInfo.email) AND qGetRegionInfo.regionfacilitator NEQ CLIENT.userID ) {
					emailRecipient = qGetRegionInfo.email;
				}
        	</cfscript>	
   
    		<cfoutput>
        		<cfsavecontent variable="email_message">
            		Dear #qGetRegionInfo.firstname# #qGetRegionInfo.lastname#,<br><br>
                    This e-mail is just to let you know a new document has been uploaded into 
                    #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname#'s (###qGetStudentInfo.studentid#) 
                    virtual folder by #qGetUser.businessname# #qGetUser.firstname# #qGetUser.lastname#.
            		The document has been recorded in the category #qGetCategory.documenttype#.<br><br>
            		Please click <a href="#studentProfileLink#">here</a> and click on "virtual folder" in the right menu. <br><br>
            		Sincerely,<br>
            		EXITS - #CLIENT.companyname#<br><br>
        		</cfsavecontent>
        	</cfoutput>            
        
			<!--- send email --->
            <cfinvoke component="nsmg.cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="#emailRecipient#">
                <cfinvokeargument name="email_subject" value="Virtual Folder - Upload Notification for #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentid#)">
                <cfinvokeargument name="email_message" value="#email_message#">
                <cfinvokeargument name="email_from" value="#CLIENT.support_email#">
            </cfinvoke>
    		<!----End of Email---->
    
    
    		<!--- Email International Representative if file has been upload by Office and in Production Environment and Int Rep is in view Permissions--->
			<cfif ListFind("1,2,3,4,5,6,7", CLIENT.userType) AND NOT APPLICATION.isServerLocal AND listFind(qGetCategory.viewPermissions, 8)>
    			<cfoutput>
        			<cfsavecontent variable="email_message">
            			This e-mail is just to let you know a new document has been uploaded into #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname#'s (###qGetStudentInfo.studentid#) 
                        virtual folder by #qGetUser.businessname# #qGetUser.firstname# #qGetUser.lastname#.
            			The document has been recorded in the category #qGetCategory.documenttype# .<br><br>
            			Please click <a href="#studentProfileIntLink#">here</a> to see the student's virtual folder.<br><br>
                        Sincerely,<br>
                        EXITS - #CLIENT.companyname#<br><br>
        			</cfsavecontent>
        		</cfoutput>
        
				<!--- send email --->
                <cfinvoke component="nsmg.cfc.email" method="send_mail">
                    <cfinvokeargument name="email_to" value="#qIntlRep.email#">
                    <cfinvokeargument name="email_subject" value="Virtual Folder - Upload Notification for #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentid#)">
                    <cfinvokeargument name="email_message" value="#email_message#">
                    <cfinvokeargument name="email_from" value="#CLIENT.support_email#">
                </cfinvoke>
                <!----End of Email---->
    
    		</cfif>
            <!---- End of Email to Intl. Representative --->
		
        </cfif>
        <!--- END - Doc does not exist --->
       
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
	<cfquery name="qCurrentDoc" datasource="#application.dsn#">
		select *
     	from virtualfolderdocuments
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
        
			<cfset vCurrentDoc = ''>
        
            <form method="post" action="uploadEdit.cfm?unqid=#url.unqid#" name="Upload" enctype="multipart/form-data">
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
                    <tr>
                        <th align="left">Host Family</th>
                        <td>
                            <select name="hostFamily" id="hostFamily">
                                <option value="">Not Applicable</option>
                                <cfloop query="qGetStudentPlacements">
                                    <option value="#hostid#">#familylastname# (#hostid#)</option>
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