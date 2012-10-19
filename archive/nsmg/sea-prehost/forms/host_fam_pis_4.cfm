
<cfquery name="get_host_interests" datasource="MySQL">
select interests, interests_other
from smg_hosts
where hostid = #client.hostid# 
</cfquery>

<cfquery name="get_interests" datasource="MySQL">
select *
from smg_interests
order by interest
</cfquery>
<cfoutput>
<form action="forms/insert_host_fam_pis_interests.cfm?hostid=#url.hostid#" method="post">

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif">&nbsp;</td>
		<td background="pics/header_background.gif"><h2>Your Family Activites and Interests</h2></td>
		<td align="right" background="pics/header_background.gif"></td>	
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
				<td colspan="8"><textarea cols="70" rows="5" name="specific_interests" wrap="VIRTUAL"></textarea></td>
			</tr>
		</table>
	</td>
	<td width="20%" align="right" valign="top">
			
	</td>
	</tr>
</table>
<!--- submit button of table --->
<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr><td align="center"><input name="Submit" type="image" src="../pics/next.gif" align="middle" border=0></td></tr>
</table>


</cfoutput>
</form>