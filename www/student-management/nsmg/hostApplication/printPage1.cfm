<!--- ------------------------------------------------------------------------- ----
	
	File:		printPage1.cfm
	Author:		Marcus Melo
	Date:		03/09/2013
	Desc:		Page 1 Print Version

	Updated:	
	
	Test URL:	
	http://smg.local/nsmg/hostApplication/printApplication.cfm?action=printPage1&hostID=37739
					
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
    
</cfsilent>   

<cfoutput>

    <table class="profileTable" align="center">
        <tr>
            <td style="padding-bottom:20px;">
            
				<!--- Host Header --->
                <table align="center" border="0" cellpadding="4" cellspacing="0" width="800" style="line-height:20px;">
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
                            <span class="title">Page 1</span>
                        </td>
                    </tr>
                </table>


                <table align="center" border="0" cellpadding="4" cellspacing="0" width="800"> 
                    <tr>           
                        <td colspan="2" align="center"><img src="../pics/hostAppBanners/HPpdf_04.jpg"/></td>
                	</tr>
                    <tr>
                    	<td>
                        
                            <table cellpadding="0" cellspacing="0" width="100%" style="line-height:20px;">
                                <tr>
                                    <td width="100" valign="top"><span class="title">Family Name:</span></td>
                                    <td>#qGetHostInfo.familyLastName# (###qGetHostInfo.hostid#)</td>
                           		</tr>
    						</table>
						
                        </td>
					</tr>                                                
                    <tr>
                        <td valign="top" width="50%">
                            
							<!--- Home Address ---> 
                            <table cellpadding="0" cellspacing="0" width="100%" style="line-height:20px;">
                            
                                <tr>
                                    <td width="100" valign="top"><span class="title">Home Address:</span></td>
                                    <td>
                                        #qGetHostInfo.address# <br />
                                        #qGetHostInfo.city# #qGetHostInfo.state#, #qGetHostInfo.zip#
                                    </td>
                           		</tr>
                                <tr>
                                    <td valign="top"><span class="title">Home Phone: </span></td>
                                    <td>#qGetHostInfo.phone#</td>
                                </tr>
    						</table>
                        
                        </td>
                        <td valign="top" width="50%">
                        
							<!--- Mailing Address ---> 
                            <table cellpadding="0" cellspacing="0" width="100%" style="line-height:20px;">
                                <tr>
                                    <td valign="top"><span class="title">Mailing Address:</span></td>
                                    <td>
                                        #qGetHostInfo.mailaddress# <br />
                                        #qGetHostInfo.mailcity# #qGetHostInfo.mailstate#, #qGetHostInfo.mailzip#
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top"><span class="title">Email Address: </span></td>
                                    <td>#qGetHostInfo.email#</td>
                                </tr>
							</table>  
                                                          
                        </td>
                    </tr>
				</table>
                
				
                <!--- Ethnicity --->
                <table align="center" border="0" cellpadding="4" cellspacing="0" width="800"> 
                    <tr>           
                        <td colspan="2" align="center"><img src="../pics/hostAppBanners/HPpdf_ethnicity.jpg"/></td>
                	</tr>
                    <tr>
                    	<td width="350" valign="top">
                        	<span class="title">What is the ethnicity of your family?</span>
                        </td>
                        <td valign="top">
                        	#qGetHostInfo.race#
 							<cfif LEn(qGetHostInfo.ethnicityOther)>
                            	<br />
								Other: #qGetHostInfo.ethnicityOther#
                            </cfif>
                        </td>
					</tr> 
                    <tr>
                    	<td width="350" valign="top">
                        	<span class="title">Primary language spoken in your home</span>
                        </td>
                        <td valign="top">#qGetHostInfo.primaryLanguage#</td>
					</tr>  
                </table>
                
                
                <!--- Home Based Business --->
                <table align="center" border="0" cellpadding="4" cellspacing="0" width="800"> 
                    <tr>           
                        <td colspan="2" align="center"><img src="../pics/hostAppBanners/HPpdf_homebased.jpg"/></td>
                	</tr>
                    <tr>
                    	<td width="350" valign="top">
                        	<span class="title">Is the residence the site of a functioning business? <br /> (e.g. daycare, farm)</span>
                        </td>
                        <td valign="top">#YesNoFormat(VAL(qGetHostInfo.homeIsFunctBusiness))#</td>
					</tr> 
                    <tr>
                    	<td colspan="2">
                        	<span class="title">Please Describe</span>
                        </td>
					</tr>  
                    <tr>
                    	<td colspan="2">#qGetHostInfo.homeBusinessDesc#</td>
					</tr>                        
                </table>


                <!--- Father's Information --->
                <cfif LEN(qGetHostInfo.fatherfirstname)>
                    <table align="center" border="0" cellpadding="4" cellspacing="0" width="800"> 
                        <tr>           
                            <td colspan="2" align="center"><img src="../pics/hostAppBanners/HPpdf_father.jpg"/></td>
                        </tr>
                        <tr>
                            <td valign="top" width="50%">
                                <table cellpadding="0" cellspacing="0" width="100%" style="line-height:20px;">
                                    <tr>
                                        <td width="150"><span class="title">Name:</span></td>
                                        <td width="200">
                                            #qGetHostInfo.fatherfirstname# #qGetHostInfo.fatherMiddleName# #qGetHostInfo.fatherlastname#
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><span class="title">Date of Birth:</span></td>
                                        <td>
                                            <cfif IsDate(qGetHostInfo.fatherDOB)>
                                                #DateFormat(qGetHostInfo.fatherDOB, 'mm/dd/yyyy')# - #DateDiff('yyyy', qGetHostInfo.fatherDOB, now())# years old                                  
                                            </cfif>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><span class="title">Education Level:</span></td>
                                        <td><cfif LEN(qGetHostInfo.fatherEducationLevel)>#qGetHostInfo.fatherEducationLevel#<cfelse>n/a</cfif></td>
                                    </tr>
                                    <tr>
                                        <td><span class="title">Cell Phone:</span></td>
                                        <td><cfif NOT LEN(qGetHostInfo.father_cell)>None on File<cfelse>#qGetHostInfo.father_cell#</cfif></td>
                                    </tr>
                                </table>						
                            </td>
                            <td valign="top" width="50%">
                                <table cellpadding="0" cellspacing="0" width="100%" style="line-height:20px;">
                                    <tr>
                                        <td><span class="title">Occupation:</span></td>
                                        <td>
                                            #qGetHostInfo.fatherworktype#
                                            <cfif qGetHostInfo.fatherfullpart EQ 1>
                                                - Full Time
                                            <cfelseif qGetHostInfo.fatherfullpart EQ 0>
                                                - Part Time
                                            </cfif>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><span class="title">Employer:</span></td>
                                        <td>#qGetHostInfo.fatherEmployeer#</td>
                                    </tr>
                                    <tr>
                                        <td><span class="title">Interests:</span></td>
                                        <td rowspan="2"><cfif LEN(qGetHostInfo.fatherInterests)>#qGetHostInfo.fatherInterests#<cfelse>n/a</cfif></td>
                                    </tr>
                                </table>						
                            </td>
                        </tr>                        		                                            
                    </table>
                </cfif>

                <!--- Mother's Information --->
                <cfif LEN(qGetHostInfo.motherfirstname)>
                    <table align="center" border="0" cellpadding="4" cellspacing="0" width="800"> 
                        <tr>           
                            <td colspan="2" align="center"><img src="../pics/hostAppBanners/HPpdf_mother.jpg"/></td>
                        </tr>
                        <tr>
                            <td valign="top" width="50%">
                                <table cellpadding="0" cellspacing="0" width="100%" style="line-height:20px;">
                                    <tr>
                                        <td width="150"><span class="title">Name:</span></td>
                                        <td width="200">
                                            #qGetHostInfo.motherfirstname# #qGetHostInfo.motherMiddleName# #qGetHostInfo.motherlastname#
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><span class="title">Date of Birth:</span></td>
                                        <td>
                                            <cfif IsDate(qGetHostInfo.motherDOB)>
                                                #DateFormat(qGetHostInfo.motherDOB, 'mm/dd/yyyy')# - #DateDiff('yyyy', qGetHostInfo.motherDOB, now())# years old                                  
                                            </cfif>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><span class="title">Education Level:</span></td>
                                        <td><cfif LEN(qGetHostInfo.motherEducationLevel)>#qGetHostInfo.motherEducationLevel#<cfelse>n/a</cfif></td>
                                    </tr>
                                    <tr>
                                        <td><span class="title">Cell Phone:</span></td>
                                        <td><cfif NOT LEN(qGetHostInfo.mother_cell)>None on File<cfelse>#qGetHostInfo.mother_cell#</cfif></td>
                                    </tr>
                                </table>						
                            </td>
                            <td valign="top" width="50%">
                                <table cellpadding="0" cellspacing="0" width="100%" style="line-height:20px;">
                                    <tr>
                                        <td><span class="title">Occupation:</span></td>
                                        <td>
                                            #qGetHostInfo.motherworktype#
                                            <cfif qGetHostInfo.motherfullpart EQ 1>
                                                - Full Time
                                            <cfelseif qGetHostInfo.motherfullpart EQ 0>
                                                - Part Time
                                            </cfif>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><span class="title">Employer:</span></td>
                                        <td>#qGetHostInfo.motherEmployeer#</td>
                                    </tr>
                                    <tr>
                                        <td><span class="title">Interests:</span></td>
                                        <td rowspan="2"><cfif LEN(qGetHostInfo.motherInterests)>#qGetHostInfo.motherInterests#<cfelse>n/a</cfif></td>
                                    </tr>
                                </table>						
                            </td>
                        </tr>                        		                                            
                    </table>
                </cfif>
                
            </td>
		</tr>
	</table>                    
                     
</cfoutput>
