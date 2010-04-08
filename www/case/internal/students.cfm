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
div.scroll {
	height: 400px;
	width: 100%;
	overflow: auto;
	border-left: 2px solid #c6c6c6;
	border-right: 2px solid #c6c6c6;
	background: #Ffffe6;
}
-->
</style>

<cfif not isDefined("url.student_order")><cfset url.student_order = "familylastname"></cfif>
<cfif not isDefined("url.student_placed")>
	<cfif client.usertype LTE '4'><cfset url.student_placed = "no"><cfelse><cfset url.student_placed = "no"></cfif>
</cfif>

<!--- OFFICE PEOPLE AND ABOVE --->
<cfif client.usertype LTE '4'>
	<cfquery name="list_regions" datasource="caseusa"> <!--- GET ALL REGIONS --->
		SELECT regionid, regionname
		FROM smg_regions
		WHERE company = '#client.companyid#' and subofregion = '0'
		ORDER BY regionname
	</cfquery>
	<cfif not isDefined("url.regionid")><cfset url.regionid = "All"></cfif>
	<cfquery name="students" datasource="caseusa">
		SELECT  
			s.studentid, s.firstname, s.smg_id,s.familylastname, s.sex, s.active, s.regionassigned, s.programid, s.dateassigned, s.regionguar,
			s.hostid, s.companyid, s.state_guarantee, s.aypenglish, s.ayporientation, 
			smg_regions.regionname,
			smg_g.regionname as r_guarantee,
			smg_states.state,
			c.countryname,
			co.companyshort 
		FROM smg_students s
		LEFT JOIN smg_regions ON s.regionassigned = smg_regions.regionid
		LEFT JOIN smg_countrylist c ON s.countryresident = c.countryid
		LEFT JOIN smg_regions smg_g ON s.regionalguarantee = smg_g.regionid
		LEFT JOIN smg_states ON s.state_guarantee = smg_states.id
		INNER JOIN smg_companies co ON s.companyid = co.companyid
		WHERE 1=1
		<!--- Students under companies --->
		<cfif client.companyid NEQ 5>AND s.companyid = '#client.companyid#'<cfelse>AND s.companyid <= 5</cfif>
		<cfif url.student_placed EQ 'inactive'>
			AND s.active = 0 AND canceldate IS NULL
		<cfelseif url.student_placed EQ 'cancel'>
			AND s.active = 0 AND canceldate IS NOT NULL
		<cfelse>
			AND s.active = 1 
		</cfif>
		<!--- Students Region Selected --->
		<cfif url.regionid NEQ "All">
			AND s.regionassigned = <cfqueryparam value="#url.regionid#" cfsqltype="cf_sql_integer">
		</cfif>		
		<!--- Students Status Placed/Unplaced --->
		<cfif url.student_placed is "yes">
			AND (hostid <> 0)
		<cfelseif url.student_placed is "no">
			AND (hostid = 0)
		</cfif>
			<!--- SHOW ONLY APPS APPROVED --->
			AND (app_current_status = '0' OR app_current_status = '11')
		ORDER BY #url.student_order#	
	</cfquery>

<!--- MANAGERS, ADVISORS AND LOCALS --->	
<cfelseif (client.usertype GTE '5' AND client.usertype LTE '7') OR client.usertype EQ '9'>
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
	
	<cfquery name="get_user_region" datasource="caseusa"> <!--- GET USERTYPE --->
		SELECT user_access_rights.regionid, user_access_rights.usertype, u.usertype as user_access
		FROM user_access_rights
		INNER JOIN smg_usertype u ON  u.usertypeid = user_access_rights.usertype
		WHERE user_access_rights.regionid = <cfqueryparam value="#url.regionid#" cfsqltype="cf_sql_integer">
			  and userid = '#client.userid#'
	</cfquery>
	
	<cfquery name="students" datasource="caseusa">
		SELECT userid, user_access_rights.companyid, user_access_rights.regionid, s.active,
			s.studentid, s.firstname, s.familylastname, s.sex, s.regionassigned, s.programid, s.dateassigned, s.regionguar,
			s.hostid, s.state_guarantee, uniqueid, s.aypenglish, s.ayporientation,
			smg_regions.regionname,
			smg_g.regionname as r_guarantee,
			smg_states.state,
			smg_programs.fieldviewable,
			c.countryname,
			co.companyshort 
		FROM user_access_rights
		INNER JOIN smg_regions ON smg_regions.regionid = user_access_rights.regionid
		INNER JOIN smg_students s ON s.regionassigned = user_access_rights.regionid
		LEFT JOIN smg_regions smg_g on s.regionalguarantee = smg_g.regionid
		LEFT JOIN smg_countrylist c ON c.countryid = s.countryresident
		LEFT JOIN smg_programs on s.programid = smg_programs.programid
		LEFT JOIN smg_states ON s.state_guarantee = smg_states.id
		INNER JOIN smg_companies co ON s.companyid = co.companyid
		WHERE userid = '#client.userid#'
			<!----Don't show 08 programs---->
			AND fieldviewable = 1
			AND user_access_rights.companyid = '#client.companyid#'
			AND s.active = <cfif url.student_placed is 'inactive'>0<cfelse>1</cfif> 
			<!--- Students Region Selected --->
			AND s.regionassigned = <cfqueryparam value="#url.regionid#" cfsqltype="cf_sql_integer">
			<!--- Students Status --->
			<cfif get_user_region.usertype NEQ '9'>
				<cfif url.student_placed is "all">
				<cfelseif url.student_placed is "yes">
				AND (s.hostid <> 0)
				<cfelseif url.student_placed is "no">
				AND (s.hostid = 0)
				</cfif>
				
				
			</cfif>
			<!--- STUDENTS UNDER ADVISOR --->		
			<cfif get_user_region.usertype EQ '6'>
				<cfquery name="get_users_under_adv" datasource="caseusa">
					SELECT DISTINCT userid	FROM user_access_rights
					WHERE advisorid = '#client.userid#'
						  AND regionid = <cfqueryparam value="#url.regionid#" cfsqltype="cf_sql_integer">
						  OR userid = '#client.userid#'
				</cfquery>
				<cfset ad_users = ValueList(get_users_under_adv.userid, ',')>
				<!--- show only placed by the reps under the advisor --->
				<cfif url.student_placed is 'yes'>
					AND ( s.arearepid = 
						<cfloop list="#ad_users#" index='i' delimiters = ",">
						'#i#' <cfif #ListLast(ad_users)# is #i#><cfelse> or s.arearepid = </cfif> </Cfloop> 
					OR  s.placerepid = 
						<cfloop list="#ad_users#" index='i' delimiters = ",">
						'#i#' <cfif #ListLast(ad_users)# is #i#><cfelse> or s.placerepid = </cfif> </Cfloop>
					OR s.arearepid = '#client.userid#' OR s.placerepid = '#client.userid#')
				</cfif>
				<cfif url.student_placed is 'all'>		
					AND s.hostid = '0' AND s.arearepid = '0'
					<!--- show only placed by the reps under the advisor --->
					OR (s.active = <cfif url.student_placed is 'inactive'>0<cfelse>1</cfif> AND userid = '#client.userid#' 
					AND user_access_rights.companyid = '#client.companyid#'
					AND ( s.arearepid = 
						<cfloop list="#ad_users#" index='i' delimiters = ",">
						'#i#' <cfif #ListLast(ad_users)# is #i#><cfelse> or s.arearepid = </cfif> </Cfloop>
					OR s.placerepid = 
						<cfloop list="#ad_users#" index='i' delimiters = ",">
						'#i#' <cfif #ListLast(ad_users)# is #i#><cfelse> or s.placerepid = </cfif> </Cfloop> 
					OR s.arearepid = '#client.userid#' OR s.placerepid = '#client.userid#'))
				</cfif>
			</cfif>
			<!--- STUDENTS UNDER AN AREA REPRESENTATIVE --->		
			<cfif get_user_region.usertype is '7'>
				<cfif url.student_placed is 'yes'>
				AND (s.arearepid = '#client.userid#' OR s.placerepid = '#client.userid#')
				</cfif>
				<cfif url.student_placed is 'all'>
				AND s.hostid = '0' AND s.arearepid = '0'
				OR (s.active = <cfif url.student_placed is 'inactive'>0<cfelse>1</cfif> AND userid = '#client.userid#' 
					AND user_access_rights.companyid = '#client.companyid#' AND (s.arearepid = '#client.userid#' OR s.placerepid = '#client.userid#') )
				</cfif>
			</cfif>
			<!--- STUDENTS UNDER A STUDENT VIEW ONLY --->
			<cfif get_user_region.usertype is '9'>
				AND s.hostid = '0'
			</cfif>		
			<!--- DO NOT SHOW APPS RECEIVED OR ON HOLD --->
			AND (app_current_status = '0' OR app_current_status = '11')		
		ORDER BY #url.student_order#
	</cfquery>

	<!--- GET USERTYPE --->
	<cfquery name="get_user_region" datasource="caseusa"> 
		SELECT user_access_rights.regionid, user_access_rights.usertype, u.usertype as user_access
		FROM user_access_rights
		INNER JOIN smg_usertype u ON  u.usertypeid = user_access_rights.usertype
		WHERE user_access_rights.regionid = <cfqueryparam value="#url.regionid#" cfsqltype="cf_sql_integer">
			  AND userid = '#client.userid#'
	</cfquery>  
	<cfset client.usertype = #get_user_region.usertype#>
	
</cfif>

<Cfoutput>

<!----Students List---->
<cfif list_regions.recordcount GT 1>
	<form name="form">
		You have access to multiple regions filter by region:
		<select name="sele_region" onChange="javascript:formHandler()">
		<cfif client.usertype LTE '4'>
		<option value="?curdoc=students&student_placed=#url.student_placed#&regionid=all" <cfif url.regionid is 'all'>selected</cfif>>All</option>
		</cfif>
		<cfloop query="list_regions">
			<option value="?curdoc=students&student_placed=#url.student_placed#&regionid=#regionid#" <cfif url.regionid is #regionid#>selected</cfif>>#regionname#</option>
		</cfloop>
		</select>
		<cfif client.usertype GT '4' AND (client.usertype LTE '7' OR client.usertype EQ '9')>
		&nbsp; &middot; &nbsp; Access Level : &nbsp; #get_user_region.user_access#
		</cfif>
	</form>
</cfif><br>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>Students </h2></td>
		<td background="pics/header_background.gif" align="right"><cfoutput><font size=-1>[
			<!--- RECEIVED / ON HOLD LINKS - OFFICE ONLY --->
			<!---
			<cfif client.usertype LTE 4> 
				<span class="edit_link"><a href="index.cfm?curdoc=app_process/apps_received&status=received">Received</a></span> &middot; 
				<span class="edit_link"><a href="index.cfm?curdoc=app_process/apps_received&status=hold">On Hold</a></span> &middot;
			</cfif>
			--->
			<cfif url.student_placed is "no"><span class="edit_link_selected"><cfelse><span class="edit_link"></cfif><a href="?curdoc=students&student_placed=no&regionid=#url.regionid#">Unplaced</a></span>  &middot; 
			<cfif url.student_placed is "yes"><span class="edit_link_selected"><cfelse><span class="edit_link"></cfif>	<cfif IsDefined('get_user_region.usertype') AND get_user_region.usertype is '9'><cfelse><a href="?curdoc=students&student_placed=yes&regionid=#url.regionid#">Placed</a></span></cfif> 			
			&middot; <cfif url.student_placed is "all"><span class="edit_link_Selected"><cfelse><span class="edit_link"></cfif> <cfif IsDefined('get_user_region.usertype') AND get_user_region.usertype is '9'><cfelse><a href="?curdoc=students&student_placed=all&regionid=#url.regionid#">All</a></span></cfif>
			<!--- INACTIVE AND CANCELLED STUDENTS - OFFICE ONLY --->
			<cfif client.usertype LTE 4> 
				&middot; <cfif url.student_placed is "inactive"><span class="edit_link_Selected"><cfelse><span class="edit_link"></cfif><a href="?curdoc=students&student_placed=inactive&regionid=#url.regionid#">Inactive</a></span>
				&middot; <cfif url.student_placed is "cancel"><span class="edit_link_Selected"><cfelse><span class="edit_link"></cfif><a href="?curdoc=students&student_placed=cancel&regionid=#url.regionid#">Cancelled</a></span>
			</cfif> ] 
			#students.recordcount# students displayed</cfoutput></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
	<tr><td width=20><a href="?curdoc=students&student_order=studentid&student_placed=#url.student_placed#&regionid=#url.regionid#">ID</a></td>
		<cfif client.usertype lte 4><td width=20><a href="?curdoc=students&student_order=smg_id&student_placed=#url.student_placed#&regionid=#url.regionid#">ALT ID</a></td></cfif>
		<td width=80><a href="?curdoc=students&student_order=familylastname&student_placed=#url.student_placed#&regionid=#url.regionid#">Last Name</a></td>
		<td width=75><a href="?curdoc=students&student_order=firstname&student_placed=#url.student_placed#&regionid=#url.regionid#">First Name</a></td>
		<td width=35><a href="?curdoc=students&student_order=sex&student_placed=#url.student_placed#&regionid=#url.regionid#">Sex</a></td>
		<td width=70><a href="?curdoc=students&student_order=country&student_placed=#url.student_placed#&regionid=#url.regionid#">Country</a></td>
		<td width=55><a href="?curdoc=students&student_order=regionname&student_placed=#url.student_placed#&regionid=#url.regionid#">Region</a></td>
		<td width=60><a href="?curdoc=students&student_order=programid&student_placed=#url.student_placed#&regionid=#url.regionid#">Program</a></td>
		<cfif url.student_placed NEQ "no">
			<Td width="60"><a href="?curdoc=students&student_order=hostid&student_placed=#url.student_placed#&regionid=#url.regionid#">Family</a></td>
		</cfif>
		<cfif client.companyid EQ 5> <!--- show company name if you are logged in the SMG --->
			<td width=30><a href="?curdoc=students&student_order=companyshort&student_placed=#url.student_placed#&regionid=#url.regionid#">Company</a></td>
		</cfif>
	</tr>
</table>
</cfoutput>

<div class="scroll">
<table width=100%>
<cfoutput query="students">

<Cfquery name="program" datasource="caseusa">
	select programname
	from smg_programs
	where programid = #programid#
	<cfif client.companyid is 5><cfelse>
		AND companyid = #client.companyid#
	</cfif>
</Cfquery>

<Cfif url.student_placed is 'no'><cfelse>
<Cfquery name="family" datasource="caseusa">
	select familylastname
	from smg_hosts
	where hostid = #hostid#
</Cfquery>
</Cfif>

<cfif IsDefined('get_user_region.usertype') AND get_user_region.usertype EQ '9'>
	<cfset urllink ="index.cfm?curdoc=student_profile&uniqueid=#uniqueid#">
<cfelse>
	<cfset urllink="index.cfm?curdoc=student_info&studentid=#studentid#">
</cfif>

<Cfif dateassigned NEQ '' AND dateassigned GT client.lastlogin>
	<tr bgcolor="e2efc7">
<cfelseif dateassigned NEQ '' AND #DateDiff('d',dateassigned, now())# GTE 25 AND #DateDiff('d',dateassigned, now())# LTE 34 AND students.hostid EQ '0' AND students.active EQ '1'>
	<tr bgcolor="B3D9FF">
<cfelseif dateassigned NEQ '' AND #DateDiff('d',dateassigned, now())# GTE 35 AND #DateDiff('d',dateassigned, now())# LTE 49 AND students.hostid EQ '0' AND students.active EQ '1'>
	<tr bgcolor="FFFF9D">
<cfelseif dateassigned NEQ '' AND #DateDiff('d',dateassigned, now())# GTE 50 AND students.hostid EQ '0' AND students.active EQ '1'>
	<tr bgcolor="FF9D9D">
<cfelse>
	<tr bgcolor="#iif(students.currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#">
</cfif>
		<td width=10><a href='#urllink#'>#Studentid#</a></td>
		<cfif client.usertype lte 4><td width=10><a href='#urllink#'>#smg_id#</a></td></cfif>
		<td width=90><a href='#urllink#'><cfif #len(familylastname)# gt 15>#Left(familylastname, 12)#...<Cfelse>#familylastname#</cfif></a></td>
		<td width=80><a href='#urllink#'>#firstname#</a></td>
		<td width=40>#sex#</td>
		<td width=80><cfif len(#countryname#) lt 10>#countryname#<cfelse>#Left(countryname,13)#..</cfif></td>
		<td width=55>#students.regionname# 
					<cfif regionguar is 'yes'>
						<font color="CC0000">
							<cfif r_guarantee is '' and state_guarantee EQ 0>* Missing</cfif>
							<cfif r_guarantee is not ''>* #r_guarantee#
								<cfelseif students.state_guarantee NEQ 0>* #students.state#</cfif>
						</cfif>
						</font>
					</td>
		<td width=60>#program.programname#
			<font color="CC0000">
				<cfif aypenglish NEQ 0>
					* Pre-Ayp English
				<cfelseif ayporientation NEQ 0>
					* Pre-Ayp Orient.
				</cfif>
			</font>
		</td>
		<cfif url.student_placed is "no"><cfelse>
			<td width="60">#family.familylastname#</td>
		</cfif>
		<cfif client.companyid is 5> <!--- show company name if you are logged in the SMG --->
			<td width=30>#students.companyshort#</td>
		</cfif>
	</tr>
</cfoutput>
</table>
</div>
<table width=100% bgcolor="#ffffe6" class="section">
	<tr>
		<td bgcolor="e2efc7">Students in Green have been added since your last vist.</td>
		<td align="center"><font color="CC0000">* Regional / State Guarantee</font></td>
		<td align="right">CTRL-F to search</td>
	</tr>
	<tr>
		<td bgcolor="B3D9FF">Student unplaced for 25-34 days.</td>
		<td bgcolor="FFFF9D">Student unplaced for 35-49 days</td>
		<td bgcolor="FF9D9D">Student Unplaced more than 50 days</td>
	</tr>
</table>

<!----footer of table---->
<cfinclude template="table_footer.cfm">