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

	<!--- Parameter for the folder locations of images --->
    <cfparam name="relative" default="../">
    <cfparam name="URL.seasonID" default="">

	<!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	
    <cfscript>
		// Get Uploaded Images
		qGetUploadedImages = APPLICATION.CFC.DOCUMENT.getDocuments(
			foreignTable="smg_hosts",	
			foreignID=VAL(qGetHostInfo.hostID), 			
			documentGroup="familyAlbum",
			seasonID=URL.seasonID
		);
	</cfscript>
    
</cfsilent>   

<cfoutput>

	<cfset records = qGetUploadedImages.recordCount>
    <cfset i = 1>
    <cfset showAnything = true>
    <cfset noImages = false>
    
    <cfloop condition="records GTE i">
    
    	<!--- Page Header --->
        <table class="profileTable" align="center">
            <tr>
                <td>
                	<!--- Host Header --->
                	<cfif showAnything>
                        <table align="center" border="0" cellpadding="4" cellspacing="0" width="800">
                            <tr>
                                <td colspan="3">
                                    <cfif qGetHostInfo.companyID EQ 10>
                                        <img src="#relative#pics/10_short_profile_headerDouble.jpg" width="800px">
                                    <cfelseif qGetHostInfo.companyID EQ 14>
                                        <img src="#relative#pics/14_short_profile_headerDouble.jpg" width="800px">
                                    <cfelseif qGetHostInfo.companyID EQ 15>
                            			<img src="#relativve#pics/15_short_profile_headerDouble.jpg" width="800px">
                                    <cfelse>
                                        <img src="#relative#pics/hostAppBanners/Pdf_Headers_02Double.jpg" width="100%">
                                    </cfif>
                                </td>
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
                                    <span class="title">Started:</span> #DateFormat(qGetHostInfo.dateStarted, 'mmm, d, yyyy')#<br />
                                    <span class="title">Section <cfif URL.reportType EQ "office">8<cfelse>7</cfif></span>
                                </td>
                            </tr>
                        </table>
                 	</cfif>
                    
                    <!--- Keeps track of how many images are being shown, used to add to the index of the query --->
                    <cfset addToI = 1>
                    
                    <!--- Keeps track of what images are being displayed, by default we should be able to display the first one. --->
                    <cfset display1 = true>
                    <cfset display2 = false>
                    <cfset display3 = false>
                    <cfset display4 = false>
                    
                    <!--- First Image --->
                    <cftry>
                        <cfimage action="info" source="#qGetUploadedImages.filePath[i]#" structname="stImageInfo1">
                        <cfscript>
                            if ( stImageInfo1.height GT stImageInfo1.width ) {
                                vSetSize1 = 'height: 350px;';
                            } else {
                                vSetSize1 = 'width: 375px;';
                            }
                        </cfscript>
                        <cfcatch type="any">
                        	<cfset display1 = false>
                      	</cfcatch>
                 	</cftry>
                      
                  	<!--- Second Image ---> 
                	<cfif i+1 LTE records>
						<cfset addToI = addToI + 1>
                        <cftry>
                            <cfimage action="info" source="#qGetUploadedImages.filePath[i+1]#" structname="stImageInfo2">
                            <cfscript>
                                if ( stImageInfo2.height GT stImageInfo2.width ) {
                                    vSetSize2 = 'height: 350px;';
                                } else {
                                    vSetSize2 = 'width: 375px;';
                                }
                            </cfscript>
                            <cfset display2 = true>
                            <cfcatch type="any">
                            	<cfset display2 = false>
                            </cfcatch>
                     	</cftry>
                    </cfif>
                  	
                    <!--- Third Image --->   
					<cfif i+2 LTE records>
                        <cfset addToI = addToI + 1>
                        <cftry>
                            <cfimage action="info" source="#qGetUploadedImages.filePath[i+2]#" structname="stImageInfo3">
                            <cfscript>
                                if ( stImageInfo3.height GT stImageInfo3.width ) {
                                    vSetSize3 = 'height: 350px;';
                                } else {
                                    vSetSize3 = 'width: 375px;';
                                }
                            </cfscript>
                            <cfset display3 = true>
                            <cfcatch type="any">
                            	<cfset display3 = false>
                          	</cfcatch>
                      	</cftry>
                    </cfif>
                        
                  	<!--- Fourth Image --->
					<cfif i+3 LTE records>
                        <cfset addToI = addToI + 1>
                        <cftry>
                            <cfimage action="info" source="#qGetUploadedImages.filePath[i+3]#" structname="stImageInfo4">
                            <cfscript>
                                if ( stImageInfo4.height GT stImageInfo4.width ) {
                                    vSetSize4 = 'height: 350px;';
                                } else {
                                    vSetSize4 = 'width: 375px;';
                                }
                            </cfscript>
                            <cfset display4 = true>
                            <cfcatch type="any">
                            	<cfset display4 = false>
                          	</cfcatch>
                     	</cftry>
                    </cfif>
                    
                    <!--- If no images will be displayed here we don't want to have a blank page, so this variable will prevent showing anything and breaking the page. --->
                    <cfset showAnything = display1 OR display2 OR display3 OR display4>
                    <cfif i+3 GTE records AND NOT showAnything>
                    	<cfset noImages = true>
                    </cfif>
                    
                    <cfif noImages>
                    	<table align="center" border="0" cellpadding="4" cellspacing="0" width="800"> 
                            <tr>           
                                <td colspan="2" align="center"><div class="heading">FAMILY ALBUM</div></td>
                            </tr>
                            <tr>
                            	<td colspan="2" align="center">No images could be found for this family.</td>
                            </tr>
                     	</table>
                    </cfif>
    
                    <!--- Display Images | 4 per page --->
                    <cfif showAnything>
                        <table align="center" border="0" cellpadding="4" cellspacing="0" width="800"> 
                            <tr>           
                                <td colspan="2" align="center"><div class="heading">FAMILY ALBUM</div></td>
                            </tr>
                            
                            <tr>
                                <td align="center">
                                    <cfif display1>
                                        <img src="#relative#uploadedfiles/hostApp/#VAL(qGetHostInfo.hostID)#/album/large/#qGetUploadedImages.fileName[i]#" style="border:1px solid ##999; #vSetSize1#" />
                                    </cfif>
                                </td>
                                <td align="center">
                                    <cfif display2>
                                        <img src="#relative#uploadedfiles/hostApp/#VAL(qGetHostInfo.hostID)#/album/large/#qGetUploadedImages.fileName[i+1]#" style="border:1px solid ##999; #vSetSize2#" />
                                    </cfif>
                                </td>
                            </tr>   
                            <tr>
                                <td align="center">
                                    <cfif display1>
                                    	<span class="title">Image Of:</span> <span class="answer">#qGetUploadedImages.documentType[i]#</span><br/>
                                        <span class="title">Description:</span> <span class="answer">#qGetUploadedImages.description[i]#</span>
                                    </cfif>
                                </td>  
                                <td align="center">
                                    <cfif display2>
                                    	<span class="title">Image Of:</span> <span class="answer">#qGetUploadedImages.documentType[i+1]#</span><br/>
                                        <span class="title">Description:</span> <span class="answer">#qGetUploadedImages.description[i+1]#</span>
                                    </cfif>
                                </td>
                            </tr>
                            <tr>
                                <td align="center">
                                    <cfif display3>
                                        <img src="#relative#uploadedfiles/hostApp/#VAL(qGetHostInfo.hostID)#/album/large/#qGetUploadedImages.fileName[i+2]#" style="border:1px solid ##999; #vSetSize3#" />
                                    </cfif>
                                </td>
                                <td align="center">
                                    <cfif display4>
                                        <img src="#relative#uploadedfiles/hostApp/#VAL(qGetHostInfo.hostID)#/album/large/#qGetUploadedImages.fileName[i+3]#" style="border:1px solid ##999; #vSetSize4#" />
                                    </cfif>
                                </td>
                            </tr>   
                            <tr>
                                <td align="center">
                                    <cfif display3>
                                    	<span class="title">Image Of:</span> <span class="answer">#qGetUploadedImages.documentType[i+2]#</span><br/>
                                        <span class="title">Description:</span> <span class="answer">#qGetUploadedImages.description[i+2]#</span>
                                    </cfif>
                                </td>  
                                <td align="center">
                                    <cfif display4>
                                    	<span class="title">Image Of:</span> <span class="answer">#qGetUploadedImages.documentType[i+3]#</span><br/>
                                        <span class="title">Description:</span> <span class="answer">#qGetUploadedImages.description[i+3]#</span>
                                    </cfif>
                                </td>
                            </tr>                                                      
                        </table>
                 	</cfif>
                    
                    <cfset i = i + addToI>
                    
                </td>
            </tr>
        </table>             
            
        <!--- Page Break --->
        <cfif (qGetUploadedImages.recordCount NEQ qGetUploadedImages.currentRow) AND showAnything>
            <div style="margin:0; padding:0; page-break-after:always"></div>
        </cfif>
    
    </cfloop>
    
    <!--- There were no images --->
    <cfif NOT VAL(qGetUploadedImages.recordCount)>
    	<table align="center" border="0" cellpadding="4" cellspacing="0" width="800">
            <tr>
                <td colspan="3">
                    <cfif qGetHostInfo.companyID EQ 10>
                        <img src="#relative#pics/10_short_profile_headerDouble.jpg" width="800px">
                    <cfelseif qGetHostInfo.companyID EQ 14>
                        <img src="#relative#pics/14_short_profile_headerDouble.jpg" width="800px">
                    <cfelse>
                        <img src="#relative#pics/hostAppBanners/Pdf_Headers_02Double.jpg" width="100%">
                    </cfif>
                </td>
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
                    <span class="title">Started:</span> #DateFormat(qGetHostInfo.dateStarted, 'mmm, d, yyyy')#<br />
                    <span class="title">Section <cfif URL.reportType EQ "office">8<cfelse>7</cfif></span>
                </td>
            </tr>
        </table>
        <table align="center" border="0" cellpadding="4" cellspacing="0" width="800"> 
            <tr>           
                <td colspan="2" align="center"><div class="heading">FAMILY ALBUM</div></td>
            </tr>
            <tr>
                <td colspan="2" align="center">No images could be found for this family.</td>
            </tr>
        </table>
    </cfif>

</cfoutput>