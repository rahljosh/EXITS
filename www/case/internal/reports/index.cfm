<SCRIPT LANGUAGE="JavaScript"> 
<!-- Begin
function formHandler(form){
var URL = document.form.sele_region.options[document.form.sele_region.selectedIndex].value;
window.location.href = URL;
}
// End -->
</SCRIPT>


<style type="text/css">
<!--
.style1 {font-size: 15px}
-->

.get_Attention{
	color: #8B0000;
}

</style>

<cfquery name="user_compliance" datasource="caseusa">
	SELECT userid, compliance
	FROM smg_users
	WHERE userid = <cfqueryparam value="#client.userid#" cfsqltype="cf_sql_integer">
</cfquery>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>Reports</h2></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table border=0 cellpadding=8 cellspacing=2 width=100% class="section">
<tr><td colspan="2">All reports that can be run are listed below.  These reports are also linked to various other 
	locations throughout the site.  If no reports are listed, there are no stand alone reports that you have access to.</td>
</tr>
<!--- OFFICE PEOPLE ONLY --->	
<cfif client.usertype LTE '4'>
<tr bgcolor="e2efc7"><td colspan="2"><span class="get_attention"><b>::</b></span> Reports Available for Office Users</td></tr>
	<tr>
		<td width="50%"><a href="?curdoc=reports/acceptance_select_pro">Acceptance Letter and Missing Documents Report</a></td>
		<td><a href="?curdoc=reports/excel_generator_menu">Reports in Excel Format</a></td>	</tr>
	<tr>
		<td width="50%"><a href="?curdoc=sevis/reports_menu">Batch System Reports</a></td>
		<td><a href="?curdoc=reports/intl_reports_menu">Reports for International Reps</a></td>	
	</tr>
	<tr>
		<td><a href="?curdoc=insurance/insurance_reports_menu">Caremed - Insurance Reports</a></td>
		<td><a href="?curdoc=reports/graphics_menu">Statistical Graphics</a></td>
	</tr>
	<tr>
		<td><a href="?curdoc=reports/ds2019_list_select_pro">DS-2019 - Students List, Placement and Verification Reports</a></td>
		<td><a href="?curdoc=reports/overall_reports_menu">Overall Reports</a></td>
	</tr>
	<tr>
		<td><a href="?curdoc=reports/select_program">Gender Report by Region</a></td>
		<td><a href="?curdoc=reports/dept_state_menu">CSIET / Department of State Reports</a></td>
	</tr>
	<tr>
		<td><a href="?curdoc=reports/labels_select_pro">Labels (Avery 5160), Student ID Cards (Avery 5371) and Bulk Letters</a></td>
		<td><a href="?curdoc=progress_reports/rp_index">Progress Reports</a></td>		
	</tr>
	<tr>
		<td><a href="?curdoc=reports/sele_program">Program Statistics</a></td>
		<td><a href="?curdoc=reports/host_check_selection">Hosts in System</a></td>
	</tr>
	<tr>
		<td><a href="?curdoc=reports/regional_manager_check">Regions with multiple Managers Assigned</a></td>
		<td><a href="reports/check_hosts_sevis.cfm" target="_blank">Check Hosts Address for SEVIS Batch System</a></td>
	</tr>
	<tr>
		<td><a href="?curdoc=reports/users_in_system">Users Privilege Report</a></td>
		<td><a href="reports/check_schools_sevis.cfm" target="_blank">Check Schools Address for SEVIS Batch System</a></td>
	</tr>	
</cfif>

<!--- Compliance Reports --->
<cfif client.usertype LTE '4' OR user_compliance.compliance EQ '1'>
<tr bgcolor="e2efc7"><td colspan="2"><span class="get_attention"><b>::</b></span> Compliance Reports - Available for Compliance Users and Office</td></tr>
	<tr>
		<td><a href="?curdoc=compliance/reports_menu">Compliance - Placement Reports</a></td>
		<td></td>
	</tr>
</cfif>

<!---- FIELD ---->
<cfif client.usertype GTE '5'>
	<cfquery name="list_regions" datasource="caseusa"> <!--- GET USERS REGION --->
		SELECT user_access_rights.regionid, smg_regions.regionname
		FROM user_access_rights
		INNER JOIN smg_regions ON smg_regions.regionid = user_access_rights.regionid
		WHERE userid = '#client.userid#' 
			AND user_access_rights.companyid = '#client.companyid#'
		ORDER BY default_region DESC, regionname
	</cfquery>
	
	<cfif NOT IsDefined('url.regionid')><cfset url.regionid = '#list_regions.regionid#'></cfif>
	
	<!--- Check url.region EQ region from client.companyid --->
	<cfquery name="check_region" datasource="caseusa">
		SELECT uar.regionid, uar.usertype, u.usertype as user_access
		FROM user_access_rights uar
		INNER JOIN smg_usertype u ON u.usertypeid = uar.usertype
		WHERE uar.regionid = <cfqueryparam value="#url.regionid#" cfsqltype="cf_sql_integer">
			  AND userid = '#client.userid#'
			  AND uar.companyid = '#client.companyid#'
	</cfquery>
	
	<cfif check_region.recordcount EQ 0>
		<cfset url.regionid = '#list_regions.regionid#'>
	</cfif>
	
	<cfquery name="get_user_region" datasource="caseusa"> <!--- GET USERTYPE --->
		SELECT user_access_rights.regionid, user_access_rights.usertype, u.usertype as user_access
		FROM user_access_rights
		INNER JOIN smg_usertype u ON u.usertypeid = user_access_rights.usertype
		WHERE user_access_rights.regionid = <cfqueryparam value="#url.regionid#" cfsqltype="cf_sql_integer">
			  AND userid = '#client.userid#'
	</cfquery>
	
	<cfset client.usertype = '#get_user_region.usertype#'>

	<!---- REGION SELECT ---->
	<cfif list_regions.recordcount GT 1>
	<cfoutput>
	<tr><td colspan="2">	
		<form name="form">
			You have access to multiple regions filter by region:
			<select name="sele_region" onChange="javascript:formHandler()">
			<cfloop query="list_regions">
				<option value="?curdoc=reports/index&regionid=#regionid#" <cfif url.regionid is #regionid#>selected</cfif>>#regionname#</option>
			</cfloop>
			</select>
			&nbsp; &middot; &nbsp; Access Level : &nbsp; #get_user_region.user_access#
		</form>
		</td>
	</tr>
	</cfoutput>
	</cfif>
</cfif>

<!----Reports for Managers ---->
<cfif client.usertype LT 6>
<tr bgcolor="e2efc7"><td colspan="2"><span class="get_attention"><b>::</b></span> Reports Available for Managers</td></tr>
	<tr>
		<td><a href="?curdoc=reports/HostFam_select_region">Host Family Spreadsheet</a></td>
		<td><a href="?curdoc=reports/select_region">Regional Hierarchy</a></td>
	</tr>
	<tr>
		<td><a href="?curdoc=cbc/managers_menu">CBC Form Authorization Not Received</a></td>
		<td>&nbsp;</td>
	</tr>	
</cfif>

<!--- ADVISORS --->
<cfif client.usertype LTE 6> 
<tr bgcolor="e2efc7"><td colspan="2"><span class="get_attention"><b>::</b></span> Reports Available for Managers and Advisors</td></tr>
	<tr>
		<td><a href="?curdoc=reports/placement_reports_menu">Placement Reports</a></td>
		<td></td>
	</tr>
</cfif>

<!--- EVERYBODY SEES IT --->
<tr bgcolor="e2efc7"><td colspan="2"><span class="get_attention"><b>::</b></span> Reports Available for All Users</td></tr>
<tr>
	<td><a href="?curdoc=reports/manager_reports">Flight Information Report</a></td>
	<td></td>
</tr>

<!--- Marcus Testing section --->
<cfif client.userid  is 510 or client.usertype is 1>
<tr bgcolor="e2efc7"><td colspan="2"><span class="get_attention"><b>::</b></span> Testing Section</td></tr>
	<tr>
		<td><a href="reports/hdreport.cfm" target=top>Help Desk Report</a></td>
		<td></td>
	</tr>
</cfif>
</table>

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>

<!----
<cfdirectory action="list" directory="d:\web\newsmg\reports\" name="reports" sort="name asc" filter="*.cfm">
<Table  align="center">
	<tr  bgcolor="#0C1163">
		<td> <font color="white"><u>Name</td>
		<td><font color="white"><u>Last Modified</td>
		<td><font color="white"><u>Size</td> 
	</tr> 
	<cfoutput query="reports">
	<tr bgcolor="#iif(reports.currentrow MOD 2 ,DE("CACED8") ,DE("white") )#">
		<Td><a href="reports/#name#">#name#</a></td>
		<td>#left(datelastmodified,10)#</td>
		<td>#size#</td>
	</tr>
	</cfoutput>
</table>
--->