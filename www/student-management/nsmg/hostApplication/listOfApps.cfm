<!--- ------------------------------------------------------------------------- ----
	
	File:		listOfApps.cfm
	Author:		Marcus Melo
	Date:		12/18/2012
	Desc:		List of Host Family Online Applications

	Updated:	
					
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
    
    <!--- Param URL Variables --->
    <cfparam name="URL.status" default="">
    <cfparam name="URL.approve" default="">
    <cfparam name="URL.hostID" default="0">
    <cfparam name="URL.seasonID" default="0">  
    <!--- Param FORM Variables --->  
    <cfparam name="FORM.setHostIDAsPaper" default="">

	<!--- INSERT UNIQUE ID | Delete This Later | Make sure unique ID is inserted when a new family is created --->
    <cfquery name="qGetHostsMissingUniqueID" datasource="#APPLICATION.DSN#">
        SELECT
            hostID
        FROM
            smg_hosts
        WHERE
            uniqueID = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
    </cfquery>
    
    <cfloop query="qGetHostsMissingUniqueID">
    
        <cfquery datasource="#APPLICATION.DSN#">
            UPDATE
                smg_hosts
            SET
                uniqueID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateUUID()#">,
                dateUpdated = <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
   				updatedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
            WHERE
                hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHostsMissingUniqueID.hostID#">
        </cfquery>
        
    </cfloop>
    <!--- INSERT UNIQUE ID | Delete This Later ---->
	
	<cfscript>
        // Set Application as Paper - Remove from the list
        if ( VAL(FORM.setHostIDAsPaper) AND APPLICATION.CFC.USER.isOfficeUser() ) {
        
            APPLICATION.CFC.HOST.setHostSeasonStatus(hostID=FORM.setHostIDAsPaper,applicationStatusID=0);
            
            // Set Page Message
            SESSION.pageMessages.Add("Record for host family ###FORM.setHostIDAsPaper# has sucessfully been converted to a paper application");
            
            // Go back to the list information
            location("#CGI.SCRIPT_NAME#?curdoc=hostApplication/listOfApps&status=#URL.status#", "no");
            
        }
		
		// Get List of Host Family Applications
		qGetHostApplications = APPLICATION.CFC.HOST.getApplicationListLimitedHostInfo(statusID=URL.status,seasonID=URL.seasonID);	
    </cfscript>
  
    <cfparam name="FORM.notHosting" default="0">
    <cfif VAL(FORM.notHosting)>
    	<cfquery datasource="#APPLICATION.DSN#">
            UPDATE smg_hosts
            SET isHosting = <cfqueryparam cfsqltype="cf_sql_integer" value="0">,
            	dateUpdated = <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
            	updatedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
            WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.notHosting#">
        </cfquery>
        <cflocation url="?#CGI.QUERY_STRING#"/>
    </cfif>
    
</cfsilent>    

<script type="text/javascript">
	$(document).ready(function(){
		$(".jQueryModal").colorbox( {
			width:"80%", 
			height:"95%", 
			iframe:true,
			overlayClose:false,
			escKey:false			
		});	
	});
	
	// JQuery Modal
	var setRecordToPaperApplication = function(recordID) { 
			
		// a workaround for a flaw in the demo system (http://dev.jqueryui.com/ticket/4375), ignore!
		$( "#dialog:ui-dialog" ).dialog( "destroy" );
	
		$( "#dialog-set-record-as-paper-confirm" ).dialog({
			resizable: false,
			height:200,
			width:400,
			modal: true,
			buttons: {
				"Convert To Paper Application": function() {
					$( this ).dialog( "close" );
					// Submit Form
					$("#frSetRecordToPaper" + recordID).submit();
				},
				Cancel: function() {
					$( this ).dialog( "close" );
				}
			}
		});
			
	}
</script>

<cfoutput>

	<!--- Set Record As Paper Application - Modal Dialog Box --->
    <div id="dialog-set-record-as-paper-confirm" title="EXITS - Host Family Application" class="displayNone" style="font-size:1em;"> 
        <p>
            <span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 0 0;"></span>
            Are you sure you would like to convert this online application to paper? <br />
        </p> 
        <p>Host Family will be removed from the online application list but it will still be available as a paper application.</p>
    </div> 

    <div class="rdholder"> 
    
        <div class="rdtop"> 
            <span class="rdtitle">Applications</span> 
        </div> <!-- end top --> 
        
        <div class="rdbox">

			<!--- Page Messages --->
            <gui:displayPageMessages 
                pageMessages="#SESSION.pageMessages.GetCollection()#"
                messageType="divOnly"
                width="90%"
                />
            
            <!--- Form Errors --->
            <gui:displayFormErrors 
                formErrors="#SESSION.formErrors.GetCollection()#"
                messageType="divOnly"
                width="90%"
                />
 
            <table width="98%" cellpadding="4" cellspacing="0" align="center">
                <tr>
                    <th align="left">Host Family</th>
                    <th align="left">City, State</th>
                    <th align="left">Email</th>
                    <th align="left">Region</th>
                    <th align="left">Area Representative</th>
                    <th align="left">Regional Advisor</th> 
                    <th align="left">Regional Manager</th>
                    <th>Actions</th>
            	</tr>
                
				<cfif NOT qGetHostApplications.recordcount>
                	<tr>
						<td colspan="6">There are no applications to display</td>
                    </tr>
                </cfif>
                
                <cfloop query="qGetHostApplications">
                    <tr <cfif qGetHostApplications.currentrow MOD 2>bgcolor="##efefef"</cfif>>
                        <td><a href="index.cfm?curdoc=hostApplication/toDoList&hostID=#qGetHostApplications.hostID#" title="View Details">#qGetHostApplications.displayHostFamily#</a></td>
                        <td>#qGetHostApplications.city#, #qGetHostApplications.state#</td>
                        <td>#qGetHostApplications.email#</td>
                        <td>#qGetHostApplications.regionName#</td>
                        <td>#qGetHostApplications.areaRepresentative#</td>
                        <td>#qGetHostApplications.regionalAdvisor#</td> 
                        <td>#qGetHostApplications.regionalManager#</td> 
                        <td width="350" align="center">
                        	<table width="100%">
                            	<tr>
                                	<td>
                                    	<a class="jQueryModal" href="/hostApplication/index.cfm?uniqueID=#qGetHostApplications.uniqueID#&userID=#CLIENT.userID#" title="Open Application">
                                        	<img src="pics/buttons/openApplication.png" border="0">
                                      	</a>
                                    </td>
                                    <td>
                                    	<a href="index.cfm?curdoc=hostApplication/toDoList&hostID=#qGetHostApplications.hostID#" title="View Details">
                                        	<img src="pics/buttons/approve.png" width="110" border="0">
                                      	</a>
                                    </td>
                                    <td>
                                    	<cfif CLIENT.userType LTE 4> 
                                            <a class="jQueryModal" href="hostApplication/viewPDF.cfm?hostID=#qGetHostApplications.hostID#&pdf&reportType=office&seasonID=#URL.seasonID#" title="Print Application">
                                                <img src="pics/buttons/printOffice.png">
                                            </a>
                                        </cfif>
                                    </td>
                                </tr>
                                <tr>
                                	<td></td>
                                    <td>
                                    	<form 
                                            action="index.cfm?curdoc=hostApplication/listOfApps&status=#URL.status#" 
                                            method="post" 
                                            style="display:inline;" 
                                            onsubmit="return confirm('Are you sure this family does not want to host this year?')"
                                            id="notHostingForm">
                                            <input type="hidden" name="notHosting" value="#qGetHostApplications.hostID#"/>
                                            <input type="image" src="pics/buttons/notHosting.png" width="110" border="0"/>
                                        </form>
                                    </td>
                                    <td>
                                    	<a class="jQueryModal" href="hostApplication/viewPDF.cfm?hostID=#qGetHostApplications.hostID#&pdf&reportType=agent&seasonID=#URL.seasonID#" title="Print Application">
                                            <img src="pics/buttons/printAgent.png">
                                        </a>
                                    </td>
                                </tr>
                            </table>
                        </td>
            		</tr>
            	</cfloop>
            </table>
            
        </div>
        
        <div class="rdbottom"></div> <!-- end bottom --> 
	
    </div>

</cfoutput>