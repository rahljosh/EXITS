<cfif #client.usertype# is not '1'>
	<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
		<tr valign=middle height=24>
			<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
			<td width=26 background="pics/header_background.gif"><img src="pics/helpdesk.gif"></td>
			<td background="pics/header_background.gif"><h2>Help Desk - Error </h2></td>
			<td width=17 background="pics/header_rightcap.gif">&nbsp;</td></tr>
	</table>
	<table width=100% border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td align="center"><br><div align="justify"><h3><p>Ooops! &nbsp; You do not have sufficient rights to edit sections.</p></td></tr>
	<tr><td align="center"><a href="?curdoc=helpdesk/help_desk_list"><img src="pics/back.gif" border="0"></img></a></td></tr>
	</table>
	<table width=100% cellpadding=0 cellspacing=0 border=0>
		<tr valign="bottom"><td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
			<td width=100% background="pics/header_background_footer.gif"></td>
			<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td></tr>
	</table>
	<cfabort>
</cfif>

<Cfquery name="sections" datasource="caseusa">
	SELECT sectionid, sectionname, assignedid
	FROM smg_help_desk_section
	WHERE systemid = '1' <!--- EXITS --->
	ORDER BY sectionname
</Cfquery>

<!---- list users --->
<cfquery name="support" datasource="caseusa">
	SELECT firstname, lastname, userid
	FROM smg_users
	WHERE usertype = '1'
	ORDER BY firstname
</cfquery>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/helpdesk.gif"></td>
		<td background="pics/header_background.gif"><h2>Help Desk - Sections Maintenance</h2></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td></tr>
</table>

<cfoutput>
<table width=100% border=0 cellpadding=4 cellspacing=0 class="section">

<cfif #cgi.http_referer# NEQ ''>
	<tr><td align="center"><span class="get_Attention"><b>Sections Updated</b></span></td></tr>
</cfif>

<cfform method=post action="?curdoc=helpdesk/update_help_desk_sections">
<input type="hidden" name="count" value="#sections.recordcount#">
<tr><td>
	<table div align="center" cellpadding= 4 cellspacing=0 width="80%">
		<tr bgcolor="00003C">
			<td width="50%"><font color="white">Section Name</font></td>
			<td width="50%"><font color="white">Assigned To</font></td>
		</tr>
		<cfloop query="sections">
		<tr bgcolor="#iif(sections.currentrow MOD 2 ,DE("ffffe6") ,DE("e2efc7") )#">
			<td>#sections.sectionname#<input type="hidden" name="#sections.currentrow#_sectionid" value="#sections.sectionid#"></td>
			<td><select name="#sections.currentrow#_userid">
				<option value="0"></option>
				<cfset supportid = #sections.assignedid#>
				<cfset current_row = #sections.currentrow#>
				<cfloop query="support">
					<cfif support.userid is supportid>
						<option value="#support.userid#" selected>#support.firstname# #support.lastname#</option>
					<cfelse>
						<option value="#support.userid#">#support.firstname# #support.lastname#</option>
					</cfif>
				</cfloop>
				</select></td>
		</tr>
		</cfloop>
		<Tr>
		<td><input name="Submit" type="image" src="pics/update.gif" border=0></td></cfform>
		<td><form action="index.cfm?curdoc=forms/" method="post"><input type="submit" value="   Add Section   " disabled></form></td>
		</Tr>
	</table>
</td></tr>
</table>

<!----footer of table --- new message ---->
<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign="bottom">
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>
</cfoutput>