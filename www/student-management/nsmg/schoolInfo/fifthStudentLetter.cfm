 <cfparam name="FORM.isSubmitted" default="0">
<!--- Import CustomTag Used for Page Messages and Form Errors ---><head>
	<script>
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
 
 
<cfif isDefined('url.delete')>
<cfscript>
//insert the doc info into the DB
	APPCFC.DOCUMENT.deleteDocumentByID(id=url.delete);
	
</cfscript>
</cfif>

<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
 <cfif val(form.isSubmitted)>

<cffile  action="upload" filefield="fileToUpload" destination="#APPLICATION.PATH.schoolLetters#" nameconflict="makeunique" mode="777">


<cfscript>
//insert the doc info into the DB
	APPCFC.DOCUMENT.insertDocument(foreignTable='school_info',foreignid=url.schoolid,seasonid=url.season,description='5+ Students at School Letter',documentTypeID=44,serverExt=FILE.ServerFileExt,serverName=FILE.ServerFileName,clientExt=FILE.ClientFileExt,clientName=FILE.ClientFileName,fileSize=FILE.FileSize,fileLocation='uploadedfiles/schoolLetters/');
	
</cfscript>
</cfif>
<cfscript>	
		// Get the letter info
		qGetSchoolDocs = APPCFC.DOCUMENT.getDocuments(foreignTable='school_info',foreignid=url.schoolid,seasonid=url.season);
 </cfscript>


<cfoutput>

	
    <gui:pageHeader
        headerType="applicationNoHeader"
    />	
	
    <div class="rdholder" style="width:100%; float:right;"> 
		
        <div class="rdtop"> 
        	<span class="rdtitle">5+ Student Letters</span> 
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

<p>
<cfif qGetSchoolDocs.recordcount eq 0><font color="##CC3300">Still waiting on the signed letter for the #url.seasonLabel# season.</font> <cfelse>Looks like everything is set for this season please review the details below.</cfif>
</p>
<p>The notification letter was sent on #dateFormat(url.letterDate, 'mmm. d, yyyy')# <cfif qGetSchoolDocs.recordcount eq 0> but it has not been receievd<cfelse> and the signed letter was recieved on #dateFormat(qGetSchoolDocs.dateCreated, 'mmm. d, yyyy')#</cfif>.</p>
 
 
 	
    <form method="post" action="fifthstudentletter.cfm?season=#url.season#&schoolid=#url.schoolid#&seasonLabel=#url.seasonLabel#&letterDate=#url.letterDate#" name="Upload" enctype="multipart/form-data">

    <cfif qGetSchoolDocs.recordcount eq 0>
    <table>
       <tr>
            <th align="left">Upload the received letter.</th>
            <td><input name="fileToUpload" id="fileToUpload" type="file" size="35" onChange="checkFileName(this.value);"/>
            <input type="hidden" value=1 name="isSubmitted" /></td>
        </tr>
        <tr>
            <td><input type="submit" value="Upload" /></td>
        </tr>
     </table>
    </form>
    <cfelse>
    
	
   <p>
    <cfloop query="qGetSchoolDocs">
      <strong>Received File:</strong> <a href="../#filePath#">#description#</a><br />
      <strong>Received On:</strong> #dateFormat(dateCreated, 'mmm. d, yyyy')#<br />
      <strong>Received By:</strong> #firstName# #lastname#<br />
      <em>Wrong file? <a href="fifthstudentletter.cfm?season=#url.season#&schoolid=#url.schoolid#&seasonLabel=#url.seasonLabel#&letterDate=#url.letterDate#&delete=#qGetSchoolDocs.id#">delete this one</a>
    </cfloop>
    </p>
    </cfif>
</cfoutput>
 </div>
   		<div class="rdbottom"></div> <!-- end bottom --> 
    </div>
    