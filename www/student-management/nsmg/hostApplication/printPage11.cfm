<!--- ------------------------------------------------------------------------- ----
	
	File:		printPage11.cfm
	Author:		Marcus Melo
	Date:		03/28/2013
	Desc:		Confidential Data - Page 11 Print Version

	Updated:	
	
	Test URL:	
	http://smg.local/nsmg/hostApplication/printApplication.cfm?action=printPage11&hostID=377311
					
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

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
                            <span class="title">Page 11</span>
                        </td>
                    </tr>
                </table>

                <table align="center" border="0" cellpadding="4" cellspacing="0" width="800"> 
                    <tr>           
                        <td align="center"><img src="../pics/hostAppBanners/HPpdf_confidential.jpg"/></td>
                    </tr>
                    <tr>
                    	<td>

                            <table cellpadding="0" cellspacing="0" width="100%" style="line-height:20px;">
                                <tr>
                                    <td width="450"><span class="title">Is any member of your household receiving any kind of public assistance?</span></td>
                                    <td valign="top">#YesNoFormat(VAL(qGetHostInfo.publicAssitance))#</td>
                           		</tr>
                                <tr>
                                    <td colspan="2"><span class="title">Please explain:</span></td>
                           		</tr>
                                <tr>
                                    <td colspan="2"><cfif LEN(qGetHostInfo.publicAssitanceExpl)>#qGetHostInfo.publicAssitanceExpl#<cfelse>n/a</cfif></td>
                           		</tr>
                                
                                
                                <tr><td colspan="2">&nbsp;</td></tr>

                                <tr>
                                    <td><span class="title">Average annual income range:</span></td>
                                    <td valign="top">
                                    	<cfswitch expression="#qGetHostInfo.income#">
                                            <cfcase value="25">Less then $25,000</cfcase>
                                            <cfcase value="35">$25,000 - $35,000</cfcase>
                                            <cfcase value="45">$35,001 - $45,000</cfcase>
                                            <cfcase value="55">$45,001 - $55,000</cfcase>
                                            <cfcase value="65">$55,001 - $65,000</cfcase>
                                            <cfcase value="75">$65,001 - $75,000</cfcase>
                                            <cfcase value="85">$75,000 and above</cfcase>
										</cfswitch>                                            
                                    </td>
                           		</tr>
                                
                                <tr><td colspan="2">&nbsp;</td></tr>
                                
                                <tr>
                                    <td><span class="title">Has any member of your household ever been charged with a crime?</span></td>
                                    <td valign="top">#YesNoFormat(VAL(qGetHostInfo.crime))#</td>
                           		</tr>
                                <tr>
                                    <td colspan="2"><span class="title">Please explain:</span></td>
                           		</tr>
                                <tr>
                                    <td colspan="2"><cfif LEN(qGetHostInfo.crimeExpl)>#qGetHostInfo.crimeExpl#<cfelse>n/a</cfif></td>
                           		</tr>

                                <tr><td colspan="2">&nbsp;</td></tr>

                                <tr>
                                    <td><span class="title">Have you had any contact with Child Protective Services Agency in the past?</span></td>
                                    <td valign="top">#YesNoFormat(VAL(qGetHostInfo.cps))#</td>
                           		</tr>
                                <tr>
                                    <td colspan="2"><span class="title">Please explain:</span></td>
                           		</tr>
                                <tr>
                                    <td colspan="2"><cfif LEN(qGetHostInfo.cpsexpl)>#qGetHostInfo.cpsexpl#<cfelse>n/a</cfif></td>
                           		</tr>
							</table>
                    	
                        </td>
					</tr>                                            
                </table>
                
            </td>
        </tr>
    </table>    

</cfoutput>