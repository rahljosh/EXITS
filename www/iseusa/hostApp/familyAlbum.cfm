<cfparam name="form.picCat" default=''>

<!--- Import CustomTag Used for Page Messages and Form Errors --->
<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

<cfset acceptedFiles = 'jpg,gif,png,JPG,GIF,PNG'>

<!----Delete Picture---->

<cfif isDefined('url.delPic')>
	<cffile action="delete" 
    	file="C:\websites\student-management\nsmg\uploadedfiles\HostAlbum\#url.delPic#">
    <cffile action="delete" 
    	file="C:\websites\student-management\nsmg\uploadedfiles\HostAlbum\thumbs\#url.delPic#"> 
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
            <cflocation url="index.cfm?page=roomPetsSmoke" addtoken="no">
		</cfif>

<h3>Upload Single Pictures<br />
<font size=-2><em>Once you upload a picture, you will be able to add a description for each picture.</em></font></h3>
<cfif isDefined("fileUpload")>
<cfif form.fileUpload is ''>
<div align="center"><font color="#FF0000"><h3>Please select a file to upload.</h3></font></div>
<cfelse>

 <cffile action="upload"
     destination="C:\websites\student-management\nsmg\uploadedfiles\HostAlbum\"
     fileField="fileUpload" nameconflict="makeunique">
<cfset newFName = "#client.hostid#_#dateformat(now(),'yyyyddmm')#_#timeformat(now(), 'hhmmss')#.#file.ServerFileExt#">
   <cffile action="rename" destination="C:\websites\student-management\nsmg\uploadedfiles\HostAlbum\#newFName#" source="C:\websites\student-management\nsmg\uploadedfiles\HostAlbum\#file.serverfile#">

   
<cfset fileTypeOK = 1>
<cfif #ListFind('#acceptedFIles#','#file.ServerFileExt#')# eq 0>
   <cfset fileTypeOK = 0>
   <cffile action="delete" 
    	file="C:\websites\student-management\nsmg\uploadedfiles\HostAlbum\#newFName#">
   
</cfif>
<!--- Process Form Submission --->
         <cfscript>
            // Data Validation
			//Play in Band
			 if ( fileTypeOK eq 0) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("You are trying to upload a #file.ServerFileExt#. We only accept image files of type jpg, png, or gif.  Please convert your file and try to upload again.");
			 }
		 </cfscript>
<cfif NOT SESSION.formErrors.length()>
 

 
   <cfimage
    action = "resize"
    height = "100"
    source = "C:\websites\student-management\nsmg\uploadedfiles\HostAlbum\#newFName#"
    width = "150"
    destination = "C:\websites\student-management\nsmg\uploadedfiles\HostAlbum\thumbs\#newFName#"
    >

     <cfquery datasource="MySQL">
     	insert into smg_host_picture_album (fk_hostID, filename, cat)
     	values(#client.hostid#, '#newFName#', #form.picCat#)
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


<input type="image" src="../images/buttons/BlkSubmit.png" />
</form>
</Td>
    </Tr>
</table>

*At least on picture from this catagory is required.

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
    	<Td><cfimage action="writetobrowser" 
        		source="http://ise.exitsapplication.com/nsmg/uploadedfiles/hostAlbum/thumbs/#filename#" height = 100><br />
                #catDesc.cat_name#<br />
                <a href="index.cfm?page=familyAlbum&delPic=#filename#"><img src="../images/buttons/delete.png"  border=0 /></a>
		</Td>
        <td valign="top">
                Description of picture:<br />
                <textarea name="desc_#filename#" cols="15" rows="5">#description#</textarea>
              <Cfset count = #count# + 1>
        </td>      
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

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
    <tr>
    <cfif current_photos.recordcount neq 0>
    <td colspan=4 align="Center">When you are done editing the descriptions, just click "Next"
        	<input type="hidden" name="updateDesc" />
        	<input name="Submit" type="image" src="../images/buttons/Next.png"/>
        </td>
        </form>
       <cfelse>
        <td align="right"><a href="index.cfm?page=roomPetsSmoke"><img src="../images/buttons/Next.png" border=0></a></td>
        </cfif>
    </tr>
    
</table>



<h3><u>Department Of State Regulations</u></h3>

<p>&dagger;<strong><a href="http://ecfr.gpoaccess.gov/cgi/t/text/text-idx?c=ecfr&sid=bfef5f6152d538eed70ad639c221a216&rgn=div8&view=text&node=22:1.0.1.7.37.2.1.6&idno=22" target="_blank" class=external>CFR Title 22, Part 62, Subpart B, &sect;62.25 (j)(2)</a></strong><br />
<em>Utilize a standard application form developed by the sponsor that includes, at a minimum, all data fields provided in Appendix F, "Information to be Collected on Secondary School Student Host Family Applications". The form must include a statement stating that: "The income data collected will be used solely for the purposes of determining that the basic needs of the exchange student can be met, including three quality meals and transportation to and from school activities." Such application form must be signed and dated at the time of application by all potential host family applicants. The host family application must be designed to provide a detailed summary and profile of the host family, the physical home environment (to include photographs of the host family home's exterior and grounds, kitchen, student's bed[-=p0 room, bathroom, and family or living room), family composition, and community environment. Exchange students are not permitted to reside with their relatives.</em></p>