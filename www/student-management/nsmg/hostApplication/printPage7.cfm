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
                            <span class="title">Page 7</span>
                        </td>
                    </tr>
                </table>

                <table align="center" border="0" cellpadding="4" cellspacing="0" width="800"> 
                    <tr>           
                        <td colspan="2" align="center"><img src="../pics/hostAppBanners/HPpdf_22.jpg"/></td>
                	</tr>
                    <tr>
                        <td valign="top"><span class="title">Curfew on school nights:</span></td>
                    </tr>
                    <tr>
                        <td>#qGetHostInfo.houserules_curfewweeknights#</td>
                    </tr>
                    <tr>
                        <td valign="top"><span class="title">Curfew on weekends</span></td>
                    </tr>
                    <tr>
                        <td>#qGetHostInfo.houserules_curfewweekends#</td>
                    </tr>
                    <tr>
                        <td valign="top"><span class="title">Chores</span></td>
                    </tr>
                    <tr>
                        <td>#qGetHostInfo.houserules_chores#</td>
                    </tr>
                    <tr>
                        <td valign="top"><span class="title">Computer, Internet, and Email Usage</span></td>
                    </tr>
                    <tr>
                        <td>#qGetHostInfo.houserules_inet#</td>
                    </tr>
                    <tr>
                        <td valign="top">
                        	<span class="title">Expenses</span> <br />
                        	<span class="title" style="font-size:0.8em">personal expenses expected to be paid by the students</span>
                        </td>
                    </tr>
                    <tr>
                        <td>#qGetHostInfo.houserules_expenses#</td>
                    </tr>
                    <tr>
                        <td valign="top">
                        	<span class="title">Other</span> <br />
                        	<span class="title" style="font-size:0.8em">please include any other rules or expectations you will have of your exchange student</span>
                        </td>
                    </tr>
                    <tr>
                        <td>#qGetHostInfo.houserules_other#</td>
                    </tr>
				</table>
                
            </td>
		</tr>
	</table>                    
                     
</cfoutput>