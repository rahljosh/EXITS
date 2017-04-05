<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Grant Access</title>

</head>
<body>

<cftry>

<cfoutput>

<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="CCCCCC" bgcolor="FFFFFF">
	<tr>
		<td bordercolor="FFFFFF">
			<!----Header Table---->
			<table width=100% cellpadding=0 cellspacing=0 border=0 align="center" height="25" bgcolor="E4E4E4">
				<tr bgcolor="E4E4E4">
					<td class="title1">&nbsp; &nbsp; Grant Access</td>
				</tr>
			</table>
			<br>
			<cfif NOT IsDefined('form.uniqueid')>

				<cfparam name="form.userid" default="">
				<cfparam name="form.firstname" default="">
				<cfparam name="form.lastname" default="">
				<cfparam name="form.email" default="">
				
				<cfform method="post" name="new_user" action="">
				<table width="90%" border="0" cellpadding="0" cellspacing="0" align="center">	
					<tr>
						<td width="100%" valign="top">
							<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
								<tr>
									<td bordercolor="FFFFFF">
										<table width="100%" cellpadding=3 cellspacing=0 border=0>
											<tr bgcolor="C2D1EF">
												<td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Grant Access &nbsp - &nbsp Users Search</td>
											</tr>
											<tr><td colspan="2" class="style1">Please enter any information on the person you would like to give access to and then click on search.</td></tr>
											<tr>
												<td class="style1" width="15%"><b>User ID:</b></td>
												<td class="style1" width="85%"><cfinput type="text" name="userid" value="#form.userid#" size="10" maxlength="6"></td>
											</tr>											
											<tr>
												<td class="style1"><b>First Name:</b></td>
												<td class="style1"><cfinput type="text" name="firstname" value="#form.firstname#" size="30" maxlength="100"></td>
											</tr>
											<tr>
												<td class="style1"><b>Last Name:</b></td>
												<td class="style1"><cfinput type="text" name="lastname" value="#form.lastname#" size="30" maxlength="100"></td>
											</tr>
											<tr>
												<td class="style1"><b>Email:</b></td>
												<td class="style1"><cfinput type="text" name="email" value="#form.email#" size="30" maxlength="100"></td>
											</tr>											
											<tr><td align="center" colspan="2"><br><cfinput name="Submit" type="image" value="  next  " src="../pics/search.gif" alt="Next" border="0"></td></tr>				
										</table>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				<br />
				</cfform>
				
				<!--- SEARCH RESULTS --->
				<cfif form.userid NEQ '' OR form.firstname NEQ '' OR form.lastname NEQ '' OR form.email NEQ ''>
					<cfquery name="find_user" datasource="MySql">
						SELECT userid, firstname, lastname, uniqueid, email, phone
						FROM smg_users
						WHERE active = '1'
							<cfif form.userid NEQ ''>
								AND userid = <cfqueryparam value="#form.userid#" cfsqltype="cf_sql_integer">
							</cfif>
							<cfif form.firstname NEQ ''>
								AND firstname LIKE '%#form.firstname#%'
							</cfif>
							<cfif form.lastname NEQ ''>
								AND lastname LIKE '%#form.lastname#%'
							</cfif>
							<cfif form.email NEQ ''>
								AND email LIKE '%#form.email#%'
							</cfif>
					</cfquery>
					<table width="90%" border="0" cellpadding="0" cellspacing="0" align="center">	
						<tr>
							<td width="100%" valign="top">
								<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
									<tr>
										<td bordercolor="FFFFFF">
											<table width="100%" cellpadding=3 cellspacing=0 border=0>
												<tr bgcolor="C2D1EF">
													<td colspan="4" class="style2" bgcolor="8FB6C9">&nbsp;:: Search Results</td>
												</tr>
												<tr><td colspan="4" class="style1">Once you found the person click the "Grant Access" link and follow the instructions.</td></tr>
												<cfif find_user.recordcount EQ 0>
													<tr><td colspan="4" class="style1">No matches found, please try again.</td></tr>
												<cfelse>
													<tr>
														<cfloop query="find_user">
															<td class="style1">
																Name: #find_user.firstname# #find_user.lastname#<br>
																Email: #find_user.email#<br>
																Phone: #find_user.phone#<br>
																ID: ###find_user.userid#
																<cfform name="grant_access" method="post" action="?curdoc=user/grant_access">
																	<cfinput type="hidden" name="uniqueid" value="#find_user.uniqueid#">
																	<cfinput type="hidden" name="userid" value="#find_user.userid#">
																	<cfinput type="image" name="submit" src="../pics/grant-access.gif">
																</cfform>
															</td>
															<cfif (find_user.currentrow MOD 4) EQ 0></tr><tr></tr></cfif>
														</cfloop>
												</cfif>
											</table>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
					<br />
				</cfif>
				<!--- END SEARCH RESULTS --->
			
			<!--- GRANT ACCESS TO CHOSEN USER --->
			<cfelse>
			
				<!--- GET COMPANIES SESSION.USERID HAS ACCESS TO --->
				<cfquery name="get_companies" datasource="MySql">
					SELECT DISTINCT uar.userid, uar.companyid
					FROM user_access_rights uar
					INNER JOIN smg_companies c ON c.companyid = uar.companyid
					WHERE userid = '#client.userid#'
						AND c.system_id = '4'
					GROUP BY uar.companyid
				</cfquery>
				
				<cfquery name="list_companies" datasource="MySql">
					SELECT c.companyid, c.companyshort
					FROM smg_companies c
					WHERE c.system_id = '4'
					<cfif client.usertype NEQ '1'>
						AND c.companyid IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#ValueList(get_companies.companyid)#" list="yes">)
					</cfif>
				</cfquery>
				
				<cfinclude template="../querys/get_usertype.cfm">
				<!--- END OF - GET COMPANIES SESSION.USERID HAS ACCESS TO --->
				
				<cfquery name="get_user" datasource="MySql">
					SELECT userid, firstname, lastname, uniqueid, email, phone
					FROM smg_users
					WHERE userid = <cfqueryparam value="#form.userid#" cfsqltype="cf_sql_integer">
				</cfquery>
				
				<cfform method="post" name="new_user" action="?curdoc=user/qr_grant_access">	
				<cfinput type="hidden" name="userid" value="#get_user.userid#">
				<table width="90%" border="0" cellpadding="0" cellspacing="0" align="center">	
					<tr>
						<td width="100%" valign="top">
							<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
								<tr>
									<td bordercolor="FFFFFF">
										<table width="100%" cellpadding=3 cellspacing=0 border=0>
											<tr bgcolor="C2D1EF">
												<td colspan="3" class="style2" bgcolor="8FB6C9">&nbsp;:: Grant Access</td>
											</tr>
											<tr><td colspan="3" class="style1">
													Name: #get_user.firstname# #get_user.lastname#<br>
													Email: #get_user.email#<br>
													Phone: #get_user.phone#<br>
													ID: ###get_user.userid#
												</td>
											</tr>
											<tr>
												<td class="style1" width="30%"><b>Company</b></td>
												<td class="style1" width="30%"><b>Usertype</b></td>
												<td class="style1" width="40%">&nbsp;</td>
											</tr>
											<tr>
												<td class="style1">
													<cfselect name="companyid" required="yes" message="You must select a company in order to continue">
														<option value="0"></option>
														<cfloop query="list_companies">
															<option value="#companyid#">#companyshort#</option>
														</cfloop>
													</cfselect>
												</td>
												<td class="style1">
													<cfselect name="usertype" required="yes" message="You must select an usertype in order to continue">
														<option value="0"></option>
														<cfloop query="get_usertype">
															<option value="#usertypeid#">#usertype#</option>
														</cfloop>
													</cfselect>	
												</td>
												<td>&nbsp;</td>
											</tr>
											<tr><td align="center" colspan="3"><br><cfinput name="Submit" type="image" value="  next  " src="../pics/save.gif" alt="Next" border="0"></td></tr>											
										</table>									
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				</cfform>
				<br />
			</cfif>
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
