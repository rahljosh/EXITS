<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!-----User Information----->
<cfinclude template="../querys/get_user_info.cfm">

<cfif not isdefined('url.helpdeskid') or url.helpdeskid EQ ''><br>
	<cfinclude template="../forms/error_message.cfm">
</cfif>

<cfquery name="help_desk_principal" datasource="caseusa">
	SELECT helpdeskid, title, category, priority, text, section, status, date, submitid, assignid, smg_help_desk.studentid,
		submit.firstname as submit_firstname, submit.lastname as submit_lastname, submit.businessname,
		assign.firstname as assign_firstname, assign.lastname as assign_lastname,
		sectionname,
		s.firstname as stufirst, s.familylastname as stulast
	FROM smg_help_desk
	LEFT JOIN smg_help_desk_section ON smg_help_desk.section = smg_help_desk_section.sectionid
	LEFT JOIN smg_users submit ON smg_help_desk.submitid = submit.userid
	LEFT JOIN smg_users assign ON smg_help_desk.assignid = assign.userid 
	LEFT JOIN smg_students s ON smg_help_desk.studentid = s.studentid
	WHERE helpdeskid = <cfqueryparam value="#url.helpdeskid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="help_desk_items" datasource="caseusa">
	SELECT itemsid, helpdeskid, submitid, text, date, 
	firstname, lastname, usertype
	FROM smg_help_desk_items
	LEFT JOIN smg_users ON smg_help_desk_items.submitid = smg_users.userid
	WHERE helpdeskid = <cfqueryparam value="#url.helpdeskid#" cfsqltype="cf_sql_integer">
	Order by date
</cfquery>

<cfif help_desk_principal.recordcount EQ '0'>
	<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
		<tr valign=middle height=24>
			<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
			<td width=26 background="pics/header_background.gif"><img src="pics/helpdesk.gif"></td>
			<td background="pics/header_background.gif"><h2>Help Desk - Error </h2></td>
			<td width=17 background="pics/header_rightcap.gif">&nbsp;</td></tr>
	</table>
	<table width=100% border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td align="center"><br><div align="justify"><h3>
						<p>Sorry, the system could not find this ticket. Please go back an try again.</p>
						<p>Thank you for your cooperation.</p></h3></div></td></tr>
	<tr><td align="center"><a href="?curdoc=helpdesk/help_desk_list"><img src="pics/back.gif" border="0"></img></a></td></tr>
	</table>
	<table width=100% cellpadding=0 cellspacing=0 border=0>
		<tr valign="bottom"><td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
			<td width=100% background="pics/header_background_footer.gif"></td>
			<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td></tr>
	</table>
	<cfabort>
</cfif>

<cfoutput>

<cfif help_desk_principal.section EQ '11'>
	<cfset newlink = '?curdoc=helpdesk/hd_list_exits'>
<cfelse>
	<cfset newlink = '?curdoc=helpdesk/help_desk_list'>
</cfif>

<cfif client.usertype NEQ '8'>
	<font size=-1> 
	[ <span class="edit_link"><a href="#newlink#&status=initial">Open</a></span> &middot; 
	  <span class="edit_link"><a href="#newlink#&status=closed">Closed</a></span> &middot;
	  <span class="edit_link"><a href="#newlink#&status=all">All</a></span></font> ]
	<br><br>
</cfif>
</cfoutput>

<!--- HEADER OF TABLE --->
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/helpdesk.gif"></td>
		<td background="pics/header_background.gif"><h2>Reviewing a Ticket</h2></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>
<!--- BODY OF TABLE --- USER'S ITEMS  --->
<table width=100% border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td width="4%"><h3><u>ID</u></h3></td>
		<td width="31%"><h3><u>Subject</u></h3></td>
		<td align="center" width="20%"><h3><u>Category</u></h3></td>
		<td align="center" width="20%%"><h3><u>Section</u></h3></td>
		<td align="center" width="15%"><h3><u>Priority</u></h3></td>
		<td align="center" width="10%"><h3><u>Status</u></h3></td>
	</tr>
<cfoutput query="help_desk_principal">
	<tr>
		<td width="4%">#helpdeskid#</td>
		<td width="31%">#title#</td>
		<td align="center" width="20%">#category#</td>
		<td align="center" width="20%">#sectionname#</td>
		<td align="center" width="15%">#priority#</td>
		<td align="center" width="10%">#status#</td>
	</tr>
</table>	
<table width=100% border=0 cellpadding=4 cellspacing=0 class="section">
	<tr>
		<td width="8%"><img src="pics/question.gif" border="0"></td>
		<td>#DateFormat(date, 'mm-dd-yyyy')# - #TimeFormat(date, 'hh:mm tt')# &nbsp; &middot &nbsp; 
			<cfif studentid EQ '0'>
				#submit_firstname# #submit_lastname# &nbsp; - &nbsp; #businessname#
			<cfelse>
				Student: #stufirst# #stulast# (###studentid#) &nbsp; - &nbsp; Intl. Rep. #businessname#
			</cfif>
			 (<cfif client.usertype NEQ '8'><a href="?curdoc=user_info&userid=#submitid#">###submitid#</a><cfelse>###submitid#</cfif>) wrote:</td>
	</tr>	
	<tr><td colspan="2"><h3>Message:</h3></td></tr>
	<tr><td colspan="2"><div align="justify">#text#</div></td></tr>	
</table>	
</cfoutput>
<!--- Items --->
<cfoutput query="help_desk_items">
<cfif help_desk_items.usertype is 1> 
	<cfset icon="response.gif"> 
	<cfset color_table="D5DCE5"> 
<cfelse>
	<cfset icon="question.gif">
	<cfset color_table="F1F3E8">
</cfif>
<table width=100% border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td width="8%"><img src="pics/#icon#" border="0"></td>
		<td>#DateFormat(date, 'mm-dd-yyyy')# - #TimeFormat(date, 'hh:mm tt')# &nbsp; &middot &nbsp; #firstname# #lastname# (<cfif client.usertype EQ '8'>#submitid#<cfelse><a href="?curdoc=user_info&userid=#submitid#">#submitid#</a></cfif>) wrote:</td>
	</tr>	
	<tr><td colspan="2"><h3><u>Message:</u></h3></td></tr>
	<tr><td colspan="2"><div align="justify">#text#</div></td></tr>
	<tr><td>&nbsp;</td></tr>
</table>
</cfoutput>
<cfif help_desk_principal.status is 'closed'>
<table width=100% border=0 cellpadding=4 cellspacing=0 class="section">
<tr bgcolor="e2efc7"><td colspan="6"><h3>This ticket has been closed, no further comments can be added. <br><cfoutput>Please submit a new ticket if you are still experiencing this problem. Reference Ticket ## #help_desk_principal.helpdeskid# in the subject.</cfoutput> </h3></td></tr>
</table>
<cfelse>
<!--- New Message --->
<cfform action="?curdoc=helpdesk/insert_help_desk_child&helpdeskid=#helpdeskid#" method="post">
<cfif client.usertype is 1>
<table width=100% border=0 cellpadding=4 cellspacing=0 class="section">
	<tr bgcolor="e2efc7"><td colspan="6"><h3>SMG Technical Suppport</h3></td></tr>
	<tr bgcolor="e2efc7">
		<td width="12%"><h3><u>Assigned :</u></h3></td>
		<td width="21%" align="left">
			<cfselect name="assigned" required="yes">
			<option value="0"></option>
			<cfquery name="global" datasource="caseusa">
				SELECT firstname, lastname, userid
				FROM smg_users
				WHERE usertype = '1'
				ORDER BY firstname
			</cfquery>
			<cfoutput query="global">
			<cfif #userid# is #help_desk_principal.assignid#><option value="#userid#" selected>#firstname# #lastname#</option><cfelse>
				<option value="#userid#">#firstname# #lastname#</option></cfif>
			</cfoutput>
			</cfselect></td>
		<td width="12%"><h3><u>Status :</u></h3></td>
		<td width="21%" align="left">
			<cfselect name="status" required="yes">
			<option value="0"></option>
			<option value="Initial">Initial</option>
			<option value="Info">Info Needed</option>				
			<option value="reviewing">Reviewing</option>
			<option value="closed">Closed</option>							
			</cfselect></td>	
		<td width="12%"><h3><u>Priority :</u></h3></td>
		<td width="21%" align="left">
			<cfselect name="priority" required="yes">
			<option value="0"></option>
			<option value="Low">Low</option>
			<option value="Medium">Medium</option>				
			<option value="High">High</option>
			</cfselect></td>	
	</tr>
</table>
</cfif>
<cfif client.usertype is 1> 
	<cfset icon="response.gif"> <!--- support users, response icon --->
	<cfset color_message="D5DCE5"> <!--- support users, light blue color --->
	<!--- <cfset color_table="E3E3E3"> --->
<cfelse>
	<cfset icon="question.gif"> <!--- regular users, question icon --->
	<cfset color_message="F1F3E8">
</cfif>


<table width=100% border=0 cellpadding=4 cellspacing=0 class="section">
	<tr bgcolor="e2efc7">
		<td width="8%"><cfoutput><img src="pics/#icon#" border="0"></cfoutput></td>
		<td><u>Enter New Message:</u></td>
	</tr>
	<tr bgcolor="e2efc7">
		<td colspan="2">
			<textarea cols="62" rows="6" name="text" wrap="VIRTUAL"></textarea>
		</td>
	</tr>
	<tr><td align="center" colspan="2"><input type="image" value="Submit" src="pics/submit.gif"></td></tr>
</table>
</cfform>
</cfif>
<!----footer of table --- new message ---->
<cfinclude template="../table_footer.cfm">
