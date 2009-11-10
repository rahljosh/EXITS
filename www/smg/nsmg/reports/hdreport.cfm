<cfif not isDefined('url.sort')>
<cfset url.sort = 'assignid'>
</cfif>
<cfif not isDefined('url.text')>
<cfset url.text = 'no'>
</cfif>
<cfquery name="hdreport" datasource="mysql">
select assignid, title, text, category, date, helpdeskid, priority
from smg_help_desk
where status <> 'Complete'
order by #url.sort#
</cfquery>
<cfoutput>
<Cfif url.text is 'no'>
<a href="hdreport.cfm?sort=#url.sort#&text=yes">Show Text</a>
<cfelseif url.text is 'yes'>
<a href="hdreport.cfm?sort=#url.sort#&text=no">Hide Text</a>

</Cfif>
<table cellpadding=4 cellspacing=0 frame="hsides">
	<tr>
		<td><A href="hdreport.cfm?sort=helpdeskid">ID</A></td><td><A href="hdreport.cfm?sort=assignid">Assigned</A></td><Td><A href="hdreport.cfm?sort=priority">Priority</Td><td><A href="hdreport.cfm?sort=title">Title</td><td><A href="hdreport.cfm?sort=category">Category</td><td><A href="hdreport.cfm?sort=date">Date</td><cfif url.text is 'yes'><td>Text</td></cfif>
	</tr>
<cfloop query="hdreport">
	<tr <cfif hdreport.currentrow mod 2>bgcolor=cccccc</cfif>>
	<Cfquery name="username" datasource="MySQL">
	select firstname from smg_users
	where userid = #assignid#
	</Cfquery>
		<td>#helpdeskid#</td><td>#username.firstname#</td><Td>#priority#</Td><td>#title#</td><td>#category#</td><td>#DateFormat(date, 'mm/dd/yyyy')#</td><cfif url.text is 'yes'><td>#text#</td></cfif>
	</tr>
</cfloop>
</table>
</cfoutput>