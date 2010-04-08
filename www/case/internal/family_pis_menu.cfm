		 <div id="subMenuNav"> 
		    <div id="subMenuLinks">  
			<cfoutput>
			<a class=nav_bar href="index.cfm?curdoc=forms/edit_host_fam_pis">Parents Info</A>  
			<a class=nav_bar href="index.cfm?curdoc=forms/host_fam_pis_2">Other Family Members</A>
			<a class=nav_bar href="index.cfm?curdoc=forms/host_fam_pis_3">Room, Smoking, Pets, Church</A>
			<a class=nav_bar href="index.cfm?curdoc=forms/host_fam_pis_4">Family Interests</a></A>
			<a class=nav_bar href="index.cfm?curdoc=forms/host_fam_pis_5">School Info</a> 
			<a class=nav_bar href="index.cfm?curdoc=forms/family_app_7_pis">Community Info</a> 
			<a class=nav_bar href="index.cfm?curdoc=forms/double_placement">Rep Info</a> 
			<!----<Cfquery name="check_host_status" datasource="caseusa">
			select studentid from smg_students where hostid = #client.hostid#
			</Cfquery>
			<cfif check_host_status.recordcount gt 0>
			<cfset client.studentid = #check_host_status.studentid#>
			<a class=nav_bar href="" onClick="javascript: win=window.open('forms/placement_check_off_list.cfm?studentid=#client.studentid#', 'Settings', 'height=480, width=450, location=yes, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Placement Check List</a>
			</cfif>---->
			</cfoutput>
			</div>
		</div>