
<cfquery name="get_host_interests" datasource="caseusa">
select interests, interests_other
from smg_hosts
where hostid = #client.hostid# 
</cfquery>

<cfquery name="get_interests" datasource="caseusa">
select *
from smg_interests
order by interest
</cfquery>

<form action="querys/insert_host_fam_pis_interests.cfm" method="post">
<cfoutput>
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/family.gif"></td>
		<td background="pics/header_background.gif"><h2>Family Activites and Interests</h2></td>
		<td align="right" background="pics/header_background.gif"><span class="edit_link">[ <cfoutput><a href="?curdoc=host_fam_info&hostid=#client.hostid#">overview</a></cfoutput> ]</span></td>	
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>
<!--- body of a table --->
<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td width="80%">
		<table border=0 cellpadding=2 cellspacing=0 align="left">
			<tr><cfloop query="get_interests">	
					<td><input type="checkbox" name="interest" value='#interestid#' <cfif ListFind(get_host_interests.interests, interestid , ",")>checked<cfelse></cfif>> </td><td>#interest#</td>
					<cfif (get_interests.currentrow MOD 4 ) is 0></tr><tr></cfif>
				</cfloop>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="8">Other Interests:</td></tr>
			<tr>
				<td colspan="8"><textarea cols="70" rows="5" name="specific_interests" wrap="VIRTUAL">#get_host_interests.interests_other#</textarea></td>
			</tr>
		</table>
	</td>
	<td width="20%" align="right" valign="top">
		<table border=0 cellpadding=2 cellspacing=0 align="right">
			<tr><td align="right"><cfinclude template="../family_pis_menu.cfm"></td></tr>
		</table> 		
	</td>
	</tr>
</table>
<!--- submit button of table --->
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
</form>