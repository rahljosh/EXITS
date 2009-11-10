<!--- a lot of the templates still use client.hostid and not url.hostid so need default or will get error. --->
<cfparam name="url.hostid" default="">

 <div id="subMenuNav"> 
    <div id="subMenuLinks">  
    <cfoutput>
    <a class="nav_bar" href="index.cfm?curdoc=forms/host_fam_form&hostid=#url.hostid#">Host Family Infomation</A>  
    <a class="nav_bar" href="index.cfm?curdoc=forms/host_fam_pis_2&hostid=#url.hostid#">Other Family Members</A>
    <a class="nav_bar" href="index.cfm?curdoc=forms/family_app_7_pis&hostid=#url.hostid#">Community Information</a> 
    <a class="nav_bar" href="index.cfm?curdoc=forms/host_fam_pis_5&hostid=#url.hostid#">School Information</a> 
    <a class="nav_bar" href="index.cfm?curdoc=cbc/hosts_cbc&hostid=#url.hostid#">Criminal Background Check</a> 
    <a class="nav_bar" href="index.cfm?curdoc=forms/host_fam_pis_3&hostid=#url.hostid#">Room, Smoking, Pets, Church</a>
    <a class="nav_bar" href="index.cfm?curdoc=forms/host_fam_pis_4&hostid=#url.hostid#">Family Interests</a>
    <a class="nav_bar" href="index.cfm?curdoc=forms/double_placement&hostid=#url.hostid#">Rep Info</a> 
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