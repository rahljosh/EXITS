<!--- ------------------------------------------------------------------------- ----
	
	File:		menu.cfm
	Author:		Marcus Melo
	Date:		April 19, 2012
	Desc:		Menu for new report section
				
				#CGI.SCRIPT_NAME#?curdoc=report/index?action=menu
				
	Updated: 				
				
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	
</cfsilent>

<cfoutput>

<!--- Table Header --->
<gui:tableHeader
	imageName="docs.gif"
	tableTitle="Reports - Menu"
/>

<table border="0" cellpadding="4" cellspacing="0" class="section" width="100%">
	<tr>
    	<td align="center">
        	<a href="#CGI.SCRIPT_NAME#?curdoc=report/index&action=studentManagementMenu" title="Click for Student Management Reports">
                <div class="reportButton">Student Management</div>
        	</a>
            
            <a href="#CGI.SCRIPT_NAME#?curdoc=report/index&action=hostFamilyManagementMenu" title="Click for Host Family Management Reports">
            	<div class="reportButton">Host Family Management</div>
            </a>
            
            <a href="#CGI.SCRIPT_NAME#?curdoc=report/index&action=representativeManagementMenu" title="Click for Representative Management Reports">
            	<div class="reportButton">Representative Management</div>
            </a>
        </td>
	</tr>        
</table>

<!--- Table Footer --->
<gui:tableFooter />

</cfoutput>