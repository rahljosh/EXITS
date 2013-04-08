<!--- ------------------------------------------------------------------------- ----
	
	File:		printPage8.cfm
	Author:		Marcus Melo
	Date:		03/28/2013
	Desc:		Family Album - Page 8 Print Version
				8.5 x 11 page is about 540 pixels wide and 720 pixels tall

	Updated:	
	
	Test URL:	
	http://smg.local/nsmg/hostApplication/printApplication.cfm?action=printPage8&hostID=37739
					
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	
    <cfscript>
		// Get Uploaded Images
		qGetUploadedImages = APPLICATION.CFC.DOCUMENT.getDocuments(
			foreignTable="smg_hosts",	
			foreignID=VAL(qGetHostInfo.hostID), 			
			documentGroup="familyAlbum"
		);
	</cfscript>
    
</cfsilent>   

<cfoutput>

    <cfloop query="qGetUploadedImages">
	
	    <!--- Get Image Information --->
		<cfimage action="info" source="#qGetUploadedImages.filePath#" structname="stImageInfo"> 
    
        <cfscript>
			if ( stImageInfo.height GT stImageInfo.width ) {
            	vSetSize = 'height="650px"';
            } else {
                vSetSize = 'width="750px"';
            }
		</cfscript>
        
        <!--- Page Header --->
        <table class="profileTable" align="center">
            <tr>
                <td>
                
                    <!--- Host Header --->
                    <table align="center" border="0" cellpadding="4" cellspacing="0" width="800">
                        <tr>
                            <td colspan="3"><img src="../pics/hostAppBanners/Pdf_Headers_02.jpg"></td>
                        </tr>
                        <tr>
                            <td valign="top">
                                <span class="title">Region:</span> #qGetHostInfo.regionName#<br />
                                <span class="title">Area Representative:</span> #qGetHostInfo.areaRepresentative#
                            </td>
                            <td align="center" valign="top">
                                <span class="title" style="font-size:18px;">#qGetHostInfo.familyLastName# (###qGetHostInfo.hostid#) <br /> Host Family Application</span>
                            </td>
                            <td align="right" valign="top">
                                <span class="title">Started:</span> #DateFormat(qGetHostInfo.applicationStarted, 'mmm, d, yyyy')#<br />
                                <span class="title">Page 8</span>
                            </td>
                        </tr>
                    </table>
    
    				<!--- Display Images | 1 per page --->
                    <table align="center" border="0" cellpadding="4" cellspacing="0" width="800"> 
                        <tr>           
                            <td colspan="2" align="center"><img src="../pics/hostAppBanners/HPpdf_20.jpg"/></td>
                        </tr>
						
                        <tr>
                            <td colspan="2" align="center">
                                <img src="../uploadedfiles/hostApp/#VAL(qGetHostInfo.hostID)#/album/large/#qGetUploadedImages.fileName#" style="border:1px solid ##999" #vSetSize# />
                            </td>
                        </tr>   
                        <tr>
                            <td width="75px"><span class="title">Description:</span></td>  
                            <td>#qGetUploadedImages.description#</td>
                        </tr>                                                       
                    </table>
                    
                </td>
            </tr>
        </table>             
            
		<!--- Page Break --->
        <cfif qGetUploadedImages.recordCount NEQ qGetUploadedImages.currentRow>
	        <div style="margin:0; padding:0; page-break-after:always"></div>
        </cfif>
    
    <!--- 2 Images Per Sheet --->
    <!---    
        <!--- Page Header --->
        <cfif qGetUploadedImages.currentRow MOD 2 EQ 1>
            <table class="profileTable" align="center">
                <tr>
                    <td>
                    
                        <!--- Host Header --->
                        <table align="center" border="0" cellpadding="4" cellspacing="0" width="800">
                            <tr>
                                <td colspan="3"><img src="../pics/hostAppBanners/Pdf_Headers_02.jpg"></td>
                            </tr>
                            <tr>
                                <td valign="top">
                                    <span class="title">Region:</span> #qGetHostInfo.regionName#<br />
                                    <span class="title">Area Representative:</span> #qGetHostInfo.areaRepresentative#
                                </td>
                                <td align="center" valign="top">
                                    <span class="title" style="font-size:18px;">#qGetHostInfo.familyLastName# (###qGetHostInfo.hostid#) <br /> Host Family Application</span>
                                </td>
                                <td align="right" valign="top">
                                    <span class="title">Started:</span> #DateFormat(qGetHostInfo.applicationStarted, 'mmm, d, yyyy')#<br />
                                    <span class="title">Page 8</span>
                                </td>
                            </tr>
                        </table>
        
        
                        <table align="center" border="0" cellpadding="4" cellspacing="0" width="800"> 
                            <tr>           
                                <td colspan="2" align="center"><img src="../pics/hostAppBanners/HPpdf_20.jpg"/></td>
                            </tr>
		</cfif>
		
		<!--- Display Images | 2 per page --->
        <tr>
            <td colspan="2" align="center">
                <img src="../uploadedfiles/hostApp/#VAL(qGetHostInfo.hostID)#/album/large/#qGetUploadedImages.fileName#" width="400px" height="300px" />
            </td>
        </tr>   
        <tr>
         	<td width="75px"><span class="title">Description:</span></td>  
            <td>#qGetUploadedImages.description#</td>
		</tr>                                                       
        
        <!--- Page Footer --->             
        <cfif qGetUploadedImages.currentRow MOD 2 EQ 0 OR qGetUploadedImages.recordCount EQ qGetUploadedImages.currentRow>
                        </table>
                        
                    </td>
                </tr>
            </table>             
            
            <!--- Page Break --->
            <cfif qGetUploadedImages.recordCount NEQ qGetUploadedImages.currentRow>
	            <div style="margin:0; padding:0; page-break-after:always"></div>
            </cfif>
            
		</cfif>
	--->		

	</cfloop>       

</cfoutput>