<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Edit User</title>
<link rel="stylesheet" type="text/css" href="forms/phpcss.css">
<style>
.vline { BACKGROUND-IMAGE: url(pics/table-borders/left-vert-line.gif); BACKGROUND-REPEAT: repeat-y }
.grouptopleft { BACKGROUND-POSITION: 50% bottom; BACKGROUND-IMAGE: url(pics/table-borders/topleft.gif); BACKGROUND-REPEAT: no-repeat }
.groupTop { BACKGROUND-POSITION: 50% bottom; BACKGROUND-IMAGE: url(pics/table-borders/top.gif); BACKGROUND-REPEAT: repeat-x }
.groupTopRight { BACKGROUND-POSITION: left bottom; BACKGROUND-IMAGE: url(pics/table-borders/topright.gif); BACKGROUND-REPEAT: no-repeat }
.groupLeft { BACKGROUND-POSITION-X: right; BACKGROUND-IMAGE: url(pics/table-borders/left-vert-line.gif); BACKGROUND-REPEAT: repeat-y }
.groupRight { BACKGROUND-IMAGE: url(pics/table-borders/right.gif); BACKGROUND-REPEAT: repeat-y }
.groupBottomLeft { BACKGROUND-POSITION: right top; BACKGROUND-IMAGE: url(pics/table-borders/bottomleft.gif); BACKGROUND-REPEAT: no-repeat }
.groupBottom { BACKGROUND-POSITION: 50% top; BACKGROUND-IMAGE: url(pics/table-borders/bottom.gif); BACKGROUND-REPEAT: repeat-x }
.groupBottomRight { BACKGROUND-POSITION: left top; BACKGROUND-IMAGE: url(pics/table-borders/bottomright.gif); BACKGROUND-REPEAT: no-repeat }
.header { BACKGROUND-REPEAT: repeat-x; BACKGROUND-COLOR: #000000  }
.footer { BACKGROUND-IMAGE: url(pics/table-borders/footerBackground.gif); BACKGROUND-REPEAT: repeat-x; BACKGROUND-COLOR: #bf0301 }
.errMessageGradientStyle { BACKGROUND-IMAGE: url(pics/error-backgradient.gif); BACKGROUND-REPEAT: repeat-x }
.normRegistrationHeader { BACKGROUND-IMAGE: url(pics/norm-backimage.gif); BACKGROUND-REPEAT: repeat-x }
.redLine { BACKGROUND-POSITION: left 50%; BACKGROUND-IMAGE: url(pics/orange_gradiant.gif); BACKGROUND-REPEAT: repeat-x; BACKGROUND-COLOR: #ff7e0d }
</style>
</head>

<body>
	
<cfquery name="userinfo" datasource="mysql">
	SELECT u.firstname, u.lastname, u.username, u.city, u.state, u.zip, u.country, u.dob,
		u.email, u.userid, u.usertype, u.address, u.address2,  u.password, smg_countrylist.countryname, smg_states.state as st,
	 	u.lastchange,u.datelastlogin, u.datecreated, u.occupation, u.businessname, 
		u.phone, u.phone_ext, u.cell_phone, u.work_phone, u.work_ext, u.fax, u.whocreated, 
		u.billing_company, u.billing_contact, u.billing_address, 
		u.php_contact_name, u.php_contact_phone, u.php_contact_email,
		u.billing_address2, u.billing_city, u.active, u.billing_country, u.billing_zip, u.billing_phone, u.billing_fax, 
		u.billing_email
	FROM smg_users u
	LEFT JOIN smg_countrylist ON smg_countrylist.countryid = u.country  
	LEFT JOIN smg_states ON smg_states.id = u.state  
	WHERE userid = '#url.id#'
</cfquery>

<cfquery name="available_supervisors" datasource="MySQL">
select distinct firstname, lastname, smg_users.userid
from smg_users
INNER JOIN user_access_rights on  user_access_rights.userid = smg_users.userid
where user_access_rights.companyid = 6 and 
user_access_rights.usertype < 8
order by firstname

</cfquery>
<cfquery name="get_countrylist" datasource="MySql">
	SELECT countryid, countryname
	FROM smg_countrylist
	ORDER BY countryname
</cfquery>	

<cfquery name="state_list" datasource="mysql">
	select statename, id
	from smg_states
	ORDER BY statename
</cfquery>

<cfoutput>
<form action="forms/qr_update_supervising.cfm" method="post">
<input type="hidden" name="userid" value="#userinfo.userid#">
<br />
<TABLE cellSpacing="0" cellPadding="0" align="center" class="regContainer">
	<tr><td class="header" colSpan="3"></td></tr>
	<TR vAlign="top">
		<TD></td>
		<td width="10">&nbsp;</td>
	</tr>
	<tr><td colSpan="3" height="8"><img height=8 src="spacer.gif" width=1></td></tr>
	<tr><td class="orangeLine" colSpan="3" height="11"><img height=11 src="spacer.gif" width=1></td></tr>
	<tr><td colSpan="3" height="10">&nbsp;</td></tr>
	<tr>
		<td width="10">&nbsp;</td>
		<td>
			<table cellSpacing="0" cellPadding="0" border="0">
				<tr>
					<td width="20">&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
			
				<tr>
					<td width="20" height="5"><img height=5 src="spacer.gif" width=1 ></td>
					<td><img height=5 src="spacer.gif" width=1 ></td>
				</tr>
			</table>
		</td>
		<td width="10">&nbsp;</td>
	</tr>
	<tr borderColor="##d3d3d3">
		<td width="10">&nbsp;</td>
		<td>
			<!-- Personal Details Group -->
			<table cellspacing="0" cellpadding="3" width="100%" border="0">
				<tr>
					<td class="groupTopLeft">&nbsp;</td>
					<td class="groupCaption" nowrap="true">Supervising Details</td>
					<td class="groupTop" width="95%">&nbsp;</td>
					<td class="groupTopRight">&nbsp;</td>
				</tr>
				<tr>
					<td class="groupLeft">&nbsp;</td>
					<td colspan="2">
						<table id="rgbPersonalDetails" cellpadding="0" cellspacing="0" border="0" width="100%">
							<tr>
								<td>
									<TABLE cellSpacing="0" cellPadding="0" width="100%" border="0">
										<TBODY>
										<TR vAlign="middle" height="30">
											
											<TD id="label"><span id="lblTitle" class="normalLabel">Current User:</span></TD>
											<TD id="input">#userinfo.firstname# #userinfo.lastname#</TD>
											<TD height="1" colspan="2"><IMG height=1 src="spacer.gif" width=20></TD>
										</TR>
										<!-----Last Name---->
										<TR vAlign="middle" height="30">
											
											<TD><span id="lblTitle" class="normalLabel">Supervising Rep:</span></TD>
											<TD id="input">
											<select name="super_rep">
											<option value=0>N/A</option>
											<cfloop query="available_supervisors">
											<option value=#userid#>#firstname# #lastname# (#userid#)</option>
											
											</cfloop>	
											</select>			
											</TD>
											<TD height="1" colspan="2"><IMG height=1 src="spacer.gif" width=20></TD>
										</TR>
															
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
				</tr>
			</table> 
			<!--- End of Personal Details --->
			
			
					
					
		</TD>
		<td width="10">&nbsp;</td>
	</TR>
	<tr>
		<td><IMG height=55 src="spacer.gif" width=1></td>
        <td align="center"><input type="image" name="imgSubmit"  src="pics/update.gif" alt="Submit" border="0" /></td>
		<td>&nbsp;</td>
	</tr>
	<tr><td class="footer" colSpan="3"></td></tr>
</TABLE>
<br />

</TD>
</TR>
</TBODY>
</TABLE> 

</form>
</cfoutput>
</body>
</html>