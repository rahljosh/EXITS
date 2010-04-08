<cfquery name="web_contacts" datasource="caseusa">
select *, smg_states.statename
from case_web_contacts
LEFT JOIN smg_states on smg_states.id = case_web_contacts.state
order by date_entered desc, contact_type
</cfquery>
<cfoutput>
<!----
<cfdump var="#web_contacts#">
---->
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24 bgcolor=##ffffff>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=30 background="pics/header_background.gif"><img src="pics/family.gif"></td>
		<td background="pics/header_background.gif"><h2>Web Contacts </td>
		<td background="pics/header_background.gif" align="right">
			
				#web_contacts.recordcount# contacts shown</center>
		</td>
	<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
</tr>
</table> 



<div class="scroll">
<table  border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
	<tr>
		<td >ID</a></td>
		<td>Last Name</a></td>
		<td >First Name</a></td>
		<td > City</a></td>
		<td > State</a></td>
        <td > Country</a></td>
        <td > Type</a></td>
        
	</tr>
	<cfloop query="web_contacts">
	<tr bgcolor="#iif(web_contacts.currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#">
		<td width=30><a href="?curdoc=web_contact_info&id=#contactid#">#contactid#</a></td>
		<td width=100><a href="?curdoc=web_contact_info&id=#contactid#">#lastname#</a></td>
		<td width=90><a href="?curdoc=web_contact_info&id=#contactid#">#firstname#</a></td>
		<td width=90>#city#</a></td>
		<td width=30> #statename#</td>
        <td width=30>#country#</td>
         <td width=30>#contact_type#</td>
	</tr>
	</cfloop>
</table>
</div>

<table width=100% bgcolor="ffffe6" class="section">
	<tr><td align="center"><form action="index.cfm?curdoc=forms/host_fam_pis" method="post"><input type="submit" value="   Add Host Family - PIS  "></form></td></tr>
</table>
</cfoutput>

<cfinclude template="table_footer.cfm">
