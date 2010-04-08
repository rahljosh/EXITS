<cfif IsDefined('url.active')>
	<cfset url.active = '#url.active#'>
<cfelse>
	<cfset url.active = '1'>
</cfif>

<cfquery name="get_pics" datasource="caseusa">
	SELECT pictureid, title, description, active
	FROM smg_pictures
	WHERE 1=1 <cfif url.active is not 'all'>AND active = '#url.active#'</cfif>
	ORDER BY pictureid
</cfquery>

<cfform name="pictures" method="post" action="?curdoc=tools/smg_welcome_pictures_qr">
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/news.gif"></td>
		<td background="pics/header_background.gif"><h2>Welcome Pictures</h2></td><td background="pics/header_background.gif" width=16></td>
		<td background="pics/header_background.gif" align="right"><font size=-1>[ 
			<cfif url.active is "1"><span class="edit_link_selected"><cfelse><span class="edit_link"></cfif><a href="?curdoc=tools/smg_welcome_pictures&active=1">Active</a></span> &middot; 			
			<cfif url.active is "0"><span class="edit_link_selected"><cfelse><span class="edit_link"></cfif><a href="?curdoc=tools/smg_welcome_pictures&active=0">Inactive</a></span> &middot; 			
			<cfif url.active is "all"><span class="edit_link_selected"><cfelse><span class="edit_link"></cfif><a href="?curdoc=tools/smg_welcome_pictures&active=all">All</a></span> ] </td>		
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table cellpadding="3" cellspacing="0" bgcolor="ffffe6" width=100% class="section">
	<cfinput type="hidden" name="count" value="#get_pics.recordcount#">
	<cfif IsDefined('url.edit')>
		<cfoutput query="get_pics">
			<cfinput type="hidden" name="pictureid#get_pics.currentrow#" value="#pictureid#">
			<tr><td align="center"><b>ID:</b> #pictureid#</td>
				<td valign="top"><b>Title: &nbsp;</b> <cfinput type="text" name="title#get_pics.currentrow#" size="70" value="#title#"></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td valign="top"><b>Description: &nbsp;<br></b> <textarea name="description#get_pics.currentrow#" cols="90" rows="7">#Description#</textarea></td>
				<td width="120" align="center" valign="top"><img src="pics/welcome_pics/#pictureid#.jpg" border=0 height="80" width="100"></td>
				<td width="60" align="center" valign="top"><b>Status:</b>
					<cfselect name="active#get_pics.currentrow#">
						<option value="1" <cfif active is '1'>selected</cfif>>Active</option>
						<option value="0" <cfif active is '0'>selected</cfif>>Inactive</option>
					</cfselect>
				</td></tr>
			<tr><td colspan="2">&nbsp;</td></tr>
		</cfoutput>
	<cfelse>
		<cfoutput query="get_pics">
			<tr><td width="60" align="center" valign="top"><b>ID:</b> #pictureid#</td>
				<td valign="top" colspan="3"><b>Title: &nbsp;</b><i>#title#</i></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td valign="top"><div align="justify"><b>Description: &nbsp;</b> #Description#</div></td>
				<td width="120" align="center" valign="top"><img src="uploadedfiles/welcome_pics/#pictureid#.jpg" border=0 height="80" width="100"></td>
				<td width="60" align="center" valign="top"><b>Status:<br></b>
					<cfif active is '1'>Active<cfelse>Inactive</cfif></td></tr>
			<tr><td colspan="2">&nbsp;</td></tr>
		</cfoutput>
	</cfif>
	<tr><td colspan="7" align="center">
		<cfoutput>
		<cfif IsDefined('url.edit')>
			<cfinput name="Submit" type="image" src="pics/update.gif" border=0>
		<cfelse>
			<a href="?curdoc=tools/add_smg_welcome_pic"><img src="pics/new.gif" border="0"></a>
			&nbsp; &nbsp; &nbsp; &nbsp;
			<a href="?curdoc=tools/smg_welcome_pictures&active=#url.active#&edit=1"><img src="pics/edit.gif" border="0"></a>
		</cfif>
		</cfoutput>
	</td></tr>
</table>

</cfform>
	
<!----footer tale---->
<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>