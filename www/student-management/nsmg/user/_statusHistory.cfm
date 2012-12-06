<!--- ------------------------------------------------------------------------- ----
	
	File:		_statusHistory.cfm
	Author:		Marcus Melo
	Date:		December 6, 2012
	Desc:		User Status History - Displays when user accounts were set as active
				inactive.

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
    
	<cfscript>
		// Get User Info
		qGetUser = APPLICATION.CFC.USER.getUserByID(userID=VAL(URL.userID));
	
		// Get Status History
		qGetStatusHistory = APPLICATION.CFC.LOOKUPTABLES.getApplicationHistory(
			applicationID=APPLICATION.CONSTANTS.TYPE.EXITS,																				   
			foreignTable="smg_users",
			foreignID=VAL(URL.userID)
		);
	</cfscript>

</cfsilent>  

<cfoutput>

	<!--- Page Header --->
    <gui:pageHeader
        headerType="applicationNoHeader"
    />	
    
        <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
            <tr>
                <th>
                	<cfif LEN(qGetUser.businessName)>
	                	#qGetUser.businessName# - 
                    </cfif>
                    #qGetUser.firstName# #qGetUser.lastName# (###qGetUser.userID#)  - Status History</th>            
            </tr>
        </table>
    
        <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
            <tr>
                <th class="left">Date</th>	
                <th class="left">Action</th>
                <th class="left">Updated By</th>
            </tr>
        
            <cfloop query="qGetStatusHistory" >
                <tr class="#iif(qGetStatusHistory.currentRow MOD 2 ,DE("off") ,DE("on") )#">
                    <td>#DateFormat(qGetStatusHistory.dateCreated, 'mm/dd/yyyy')#</td>
                    <td>#qGetStatusHistory.actions#</td>  
                    <td>#qGetStatusHistory.enteredBy#</td>                          
                </tr>
            </cfloop>   			             
            
            <cfif NOT qGetStatusHistory.recordCount>
                <tr class="off">
                    <td colspan="3" class="center">History not available</td>
                </tr>
            </cfif>
        </table>

	<!--- Page Footer --->
    <gui:pageFooter
        footerType="noFooter"
    />

</cfoutput>