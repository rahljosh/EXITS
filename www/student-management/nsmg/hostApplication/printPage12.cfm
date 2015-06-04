<!--- ------------------------------------------------------------------------- ----
	
	File:		printPage12.cfm
	Author:		Marcus Melo
	Date:		04/07/2013
	Desc:		References - Page 12 Print Version

	Updated:	
	
	Test URL: 	
	http://smg.local/nsmg/hostApplication/printApplication.cfm?action=printPage12&hostID=37739
					
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Parameter for the folder locations of images --->
    <cfparam name="relative" default="../">

	<!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

    <cfscript>
		// Get References
		qGetReferences = APPLICATION.CFC.HOST.getReferences(hostID=qGetHostInfo.hostID);
    </cfscript>

</cfsilent>   

<cfoutput>

    <table class="profileTable" align="center">
        <tr>
            <td style="padding-bottom:20px;">
            
				<!--- Host Header --->
                <table align="center" border="0" cellpadding="4" cellspacing="0" width="800" style="line-height:20px;">
                    <tr>
                        <td colspan="3">
                        	<cfif qGetHostInfo.companyID EQ 10>
                            	<img src="#relative#pics/10_short_profile_headerDouble.jpg" width="800px">
                           	<cfelseif qGetHostInfo.companyID EQ 14>
                            	<img src="#relative#pics/14_short_profile_headerDouble.jpg" width="800px">
                            <cfelseif qGetHostInfo.companyID EQ 15>
                            	<img src="#relative#pics/15_short_profile_headerDouble.jpg" width="800px">
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
                            <span class="title">Section 12</span>
                        </td>
                    </tr>
                </table>
				
                <table align="center" border="0" cellpadding="4" cellspacing="0" width="800"> 
                    <tr>           
                        <td colspan="2" align="center"><div class="heading">REFERENCES</div></td>
                	</tr>
                    <tr>
                    	<td>
                        	
                            <!--- References --->
                            <table cellpadding="0" cellspacing="0" width="100%" style="line-height:20px;">
                        	
                            	<cfloop query="qGetReferences">
                            
                                    <tr <cfif qGetReferences.currentrow MOD 2>bgcolor="##ddeaf3"</cfif> >
                                        <td valign="top" width="50%">
                                        
                                            <table cellpadding="0" cellspacing="0" width="100%" style="line-height:20px;">
                                                <tr>
                                                    <td width="100"><span class="title">Name:</span></td>
                                                    <td class="answer">
                                                        #qGetReferences.firstName# #qGetReferences.lastName#
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><span class="title">Phone:</span></td>
                                                    <td class="answer">#qGetReferences.phone#</td>
                                                </tr>
                                                <tr>
                                                    <td><span class="title">Address:</span></td>
                                                    <td class="answer">#qGetReferences.address#</td>
                                                </tr>
                                                <cfif LEN(qGetReferences.address2)>
                                                    <tr>
                                                        <td>&nbsp;</td>
                                                        <td class="answer">#qGetReferences.address2#</td>
                                                    </tr>
                                                </cfif>
                                                <tr>
                                                	<td>&nbsp;</td>
                                                    <td class="answer">#qGetReferences.city#, #qGetReferences.state# #qGetReferences.zip#</td>
                                                </tr>
                                                <tr>
                                                    <td><span class="title">Email:</span></td>
                                                    <td class="answer">#qGetReferences.email#</td>
                                                </tr>
                                            </table>
                                        
                                        </td>
                                    </tr>
            						<tr><td colspan="2">&nbsp;</td></tr>
                            	</cfloop>                      
			            	
                            </table>
                        	                                                                                                    
                        </td>
					</tr>                                                
				</table>
                
            </td>
		</tr>
	</table>                    
                     
</cfoutput>
