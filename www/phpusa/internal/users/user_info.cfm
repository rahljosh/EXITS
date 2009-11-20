<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>User Information</title>
<link rel="stylesheet" type="text/css" href="../phpusa.css" />
<!----Script to show diff fields---->			
<script type="text/javascript">
<!--
function changeDiv(the_div,the_change)
{
  var the_style = getStyleObject(the_div);
  if (the_style != false)
  {
	the_style.display = the_change;
  }
}
function hideAll()
{
  changeDiv("1","none");
  changeDiv("2","none");

}
function getStyleObject(objectId) {
  if (document.getElementById && document.getElementById(objectId)) {
	return document.getElementById(objectId).style;
  } else if (document.all && document.all(objectId)) {
	return document.all(objectId).style;
  } else {
	return false;
  }
}
// -->
</script>
</head>

<body>

<cfif isDefined('url.uniqueid')>
	<cfquery name="get_user_id" datasource="MySQL">
		SELECT userid 
		FROM smg_users
		WHERE uniqueid = '#url.uniqueid#'
	</cfquery>
	<cfset url.userid = #get_user_id.userid#>
<cfelseif IsDefined('url.id')>	
	<cfset url.userid = #url.id#>	
</cfif>

<cfinclude template="../check_rights.cfm">

<!----Rep Info---->
<cfquery name="rep_info" datasource="mysql">
	select users.*, smg_states.state as stateabv , smg_countrylist.countryname
	from smg_users users
	LEFT JOIN smg_countrylist ON countryid = users.country
	LEFT JOIN smg_states on smg_states.id = users.state
	where users.userid = '#url.userid#'
</cfquery>

<style type="text/css">
<!--
.smlink         		{font-size: 11px;}
.section        		{border-top: 1px solid #c6c6c6;; border-right: 2px solid #c6c6c6;border-left: 2px solid #c6c6c6;border-bottom: 0px; background: #Ffffe6;}
.sectionFoot    		{border-bottom: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;font-size:2px;}
.sectionBottomDivider 	{border-bottom: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;}
.sectionTopDivider 		{border-top: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;}
.sectionSubHead			{font-size:11px;font-weight:bold;}
.header { BACKGROUND-REPEAT: repeat-x; BACKGROUND-COLOR: #000000  }
.footer { BACKGROUND-IMAGE: url(pics/table-borders/footerBackground.gif); BACKGROUND-REPEAT: repeat-x; BACKGROUND-COLOR: #bf0301 }
-->
</style>

<cfoutput query="rep_info">
<br />
<!--- SIZING TABLE --->
<TABLE cellSpacing="0" cellPadding="0" align="center" class="regContainer">
	<tr><td class="header" colSpan="3"></td></tr>
	<tr><td colSpan="3" height="8"><img height=8 src="spacer.gif" width=1></td></tr>
	<tr><td colSpan="3" height="10">&nbsp;</td></tr>
	<tr>
		<td width="10">&nbsp;</td>
		<td>
			<table cellSpacing="0" cellPadding="0" border="0">
				<tr><td class="orangeLine" colSpan="4" height="11"><img height=11 src="spacer.gif" width=1></td></tr>
				<TR vAlign="top">
					<TD colspan=4 align="center">
						<h3>Please verify that your account information is correct.  Inaccurate information could result in 
						delayed communication, missed emails, inaccurate records and inefficient communication.</h3>
					</td>
					<td>&nbsp;&nbsp;&nbsp;</td>
				</tr>
				<tr><td colSpan="3" height="8"><img height=8 src="spacer.gif" width=1></td></tr>
				<tr><td class="orangeLine" colSpan="4" height="11"><img height=11 src="spacer.gif" width=1></td></tr>
				<tr><td colSpan="3" height="10">&nbsp;</td></tr>
						<tr>
							<td width="10">&nbsp;</td>
			
							<td colspan=3>
								<table cellspacing="0" cellpadding="3" width="100%" border="0">
									<tr>
										<td class="groupTopLeft">&nbsp;</td><td class="groupCaption" nowrap="true">
			Personal Information [<a href="?curdoc=users/edit_user&id=#url.userid#"> EDIT </a>]
				<cfif client.usertype LT 4>
					<cfif rep_info.changepass eq 1>
						<span class="get_attention"><font size=-2>User will be required to change pass on next log in.</span>
					</cfif>
				</cfif></td><td class="groupTop" width="95%">&nbsp;</td><td class="groupTopRight">&nbsp;</td>
									</tr><tr>
								
										<td class="groupLeft">&nbsp;</td><td colspan="2">
										<table id="rgbPersonalDetails" cellpadding="0" cellspacing="0" border="0" width="100%"><tr><td>
									<!----Table with Info in It---->
												<TABLE cellSpacing="0" cellPadding="0" width="100%" border="0">
													<TBODY>
														<TR>
															<TD valign="center">
																<!----Contact Info ---->
																	
																				
																<table width=100%>
																	<tr>
																		<td valign="top">
																		<cfform>
																		<cfif client.usertype eq 5>
						<cfinput type="radio" name="usertype" 	onClick="hideAll(); changeDiv('1','block');" checked value="personal">Personal <cfinput type="radio" name="usertype" 	onClick="hideAll(); changeDiv('2','block');" value="billing">Billing &nbsp;&nbsp;
						</cfif>
						  <div id="1" STYLE="display:block">
							#firstname# #lastname# (###userid#)<br>
							#address#<br>
							<cfif #address2# is ''><cfelse>#address2#<Br></cfif>
							#city# <cfif #usertype# is 8>#countryname#<cfelse>#stateabv#</cfif>, #zip#<Br>
							P: &nbsp;#phone# <cfif phone_ext is not ''>x#phone_ext#</cfif><br>
							C: &nbsp;#cell_phone#<br>
							W: #work_phone# <cfif work_ext is not ''>x#work_ext#</cfif><br>
							F: &nbsp;#fax#<br>
							E: <a href="mailto:#email#">#email#</a><br><br />	
							<b>PHP Contact</b><br />
							#php_contact_name#<br />
							P: #php_contact_phone#<br />
							E: #php_contact_email#<br />																									
							</div>
							<div id="2" STYLE="display:none">
							#billing_company#<br>
							#billing_contact#<br>
							#billing_address#<br>
							<cfif #billing_address2# is ''><cfelse>#billing_address2#<Br></cfif>
							#billing_city# #countryname#, #billing_zip#<Br>
							P: #billing_phone#<br>
							F: #billing_fax#<br>
							E: <a href="mailto:#billing_email#">#billing_email#</a><br>
						</div>
						</cfform>
						</td>
						<td valign="top">
								<div style="padding-left:5px; float:inherit"  >
					<strong>Last Login: </strong>#DateFormat(lastlogin, 'mm/dd/yyyy')# <br>
					<strong>User Entered:</strong> #DateFormat(datecreated, 'mm/dd/yyyy')# <br>
					<cfif client.usertype lte 4 or client.usertype lt #rep_info.usertype# or client.userid eq rep_info.userid>
						<strong>Username:</strong>&nbsp;&nbsp;&nbsp;<cfif rep_info.userid eq 9401>*******<cfelse>#username#</cfif><br>
						<strong>Password:</strong>&nbsp;&nbsp;&nbsp;<cfif rep_info.userid eq 9401>*******<cfelse>#password#</cfif><br>
					</cfif>
					<font size=-2><a href="?curdoc=users/resendlogin&userid=#userid#"><img src="pics/email.gif" border=0 align="left"> Resend Login Info Email</A><cfif isDefined('url.es')><font color="red"> - Login Information Sent</font></cfif>
					<cfif client.usertype LTE 5 or client.userid eq 9401><br>
						<a href="">view history</a>
					</cfif>
					</font>
				</div>
								
								</td>
							</tr>
						</table>
					
							
																											
																	
														</TD>
														
														
													</TR>
													</tr>
												</table>
						
									
										</td></tr></table></td><td class="groupRight">&nbsp;</td>
									</tr><tr>
										<td class="groupBottomLeft"><img height=5 src='spacer.gif' width=1 ></td><td class="groupBottom" colspan="2"><img height=1 src='spacer.gif' width=1 ></td><td class="groupBottomRight"><img height=1 src='spacer.gif' width=1 ></td>
									</tr>
								</table> 
								<td width="10">&nbsp;</td>
						</tr>
						<tr>
						<td width="10">&nbsp;</td>
							<td width=50%>
							
							
						<!----Schools and Students---->
						<table cellspacing="0" cellpadding="3" width="100%" border="0">
								<tr>
									<td class="groupTopLeft">&nbsp;</td><td class="groupCaption" nowrap="true">Schools & Students <cfif client.usertype lte 4>[<a href="?curdoc=users/new_user_details&userid=#url.userid#"> EDIT </a>]</cfif></td><td class="groupTop" width="95%">&nbsp;</td><td class="groupTopRight">&nbsp;</td>
								</tr><tr>
							
									<td class="groupLeft">&nbsp;</td><td colspan="2">
									<table id="rgbPersonalDetails" cellpadding="0" cellspacing="0" border="0" width="100%"><tr><td>
								<!----Table with Info in It---->
											<TABLE cellSpacing="0" cellPadding="0" width="100%" border="0">
												<TBODY>
													<TR>
														<TD valign="center">
															<!----Schools and students under rep ---->
																
																			
															<style type="text/css">
															<!--
															div.scroll {
																height: 100px;
																width: 380px;
																overflow: auto;
															}
															-->
															</style>
															<cfquery name="users_schools" datasource="mysql">
															select school_contacts.schoolid, school_contacts.userid, schools.schoolname, schools.city,
															states.state as stateshort
															from php_school_contacts school_contacts, php_schools schools, smg_states states
															where school_contacts.schoolid = schools.schoolid  
															and schools.state = states.id 
															and school_contacts.userid = #url.userid#
															order by schools.schoolname
															</cfquery>
															<div class="scroll">
																<!----scrolling table with school information---->
																<table width=100%>
																	<cfloop query="users_schools">
																	<strong>#schoolname# (#schoolid#)</strong> #city#, #stateshort#<br>
																	<cfquery name="students" datasource="mysql">
																	select students.firstname, students.familylastname, students.city, students.country,
																	countrylist.countryname
																	from smg_students students, smg_countrylist countrylist
																	where schoolid = #schoolid#
																	 and students.country = countrylist.countryid and active =1 and companyid = 6
																	order by familylastname
																	</cfquery>
																	<cfloop query="students">
																	&nbsp;&nbsp;&nbsp;&nbsp;#familylastname#, #firstname# from #city# #countryname#<br>
																	</cfloop>
																	
																	</cfloop>
																											
																	</td>
																</tr>
															</table>
					
							
																											
																	
														</TD>
														
														
													</TR>
													</tr>
												</table>
						
									
										</td></tr></table></td><td class="groupRight">&nbsp;</td>
									</tr><tr>
										<td class="groupBottomLeft"><img height=5 src='spacer.gif' width=1 ></td><td class="groupBottom" colspan="2"><img height=1 src='spacer.gif' width=1 ></td><td class="groupBottomRight"><img height=1 src='spacer.gif' width=1 ></td>
									</tr>
								</table> 
								<Td width=5></Td>
					<td valign="top">
										<!----User Type & Access info---->
										
						<table cellspacing="0" cellpadding="3" width="100%" border="0">
								<tr>
									<td class="groupTopLeft">&nbsp;</td><td class="groupCaption" nowrap="true">User Type & Access <cfif client.usertype lte 4><cfif not isDefined('url.access')>  [ <A href="?curdoc=forms/edit_user_access&id=#url.userid#">EDIT</a> ]</cfif></cfif> </td><td class="groupTop" width="95%">&nbsp;</td><td class="groupTopRight">&nbsp;</td>
								</tr><tr>
							
									<td class="groupLeft">&nbsp;</td><td colspan="2">
									<table id="rgbPersonalDetails" cellpadding="0" cellspacing="0" border="0" width="100%"><tr><td>
								<!----Table with Info in It---->
											<TABLE cellSpacing="0" cellPadding="0" width="100%" border="0">
												<TBODY>
													<TR>
														<TD valign="center">
															<!----Usertype & access Info---->
																<cfif not isDefined('url.access')>
<!----
																	 Current Access Level: <strong>#access_level.usertype#</strong><br>
																	 #access_level.typedescription# (see schools to left) 			
																	 <cfif access_level.usertypeid 	gte 2>
																	 <br>
																	 The schools that you manage, but are not directly responsable for students at are:
																	 </cfif>		
																	 ---->		
																<cfelseif url.access EQ 'AXIS'>
																Click Grant Access below to give this person access to AXIS. An email will be 
																sent to them informing them that they now have access.  <br>
																<div align="center"><a href="?curdoc=users/grant_access_qr&uniqueid=#url.uniqueid#"><img src="pics/confirm-access.jpg" alt="Confirm Access" width="126" height="32" border=0></a></div>
												
																</cfif>	
																<strong>Supervising Rep:</strong>
																<cfif php_superviser eq 0>
																<br />
																Not Supervised by Anyone.
																<cfelse>
																<cfquery name="supervising_rep" datasource="mysql">
																select firstname, lastname, userid
																from smg_users 
																where userid = #php_superviser#
																</cfquery>
																
																<br />
																 #supervising_rep.firstname# #supervising_rep.lastname# (#supervising_rep.userid#)	
																 </cfif>									
														</TD>
														<td>
														
														
														</td>
														
													</TR>
													</tr>
												</table>
						
						
									
										</td>
										
										</tr></table></td><td class="groupRight">&nbsp;</td>
										
										
									</tr><tr>
										<td class="groupBottomLeft"><img height=5 src='spacer.gif' width=1 ></td><td class="groupBottom" colspan="2"><img height=1 src='spacer.gif' width=1 ></td><td class="groupBottomRight"><img height=1 src='spacer.gif' width=1 ></td>
									</tr>
								</table> 
						</td>
					</tr>
						<tr>
							<td width="10">&nbsp;</td><td width=50%>
					
					<!----Employment Info---->
					
						<table cellspacing="0" cellpadding="3" width="420" border="0">
								<tr>
									<td class="groupTopLeft">&nbsp;</td><td class="groupCaption" nowrap="true">Employemnt Information</td><td class="groupTop" width="95%">&nbsp;</td><td class="groupTopRight">&nbsp;</td>
								</tr><tr>
							
									<td class="groupLeft">&nbsp;</td><td colspan="2">
									<table id="rgbPersonalDetails" cellpadding="0" cellspacing="0" border="0" width="100%"><tr><td>
								<!----Table with Info in It---->
											<TABLE cellSpacing="0" cellPadding="0" width="100%" border="0">
												<TBODY>
													<TR>
														<TD valign="center">
															<!----Employtment Info---->
																<cfif usertype is 5>
															<cfif rep_info.insurance_policy_type is ''><font color="FF0000">Missing insurance type for this Agent</font>
																<cfelseif rep_info.insurance_policy_type is 'none'>Does not take insurance provided by SMG
																<cfelse>Takes #rep_info.insurance_policy_type# insurance provided by SMG
															</cfif><br>
															<cfif rep_info.accepts_sevis_fee is ''>Missing SEVIS fee information
																<cfelseif rep_info.accepts_sevis_fee is '0'>Does not accept SEVIS fee
																<cfelse>Accepts SEVIS fee.
															</cfif><br>
														<Cfelse>
															<strong>Occupation:</strong> #occupation#<br>
															<strong>Employer:</strong> #businessname#<br>
															<strong>Work Phone:</strong> #work_phone#
															</cfif>
																
					
							
																											
																	
														</TD>
														<td>
														
														
														</td>
														
													</TR>
													</tr>
												</table>
						
						
									
										</td>
										
										</tr></table></td><td class="groupRight">&nbsp;</td>
										
										
									</tr><tr>
										<td class="groupBottomLeft"><img height=5 src='spacer.gif' width=1 ></td><td class="groupBottom" colspan="2"><img height=1 src='spacer.gif' width=1 ></td><td class="groupBottomRight"><img height=1 src='spacer.gif' width=1 ></td>
									</tr>
								</table> 
								
								
						</td>
						<Td width=5></Td>
						<td valign="top">
										<!----Payment info---->
										
						<table cellspacing="0" cellpadding="3" width="100%" border="0">
								<tr>
									<td class="groupTopLeft">&nbsp;</td><td class="groupCaption" nowrap="true">Payment Information</td><td class="groupTop" width="95%">&nbsp;</td><td class="groupTopRight">&nbsp;</td>
								</tr><tr>
							
									<td class="groupLeft">&nbsp;</td><td colspan="2">
									<table id="rgbPersonalDetails" cellpadding="0" cellspacing="0" border="0" width="100%"><tr><td>
								<!----Table with Info in It---->
											<TABLE cellSpacing="0" cellPadding="0" width="100%" border="0">
												<TBODY>
													<TR>
														<TD valign="center">
															<!----Payment Info---->
																 Available soon<br>
																	
														</TD>
														<td>
														
														
														</td>
														
													</TR>
													</tr>
												</table>
						
						
									
										</td>
										
										</tr></table></td><td class="groupRight">&nbsp;</td>
										
										
									</tr><tr>
										<td class="groupBottomLeft"><img height=5 src='spacer.gif' width=1 ></td><td class="groupBottom" colspan="2"><img height=1 src='spacer.gif' width=1 ></td><td class="groupBottomRight"><img height=1 src='spacer.gif' width=1 ></td>
									</tr>
								</table> 
						
						
						</td>
						</tr>
					</table>
					
					<!----End of File--->
	<tr><td class="footer" colSpan="3"></td></tr>
</TABLE>
<br />

</TD>
</TR>
</TBODY>
</TABLE> 
</cfoutput>
</body>
</html>