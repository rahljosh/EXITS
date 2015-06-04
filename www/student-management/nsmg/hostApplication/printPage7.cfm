<!--- ------------------------------------------------------------------------- ----
	
	File:		printPage7.cfm
	Author:		Marcus Melo
	Date:		03/23/2013
	Desc:		Family Rules - Page 7 Print Version

	Updated:	
	
	Test URL:	
	http://smg.local/nsmg/hostApplication/printApplication.cfm?action=printPage7&hostID=37739
					
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Parameter for the folder locations of images --->
    <cfparam name="relative" default="../">

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
                            <span class="title">Section <cfif URL.reportType EQ "office">7<cfelse>6</cfif></span>
                        </td>
                    </tr>
                </table>

                <table align="center" border="0" cellpadding="4" cellspacing="0" width="800"> 
                    <tr>           
                        <td colspan="2" align="center"><div class="heading">FAMILY RULES</div></td>
                	</tr>
                    <tr>
                        <td valign="top"><span class="title">Curfew on school nights:</span></td>
                        <td class="answer">#qGetHostInfo.houserules_curfewweeknights#</td>
                    </tr>
                    <tr>
                        <td valign="top"><span class="title">Curfew on weekends:</span></td>
                        <td class="answer">#qGetHostInfo.houserules_curfewweekends#</td>
                    </tr>
                    <tr>
                        <td valign="top"><span class="title">Chores:</span></td>
                        <td class="answer">#qGetHostInfo.houserules_chores#</td>
                    </tr>
                    <tr>
                        <td valign="top"><span class="title">Computer, Internet, and Email Usage:</span></td>
                        <td class="answer">#qGetHostInfo.houserules_inet#</td>
                    </tr>
                    <tr>
                        <td valign="top">
                        	<span class="title">Expenses:</span> <br />
                        	<span class="title" style="font-size:0.8em">(personal expenses expected to be paid by the students)</span>
                        </td>
                        <td class="answer">#qGetHostInfo.houserules_expenses#</td>
                    </tr>
                    <tr>
                        <td valign="top">
                        	<span class="title">Other:</span> <br />
                        	<span class="title" style="font-size:0.8em">(please include any other rules or expectations you will have of your exchange student)</span>
                        </td>
                        <td class="answer">#qGetHostInfo.houserules_other#</td>
                    </tr>
				</table>
                
            </td>
		</tr>
	</table>                    
                     
</cfoutput>