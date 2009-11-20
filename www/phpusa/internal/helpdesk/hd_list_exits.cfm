<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfif NOT isDefined("url.status")>
	<cfset url.status = "initial">
</cfif>

<cfif NOT IsDefined('url.order')>
	<cfset url.order = 'assign.firstname, priority DESC, date, status'>
</cfif>

<cfquery name="help_desk_list" datasource="MySql">
	SELECT helpdeskid, title, category, section, priority, text, status, date, submitid, assignid, smg_help_desk.studentid,
		submit.firstname as submit_firstname, submit.lastname as submit_lastname, submit.businessname,
		assign.firstname as assign_firstname, assign.lastname as assign_lastname,
		s.firstname as stufirst, s.familylastname as stulast
	FROM smg_help_desk
	LEFT JOIN smg_users submit ON smg_help_desk.submitid = submit.userid
	LEFT JOIN smg_users assign ON smg_help_desk.assignid = assign.userid
	LEFT JOIN smg_students s ON smg_help_desk.studentid = s.studentid
	WHERE section = '11'
		AND smg_help_desk.companyid <= '5'
	<cfif url.status EQ 'initial'>
		AND status != 'closed'	
	<cfelseif url.status EQ 'closed'>
		AND status = '#url.status#'	
	</cfif>
	ORDER BY #url.order#
</cfquery>

<style type="text/css">
<!--
div.scroll {
	height: 300px;
	width:auto;
	overflow:auto;
	border-left: 2px solid #c6c6c6;
	border-right: 2px solid #c6c6c6;
	background: #Ffffe6;
}
div.scroll2 {
	height: 180px;
	width:auto;
	overflow:auto;
	border-left: 2px solid #c6c6c6;
	border-right: 2px solid #c6c6c6;
	background: #Ffffe6;
	left:auto;
}
div.box2 {
	height: 180px;
	width:auto;
	border-left: 2px solid #c6c6c6;
	border-right: 2px solid #c6c6c6;
	background: #Ffffe6;
}
-->
</style>

<cfoutput>
<!--- HEADER OF TABLE --- ALL ITEMS --->
<table width=100% cellpadding=0 cellspacing=0 border=0 height="24"> 
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/helpdesk.gif"></td>
		<td background="pics/header_background.gif"><h2>SMG EXITS - Tickets</h2></td>
		<td background="pics/header_background.gif" align="right">
			&nbsp; &nbsp;
			<font size=-1> 
			[ <cfif url.status is "initial"><span class="edit_link_selected"><cfelse><span class="edit_link"></cfif>
			<a href="?curdoc=helpdesk/hd_list_exits&status=initial">Open</a></span> &middot; 
			<cfif url.status is "closed"><span class="edit_link_selected"><cfelse><span class="edit_link"></cfif>
			<a href="?curdoc=helpdesk/hd_list_exits&status=closed">Closed</a></span> &middot;
			<cfif url.status is "all"><span class="edit_link_selected"><cfelse><span class="edit_link"></cfif>
			<a href="?curdoc=helpdesk/hd_list_exits&status=all">All</a></span> ]
			&nbsp; #help_desk_list.recordcount# message(s) displayed</font>		
		</td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>
</cfoutput>
<!--- BODY OF TABLE --- ALL ITEMS --->

<table border=0 cellpadding=3 cellspacing=0 class="section" width=100%>
	<tr>
		<cfoutput>	
		<td width="4%"><a href="?curdoc=helpdesk/hd_list_exits&status=#url.status#&order=helpdeskid"><u>ID</u></a></td>
		<td width="23%"><a href="?curdoc=helpdesk/hd_list_exits&status=#url.status#&order=title"><u>Subject</u></a></td>
		<td width="13%"><a href="?curdoc=helpdesk/hd_list_exits&status=#url.status#&order=category"><u>Category</u></a></td>
		<td width="8%"><a href="?curdoc=helpdesk/hd_list_exits&status=#url.status#&order=priority"><u>Priority</u></a></td>
		<td width="8%"><a href="?curdoc=helpdesk/hd_list_exits&status=#url.status#&order=status"><u>Status</u></a></td>
		<td width="15%"><a href="?curdoc=helpdesk/hd_list_exits&status=#url.status#&order=submit_firstname"><u>Submitted by</u></a></td>
		<td width="15%"><a href="?curdoc=helpdesk/hd_list_exits&status=#url.status#&order=assign_firstname"><u>Assigned To</u></a></td>
		<td width="10%"><a href="?curdoc=helpdesk/hd_list_exits&status=#url.status#&order=date"><u>Date</u></a></td>
		<td width="1%"></td>
		</cfoutput>
	</tr>
</table>

<div class="scroll">
	<table width="100%" border=0 cellpadding=3 cellspacing=0 >
	<cfif help_desk_list.recordcount is not 0>
		<cfoutput query="help_desk_list">
		<cfquery name="check_sub_items" datasource="MySql">
			SELECT itemsid, u.usertype
			FROM smg_help_desk_items
			INNER JOIN smg_users u ON submitid = userid
			WHERE helpdeskid = '#help_desk_list.helpdeskid#'
			ORDER BY itemsid DESC limit 1	
		</cfquery>
			<cfif status is 'initial'><cfset color="green"></cfif>
			<cfif status is 'info'><cfset color="663366"></cfif>
			<cfif status is 'reviewing'><cfset color="red"></cfif>
			<cfif status is 'closed'><cfset color="blue"></cfif>
			<cfif #DateDiff('d',date, now())# GT 15 and status is not 'closed'>
			<tr bgcolor="FFC4C5">
			<cfelse>
			<tr bgcolor="#iif(help_desk_list.currentrow MOD 2 ,DE("ffffe6") ,DE("e2efc7") )#">
			</cfif>
				<td width="4%" align="left"><a href="?curdoc=helpdesk/help_desk_view&helpdeskid=#helpdeskid#">#helpdeskid#</a></td>
				<td width="21%"><a href="?curdoc=helpdesk/help_desk_view&helpdeskid=#helpdeskid#">#title#</a><cfif check_sub_items.recordcount is not 0 and check_sub_items.usertype GT '1' <!--- and help_desk_list.status is 'info' --->><img src="pics/responsesmall.gif" border="0"></cfif></td>
				<td width="15%"><font color="#color#">#category#</font></td>
				<td width="8%"><font color="#color#">#priority#</font></td>
				<td width="8%"><font color="#color#">#status#</font></td>
				<td width="15%"><font color="#color#">
					<cfif submitid EQ '0'>
						SMG EXITS
					<cfelseif studentid EQ '0'>
						#submit_firstname# #submit_lastname#
					<cfelse>
						Student: #stufirst# #stulast#
					</cfif></font></td>
				<td width="15%"><font color="#color#">#assign_firstname# #assign_lastname#</font></td>
				<td width="10%"><font color="#color#">#DateFormat(date, 'mm-dd-yyyy')#</font></td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr><td colspan="6" bgcolor="ffffe6"><cfoutput>At the moment there are no "#url.status#" messages</cfoutput></td></tr>
	</cfif>
	</table>
</div>
<table width="100%" class="section">
	<tr><td width="28%" bgcolor="ffc4c5">&nbsp; * Tickets older than 15 days.</td><td width="72%"></td></tr>	
</table>

<!----footer of table --- ALL ITEMS---->
<cfinclude template="../table_footer.cfm">