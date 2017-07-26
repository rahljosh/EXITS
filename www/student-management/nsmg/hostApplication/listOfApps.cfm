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
    
    	<!--- Ajax Call to the Component --->
    <cfajaxproxy cfc="nsmg.extensions.components.host" jsclassname="hostFamily">
    <!--- Param URL Variables --->
    <cfparam name="URL.status" default="">
    <cfparam name="URL.approve" default="">
    <cfif client.usertype lte 4>
     	<cfparam name="URL.regionID" default="">
    <cfelse>
    	 <cfparam name="URL.regionID" default="#CLIENT.regionID#">
    </cfif>
	
 	 <cfscript>
 	 	vCurrentSeason = APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason().seasonID;
 	 </cfscript>
  	 
  
    <cfparam name="URL.hostID" default="0">
    <cfparam name="URL.seasonID" default="#vCurrentSeason#"> 
    <cfparam name="URL.active_rep" default="2">  
    <cfparam name="URL.currently_hosting" default="0">  
    <cfparam name="URL.ny_office" default="2">   
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
            location("#CGI.SCRIPT_NAME#?curdoc=hostApplication/listOfApps&regionid=#URL.regionID#&status=#URL.status#", "no");
            
        }
		
		// Get List of Host Family Applications
		qGetHostApplications = APPLICATION.CFC.HOST.getApplicationListLimitedHostInfo(statusID=URL.status,seasonID=URL.seasonID,active_rep=URL.active_rep,ny_office=URL.ny_office,regionID=URL.regionID,currently_hosting=URL.currently_hosting);	
   
      // Get User Regions
        qGetRegionList = APPLICATION.CFC.REGION.getUserRegions(
            companyID=CLIENT.companyID,
            userID=CLIENT.userID,
            userType=CLIENT.userType
        );

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
			overlayClose:true,
			escKey:true,
			closeButton:true,		
			onClosed:function(){ window.location.reload(); }
		});	
	});
		
</script>
<cfoutput>

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
<!--- Search Options --->

<!-- Checkout-Form -->
<div class="sky-form">
	<div class="row">
		<section class="col col-2">
			<h1>Status</h1>
			<label class="select ">
			<select name="statusID" id="statusID" onChange="top.location.href=this.options[this.selectedIndex].value;">

				<option value="?curdoc=hostApplication/listOfApps&regionid=#URL.regionID#&status=9&seasonID=#url.seasonid#&active_rep=#url.active_rep#&ny_office=#URL.ny_office#&currently_hosting=#URL.currently_hosting#" <cfif val(URL.status) eq 9>selected="selected"</cfif>  >Applications with HF: Not Started</option>
				<option value="?curdoc=hostApplication/listOfApps&regionid=#URL.regionID#&status=8&seasonID=#url.seasonid#&active_rep=#url.active_rep#&ny_office=#URL.ny_office#&currently_hosting=#URL.currently_hosting#" <cfif val(URL.status) eq 8>selected="selected"</cfif> >Applications with HF: In Process</option>
				<option value="?curdoc=hostApplication/listOfApps&regionid=#URL.regionID#&status=7&seasonID=#url.seasonid#&active_rep=#url.active_rep#&ny_office=#URL.ny_office#&currently_hosting=#URL.currently_hosting#"  <cfif val(URL.status) eq 7>selected="selected"</cfif> >Applications with Field: Area Rep.</option>
				<option value="?curdoc=hostApplication/listOfApps&regionid=#URL.regionID#&status=6&seasonID=#url.seasonid#&active_rep=#url.active_rep#&ny_office=#URL.ny_office#&currently_hosting=#URL.currently_hosting#"<cfif val(URL.status) eq 6>selected="selected"</cfif> >Applications with Field: Advisor</option>
				<option value="?curdoc=hostApplication/listOfApps&regionid=#URL.regionID#&status=5&seasonID=#url.seasonid#&active_rep=#url.active_rep#&ny_office=#URL.ny_office#&currently_hosting=#URL.currently_hosting#"  <cfif val(URL.status) eq 5>selected="selected"</cfif> >Applications with Field: Manager</option>
				<option value="?curdoc=hostApplication/listOfApps&regionid=#URL.regionID#&status=4&seasonID=#url.seasonid#&active_rep=#url.active_rep#&ny_office=#URL.ny_office#&currently_hosting=#URL.currently_hosting#"  <cfif val(URL.status) eq 4>selected="selected"</cfif> >Applications with #CLIENT.companyshort#: HQ</option>
				<option value="?curdoc=hostApplication/listOfApps&regionid=#URL.regionID#&status=3&seasonID=#url.seasonid#&active_rep=#url.active_rep#&ny_office=#URL.ny_office#&currently_hosting=#URL.currently_hosting#"  <cfif val(URL.status) eq 3>selected="selected"</cfif> >Applications with #CLIENT.companyshort#: Approved</option>
			</select>
		</label>
		</section>
	<section class="col col-2">
		<h1>Region</h1>
		<label class="select ">
		<select name="regionID" id="active_rep"  onChange="top.location.href=this.options[this.selectedIndex].value;">
			<cfif client.usertype LTE 4>
			<option value="?curdoc=hostApplication/listOfApps&status=#URL.status#&seasonID=#url.seasonid#&active_rep=2&ny_office=#URL.ny_office#&currently_hosting=#URL.currently_hosting#" <cfif regionID EQ URL.regionID>selected="selected"</cfif>>All</otpion>
			</cfif>
			<cfloop query="qGetRegionList">
				<option value="?curdoc=hostApplication/listOfApps&regionid=#qGetRegionList.regionID#&status=#URL.status#&seasonID=#url.seasonid#&active_rep=2&ny_office=#URL.ny_office#&currently_hosting=#URL.currently_hosting#" <cfif regionID EQ URL.regionID>selected="selected"</cfif>>#qGetRegionList.regionname#</option>
			</cfloop>
			</select>  

		</label>
		</section>
		<section class="col col-2">
		<h1>With Active Rep</h1>
		<label class="select ">
			<select name="active_rep" id="active_rep"  onChange="top.location.href=this.options[this.selectedIndex].value;">
				<option value="?curdoc=hostApplication/listOfApps&regionid=#URL.regionID#&status=#URL.status#&seasonID=#url.seasonid#&active_rep=2&ny_office=#URL.ny_office#&currently_hosting=#URL.currently_hosting#" <cfif URL.active_rep EQ 2>selected</cfif>>All</option>
				<option value="?curdoc=hostApplication/listOfApps&regionid=#URL.regionID#&status=#URL.status#&seasonID=#url.seasonid#&active_rep=1&ny_office=#URL.ny_office#&currently_hosting=#URL.currently_hosting#" <cfif URL.active_rep EQ 1>selected</cfif>>Yes</option>
				<option value="?curdoc=hostApplication/listOfApps&regionid=#URL.regionID#&status=#URL.status#&seasonID=#url.seasonid#&active_rep=0&ny_office=#URL.ny_office#&currently_hosting=#URL.currently_hosting#" <cfif URL.active_rep EQ 0>selected</cfif>>No</option>
			</select>  

		</label>
		</section>
		<cfif URL.status eq 3>
			<section class="col col-2">
			<h1>Currently Hosting</h1>
			<label class="select ">
				<select name="currently_hosting" id="active_rep"  onChange="top.location.href=this.options[this.selectedIndex].value;">
					<option value="?curdoc=hostApplication/listOfApps&regionid=#URL.regionID#&status=#URL.status#&seasonID=#url.seasonid#&active_rep=#url.active_rep#&ny_office=#URL.ny_office#&currently_hosting=0" <cfif URL.currently_hosting EQ 0>selected</cfif>>All</option>
					<option value="?curdoc=hostApplication/listOfApps&regionid=#URL.regionID#&status=#URL.status#&seasonID=#url.seasonid#&active_rep=#url.active_rep#&ny_office=#URL.ny_office#&currently_hosting=1" <cfif URL.currently_hosting EQ 1>selected</cfif>>Yes</option>
					<option value="?curdoc=hostApplication/listOfApps&regionid=#URL.regionID#&status=#URL.status#&seasonID=#url.seasonid#&active_rep=#url.active_rep#&ny_office=#URL.ny_office#&currently_hosting=2" <cfif URL.currently_hosting EQ 2>selected</cfif>>No</option>
					<option value="?curdoc=hostApplication/listOfApps&regionid=#URL.regionID#&status=#URL.status#&seasonID=#url.seasonid#&active_rep=#url.active_rep#&ny_office=#URL.ny_office#&currently_hosting=3" <cfif URL.currently_hosting EQ 3>selected</cfif>>Used for Relocation</option>
				</select>  

			</label>
			</section>
		</cfif>
		<section class="col col-2">
		<h1>NY Office Rep</h1>
			<label class="select ">
			<select name="ny_office" id="ny_office"  onChange="top.location.href=this.options[this.selectedIndex].value;">
				<option value="?curdoc=hostApplication/listOfApps&regionid=#URL.regionID#&status=#URL.status#&seasonID=#url.seasonid#&active_rep=#url.active_rep#&ny_office=0&currently_hosting=#URL.currently_hosting#" <cfif URL.ny_office EQ 2>selected</cfif>>All</option>
				<option value="?curdoc=hostApplication/listOfApps&regionid=#URL.regionID#&status=#URL.status#&seasonID=#url.seasonid#&active_rep=#url.active_rep#&ny_office=1&currently_hosting=#URL.currently_hosting#" <cfif URL.ny_office EQ 1>selected</cfif>>Yes</option>
				<option value="?curdoc=hostApplication/listOfApps&regionid=#URL.regionID#&status=#URL.status#&seasonID=#url.seasonid#&active_rep=#url.active_rep#&ny_office=2&currently_hosting=#URL.currently_hosting#" <cfif URL.ny_office EQ 0>selected</cfif>>No</option>
			</select>    
			</label>
		</section>

		<section class="counters col col-2">
			<span class="counter">#qGetHostApplications.recordcount#</span>
			<h3>Applications</h>
		</section>
	</div>
</div>
						
<table  class="table table-striped table-hover">
	<thead>
		<tr>
		<th align="left">Since</th>
		
		<th align="left">Host Family</th>
		<cfif url.status eq 8>
		<th align="left">App Updated</th>
		</cfif>
		<th align="left"></Th>
		<th align="left">City, State</th>
		<th align="left">Contact</th>
		<th align="left">Region</th>
		<th align="left">Area Representative</th>
		<th align="left">Regional Advisor</th> 
		<th align="left">Regional Manager</th>
		<th></th>
		</tr>

	</thead>
	

	<Cfset displayCount = 0>
	<cfloop query="qGetHostApplications">

		<cfif ((url.status eq 9) AND DateDiff('d',appUpdated, now()) gt 3)>
		  <tr class="danger">
		 <cfelseif ((url.status eq 8) AND DateDiff('d',appUpdated, now()) gt 7)>
		  <tr class="danger">
		 <cfelseif ((url.status eq 7) AND DateDiff('d',appUpdated, now()) gt 3)>
		  <tr class="danger">
		 <cfelseif ((url.status eq 6) AND DateDiff('d',appUpdated, now()) gt 1)>
		  <tr class="danger">
		 <cfelseif ((url.status eq 5) AND DateDiff('d',appUpdated, now()) gt 1)>
		  <tr class="danger">
		 <cfelse>
		  <tr>
		</cfif> 


			<td>#DateFormat(appUpdated, 'mmm d, yyyy')#</td>
			
			 <td><a href="index.cfm?curdoc=host_fam_info&hostID=#qGetHostApplications.hostID#" title="View Details">#qGetHostApplications.displayHostFamily#</a>
			<cfif url.status eq 8>
			<td align="left">#DateFormat(dateUpdated, 'mmm d, yyyy')#</td>
			</cfif>
			  <cfif val(qGetHostApplications.totalNumberCurrentStudents)><br>
			<mark> <em>Hosting #qGetHostApplications.totalNumberCurrentStudents# student<cfif val(qGetHostApplications.totalNumberCurrentStudents) gt 1>s</cfif></em></mark>
			 </cfif>
			 </td>
			<td>
				<a href="hostApplication/app-notes.cfm?hostAppID=#qGetHostApplications.hostAppSeasonID#" class="jQueryModal" title="Open Application">
				<cfif qGetHostApplications.appNotes is ''>
					<button type="button" class="btn btn-default btn-sm"><i class="fa fa-comments-o" aria-hidden="true"></i> Add Notes</button>
				<cfelse>
					<button type="button" class="btn btn-warning btn-sm"><i class="fa fa-comments-o" aria-hidden="true"></i> 
						<cfif isDate(qGetHostApplications.noteDate)>
							#DATEFORMAT(qGetHostApplications.noteDate, 'm/dd/yy')#
						<cfelse>
							See Notes
						</cfif>
						</button>
				</cfif>
				
				</a>
			</td> 
			<td>#qGetHostApplications.hostCity#, #qGetHostApplications.hostState#</td>
			<td>#qGetHostApplications.hostEmail#<br>#qGetHostApplications.host_phone#</td>
			<td>#qGetHostApplications.regionName#</td>
			<td>#qGetHostApplications.areaRepresentative#</td>
			<td>#qGetHostApplications.regionalAdvisor#</td> 
			<td>#qGetHostApplications.regionalManager#</td> 
			<td width="350" align="center">


			<a href="/hostApplication/index.cfm?uniqueID=#qGetHostApplications.uniqueID#&season=#URL.seasonID#&userID=#CLIENT.userID#" class="jQueryModal" title="Open Application">
				<button type="button" class="btn btn-primary btn-sm"><i class="fa fa-folder-open-o" aria-hidden="true"></i> Open</button>
			</a>

			<cfif url.status lte 8>
				<a href="index.cfm?curdoc=hostApplication/toDoList&hostID=#qGetHostApplications.hostID#" title="View Details">
					<button type="button" class="btn btn-success btn-sm"><i class="fa fa-thumbs-o-up" aria-hidden="true"></i> Review</button>
				</a>
			</cfif>
			<!----
			<cfif CLIENT.userType LTE 4 and url.status lte 3> 
		 		<a href="hostApplication/viewPDF.cfm?hostID=#qGetHostApplications.hostID#&pdf&reportType=office&seasonID=#URL.seasonID#" class="jQueryModal">
					<button type="button" class="btn btn-warning btn-sm"><i class="fa fa-print" aria-hidden="true"></i> Confidential </button>
				</a>
				<a href="hostApplication/viewPDF.cfm?hostID=#qGetHostApplications.hostID#&pdf&reportType=agent&seasonID=#URL.seasonID#" class="jQueryModal">
					<button type="button" class="btn btn-warning btn-sm"><i class="fa fa-print" aria-hidden="true"></i> Agent</button>
				</a>
			 	
			</cfif>
			---->
			<cfif url.status gt 2> 
				<a href="hostApplication/host-status-change.cfm?hostID=#qGetHostApplications.hostID#&pdf&reportType=agent&seasonID=#URL.seasonID#" class="jQueryModal">
						<button type="button" class="btn btn-danger btn-sm"><i class="fa fa-thumbs-o-down" aria-hidden="true"></i> Not Hosting</button>
				</a>
			</cfif>



			   </div>

			</td>
		</tr>
	
	</cfloop>
		<cfif (qGetHostApplications.recordcount eq 0)>
		<tr>
			<td colspan="8">There are no applications to display</td>
		</tr>
	</cfif>
</table>
            
     

</cfoutput>