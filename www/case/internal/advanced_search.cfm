<style type="text/css">
	table.nav_bar { font-size: 10px; background-color: #ffffff; border: 1px solid #666666; }
</style>

<!--- COUNTRY LIST --->
<cfinclude template="querys/get_countries.cfm">

<!--- INTERESTS LIST --->
<cfinclude template="querys/get_interests.cfm">

<!--- RELIGIOUS LIST --->
<cfinclude template="querys/get_religious.cfm">

<!--- PROGRAM LIST --->
<cfinclude template="querys/get_programs.cfm">

<!--- INTL REP LIST --->
<cfinclude template="querys/get_intl_rep.cfm">

<!--- STATES --->
<cfinclude template="querys/get_states.cfm">

<cfquery name="get_regions" datasource="caseusa">
	select regionid, regionname,
		   companyshort
	from smg_regions
	INNER JOIN smg_companies ON company = companyid
	where 1 = 1
	<cfif #client.companyid# NEQ 5>
		and company = '#client.companyid#'
	</cfif>
	<cfif client.usertype GT 4>
		AND( regionid like
		<cfquery name="get_regions" datasource="caseusa">
		select regionid from
		user_access_rights
		where userid = #client.userid#
		</cfquery>
		<Cfloop query="get_regions">
		 #regionid# <cfif #get_regions.currentrow# eq #get_regions.recordcount#><cfelse> or regionid like</cfif>
		</Cfloop>)
	</cfif>
	order by companyshort, regionname
</cfquery>

<cfform action="?curdoc=adv_search_list" method="POST"><br>
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td background="pics/header_background.gif"><h2>Advanced Search</h2></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
		<tr bgcolor="e2efc7"><td colspan="2"><span class="get_attention"><b>::</b></span> You can combine the following criteria</td></tr>
		<tr><td class="label">Active : </td>
			<td><select name="active" size="1">
					<option value="1">Yes</option>
					<option value="0">No</option>
					<option value="2">All</option>
				</select></td></tr>
		<tr><td class="label">Placement Status : </td>
			<td><select name="status" size="1">
					<option value="0"></option>
					<option value="placed">Placed</option>
					<option value="unplaced">Unplaced</option>
				</select></td></tr>
		<tr><td class="label">Pre-AYP :</td>
			<td><select name="preayp" size="1">
				<option value='none'>None</option>
				<option value="english">English Camp</option>
				<option value="orient">Orientation Camp</option>
				</select></td></tr>		
		<tr><td class="label">Direct Placement :</td>
			<td><select name="direct" size="1">
				<option value='all' selected>All</option>
				<option value="yes">Yes</option>
				<option value="no">No</option>
				</select></td></tr>		
		<tr><td class="label">Age : </td>
			<td><select name="age" size="1">
					<option value="0"></option>
					<option value="15">15</option>
					<option value="16">16</option>
					<option value="17">17</option>
					<option value="18">18</option>
				</select></td></tr>
		<tr><td class="label">Gender : </td>
			<td><select name="gender" size="1">
					<option value="0"></option>
					<option value="male">Male</option>
					<option value="female">Female</option>
				</select></td></tr>
		<tr><td class="label">Last Grade Completed : </td>
			<td><select name="grades" size="1">
					<option value="0"></option>
					<option value="7">7th</option>
					<option value="8">8th</option>
					<option value="9">9th</option>
					<option value="10">10th</option>
					<option value="11">11th</option>
					<option value="12">12th</option>
				</select></td>
		</tr>
		<tr><td class="label">Graduated in Home Country : </td>
			<td><select name="graduate" size="1">
					<option value=""></option>
					<option value="1">Yes</option>
				</select></td>
		</tr>
		<tr><td class="label">Religion :</td>
			<td><select name="religion" size="1">			
					<option value="0"></option>
					<cfoutput query="get_religious"><option value="#religionid#">#religionname#</option></cfoutput>
				</select></td></tr>
		<tr><td class="label">Center of Interests :</td>
			<td><select name="interests" size="1">			
					<option value="0"></option>
					<cfoutput query="get_interests"><option value="#interestid#">#interest#</option></cfoutput>
				</select></td></tr>
		<tr><td class="label">Play in competitive sports :</td>
			<td><select name="sports" size="1">			
					<option value="0"></option>
					<option value="yes">Yes</option>
					<option value="no">No</option>
				</select></td></tr>
		<tr><td class="label">Text in the narrative :</td>
			<td><input type="text" name="interests_other" size="25" maxlength="25"></td></tr>
		<tr><td class="label">Country of Origin :</td>
			<td><select name="countryid" size="1">			
					<option value="0"></option>
					<cfoutput query="get_countries"><option value="#countryid#">#countryname#</option></cfoutput>
				</select></td></tr>
		<tr><td class="label">International Rep. :</td>
			<td><select name="intrep" size="1">
				<option value="0"></option>
				<cfoutput query="get_intl_rep"><option value="#intrep#">#businessname#</option></cfoutput>
				</select></td></tr>
		<tr><td class="label">Region :</td>
			<td><select name="regionid" size="1">
					<cfif client.usertype LTE 4>
					<option value="0"></option>
					</cfif>
					<cfif #client.companyid# EQ 5>
						<cfoutput query="get_regions"><option value="#regionid#">#companyshort# &nbsp; #regionname#</option></cfoutput>
					<cfelse>
						<cfoutput query="get_regions"><option value="#regionid#">#regionname#</option></cfoutput>
					</cfif>
				</select></td></tr>
		<tr><td class="label">State Guarantee :</td>
			<td><select name="stateid" size="1">
				<option value="0">None</option>
						<cfoutput query="get_states"><option value="#id#">#statename#</option></cfoutput>
				</select></td></tr>								
		<tr><td class="label">Program :</td>
			<td><select name="programid" multiple  size="5">
				<option value="0" selected>All</option>
				<cfif #client.companyid# is 5>
					<cfoutput query="get_program"><option value="#ProgramID#">#companyshort# &nbsp; #programname#</option></cfoutput>
				<cfelse>	
					<cfoutput query="get_program"><option value="#ProgramID#">#ProgramName# </option></cfoutput>
				</cfif>
				</select></td></tr>
		<tr><td class="label">Student ID :</td>
			<td><input type="text" name="studentid" size="5" maxlength="5"></td></tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr><td align="center"><input type="Submit" value="Search">&nbsp; &nbsp; &nbsp; &nbsp;<input type="Reset"></td></tr>
</table>

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>
</cfform><br><br>
