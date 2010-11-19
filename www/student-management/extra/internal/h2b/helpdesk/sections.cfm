<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Sections</title>

</head>

<body>

<cftry>

<Cfquery name="get_sections" datasource="MySQL">
	SELECT sectionid, sectionname, assignedid
	FROM smg_help_desk_section
	WHERE systemid = '4' <!--- EXTRA --->
</Cfquery>

<cfquery name="get_users" datasource="mysql">
	SELECT firstname, lastname, userid
	FROM smg_users
	WHERE usertype = '1'
	ORDER BY firstname
</cfquery>

<cfoutput>

<cfform method="post" name="helpdesk_sections" action="?curdoc=helpdesk/qr_sections">
<cfinput type="hidden" name="count" value="#get_sections.recordcount#">
<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="CCCCCC" bgcolor="f4f4f4">
	<tr>
		<td bordercolor="FFFFFF">
			<!----Header Table---->
			<table width=95% cellpadding=0 cellspacing=0 border=0 align="center" height="25" bgcolor="E4E4E4">
				<tr bgcolor="E4E4E4">
					<td class="title1">&nbsp; &nbsp; Help Desk Section Maintenance</td>
				</tr>
			</table>
			<br>
			<table width="90%" border="0" cellpadding="0" cellspacing="0" align="center" bordercolor="C7CFDC">	
				<tr>
					<td>
						<table width="100%" cellpadding=3 cellspacing=0 border=0>
							<tr class="style2">	
								<td width="10%" bgcolor="4F8EA4">ID</td>
								<td width="45%" bgcolor="4F8EA4">Section</td>
								<td width="45%" bgcolor="4F8EA4">Assigned To</td>
							</tr>
							<cfloop query="get_sections">
								<tr bgcolor="#iif(currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#" class="style5">
									<td>#sectionid# <cfinput type="hidden" name="#currentrow#_sectionid" value="#sectionid#"></td>
									<td><cfinput type="text" name="#currentrow#_sectionname" value="#sectionname#" size="40"></td>
									<td>
										<cfset section_user = #get_sections.assignedid#>
										<cfselect name="#currentrow#_userid">
											<option value="0"></option>
											<cfloop query="get_users">
													<option value="#userid#" <cfif userid EQ section_user>selected</cfif>>#firstname# #lastname#</option>
											</cfloop>
										</cfselect>
									</td>
								</tr>
							</cfloop>
						</table>
					</td>
				</tr>
			</table>
			<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
				<tr><td align="center"><br><cfinput name="Submit" type="image" value="  Save  " src="../pics/save.gif" alt="Next" border="0"></td></tr>
			</table>							
		</td>
	</tr>
</table>
</cfform>

</cfoutput>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</cftry>

</body>
</html>