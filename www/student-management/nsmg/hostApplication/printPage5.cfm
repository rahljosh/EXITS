<!--- ------------------------------------------------------------------------- ----
	
	File:		printPage5.cfm
	Author:		Marcus Melo
	Date:		03/17/2013
	Desc:		Hosting Environment - Page 5 Print Version

	Updated:	
	
	Test URL:	
	http://smg.local/nsmg/hostApplication/printApplication.cfm?action=printPage5&hostID=37739
					
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
    
    <cfquery name="qPets" datasource="mySQL">
        SELECT 
        	*
        FROM
        	smg_host_animals
        WHERE
        	hostid = <cfqueryparam cfsqltype="integer" value="#VAL(qGetHostInfo.hostID)#">
    </cfquery>

    <cfquery name="qGetWhoIsSharingRoom" datasource="mySQL">
        SELECT 
        	*
        FROM 
        	smg_host_children           
        WHERE 
        	hostiD = <cfqueryparam cfsqltype="integer" value="#VAL(qGetHostInfo.hostID)#">
        AND
        	shared = <cfqueryparam cfsqltype="cf_sql_varchar" value="yes">
    </cfquery>
    
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
                            <span class="title">Page 5</span>
                        </td>
                    </tr>
                </table>
                
                <table align="center" border="0" cellpadding="4" cellspacing="0" width="800"> 
                    <tr>           
                        <td align="center"><img src="../pics/hostAppBanners/HPpdf_pets.jpg"/></td>
                	</tr>
                    <tr>
                        <td>
                            <table width="100%" cellspacing="0" cellpadding="2" class="border">
                                <tr>
                                    <td><span class="title">Type</span></td>
                                    <td><span class="title">Indoor / Outdoor</span></td>
                                    <td><span class="title">How many?</span></td>
                                </tr>
                                <cfif NOT qPets.recordcount>
                                    <tr>
                                        <td colspan="3">There are no pets in this home.</td>
                                    </tr>
                                <cfelse>
                                    <cfloop query="qPets">
                                        <tr <cfif qPets.currentrow mod 2> bgcolor="##deeaf3"</cfif>>
                                            <td><p class=p_uppercase>#qPets.animaltype#</td>
                                            <td><p class=p_uppercase>#qPets.indoor#</td>
                                            <td>#qPets.number#</td>
                                        </tr>
                                    </cfloop>
                                </cfif>
                            </table>  
                        </td>
                    </tr>
				</table>
                
                <table align="center" border="0" cellpadding="4" cellspacing="0" width="800"> 
                    <tr>           
                        <td align="center"><img src="../pics/hostAppBanners/HPpdf_allergies.jpg"/></td>
                	</tr>
                    <tr>
                    	<td>
                            <table width="100%" cellspacing="0" cellpadding="2" class="border">
                                <tr>
                                    <td width="70%">
                                    	<span class="title">Would you be willing to host a student who is allergic to animals?</span>
                                        <span class="formNote">(If they are able to handle the allergy with medication)</span>
                                    </td>
                            		<td valign="top"><cfif qGetHostInfo.pet_allergies eq 0>No<cfelse>Yes</cfif></td>
                            	</tr>
                            </table> 
						</td>
					</tr>                                                                         
				</table>     

                <table align="center" border="0" cellpadding="4" cellspacing="0" width="800"> 
                    <tr>           
                        <td align="center"><img src="../pics/hostAppBanners/HPpdf_roomsharing.jpg"/></td>
                	</tr>
                    <tr>
                    	<td>
                            <table width="100%" cellspacing="0" cellpadding="2" class="border">
                                <tr>
                                    <td width="70%">
                                    	<span class="title">Will the student share a bedroom?</span>
                                        <span class="formNote">(The student may share a bedroom with someone of the same sex and within a reasonable age difference, but must have his/her own bed.)</span>
                                    </td>
                            		<td valign="top">#YesNoFormat(VAL(qGetHostInfo.isStudentSharingBedroom))#</td>
                            	</tr>
                                <cfif qGetWhoIsSharingRoom.recordCount>
                                    <tr>
                                        <td><span class="title">Who will they share a room with?</span></td>
                                        <td valign="top">#qGetWhoIsSharingRoom.name#</td>
                                    </tr>
                                </cfif>
                            </table> 
						</td>
					</tr>                                                                         
				</table>                
                           
                <table align="center" border="0" cellpadding="4" cellspacing="0" width="800"> 
                    <tr>           
                        <td align="center"><img src="../pics/hostAppBanners/HPpdf_smoking.jpg"/></td>
                	</tr>
                    <tr>
                        <td>
                            <table width="100%" cellspacing="0" cellpadding="2" class="border">
                                <tr>
                                    <td width="70%"><span class="title">Does anyone in your home smoke?</span></td>
                                    <td>#qGetHostInfo.hostsmokes#</td>
                                </tr>
                                <tr>
                                    <td colspan="2"><span class="title">Conditions:</span> #qGetHostInfo.smokeconditions#</td>
                                </tr>
                            </table> 
                        </td>
					</tr>
				</table>
                
                <table align="center" border="0" cellpadding="4" cellspacing="0" width="800"> 
                    <tr>           
                        <td align="center"><img src="../pics/hostAppBanners/HPpdf_dietaryneeds.jpg"/></td>
                	</tr>
                    <tr>
                        <td>
                            <table width="100%" cellspacing="0" cellpadding="2" class="border">
                                <tr>
                                    <td width="70%"><span class="title">Does anyone in your family follow any dietary restrictions?</span></td>
                                    <td><cfif qGetHostInfo.famDietRest eq 0>No<cfelse>Yes</cfif></td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                    	<span class="title">Restrictions:</span><br />
										<cfif qGetHostInfo.famDietRestDesc is ''>No Restrictions Noted<cfelse>#qGetHostInfo.famDietRestDesc#</cfif>
                                    </td>
                                </tr>
                                <tr>
                                    <td><span class="title">Do you expect the student to follow any dietary restrictions?</span></td>
                               		<td><cfif qGetHostInfo.stuDietRest eq 0>No<cfelse>Yes</cfif></td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                    	<span class="title">Restrictions:</span><br />
                                    	<cfif qGetHostInfo.stuDietRestDesc is ''>No Restrictions Noted<cfelse>#qGetHostInfo.stuDietRestDesc#</cfif>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                    	<span class="title">Would you feel comfortable hosting a student with a dietary restriction?</span>
                                    	<span class="formNote">(vegetarian, vegan, etc.)</span>
                                    </td>
                                    <td><cfif qGetHostInfo.dietaryRestriction eq 0>No<cfelse>Yes</cfif></td>
                                </tr>
                                <tr>
                                    <td>
                                    	<span class="title">Are you prepared to provide three (3) quality meals per day?</span>
                                    	<span class="formNote">(students are expected to provide and/or pay for school lunches)</span>
                                    </td>
                                    <td><cfif qGetHostInfo.threesquares eq 0>No<cfelse>Yes</cfif></td> 
                                </tr>
                            </table> 
                        </td>
					</tr>
				</table>
                                
            </td>
		</tr>
	</table>                    
                     
</cfoutput>