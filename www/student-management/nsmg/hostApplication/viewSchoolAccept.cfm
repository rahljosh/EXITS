<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Untitled Document</title>
<script type="text/javascript">
		function zp(n){
		return n<10?("0"+n):n;
		}
		function insertDate(t,format){
		var now=new Date();
		var DD=zp(now.getDate());
		var MM=zp(now.getMonth()+1);
		var YYYY=now.getFullYear();
		var YY=zp(now.getFullYear()%100);
		format=format.replace(/DD/,DD);
		format=format.replace(/MM/,MM);
		format=format.replace(/YYYY/,YYYY);
		format=format.replace(/YY/,YY);
		t.value=format;
		}
		</script>
</head>

<body>
<cfinclude template="approveDenyInclude.cfm">

<!----See if a letter exists---->
<Cfquery name="checkDocs" datasource="#application.dsn#">
select *
from smg_documents
where hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.hostid#">
and shortDesc =  'School Acceptance'
</Cfquery>

<cfset acceptedFiles = 'jpg,JPG,jpeg,JPEG'>
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
 
 <br />
<cfinclude template="approveDenyButtonsInclude.cfm">
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
</cfform>

</body>
</html>