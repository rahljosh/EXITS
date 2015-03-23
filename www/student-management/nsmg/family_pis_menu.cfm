<cfparam name="URL.hostID" default="0">
<cfparam name="CLIENT.hostID" default="0">
<cfparam name="currentHostID" default="0">

<cfscript>
	// a lot of the templates still use client.hostid and not url.hostid so we need to check which one is valid
	if ( VAL(CLIENT.hostID) ) {
		currentHostID = CLIENT.hostID;			
	} else if ( VAL(URL.hostID) ) {
		currentHostID = URL.hostID;			
	}
</cfscript>

 <div id="subMenuNav"> 
    <div id="subMenuLinks">  
    <cfoutput>
    <a class="nav_bar" href="index.cfm?curdoc=forms/host_fam_form&hostid=#currentHostID#">Host Family Information</A>  
    <a class="nav_bar" href="index.cfm?curdoc=forms/host_fam_mem_form&hostid=#currentHostID#">Other Family Members</A>
    <a class="nav_bar" href="index.cfm?curdoc=forms/host_fam_pis_7&hostid=#currentHostID#">Community Information</a> 
    <a class="nav_bar" href="index.cfm?curdoc=forms/host_fam_pis_5&hostid=#currentHostID#">School Information</a> 
    <cfif CLIENT.userType LTE 4>
	    <a class="nav_bar" href="index.cfm?curdoc=cbc/hosts_cbc&hostid=#currentHostID#">Criminal Background Check</a> 
    </cfif>
    <a class="nav_bar" href="index.cfm?curdoc=forms/host_fam_pis_3&hostid=#currentHostID#">Room, Smoking, Pets, Church</a>
    <a class="nav_bar" href="index.cfm?curdoc=forms/host_fam_pis_4&hostid=#currentHostID#">Family Interests</a>
    <a class="nav_bar" href="index.cfm?curdoc=forms/double_placement&hostid=#currentHostID#">Rep Info</a> 
    <!----<Cfquery name="check_host_status" datasource="MySQL">
    select studentid from smg_students where hostid = #client.hostid#
    </Cfquery>
    <cfif check_host_status.recordcount gt 0>
    <cfset client.studentid = #check_host_status.studentid#>
    <a class=nav_bar href="" onClick="javascript: win=window.open('forms/placement_check_off_list.cfm?studentid=#client.studentid#', 'Settings', 'height=480, width=450, location=yes, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Placement Check List</a>
    </cfif>---->
    </cfoutput>
    </div>
</div>