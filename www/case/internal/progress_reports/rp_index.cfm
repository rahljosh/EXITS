<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Progress Reports - Reports</title>
</head>

<!--- REPORTS PER PROGRAM
	10 MONTH - OCT - DEC - FEB - APRIL - JUNE - TYPE = 1
	12 MONTH - FEB - APRIL - AUG - OCT - DEC - TYPE = 2
	1ST SEMESTER - OCT - DEC - FEB - TYPE = 3
	2ND SEMESTER - FEB - APRIL - JUNE - TYPE = 4
	
	10 MONTH PRIVATE - PROGRAM END DATE 06/31
	12 MONTH PRIVATE - PROGRAM END DATE 12/31
	1ST SEMESTER PRIVATE - PROGRAM END DATE 06/31
	2ND SEMESTER PRIVATE - PROGRAM END DATE 01/15
	USE #DateFormat(current_students_status.enddate, 'mm')# EQ '12'
---->

<body>

<cfinclude template="../querys/get_programs.cfm">

<cfinclude template="../querys/get_user_regions.cfm">

<cfoutput>

<cfset listmonth = "10,12,2,4,6,8">

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign="middle" height="24">
		<td height="24" width="13" background="pics/header_leftcap.gif">&nbsp;</td>
		<td width="26" background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>Progress Reports</h2></td>
		<cfif client.usertype LTE 4>
		<td background="pics/header_background.gif" align="right">
			<cfif NOT IsDefined('url.all')><a href="?curdoc=reports/placement_reports_menu&all=1">Show All Programs</a><cfelse><a href="?curdoc=reports/placement_reports_menu">Show Active Programs Only</a></cfif>
		</td>
		</cfif>
		<td width="17" background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table border=0 cellpadding=8 cellspacing=2 width=100% class="section">
<tr><td>

	<!--- Row 1 - 2 boxes --->
	<table cellpadding=6 cellspacing="0" align="center" width="97%">
		<tr>
			<td width="50%" align="left" valign="top">
				<cfform action="progress_reports/rp_missing_report_region.cfm" method="post" target="blank">
				<table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
					<tr><th colspan="2" bgcolor="##e2efc7">Missing Progress Report by Region (Active Students)</th></tr>
					<tr align="left">
						<TD>Program :</td>
						<TD><cfselect name="programid" multiple size="5" required="yes" message="You must select a program in order to continue.">
								<cfloop query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ '5'>#companyshort# - </cfif>#programname#</option></cfloop>
							</cfselect>
						</td>
					</tr>
					<tr align="left">
						<TD>Region :</td>
						<TD><cfselect name="regionid" query="get_regions" value="regionid" display="regionname" queryPosition="below">
								<cfif client.usertype LTE 4><option value=0>All Regions</option></cfif>
							</cfselect>
						</td>		
					</tr>	
					<tr align="left">
						<td>Month :</td>
						<td><cfselect name="rmonth">
								<cfloop list="#listmonth#" index="i">
									<option value="#i#">#MonthAsString(i)#</option>
								</cfloop>
							</cfselect>
						</td>		
					</tr>
					<tr><TD colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
				</table>
				</cfform>
			</td>
			<td width="50%" align="right" valign="top">
				<cfform action="progress_reports/rp_missing_all_reports_region.cfm" method="post" target="blank">
				<table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
					<tr><th colspan="2" bgcolor="##e2efc7">Missing ALL Progress Reports by Region (Active Students)</th></tr>
					<tr align="left">
						<TD>Program :</td>
						<TD><cfselect name="programid" multiple size="5" required="yes" message="You must select a program in order to continue.">
								<cfloop query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ '5'>#companyshort# - </cfif>#programname#</option></cfloop>
							</cfselect>
						</td>
					</tr>
					<tr align="left">
						<TD>Region :</td>
						<TD><cfselect name="regionid" query="get_regions" value="regionid" display="regionname" queryPosition="below">
								<cfif client.usertype LTE 4><option value=0>All Regions</option></cfif>
							</cfselect>
						</td>		
					</tr>	
					<tr><TD colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
				</table>
				</cfform>
			</td>
		</tr>
	</table><br>

</td></tr>
</table>
<cfinclude template="../table_footer.cfm">	

</cfoutput>

</body>
</html>