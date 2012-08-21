<!--- Import CustomTag Used for Page Messages and Form Errors --->
<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
<link href="http://ise.111cooper.com/hostApp/css/hostApp.css" rel="stylesheet" type="text/css" />
<link href="http://111cooper.com/nsmg/linked/css/baseStyle.css" rel="stylesheet" type="text/css" />
<cfparam name="form.picCat" default=''>

<cfinclude template="approveDenyInclude.cfm">


<!--- Import CustomTag Used for Page Messages and Form Errors --->
<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

<cfset acceptedFiles = 'jpg,gif,png,JPG,GIF,PNG'>

<!----Delete Picture---->

<cfif isDefined('url.delPic')>
	<cffile action="delete" 
    	file="/home/httpd/vhosts/111cooper.com/httpdocs/nsmg/uploadedfiles/HostAlbum/#client.hostid#/large/#url.delPic#">
    <cffile action="delete" 
    	file="/home/httpd/vhosts/111cooper.com/httpdocs/nsmg/uploadedfiles/HostAlbum/#client.hostid#/thumbs/#url.delPic#"> 
        <cfquery name="delPic" datasource="MySQL">
            delete from smg_host_picture_album
            where filename = '#url.delPic#'   
        </cfquery>
    
</cfif>
<Cfquery name="current_photos" datasource="mysql">
select filename, description, cat 
from smg_host_picture_album
where fk_hostid = #client.hostid#
</cfquery>

<h2>Picture Album</h2> 
Please upload photos of you, your family, and your home including the exterior and grounds, kitchen, student's bedroom, student's bathroom, and family and living areas with a brief description of each. <br /><br />
<Cfquery name="picCatagories" datasource="mysql">
select *
from smg_host_pic_cat
</cfquery>

	<cfif IsDefined('form.updateDesc')>
			<cfloop query="current_photos">
				<cfquery name="insert_kids" datasource="MySQL">
					update smg_host_picture_album
                    set description = '#form["desc_" & filename]#' 
                  	where filename = '#filename#'   
                </cfquery>
			</cfloop>
            <Cfquery name="current_photos" datasource="mysql">
            select filename, description, cat
            from smg_host_picture_album
            where fk_hostid = #client.hostid#
            </cfquery>
         <div align="center">Descriptions Updated!</div>
		</cfif>
<cfif isDefined('url.delPic')>
   <div align="center">Picture & Descriptions Deleted!</div>
</cfif>
<cfif isDefined("fileUpload")>
<cfset form.picCat = #RemoveChars(form.picCat, 1, 4)#>
<cfif form.fileUpload is ''>
<div align="center"><font color="#FF0000"><h3>Please select a file to upload.</h3></font></div>
<cfelse>
		<cfif DirectoryExists('/home/httpd/vhosts/111cooper.com/httpdocs/nsmg/uploadedfiles/HostAlbum/#client.hostid#/large')>
        <cfelse>
        	<cfdirectory action = "create" directory = "/home/httpd/vhosts/111cooper.com/httpdocs/nsmg/uploadedfiles/HostAlbum/#client.hostid#/large" >
        </cfif>	
        
        <cfif DirectoryExists('/home/httpd/vhosts/111cooper.com/httpdocs/nsmg/uploadedfiles/HostAlbum/#client.hostid#/thumbs')>
        <cfelse>
        	<cfdirectory action = "create" directory = "/home/httpd/vhosts/111cooper.com/httpdocs/nsmg/uploadedfiles/HostAlbum/#client.hostid#/thumbs" >
        </cfif>	
        
        
   <cffile action="upload"
     destination="/home/httpd/vhosts/111cooper.com/httpdocs/nsmg/uploadedfiles/temp/"
     fileField="fileUpload" nameconflict="makeunique">    
      <cfdirectory action="list" name="currentPics2" directory="/home/httpd/vhosts/111cooper.com/httpdocs/nsmg/uploadedfiles/temp/">
     
      <cfset fileTypeOK = 1>
	<cfif #ListFind('#acceptedFIles#','#file.ServerFileExt#')# eq 0>
   <cfset fileTypeOK = 0>
   <cffile action="delete" 
    	file="/home/httpd/vhosts/111cooper.com/httpdocs/nsmg/uploadedfiles/HostAlbum/#client.hostid#/#file.serverfile#">
   
	</cfif>

      <!----Resize pictures for large and thumbnails---->
       <cfloop query="currentPics2">
            
     			   <cfinvoke component="cfc.ResizeLarge" method="GetImage" returnvariable="myImage">
                        <cfinvokeargument name="img" value="#name#"/>
                        <cfinvokeargument name="hostid" value="#client.hostid#"/>
                    </cfinvoke>
                   
 					<cfinvoke component="cfc.ResizeThumb" method="GetImage" returnvariable="myImage">
                        <cfinvokeargument name="img" value="#name#"/>
                       
                        <cfinvokeargument name="mls" value="#client.hostid#"/>
                 	</cfinvoke>
				
                     </cfloop>
                    <cfloop query="currentPics2">
				 	<cffile action="delete" file="/home/httpd/vhosts/111cooper.com/httpdocs/nsmg/uploadedfiles/temp/#name#">  
                   </cfloop>

     
  <!----  
<cfset newFName = "#client.hostid#_#dateformat(now(),'yyyyddmm')#_#timeformat(now(), 'hhmmss')#.#file.ServerFileExt#">
   <cffile action="rename" destination="/home/httpd/vhosts/111cooper.com/httpdocs/nsmg/uploadedfiles/HostAlbum/#client.hostid#/large/#newFName#" source="/home/httpd/vhosts/111cooper.com/httpdocs/nsmg/uploadedfiles/HostAlbum/#client.hostid#/regular/#file.serverfile#">
   
   <cffile action="rename" destination="/home/httpd/vhosts/111cooper.com/httpdocs/nsmg/uploadedfiles/HostAlbum/#client.hostid#/thumbs/#newFName#" source="/home/httpd/vhosts/111cooper.com/httpdocs/nsmg/uploadedfiles/HostAlbum/#client.hostid#/thumbs/#file.serverfile#">
---->
   

<!--- Process Form Submission --->
         <cfscript>
            // Data Validation
			//Play in Band
			 if ( fileTypeOK eq 0) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("You are trying to upload a #file.ServerFileExt#. We only accept image files of type jpg or jpeg.  Please convert your file and try to upload again.");
			 }
		 </cfscript>
<cfif NOT SESSION.formErrors.length()>
 

 


     <cfquery datasource="MySQL">
     	insert into smg_host_picture_album (fk_hostID, filename, cat)
     	values(#client.hostid#, '#file.serverfile#', #form.picCat#)
     </cfquery>

   
    </cfif>
   </cfif>
</cfif>

<!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="section"
        />
        <!----
<table width=100% cellspacing=0 cellpadding=2 class="border">
	<Tr>
   		<td>


<form enctype="multipart/form-data" method="post">
<input type="file" name="fileUpload" /><br />


</td>
<Td>
Select a catagory for this picture:<br />
<cfoutput>
<select name="picCat">
<cfloop query="picCatagories">
<option value="#catID#" <cfif form.picCat eq #catID#>selected</cfif>>#cat_name#<Cfif catid is not 7>*</Cfif></option>
</cfloop>
</select>

</cfoutput>
</Td>
<Td>


<input type="image" src="../pics/buttons/BlkSubmit.png" />
</form>
</Td>
    </Tr>
</table>

*At least on picture from this catagory is required.
---->
<h3>Photo Album</h3>
<table width=100% cellspacing=0 cellpadding=2 class="border">

<cfif current_photos.recordcount neq 0>
<cfoutput>
<form method="post" action="viewFamPics.cfm?itemID=#url.itemID#&usertype=#url.usertype#">
 </cfoutput>
	<tr>
    <cfset count = 1>
    <cfoutput>
   
    <cfloop query="current_photos">
    	<cfquery name="catDesc" datasource="mysql">
        select cat_name
        from smg_host_pic_cat
        where catID = #current_photos.cat#
        </cfquery>
    	<Td><img src="http://111cooper.com/nsmg/uploadedfiles/HostAlbum/#client.hostid#/thumbs/#filename#" height = 100><br />
                #catDesc.cat_name#<br />
                <a href="viewFamPics.cfm?delPic=#filename#"><img src="../pics/buttons/deleteGreyRed.png" height=30  border=0 /></a>
</Td>
                <td valign="top">
                Description of picture:<br />
                <textarea name="desc_#filename#" cols="20" rows="5">#description#</textarea>
              <Cfset count = #count# + 1>
 	<Cfif  #count#  mod 2>
    </tr>
    </Cfif>
    </cfloop>
    </Cfoutput>
   <tr>
    	
   </tr>
   
   
<cfelse>
	<tr>
    	<td align="center"> <h3>No pictures were found.  Not a  problem though, just upload a few and you'll be set.</h3></td>
</Cfif>

</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% >
    <tr>
  
    <td colspan=4 align="Center" valign="center">Made any change to descriptions?  Make sure you click Update
        	
        
     
        <td align="right">
                  <input type="hidden" name="updateDesc" />
        	<input name="Submit" type="image" src="../pics/buttons/update_44.png"/>
          
           
            </td>
        </td>
        
       
    </tr>
    
</table>
  </form>
 
      <br />
<hr width=80% align="center" height=1px />
<br />

<cfinclude template="approveDenyButtonsInclude.cfm">

