<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>User Information</title>
</head>

<body>

<HEAD>
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

<style type="text/css">
<!--
.smlink         		{font-size: 11px;}
.section        		{border-top: 1px solid #c6c6c6;; border-right: 2px solid #c6c6c6;border-left: 2px solid #c6c6c6;border-bottom: 0px; background: #Ffffe6;}
.sectionFoot    		{border-bottom: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;font-size:2px;}
.sectionBottomDivider 	{border-bottom: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;}
.sectionTopDivider 		{border-top: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;}
.sectionSubHead			{font-size:11px;font-weight:bold;}
-->
</style>
</head>

<cfif isDefined('url.redirect')>
	<cfif url.userid NEQ client.userid>
	You are trying to edit a profile other then your own.  This is not allowed.  If you got this error and you do not know why, please contat
	support@case-usa.org<br>
	<br>
	Continue and view your own account: <cfoutput><a href="index.cfm?curdoc=user_info&userid=#client.userid#&redirect=initial_welcome">Account Info</a></cfoutput>
	<cfabort>	
	</cfif>
</cfif>

<!--- CHECK RIGHTS --->
<cfinclude template="check_rights.cfm">

<!----Rep Info---->
<cfquery name="rep_info" datasource="caseusa">
	select *
	from smg_users
	LEFT JOIN smg_countrylist ON countryid = smg_users.country
	LEFT JOIN smg_insurance_type ON insutypeid = smg_users.insurance_typeid
	WHERE userid = '#url.userid#'
</cfquery>

<!----Regional Information---->
<Cfquery name="region_company_access" datasource="caseusa">
	SELECT uar.companyid, uar.regionid, uar.usertype, uar.id, uar.advisorid,
		   r.regionname,
		   c.companyshort,
		   ut.usertype as usertypename, ut.usertypeid,
		   adv.firstname, adv.lastname
	FROM user_access_rights uar
	INNER JOIN smg_regions r ON r.regionid = uar.regionid
	INNER JOIN smg_companies c ON c.companyid = uar.companyid
	INNER JOIN smg_usertype ut ON ut.usertypeid = uar.usertype
	LEFT JOIN smg_users adv ON adv.userid = uar.advisorid
	WHERE uar.userid = '#url.userid#'
	ORDER BY r.regionname
</Cfquery>

<cfquery name="user_compliance" datasource="caseusa">
	SELECT userid, compliance
	FROM smg_users
	WHERE userid = <cfqueryparam value="#client.userid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="get_paperwork" datasource="caseusa">
	SELECT p.paperworkid, p.userid, p.seasonid, p.ar_info_sheet, p.ar_ref_quest1, p.ar_ref_quest2, p.ar_cbc_auth_form, p.ar_agreement, p.ar_training,
		s.season
	FROM smg_users_paperwork p
	LEFT JOIN smg_seasons s ON s.seasonid = p.seasonid
	WHERE userid = <cfqueryparam value="#url.userid#" cfsqltype="cf_sql_integer" maxlength="6">
	ORDER BY p.seasonid DESC
</cfquery>

<cfoutput query="rep_info">

<cfform action="?curdoc=forms/edit_user" method="post">

<cfset temp = "temp">
<cfset temp_password = "#temp##RandRange(100000, 999999)#">
<cfinput type="hidden" name="temp_password" value="#temp_password#">


<!--- OFFICE / FIELD --->
<cfif listfindnocase("1,2,3,4,5,6,7,9", rep_info.usertype)>

<!--- SIZING TABLE --->
<table border=0 width=100%>
	<tr>
		<td width="55%" valign="top">
			<!----Personal Information---->
			<table width=100% cellpadding=0 cellspacing=0 border=0 height=24 >
				<tr valign=middle height=24>
					<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
					<td width=26 background="pics/header_background.gif"><img src="pics/user.gif"></td>
					<td background="pics/header_background.gif"><h2>Personal Information</h2>
						<cfif client.usertype LT 4 AND rep_info.changepass eq 1>
							<span class="get_attention"<font size=-2>User will be required to change pass on next log in.</span>
						</cfif>
					</td>
					<td background="pics/header_background.gif" width=16><a href="?curdoc=forms/edit_user&userid=#url.userid#"><img src="pics/edit.png" border=0 alt="Edit"></a></td>
					<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
				</tr>
			</table>
			<table width=100% cellpadding=10 cellspacing=0 border=0 class="section" >
				<tr>
					<td style="line-height:20px;" valign="top">
						<table width=245 cellpadding=0 cellspacing=0 border=0 bgcolor=##ffffff align="left">
							<tr valign=top>
								<td width=6 style="border-left: 1px solid ##FAF7F1;"><img src="pics/address_topleft.gif" height=6 width=6></td>
								<td width=201 style="line-height:1px; font-size:2px; border-top: 1px solid ##557aa7;">&nbsp;</td>
								<td width=6><img src="pics/address_topright.gif" height=6 width=6></td>
							</tr>
							<tr>
								<td width=6 style="border-left: 1px solid ##557aa7;">&nbsp;</td>
								<td width=226 style="padding:5px;">
									#firstname# #lastname# - #userid#<br>
									#address#<br>
									<cfif address2 NEQ ''>#address2#<Br></cfif>
									#city# #state#, #zip#<Br>
									Home: #phone#<br>
									<cfif work_phone NEQ ''>Work: #work_phone#<br></cfif>
									<cfif cell_phone NEQ ''>Cell: #cell_phone#<br></cfif>
									<cfif fax NEQ ''>Fax: #fax#<br></cfif>
									Email: <a href="mailto:#email#">#email#</a><br>	
								</td>
								<td width=6 style="border-right: 1px solid ##557aa7;">&nbsp;</td>
							</tr>
							<tr valign="bottom">
								<td width=6 style="border-left: 1px solid ##FAF7F1;"><img src="pics/address_bottomleft.gif" height=6 width=6></td>
								<td width=201 style="line-height:1px; font-size:2px; border-bottom: 1px solid ##557aa7;">&nbsp;</td>
								<td width=6><img src="pics/address_bottomright.gif" height=6 width=6></td>
							</tr>
						</table>
						<div style="padding-left:5px; float:inherit"  >
							<strong>Last Login: </strong>&nbsp;&nbsp; #DateFormat(lastlogin, 'mm/dd/yyyy')#<br>
							<strong>User Entered:</strong>&nbsp;&nbsp; #DateFormat(datecreated, 'mm/dd/yyyy')# <br>
							<strong>Status:</strong>&nbsp;&nbsp; <cfif active EQ 1>Active<cfelse>Inactive</cfif><br>
							<cfif client.usertype EQ 1 OR client.usertype LT rep_info.usertype OR client.userid EQ rep_info.userid>
								<strong>Username:</strong>&nbsp;&nbsp;<cfif rep_info.userid eq 9401>****<cfelse>#username#</cfif><br>
								<strong>Password:</strong>&nbsp;&nbsp;<cfif rep_info.userid eq 9401>****<cfelse>#password#</cfif><br>
							</cfif>
							<font size=-2><a href="resendlogin.cfm?userid=#userid#"><img src="pics/email.gif" border=0 align="left"> Resend Login Info Email</A>
							<cfif isDefined('url.es')><font color="red"> - Sent</font></cfif>
							<cfif client.usertype LTE 5 or client.userid eq 9401><br>
								<a href="?curdoc=history&userid=#url.userid#">view history</a>
							</cfif>
							</font>
						</div>
					</td>
				</tr>
			</table>
			<table width=100% cellpadding=0 cellspacing=0 border=0>
				<tr valign=bottom >
					<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
					<td width=100% background="pics/header_background_footer.gif"></td>
					<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
				</tr>
			</table>
		</td>
		<td width="1%">&nbsp;</td>
		<td width="44%" valign="top">
			<!--- INFORMATION --->
			<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
				<tr valign=middle height=24>
					<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
					<td width=26 background="pics/header_background.gif"><img src="pics/user.gif"></td>
					<td background="pics/header_background.gif"><h2>&nbsp;&nbsp;</h2></td>
					<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
				</tr>
			</table>
			<table width=100% cellpadding=10 cellspacing=0 border=0 class="section" >
				<tr>
					<td style="line-height:20px;" valign="top">
						<div style="width:100%; float:right;text-align:center;">
							<cfif isDefined('url.redirect')> 
								<div style="font-size:14px;font-weight:bold;border: 1px dashed CC0000;">
									<cfset client.firstlogin = 'yes'> 
									Please verify that your account information is correct, if not, please click on edit (<img src="pics/edit.png">) and update your information.<br>
									<a href="querys/continue.cfm"><img src="pics/verify_account_info.jpg" width="144" height="112" border=0></a>
								</div>
							<cfelse>
								<div style="font-size:14px;font-weight:bold;" align="justify">
								Please verify that your account information is correct. <br> 
								Inaccurate information could result in delayed payments and missed emails.<br /> 
								SMG is not responsible for delayed payments if your information is incorrect.  
								If information is incorrect and you update your information, you must notify your manager or facilitator.
								</div>
								If you can not edit information that is incorrect, contact your manager or facilitator.
							</cfif>
						</div>
					</td>
				</tr>
			</table>
			<table width=100% cellpadding=0 cellspacing=0 border=0>
				<tr valign=bottom >
					<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
					<td width=100% background="pics/header_background_footer.gif"></td>
					<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
				</tr>
			</table>
		</td>
	</tr>
</table><br>

<!--- SIZING TABLE --->
<table width=100% border=0 >
	<tr>
		<td width="50%" valign="top">
			<!----Regional & Company Information---->
			<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
				<tr valign=middle height=24>
					<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
					<td width=26 background="pics/header_background.gif"><img src="pics/usa.gif"></td>
					<td background="pics/header_background.gif"><h2>&nbsp;&nbsp;Company & Regional Access </td><td background="pics/header_background.gif" width=16><cfif client.usertype LTE 5><a href="index.cfm?curdoc=forms/region_access_rights&userid=#url.userid#"><img src="pics/edit.png" border=0 alt="Edit"></a></cfif></td>
					<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
				</tr>
			</table>
			<table width=100% cellpadding=10 cellspacing=0 border=0 class="section" >
				<tr>
					<td style="line-height:20px;" valign="top">
						<Cfquery name="default_company" datasource="caseusa">
							select companyshort from smg_companies
							where companyid = #defaultcompany#
						</Cfquery>
						<font size=-2>Default Company: #default_company.companyshort#</font>
						<style type="text/css">
						<!--
						div.scroll {
							height: 100px;
							width: 430px;
							overflow: auto;
						}
						-->
						</style>
						<table width=100%>
							<Tr>
								<td width=35><u>Co.</u></td><td width=160><u>Region</u></td>
								<td><u>Access Level</u></td><td><u>Reports to:</u></td>
							</Tr>
						</table>
						<div class="scroll">
							<!----scrolling table with region information---->
							<table width=100%>
								<cfif region_company_access.recordcount eq 0>
									<Tr><td align="center">No Regions assigned for this user. Click 'Edit access / region' to assign access.</td></tr>
								<cfelse>
									<cfloop query="region_company_access">
									<tr bgcolor="#iif(region_company_Access.currentrow MOD 2 ,DE("fffff6") ,DE("ffffe6") )#">	
									<Td width=35>#companyshort#</Td>
									<td width=160>#regionname# (#regionid#)</td>
									<td>#usertypename#</td>
									<td><cfif usertype LTE '4'>
											n/a
										<cfelse>
											<cfif advisorid is '0'>Directly to Director<cfelse>#firstname# #lastname#</cfif>
										</cfif>
									</td>
									</tr>
									</cfloop>
								</cfif>
							</table>
						</div>
					</td>
				</tr>
			</table>
			<table width=100% cellpadding=0 cellspacing=0 border=0>
				<tr valign=bottom >
					<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
					<td width=100% background="pics/header_background_footer.gif"></td>
					<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
				</tr>
			</table>
		</td>
		<td>&nbsp;</td>
		<td width="49%" valign="top">
			<!----Student Information---->
			<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
				<tr valign=middle height=24>
					<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
					<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
					<td background="pics/header_background.gif"><h2>Student Information</td><td background="pics/header_background.gif" width=16></td>
					<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
				</tr>
			</table>
			<table width=100% cellpadding=10 cellspacing=0 border=0 class="section" >
				<tr>
					<td style="line-height:20px;" valign="top">
						<!----Query for placed students---->
						<cfquery name="get_placed_students" datasource="caseusa">
							SELECT smg_students.studentid, smg_students.familylastname, smg_students.firstname, smg_students.placerepid,
								smg_students.sex, smg_countrylist.countryname, smg_students.countryresident, smg_students.city, smg_students.branchid as branch,
								smg_users.firstname as intl_firstname, smg_users.lastname as intl_lastname, smg_users.businessname as intl_businessname,
								p.programname
							FROM smg_students 
							LEFT JOIN smg_countrylist ON smg_students.countryresident = smg_countrylist.countryid 
							INNER JOIN smg_users ON smg_students.intrep = smg_users.userid
							INNER JOIN smg_programs p ON p.programid = smg_students.programid
							WHERE smg_students.placerepid = '#url.userid#'
						</cfquery>
						<!----Query for supervised students---->
						<cfquery name="get_supervised_students" datasource="caseusa">
							SELECT smg_students.studentid, smg_students.familylastname, smg_students.firstname, smg_students.placerepid,
								smg_students.sex, smg_countrylist.countryname, smg_students.countryresident, smg_students.city, smg_students.branchid as branch,
								smg_users.firstname as intl_firstname, smg_users.lastname as intl_lastname, smg_users.businessname as intl_businessname,
								p.programname
							 FROM smg_students 
							 LEFT JOIN smg_countrylist ON smg_students.countryresident = smg_countrylist.countryid 
							 INNER JOIN smg_users ON smg_students.intrep = smg_users.userid
							 INNER JOIN smg_programs p ON p.programid = smg_students.programid
							 WHERE smg_students.arearepid = '#url.userid#'
						</cfquery>				
						<style type="text/css">
						<!--
						div.scroll1 {
							height: 75px;
							width: 490px;
							overflow: auto;
						}
						-->
						</style>
						<table width=480 border=0>
							<Tr>
								<td width=30 align="left"><u>ID</u></td>
								<td width=70 align="left"><u>Last</u> </td>
								<td width=70 align="left"><u>First</u> </td>
								<td width=30 align="left"><u>Sex</u></td>
								<td width=70 align="left"><u>Country</u></td>
								<td width=140 align="left"><u>Business Name</u></td>
								<td width=70 align="left"><u>Program</u></td>
							</Tr>
						</table>
						<u>Placed:</u> &nbsp; (#get_placed_students.recordcount#)
						<cfif get_placed_students.recordcount gt 2><div class="scroll1"></cfif>
						<!----scrolling table with placed information---->
						<table  border=0 width=100%>
							<Cfif get_placed_students.recordcount EQ 0>
								<tr><td colspan=6 align="Center">Rep has not placed any students</td></tr>
							</Cfif>
							<cfloop query="get_placed_Students">
							<tr bgcolor="#iif(get_placed_Students.currentrow MOD 2 ,DE("fffff6") ,DE("ffffe6") )#">		
								<td width=30 align="left">#studentid#</td>
								<td width=70 align="left">#familylastname#</td>
								<td width=70 align="left">#firstname#</td>
								<td width=30 align="left">#Left(sex,1)#</td>
								<td width=70 align="left">#Left(countryname,13)#</td>
								<td width=120 align="left"><cfif len(intl_businessname) gt 17>#Left(intl_businessname,17)#...<cfelse>#intl_businessname#</cfif></td>
								<td width=70 align="left"><u>#programname#</u></td>
							</tr>
							</cfloop>
						</table>
						<cfif get_placed_students.recordcount gt 2></div></cfif><br>
						<u>Supervising:</u> &nbsp; (#get_supervised_students.recordcount#)
						<cfif get_supervised_students.recordcount gt 2><div class="scroll1"></cfif>
						<!----scrolling table with supervised information---->
						<table width=100% border=0>
							<Cfif get_supervised_students.recordcount eq 0>
								<Tr><td colspan=6 align="Center">Rep is not supervising any students</td></Tr>
							</Cfif>
							<cfloop query="get_supervised_students">
							<tr bgcolor="#iif(get_supervised_students.currentrow MOD 2 ,DE("fffff6") ,DE("ffffe6") )#">		
								<td width=30 align="left">#studentid#</td>
								<td width=70 align="left">#familylastname#</td>
								<td width=70 align="left">#firstname#</td>
								<td width=30 align="left">#Left(sex,1)#</td>
								<td width=70 align="left">#Left(countryname,13)#</td>
								<td width=120 align="left"><cfif len(intl_businessname) gt 17>#Left(intl_businessname,17)#...<cfelse>#intl_businessname#</cfif></td>
								<td width=70 align="left"><u>#programname#</u></td>
							</tr>
							</cfloop>
						</table>
						<cfif get_supervised_students.recordcount gt 2></div></cfif>
					</td>
				</tr>
			</table>
			<!----footer of  regional table---->
			<table width=100% cellpadding=0 cellspacing=0 border=0>
				<tr valign=bottom >
					<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
					<td width=100% background="pics/header_background_footer.gif"></td>
					<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
				</tr>
			</table>
		</td>
	</tr>
</table><br>

<!--- SIZING TABLE --->
<Table width=100% border=0>
	<tr>
		<td width="30%">
			<!---- PAYMENT INFORMATION ---->
			<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
				<tr valign=middle height=24>
					<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
					<td width=26 background="pics/header_background.gif"><img src="pics/$.gif"><img src="pics/$.gif"><img src="pics/$.gif"></td>
					<td background="pics/header_background.gif"><h2>&nbsp;&nbsp;Payment Activity </td><td background="pics/header_background.gif" width=16></a></td>
					<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
				</tr>
			</table>
			<table width=100% cellpadding=10 cellspacing=0 border=0 class="section" >
				<tr>
					<td style="line-height:20px;" valign="top">
						<Cfquery name="super_payments" datasource="caseusa">
							select sum(amount) as amount
							from smg_rep_payments
							where agentid = #url.userid#  and transtype = 'supervision' and companyid = '#client.companyid#'
						</Cfquery>
						<Cfquery name="place_payments" datasource="caseusa">
							select sum(amount) as amount
							from smg_rep_payments
							where agentid = #url.userid# and transtype = 'placement' and companyid = '#client.companyid#'
						</Cfquery>		
						<strong>Supervising Payments:</strong> <Cfif super_payments.recordcount is 0>$0.00<cfelse>#LSCurrencyFormat(super_payments.amount, 'local')#</cfif><br>
						<strong>Placement Payments:</strong> <Cfif place_payments.recordcount is 0>$0.00<cfelse>#LSCurrencyFormat(place_payments.amount, 'local')#</cfif><br>
						<font size = -2><a href="?curdoc=reports/rep_payments_made&user=#url.userid#">view details</a></font> <cfif client.usertype lte 4> - <font size = -2><a href="?curdoc=forms/supervising_placement_payment_details&user=#url.userid#">make payment</a></cfif>
					</td>
				</tr>
			</table>
			<table width=100% cellpadding=0 cellspacing=0 border=0>
				<tr valign=bottom >
					<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
					<td width=100% background="pics/header_background_footer.gif"></td>
					<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
				</tr>
			</table>
		</td>
		<td width=5></td>
		<td width="30%" valign="top">
			<!---- NOTES ---->
			<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
				<tr valign=middle height=24>
					<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
					<td width=26 background="pics/header_background.gif"><img src="pics/notes.gif"></td>
					<td background="pics/header_background.gif"><h2>Notes</h2></td>
					<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
				</tr>
			</table>
			<table width=100% cellpadding=10 cellspacing=0 border=0 class="section" >
				<tr>
					<td style="line-height:20px;" valign="top">
						<Cfif comments EQ ''>No additional information available.<cfelse>#comments#</cfif><br><br>
					</td>
				</tr>
			</table>
			<table width=100% cellpadding=0 cellspacing=0 border=0>
				<tr valign=bottom >
					<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
					<td width=100% background="pics/header_background_footer.gif"></td>
					<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
				</tr>
			</table>
		</td>
		<td width=5></td>
		<td width=40% valign="top" rowspan=2>
			<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
				<tr valign=middle height=24>
					<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
					<td width=26 background="pics/header_background.gif"><img src="pics/family.gif"></td>
					<td background="pics/header_background.gif"><h2>&nbsp;Other Family Members</h2></td>
					<td background="pics/header_background.gif" width=16><a href="?curdoc=forms/edit_family_members&userid=#url.userid#"><img src="pics/edit.png" border=0 alt="Edit"></a></td>
					<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
				</tr>
			</table>
			<table width=100% cellpadding=10 cellspacing=0 border=0 class="section" >
				<tr>
					<td style="line-height:20px;" valign="top">
					<Cfquery name="family_members" datasource="caseusa">
						select firstname, lastname, dob, relationship, no_members, auth_received, auth_received_type
						from smg_user_family
						where userid = '#url.userid#'
					</Cfquery>
					<table width=100% border=0>
						<tr>
							<td><strong>Name</strong></td>
							<td><strong>Age</strong></td>
							<td><strong>Relationship</strong></td>
							<td><strong>CBC</strong></td>
						</tr>
						<Cfif family_members.recordcount eq 0>
							<tr><td colspan="4">No other household residents on file for this user.</td></tr>
						<cfelse>
							<cfloop query="family_members">
							<tr>
								<td>#firstname# #lastname#</td>
								<td>#DateDiff('yyyy', dob, now() )# yrs.</td>
								<Td>#relationship#</Td>
								<Td><cfif #DateDiff('yyyy', dob, now() )# LTE 17>
										N/A
									<cfelse>
										<cfif auth_received eq 0>
											<a href="https://www.student-management.com/nsmg/forms/cbc_auth_fam.cfm?id=#rep_info.uniqueid#&userid=#userid#">Get</a>
											<a href="https://www.student-management.com/nsmg/index.cfm?curdoc=forms/upload_cbc_fam&id=#rep_info.uniqueid#&userid=#userid#">Upload</a>
										<cfelse>
											<a href="https://www.student-management.com/nsmg/uploadedfiles/cbc_auth/household/#rep_info.uniqueid#_#userid#.#auth_received_type#">Received</a>
										</cfif>
									</cfif>
								</Td>
							</tr>
							</cfloop>	
						</cfif>
					</table>
				</td>
			</tr>
			</table>
			<table width=100% cellpadding=0 cellspacing=0 border=0>
				<tr valign=bottom >
					<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
					<td width=100% background="pics/header_background_footer.gif"></td>
					<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
				</tr>
			</table>
		</td>
	</tr>
</table><br>

<!--- SIZING TABLE --->
<Table width=100% border=0>	
	<tr>
		<td width=50% valign="top">
			<!---- AR PAPERWORK ---->
			<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
				<tr valign=middle height=24>
					<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
					<td width=26 background="pics/header_background.gif"><img src="pics/clock.gif"></td>
					<td background="pics/header_background.gif"><h2>Area Representative Paperwork</td>
					<td background="pics/header_background.gif" width=16><a href="?curdoc=forms/user_paperwork&userid=#url.userid#"><img src="pics/edit.png" border=0 alt="Edit"></a></td>
					<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
				</tr>
			</table>
			<table width=100% cellpadding=2 cellspacing=0 border=0 class="section" >
				<tr style="line-height:20px;"><td><b>Season: #get_paperwork.season#</td></tr>
				<tr bgcolor="##FFFFFF"><td width="40%">AR Information Sheet</td>
					<td><input type="checkbox" name="ar_info_sheet_check" disabled="disabled" <cfif get_paperwork.ar_info_sheet NEQ ''>checked="checked"</cfif>>
						Date: #DateFormat(get_paperwork.ar_info_sheet, 'mm/dd/yyyy')#				
					</td>
				</tr>
				<tr><td>AR Ref. Questionnaire ##1</td>
					<td><input type="checkbox" name="ar_ref_quest1_check" disabled="disabled" <cfif get_paperwork.ar_ref_quest1 NEQ ''>checked="checked"</cfif>> 
						Date: #DateFormat(ar_ref_quest1, 'mm/dd/yyyy')#					
					</td>
				</tr>
				<tr bgcolor="##FFFFFF"><td>AR Ref. Questionnaire ##2</td>
					<td><input type="checkbox" name="ar_ref_quest2_check" disabled="disabled" <cfif get_paperwork.ar_ref_quest2 NEQ ''>checked="checked"</cfif>> 
						Date: #DateFormat(get_paperwork.ar_ref_quest2, 'mm/dd/yyyy')#					
					</td>
				</tr>
				<tr><td>CBC Authorization Form</td>
					<td><input type="checkbox" name="ar_cbc_auth_form_check" disabled="disabled" <cfif get_paperwork.ar_cbc_auth_form NEQ ''>checked="checked"</cfif>> 
						Date: #DateFormat(get_paperwork.ar_cbc_auth_form, 'mm/dd/yyyy')#				
					</td>
				</tr>
				<tr bgcolor="##FFFFFF"><td>AR Agreement</td>
					<td><input type="checkbox" name="ar_agreement_check" disabled="disabled" <cfif get_paperwork.ar_agreement NEQ ''>checked="checked"</cfif>> 
						Date: #DateFormat(get_paperwork.ar_agreement, 'mm/dd/yyyy')#
					</td>
				</tr>
				<tr><td>AR Training Sign-off Form</td>
					<td><input type="checkbox" name="ar_training_check" disabled="disabled" <cfif get_paperwork.ar_training NEQ ''>checked="checked"</cfif>> 
						Date: #DateFormat(get_paperwork.ar_training, 'mm/dd/yyyy')#
					</td>
				</tr>							
			</table>
			<table width=100% cellpadding=0 cellspacing=0 border=0>
				<tr valign=bottom >
					<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
					<td width=100% background="pics/header_background_footer.gif"></td>
					<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
				</tr>
			</table>
		</td>
		<td width="5" valign="top"></td>
		<td width="50%" valign="top">
			<!----CBC---->
			<cfquery name="get_cbc_user" datasource="caseusa">
				SELECT cbcid, userid, date_authorized , date_sent, date_received, requestid, smg_users_cbc.seasonid, flagcbc, smg_seasons.season
				FROM smg_users_cbc
				LEFT JOIN smg_seasons ON smg_seasons.seasonid = smg_users_cbc.seasonid
				WHERE userid = <cfqueryparam value="#url.userid#" cfsqltype="cf_sql_integer"> 
					AND familyid = '0'
				ORDER BY smg_seasons.season
			</cfquery>
			<cfquery name="check_hosts" datasource="caseusa">
				SELECT DISTINCT h.hostid, familylastname, h.fatherssn, h.motherssn, date_sent, date_received, smg_seasons.season, requestid
				FROM smg_hosts h
				INNER JOIN smg_hosts_cbc cbc ON h.hostid = cbc.hostid
				LEFT JOIN smg_seasons ON smg_seasons.seasonid = cbc.seasonid
				WHERE cbc.cbc_type = 'father' AND ((h.fatherssn = '#rep_info.ssn#' AND h.fatherssn != '') OR (h.fatherfirstname = '#rep_info.firstname#' AND h.fatherlastname = '#rep_info.lastname#' <cfif rep_info.dob NEQ ''>AND h.fatherdob = '#DateFormat(rep_info.dob,'yyyy/mm/dd')#'</cfif>))
					OR 
					cbc.cbc_type = 'mother' AND ((h.motherssn = '#rep_info.ssn#' AND h.motherssn != '') OR (h.motherfirstname = '#rep_info.firstname#' AND h.motherlastname = '#rep_info.lastname#' <cfif rep_info.dob NEQ ''>AND h.motherdob = '#DateFormat(rep_info.dob,'yyyy/mm/dd')#'</cfif>))
			</cfquery>
			<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
				<tr valign=middle height=24>
					<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
					<td width=26 background="pics/header_background.gif"><img src="pics/notes.gif"></td>
					<td background="pics/header_background.gif"><h2>Criminal Background Check</td>
					<cfif client.usertype EQ 1 OR user_compliance.compliance EQ 1>
						<td background="pics/header_background.gif" width=16><a href="?curdoc=cbc/users_cbc&userid=#url.userid#"><img src="pics/edit.png" border=0 alt="Edit"></a></td>
					</cfif>
					<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
				</tr>
			</table>
			<table width=100% cellpadding=4 cellspacing=0 border=0 class="section">
				<tr>
					<td align="center" valign="top"><b>Season</b></td>		
					<td align="center" valign="top"><b>Date Sent</b> <br><font size="-2">mm/dd/yyyy</font></td>		
					<td align="center" valign="top"><b>Date Received</b> <br><font size="-2">mm/dd/yyyy</font></td>		
					<td align="center" valign="top"><b>Request ID</b></td>
				</tr>				
				<cfif get_cbc_user.recordcount EQ '0'>
					<tr><td align="center" colspan="5">No CBC has been submitted.</td></tr>
				<cfelse>
					<cfloop query="get_cbc_user">
					<tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("ffffe6") )#"> 
						<td align="center" style="line-height:20px;"><b>#season#</b> <cfinput type="hidden" name="cbcid#currentrow#" value="#cbcid#"></td>
						<td align="center" style="line-height:20px;"><cfif date_sent EQ ''>processing<cfelse>#DateFormat(date_sent, 'mm/dd/yyyy')#</cfif></td>
						<td align="center" style="line-height:20px;"><cfif date_received EQ ''>processing<cfelse>#DateFormat(date_received, 'mm/dd/yyyy')#</cfif></td>		
						<td align="center" style="line-height:20px;"><cfif requestid EQ ''>processing<cfelseif flagcbc EQ 1>On Hold Contact Compliance<cfelse>#requestid#</cfif></td>
					</tr>
					</cfloop>
				</cfif>
				<cfloop query="check_hosts">
					<tr><td colspan="3">CBC Submitted for Host Family (###hostid#).</td></tr>
					<tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("ffffe6") )#"> 
						<td align="center" style="line-height:20px;"><b>#season#</b></td>
						<td align="center" style="line-height:20px;"><cfif date_sent EQ ''>processing<cfelse>#DateFormat(date_sent, 'mm/dd/yyyy')#</cfif></td>
						<td align="center" style="line-height:20px;"><cfif date_received EQ ''>processing<cfelse>#DateFormat(date_received, 'mm/dd/yyyy')#</cfif></td>							
						<td align="center" style="line-height:20px;"><cfif requestid EQ ''>processing<cfelse>#requestid#</cfif></td>
					</tr>
				</cfloop>				
			</table>
			<table width=100% cellpadding=0 cellspacing=0 border=0>
				<tr valign=bottom >
					<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
					<td width=100% background="pics/header_background_footer.gif"></td>
					<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
				</tr>
			</table>
		</td>
	</tr>
</table>


<!--- INTERNATIONAL REPRESENTATIVE --->
<cfelse>
	
<!--- SIZING TABLE --->
<table border=0 width=100%>
	<tr>
		<td width="59%" valign="top">
			<!----Personal Information---->
			<table width=100% cellpadding=0 cellspacing=0 border=0 height=24 >
				<tr valign=middle height=24>
					<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
					<td width=26 background="pics/header_background.gif"><img src="pics/user.gif"></td>
					<td background="pics/header_background.gif"><h2>International Rep. Information</h2>
						<cfif client.usertype LT 4 AND rep_info.changepass EQ 1>
							<span class="get_attention"<font size=-2>User will be required to change pass on next log in.</span>
						</cfif>
					</td>
					<td background="pics/header_background.gif" width=16><a href="?curdoc=forms/edit_user&userid=#url.userid#"><img src="pics/edit.png" border=0 alt="Edit"></a></td>
					<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
				</tr>
			</table>
			<table width=100% cellpadding=4 cellspacing=0 border=0 class="section" >
				<tr>
					<td style="line-height:20px;" valign="top">
						<div style="float:left;">
							<table width=245 cellpadding=0 cellspacing=0 border=0 bgcolor=##ffffff align="left">
								<tr valign=top>
									<td width=6 style="border-left: 1px solid ##FAF7F1;"><img src="pics/address_topleft.gif" height=6 width=6></td>
									<td width=201 style="line-height:1px; font-size:2px; border-top: 1px solid ##557aa7;">&nbsp;</td>
									<td width=6><img src="pics/address_topright.gif" height=6 width=6></td>
								</tr>
								<cfform>
								<cfinput type="radio" name="usertype" onClick="hideAll(); changeDiv('1','block');" checked value="personal">Personal <cfinput type="radio" name="usertype" 	onClick="hideAll(); changeDiv('2','block');" value="billing">Billing &nbsp;&nbsp;
								<tr>
									<td width=6 style="border-left: 1px solid ##557aa7;">&nbsp;</td>
									<td width=226 style="padding:5px;">
										<div id="1" STYLE="display:block">
											#businessname#<br>
											#firstname# #lastname# - #userid#<br>
											#address#<br>
											<cfif address2 NEQ ''>#address2#<br></cfif>
											#city# #countryname#, #zip#<Br>
											P: #phone#<br>
											F: #fax#<br>
											E: <a href="mailto:#email#">#email#</a><br>	
										</div>
										<div id="2" STYLE="display:none">
											#billing_company#<br>
											#billing_contact#<br>
											#billing_address#<br>
											<cfif billing_address2 NEQ ''>#billing_address2#<br></cfif>
											#billing_city# #countryname#, #billing_zip#<Br>
											P: #billing_phone#<br>
											F: #billing_fax#<br>
											E: <a href="mailto:#billing_email#">#billing_email#</a><br>	
										</div>
									</td>
									<td width=6 style="border-right: 1px solid ##557aa7;">&nbsp;</td>
								</tr>
								</cfform>
								<tr valign="bottom">
									<td width=6 style="border-left: 1px solid ##FAF7F1;"><img src="pics/address_bottomleft.gif" height=6 width=6></td>
									<td width=201 style="line-height:1px; font-size:2px; border-bottom: 1px solid ##557aa7;">&nbsp;</td>
									<td width=6><img src="pics/address_bottomright.gif" height=6 width=6></td>
								</tr>
							</table>
							<div style="padding-left:5px; float:inherit"  >
								<strong>Last Login: </strong>&nbsp;&nbsp; #DateFormat(lastlogin, 'mm/dd/yyyy')#<br>
								<strong>User Entered:</strong>&nbsp;&nbsp; #DateFormat(datecreated, 'mm/dd/yyyy')# <br>
								<strong>Status:</strong>&nbsp;&nbsp; <cfif active EQ 1>Active<cfelse>Inactive</cfif><br>
								<!--- LOGIN INFORMATION --->
								<cfif client.usertype EQ 1 OR client.usertype LT rep_info.usertype OR client.userid EQ rep_info.userid>
									<strong>Username:</strong>&nbsp;&nbsp;#username#<br>
									<strong>Password:</strong>&nbsp;&nbsp;#password#<br>
								</cfif>
								<font size=-2><a href="resendlogin.cfm?userid=#userid#"><img src="pics/email.gif" border=0 align="left"> Resend Login Info Email</A><cfif isDefined('url.es')><font color="red"> - Sent</font></cfif>
								<cfif client.usertype LTE 5><br>
									<a href="?curdoc=history&userid=#url.userid#">view history</a>
								</cfif>
								</font>
							</div>
						</div>
					</td>
				</tr>
			</table>
			<table width=100% cellpadding=0 cellspacing=0 border=0>
				<tr valign=bottom >
					<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
					<td width=100% background="pics/header_background_footer.gif"></td>
					<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
				</tr>
			</table>
		</td>
		<td width="1%">&nbsp;</td>		
		<td width="40%" valign="top">
			<!--- INFORMATION --->
			<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
				<tr valign=middle height=24>
					<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
					<td width=26 background="pics/header_background.gif"><img src="pics/user.gif"></td>
					<td background="pics/header_background.gif"><h2>&nbsp;&nbsp;</h2></td>
					<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
				</tr>
			</table>
			<table width=100% cellpadding=4 cellspacing=0 border=0 class="section" >
				<tr>
					<td style="line-height:20px;" valign="top">
						<cfif isDefined('url.redirect')> 
							<div style="font-size:14px;font-weight:bold;border: 1px dashed CC0000;" align="justify">
							<cfset client.firstlogin = 'yes'> 
							Please verify that your account information is correct, if not, please click on edit (<img src="pics/edit.png">) and update your information.<br>
							<a href="querys/continue.cfm"><img src="pics/verify_account_info.jpg" width="144" height="112" border=0></a>
							</div>
						<cfelse>
							<div style="font-size:14px;font-weight:bold;" align="justify">
							Please verify that your account information is correct.  Inaccurate information could result in 
							delayed communication, missed emails, inaccurate records and inefficient communication.  
							To update your information, click on please click on the edit icon (<img src="pics/edit.png">). 
							If information is incorrect and you update your information, please notify SMG immediatly of any such updates. 
							</div> 
						</cfif>
					</td>
				</tr>
			</table>
			<table width=100% cellpadding=0 cellspacing=0 border=0>
				<tr valign=bottom >
					<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
					<td width=100% background="pics/header_background_footer.gif"></td>
					<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
				</tr>
			</table>							
		</td>
	</tr>
</table><br>

<!--- SIZING TABLE --->
<table width=100% border=0 >
	<tr>
		<td width=50% valign="top">
			<!---- LOGO MANAGEMENT ---->
			<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
				<tr valign=middle height=24>
					<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
					<td width=26 background="pics/header_background.gif"><cfif rep_info.logo is ''><img src="pics/logos/smg_clear.gif" height=16><Cfelse><img src="pics/logos/#rep_info.logo#" height=16></cfif></td>
					<td background="pics/header_background.gif"><h2>&nbsp;&nbsp;Logo Management</h2></td>
					<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
				</tr>
			</table>
			<table width=100% cellpadding=4 cellspacing=0 border=0 class="section" >
				<tr>
					<td>
						You can set what logo appears in the upper right hand corner for you, branch offices and your students.<br>
						<cfform action="querys/upload_logo.cfm"  method="post" enctype="multipart/form-data" preloader="no">
							<cfinput type="file" name="file_upload" size=35 message="Please specify a file." required="yes" enctype="multipart/form-data"> 
							<cfinput type="submit" name="submit" value="Upload Picture">
						</cfform><i>logo should be 71 pixels in height</i>
					</td>
				</tr>
			</table>
			<table width=100% cellpadding=0 cellspacing=0 border=0>
				<tr valign=bottom >
					<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
					<td width=100% background="pics/header_background_footer.gif"></td>
					<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
				</tr>
			</table>
			<br />
			<!---- NOTES ---->
			<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
				<tr valign=middle height=24>
					<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
					<td width=26 background="pics/header_background.gif"><img src="pics/notes.gif"></td>
					<td background="pics/header_background.gif"><h2>Notes</h2></td>
					<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
				</tr>
			</table>
			<table width=100% cellpadding=4 cellspacing=0 border=0 class="section" >
				<tr>
					<td style="line-height:20px;" valign="top">
						<cfif comments EQ ''>No additional information available.<cfelse>#comments#</cfif><br><br>
					</td>
				</tr>
			</table>
			<table width=100% cellpadding=0 cellspacing=0 border=0>
				<tr valign=bottom >
					<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
					<td width=100% background="pics/header_background_footer.gif"></td>
					<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
				</tr>
			</table>
		</td>
		<td width="1%">&nbsp;</td>
		<td width="49%" valign="top">
			<!---- SEVIS AND INSURANCE INFORMATION ---->
			<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
				<tr valign=middle height=24>
					<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
					<td width=26 background="pics/header_background.gif"><img src="pics/insurance_scroll.gif"></td>
					<td background="pics/header_background.gif"><h2>&nbsp;&nbsp;Insurance & SEVIS Information</h2></td>
					<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
				</tr>
			</table>
			<table width=100% cellpadding=4 cellspacing=0 border=0 class="section" >
				<tr>
					<td align="right"><b>Insurance :</b></td>
					<td><cfif insurance_typeid EQ '0'>
							<font color="FF0000">Insurance Type Information is Missing</font>
						<cfelseif insurance_typeid EQ '1'>
							#rep_info.type# insurance
						<cfelse>
							Takes #rep_info.type# insurance
						</cfif>
					</td>
				</tr>
				<tr>
					<td align="right"><b>SEVIS : </b></td>
					<td><cfif accepts_sevis_fee EQ ''>
							Missing SEVIS fee information
						<cfelseif rep_info.accepts_sevis_fee EQ 0>
							Does not accept SEVIS fee
						<cfelse>
							Accepts SEVIS fee.
						</cfif><br>						
					</td>
				</tr>
			</table>
			<table width=100% cellpadding=0 cellspacing=0 border=0>
				<tr valign=bottom >
					<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
					<td width=100% background="pics/header_background_footer.gif"></td>
					<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
				</tr>
			</table>
			<br>
			<!--- STATEMENT --->		
			<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
				<tr valign=middle height=24>
					<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
					<td width=26 background="pics/header_background.gif"><img src="pics/$.gif"><img src="pics/$.gif"><img src="pics/$.gif"></td>
					<td background="pics/header_background.gif"><h2>&nbsp;&nbsp;Account Activity - Statement</td>
					<td background="pics/header_background.gif" width=16></a></td>
					<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
				</tr>
			</table>
			<table width=100% cellpadding=4 cellspacing=0 border=0 class="section" >
				<tr>
					<td style="line-height:20px;" valign="top">
						<!--- HIDE STATEMENT FOR OFFICE USERS AND LITZ AND ECSE AGENTS --->
						<cfquery name="invoice_check" datasource="caseusa">
							select invoice_access 
							from smg_users
							where userid = '#client.userid#'
						</cfquery>
						<cfif (client.userid EQ 64 OR client.userid EQ 126) OR (client.usertype NEQ 8 AND invoice_check.invoice_access NEQ 1)> 
							Not available. <br /> 
							If you wish a copy of your statement please contact Stacy Brewer at stacy@case-usa.org
						    <cfelse>
							CASE Detailed Statement : <a href="index.cfm?curdoc=intrep/invoice/statement_detailed" class="smlink" target="_top">View Statement</a><br />
						</cfif>
					</td>
				</tr>
			</table>
			<table width=100% cellpadding=0 cellspacing=0 border=0>
				<tr valign=bottom >
					<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
					<td width=100% background="pics/header_background_footer.gif"></td>
					<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
				</tr>
			</table>
		</td>
	</tr>
</table><br>

</cfif>

</cfform>
</cfoutput>

</body>
</html>