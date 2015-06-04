<!--- ------------------------------------------------------------------------- ----
	
	File:		printPage10.cfm
	Author:		Marcus Melo
	Date:		03/28/2013
	Desc:		Community Profile

	Updated:	
	
	Test URL:	
	http://smg.local/nsmg/hostApplication/printApplication.cfm?action=printPage10&hostID=377310
					
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Parameter for the folder locations of images --->
    <cfparam name="relative" default="../">

	<!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	    
</cfsilent>   

<cfoutput>

	<!--- Page Header --->
    <table class="profileTable" align="center">
        <tr>
            <td>
            
                <!--- Host Header --->
                <table align="center" border="0" cellpadding="4" cellspacing="0" width="800">
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
                            <span class="title">Section <cfif URL.reportType EQ "office">10<cfelse>9</cfif></span>
                        </td>
                    </tr>
                </table>

                <table align="center" border="0" cellpadding="4" cellspacing="0" width="800"> 
                    <tr>           
                        <td align="center"><div class="heading">COMMUNITY PROFILE</div></td>
                    </tr>
                    <tr>
                    	<td>

                            <table cellpadding="0" cellspacing="0" width="100%" style="line-height:20px;">
                                <tr>
                                    <td width="230" valign="top"><span class="title">Population of #qGetHostInfo.city#:</span></td>
                                    <td valign="top" class="answer">#qGetHostInfo.population#</td>
                           		</tr>
                                <tr>
                                    <td><span class="title">City or Town Website:</span></td>
                                    <td valign="top" class="answer">
                                    	<a href="<cfif NOT ListFindNoCase('http:',#qGetHostInfo.cityWebsite#)>http://www.</cfif>#qGetHostInfo.cityWebsite#" target="_blank">
                                        	#qGetHostInfo.cityWebsite#
                                      	</a>
                                 	</td>
                           		</tr>
                                <tr>
                                    <td><span class="title">Nearest Major City:</span></td>
                                    <td valign="top" class="answer">#qGetHostInfo.nearbigCity# <cfif LEN(qGetHostInfo.near_city_dist)>Distance: #qGetHostInfo.near_city_dist# miles</cfif></td>
                           		</tr>
							</table>
                    	
                        </td>
					</tr>                                            
                </table>
                
                <table align="center" border="0" cellpadding="4" cellspacing="0" width="800"> 
                    <tr>           
                        <td align="center"><div class="heading">AIRPORT</div></td>
                    </tr>
                    <tr>
                    	<td>

                            <table cellpadding="0" cellspacing="0" width="100%" style="line-height:20px;">
                                <tr>
                                    <td width="230"><span class="title">Major Airport:</span></td>
                                    <td valign="top" class="answer">#qGetHostInfo.major_air_code#</td>
                           		</tr>
							</table>
                    	
                        </td>
					</tr>                                            
                </table>
					
                <table align="center" border="0" cellpadding="4" cellspacing="0" width="800"> 
                    <tr>           
                        <td align="center"><div class="heading">CLIMATE</div></td>
                    </tr>
                    <tr>
                    	<td>

                            <table cellpadding="0" cellspacing="0" width="100%" style="line-height:20px;">
                                <tr>
                                    <td width="230"><span class="title">Avg temp in winter:</span></td>
                                    <td valign="top" class="answer">#qGetHostInfo.wintertemp# <sup>o</sup>F</td>
                           		</tr>
                                <tr>
                                    <td><span class="title">Avg temp in summer:</span></td>
                                    <td valign="top" class="answer">#qGetHostInfo.summertemp# <sup>o</sup>F</td>
                           		</tr>
                                <tr>
                                    <td><span class="title">How would you describe your seasons?</span></td>
                                    <td valign="top" class="answer">
                                    	<cfif VAL(qGetHostInfo.snowy_winter)>Cold, snowy winters &nbsp; &nbsp; &nbsp;</cfif>
                                        <cfif VAL(qGetHostInfo.rainy_winter)>Mild, rainy winters &nbsp; &nbsp; &nbsp;</cfif>
                                        <cfif VAL(qGetHostInfo.hot_summer)>Hot Summers &nbsp; &nbsp; &nbsp;</cfif>
                                        <cfif VAL(qGetHostInfo.mild_summer)>Mild Summers &nbsp; &nbsp; &nbsp;</cfif>
                                        <cfif VAL(qGetHostInfo.high_hummidity)>High Humidity &nbsp; &nbsp; &nbsp;</cfif>
                                        <cfif VAL(qGetHostInfo.dry_air)>Dry air &nbsp; &nbsp; &nbsp;</cfif>
                                    </td>
                           		</tr>
							</table>
                    	
                        </td>
					</tr>                                            
                </table>

                <table align="center" border="0" cellpadding="4" cellspacing="0" width="800"> 
                    <tr>           
                        <td align="center"><div class="heading">NEIGHBORHOOD & TERRAIN</div></td>
                    </tr>
                    <tr>
                    	<td>

                            <table cellpadding="0" cellspacing="0" width="100%" style="line-height:20px;">
                                <tr>
                                    <td width="230"><span class="title">You would describe your neighborhood as:</span></td>
                                    <td valign="top" class="answer">#qGetHostInfo.neighborhood#</td>
                           		</tr>
                                <tr>
                                    <td><span class="title">Would you describe the community as:</span></td>
                                    <td valign="top" class="answer">#qGetHostInfo.community#</td>
                           		</tr>
                                <tr>
                                    <td><span class="title">Areas in or near your neighborhood to be avoided:</span></td>
                                    <td class="answer"><cfif LEN(qGetHostInfo.avoidArea)>#qGetHostInfo.avoidArea#<cfelse>n/a</cfif></td>
                           		</tr>
                                <tr>
                                    <td><span class="title">The terrain of your community is (please select one from each row):</span></td>
                                    <td valign="top" class="answer">
                                    	#qGetHostInfo.terrain1# &nbsp; &nbsp; &nbsp;
                                    	#qGetHostInfo.terrain2# &nbsp; &nbsp; &nbsp;
                                    	#qGetHostInfo.terrain3# &nbsp; &nbsp; &nbsp;
                                        <cfif LEN(qGetHostInfo.terrain3_desc)><br />#qGetHostInfo.terrain3_desc#</cfif>
                                    </td>
                           		</tr>
							</table>
                    	
                        </td>
					</tr>                                            
                </table>

                <table align="center" border="0" cellpadding="4" cellspacing="0" width="800"> 
                    <tr>           
                        <td align="center"><div class="heading">MISCELLANEOUS INFORMATION</div></td>
                    </tr>
                    <tr>
                    	<td>

                            <table cellpadding="0" cellspacing="0" width="100%" style="line-height:20px;">
                                <tr>
                                    <td><span class="title">Indicate particular clothes, sports equipment, etc. that your student should consider bringing:</span></td>
                           		</tr>
                                <tr>
                                	<td class="answer"><cfif LEN(qGetHostInfo.special_cloths)>#qGetHostInfo.special_cloths#<cfelse>n/a</cfif></td>
                                </tr>
                                <tr>
                                    <td><span class="title">Describe the points of interest in your area:</span></td>
                           		</tr>
                                <tr>
                                	<td class="answer"><cfif LEN(qGetHostInfo.point_interest)>#qGetHostInfo.point_interest#<cfelse>n/a</cfif></td>
                                </tr>
							</table>
                    	
                        </td>
					</tr>                                            
                </table>
                
            </td>
        </tr>
    </table>    

</cfoutput>