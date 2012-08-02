<cfoutput>
	<cfscript>
		if ( VAL(CLIENT.hostID) ) {
			vAdditionalURL = "&hostID=#CLIENT.hostID#";	
		} else {
			vAdditionalURL = "";
		}
	</cfscript>

    <div id="subMenuNav"> 
        <div id="subMenuLinks">  
            <a class=nav_bar href="index.cfm?curdoc=host_fam_info">Overview</a>
            <a class=nav_bar href="index.cfm?curdoc=forms/edit_host_fam_pis#vAdditionalURL#">Parents Info</a>  
            <a class=nav_bar href="index.cfm?curdoc=forms/host_fam_pis_2#vAdditionalURL#">Other Family Members</a>
            <a class=nav_bar href="index.cfm?curdoc=forms/host_fam_pis_3#vAdditionalURL#">Room, Smoking, Pets, Church</a>
            <a class=nav_bar href="index.cfm?curdoc=forms/host_fam_pis_4#vAdditionalURL#">Family Interests</a>
            <a class=nav_bar href="index.cfm?curdoc=forms/host_fam_pis_5#vAdditionalURL#">School Info</a> 
        </div>
    </div>
</cfoutput>