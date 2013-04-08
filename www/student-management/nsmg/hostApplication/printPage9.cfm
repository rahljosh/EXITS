<!--- ------------------------------------------------------------------------- ----
	
	File:		printPage9.cfm
	Author:		Marcus Melo
	Date:		03/28/2013
	Desc:		School Information - Page 9 Print Version

	Updated:	
	
	Test URL:	
	http://smg.local/nsmg/hostApplication/printApplication.cfm?action=printPage9&hostID=37739
					
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	
    <cfscript>
		qGetSchool = APPLICATION.CFC.SCHOOL.getSchools(schoolID=VAL(qGetHostInfo.schoolID));
	</cfscript>
    
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
                            <span class="title">Page 9</span>
                        </td>
                    </tr>
                </table>

                <table align="center" border="0" cellpadding="4" cellspacing="0" width="800"> 
                    <tr>           
                        <td align="center"><img src="../pics/hostAppBanners/HPpdf_25.jpg"/></td>
                    </tr>
                    <tr>
                    	<td>

                            <table cellpadding="0" cellspacing="0" width="100%" style="line-height:20px;">
                                <tr>
                                    <td width="80" valign="top"><span class="title">School:</span></td>
                                    <td>#qGetSchool.schoolName#</td>
                           		</tr>
							</table> <br />

                            <table cellpadding="0" cellspacing="0" width="100%" style="line-height:20px;">
                                <tr>
                                    <td width="600px" ><span class="title">Does any member of your household work for the high school in a coaching/teaching/administrative capacity?</span></td>
                                    <td valign="top">#YesNoFormat(VAL(qGetHostInfo.schoolWorks))#</td>
                           		</tr>
                                <tr><td colspan="2">&nbsp;</td></tr
                                <tr>
                                	<td colspan="2"><span class="title">Job Title &amp; Duties:</span></td>
                                </tr>
                                <tr>
                                    <td colspan="2"><cfif LEN(qGetHostInfo.schoolWorksExpl)>#qGetHostInfo.schoolWorksExpl#<cfelse>n/a</cfif></td>
                                </tr>
                                <tr><td colspan="2">&nbsp;</td></tr>
                                
                                <tr>
                                    <td><span class="title">Has any member of your household had contact with a coach regarding the hosting of an exchange student with a particular athletic ability?</span></td>
                                    <td valign="top">#YesNoFormat(VAL(qGetHostInfo.schoolCoach))#</td>
                           		</tr>
                                <tr><td colspan="2">&nbsp;</td></tr>
                                <tr>
                                	<td colspan="2"><span class="title">Please Describe:</span></td>
                                </tr>
                                <tr>
                                    <td colspan="2"><cfif LEN(qGetHostInfo.schoolCoachExpl)>#qGetHostInfo.schoolCoachExpl#<cfelse>n/a</cfif></td>
                                </tr>                                
    						</table> <br />
                    	
                        </td>
					</tr>                                            
                </table>
                
                <table align="center" border="0" cellpadding="4" cellspacing="0" width="800"> 
                    <tr>           
                        <td align="center"><img src="../pics/hostAppBanners/HPpdf_transportation.jpg"/></td>
                    </tr>
                    <tr>
                    	<td>

                            <table cellpadding="0" cellspacing="0" width="100%" style="line-height:20px;">
                                <tr>
                                    <td width="400" valign="top"><span class="title">How far is the school from your home?</span></td>
                                    <td>#qGetHostInfo.schoolDistance# miles</td>
                           		</tr>
                                <tr>
                                    <td valign="top"><span class="title">How will the student get to school?</span></td>
                                    <td>#qGetHostInfo.schooltransportation# <cfif LEN(qGetHostInfo.schoolTransportationOther)>#qGetHostInfo.schoolTransportationOther#</cfif></td>
                           		</tr>
                                <tr>
                                    <td valign="top"><span class="title">Will you provide transportation for extracurricular activities?</span></td>
                                    <td>#YesNoFormat(VAL(qGetHostInfo.extraCuricTrans))#</td>
                           		</tr>
							</table>
						
                        </td>
					</tr>                                            
                </table>

            </td>
        </tr>
    </table>    

</cfoutput>