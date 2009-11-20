<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<!-- InstanceBegin template="/Templates/phpusa_template.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- InstanceBeginEditable name="doctitle" -->
<title>DMD-PHP</title>
<!-- InstanceEndEditable -->
<!-- InstanceBeginEditable name="head" -->

<!-- InstanceEndEditable -->
</head>
<body>
<!----header of table---->

<!--- SIZING TABLE --->
<link rel="stylesheet" type="text/css" href="../phpusa.css" />
<!---- Outer Table (outline and title ---->

		<TABLE cellSpacing="0" cellPadding="0" align="center" class="regContainer" border=0>
				<TR vAlign="top">
					<TD colspan=4 align="center">
						<h3>
						<!-- InstanceBeginEditable name="top message" -->
								Please enter the following contact information and assign the user to one or more schools. <br>User will receive an email notification containing their account info.
								  
								  <!-- InstanceEndEditable -->					  </td>
								
		  </tr>
							<tr>
								<td colSpan="3" height="8"><img height=8 src="spacer.gif" width=1></td>

							</tr>
							<tr>
								<td class="orangeLine" colSpan="8" height="11"><img height=11 src="spacer.gif" width=1></td>
							</tr>
							<tr>
								<td colSpan="3" height="10">&nbsp;</td>
							</tr>
							<tr>
								<td width="10">&nbsp;</td>
								<td>

<!-- InstanceBeginEditable name="body" -->
<HEAD>

</HEAD>

<cfform name=frmPhone method="post" action="index.cfm?curdoc=users/new_user_details_qr">
<cfquery name="user_info" datasource="mysql">
	select state, firstname, lastname, phone, phone_ext, work_phone, work_ext, cell_phone, fax
	from smg_users
	where userid = '#url.userid#'
</cfquery>

<table cellspacing="0" cellpadding="3" width="100%" border="0">
										<tr>
											<td class="groupTopLeft">&nbsp;</td><td class="groupCaption" nowrap="true">
				Assign Schools 
					</td><td class="groupTop" width="95%">&nbsp;</td><td class="groupTopRight">&nbsp;</td>
										</tr><tr>
									
											<td class="groupLeft">&nbsp;</td><td colspan="2">
											<table id="rgbPersonalDetails" cellpadding="0" cellspacing="0" border="0" width="100%"><tr><td>
										<!----Table with Info in It---->
													<TABLE cellSpacing="0" cellPadding="0" width="100%" border="0">
														<TBODY>
															<TR>
																<TD valign="center">
																	<!----Schools ---->
																		
																					
																	<cfinclude template="new_user_details_schools.cfm">
							
									
																													
																			
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
</td>
<td></td>

<cfoutput>
<td colspan=10 align="center">
	<cfif IsDefined('url.new')><h3>When this form is submitted, #user_info.firstname# will receive an email with instruction on accessing the sytem.<br></h3></cfif>
	<div align="center">
	<input type="image" name="imgSubmit" src="pics/update.gif" alt="Submit" border="0" />
	<input type="hidden" value="#url.userid#" name="userid">
	</div>
</td>
</cfoutput>
</table>
</cfform>

<!-- InstanceEndEditable -->

<cfinclude template="../bottom.cfm">
</body>
<!-- InstanceEnd --></html>

</body>
</html>