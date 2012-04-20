<!--- ------------------------------------------------------------------------- ----
	
	File:		_hostFamilyManagementMenu.cfm
	Author:		Marcus Melo
	Date:		April 19, 2012
	Desc:		Host Family Management Report Options
				
				#CGI.SCRIPT_NAME#?curdoc=report/index?action=hostFamilyManagementMenu
				
	Updated: 				
				
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

    <cfscript>
		// Get Programs
		qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(dateActive=1);
	
		// Get User Regions
		qGetRegionList = APPLICATION.CFC.REGION.getUserRegions(
			companyID=CLIENT.companyID,
			userID=CLIENT.userID,
			userType=CLIENT.userType
		);
	</cfscript>
	
</cfsilent>

<cfoutput>

<!--- Table Header --->
<gui:tableHeader
	imageName="docs.gif"
	tableTitle="Reports - Host Family Management"
	tableRightTitle='<h2><a href="#CGI.SCRIPT_NAME#?curdoc=report/index" title="Click for Student Management Reports">[ Reports Menu ]</a></h2>'
/>

<table class="reportSection">
    <tr>
        <td>

            <!--- Row 1 - Welcome Family By Region --->
            <form action="report/index.cfm?action=welcomeFamilyByRegion" name="welcomeFamily" id="welcomeFamily" method="post" target="blank">
                
                <table width="48%" cellpadding="4" cellspacing="0" class="blueThemeReportTable left">
                    <tr><th colspan="2">Welcome Family By Region</th></tr>
                    <tr class="on">
                        <td class="subTitleRightNoBorder">Program: <span class="required">*</span></td>
                        <td>
                            <select name="programID" id="programID" class="xLargeField" multiple size="6" required>
                                <cfloop query="qGetProgramList"><option value="#qGetProgramList.programID#">#qGetProgramList.programName#</option></cfloop>
                            </select>
                        </td>
                    </tr>
                    <tr class="on">
                        <td class="subTitleRightNoBorder">Region: <span class="required">*</span></td>
                        <td>
                            <select name="regionID" id="regionID" class="xLargeField" multiple size="6" required>
                                <cfloop query="qGetRegionList"><option value="#qGetRegionList.regionID#">#qGetRegionList.regionname#</option></cfloop>
                            </select>
                        </td>		
                    </tr>
                    <tr class="on">
                        <td class="subTitleRightNoBorder">Output Type: <span class="required">*</span></td>
                        <td>
                            <select name="outputType" class="xLargeField">
                                <option value="onScreen">On Screen</option>
                                <option value="Excel">Excel Spreadsheet</option>
                            </select>
                        </td>		
                    </tr>
                    <tr class="on">
                        <td>&nbsp;</td>
                        <td class="required noteAlert">* Required Fields</td>
                    </tr>
                    <tr>
                        <th colspan="2"><input type="image" src="pics/view.gif" align="center" border="0"></th>
                    </tr>
                </table>
            </form>
			

		</td>
    </tr>
</table>    

<!--- Table Footer --->
<gui:tableFooter />

</cfoutput>