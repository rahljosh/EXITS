<!--- ------------------------------------------------------------------------- ----
	
	File:		school_acceptance.cfm
	Author:		James Griffiths
	Date:		October 12, 2012
	Desc:		Allows viewing, upload, and deletion of school acceptance letters.
				-they are stored in a different folder than the other internal virtual folder documents

----- ------------------------------------------------------------------------- --->

<cfsilent>
	
    <cfparam name="URL.studentID" default="0">
    <cfparam name="URL.hostID" default="0">
    <cfparam name="URL.type" default="view">
    
    <cfquery name="checkAcceptance" datasource="#APPLICATION.DSN#">
    	SELECT
        	*
      	FROM
        	smg_documents
      	WHERE
        	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.hostID)#">
      	AND
        	shortDesc = 'School Acceptance'
    </cfquery>
    
    <cfscript>
		
		// Set the type of files that are accepted
		acceptedFiles = 'jpg,JPG,jpeg,JPEG';
		
		// Get Folder Path
		currentDirectory = "#APPLICATION.PATH.uploadedFiles#hosts/#URL.hostID#";
		
		// Make sure the folder Exists
        AppCFC.UDF.createFolder(currentDirectory);
		
	</cfscript>
    
</cfsilent>

<cfoutput>

    <cfswitch expression="#URL.type#">
            
        <cfcase value="upload">
            upload
        </cfcase>
        
        <cfcase value="delete">
            delete
        </cfcase>
        
        <cfdefaultcase>
        
            <h2>School Acceptance Letter</h2>
            
            <hr width=80% align="center" height=1px />
            
            <cfif checkAcceptance.recordcount gt 0>
            	<Table width=50% align="center">
                    <tr>
                        <td colspan=2 align="center">
                         #checkAcceptance.description#
                       </td>
                    </tr>
      			</Table>
            </cfif>
            
 			<div id="slidingDiv" display:"none" align="center"> 
      			<img src="#currentDirectory#/#checkAcceptance.fileName#">
      		</div>
 
        </cfdefaultcase>
        
    </cfswitch>

</cfoutput>


<!---
<cfif isDefined('form.process')>

 	<cfif DirectoryExists('C:/websites/student-management/nsmg/uploadedfiles/hosts/#client.hostid#')>
    <cfelse>
        <cfdirectory action = "create" directory = "C:/websites/student-management/nsmg/uploadedfiles/hosts/#client.hostid#" >
    </cfif>	

 	<cfif DirectoryExists('C:/websites/student-management/nsmg/uploadedfiles/hosts/#client.hostid#/thumbs')>
    <cfelse>
        <cfdirectory action = "create" directory = "C:/websites/student-management/nsmg/uploadedfiles/hosts/#client.hostid#/thumbs" >
    </cfif>	  
    
<cffile action="upload"
     destination="C:/websites/student-management/nsmg/uploadedfiles/hosts/#client.hostid#"
     fileField="schoolAcceptLetter" nameconflict="makeunique">    
      <cfdirectory action="list" name="schoolAcceptance" directory="C:/websites/student-management/nsmg/uploadedfiles/hosts/#client.hostid#">
      
   <cfset fileTypeOK = 1>
   <cfif #ListFind('#acceptedFIles#','#file.ServerFileExt#')# eq 0>
	   <cfset fileTypeOK = 0>
       <cffile action="delete" 
            file="C:/websites/student-management/nsmg/uploadedfiles/hosts/#client.hostid#/#file.serverfile#">
   <cfelse>
   <!----Make an thumbnail of image so it doesn't take long to display.  keeping original for printing if needed---->
   
        <cfinvoke component="nsmg.cfc.ResizeThumb" method="GetImage" returnvariable="myImage">
            <cfinvokeargument name="img" value="#file.serverfile#"/>
            <cfinvokeargument name="originalPath" value="hosts/#client.hostid#/">
            <cfinvokeargument name="newPath" value="hosts/#client.hostid#/thumbs/">
            <cfinvokeargument name="id" value="#client.hostid#"/>
        </cfinvoke>
		<cfquery name="addToDoList" datasource="#application.dsn#">
         insert into smg_documents (fileName, type, dateFiled, filePath, description, shortDesc, userid, userType, hostID)
                				values ('#file.serverfile#', '#file.ServerFileExt#', #now()#, 'hosts/#client.hostid#', 'School Acceptance Form - Signed #form.dateSigned#', 'School Acceptance', #client.userid#, 'Host Family', #client.hostid#)
        </cfquery>
		<cflocation url="viewSchoolAccept.cfm?itemID=#url.itemID#&usertype=#url.usertype#">
	</cfif>
</cfif>



<h2>School Acceptance Letter</h2>
<hr width=80% align="center" height=1px />
<cfform action="viewSchoolAccept.cfm?itemID=#url.itemID#&usertype=#url.usertype#" enctype="multipart/form-data">
<cfoutput>
<cfif checkDocs.recordcount gt 0>



<Table width=50% align="center">
	<Tr>
    	<Th colspan=2>The follwing documents are on file for School Acceptance Letters</Th>
    </Tr>
    <cfloop query="checkDocs">
    <tr>
    	<td colspan=2 align="center">
         #Description#
       </td>
    </tr>
    </cfloop>
    </Table>
<div id="slidingDiv" display:"none" align="center"> 
 <img src="../uploadedfiles/#checkDocs.filepath#/#checkDocs.fileName#">
 </div>

<cfelse>

<Table width=50% align="center">
	<Tr>
    	<Th colspan=2>
			Please upload the signed school acceptance letter<br />
            <em> Scanned as a JPG works best</em>
        </Th>
    </Tr>
    	<tr>
        	<td>&nbsp;</td>
        </tr>
    <tr>
    	<td align="right" width="50%"><strong>Select File</strong></td><td><cfinput type="file" name="schoolAcceptLetter" size= "20"></td>
    </tr>
    <tr>
    	<td align="right"><strong>Date Signed</strong></td><td><cfinput type="Text" name="dateSigned" value=""  placeholder="MM/DD/YYYY" class="datePicker" onfocus="insertDate(this,'MM/DD/YYYY')" validate="date" maxlength="10" size=12>
</Table>
      <br />
<hr width=80% align="center" height=1px />
 <form action="view SchoolAccept.cfm?itemID=#url.itemID#&usertype=#url.usertype#" method="post">
  <input type="hidden" name="process" />
 <table cellpadding=10 align="center">
	<tr>
        
        <Td><input type="image" src="../pics/buttons/submit.png" name="process" value=1 /></Td>
    </tr>
    </table>


</cfif>
</cfoutput>
</cfform>--->