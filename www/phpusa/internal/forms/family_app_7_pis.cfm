<!--- Kill Extra Output --->
<cfsilent>

    <cfinclude template="../querys/get_local.cfm">
    <cfinclude template="../querys/family_info.cfm">
    
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.hostID" default="#client.hostID#">
    <cfparam name="FORM.community" default="">
    <cfparam name="FORM.nearbigcity" default="">
    <cfparam name="FORM.near_City_dist" default="">
    <cfparam name="FORM.major_air_code" default="">
    <cfparam name="FORM.airport_city" default="">
    <cfparam name="FORM.airport_state" default="">
    <cfparam name="FORM.pert_info" default="">
    
    <!--- Form Submitted --->
    <cfif FORM.submitted>
    
        <cfquery name="updateCommunityInfo" datasource="#application.dsn#">
            UPDATE 
                smg_hosts
            SET 
                community = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.community#">,
                nearbigcity = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.nearbigcity#">,
                near_City_dist = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.near_City_dist#">,
                major_air_code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.major_air_code#">,
                airport_city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.airport_city#">,
                airport_state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.airport_state#">,
                pert_info = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.pert_info#">
            WHERE 
                hostID = <cfqueryparam value="#client.hostID#" cfsqltype="cf_sql_integer">
            LIMIT 1
        </cfquery>
        
        <cflocation url="?curdoc=host_fam_info&hostID=#client.hostID#" addtoken="no">
    
    </cfif>

</cfsilent>

<cfform action="#CGI.SCRIPT_NAME#?#cgi.QUERY_STRING#" method="post">
<input type="hidden" name="submitted" value="1" />
<input type="hidden" name="hostID" value="#FORM.hostID#" />

<cfoutput query="local">

<h2>&nbsp;&nbsp;&nbsp;&nbsp; C o m m u n i t y &nbsp;&nbsp;&nbsp; I n f o r m a t i o n <font size=-2>[ <a href="?curdoc=host_fam_info&hostID=#client.hostID#">overview</a> ] </font></h2>


<table width="90%" border=1 align="center" cellpadding=8 cellspacing=8 bordercolor="##C7CFDC" bgcolor="##FFFFFF" class="section">
	<tr><td width="80%" class="box">
		<table border=0 cellpadding=4 cellspacing=0 align="left">
			<tr><td colspan="2"><h3>#city# #state#, #zip#</h3></td></tr>
			<tr><td colspan="2">Would you describe the community as:</td></tr>
			<tr><td colspan="2">
				<cfif family_info.community is 'Urban'><cfinput type="radio" name="community" value="Urban" checked><cfelse><cfinput type="radio" name="community" value="Urban"> </cfif>Urban
				<cfif family_info.community is 'suburban'><cfinput type="radio" name="community" value="suburban" checked><cfelse><cfinput type="radio" name="community" value="suburban"></cfif>Suburban
				<cfif family_info.community is 'small'><cfinput type="radio" name="community" value="small" checked><cfelse><cfinput type="radio" name="community" value="small"></cfif>Small Town
				<cfif family_info.community is 'rural'><cfinput type="radio" name="community" value="rural" checked><cfelse><cfinput type="radio" name="community" value="rural"></cfif>Rural
				</td></tr>
			<tr><td class="label">Closest City:</td><td class="form_text"><cfinput type="text" name="nearbigcity" size=20 value="#family_info.nearbigcity#"></td></tr>
			<tr><td class="label">Distance:</td><td class="form_text"> <cfinput name="near_City_dist" size="3" type="text" value="#family_info.near_City_dist#">miles</td></tr>
			<tr><td class="label">Arrival Airport Code:</td><td class="form_text"><cfinput type="text" name="major_air_code" size=3 value="#family_info.major_air_code#" onchange="javascript:this.value=this.value.toUpperCase();"></td></tr>
			<tr><td class="label">Arrival Airport City: </td><td class="form_text"><cfinput type="text" name="airport_city" size="20" value="#family_info.airport_city#"></td></tr>
			<tr><td class="label" >Arrival Airport State: </td><td width=10>
				<cfinclude template="../querys/states.cfm">
				<select name="airport_state">
				<option>
					<cfloop query="states">
						<option value="#state#" <Cfif family_info.airport_state is #state#>selected</cfif>>#State#</option>
					</cfloop>
				</select></td></tr>
			<tr bgcolor="e2efc7"><td colspan="2">Points of interest in the community:</td></tr>
			<tr bgcolor="e2efc7"><td colspan="2"><textarea cols="60" rows="4" name="pert_info" wrap="VIRTUAL"><cfoutput>#family_info.pert_info#</cfoutput></textarea></td></tr>					
		</table>
	</td>
	<td width="20%" align="right" valign="top" class="box">
		<table border=0 cellpadding=4 cellspacing=0 align="right">
			<tr><td align="right"><cfinclude template="../family_pis_menu.cfm"></td></tr>
		</table> 		
	</td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr><td align="center"><input name="Submit" type="image" src="pics/next.gif" align="middle" border=0></td></tr>
</table>

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>
</cfoutput>
</cfform>