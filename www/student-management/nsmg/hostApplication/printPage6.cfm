<!--- ------------------------------------------------------------------------- ----
	
	File:		printPage6.cfm
	Author:		Marcus Melo
	Date:		03/17/2013
	Desc:		Religious Preference - Page 6 Print Version

	Updated:	
	
	Test URL:	
	http://smg.local/nsmg/hostApplication/printApplication.cfm?action=printPage6&hostID=37739
					
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Parameter for the folder locations of images --->
    <cfparam name="relative" default="../">

	<!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

    <cfquery name="qGetReligionList" datasource="#APPLICATION.DSN#">
		SELECT
        	religionID,
            religionName
    	FROM
        	smg_religions
        WHERE
        	religionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetHostInfo.religion)#">
    </cfquery> 

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
                            <span class="title">Section <cfif URL.reportType EQ "office">6<cfelse>5</cfif></span>
                        </td>
                    </tr>
                </table>
                
                <table align="center" border="0" cellpadding="4" cellspacing="0" width="100%"> 
                    <tr>           
                        <td colspan="2" align="center"><div class="heading">RELIGIOUS PREFERENCE</div></td>
                	</tr>
                    <cfif VAL(qGetHostInfo.informReligiousPref) OR URL.reportType EQ "office">
                        <tr>
                            <td><span>Are you willing to voluntarily inform your exchange student of your religious affiliation?</span></td>
                            <td class="answer"><cfif LEN(qGetHostInfo.informReligiousPref)>#YesNoFormat(VAL(qGetHostInfo.informReligiousPref))#<cfelse>n/a</cfif></td>
                        </tr>
                        <tr>
                            <td><span>What is your religious affiliation?</span></td>
                            <td class="answer"><cfif qGetReligionList.recordCount>#qGetReligionList.religionName#<cfelse>n/a</cfif></td>
                        </tr>
                  	</cfif>
                    <tr>
                        <td><span>Would you provide transportation to the student's church services if they are different from your own?</span></td>
                        <td class="answer"><cfif LEN(qGetHostInfo.churchTrans)><cfif qGetHostInfo.churchTrans EQ "yes">Yes<cfelse>No</cfif><cfelse>n/a</cfif></td>
                    </tr>
                    <tr>
                        <td><span>Does any member of your household have difficulty hosting a student with different religious beliefs?</span></td>
                        <td class="answer"><cfif LEN(qGetHostInfo.hostingDiff)>#YesNoFormat(VAL(qGetHostInfo.hostingDiff))#<cfelse>n/a</cfif></td>
                    </tr>
				</table>
                
                <table align="center" border="0" cellpadding="4" cellspacing="0" width="800"> 
                    <tr>           
                        <td colspan="2" align="center"><div class="heading">RELIGIOUS ATTENDANCE</div></td>
                	</tr>
                    <tr>
                        <td><span>How often do you go to your religious place of worship?</span></td>
                        <td class="answer">
                        	<cfswitch expression="#qGetHostInfo.religious_participation#">
                            
                            	<cfcase value="Active">
									Active (2+ times a week)
                                </cfcase>
                                
                            	<cfcase value="Average">
									Average (1-2x a week)
                                </cfcase>

                            	<cfcase value="Little Interest">
									Little Interest (occasionally)
                                </cfcase>

                            	<cfcase value="Inactive">
									Inactive (Never attend)
                                </cfcase>

                            	<cfcase value="No Interest">
									Holidays
                                </cfcase>

                        	</cfswitch>
                        </td>
                    </tr>
                    <tr>
                        <td><span>Would you expect your exchange student to attend services with your family?</span></td>
                        <td class="answer"><cfif LEN(qGetHostInfo.churchFam)><cfif qGetHostInfo.churchFam EQ "yes">Yes<cfelse>No</cfif><cfelse>n/a</cfif></td>
                    </tr>
				</table>
                                
            </td>
		</tr>
	</table>                    
                     
</cfoutput>