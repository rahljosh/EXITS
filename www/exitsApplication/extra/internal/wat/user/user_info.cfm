<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>New International Representative</title>

<SCRIPT LANGUAGE="JavaScript">
<!-- Begin -->
function UserName() {
	document.new_user.username.value = document.new_user.email.value;
}
<!--  End -->
</script>

<cftry>

</head>
<body>

<cfquery name="get_user" datasource="MySql">
	SELECT *
	FROM smg_users
	WHERE uniqueid = <cfqueryparam value="#url.uniqueid#" cfsqltype="cf_sql_char">
</cfquery>

<cfquery name="get_user_access" datasource="MySql">
	SELECT uar.id, uar.companyid, c.companyshort, uar.usertype, ut.usertype as usertypename, default_region
	FROM user_access_rights uar
	INNER JOIN smg_companies c ON c.companyid = uar.companyid
	INNER JOIN smg_usertype ut ON ut.usertypeid = uar.usertype
	WHERE userid = '#get_user.userid#'
		AND c.system_id = '4'
	ORDER BY default_region DESC
</cfquery>

<!--- GET COMPANIES SESSION.USERID HAS ACCESS TO --->
<cfquery name="list_companies" datasource="MySql">
	SELECT DISTINCT uar.userid, uar.companyid, c.companyshort
	FROM user_access_rights uar
	INNER JOIN smg_companies c ON c.companyid = uar.companyid
	WHERE userid = '#client.userid#'
		AND c.system_id = '4'
	GROUP BY uar.companyid
</cfquery>

<cfquery name="get_usertype" datasource="MySql">
	SELECT usertypeid, usertype
	FROM smg_usertype
	WHERE usertypeid >= '#client.usertype#' 
		AND usertypeid <= '3'
</cfquery>
<!--- END OF - GET COMPANIES SESSION.USERID HAS ACCESS TO --->


<cfinclude template="../querys/statelist.cfm">

<cfinclude template="../querys/countrylist.cfm">

<cfinclude template="../querys/get_usertype.cfm">

<cfparam name="edit" default="no">

<cfoutput>

<cfform method="post" name="new_user" action="?curdoc=user/qr_user_info">
<input type="hidden" name="userid" value="#get_user.userid#">
<input type="hidden" name="uniqueid" value="#get_user.uniqueid#">

<cfif isDefined('form.edit') AND (listFind("1,2,3,4,8", CLIENT.userType))>
	<cfset edit = '#form.edit#'>
</cfif>

<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="CCCCCC" bgcolor="f4f4f4">
	<tr>
		<td bordercolor="FFFFFF">
			<!----Header Table---->
			<table width=95% cellpadding=0 cellspacing=0 border=0 align="center" height="25" bgcolor="E4E4E4">
				<tr bgcolor="E4E4E4">
					<td class="title1">&nbsp; &nbsp; User Information</td>
				</tr>
			</table>
			<br />
			<table width="90%" border="0" cellpadding="0" cellspacing="0" align="center" bordercolor="C7CFDC">	
				<tr>
					<td width="49%" valign="top">
						<!--- PERSONAL INFO --->
						<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF">
									<table width="100%" cellpadding=3 cellspacing=0 border=0>
										<tr bgcolor="C2D1EF">
											<td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Personal Information</td>
										</tr>
										<tr>
											<td class="style1"><b>User ID:</b></td>
											<td class="style1">###get_user.userid#</td>
										</tr>	
										<tr>
											<td class="style1" width="30%"><b>User Entered:</b></td>
											<td class="style1" width="70%">#DateFormat(get_user.datecreated, 'mm/dd/yyyy')#</td>
										</tr>
                                        <tr>
											<td class="style1"><b>Status:</b></td>
											<td class="style1">
												<!--- Only Office Users --->
                                                <cfif listFind("1,2,3,4", CLIENT.userType)>
                                                        
                                                    <cfif edit EQ 'yes'>
                                                        <cfif get_user.active EQ '1'><input type="radio" name="active" value="1" checked="yes"> <cfelse> <input type="radio" name="active" value="1"> </cfif> Active
                                                        <cfif get_user.active EQ '0'><input type="radio" name="active" value="0" checked="yes"> <cfelse> <input type="radio" name="active" value="1"> </cfif> Inactive																
                                                    <cfelse>
                                                        <cfif get_user.active EQ '1'>Active<cfelse>Inactive</cfif>
                                                    </cfif>											
												
												<cfelse>
                                                	
                                                    <cfif get_user.active EQ '1'>Active<cfelse>Inactive</cfif>
                                                
                                                </cfif>				
											</td>
										</tr>
										<tr>
											<td class="style1"><b>First Name:</b></td>
											<td class="style1"><cfif edit EQ 'yes'><cfinput type="text" name="firstname" value="#get_user.firstname#" size="30" maxlength="100" required="yes" message="First Name is Required."><cfelse>#get_user.firstname#</cfif></td>
										</tr>
										<tr>
											<td class="style1"><b>Middle Name:</b></td>
											<td class="style1"><cfif edit EQ 'yes'><input type="text" name="middlename" value="#get_user.middlename#" size="30" maxlength="100"><cfelse>#get_user.middlename#</cfif></td>
										</tr>											
										<tr>
											<td class="style1"><b>Last Name:</b></td>
											<td class="style1"><cfif edit EQ 'yes'><cfinput type="text" name="lastname" value="#get_user.lastname#" size="30" maxlength="100" required="yes" message="Last Name is Required."><cfelse>#get_user.lastname#</cfif></td>
										</tr>
										<tr>
											<td class="style1"><b>Sex:</b></td>
											<td class="style1">
												<cfif edit EQ 'yes'>
													<cfif get_user.sex EQ 'Male'><input type="radio" name="sex" value="Male" checked="yes"> <cfelse> <input type="radio" name="sex" value="Male"> </cfif> Male
													<cfif get_user.sex EQ 'Female'><input type="radio" name="sex" value="Female" checked="yes"> <cfelse> <input type="radio" name="sex" value="Female"> </cfif> Female																
												<cfelse>
													<cfif get_user.sex EQ 'Male'>Male<cfelse>Female</cfif>
												</cfif>
											</td>
										</tr>
										<tr>
											<td class="style1"><b>Date of Birth:</b></td>
											<td class="style1"><cfif edit EQ 'yes'><input type="text" name="dob" value="#DateFormat(get_user.dob, 'mm/dd/yyyy')#" size="8" maxlength="10"><cfelse>#DateFormat(get_user.dob, 'mm/dd/yyyy')#</cfif> mm/dd/yyyy</td>
										</tr>																				
										<tr>
											<td class="style1"><b>Drivers License:</b></td>
											<td class="style1"><cfif edit EQ 'yes'><input type="text" name="drivers_license" value="#get_user.drivers_license#" size="20" maxlength="20"><cfelse>#get_user.drivers_license#</cfif></td>											
										</tr>																				
										<tr>
											<td class="style1"><b>Address:</b></td>
											<td class="style1"><cfif edit EQ 'yes'><input type="text" name="address" value="#get_user.address#" size="40" maxlength="100"><cfelse>#get_user.address#</cfif></td>											
										</tr>
										<tr>
											<td class="style1"></td>
											<td class="style1"><cfif edit EQ 'yes'><input type="text" name="address2" value="#get_user.address2#" size="40" maxlength="100"><cfelse>#get_user.address2#</cfif></td>											
										</tr>											
										<tr>
											<td class="style1"><b>City:</b></td>
											<td class="style1"><cfif edit EQ 'yes'><input type="text" name="city" value="#get_user.city#" size="30" maxlength="100"><cfelse>#get_user.city#</cfif></td>											
										</tr>
										<tr>
											<td class="style1"><b>State:</b></td>
											<td colspan="3" class="style1">
												<cfif edit EQ 'yes'>		
												<select name="state">
													<option value="0">State...</option>
													<cfloop query="statelist">
													<option value="#id#" <cfif id EQ get_user.state>selected</cfif>>#statename#</option>
													</cfloop>
												</select>	
												<cfelse>
													<cfloop query="statelist">
														<cfif id EQ get_user.state>#statename#</cfif>
													</cfloop>
												</cfif>													
											</td>
										</tr>
										<tr>
											<td class="style1"><b>Country:</b></td>
											<td colspan="3" class="style1">
												<cfif edit EQ 'yes'>		
													<select name="country">
														<option value="0">Country...</option>
														<cfloop query="countrylist">
														<option value="#countryid#" <cfif countryid EQ get_user.country>selected</cfif>>#countryname#</option>
														</cfloop>
													</select>	
												<cfelse>
													<cfloop query="countrylist">
														<cfif countryid EQ get_user.country>#countryname#</cfif>
													</cfloop>
												</cfif>	
											</td>
										</tr>										
										<tr>
											<td class="style1"><b>Postal Code:</b></td>
											<td class="style1"><cfif edit EQ 'yes'><input type="text" name="zip" value="#get_user.zip#" size="8" maxlength="10"><cfelse>#get_user.zip#</cfif></td>											
										</tr>
									</table>
								</td>
							</tr>
						</table>
						
                        <br />
                        
						<!--- EMPLOYMENT INFORMATION --->	
                        <table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
                            <tr>
                                <td bordercolor="FFFFFF">
                                    <table width="100%" cellpadding=3 cellspacing=0 border=0>
                                        <tr bgcolor="C2D1EF">
                                            <td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Employment Information</td>
                                        </tr>
                                        <tr>
                                            <td class="style1"><b>Business Name:</b></td>
                                            <td class="style1"><cfif edit EQ 'yes' AND CLIENT.userType NEQ 8><input type="text" name="businessname" value="#get_user.businessname#" size="40" maxlength="100"><cfelse>#get_user.businessname#</cfif></td>
                                        </tr>	
                                        <tr>
                                            <td class="style1" width="30%"><b>Occupation:</b></td>
                                            <td class="style1" width="70%"><cfif edit EQ 'yes'><input type="text" name="occupation" value="#get_user.occupation#" size="40" maxlength="100"><cfelse>#get_user.occupation#</cfif></td>
                                        </tr>											
                                        <tr>
                                            <td class="style1"><b>Work Phone:</b></td>
                                            <td class="style1" colspan="3"><cfif edit EQ 'yes'><input type="text" name="work_phone" value="#get_user.work_phone#" size="15" maxlength="20"><cfelse>#get_user.work_phone#</cfif></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                                                
                        <br />

                        <!--- DEFAULT COMPANY ACCESS INFORMATION --->
						<cfif listFind("1,2,3,4", CLIENT.userType)>
						
							<!--- NOTES / MISCELLANEOUS INFORMATION --->
                            <table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
                                <tr>
                                    <td bordercolor="FFFFFF">
                                        <table width="100%" cellpadding=3 cellspacing=0 border=0>
                                            <tr bgcolor="C2D1EF">
                                                <td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Notes / Miscellaneous Information</td>
                                            </tr>
                                            <tr>
                                                <td class="style1" width="30%" valign="top"><b>Notes:</b></td> 
                                                <td class="style1" width="70%">
                                                    <textarea cols="40" rows="8" name="comments" <cfif edit NEQ 'yes'>disabled="disabled"</cfif>>#Replace(get_user.comments,"<br />","#chr(10)#","all")#</textarea>
                                                </td>
                                            </tr>
                                        </table>									
                                    </td>
                                </tr>
                            </table>
                            
                    	</cfif>
                        
					</td>
                    
					<td width="2%" valign="top">&nbsp;</td>
                    
					<td width="49%" valign="top">
                    
						<!--- CONTACT INFO --->
						<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF">
									<table width="100%" cellpadding=3 cellspacing=0 border=0>
										<tr bgcolor="C2D1EF" bordercolor="FFFFFF">
											<td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Contact Information</td>
										</tr>
										<tr>
											<td class="style1" width="30%"><b>Home Phone:</b></td>
											<td class="style1" width="70%"><cfif edit EQ 'yes'><input type="text" name="phone" value="#get_user.phone#" size="15" maxlength="20"><cfelse>#get_user.phone#</cfif></td>
										</tr>
										<tr>
											<td class="style1"><b>Cell Phone:</b></td>
											<td class="style1"><cfif edit EQ 'yes'><input type="text" name="cell_phone" value="#get_user.cell_phone#" size="15" maxlength="20"><cfelse>#get_user.cell_phone#</cfif></td>
										</tr>
										<tr>
											<td class="style1"><b>Fax:</b></td>
											<td class="style1"><cfif edit EQ 'yes'><input type="text" name="fax" value="#get_user.fax#" size="15" maxlength="20"><cfelse>#get_user.fax#</cfif></td>
										</tr>											
										
										<tr>
											<td class="style1"><b>Email:</b></td>
											<td class="style1">
											<cfif client.usertype LT get_user.usertype>
												<cfif edit EQ 'yes'><input type="text" name="email" size="40" value="#get_user.email#" maxlength="100" onChange="UserName()"><cfelse>#get_user.email#</cfif>
											<cfelse>
												<cfif edit EQ 'yes'><input type="text" name="email" size="40" value="#get_user.email#" maxlength="100"><cfelse>#get_user.email#</cfif>
											</cfif>
											</td>
										</tr>
										<tr>
											<td class="style1"><b>Alt. Email:</b></td>
											<td class="style1"><cfif edit EQ 'yes'><input type="text" name="email2" value="#get_user.email2#" size="40" maxlength="100"><cfelse>#get_user.email2#</cfif></td>
										</tr>
									</table>																		
								</td>
							</tr>
						</table>
                        
						<br />
                        
						<!--- LOGIN INFORMATION --->
						<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF">
									<table width="100%" cellpadding=3 cellspacing=0 border=0>
										<tr bgcolor="C2D1EF">
											<td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Usertype / Login Information</td>
										</tr>
										<tr>
											<td class="style1" width="30%"><b>Username:</b></td>
											<td class="style1" width="70%">
												<cfif client.usertype LT get_user.usertype OR client.userid EQ get_user.userid>
													<cfif edit EQ 'yes'><cfinput type="text" name="username" value="#get_user.username#" size="40" maxlength="50" required="yes" message="You must enter a username in order to continue."><cfelse>#get_user.username#</cfif></td>
												<cfelse>
													#get_user.username#
												</cfif>
											</td>
										</tr>
										<tr><td></td><td><font size="-2">* Defaults to email address, change if desire.</font></td></tr>											
										<tr>
											<td class="style1"><b>Password:</b></td>
											<td class="style1">
												<cfif (client.usertype LT get_user.usertype OR client.userid EQ get_user.userid) AND client.usertype NEQ '8'>
													<cfif edit EQ 'yes'><cfinput type="text" name="password" value="#get_user.password#" size="10" maxlength="15" required="yes" message="You must enter a password in order to continue."><cfelse>#get_user.password#</cfif>
												<cfelseif client.usertype EQ '8'>
                                                	******** <a href="?curdoc=user/password_reset">[ Change Password ]</a>
                                                <cfelse>
													********
												</cfif>
											</td>											
										</tr>
									</table>									
								</td>
							</tr>
						</table>
                        
						<br />
                        
                        <!--- DEFAULT COMPANY ACCESS INFORMATION --->
						<cfif listFind("1,2,3,4", CLIENT.userType)>

							<!--- COMPANY ACCESS INFORMATION --->
                            <table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
                                <tr>
                                    <td bordercolor="FFFFFF">
                                        <table width="100%" cellpadding=3 cellspacing=0 border=0>
                                            <tr bgcolor="C2D1EF">
                                                <td colspan="3" class="style2" bgcolor="8FB6C9">&nbsp;:: Company Access</td>
                                            </tr>
                                            <tr>
                                                <td class="style1" width="40%"><b>Company</b></td>
                                                <td class="style1" width="40%"><b>Usertype</b></td>
                                                <td class="style1" width="20%" align="center"><b>Delete</b></td>
                                            </tr>
                                            <cfif edit EQ 'yes' AND listFind("1,2,3,4", CLIENT.userType)>
                                                <!--- EDIT COMPANY ACCESS --->
                                                <input type="hidden" name="user_access_count" value="#get_user_access.recordcount#">
                                                <cfloop query="get_user_access">
                                                    <input type="hidden" name="access_id_#currentrow#" value="#get_user_access.id#">
                                                    <tr>
                                                        <td class="style1">
                                                            #companyshort#
                                                        </td>
                                                        <td class="style1">
                                                        <!--- USERTYPE --->
                                                        <cfif usertype GTE client.usertype> 
                                                            <select name="usertype_#currentrow#">
                                                                <cfset loop_companyid = #get_user_access.companyid#>
                                                                <cfset loop_usertype = #get_user_access.usertype#>
                                                                <cfloop query="get_usertype">
                                                                    <option value="#usertypeid#" <cfif loop_usertype EQ usertypeid>selected</cfif>>#usertype#</option>
                                                                </cfloop>
                                                            </select>
                                                        <cfelse>
                                                            #usertypename#
                                                            <input type="hidden" name="usertype_#currentrow#" value="#usertype#">
                                                        </cfif>
                                                        </td>
                                                        <td class="style1" align="center">
                                                            <cfif usertype GTE client.usertype>	
                                                                <input type="checkbox" name="delete_#currentrow#">
                                                            </cfif>
                                                        </td>																				
                                                    </tr>
                                                </cfloop>
                                                <!--- NEW COMPANY ACCESS --->
                                                <tr><td class="style1" colspan="1"><b>New Access Level</b></td></tr>
                                                <tr>
                                                    <td class="style1">
                                                        <select name="companyid_new">
                                                            <option value="0"></option>
                                                            <cfloop query="list_companies">
                                                                <option value="#companyid#">#companyshort#</option>
                                                            </cfloop>
                                                        </select>
                                                    </td>
                                                    <td class="style1">
                                                        <select name="usertype_new">
                                                            <option value="0"></option>
                                                            <cfloop query="get_usertype">
                                                                <option value="#usertypeid#">#usertype#</option>
                                                            </cfloop>
                                                        </select>												
                                                    </td>
                                                    <td class="style1">&nbsp;</td>
                                                </tr>
                                            <cfelse>
                                                <cfloop query="get_user_access">
                                                    <tr>
                                                        <td class="style1">#companyshort#</td>
                                                        <td class="style1">#usertypename#</td>
                                                        <td class="style1">&nbsp;</td>																				
                                                    </tr>
                                                </cfloop>
                                            </cfif>
                                        </table>									
                                    </td>
                                </tr>
                            </table>
                            <br />
                        
                            <table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
                                <tr>
                                    <td bordercolor="FFFFFF">
                                        <table width="100%" cellpadding=3 cellspacing=0 border=0>
                                            <tr bgcolor="C2D1EF"><td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Default Company Access</td></tr>
                                            <tr>
                                                <td class="style1" width="40%"><b>Default Company:</b></td>
                                                <td class="style1" width="60%">
                                                    <cfif edit EQ 'yes' AND listFind("1,2,3,4", CLIENT.userType)>
                                                        <select name="default_company">
                                                            <option value="0"></option>
                                                            <cfloop query="get_user_access">
                                                                <option value="#companyid#" <cfif default_region EQ 1>selected</cfif>>#companyshort#</option>
                                                            </cfloop>
                                                        </select>													
                                                    <cfelse>
                                                        <cfif get_user_access.default_region EQ 1>#get_user_access.companyshort#<cfelse>n/a</cfif>
                                                    </cfif>
                                                </td>
                                            </tr>
                                        </table>									
                                    </td>
                                </tr>
                            </table>
						</cfif>
                        
					</td>	
				</tr>
			</table>
            
			<!---- SAVE BUTTON - OFFICE USERS AND INTERNATIONAL REPRESENTATIVES ---->
			<cfif (listFind("1,2,3,4,8", CLIENT.userType) AND edit EQ 'yes')>
                <table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
                    <tr><td align="center"><br /><input name="Submit" type="image" value="  save  " src="../pics/save.gif" alt="Save" border="0" style="padding-bottom:10px;"></td></tr>
                </table>
			</cfif>
            
			</cfform>
			
			<!---- EDIT BUTTON - OFFICE USERS AND INTERNATIONAL REPRESENTATIVES ---->
			<cfif (listFind("1,2,3,4,8", CLIENT.userType) AND edit EQ 'no')>
                <table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
                    <tr><td align="center">
                        <form action="" method="post">&nbsp;
                            <input type="hidden" name="edit" value="yes">
                            <input name="Submit" type="image" value="  edit  " src="../pics/edit.gif" alt="Edit" border=0 style="padding-bottom:10px;">
                        </form>
                        </td>
                    </tr>
                </table>
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