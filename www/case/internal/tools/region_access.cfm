<SCRIPT LANGUAGE="JavaScript"> 
<!-- Begin
function formHandler(form){
var URL = document.form.sele_region.options[document.form.sele_region.selectedIndex].value;
window.location.href = URL;
}
// End -->
</SCRIPT>

<cfif client.usertype LTE '4'>
	<cfquery name="list_regions" datasource="caseusa"> <!--- GET ALL REGIONS --->
		SELECT regionid, regionname
		FROM smg_regions
		WHERE company = '#client.companyid#' and subofregion = '0'
		ORDER BY regionname
	</cfquery>
	
	<cfif not isDefined("url.regionid")><cfset url.regionid = list_regions.regionid></cfif>

<cfelse>
	<cfquery name="list_regions" datasource="caseusa"> <!--- GET USERS REGION --->
		SELECT user_access_rights.regionid, user_access_rights.usertype, smg_regions.regionname
		FROM user_access_rights
		INNER JOIN smg_regions ON smg_regions.regionid = user_access_rights.regionid
		WHERE userid = '#client.userid#' AND user_access_rights.companyid = '#client.companyid#'
		ORDER BY default_region DESC, regionname
	</cfquery>
	<!--- getting correct usertype for the region choosen --->
	<cfset client.usertype = list_regions.usertype>
	
	<cfif not IsDefined('url.regionid')><cfset url.regionid = list_regions.regionid></cfif>
</cfif>


<cfquery name="current_programs" datasource="caseusa">
		select programid from smg_programs
		where startdate < #now()# and companyid = #client.companyid#
		</cfquery>
		
<cfif client.usertype lte 4>
	<Cfoutput>
	
	<Cfquery name="rd_students" datasource="caseusa">
		select smg_students.studentid, smg_students.regionassigned, smg_students.familylastname, smg_students.firstname, smg_students.programid,  smg_users.firstname as rep_firstname, smg_users.lastname as rep_lastname, smg_users.userid
		from smg_students right join smg_users on smg_students.arearepid = smg_users.userid
		where 1=1
			<cfif url.regionid is "All"><cfelse>
				AND smg_students.regionassigned = <cfqueryparam value="#url.regionid#" cfsqltype="cf_sql_integer">
			</cfif>
			AND smg_students.companyid = #client.companyid# and smg_students.active =1 and
			 (programid = 
			<Cfloop query="current_programs">
			 #programid# <cfif current_programs.currentrow is #current_programs.recordcount#><cfelse> or programid = </cfif>
			</Cfloop>)
			and smg_students.active =1
			ORDER BY smg_users.lastname, smg_users.userid
		</cfquery>
	</Cfoutput>
<cfelse>
	
	<Cfquery name="rd_students" datasource="caseusa">
	SELECT smg_students.studentid, smg_students.regionassigned, smg_students.familylastname, smg_students.firstname, smg_students.programid,  smg_users.firstname as rep_firstname, smg_users.lastname as rep_lastname, smg_users.userid
	FROM smg_students right join smg_users on smg_students.arearepid = smg_users.userid
	WHERE 1=1
	<cfif url.regionid is "All"><cfelse>
		AND smg_students.regionassigned = <cfqueryparam value="#url.regionid#" cfsqltype="cf_sql_integer">
	</cfif>
		<cfif client.usertype is 6>
		<cfquery name="get_reps" datasource="caseusa">
							select userid 
							from user_access_rights
							where advisorid = #client.userid# and companyid = #client.companyid#
							</cfquery>
							
							and (smg_students.arearepid = 
							<cfloop query="get_reps">
							#userid# <cfif get_reps.currentrow eq #get_reps.recordcount#><cfelse> or smg_students.arearepid =</cfif>
							</cfloop>)
		</cfif>
	and smg_users.usertype < 8
	and smg_students.companyid = #client.companyid# and smg_students.active =1
	and (programid = 
	<Cfloop query="current_programs">
	 #programid# <cfif current_programs.currentrow is #current_programs.recordcount#><cfelse> or programid = </cfif>
	</Cfloop>)
	order by smg_users.lastname,smg_users.userid 
	</Cfquery> 
	
		<cfquery name="get_user_region" datasource="caseusa"> <!--- GET USERTYPE --->
		SELECT user_access_rights.regionid, user_access_rights.usertype, u.usertype as user_access
		FROM user_access_rights
		INNER JOIN smg_usertype u ON  u.usertypeid = user_access_rights.usertype
		WHERE user_access_rights.regionid = <cfqueryparam value="#url.regionid#" cfsqltype="cf_sql_integer">
			  and userid = '#client.userid#'
	</cfquery>  
	<cfset client.usertype = #get_user_region.usertype#>
</cfif>

<!--- REGIONS LIST --->
<cfoutput>
<cfif list_regions.recordcount lte 1><Cfelse>
	<form name="form">
		Filter by region:
		<select name="sele_region" onChange="javascript:formHandler()">
		<cfif client.usertype LTE '4'>
		<option value="?curdoc=forms/approve_list&regionid=all" <cfif url.regionid is 'all'>selected</cfif>>All</option>
		</cfif>
		<cfloop query="list_regions">
			<option value="?curdoc=forms/approve_list&regionid=#regionid#" <cfif url.regionid is #regionid#>selected</cfif>>#regionname#</option>
		</cfloop>
		</select>
	</form>
</cfif>  &nbsp; &middot; &nbsp; Access Level : &nbsp; #get_user_region.user_access#  <br>
</cfoutput>
