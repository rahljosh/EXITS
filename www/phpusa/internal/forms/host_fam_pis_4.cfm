<cfquery name="get_host_interests" datasource="mysql">
select interests, interests_other
from smg_hosts
where hostid = #client.hostid# 
</cfquery>

<cfquery name="get_interests" datasource="mysql">
select *
from smg_interests
order by interest
</cfquery>

<cfform action="querys/insert_host_fam_pis_interests.cfm" method="post">
<cfoutput>
<h2>&nbsp;&nbsp;&nbsp;&nbsp;F a m i l y &nbsp;&nbsp;&nbsp; A c t i v i t i e  s   &nbsp;&nbsp;&nbsp;  a n d&nbsp;&nbsp;&nbsp; I n t e r e  s t s <font size=-2>[ <cfoutput><a href="?curdoc=host_fam_info&hostid=#client.hostid#">overview</a></cfoutput> ] </font></h2>
<!--- body of a table --->
<table width="90%" border=1 align="center" cellpadding=8 cellspacing=8 bordercolor="##C2D1EF" bgcolor="##FFFFFF" class="section">
	<tr><td width="80%" class="box">
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
	<td width="20%" align="right" valign="top" class="box">
		<table border=0 cellpadding=2 cellspacing=0 align="right">
			<tr><td align="right"><cfinclude template="../family_pis_menu.cfm"></td></tr>
		</table> 		
	</td>
	</tr>
</table>
<!--- submit button of table --->
<table width=90% border=0 align="center" cellpadding=4 cellspacing=0 class="section">
	<tr><td align="center"><input name="Submit" type="image" src="pics/next.gif" align="middle" alt ="next" border=0></td></tr>
</table>


</cfoutput>
</cfform>