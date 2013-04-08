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
                            <span class="title">Page 6</span>
                        </td>
                    </tr>
                </table>
                
                <table align="center" border="0" cellpadding="4" cellspacing="0" width="800"> 
                    <tr>           
                        <td colspan="2" align="center"><img src="../pics/hostAppBanners/HPpdf_religiouspreference.jpg"/></td>
                	</tr>
                    <tr>
                        <td width="70%"><span class="title">What is your religious affiliation?</span></td>
                        <td><cfif qGetReligionList.recordCount>#qGetReligionList.religionName#<cfelse>n/a</cfif></td>
                    </tr>
                    <tr>
                        <td><span class="title">Would you provide transportation to the student's churchTrans services if they are different from your own?</span></td>
                        <td><cfif LEN(qGetHostInfo.churchTrans)>#YesNoFormat(VAL(qGetHostInfo.churchTrans))#<cfelse>n/a</cfif></td>
                    </tr>
                    <tr>
                        <td width="70%"><span class="title">Are you willing to voluntarily inform your exchange student of your religious affiliation?</span></td>
                        <td><cfif LEN(qGetHostInfo.informReligiousPref)>#YesNoFormat(VAL(qGetHostInfo.informReligiousPref))#<cfelse>n/a</cfif></td>
                    </tr>
                    <tr>
                        <td width="70%"><span class="title">Does any member of your household have difficulty hosting a student with different religious beliefs?</span></td>
                        <td><cfif LEN(qGetHostInfo.hostingDiff)>#YesNoFormat(VAL(qGetHostInfo.hostingDiff))#<cfelse>n/a</cfif></td>
                    </tr>
				</table>
                
                <table align="center" border="0" cellpadding="4" cellspacing="0" width="800"> 
                    <tr>           
                        <td colspan="2" align="center"><img src="../pics/hostAppBanners/HPpdf_religiousattendance.jpg"/></td>
                	</tr>
                    <tr>
                        <td width="70%"><span class="title">How often do you go to your religious place of worship?</span></td>
                        <td>
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
                        <td width="70%"><span class="title">Would you expect your exchange student to attend services with your family?</span></td>
                        <td><cfif LEN(qGetHostInfo.churchFam)>#YesNoFormat(VAL(qGetHostInfo.churchFam))#<cfelse>n/a</cfif></td>
                    </tr>
				</table>
                                
            </td>
		</tr>
	</table>                    
                     
</cfoutput>