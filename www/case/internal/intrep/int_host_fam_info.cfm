<cfif isDefined('url.hostid')>
	<cfset client.hostid = #url.hostid#>
<cfelse>
</cfif>

<script>
function areYouSure() { 
   if(confirm("You are about to delete this Host Family. You will not be able to recover this information. Click OK to continue")) { 
     form.submit(); 
        return true; 
   } else { 
        return false; 
   } 
} 
</script>

<cfinclude template="../querys/family_info.cfm">

<!-----Host Children----->
<cfquery name="host_children" datasource="caseusa">
	SELECT *
	FROM smg_host_children
	WHERE hostid = '#family_info.hostid#'
	ORDER BY birthdate
</cfquery>

<!--- REGION --->
<cfquery name="get_region" datasource="caseusa">
	SELECT regionid, regionname
	FROM smg_regions
	WHERE regionid = '#family_info.regionid#'
</cfquery>

<!--- SCHOOL ---->
<cfquery name="get_school" datasource="caseusa">
	SELECT schoolid, schoolname, address, city, state, begins, ends
	FROM smg_Schools
	WHERE schoolid = '#family_info.schoolid#'
</cfquery>

<style type="text/css">
<!--
div.scroll {
	height: 155px;
	width:auto;
	overflow:auto;
	border-left: 2px solid #c6c6c6;
	border-right: 2px solid #c6c6c6;
	background: #Ffffe6;
	left:auto;
}
div.scroll2 {
	height: 100px;
	width:auto;
	overflow:auto;
	border-left: 2px solid #c6c6c6;
	border-right: 2px solid #c6c6c6;
	background: #Ffffe6;
	left:auto;
}
</style>

<cfoutput>
<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr><td width="60%" align="left" valign="top">
	<!--- HEADER OF TABLE --- Host Family Information --->
	<table width=100% cellpadding=0 cellspacing=0 border=0 height=24 >
		<tr valign=middle height=24>
			<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td><td width=26 background="pics/header_background.gif"><img src="pics/family.gif"></td>
			<td background="pics/header_background.gif"><h2>Host Family Information</h2></td><cfif client.usertype LTE '4'><td background="pics/header_background.gif"><a href="?curdoc=querys/delete_host&hostid=#hostid#" onClick="return areYouSure(this);"><img src="pics/deletex.gif" border="0"></img></a></td></cfif>
			<td background="pics/header_background.gif" width=16></td><td width=17 background="pics/header_rightcap.gif">&nbsp;</td></tr>
	</table>
	<!--- BODY OF A TABLE --->
	<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
		<tr><td>Family Name:</td><td>#family_info.familylastname#</td><td>ID:</td><td>#family_info.hostid#</td></tr>
		<tr><td>Address:</td><td>#family_info.address#</td></tr>
		<tr><td>City:</td><td>#family_info.city#</td></tr>
		<tr><td>State:</td><td>#family_info.state#</td><td>ZIP:</td><td>#family_info.zip#</td></tr>
		<tr><td>Phone:</td><td>#family_info.phone#</td></tr>
		<tr><td>Email:</td><td><a href="mailto:#family_info.email#">#family_info.email#</a></td></tr>
		<tr><td>Host Father:</td><td>#family_info.fatherfirstname# #family_info.fatherlastname# &nbsp; <cfif family_info.fatherbirth is '0'><cfelse> <cfset calc_age_father = #CreateDate(family_info.fatherbirth,01,01)#> (#DateDiff('yyyy', calc_age_father, now())#) </cfif></td><td>Occupation:</td><td><cfif family_info.fatherworkposition is ''>n/a<cfelse>#family_info.fatherworkposition#</cfif></td></tr>
		<tr><td>Host Mother:</td><td>#family_info.motherfirstname# #family_info.motherlastname#  &nbsp; <cfif family_info.motherbirth is '0'><cfelse> <cfset calc_age_mom = #CreateDate(family_info.motherbirth,01,01)#> (#DateDiff('yyyy', calc_age_mom, now())#) </cfif></td><td>Occupation:</td><td><cfif family_info.motherworkposition is ''>n/a<cfelse>#family_info.motherworkposition#</cfif></td></tr>
	</table>	
	<!--- BOTTOM OF A TABLE --->
	<table width=100% cellpadding=0 cellspacing=0 border=0>
		<tr valign="bottom"><td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td><td width=100% background="pics/header_background_footer.gif"></td><td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td></tr>
	</table>		
</td>
<td width="2%"></td> <!--- SEPARATE TABLES --->
<td width="38%" align="right" valign="top">
	<!--- HEADER OF TABLE --- Other Family Members --->
	<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
		<tr valign=middle height=24>
			<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td><td width=26 background="pics/header_background.gif"><img src="pics/family.gif"></td>
			<td background="pics/header_background.gif"><h2>Other Family Members</h2></td><td background="pics/header_background.gif" width=16></td>
			<td width=17 background="pics/header_rightcap.gif">&nbsp;</td></tr>
	</table>
	<!--- BODY OF TABLE --->
	<table width=100% border=0 cellpadding=4 cellspacing=0 class="section">
		<tr><td width="40%"><u>Name</u></td>
			<td width="20%"><u>Sex</u></td>
			<td width="20%"><u>Age</u></td>
			<td width="20%"><u>At Home</u></td></tr>
	</table>
	<div class="scroll">
	<table width=100% align="left" border=0 cellpadding=2 cellspacing=0>
		<cfloop query="host_children">
			<tr><td width="40%">#name#</td>
				<td width="20%">#sex#</td>
				<td width="20%"><cfif birthdate is ''><cfelse>#DateDiff('yyyy', birthdate, now())#</cfif></td>
				<td width="20%">#liveathome#</td></tr>
		</cfloop>
	</table>
	</div>
	<!--- BOTTOM OF A TABLE --->
	<table width=100% cellpadding=0 cellspacing=0 border=0>
		<tr valign="bottom"><td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td><td width=100% background="pics/header_background_footer.gif"></td><td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td></tr>
	</table>		
</td></tr>
</table><br>

<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr>
	<td width="32%" align="left" valign="top">
		<!--- HEADER OF TABLE --- COMMUNITY INFO --->
		<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
			<tr valign=middle height=24>
				<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td><td width=26 background="pics/header_background.gif"><img src="pics/family.gif"></td>
				<td background="pics/header_background.gif"><h2>Community Info</h2></td><td background="pics/header_background.gif" width=16></td>
				<td width=17 background="pics/header_rightcap.gif">&nbsp;</td></tr>
		</table>
		<!--- BODY OF TABLE --->
		<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
			<tr><td>Region:</td><td colspan="3"><cfif get_region.regionname is ''>not assigned<cfelse>#get_region.regionname#</cfif></td></tr>
			<tr><td>Community:</td><td colspan="3"><cfif family_info.community is ''>n/a<cfelse> #family_info.community#</cfif></td></tr>
			<tr><td>Closest City:</td><td><cfif family_info.nearbigcity is ''>n/a<cfelse> #family_info.nearbigcity#</cfif></td><td>Distance:</td><td>#family_info.near_City_dist# miles</td></tr>
			<tr><td>Airport Code:</td><td colspan="3"><cfif family_info.major_air_code is ''>n/a<cfelse> #family_info.major_air_code#</cfif></td></tr>
			<tr><td>Airport City:</td><td colspan="3"><cfif family_info.airport_city is '' and family_info.airport_state is ''>n/a<cfelse>#family_info.airport_city# / #family_info.airport_state#</cfif></td></tr>
			<tr><td valign="top">Interests: </td><td colspan="3"><cfif len(#family_info.pert_info#) gt '100'>#Left(family_info.pert_info,92)# <a href="?curdoc=forms/family_app_7_pis">more...</a><cfelse>#family_info.pert_info#</cfif></td></tr>
		</table>				
		<!--- BOTTOM OF A TABLE  --- COMMUNITY INFO --->
		<table width=100% cellpadding=0 cellspacing=0 border=0>
			<tr valign="bottom"><td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td><td width=100% background="pics/header_background_footer.gif"></td><td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td></tr>
		</table>				
	</td>
	<td width="2%"></td> <!--- SEPARATE TABLES --->
	<td width="28%" align="center" valign="top">
		<!--- HEADER OF TABLE --- SCHOOL --->
		<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
			<tr valign=middle height=24>
				<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td><td width=26 background="pics/header_background.gif"><img src="pics/school.gif"></td>
				<td background="pics/header_background.gif"><h2>School Info</h2></td><td background="pics/header_background.gif" width=16></td>
				<td width=17 background="pics/header_rightcap.gif">&nbsp;</td></tr>
		</table>
		<!--- BODY OF TABLE --->
		<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
			<tr><td>School:</td><td><cfif get_school.recordcount is '0'>there is no school assigned<cfelse>#get_school.schoolname#</cfif></td></tr>
			<tr><td>Address:</td><td><cfif get_school.address is ''>n/a<cfelse>#get_school.address#</cfif></td></tr>
			<tr><td>City:</td><td><cfif get_school.city is '' and get_school.state is ''>n/a<cfelse>#get_school.city# / #get_school.state#</cfif></td></tr>
			<tr><td>Start Date:</td><td><cfif get_school.begins is ''>n/a<cfelse>#DateFormat(get_school.begins, 'mm/dd/yyyy')#</cfif></td></tr>
			<tr><td>End Date:</td><td><cfif get_school.ends is ''>n/a<cfelse>#DateFormat(get_school.ends, 'mm/dd/yyyy')#</cfif></td></tr>			
			<tr><td>&nbsp;</td></tr>
		</table>				
		<!--- BOTTOM OF A TABLE --- SCHOOL  --->
		<table width=100% cellpadding=0 cellspacing=0 border=0>
			<tr valign="bottom"><td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td><td width=100% background="pics/header_background_footer.gif"></td><td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td></tr>
		</table>		
	</td>
	<td width="2%"></td> <!--- SEPARATE TABLES --->
	<td width="36%" align="right" valign="top">
		<!--- OPEN --->
	</td>
</tr>
</table><br>

</cfoutput>