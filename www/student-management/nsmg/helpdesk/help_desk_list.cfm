<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfif NOT isDefined("url.status")>
	<cfset url.status = "initial">
</cfif>

<cfquery name="help_desk_list" datasource="MySql">
	SELECT helpdeskid, title, category, section, priority, text, status, date, submitid, assignid,
		submit.firstname as submit_firstname, submit.lastname as submit_lastname,
		assign.firstname as assign_firstname, assign.lastname as assign_lastname
	FROM smg_help_desk
	LEFT JOIN smg_users submit ON smg_help_desk.submitid = submit.userid
	LEFT JOIN smg_users assign ON smg_help_desk.assignid = assign.userid 
	WHERE section != '11'
		AND smg_help_desk.companyid <= '5'
	<cfif url.status EQ 'initial'>
		AND status != 'closed'	
	<cfelseif url.status EQ 'closed'>
		AND status = '#url.status#'	
	</cfif>
	ORDER BY status, date DESC
</cfquery>

<cfquery name="help_desk_user" datasource="MySql">
	SELECT helpdeskid, title, category, section, priority, text, status, date, submitid, assignid,
		submit.firstname as submit_firstname, submit.lastname as submit_lastname,
		assign.firstname as assign_firstname, assign.lastname as assign_lastname
	FROM smg_help_desk
	LEFT JOIN smg_users submit ON smg_help_desk.submitid = submit.userid
	LEFT JOIN smg_users assign ON smg_help_desk.assignid = assign.userid 
	WHERE submitid = '#client.userid#'
	ORDER BY status, date DESC
</cfquery>

<style type="text/css">
<!--
div.scroll {
	height: 230px;
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

<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr><td width="49%" align="left">
	<!--- HEADER OF TABLE --- ADD A NEW TICKET --->
	<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
		<tr valign=middle height=24>
			<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
			<td width=26 background="pics/header_background.gif"><img src="pics/helpdesk.gif"></td>
			<td background="pics/header_background.gif"><h2>Help Desk <cfif IsDefined('url.new')> - Adding a New Ticket</cfif> </h2></td>
			<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
		</tr>
	</table>
	<table width=100% border=0 cellpadding=4 cellspacing=0 class="section">
		<tr><td><cfif IsDefined('url.new')> <font size="1" color="#3333FF">Please try to include as much information as possible.</font> <cfelse>&nbsp;</cfif></td></tr>
	</table>
	<div class="box2">
		<cfif not IsDefined('url.new')>
		<table>
			<tr><td width="100%"><div align="justify">
					<p>Please, fill out the form and submit the information. Your message 
					will be forwarded to the EXITS support team.  You will then receive an 
					email from our Customer Service team updating you on the progress of the 
					issue.</p>
					<p>Before you enter a new problem in the form below, please check the 
					previously logged items to make sure you are not requesting service on 
					an item we are already working on.</p>
					<p>Thank You,<br>
					Support Team</p></div></td>
			</tr>
			<tr><td align="Center" width="100%">
					<cfif #client.usertype# lt 5 or client.usertype eq 8 or client.usertype eq 11>
					<form action="index.cfm?curdoc=helpdesk/help_desk_list&new=yes" method="post"><input type="image" value=" New Ticket " src="pics/newticket.gif"></form>
					</cfif></td>
			</tr>
		</table>
		<cfelse> <!--- NEW HELP DESK ITEM --->
		<cfform action="?curdoc=helpdesk/insert_help_desk" method="post">
			<table>		
				<tr><td width="50%">Subject: <br> <cfinput type="text" size="28" name="title" required="yes" message="Before you submit your question, you must enter a subject." value="Enter a subject" onfocus="if (this.value == this.defaultValue) this.value = '';"></td>
					<td align="left" width="50%">Category: <br>
						<cfselect name="category" required="yes" message="Before you submit your question you must select a category">
							<option value="0"></option>
							<option value="Question">Question</option>	<option value="Suggestion">Suggestion</option>
							<option value="Error">Error on Screen</option>	<option value="Request">Request for Service</option>
							<option value="Problem">Problem Affecting Today's Work</option>						
						</cfselect></td>
				</tr>
				<tr><td width="50%" valign="bottom">Message: </td>
					<td align="left" width="50%">Section Affected :
						<cfselect name="section" required="yes" message="Before you submit your question you must select a section"> 
						<option value="0"></option>
						<cfquery name="get_sections" datasource="MySql">
							SELECT *	FROM smg_help_desk_section	
							WHERE systemid = '1' <!--- exits ---> 
							<cfif client.usertype EQ '8' OR client.usertype EQ '10' OR client.usertype EQ '11'>
							 AND (sectionid = '11' or sectionid = '10')
							</cfif>
							ORDER BY sectionname
						</cfquery>
						<cfoutput query="get_sections"><option value="#sectionid#">#sectionname# &nbsp; &nbsp;</option></cfoutput>
					</cfselect></td> 
				</tr>
				<tr><td colspan="2"><textarea cols="48" rows="3" name="text" wrap="VIRTUAL"></textarea></td></tr>
				<tr><td align="center" colspan="2"><input type="image" value=" Submit " src="pics/submit.gif"></td></tr>
			</table>
		</cfform>	
		</cfif>	
	</div>
	<!--- footer of table- ADD A NEW TICKET --->
	<table width=100% cellpadding=0 cellspacing=0 border=0>
		<tr valign="bottom">
			<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
			<td width=100% background="pics/header_background_footer.gif"></td>
			<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
		</tr>
	</table>
</td>
<td width="2%"><!--- SEPARATE TABLES ---></td>
<td width="49%" align="right">
	<cfoutput>
	<!--- HEADER OF TABLE --- USER'S ITEMS --->
	<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
		<tr valign=middle height=24>
			<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
			<td width=26 background="pics/header_background.gif"><img src="pics/helpdesk.gif"></td>
			<td background="pics/header_background.gif"><h2>Tickets Submitted by You</h2></td>
			<td background="pics/header_background.gif" align="right">#help_desk_user.recordcount# message(s) displayed</td>
			<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
		</tr>
	</table>
	</cfoutput>
	<!--- BODY OF TABLE --- USER'S ITEMS  --->
	<table width=100% border=0 cellpadding=4 cellspacing=0 class="section">
		<tr><td width="20%"><u>Submitted</u></td>	<td width="36%"><u>Subject</u></td>
		<td width="20%"><u>Category</u></td>		<td width="20%"><u>Status</u></td>	<td width="6%">&nbsp;</td></tr>
	</table>
	<div class="scroll2">
		<table width=99%>
		<cfif help_desk_user.recordcount is not 0>
			<cfoutput query="help_desk_user">
				<cfif status is 'initial'><cfset color="green"></cfif>		
				<cfif status is 'info'><cfset color="663366"></cfif>
				<cfif status is 'reviewing'><cfset color="red"></cfif>		
				<cfif status is 'closed'><cfset color="blue"></cfif>
				<tr bgcolor="#iif(help_desk_user.currentrow MOD 2 ,DE("ffffe6") ,DE("e2efc7") )#">
					<td width="20%"><a href="?curdoc=helpdesk/help_desk_view&helpdeskid=#helpdeskid#">#DateFormat(date, 'mm-dd-yyyy')#</a></td>
					<td width="36%"><a href="?curdoc=helpdesk/help_desk_view&helpdeskid=#helpdeskid#">#title#</a></td>
					<td width="20%"><font color="#color#">#category#</font></td>
					<td width="20%"><font color="#color#">#status#</font></td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr><td colspan="6" bgcolor="ffffe6"><cfoutput>At the moment there are no "#url.status#" messages</cfoutput></td></tr>
		</cfif>
		</table>
	</div>
	<!----footer of table --- USER'S ITEMS ---->
	<table width=100% cellpadding=0 cellspacing=0 border=0>
		<tr valign="bottom">
			<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
			<td width=100% background="pics/header_background_footer.gif"></td>
			<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
		</tr>
	</table>
</td></tr>
</table><br>
<cfif client.usertype NEQ 8 AND client.usertype NEQ 10 AND client.usertype NEQ 11>
<cfoutput>
<!--- HEADER OF TABLE --- ALL ITEMS --->
<table width=100% cellpadding=0 cellspacing=0 border=0 height="24"> 
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/helpdesk.gif"></td>
		<td background="pics/header_background.gif"><h2>All Tickets</h2></td>
		<td background="pics/header_background.gif" align="right">
			&nbsp; &nbsp;
			<font size=-1> 
			[ <cfif url.status is "initial"><span class="edit_link_selected"><cfelse><span class="edit_link"></cfif>
			<a href="?curdoc=helpdesk/help_desk_list&status=initial">Open</a></span> &middot; 
			<cfif url.status is "closed"><span class="edit_link_selected"><cfelse><span class="edit_link"></cfif>
			<a href="?curdoc=helpdesk/help_desk_list&status=closed">Closed</a></span> &middot;
			<cfif url.status is "all"><span class="edit_link_selected"><cfelse><span class="edit_link"></cfif>
			<a href="?curdoc=helpdesk/help_desk_list&status=all">All</a></span> ]
			&nbsp; #help_desk_list.recordcount# message(s) displayed</font>		
		</td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>
</cfoutput>
<!--- BODY OF TABLE --- ALL ITEMS --->
<table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
	<tr>	
		<td width="4%"><u>ID</u></td>
		<td width="21%"><u>Subject</u></td>
		<td width="15%"><u>Category</u></td>
		<td width="8%"><u>Priority</u></td>
		<td width="8%"><u>Status</u></td>
		<td width="15%"><u>Submitted by</u></td>
		<td width="15%"><u>Assigned To</u></td>
		<td width="10%"><u>Date</u></td>
		<td width="1%"></td>
	</tr>
</table>
<div class="scroll">
	<table width="100%">
	<cfif help_desk_list.recordcount is not 0>
		<cfoutput query="help_desk_list">
		<cfquery name="check_sub_items" datasource="MySql">
			SELECT itemsid, u.usertype
			FROM smg_help_desk_items
			INNER JOIN smg_users u ON submitid = userid
			WHERE helpdeskid = #help_desk_list.helpdeskid#
			ORDER BY itemsid DESC limit 1	
		</cfquery>
			<cfif status is 'initial'><cfset color="green"></cfif>
			<cfif status is 'info'><cfset color="663366"></cfif>
			<cfif status is 'reviewing'><cfset color="red"></cfif>
			<cfif status is 'closed'><cfset color="blue"></cfif>
			<cfif #DateDiff('d',date, now())# GT 15 AND status NEQ 'closed' AND category NEQ 'Suggestion' AND category NEQ 'Question'>
			<tr bgcolor="FFC4C5">
			<cfelse>
			<tr bgcolor="#iif(help_desk_list.currentrow MOD 2 ,DE("ffffe6") ,DE("e2efc7") )#">
			</cfif>
				<td width="4%" align="left"><a href="?curdoc=helpdesk/help_desk_view&helpdeskid=#helpdeskid#">#helpdeskid#</a></td>
				<td width="21%"><a href="?curdoc=helpdesk/help_desk_view&helpdeskid=#helpdeskid#">#title#</a><cfif check_sub_items.recordcount is not 0 and check_sub_items.usertype GT '1' <!--- and help_desk_list.status is 'info' --->><img src="pics/responsesmall.gif" border="0"></cfif></td>
				<td width="15%"><font color="#color#">#category#</font></td>
				<td width="8%"><font color="#color#">#priority#</font></td>
				<td width="8%"><font color="#color#">#status#</font></td>
				<td width="15%"><font color="#color#">#submit_firstname# #submit_lastname#</font></td>
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
<cfelse>

<!----Alternate Contact Methods---->
	<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
		<tr valign=middle height=24>
			<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
			<td width=26 background="pics/header_background.gif"><img src="pics/news.gif"></td>
			<td background="pics/header_background.gif"><h2>Alternate Contact Methods</td><td background="pics/header_background.gif" width=16></td>
			<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
		</tr>
	</table>
	
				<table width=100% cellpadding=4 cellspacing=0 border=0 class="section" >
	<tr>
		<td><h3><u>Finance Questions</u></h3>
	<cfif client.companyid LTE 5>
	
	Bryan McCready<br>
	<a href="mailto:bmccready@iseusa.org">bmccready@iseusa.org</a><br>
	800-766-4656-Toll Free<br>
	631-893-4540-Phone<br>
	631-893-4550-Fax<br>
<cfelseif client.companyid eq 10>
Jana De Fillipps <br>
	<a href="mailto:jana@case-usa.org">jana@case-usa.org</a><br>
	800-458-8336-Toll Free<br>
	732-671-6448-Phone<br>
	732-615-9183-Fax<br>
</cfif>
		</td>
	
	
	<td valign="top">
	<h3><u>Live Chat</u></h3>
	Live chat is available depending on operator availability.<br>
	<table cellpadding="0" cellspacing="0" border="0" align="center"><tr><td align="center">
	 <!-- http://www.LiveZilla.net Chat Button Link Code --><a href="javascript:void(window.open('http://www.exitsapplication.com/livezilla/livezilla.php','','width=600,height=600,left=0,top=0,resizable=yes,menubar=no,location=yes,status=yes,scrollbars=yes'))"><img src="http://www.exitsapplication.com/livezilla/image.php?id=04" width="128" height="42" border="0" alt="LiveZilla Live Help"></a><noscript><div></div></noscript><!-- http://www.LiveZilla.net Chat Button Link Code --><!-- http://www.LiveZilla.net Tracking Code --><div id="livezilla_tracking" style="display:none"></div><script language="JavaScript" type="text/javascript">var script = document.createElement("script");script.type="text/javascript";var src = "http://www.exitsapplication.com/livezilla/server.php?request=track&output=jcrpt&nse="+Math.random();setTimeout("script.src=src;document.getElementById('livezilla_tracking').appendChild(script)",1);</script><!-- http://www.LiveZilla.net Tracking Code -->
                   
	</td>
	</tr><tr><td align="center"></td></tr></table>
	</td>
	<td valign="top">
	<h3><u>Email</u></h3>
	<cfoutput>
	Need to contact us or send an attachment? Please email our<br>
	general support email at <a href="mailto:#client.support_email#">#client.support_email#</a> <br>
	</cfoutput>
	
	</td>
	</tr>
</table>
<!----footer of table---->
<cfinclude template="../table_footer.cfm">

</cfif>