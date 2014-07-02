<cfsilent>

	<cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.regionID" default="0">
    <cfparam name="URL.id" default="0">
    
    <cfparam name="FORM.status" default="1">
    <cfparam name="FORM.regional_guarantee" default="0">
    <cfparam name="FORM.regional_stipend" default="0">
    
    <cfscript>
		if (VAL(FORM.regionID)) {
			URL.id = FORM.regionID;
		}
		if (NOT LEN(FORM.regional_guarantee)) {
			FORM.regional_guarantee = 0;	
		}
		if (NOT LEN(FORM.regional_stipend)) {
			FORM.regional_stipend = 0;	
		}
	</cfscript>
    
    <cfquery name="get_Region_info" datasource="#APPLICATION.DSN#">
        SELECT * 
        FROM smg_regions 
        WHERE regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
    </cfquery>
    
    <cfquery name="facilitators" datasource="#APPLICATION.DSN#">
        SELECT DISTINCT u.userid, u.firstname, u.lastname
        FROM user_access_rights uar 
        INNER JOIN smg_users u ON u.userid = uar.userid
        WHERE uar.usertype = 4 
        AND u.active = 1
        AND uar.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
        ORDER BY u.lastname
    </cfquery>
    
    <cfif VAL(FORM.submitted)>
    
    	<cfquery datasource="#APPLICATION.DSN#">
            UPDATE smg_regions
            SET
                regionfacilitator = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.facilitator#">,
                title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.title#">,
                regional_guarantee = <cfqueryparam cfsqltype="cf_sql_decimal" value="#FORM.regional_guarantee#">,
                <cfif CLIENT.companyID EQ 14 OR APPLICATION.isServerLocal>
                    regional_stipend = <cfqueryparam cfsqltype="cf_sql_decimal" value="#FORM.regional_stipend#">,
                </cfif>
                active = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.status#">,
                url = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.website#">,
                websiteBlurb = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.websiteBlurb#">,
                twitter = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.twitter#">,
                facebook = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.facebook#">,
                googleplus = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.googleplus#">,
                pintrest = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.pintrest#">,
                youtube = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.youtube#">,
                tumblr = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.tumblr#">,
                regionalEmail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#">
            WHERE regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionid#">
        </cfquery>
        
        <cfquery name="get_sub_Regions" datasource="#APPLICATION.DSN#">
            SELECT regionid
            FROM smg_regions
            WHERE subofregion = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionid#">
        </cfquery>
        
        <cfloop query="get_sub_Regions">
            <cfquery datasource="#APPLICATION.DSN#">
                UPDATE smg_regions
                SET regional_guarantee = <cfqueryparam cfsqltype="cf_sql_decimal" value="#FORM.regional_guarantee#">
                WHERE regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#regionid#">
            </cfquery>
        </cfloop>
        
        <!----Update Facilitators for each company selected---->
        <cfloop list="#FORM.subregion#" index="i">
            <cfquery datasource="#APPLICATION.DSN#">
                INSERT INTO smg_regions(
                    regionname,
                    subofregion)
                VALUES(
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionid#">)
            </cfquery>
        </cfloop>
        
    </cfif>

</cfsilent>

<cfoutput>

	<form action="?curdoc=tools/edit_region" method="post">
		<input type="hidden" name="submitted" value="1" />
        <input type="hidden" name="regionID" value="#URL.id#" />
        
		<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
			<tr valign=middle height=24>
                <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
                <td width=26 background="pics/header_background.gif"></td>
                <td background="pics/header_background.gif"><h2>Region Maintenance </h2></td>
                <td background="pics/header_background.gif" align="right">&nbsp; &nbsp; &nbsp; <a href="index.cfm?curdoc=tools/regions">Regions List</a></td>
                <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
         	</tr>
		</table>

        <table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
            <tr><td align="center"><h2>#get_region_info.regionname#</h2></td></tr>
        </table>

		<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
			<tr>
            	<td>
    				<table border=0 cellpadding=4 cellspacing=0>
    					<tr>
        					<td><h3>Facilitator: </h3></td>
                           	<td>
                                <select name="facilitator">
                                <option value=0>None Assigned</option>
                                    <cfloop query="facilitators">
                                        <option value="#userid#" <cfif get_region_info.regionfacilitator EQ userid>selected</cfif>>#firstname# #lastname#</option>
                                    </cfloop>
                                </select>
                         	</td>
						</tr>
    					<tr>
        					<td><h3>Title: </h3></td>
                            <td>
								<select name="title">
									<option value="Manager" <cfif get_region_info.title EQ 'Manager'>selected</cfif>>Manager</option>
									<option value="Director" <cfif get_region_info.title EQ 'Director'>selected</cfif>>Director</option>
								</select>
                         	</td>
						</tr>
                        <tr>
                            <td><h3>Status: </h3></td>
                            <td>
                                <cfif get_Region_info.active is '1'><input type="radio" name="status" value="1" checked>Active<cfelse><input type="radio" name="status" value="1">Active</cfif>&nbsp; &nbsp;
                                <cfif get_Region_info.active is '0'><input type="radio" name="status" value="0" checked>Inactive<cfelse><input type="radio" name="status" value="0">Inactive</cfif>
                            </td>
                        </tr>
    					<tr>
                            <td><h3>Website: </h3></td>
                            <td>
                                <input type="text" size=25 name="website" value="#get_Region_info.url#" />
                            </td>
                        </tr>
                        <tr>
                            <td valign="top"><h3>Website Blurb: </h3></td><td>
                                <textarea cols=40 rows=5 name="websiteBlurb">#get_Region_info.websiteBlurb#</textarea>
                            </td>
                        </tr>
           				<tr>
                    		<td><h3>Email: </h3></td><td>
                                <input type="text" size=25 name="email" value="#get_Region_info.regionalEmail#" />
                            </td>
                    	</tr>
                        <tr>
                            <td><h3>Facebook: </h3></td><td>
                                <input type="text" size=25 name="facebook" value="#get_Region_info.facebook #"/>
                            </td>
                        </tr>
                        <tr>
                            <td><h3>Twitter:</h3></td><td>
                                <input type="text" size=25 name="twitter" value="#get_Region_info.twitter#"/>
                            </td>
                        </tr>
        				<tr>
                            <td><h3>Pintrest:</h3></td><td>
                                <input type="text" size=25 name="pintrest" value="#get_Region_info.pintrest#" />
                            </td>
                        </tr>
                        <tr>
                            <td><h3>Youtube: </h3></td><td>
                                <input type="text" size=25 name="youtube" value="#get_Region_info.youtube#" />
                            </td>
                        </tr>
            			<tr>
                            <td><h3>Tumblr: </h3></td>
                            <td>
                                <input type="text" size=25 name="tumblr" value="#get_Region_info.tumblr#"/>
                            </td>
                        </tr>
    					<tr>
                            <td><h3>Goolge +:</h3></td>
                            <td>
                                <input type="text" size=25 name="googleplus"  value="#get_Region_info.googleplus#"/>
                            </td>
                        </tr>
  					</table>
  
  					<table  border=0 cellpadding=4 cellspacing=0>
						<tr>
							<td colspan=2>
                            	<h3>Current Regional Guarantees:</h3>
                                <cfquery name="sub_regions" datasource="#APPLICATION.DSN#">
                                    SELECT * 
                                    FROM smg_regions 
                                    WHERE subofregion = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
                                </cfquery>
								<cfif sub_regions.recordcount is 0>
									No regional Preference regions defined, use form below to add regions.
								<cfelse>
									<cfloop query="sub_regions">
										-- #regionname#
									</cfloop>
								</cfif>
                                <br><br>
                         	</td>
						</tr>
                        <tr>
                            <td colspan=2>
                                <h3>Add Regional Guarantees:</h3>
                                You can add as many sub-regions as you would like, seperate each with a comma (,)<br>
                                <textarea cols="40" rows="5" name="subregion"></textarea>
                            </td>
                        </tr>
						<tr><td><h3>Region Preference Fee: &nbsp; &nbsp; <input type="text" value="#get_region_info.regional_guarantee#" name="regional_guarantee" size=8></input></h3> </td></tr>
    
						<!--- This is only used by ESI --->
                        <cfif CLIENT.companyID EQ 14 OR APPLICATION.isServerLocal>
                            <tr><td><h3>Region Stipend: &nbsp; &nbsp; <input type="text" value="#get_region_info.regional_stipend#" name="regional_stipend" size=8></input></h3> </td></tr>
                        </cfif>
                 	</table>
               	</td>
            </tr>
        </table>
        
        <table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
            <tr><td align="center"><font size=-1><br><input name="submit" type="image" src="pics/update.gif" border=0></font></td></tr>
        </table>
        
    </form>
    
    <cfinclude template="../table_footer.cfm">

</cfoutput>