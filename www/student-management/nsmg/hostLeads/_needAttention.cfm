<!--- ------------------------------------------------------------------------- ----
	
	File:		_needAttention.cfm
	Author:		Marcus Melo
	Date:		December 11, 2009
	Desc:		ISEUSA.com Host Family Leads - Pop Up Warning

	Updated:																		
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

	<cfscript>
		// Get Leads that need attention
		qGetHostLeads = APPLICATION.CFC.HOST.getPendingHostLeads(
			userType=CLIENT.userType,
			areaRepID=CLIENT.userID, 
			regionID=CLIENT.regionID,
			lastLogin=CLIENT.lastlogin
		);
		
		// PopUp should be displayed only once
		CLIENT.displayHostLeadPopUp = 0;
	</cfscript>
    
</cfsilent>

<cfoutput>

	<!--- Page Header --->
    <gui:pageHeader
        headerType="applicationNoHeader"
    />	

		<script language="javascript">
            // Displays the Host Lead List
			var viewHostLeads = function() {
				// Redirect Parent
                parent.location.href = '../index.cfm?curdoc=hostLeads/index';
                // Close Window 
                parent.$.fn.colorbox.close();
            }
        </script>

        <!--- Table Header --->
        <gui:tableHeader
            imageName="current_items.gif"
            tableTitle="Host Family Leads Needing Your Attention"
            width="95%"
            imagePath="../"
        />    

            <table width="95%" border="0" cellpadding="4" cellspacing="0" class="section" align="center">
                <tr class="defaultTableStyle">
                    <td>Name</td>
                    <td>Address</td>                    
                    <td>Status</td>
                    <td>Last Updated</td>
                    <td>Actions</td>
                </tr>                                
                <cfloop query="qGetHostLeads">
                    <tr bgcolor="###iif(qGetHostLeads.currentrow MOD 2 ,DE("FFFFE6") ,DE("FFFFFF") )#">
                        <td>#qGetHostLeads.firstName# #qGetHostLeads.lastName#</td>
                        <td>#qGetHostLeads.city#, #qGetHostLeads.stateName# #qGetHostLeads.zipCode#</td>
                        <td>#qGetHostLeads.statusAssigned#</td>
                        <td>#DateFormat(qGetHostLeads.dateUpdated, 'mm/dd/yyyy')# #TimeFormat(qGetHostLeads.dateUpdated, 'hh:mm:tt')# EST</td>
                        <td>
                        	<cfif dateUpdated GT CLIENT.lastLogin>
                            	Recently Assigned
                            <cfelse>    
	                            Needs Disposition
                            </cfif>
                        </td>
                    </tr>                   
                </cfloop>
            </table>

			<table width="95%" border="0" cellpadding="4" cellspacing="0" class="section" align="center">
                <tr>
                	<td colspan="5" align="center">
                    	<a href="javascript:viewHostLeads();"><img src="../pics/viewHostLeads.gif" border="0" /></a>
                    </td>
				</tr>
			</table>                                    
            
        <!--- Table Footer --->
        <gui:tableFooter 
  	        width="95%"
			imagePath="../"
        />
	
	<!--- Page Footer --->
    <gui:pageFooter
        footerType="application"
    />

</cfoutput>


