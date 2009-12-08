<!--- Kill Extra Output --->
<cfsilent>

    <cfinclude template="../querys/get_regions.cfm">
    
    <cfinclude template="../querys/get_programs.cfm">
    
    <cfquery name="qGetSeasons" datasource="MySql">
        SELECT 
        	seasonid, 
            season
        FROM 
        	smg_seasons
        WHERE 
        	active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
    </cfquery>
    
    <!--- CBCs NEEDS TO BE RUN - COUNT --->
    <cfquery name="qGetHostCBCs" datasource="MySql">
        SELECT DISTINCT 
            count(cbc.cbcfamid) as total, 
            cbc.cbc_type, 
            smg_seasons.season
        FROM 
        	smg_hosts_cbc cbc
        INNER JOIN 
        	smg_hosts h ON h.hostid = cbc.hostid
        INNER JOIN 
        	smg_seasons ON smg_seasons.seasonid = cbc.seasonid
        WHERE 
        	cbc.date_sent IS NULL 
        AND 
        	requestid = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
        <cfif NOT ListFind("1,2,3,4,5", CLIENT.companyID)>
        AND 
        	cbc.companyid = <cfqueryparam value="#CLIENT.companyid#" cfsqltype="cf_sql_integer">
        </cfif>
        GROUP BY 
        	cbc.cbc_type, cbc.seasonid
        ORDER BY 
        	cbc.seasonid
    </cfquery>
    
    <cfquery name="qGetUserCBCs" datasource="MySql">
        SELECT 
        	DISTINCT count(cbc.cbcid) as total, 
            smg_seasons.season
        FROM 
        	smg_users_cbc cbc
        INNER JOIN 
        	smg_users u ON u.userid = cbc.userid
        INNER JOIN 
        	smg_seasons ON smg_seasons.seasonid = cbc.seasonid
        WHERE 
        	cbc.date_sent IS NULL 
        <cfif NOT ListFind("1,2,3,4,5", CLIENT.companyID)>
        AND 
        	cbc.companyid = <cfqueryparam value="#CLIENT.companyid#" cfsqltype="cf_sql_integer">
        </cfif>
        GROUP BY 
        	cbc.seasonid
        ORDER BY 
        	cbc.seasonid
    </cfquery>

</cfsilent>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>CBC Menu</title>
</head>

<body>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/helpdesk.gif"></td>
		<td background="pics/header_background.gif"><h2>CBC BATCH INTERFACE</h2></td>
		<td background="pics/header_background.gif" align="right">
			<cfif NOT IsDefined('url.all')>
				<a href="?curdoc=cbc/cbc_menu&all=1">Show All Programs</a>
			<cfelse>
				<a href="?curdoc=cbc/cbc_menu">Show Active Programs Only</a>
			</cfif>
		</td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfoutput>
<table width=100% border=0 cellpadding=4 cellspacing=0 class="section">
<tr><td>

<table width=100% border=0 cellpadding=4 cellspacing=0>
	<tr>
		<td align="center" width="50%" valign="top">
			<cfform action="cbc/create_xml_users_gis.cfm" method="POST" target="blank">
			<Table cellpadding=6 cellspacing="0" align="center" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">GIS - Office and Reps</th></tr>
				<tr align="left">
					<TD width="15%">Usertype :</td>
					<TD><cfselect name="usertype">			
						<option value="">Select a usertype</option>
						<option value="user">Office & Reps</option>
						<option value="member">Reps Family Members</option>
						</cfselect>
					</td>
				</tr>
				<tr align="left">
					<TD width="15%">Season :</td>
					<TD><cfselect name="seasonid" query="qGetSeasons" display="season" value="seasonid" queryPosition="below">			
						<option value=0>Select a season</option>
						</cfselect>
					</td>
				</tr>
				<tr>
					<td colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
				</tr>
			</table><br>
			</cfform>
		</td>
		<td align="center" width="50%" valign="top">
			<cfform action="cbc/create_xml_hosts_gis.cfm" method="POST" target="blank">
			<Table cellpadding=6 cellspacing="0" align="center" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">GIS - Host Family and Members</th></tr>
				<tr align="left">
					<TD width="15%">Usertype :</td>
					<TD><cfselect name="usertype">			
						<option value=0>Select an usertype</option>
						<option value="father">Host Father</option>
						<option value="mother">Host Mother</option>
						<option value="member">Host Members</option>
						</cfselect>
					</td>
				</tr>
				<tr align="left">
					<TD width="15%">Season :</td>
					<TD><cfselect name="seasonid" query="qGetSeasons" display="season" value="seasonid" queryPosition="below">			
						<option value=0>Select a season</option>
						</cfselect>
					</td>
				</tr>
				<tr>
					<td colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
				</tr>
			</table><br>
			</cfform>
		</td>
	</tr>
</table>

<table width=100% border=0 cellpadding=4 cellspacing=0>
	<tr>
		<td align="center" width="50%" valign="top">
			<cfform action="cbc/create_xml_users_nossn.cfm" method="POST" target="blank">
			<Table cellpadding=6 cellspacing="0" align="center" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">GIS US SEARCH - NO SSN - Office and Reps</th></tr>
				<tr align="left">
					<TD width="15%">Usertype :</td>
					<TD><cfselect name="usertype">			
						<option value=0>Select an usertype</option>
						<option value="1">Office</option>
						<option value="2">Reps (Man., Adv. and Area)</option>
						<option value="3">Reps Family</option>
						</cfselect>
					</td>
				</tr>
				<tr align="left">
					<TD width="15%">Season :</td>
					<TD><cfselect name="seasonid" query="qGetSeasons" display="season" value="seasonid" queryPosition="below">			
						<option value=0>Select a season</option>
						</cfselect>
					</td>
				</tr>
				<tr>
					<td colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
				</tr>
			</table><br>
			</cfform>
		</td>
		<td align="center" width="50%" valign="top">
			<cfform action="cbc/create_xml_hosts_nossn.cfm" method="POST" target="blank">
			<Table cellpadding=6 cellspacing="0" align="center" width="100%">
					<tr><th colspan="2" bgcolor="e2efc7">GIS US SEARCH - NO SSN - Host Family and Members</th></tr>
				<tr align="left">
					<TD width="15%">Usertype :</td>
					<TD><cfselect name="usertype">			
						<option value=0>Select an usertype</option>
						<option value="father">Host Father</option>
						<option value="mother">Host Mother</option>
						<option value="member">Host Members</option>
						</cfselect>
					</td>
				</tr>
				<tr align="left">
					<TD width="15%">Season :</td>
					<TD><cfselect name="seasonid" query="qGetSeasons" display="season" value="seasonid" queryPosition="below">			
						<option value=0>Select a season</option>
						</cfselect>
					</td>
				</tr>
				<tr>
					<td colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
				</tr>
			</table><br>
			</cfform>
		</td>
	</tr>
</table>



<!--- NEEDS TO BE SUBMITTED - COUNT --->
<table width=100% border=0 cellpadding=4 cellspacing=0>
	<tr>
		<td align="center" width="50%" valign="top">
			<Table cellpadding=6 cellspacing="0" align="center" width="100%">
				<tr><th colspan="3" bgcolor="e2efc7">Users CBCs to be submitted</th></tr>
				<tr><th>Season</th><th>CBC Type</th><th>Total</th></tr>
				<cfif qGetUserCBCs.recordcount>
					<cfloop query="qGetUserCBCs">
						<tr><td align="center">#season#</td><td align="center">n/a</td><td align="center">#total#</td></tr>
					</cfloop>	
				<cfelse>
					<tr><td colspan="3" align="center">There are no CBCs to be submitted at this time.</td></tr>
				</cfif>
			</table><br>
		</td>
		<td align="center" width="50%" valign="top">
			<Table cellpadding=6 cellspacing="0" align="center" width="100%">
				<tr><th colspan="3" bgcolor="e2efc7">Host Family and Members CBCs to be submitted</th></tr>
				<tr><th>Season</th><th>CBC Type</th><th>Total</th></tr>
				<cfif qGetHostCBCs.recordcount>
					<cfloop query="qGetHostCBCs">
						<tr><td align="center">#season#</td><td align="center">#cbc_type#</td><td align="center">#total#</td></tr>
					</cfloop>
				<cfelse>
					<tr><td colspan="3" align="center">There are no CBCs to be submitted at this time.</td></tr>
				</cfif>
			</table><br>
		</td>
	</tr>
</table><br><br>

<table width=100% border=0 cellpadding=4 cellspacing=0>
	<tr>
		<td align="center" width="50%" valign="top">
			<cfform action="cbc/create_xml_users.cfm" method="POST" target="blank">
			<Table cellpadding=6 cellspacing="0" align="center" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">Intellicorp - CBC Batch - Office and Reps</th></tr>
				<tr align="left">
					<TD width="15%">Usertype :</td>
					<TD><cfselect name="usertype">			
						<option value=0>Select an usertype</option>
						<option value="1">Office</option>
						<option value="2">Reps (Man., Adv. and Area)</option>
						<option value="3">Reps Family</option>
						</cfselect>
					</td>
				</tr>
				<tr align="left">
					<TD width="15%">Season :</td>
					<TD><cfselect name="seasonid" query="qGetSeasons" display="season" value="seasonid" queryPosition="below">			
						<option value=0>Select a season</option>
						</cfselect>
					</td>
				</tr>
				<tr>
					<td colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
				</tr>
			</table><br>
			</cfform>
		</td>
		<td align="center" width="50%" valign="top">
			<cfform action="cbc/create_xml_hosts.cfm" method="POST" target="blank">
			<Table cellpadding=6 cellspacing="0" align="center" width="100%">
					<tr><th colspan="2" bgcolor="e2efc7">Intellicorp - CBC Batch - Host Family and Members</th></tr>
				<tr align="left">
					<TD width="15%">Usertype :</td>
					<TD><cfselect name="usertype">			
						<option value=0>Select an usertype</option>
						<option value="father">Host Father</option>
						<option value="mother">Host Mother</option>
						<option value="member">Host Members</option>
						</cfselect>
					</td>
				</tr>
				<tr align="left">
					<TD width="15%">Season :</td>
					<TD><cfselect name="seasonid" query="qGetSeasons" display="season" value="seasonid" queryPosition="below">			
						<option value=0>Select a season</option>
						</cfselect>
					</td>
				</tr>
				<tr>
					<td colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
				</tr>
			</table><br>
			</cfform>
		</td>
	</tr>
</table>

<table width=100% border=0 cellpadding=4 cellspacing=0>
	<tr><th colspan="2" bgcolor="e2efc7">R E P O R T S</th></tr>
	<tr>
		<td align="center" width="50%" valign="top">
			<cfform action="cbc/rp_users_searches.cfm" method="POST" target="blank">
			<Table cellpadding=6 cellspacing="0" align="center" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">Office, Rep and Rep's Family Member CBCs (Authorization Received)</th></tr>
				<tr align="left">
					<TD width="15%">Usertype :</td>
					<TD><cfselect name="usertype">			
						<option value=0 selected>All</option>
						<option value="1">Office</option>
						<option value="2">Reps</option>
						<option value="3">Reps Family</option>
						</cfselect>
					</td>
				</tr>				
				<tr align="left">
					<TD width="15%">Status :</td>
					<TD><cfselect name="status">			
						<option value=0 selected>All</option>
						<option value="1">Completed</option>
						<option value="2">Pending</option>
						</cfselect>
					</td>
				</tr>				
				<tr>
					<td colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
				</tr>
			</table><br>
			</cfform>
		</td>
		<td align="center" width="50%" valign="top">
			<cfform action="cbc/rp_host_searches.cfm" method="POST" target="blank">
			<Table cellpadding=6 cellspacing="0" align="center" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">Hosts and Other Family Members CBCs (Authorization Received)</th></tr>
				<tr align="left">
					<TD width="15%">Usertype :</td>
					<TD><cfselect name="usertype">			
						<option value=0 selected>All</option>
						<option value="1">Host Parents</option>
						<option value="2">Other Members</option>
						</cfselect>
					</td>
				</tr>				
				<tr align="left">
					<TD width="15%">Status :</td>
					<TD><cfselect name="status">			
						<option value=0 selected>All</option>
						<option value="1">Completed</option>
						<option value="2">Pending</option>
						</cfselect>
					</td>
				</tr>				
				<tr>
					<td colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
				</tr>
			</table><br>
			</cfform>
		</td>
	</tr>
</table><br>

<table width=100% border=0 cellpadding=4 cellspacing=0>
	<tr>
		<td align="center" width="50%" valign="top">
			<cfform action="cbc/rp_hosts_auth_not_rec.cfm" method="POST" target="blank">
			<Table cellpadding=6 cellspacing="0" align="center" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">Hosts - Authorization not received (Current placing/assigned to student)</th></tr>
				<tr align="left">
					<TD width="15%">Usertype :</td>
					<TD><cfselect name="usertype">			
						<option value="1">Host Parents</option>
						</cfselect>
					</td>
				</tr>
				<tr align="left">
					<td>Region :</td>
					<td><cfselect name="regionid" multiple size="4">
						<cfif CLIENT.usertype LTE 4><option value=0 selected="selected">All Regions</option></cfif>
						<cfloop query="get_regions"><option value="#regionid#">#regionname#</option></cfloop>
						</cfselect>
					</td>
				</tr>												
				<tr align="left">
					<TD width="15%">Season :</td>
					<TD><cfselect name="seasonid" query="qGetSeasons" display="season" value="seasonid" queryPosition="below">			
						<option value=0>Select a season</option>
						</cfselect>
					</td>
				</tr>
				<tr>
					<td colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
				</tr>
			</table><br>
			</cfform>
		</td>
		<td align="center" width="50%" valign="top">
			<cfform action="cbc/rp_hosts_auth_prog.cfm" method="POST" target="blank">
			<Table cellpadding=6 cellspacing="0" align="center" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">Hosts - Authorization not received (Current placing/assigned to student)</th></tr>
				<tr align="left">
					<TD width="15%">Usertype :</td>
					<TD><cfselect name="usertype">			
						<option value="1">Host Parents</option>
						</cfselect>
					</td>
				</tr>
				<tr align="left">
					<td>Region :</td>
					<td><cfselect name="regionid" multiple size="4">
						<option value=0 selected="selected">All Regions</option>
						<cfloop query="get_regions"><option value="#regionid#">#regionname#</option></cfloop>
						</cfselect>
					</td>
				</tr>	
				<tr align="left">
					<TD width="15%">Program :</td>
					<TD><cfselect name="programid" multiple size="4">			
							<cfloop query="get_program">
								<option value="#ProgramID#"><cfif CLIENT.companyid EQ '5'>#get_program.companyshort# - </cfif>#programname#</option>
							</cfloop>
						</cfselect>
					</td>
				</tr>
				<tr>
					<td colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
				</tr>
			</table><br>
			</cfform>	
		</td>
	</tr>
</table><br>

<table width=100% border=0 cellpadding=4 cellspacing=0>
	<tr>
		<td align="center" width="50%" valign="top">
			<cfform action="cbc/rp_members_auth_not_rec.cfm" method="POST" target="blank">
			<Table cellpadding=6 cellspacing="0" align="center" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">Host Members 18+ living with Parents - Authorization not received</th></tr>
				<tr align="left">
					<TD width="15%">Usertype :</td>
					<TD><cfselect name="usertype">			
						<option value="1">Other Members</option>
						</cfselect>
					</td>
				</tr>
				<tr align="left">
					<td>Region :</td>
					<td><cfselect name="regionid" multiple size="4">
						<cfif CLIENT.usertype LTE 4><option value=0 selected="selected">All Regions</option></cfif>
						<cfloop query="get_regions"><option value="#regionid#">#regionname#</option></cfloop>
						</cfselect>
					</td>
				</tr>												
				<tr align="left">
					<TD width="15%">Season :</td>
					<TD><cfselect name="seasonid" query="qGetSeasons" display="season" value="seasonid" queryPosition="below">			
						<option value=0>Select a season</option>
						</cfselect>
					</td>
				</tr>
				<tr>
					<td colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
				</tr>
			</table><br>
			</cfform>
		</td>
		<td align="center" width="50%" valign="top">
			<cfform action="cbc/rp_members_auth_prog.cfm" method="POST" target="blank">
			<Table cellpadding=6 cellspacing="0" align="center" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">Host Members 18+ living with Parents - Authorization not received</th></tr>
				<tr align="left">
					<TD width="15%">Usertype :</td>
					<TD><cfselect name="usertype">			
						<option value="1">Host Parents</option>
						</cfselect>
					</td>
				</tr>
				<tr align="left">
					<td>Region :</td>
					<td><cfselect name="regionid" multiple size="4">
						<cfif CLIENT.usertype LTE 4><option value=0 selected="selected">All Regions</option></cfif>
						<cfloop query="get_regions"><option value="#regionid#">#regionname#</option></cfloop>
						</cfselect>
					</td>
				</tr>												
				<tr align="left">
					<TD width="15%">Program :</td>
					<TD><cfselect name="programid" multiple size="4">			
							<cfloop query="get_program">
								<option value="#ProgramID#"><cfif CLIENT.companyid EQ '5'>#get_program.companyshort# - </cfif>#programname#</option>
							</cfloop>
						</cfselect>
					</td>
				</tr>
				<tr>
					<td colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
				</tr>
			</table><br>
			</cfform>	
		</td>
	</tr>
</table><br>

<table width=100% border=0 cellpadding=4 cellspacing=0>
	<tr>
		<td align="center" width="50%" valign="top">
			<cfform action="cbc/rp_users_auth_not_rec.cfm" method="POST" target="blank">
			<Table cellpadding=6 cellspacing="0" align="center" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">Active Users - CBC Authorization Form Not Received</th></tr>
				<tr align="left">
					<TD width="15%">Usertype :</td>
					<TD><cfselect name="usertype">			
						<!--- <option value=0 selected>All</option> --->
						<option value="1">Office</option>
						<option value="2">Reps</option>
						<!--- <option value="3">Reps Family</option> --->
						</cfselect>
					</td>
				</tr>	
				<tr align="left">
					<td>Region :</td>
					<td><select name="regionid" size="1">
						<option value=0>All Regions</option>
						<cfloop query="get_regions"><option value="#regionid#">#regionname#</option></cfloop>
						</select>
					</td>
				</tr>								
				<tr><td></td><td><input type="checkbox" disabled></td></tr>
				<tr>
					<td colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
				</tr>
			</table><br>
			</cfform>
		</td>
		<td align="center" width="50%" valign="top">
			<!--- available --->
		</td>
	</tr>
</table><br><br>

</td></tr>
</table>

</cfoutput>

<!----footer of table --- new message ---->
<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign="bottom">
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table><br>

<!---
<cfif CLIENT.userid eq 510>

CFINVOKE EXAMPLE

<cfscript>
ws = CreateObject("webservice", "http://getanagram.com/wsdevel.wsdl");
ws.GetTypeScores(text='123 456 7890',ContactScore="ContactScore",EventScore="EventScore");
</cfscript>
Contact Score: <cfdump var="#ContactScore#" /><br>
Event Score: <cfdump var="#EventScore#" /> 

<cfinvoke webservice="http://getanagram.com/wsdevel.wsdl" method="GetTypeScores" returnvariable="foo">
	<cfinvokeargument name="text" value="123 456 7890"/>
</cfinvoke>

Output: <cfoutput>#foo#</cfoutput> 
</cfif>
--->

</body>
</html>