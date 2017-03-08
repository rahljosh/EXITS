<cfif client.usertype LTE '4'>

<cfparam name="URL.active" default="1">

<Cfquery name="programs" datasource="MySQL">
	SELECT 
    	programid, programname, type, p.startdate, p.enddate, insurance_startdate, insurance_enddate, p.companyid, programfee,
        application_fee, insurance_w_deduct, insurance_wo_deduct, blank, hold, p.tripid, p.active, p.fieldviewable,
        smg_companies.companyshort,
        smg_program_type.programtype,
        smg_incentive_trip.trip_place, smg_incentive_trip.trip_year,
        smg_seasons.season,
        smg.season as smgseason
	FROM 
    	smg_programs p
	INNER JOIN 
    	smg_companies ON smg_companies.companyid = p.companyid
	LEFT JOIN 
    	smg_program_type ON smg_program_type.programtypeid = p.type
	LEFT JOIN 
    	smg_incentive_trip ON smg_incentive_trip.tripid = p.tripid
	LEFT JOIN 
    	smg_seasons ON smg_seasons.seasonid = p.seasonid
	LEFT JOIN 
    	smg_seasons smg ON smg.seasonid = p.smgseasonid
	WHERE 
    	p.active = <cfqueryparam value="#URL.active#" cfsqltype="cf_sql_integer">
    <cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.publicHS, CLIENT.companyID)>
        AND 
            p.companyid IN (<cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,10,12,13" list="yes">)
	<cfelse>
        AND 
            p.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
    </cfif>
	ORDER BY     	
        endDate DESC
</Cfquery>

<form method=post action="?curdoc=tools/new_program">

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/helpdesk.gif"></td>
		<td background="pics/header_background.gif"><h2>Program Maintenence</h2></td>
		<td background="pics/header_background.gif" align="right">
			<font size=-1>  [ &nbsp; <cfif URL.active EQ '1'><span class="edit_link_Selected"><cfelse><span class="edit_link"></cfif> <a href="?curdoc=tools/programs&active=1">Active</a></span> &middot; <cfif URL.active EQ '0'><span class="edit_link_Selected"><cfelse><span class="edit_link"></cfif> <a href="?curdoc=tools/programs&active=0">Inactive</a> </span> &middot; All &nbsp; ] </font> 
		</td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table width=100% border=0 cellpadding=4 cellspacing=0 class="section">
	<tr>
		<td><b>ID</b></td>
		<td><b>Status</b></td>
		<td><b>Field View</b></td>
		<td><b>Program Name</b></td>
		<td><b>Type</b></td>
		<td><b>Start Date</b></td>
		<td><b>End Date</b></td>
        <td><b>Insurance Start </b></td>
		<td><b>Insurance End </b></td>
		<td><b>Season</b></td>
		<td><b>SMG Season</b></td>
		<td><b>Incentive Trip</b></td>
		<!--- <td><b>Fee's</b></td> --->
	</tr>
	<cfoutput query="programs">
	<tr bgcolor="#iif(programs.currentrow MOD 2 ,DE("ffffe6") ,DE("e2efc7") )#">
		<td>#programid#</td>
		<Td><cfif enddate lt now()><font color="red">expired<cfelseif hold is 1><font color="##3300CC">hold</font><cfelseif #enddate# gt #now()#><Font color="green">active</cfif></Font></Td>
		<td><cfif fieldviewable is 1>Yes<cfelse>No</cfif></td>
		<td><a href="?curdoc=tools/change_programs&progid=#programid#">#programname#</a></td>
		<td><cfif programtype is ''><font color="red">None Assigned</font><cfelse>#programtype#</cfif></td>
		<td>#DateFormat(startdate, 'mm-dd-yyyy')#</td>
		<td>#DateFormat(enddate, 'mm-dd-yyyy')#</td>
        <td>#DateFormat(insurance_startDate, 'mm-dd-yyyy')#</td>
		<td>#DateFormat(insurance_endDate, 'mm-dd-yyyy')#</td>
		<td>#season#</td>
		<td>#smgseason#</td>
		<td>#trip_place# <cfif trip_year NEQ ''>- #DateFormat(trip_year, 'yyyy')#</cfif></td>
		<!--- <td>#programfee# *</td> --->
	</tr>
	</cfoutput>
	<Tr>
		<td colspan=8 align="center"><input name="Submit" type="image" src="pics/new.gif" border=0></td>
	</Tr>
	<tr><td colspan=8>&nbsp;</td></tr>
	<Tr>
		<td colspan=8><p><font size=-1><a href="?curdoc=tools/program_types">Change program type details.</a></font></p></td>
	</Tr>
	<Tr>
		<td colspan=8><p>Click on program name to edit the details of that program. <br> Changes are affective immediatly and will affect all students assigned to that program.<br><br></td>
	</Tr>
	<tr>
		<td colspan="8"><font size=-2>* this is the base fee for the program, to set a different fee for Int. Reps, edit their account under Users -> Int. Agents Changing fees this will only affect students that have NOT been invoiced.</font></td>
	</tr>
</table>
</form>

<cfelse>
You do not have sufficient rights to edit programs.
</cfif>

<cfinclude template="../table_footer.cfm">