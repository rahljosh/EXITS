<!--- ------------------------------------------------------------------------- ----
	
	File:		familyAlbum.cfm
	Author:		Marcus Melo
	Date:		November 6, 2012
	Desc:		Host Family Album

	Updated:	

----- ------------------------------------------------------------------------- --->

<cfsilent>

    <!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />	

	<!--- Param URL Variables --->
    <cfparam name="URL.deleteImageID" default="">

	<!--- Param FORM Variables --->
    <cfparam name="FORM.action" default="">
    <cfparam name="FORM.fileData" default="">
    <cfparam name="FORM.categoryID" default="">
	
    <cfscript>
		// Get Category List
		qGetCategoryList = APPLICATION.CFC.LOOKUPTABLES.getPictureCategory();
	</cfscript>

    <cfquery name="qGetImages" datasource="#APPLICATION.DSN.Source#">
        SELECT 
        	pa.ID,
        	pa.filename, 
            pa.description, 
            pa.cat,
            cat_name
        FROM 
        	smg_host_picture_album pa
        LEFT OUTER JOIN
        	smg_host_pic_cat c ON c.catID = pa.cat
        WHERE 
        	pa.fk_hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CFC.SESSION.getHostSession().ID#">
    </cfquery>

	<!--- Delete Image --->
    <cfif VAL(URL.deleteImageID)>
    	        
        <cftry>
        	
            <!--- Get Image Name --->			
            <cfquery name="qGetImageInfo" datasource="#APPLICATION.DSN.Source#">
                SELECT 
                    ID,
                    filename 
                FROM 
                    smg_host_picture_album
                WHERE 
                    fk_hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CFC.SESSION.getHostSession().ID#">
                AND
                	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.deleteImageID#">
            </cfquery>
            
            <!--- Delete Large Image --->
            <cffile action="delete" file="#APPLICATION.CFC.SESSION.getHostSession().PATH.albumLarge##qGetImageInfo.filename#">
            
            <!--- Delete Thumb Image --->
            <cffile action="delete" file="#APPLICATION.CFC.SESSION.getHostSession().PATH.albumThumbs##qGetImageInfo.filename#"> 
            
            <cfcatch type="any">
            	<!--- Errors Found --->
            </cfcatch>
            
        </cftry>
		
        <!--- Delete Record --->
        <cfquery datasource="#APPLICATION.DSN.Source#">
            DELETE FROM
                smg_host_picture_album
            WHERE 
                fk_hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CFC.SESSION.getHostSession().ID#">
            AND
            	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.deleteImageID#">
        </cfquery>

		<cfscript>
            // Set Page Message
            SESSION.pageMessages.Add("Picture has been deleted");
        </cfscript>
        
        <cflocation url="index.cfm?section=familyAlbum" addtoken="no">

    </cfif>

	<!--- Update Descriptions --->
    <cfif FORM.action EQ 'updateDescription'>
    
        <cfloop query="qGetImages">
        
            <cfquery datasource="#APPLICATION.DSN.Source#">
                UPDATE
                	smg_host_picture_album
                SET 
                	description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form['desc_' & qGetImages.ID]#"> 
                WHERE 
                	fk_hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CFC.SESSION.getHostSession().ID#">
                AND
                    ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetImages.ID#">   
            </cfquery>
            
        </cfloop>
        
        <cflocation url="index.cfm?section=schoolInfo" addtoken="no">
        
    </cfif>
    
    <!--- Upload File --->
	<cfif FORM.action EQ 'uploadFile'>
    
		<!--- Process Form Submission --->
        <cfscript>
            // Data Validation
            if ( NOT LEN(FORM.fileData) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please select a file to upload.");
            }
			
            // Data Validation
            if ( NOT LEN(FORM.categoryID) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate which catagory this picture belongs to.");
            }
        </cfscript>
			
        <!--- No Errors - we have a file and category --->
        <cfif NOT SESSION.formErrors.length()>
        	
            <cfinvoke component="extensions.components.document" method="familyAlbumUpload" returnvariable="stResult">
                <cfinvokeargument name="formField" value="#FORM.fileData#">
                <cfinvokeargument name="categoryID" value="#ReplaceNoCase(FORM.categoryID,'area','')#">
            </cfinvoke>
            
            <cfscript>
				if ( stResult.isSuccess ) {
                    // Set Page Message
                    SESSION.pageMessages.Add(stResult.message);
				} else {
					// Set Error Message
					SESSION.formErrors.Add(stResult.message);
				}	
				
				// Refresh Page
				location("index.cfm?section=familyAlbum", "no");
			</cfscript>
            
		</cfif>
	
	</cfif>    
    
</cfsilent>

<style type="text/css">
	.box{
		margin: 10px 0px;
		padding:15px 10px 15px 50px;
		background-repeat: no-repeat;
		background-position: 10px center;
		position:relative;
		color: #000;
		background-color:#FFC;
		background-image: url('images/info.png');
	}
</style>

<script type="text/javascript">
	$(document).ready(function(){
		$('.box').hide();
		
		$('#dropdown').change(function() {
			$('.box').hide();
			$('#div' + $(this).val()).show();
		});
		
	});
</script>

<cfoutput>

    <h2>Picture Album</h2> 
    
    Please upload photos of you, your family, and your home including the exterior and grounds, kitchen, student's bedroom, student's bathroom, 
    and family and living areas with a brief description of each. <br /><br />
    
    <h3>Upload Single Pictures<br /></h3>
    
    <font size=-2><em>Once you upload a picture, you will be able to add a description for each picture.</em></font><br /><br />

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
	
    <!--- Upload Form --->        
	<form method="post" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" enctype="multipart/form-data">  
    	<input type="hidden" name="action" value="uploadFile" />
        <table width="100%" cellspacing="0" cellpadding="2" class="border">
            <tr>
                <td colspan="4">
                    <cfloop query="qGetCategoryList">
                        <div id="divarea#catid#" class="box" display="hidden">#requirements#</div>
                    </cfloop>
                </td>
            </tr>
            <tr>
                <td>
                    Select a category for this picture:<br />
                    <select name="categoryID" id="dropdown">
                        <option value="0"></option>
                        <cfloop query="qGetCategoryList">
                            <option value="area#catID#" <cfif FORM.categoryID EQ "area#qGetCategoryList.catID#">selected</cfif>>#qGetCategoryList.cat_name#<cfif qGetCategoryList.catid NEQ 7>*</cfif></option>
                        </cfloop>
                    </select>
                </td>
                <td><input type="file" name="fileData" /><br /></td>
				<td><input type="image" src="/images/buttons/BlkSubmit.png" /></td>
		    </tr>
		</table>
	</form>
    
	*At least one picture from this catagory is required. More than one photo may be needed to clearly depict each room.

    <h3>Your Photo Album</h3>
    
    <!--- Update Description --->
    <form method="post" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#">
    	<input type="hidden" name="action" value="updateDescription" />
        <cfset vTrRowCount = 1>
    	<table width="100%" cellspacing="0" cellpadding="4" class="border">
            <tr>
                <cfloop query="qGetImages">
                	<td width="50%" valign="top" align="center">
                        
                        <div style="display:block; margin:5px 0 2px 0;">
							
                            <span style="float:left; margin-right:3px;">
                                <label for="#qGetImages.ID#" style="font-weight:bold;">
                                	<span style="display:block; margin-bottom:5px;">#qGetImages.cat_name#</span>
                                	<img src="#APPLICATION.CFC.SESSION.getHostSession().PATH.relativeAlbumThumbs##qGetImages.filename#">
                                    <!--- <cfimage action="writeToBrowser" source="#APPLICATION.CFC.SESSION.getHostSession().PATH.albumThumbs##qGetImages.filename#"> --->
                                </label>
                            </span>    
                            
                            <span style="display:block; margin-bottom:5px;">Description of picture:</span>
                            <textarea name="desc_#qGetImages.ID#" id="#qGetImages.ID#" cols="20" rows="6">#qGetImages.description#</textarea>
                            
                        </div>
                         
                        <div style="display:block; margin:3px 0 5px 0;"> 
                            <a href="index.cfm?section=familyAlbum&deleteImageID=#qGetImages.ID#" onClick="return confirm('Are you sure you want to delete the #qGetImages.cat_name# picture?')">
                                <img src="/images/buttons/deleteGreyRed.png" height="30" border="0" />
                            </a>
                        </div>
                    </td>
            		<cfif qGetImages.currentRow MOD 2 EQ 0>
                    	<cfset vTrRowCount ++>
                        </tr>
		                <tr <cfif vTrRowCount MOD 2 EQ 0> bgcolor="##deeaf3" </cfif> >
                    <cfelseif qGetImages.currentRow EQ qGetImages.recordCount>
                    	<td width="50%">&nbsp;</td> 
        		    </cfif>
		        </cfloop>
            
			<cfif NOT qGetImages.recordcount>
                <tr><td align="center"><h3>No pictures were found.  Not a  problem though, just upload a few and you'll be set.</h3></td></tr>
            </cfif>
    	</table>

        <table border="0" cellpadding="4" cellspacing="0" width="100%" class="section">
            <tr>
                <td align="center" valign="center">
                	When you are done editing the descriptions, just click "Next"
				</td>                    
                <td align="right">
                    <input name="Submit" type="image" src="/images/buttons/Next.png"/>
                </td>
            </tr>
        </table>
    </form>
    
</cfoutput>