<cfquery name="news_messages" datasource="mysql">
	select *
	from smg_news_messages
	where messagetype = 'news'  and  (expires > #now()# and startdate < #now()#)
	and companyid = #client.companyid#
</cfquery>

<Cfquery name="new_hostcompanies" datasource="mysql">
	select extra_hostcompany.hostcompanyid, extra_hostcompany.name, extra_hostcompany.city, extra_hostcompany.state, extra_hostcompany.homepage, smg_states.statename
	from extra_hostcompany
	LEFT JOIN smg_states ON smg_states.id = extra_hostcompany.state 
	where entrydate > '#client.lastlogin#'
</Cfquery>

<Cfquery name="new_candidates" datasource="mysql">
	select extra_candidates.firstname, extra_candidates.lastname, extra_candidates.residence_country, extra_candidates.uniqueid,
	smg_countrylist.countryname
	from extra_candidates
	LEFT JOIN smg_countrylist ON smg_countrylist.countryid = extra_candidates.residence_country 
	where entrydate > '#client.lastlogin#'
	AND  extra_candidates.companyid = '#client.companyid#'
</Cfquery>
<cfoutput>

<!--- <cfdump var="#client.auth#"> --->
<table  bgcolor="##FFFFFF" bordercolor="##CCCCCC" border="1" height="100%" width="100%">
	<tr bordercolor="##FFFFFF">
		<td>

			<TABLE cellSpacing="0" cellPadding="0" align="center" class="regContainer" width="700">
				<tr>
					<td width="10">&nbsp;</td>
					<td>
										
							<!-- Error Message / Validation Summary -->
							<cfif update_messages.recordcount eq 0>
							<div id="divInvalidFormMsg" style="DISPLAY: none">
							<cfelse>
							<div id="divInvalidFormMsg" style="DISPLAY: inline">
							
								<!-- Error Message -->
								<table cellSpacing="0" cellPadding="0" width="100%" border="0" class="style1">
									<tr>
										<td width="6"><img height=6 src="../pics/table-borders/red-err-lefttopcorner.gif" width=6></td>
										<td bgColor="##bb0000" height="6"><img height=6 src="spacer.gif" width=1 ></td>
										<td width="6"><img height=6 src="../pics/table-borders/red-err-righttopcorner.gif" width=6></td>
									</tr>
		
									<tr>
										<td class="errMessageGradientStyle" bgColor="##bb0000"><img height=45 src="spacer.gif" width=1 >
										</td>
										<td class="errMessageGradientStyle" bgColor="##bb0000">
											
											<table cellSpacing="0" cellPadding="10" width="100%" border="0">
												<tr>
													<td vAlign="middle" align="center"><img src="../pics/error-exclamate.gif" ></td>
													<td vAlign="middle" align="left"><font color="white"><strong><span class=upper>ALERT!&nbsp;&nbsp; ALARM!&nbsp;&nbsp;  Alarma!&nbsp;&nbsp;  Alerte!&nbsp;&nbsp;  Allarme!&nbsp;&nbsp;  Alerta!</span> </strong><br>
													
													
													<cfloop query="alert_messages">
													<b><a class=nav_bar href="" onClick="javascript: win=window.open('message_details.cfm?id=#alert_messages.messageid#', 'Details', 'height=480, width=450, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><font color="##ffffff">#message#</font></a></b><br>
													</cfloop></font><br>
													</td>
												</tr>
											</table>
											
										</td>
										<td class="errMessageGradientStyle" bgColor="##bb0000"><img height=45 src="spacer.gif" width=1 >
										</td>
									</tr>
		
									<tr>
										<td><img height=6 src="../pics/table-borders/red-err-leftbottcorner.gif" width=6></td>
										<td bgColor="##bb0000"><img height=6 src="spacer.gif" width=1 ></td>
										<td><img height=6 src="../pics/table-borders/red-err-rightbottomcorner.gif" width=6></td>
									</tr>
								</table>
							</div>
							</cfif>
							<!-- End error message end -->						
						
				</td>
				<td width="10">&nbsp;</td>
				</tr>
				<tr borderColor="##d3d3d3">
					<td width="10">&nbsp;</td>
					<td>
							
							<!---- Outer Table (outline and title ---->
							<table cellspacing="0" cellpadding="3" width="100%" border="0" class="style1">
								<tr>
									<td class="groupTopLeft">&nbsp;</td>
									<td class="groupCaption" nowrap="true"><b>News & Announcements</b></td>
									<td class="groupTop" width="95%">&nbsp;</td><td class="groupTopRight">&nbsp;</td>
								</tr>
								<tr>					
									<td class="groupLeft">&nbsp;</td>
									<td colspan="2">
									
												<table id="rgbPersonalDetails" cellpadding="0" cellspacing="0" border="0" width="100%" class="style1">
													<tr>
														<td>
															
															<!----Table with Info in It---->
															<TABLE cellSpacing="0" cellPadding="0" width="100%" border="0" class="style1">
																<TBODY>
																	<TR>
																		<TD valign="center">
																			
																				<!----News & Announcements---->
																				<table border=0 width=100%>
																					<tr>
																						<td valign="top" class="style1">
																							<cfif news_messages.recordcount eq 0>
																							<strong>#DateFormat(now(), 'mmm. d, yyyy')#</strong><br>
																								There are currently no announcements or news items.
																							<cfelse>
																								<cfloop query="news_messages">
																									<b>#message#</b><br>
																									#DateFormat(startdate, 'MMMM D, YYYY')# - #ParagraphFormat(details)#
																								</cfloop>
																							</cfif>
																						</td>
																						<td align="right">
																							<div align="right"><img src="../pics/tower.gif" width="31" height="51"></div>
																						</td>
																					</tr>
																				</table>
																		
																		</TD>
																	</TR>
																</TBODY>
															</table>
															
														</td>
													</tr>
												</table>
												
									</td>
									<td class="groupRight">&nbsp;</td>
								</tr>
								<tr>
									<td class="groupBottomLeft"><img height=5 src='spacer.gif' width=1 ></td>
									<td class="groupBottom" colspan="2"><img height=1 src='spacer.gif' width=1 ></td>
									<td class="groupBottomRight"><img height=1 src='spacer.gif' width=1 ></td>
						
									<!--- End of News & Anoucements --->
										
								</tr>
								<tr>
									<td>&nbsp;</td>
								</tr>
						</table> 
								 
											<!---- Outer Table (outline and title ---->
											<table cellspacing="0" cellpadding="3" width="100%" border="0" class="style1">
												<tr>
													<td class="groupTopLeft">&nbsp;</td>
													<td class="groupCaption" nowrap="true"><b>New Students</b></td>
													<td class="groupTop" width="95%">&nbsp;</td>
													<td class="groupTopRight">&nbsp;</td>
												</tr>
												<tr>
													<td class="groupLeft">&nbsp;</td>
													<td colspan="2">
													
													<table id="rgbPersonalDetails" cellpadding="0" cellspacing="0" border="0" width="100%">
														<tr>
															<td>
																
																<!----Table with Info in It---->
																<TABLE cellSpacing="0" cellPadding="0" width="100%" border="0" class="style1">
																	<TBODY>
																		<TR>
																			<TD valign="center">
																				<!----New Students---->
																								
																				<cfif new_candidates.recordcount eq 0>
																					No new students have been added.
																				<cfelse>
																					<Cfloop query="new_candidates">
																						<a href="?curdoc=candidate/candidate_info&uniqueid=#uniqueid#">#firstname# #lastname#</a> of #countryname#<br>
																					</Cfloop>
																				</cfif>
																								
																			</TD>
																		</TR>
																	</TBODY>
																</table>
																	
															</td>
														</tr>
													</table>
													
													</td>
													<td class="groupRight">&nbsp;</td>
												</tr>
												<tr>
													<td class="groupBottomLeft"><img height=5 src='spacer.gif' width=1 ></td>
													<td class="groupBottom" colspan="2"><img height=1 src='spacer.gif' width=1 ></td>
													<td class="groupBottomRight"><img height=1 src='spacer.gif' width=1 ></td>
												</TR>
												<tr>
													<td colspan="4">
							
													<br />
							
														<!---- Outer Table (outline and title ---->
														<table cellspacing="0" cellpadding="3" width="100%" border="0" class="style1">
															<tr>
																<td class="groupTopLeft">&nbsp;</td>
																<td class="groupCaption" nowrap="true"><b>New Host Companies</b></td>
																<td class="groupTop" width="95%">&nbsp;</td>
																<td class="groupTopRight">&nbsp;</td>
															</tr>
															<tr>
																<td class="groupLeft">&nbsp;</td>
																<td colspan="2">
																
																<table id="rgbPersonalDetails" cellpadding="0" cellspacing="0" border="0" width="100%">
																	<tr>
																		<td>
													
																				<!----Table with Info in It---->
																				<TABLE cellSpacing="0" cellPadding="0" width="100%" border="0" class="style1">
																					<TBODY>
																						<TR>
																							<TD valign="center">
																								<!----New HOST COMPANIES ---->
																									
																								<cfif new_hostcompanies.recordcount eq 0>
																								No new host companies have been added.
																							<cfelse>
																								<Cfloop query="new_hostcompanies">
																									<A href="?curdoc=hostcompany/hostcompany_profile&hostcompanyid=#hostcompanyid#">#name# in  #city#, #statename#</A> <cfif homepage is not ''>:: <a href="#homepage#">homepage</a></cfif><br>
																								</Cfloop>
																							</cfif>
																							
																								</TD>
																							</TR>
																						</TBODY>
																					</table>
																						
																		</td>
																	</tr>
																</table>
																		
																</td>
																<td class="groupRight">&nbsp;</td>
															</tr>
															<tr>
																<td class="groupBottomLeft"><img height=5 src='spacer.gif' width=1 ></td>
																<td class="groupBottom" colspan="2"><img height=1 src='spacer.gif' width=1 ></td>
																<td class="groupBottomRight"><img height=1 src='spacer.gif' width=1 ></td>
															</TR>
														</table> 
																
													</td>
												</tr>
											</table>
											

							
							<br />
							
					</td>
				</tr>
			</table>

<!------******************************************************---->

		<cfif update_messages.recordcount neq 0>
		
			<table width=93% border="1" align="center" cellpadding="4" cellspacing="4" bgcolor="##009966" class="style1">
				<tr>
					<td bordercolor="##009966"><b><u><font color="##ffffff">System Updates:</u></b><br>
						<cfloop query="update_messages">
						<b><a class=nav_bar href="" onClick="javascript: win=window.open('message_details.cfm?id=#update_messages.messageid#', 'Details', 'height=480, width=450, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><font color="##ffffff">#message#</font></b><br>
						</cfloop>
				 	</td>
				</tr>
			</table>
			
		</cfif>
		<cfif alert_messages.recordcount neq 0>
		
			<table width=93% border="1" align="center" cellpadding="4" cellspacing="4" bgcolor="##CC3300" class="style1">
				<tr>
					<td bordercolor="##CC3300">
						<b><u><font color="##ffffff">Alerts:</u></b><br>
						<cfloop query="alert_messages">
						<b><a class=nav_bar href="" onClick="javascript: win=window.open('message_details.cfm?id=#alert_messages.messageid#', 'Details', 'height=480, width=450, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><font color="##ffffff">#message#</font></a></b><br>
						</cfloop>
						</div>
				  </td>
				</tr>
			</table>
			
		</cfif>
		
		
		</td>
	</tr>
</table>
</cfoutput>