










<style type="text/css">
	.box{
		
		margin: 10px 0px;
		padding:15px 10px 15px 50px;
		background-repeat: no-repeat;
		background-position: 10px center;
		position:relative;
		color: #000;
		background-color:#FFC;
		background-image: url('../images/info.png');
	}
</style>
<cfparam name="form.picCat" default=''>

<!--- Import CustomTag Used for Page Messages and Form Errors --->
<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

<cfset acceptedFiles = 'jpg,JPG,jpeg,JPEG'>

<!----Delete Picture---->

<cfif isDefined('url.delPic')>
	<cffile action="delete" 
    	file="C:/websites/www/student-management/nsmg/uploadedfiles/HostAlbum/#client.hostid#/large/#url.delPic#">
    <cffile action="delete" 
    	file="C:/websites/www/student-management/nsmg/uploadedfiles/HostAlbum/#client.hostid#/thumbs/#url.delPic#"> 
        <cfquery name="delPic" datasource="MySQL">
            delete from smg_host_picture_album
            where filename = '#url.delPic#'   
        </cfquery>
        <cflocation url="index.cfm?page=familyAlbum">
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
            select filename, description 
            from smg_host_picture_album
            where fk_hostid = #client.hostid#
            </cfquery>
            <cflocation url="index.cfm?page=schoolInfo" addtoken="no">
		</cfif>
<script type="text/javascript">
$(document).ready(function(){
 $('.box').hide();
  $('#dropdown').change(function() {
    $('.box').hide();
    $('#div' + $(this).val()).show();
 });
});
</script>

<h3>Upload Single Pictures<br />
<font size=-2><em>Once you upload a picture, you will be able to add a description for each picture.</em></font></h3>


<cfif isDefined("fileUpload")>
<cfset form.picCat = #RemoveChars(form.picCat, 1, 4)#>
<cfif form.fileUpload is ''>
<div align="center"><font color="#FF0000"><h3>Please select a file to upload.</h3></font></div>
<cfelse>
		<cfif DirectoryExists('C:/websites/www/student-management/nsmg/uploadedfiles/HostAlbum/#client.hostid#/large')>
        <cfelse>
        	<cfdirectory action = "create" directory = "C:/websites/www/student-management/nsmg/uploadedfiles/HostAlbum/#client.hostid#/large" >
        </cfif>	
        
        <cfif DirectoryExists('C:/websites/www/student-management/nsmg/uploadedfiles/HostAlbum/#client.hostid#/thumbs')>
        <cfelse>
        	<cfdirectory action = "create" directory = "C:/websites/www/student-management/nsmg/uploadedfiles/HostAlbum/#client.hostid#/thumbs" >
        </cfif>	
        
        
   <cffile action="upload"
     destination="C:/websites/www/student-management/nsmg/uploadedfiles/temp/"
     fileField="fileUpload" nameconflict="makeunique">    
      <cfdirectory action="list" name="currentPics2" directory="C:/websites/www/student-management/nsmg/uploadedfiles/temp/">
     
      <cfset fileTypeOK = 1>
	<cfif #ListFind('#acceptedFIles#','#file.ServerFileExt#')# eq 0>
   <cfset fileTypeOK = 0>
   <cffile action="delete" 
    	file="C:/websites/www/student-management/nsmg/uploadedfiles/HostAlbum/#client.hostid#/#file.serverfile#">
   
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
				 	<cffile action="delete" file="C:/websites/www/student-management/nsmg/uploadedfiles/temp/#name#">  
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
     	values(#client.hostid#, '#file.clientfilename#.jpg', #form.picCat#)
     </cfquery>

     <Cflocation url="index.cfm?page=familyAlbum" addtoken="no">
    </cfif>
   </cfif>
</cfif>

<!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="section"
        />
<table width=100% cellspacing=0 cellpadding=2 class="border">
	<tr>
    	<td colspan="4">
        <Cfoutput>
<cfloop query="picCatagories">
<div id="divarea#catid#" class="box"> #requirements#</div>
</cfloop>
</cfoutput>
        
        </td>
    </tr>
	<Tr>
    <Td>
Select a category for this picture:<br />

<Cfoutput>
<form enctype="multipart/form-data" method="post">
<select name="picCat" id="dropdown">
	<option value="0"></option>
		<cfloop query="picCatagories">
			<option value="area#catID#" <cfif form.picCat eq #catID#>selected</cfif>>#cat_name#<Cfif catid is not 7>*</Cfif></option>
		</cfloop>
</select>

</cfoutput>
</Td>
   		<td>



<input type="file" name="fileUpload" /><br />


</td>

<Td>


<input type="image" src="../images/buttons/BlkSubmit.png" />
</form>
</Td>
    </Tr>
</table>

*At least on picture from this catagory is required. More than one photo may be needed to clearly depict each room.

<h3>Your Photo Album</h3>
<table width=100% cellspacing=0 cellpadding=2 class="border">
<cfif current_photos.recordcount neq 0>
<form method="post" action="familyAlbum.cfm">
	<tr>
    <cfset count = 1>
    <cfoutput>
    <cfloop query="current_photos">
    	<cfquery name="catDesc" datasource="mysql">
        select cat_name
        from smg_host_pic_cat
        where catID = #cat#
        </cfquery>
    	<Td><img src="http://ise.exitsapplication.com/nsmg/uploadedfiles/HostAlbum/#client.hostid#/thumbs/#filename#" height = 100><br />
                #catDesc.cat_name#<br />
                <a href="index.cfm?page=familyAlbum&delPic=#filename#"><img src="../images/buttons/deleteGreyRed.png" height=30  border=0 /></a>
</Td>
                <td valign="top">
                Description of picture:<br />
                <textarea name="desc_#filename#" cols="20" rows="5">#description#</textarea>
              <Cfset count = #count# + 1>
 	<Cfif  #count#  mod 2>ß
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

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
    <tr>
  
    <td colspan=4 align="Center" valign="center">When you are done editing the descriptions, just click "Next"
        	
        
     
        <td align="right">
                  <input type="hidden" name="updateDesc" />
        	<input name="Submit" type="image" src="../images/buttons/Next.png"/>
            </form>
           
            </td>
        </td>
        
       
    </tr>
    
</table>


<!----
<h3><u>Department Of State Regulations</u></h3>

<p>&dagger;<strong><a href="http://ecfr.gpoaccess.gov/cgi/t/text/text-idx?c=ecfr&sid=bfef5f6152d538eed70ad639c221a216&rgn=div8&view=text&node=22:1.0.1.7.37.2.1.6&idno=22" target="_blank" class=external>CFR Title 22, Part 62, Subpart B, &sect;62.25 (j)(2)</a></strong><br />


<em> The host family application must be designed to provide a detailed summary and profile of the host family, the physical home environment (to include photographs of the host family home's exterior and grounds, kitchen, student's bedroom, bathroom, and family or living room), family composition, and community environment. Exchange students are not permitted to reside with their relatives.</em></p>---->