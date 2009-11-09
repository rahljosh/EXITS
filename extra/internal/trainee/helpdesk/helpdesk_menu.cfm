<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Help Desk</title>

<style type="text/css">
<!--
div.scroll {
	height: 200px;
	width:auto;
	overflow:auto;
	left:auto;
}
div.scroll2 {
	height: 200px;
	width:auto;
	overflow:auto;
	left:auto;
}
-->
</style>
</head>

<body>

<cftry>

<cfif NOT isDefined("url.status")>
	<cfset url.status = "initial">
</cfif>

<cfquery name="help_desk_list" datasource="MySql">
	SELECT helpdeskid, title, category, section, priority, text, status, date, hd.companyid, smg_companies.companyshort,
		submit.firstname as submit_firstname, submit.lastname as submit_lastname,
		assign.firstname as assign_firstname, assign.lastname as assign_lastname
	FROM smg_help_desk hd
	LEFT JOIN smg_users submit ON hd.submitid = submit.userid
	LEFT JOIN smg_users assign ON hd.assignid = assign.userid 
	LEFT JOIN smg_companies ON hd.companyid = smg_companies.companyid
	WHERE hd.companyid = '#client..companyid#'
	<!---
	<cfif client..usertype eq 1>
		(hd.companyid = 7 or hd.companyid = 8 or hd.companyid = 9)
	<cfelse>
		hd.companyid = #client..companyid#
	</cfif>
	--->	
	<cfif url.status EQ 'initial'>
		AND status != 'closed'	
	<cfelseif url.status EQ 'closed'>
		AND status = '#url.status#'	
	</cfif>
	ORDER BY assign.firstname, priority DESC, date, status
</cfquery>

<cfquery name="help_desk_user" datasource="MySql">
	SELECT helpdeskid, title, category, section, priority, text, status, date
	FROM smg_help_desk hd
	WHERE hd.companyid = '#client..companyid#'
		AND submitid = '#client..userid#'
	ORDER BY status, date
</cfquery>

<cfoutput>

<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="CCCCCC" bgcolor="f4f4f4">
	<tr>
		<td bordercolor="FFFFFF">
			<!----Header Table---->
			<table width=95% cellpadding=0 cellspacing=0 border=0 align="center" height="25" bgcolor="E4E4E4">
				<tr bgcolor="E4E4E4">
					<td class="title1">&nbsp; &nbsp; Help Desk</td>
				</tr>
			</table>
			<br>
			<table width="90%" border="0" cellpadding="0" cellspacing="0" align="center" bordercolor="C7CFDC">	
				<tr>
					<td width="49%" valign="top">
						<!--- New Ticket --->
						<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff" height="260">
							<tr>
								<td bordercolor="FFFFFF" valign="top">
									<table width="100%" cellpadding=3 cellspacing=0 border=0>
										<tr bgcolor="C2D1EF">
											<td class="style2" bgcolor="8FB6C9" colspan="2">&nbsp;:: New Ticket</td>
										</tr>
										<cfif NOT IsDefined('form.newticket')>
											<tr>
												<td class="style1">
													<div align="justify">
														<p>Please, fill out the form and submit the information. Your message 
														will be forwarded to the EXITS support team.  You will then receive an 
														email from our Customer Service team updating you on the progress of the 
														issue.</p>
														<p>Before you enter a new problem in the form below, please check the 
														previously logged items to make sure you are not requesting service on 
														an item we are already working on.</p>
														<p>Thank You,<br>
														SMG Support Team</p>
													</div>
												</td>
											</tr>
											<tr>
												<td align="Center" width="100%">
													<cfform name="new_ticket" action="" method="post">
														<cfinput type="hidden" name="newticket">
														<cfinput type="image" name="submit" value=" New Ticket " src="../pics/new-ticket.gif">
													</cfform>
												</td>
											</tr>
										<cfelse>
											<cfform name="new_ticket" action="?curdoc=helpdesk/qr_helpdesk_menu" method="post">
												<tr class="style1">
													<td colspan="2">
														Title: <br>
														<cfinput type="text" size="45" name="title" required="yes" message="Before you submit your question, you must enter a title.">	
													</td>
												</tr>
												<tr class="style1">
													<td width="50%">
														Category: <br>
														<cfselect name="category">
															<option value="0"></option>
															<option value="Question">Question</option>	
															<option value="Suggestion">Suggestion</option>
															<option value="Error">Error on Screen</option>	
															<option value="Request">Request for Service</option>
															<option value="Problem">Problem Affecting Today's Work</option>						
														</cfselect>
													</td>
													<td width="50%">Section Affected :
														<cfselect name="section"> 
														<option value="0"></option>
														<cfquery name="get_sections" datasource="MySql">
															SELECT *	
															FROM smg_help_desk_section	
															WHERE systemid = '4' <!--- EXTRA --->
															ORDER BY sectionname
														</cfquery>
														<cfloop query="get_sections">
															<option value="#sectionid#">#sectionname#</option>
														</cfloop>
													</cfselect>
													</td> 
												</tr>
												<tr class="style1">
													<td colspan="2">
														Please describe your problem below:<br />
														<textarea cols="48" rows="5" name="text" wrap="VIRTUAL"></textarea>
													</td>
												</tr>
												<tr><td align="center" colspan="2"><cfinput type="image" name="submit" value=" Submit " src="../pics/save.gif"></td></tr>
											</cfform>	
										</cfif>
									</table>
								</td>
							</tr>
						</table>
					</td>
					<td width="2%" valign="top">&nbsp;</td>
					<td width="49%" valign="top">
						<!--- Tickets Submitted by You --->
						<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff" height="260">
							<tr>
								<td bordercolor="FFFFFF">
									<table width="100%" cellpadding=3 cellspacing=0 border=0>
										<tr bgcolor="C2D1EF">
											<td width="60%" class="style2" bgcolor="8FB6C9">&nbsp;:: Tickets Submitted By You</td>
											<td width="40%" class="style2" bgcolor="8FB6C9" align="right">#help_desk_user.recordcount# ticket(s) found</td>
										</tr>
										<tr>	
											<td colspan="2">
												<table width="100%" cellpadding=3 cellspacing=0 border=0>
													<tr class="style2">	
														<td width="20%" bgcolor="4F8EA4">Submitted</td>
														<td width="36%" bgcolor="4F8EA4">Title</td>
														<td width="20%" bgcolor="4F8EA4">Category</td>
														<td width="20%" bgcolor="4F8EA4">Status</td>
														<td width="4%" bgcolor="4F8EA4">&nbsp;</td></tr>
												</table>
												<div class="scroll2">
												<table width=99% cellpadding=0 cellspacing=0 border=0>
													<cfloop query="help_desk_user">
														<tr bgcolor="#iif(currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
															<td width="20%"><a href="?curdoc=helpdesk/helpdesk_view&helpdeskid=#helpdeskid#" class="style4">#DateFormat(date, 'mm-dd-yyyy')#</a></td>
															<td width="36%"><a href="?curdoc=helpdesk/helpdesk_view&helpdeskid=#helpdeskid#" class="style4">#title#</a></td>
															<td width="20%" class="style5">#category#</td>
															<td width="20%" class="style5">#status#</td>
														</tr>
													</cfloop>
												</table>
												</div>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>	
				</tr>
				<tr>
					<td colspan="3"><br>
						<!--- All Tickets --->
						<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF">
									<table width="100%" cellpadding=3 cellspacing=0 border=0>
										<tr bgcolor="C2D1EF">
											<td width="30%" class="style2" bgcolor="8FB6C9" valign="top">&nbsp;:: All Tickets</td>
											<td width="70%" class="style2" bgcolor="8FB6C9" align="right">
												#help_desk_list.recordcount# ticket(s) found<br>
												Filter: [ <a href="?curdoc=helpdesk/helpdesk_menu&status=initial" class="style2">Open</a>
												&nbsp; | &nbsp; <a href="?curdoc=helpdesk/helpdesk_menu&status=closed" class="style2">Closed</a>
												&nbsp; | &nbsp; <a href="?curdoc=helpdesk/helpdesk_menu&status=all" class="style2">All</a> ]
											</td>
										</tr>
										<tr>
											<td colspan="2">
												<table width="100%" cellpadding=3 cellspacing=0 border=0>
													<tr class="style2">	
														<td width="4%" bgcolor="4F8EA4">ID</td>
														<td width="6%" bgcolor="4F8EA4">Comp.</td>
														<td width="27%" bgcolor="4F8EA4">Title</td>
														<td width="12%" bgcolor="4F8EA4">Category</td>
														<td width="8%" bgcolor="4F8EA4">Priority</td>
														<td width="8%" bgcolor="4F8EA4">Status</td>
														<td width="15%" bgcolor="4F8EA4">Submitted by</td>
														<td width="15%" bgcolor="4F8EA4">Assigned To</td>
														<td width="10%" bgcolor="4F8EA4">Date</td>
														<td width="1%" bgcolor="4F8EA4">&nbsp;</td>
													</tr>
												</table>
												<div class="scroll">
												<table width="99%" cellpadding=0 cellspacing=0 border=0>
												<cfloop query="help_desk_list">
													<tr bgcolor="#iif(currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
														<td width="4%"><a href="?curdoc=helpdesk/helpdesk_view&hdid=#helpdeskid#" class="style4">#helpdeskid#</a></td>
														<td width="6%" <a href="?curdoc=helpdesk/helpdesk_view&hdid=#helpdeskid#" class="style4">#companyshort#</td>
														<td width="27%"><a href="?curdoc=helpdesk/helpdesk_view&helpdeskid=#helpdeskid#" class="style4">#title#</a></td>
														<td width="12%" class="style5">#category#</td>
														<td width="8%" class="style5">#priority#</td>
														<td width="8%" class="style5">#status#</td>
														<td width="15%" class="style5">#submit_firstname# #submit_lastname#</td>
														<td width="15%" class="style5">#assign_firstname# #assign_lastname#</td>
														<td width="10%" class="style5">#DateFormat(date, 'mm-dd-yyyy')#</td>
													</tr>
												</cfloop>
												</table>
												</div>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
						<br>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

</cfoutput>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</cftry>

</body>
</html>