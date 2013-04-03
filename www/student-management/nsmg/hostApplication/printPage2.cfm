<!--- ------------------------------------------------------------------------- ----
	
	File:		printPage2.cfm
	Author:		Marcus Melo
	Date:		03/17/2013
	Desc:		Page 2 Print Version

	Updated:	
	
	Test URL: 	
	http://smg.local/nsmg/hostApplication/printApplication.cfm?action=printPage2&hostID=37739
					
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

    <cfscript>
		// Host Family Children
		qGetHostChildren = APPLICATION.CFC.HOST.getHostMemberByID(hostID=FORM.hostID);
    </cfscript>

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
                            <span class="title">Page 2</span>
                        </td>
                    </tr>
                </table>


                <table align="center" border="0" cellpadding="4" cellspacing="0" width="800"> 
                    <tr>           
                        <td colspan="2" align="center"><img src="../pics/hostAppBanners/HPpdf_familymembers.jpg"/></td>
                	</tr>
                    <tr>
                    	<td>
                        	
                            <!--- Familiy Members --->
                            <table cellpadding="0" cellspacing="0" width="100%" style="line-height:20px;">

								<cfif NOT VAL(qGetHostChildren.recordcount)>
                                    <tr>
                                        <td colspan="2" align="center">No family members are listed with this family.</td>
                                    </tr>
                                </cfif>
                            
                            	<cfloop query="qGetHostChildren">

                                    <cfquery name="qGetSchool" datasource="#application.dsn#">
                                        SELECT 
                                            schoolname
                                        FROM	 
                                            smg_schools
                                        WHERE 
                                            schoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetHostChildren.school)#">
                                    </cfquery>
                        
                                    <tr <cfif qGetHostChildren.currentrow MOD 2>bgcolor="##ddeaf3"</cfif> >
                                        <td valign="top" width="50%">
                                        
                                            <table cellpadding="0" cellspacing="0" width="100%" style="line-height:20px;">
                                                <tr>
                                                    <td width="150"><span class="title">Name:</span></td>
                                                    <td width="200">
                                                        #qGetHostChildren.name# #qGetHostChildren.middleName# #qGetHostChildren.lastName#
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><span class="title">Gender:</span></td>
                                                    <td>#APPLICATION.CFC.UDF.ProperCase(qGetHostChildren.sex)#</td>
                                                </tr>
                                                <tr>
                                                    <td><span class="title">Date of Birth:</span></td>
                                                    <td>
                                                        <cfif IsDate(qGetHostChildren.birthdate)>
                                                            #DateFormat(qGetHostChildren.birthdate, 'mm/dd/yyyy')# - #DateDiff('yyyy', qGetHostChildren.birthdate, now())# years old                                  
                                                        </cfif>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><span class="title">Relation:</span></td>
                                                    <td>#APPLICATION.CFC.UDF.ProperCase(qGetHostChildren.membertype)#</td>
                                                </tr>
                                                <tr>
                                                    <td><span class="title">Living at Home:</span></td>
                                                    <td><cfif qGetHostChildren.liveathome is 'yes'>Yes<cfelseif qGetHostChildren.liveathome is 'no' and qGetHostChildren.liveathomePartTime is 'yes'>Part Time<cfelse>No</cfif></td>
                                                </tr>
                                                <tr>
                                                    <td><span class="title">Shared Room:</span></td>
                                                    <td>#APPLICATION.CFC.UDF.ProperCase(qGetHostChildren.shared)#</td>
                                                </tr>
                                                <tr>
                                                    <td><span class="title">Current Employer:</span></td>
                                                    <td>#APPLICATION.CFC.UDF.ProperCase(qGetHostChildren.employer)#</td>
                                                </tr>
                                            </table>
                                        
                                        </td>
                                        <td valign="top" width="50%">
                                        
                                            <table cellpadding="0" cellspacing="0" width="100%" style="line-height:20px;">
                                                <tr>
                                                    <td width="150"><span class="title">School Attending:</span></td>
                                                    <td width="200">#qGetSchool.schoolname#</td>
                                                </tr>
                                                <tr>
                                                    <td><span class="title">Grade in School:</span></td>
                                                    <td>
                                                        <cfswitch expression="#qGetHostChildren.gradeInSchool#">
                                                            <cfcase value="Not-Applicable">
                                                                Not Applicable
                                                            </cfcase>
                                                            <cfcase value="1">
                                                                1st
                                                            </cfcase>
                                                            <cfcase value="2">
                                                                2nd
                                                            </cfcase>
                                                            <cfcase value="3">
                                                                3rd
                                                            </cfcase>
                                                            <cfcase value="4,5,6,7,8,9,10,11,12">
                                                                #qGetHostChildren.gradeInSchool#th
                                                            </cfcase>
                                                            <cfdefaultcase>
                                                                #qGetHostChildren.gradeInSchool#
                                                            </cfdefaultcase>
                                                        </cfswitch>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="top" rowspan="3"><span class="title">Interests:</span></td>
                                                    <td>#qGetHostChildren.interests#</td>
                                                </tr>
                                            </table>
                                        
                                        </td>
                                    </tr>
            					
                            	</cfloop>                      
			            	
                            </table>
                        	                                                                                                    
                        </td>
					</tr>                                                
				</table>
                
            </td>
		</tr>
	</table>                    
                     
</cfoutput>