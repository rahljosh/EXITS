<!--- ------------------------------------------------------------------------- ----
	
	File:		_representativeManagementMenu.cfm
	Author:		Marcus Melo
	Date:		April 19, 2012
	Desc:		Representative Management Report Options
				
				#CGI.SCRIPT_NAME#?curdoc=report/index?action=representativeManagementMenu
				
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
	tableTitle="Reports - Representative Management"
	tableRightTitle='<a href="#CGI.SCRIPT_NAME#?curdoc=report/index" title="Click for Student Management Reports">[ Reports Menu ]</a>'
/>

<table class="reportSection">
    <tr>
        <td>
			

		</td>
    </tr>
</table>    

<!--- Table Footer --->
<gui:tableFooter />

</cfoutput>