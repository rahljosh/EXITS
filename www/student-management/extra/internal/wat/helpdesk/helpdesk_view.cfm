<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Help Desk - Ticket View</title>
</head>

<body>

<cftry>
 
<cfquery name="helpdesk" datasource="MySql">
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

<cfquery name="help_desk_items" datasource="MySql">
	SELECT itemsid, helpdeskid, submitid, text, date, 
		firstname, lastname, usertype
	FROM smg_help_desk_items
	LEFT JOIN smg_users ON smg_help_desk_items.submitid = smg_users.userid
	WHERE helpdeskid = <cfqueryparam value="#helpdesk.helpdeskid#" cfsqltype="cf_sql_integer">
	ORDER BY date
</cfquery>

<cfoutput>

<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="CCCCCC" bgcolor="f4f4f4">
	<tr>
		<td bordercolor="FFFFFF">
			<!----Header Table---->
			<table width=95% cellpadding=0 cellspacing=0 border=0 align="center" height="25" bgcolor="E4E4E4">
				<tr bgcolor="E4E4E4">
					<td class="title1">&nbsp; &nbsp; Help Desk - Ticket View</td>
				</tr>
			</table>
			<br>
			<table width="90%" border="0" cellpadding="0" cellspacing="0" align="center" bordercolor="C7CFDC">	
				<tr>
					<td colspan="3">
						<!--- All Tickets --->
						<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF">
									<table width="100%" cellpadding=3 cellspacing=0 border=0>
										<tr class="style2">	
											<td width="5%" bgcolor="4F8EA4">ID ##</td>
											<td width="35%" bgcolor="4F8EA4">Title</td>
											<td width="15%" bgcolor="4F8EA4">Category</td>
											<td width="15%" bgcolor="4F8EA4">Section</td>
											<td width="15%" bgcolor="4F8EA4">Priority</td>
											<td width="15%" bgcolor="4F8EA4">Status</td>
										</tr>
										<tr class="style1">
											<td>#helpdesk.helpdeskid#</td>
											<td>#helpdesk.title#</td>
											<td>#helpdesk.category#</td>
											<td>#helpdesk.sectionname#</td>
											<td>#helpdesk.priority#</td>
											<td>#helpdesk.status#</td>										
										</tr>
										<tr><td colspan="6">&nbsp;</td></tr>
										
										<tr class="style2"><td colspan="6" bgcolor="4F8EA4">Ticket Information</td></tr>
										<tr class="style1">
											<td colspan="3">
												<b>Date:</b> #DateFormat(helpdesk.date, 'mm-dd-yyyy')# - #TimeFormat(helpdesk.date, 'hh:mm tt')# 
											</td>
											<td colspan="3">
												<b>Submitted by:</b> #helpdesk.submit_firstname# #helpdesk.submit_lastname# <cfif helpdesk.businessname NEQ ''>&nbsp; - &nbsp; #helpdesk.businessname#</cfif> (###helpdesk.submitid#)
											</td>
										</tr>
										<tr class="style1"><td colspan="6"><b>Message</b></td></tr>
										<tr class="style1"><td colspan="6">#Replace(helpdesk.text,"<br>","#chr(10)#","all")#</td></tr>
										<tr><td colspan="6">&nbsp;</td></tr>
										
										<!--- TICKET COMMENTS --->
										<cfif help_desk_items.recordcount>
											<tr class="style2"><td colspan="6" bgcolor="4F8EA4">Ticket Comments</td></tr>
											<cfloop query="help_desk_items">
												<tr class="style1" bgcolor="#iif(currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
													<td colspan="3">
														<b>Date:</b> #DateFormat(date, 'mm-dd-yyyy')# - #TimeFormat(date, 'hh:mm tt')# 
													</td>
													<td colspan="3">
														<b>Submitted by:</b> #firstname# #lastname# (###submitid#)
													</td>
												</tr>
												<tr class="style1" bgcolor="#iif(currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#"><td colspan="6"><b>Message</b></td></tr>
												<tr class="style1" bgcolor="#iif(currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#"><td colspan="6">#Replace(text,"<br>","#chr(10)#","all")#</td></tr>
											</cfloop>
										</cfif>
										
										<cfif helpdesk.status EQ 'closed'>
											<tr class="style2"><td colspan="6" bgcolor="4F8EA4" align="center">This ticket has been closed, no further comments can be added.</td></tr>
											<tr class="style1"><td colspan="6" align="center">Please submit a new ticket if you are still experiencing this problem. Reference Ticket ###helpdesk.helpdeskid# in the subject.</td></tr>
										<cfelse>	
											<!--- ADD COMMENTS --->
											<cfform name="new_comment" action="?curdoc=helpdesk/qr_helpdesk_view" method="post">
												<cfinput type="hidden" name="helpdeskid" value="#helpdesk.helpdeskid#">
												<!--- SMG SUPPORT - UPDATE ASSIGNED TO / STATUS AND PRIORITY --->
												<cfif client.usertype EQ 1>
													<tr class="style2"><td colspan="6" bgcolor="4F8EA4" align="center">SMG Technical Suppport</td></tr>
												 	<tr class="style1">
														<td colspan="2">
															<b>Assigned to: &nbsp;</b>
															<cfselect name="assignid">
																<option value="0"></option>
																<cfquery name="get_support" datasource="MySql">
																	SELECT firstname, lastname, userid
																	FROM smg_users
																	WHERE usertype = '1'
																	ORDER BY firstname
																</cfquery>
																<cfloop query="get_support">
																	<option value="#userid#" <cfif userid EQ helpdesk.assignid>selected</cfif>>#firstname# #lastname#</option>
																</cfloop>
															</cfselect>															
														</td>
														<td colspan="2">
															<b>Status: &nbsp;</b>
															<cfselect name="status">
																<option value="0"></option>
																<option value="Initial">Initial</option>
																<option value="Info">Info Needed</option>				
																<option value="reviewing">Reviewing</option>
																<option value="closed">Closed</option>							
															</cfselect>
														</td>
														<td colspan="2">
															<b>Priority: &nbsp;</b>
															<cfselect name="priority">
																<option value="0"></option>
																<option value="Low">Low</option>
																<option value="Medium">Medium</option>				
																<option value="High">High</option>
															</cfselect>															
														</td>
													</tr>
													<tr><td colspan="6">&nbsp;</td></tr>
												</cfif>
												<tr class="style2"><td colspan="6" bgcolor="4F8EA4" align="center">New Comment</td></tr>												
												<tr class="style1"><td colspan="6"><b>Please enter a new comment for this ticket below: </b></td></tr>
												<tr class="style1"><td colspan="6"><textarea cols="80" rows="5" name="text" wrap="VIRTUAL"></textarea></td></tr>
												<tr><td align="center" colspan="6"><cfinput type="image" name="submit" value=" Submit " src="../pics/save.gif"></td></tr>
											</cfform>
										</cfif>									
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