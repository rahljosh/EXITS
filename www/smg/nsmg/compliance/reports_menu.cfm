<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Reports for Compliance</title>
</head>

<body>

<style type="text/css">
	table.nav_bar { font-size: 10px; background-color: #ffffe6; border: 1px solid e2efc7; }
</style>

<cfinclude template="../querys/get_programs.cfm">

<cfinclude template="../querys/get_facilitators.cfm">

<cfinclude template="../querys/get_user_regions.cfm">

<cfinclude template="../querys/get_seasons.cfm">

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>COMPLIANCE - Placement Reports</h2></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table border=0 cellpadding=8 cellspacing=2 width=100% class="section">
<tr><td>
		<!--- Row 1 - 2 boxes --->
		<table cellpadding=6 cellspacing="0" align="center" width="95%">
		<tr>
			<td width="50%" align="left" valign="top">
				<cfform action="compliance/documents_received.cfm" name="doc_received" method="POST" target="blank">
				<Table class="nav_bar" cellpadding=6 cellspacing="0" align="left" width="100%">
					<tr><th colspan="2" bgcolor="e2efc7">Placement Documents Received per Period</th></tr>
					<tr align="left">
						<TD>Program :</td>
						<TD><cfselect name="programid" query="get_program" value="ProgramID" display="programname" multiple="yes" size="5" required="yes" message="You must select at least one program."></cfselect></td>
					</tr>
					<tr align="left">
						<TD>Region :</td>
						<TD><cfselect name="regionid" size="1">
							<option value=0>All Regions</option>
							<cfoutput query="get_regions"><option value="#regionid#">#regionname#</option></cfoutput>
							</cfselect></td>		
					</tr>
					<tr><td width="5">From : </td><td><cfinput type="text" name="date1" size="8" maxlength="10" required="yes" message="Start date is required."></cfinput> mm/dd/yyyy</td></tr>
					<tr><td width="5">To : </td><td><cfinput type="text" name="date2" size="8" maxlength="10" required="yes"  message="End date is required."></cfinput> mm/dd/yyyy</td></tr>
					<tr>
						<TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
					</tr>
				</table>
				</cfform>
			</td>
			<td width="50%" align="right" valign="top">
				<cfform action="compliance/placement_paperwork.cfm" name="doc_received" method="POST" target="blank">
				<Table class="nav_bar" cellpadding=6 cellspacing="0" align="left" width="100%">
					<tr><th colspan="2" bgcolor="e2efc7">Placement Paperwork</th></tr>
					<tr align="left">
						<TD>Program :</td>
						<TD><cfselect name="programid" query="get_program" value="ProgramID" display="programname" multiple size="5" required="yes" message="You must select at least one program."></cfselect></td>
					</tr>
					<tr align="left">
						<TD>Region :</td>
						<td><cfselect name="regionid" query="get_regions" value="regionid" display="regionname" multiple="yes" size="5" required="yes" message="You must select a region" queryPosition="below">
								<option value=0>All Regions</option>
							</cfselect>						
						</td>
					</tr>
					<tr>
						<TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
					</tr>
				</table>
				</cfform>
			</td>
		</tr>
		</table><br>
		
		<!--- Row 2 - 2 boxes --->
		<table cellpadding=6 cellspacing="0" align="center" width="95%">
		<tr>
			<td width="50%" align="left" valign="top">
				<cfform action="compliance/rp_arrival_x_cbc.cfm" name="doc_received" method="POST" target="blank">
				<Table class="nav_bar" cellpadding=6 cellspacing="0" align="left" width="100%">
					<tr><th colspan="2" bgcolor="e2efc7">Student Arrival Date x CBC Date (No Relocations)</th></tr>
					<tr align="left">
						<TD>Program :</td>
						<TD><cfselect name="programid" query="get_program" value="ProgramID" display="programname" multiple size="5" required="yes" message="You must select at least one program."></cfselect></td>
					</tr>
					<tr align="left">
						<TD>Region :</td>
						<td><cfselect name="regionid" query="get_regions" value="regionid" display="regionname" multiple="yes" size="5" required="yes" message="You must select a region" queryPosition="below">
								<option value=0>All Regions</option>
							</cfselect>						
						</td>
					</tr>
					<tr>
						<TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
					</tr>
				</table>
				</cfform>
			</td>
			<td width="50%" align="right" valign="top">
				<cfform action="compliance/rp_placement_x_cbc_relocated.cfm" name="doc_received" method="POST" target="blank">
				<Table class="nav_bar" cellpadding=6 cellspacing="0" align="left" width="100%">
					<tr><th colspan="2" bgcolor="e2efc7">Placement Approval x CBC Date (Students Relocated Only)</th></tr>
					<tr align="left">
						<TD>Program :</td>
						<TD><cfselect name="programid" query="get_program" value="ProgramID" display="programname" multiple size="5" required="yes" message="You must select at least one program."></cfselect></td>
					</tr>
					<tr align="left">
						<TD>Region :</td>
						<td><cfselect name="regionid" query="get_regions" value="regionid" display="regionname" multiple="yes" size="5" required="yes" message="You must select a region" queryPosition="below">
								<option value=0>All Regions</option>
							</cfselect>						
						</td>
					</tr>
					<tr>
						<TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
					</tr>
				</table>
				</cfform>	
			</td>
		</tr>
		</table><br>

		<!--- Row 3 - 2 boxes --->
		<table cellpadding=6 cellspacing="0" align="center" width="95%">
		<tr>
			<td width="50%" align="left" valign="top">
				<cfform action="compliance/school_acceptance.cfm" name="doc_received" method="POST" target="blank">
				<Table class="nav_bar" cellpadding=6 cellspacing="0" align="left" width="100%">
					<tr><th colspan="2" bgcolor="e2efc7">Flight Arrival x School Acceptance Dates</th></tr>
					<tr align="left">
						<TD>Program :</td>
						<TD><cfselect name="programid" query="get_program" value="ProgramID" display="programname" multiple size="5" required="yes" message="You must select at least one program."></cfselect></td>
					</tr>
					<tr align="left">
						<TD>Region :</td>
						<td><cfselect name="regionid" query="get_regions" value="regionid" display="regionname" multiple="yes" size="5" required="yes" message="You must select a region" queryPosition="below">
								<option value=0>All Regions</option>
							</cfselect>						
						</td>
					</tr>
					<tr>
						<TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
					</tr>
				</table>
				</cfform>
			</td>
			<td width="50%" align="right" valign="top">
				<cfform action="compliance/arrival_school_acceptance_check.cfm" name="doc_received" method="POST" target="blank">
				<Table class="nav_bar" cellpadding=6 cellspacing="0" align="left" width="100%">
					<tr><th colspan="2" bgcolor="e2efc7">Students with Arrival Information and Missing School Acceptance (Place Management)</th></tr>
					<tr align="left">
						<TD>Program :</td>
						<TD><cfselect name="programid" query="get_program" value="ProgramID" display="programname" multiple size="5" required="yes" message="You must select at least one program."></cfselect></td>
					</tr>
					<tr>
						<TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
					</tr>
				</table>
				</cfform>			
			</td>
		</tr>
		</table>

		<!--- Row 4 - 2 boxes --->
		<table cellpadding=6 cellspacing="0" align="center" width="95%">
		<tr>
			<td width="50%" align="left" valign="top">
				<cfform action="compliance/missing_place_docs.cfm" name="doc_received" method="POST" target="blank">
				<Table class="nav_bar" cellpadding=6 cellspacing="0" align="left" width="100%">
					<tr><th colspan="2" bgcolor="e2efc7">Missing Compliance Placement Documents</th></tr>
					<tr align="left">
						<TD>Program :</td>
						<TD><cfselect name="programid" query="get_program" value="ProgramID" display="programname" multiple size="5" required="yes" message="You must select at least one program."></cfselect></td>
					</tr>
					<tr>
						<TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
					</tr>
				</table>
				</cfform>
			</td>
			<td width="50%" align="right" valign="top">
				<cfform action="compliance/missing_supervision_docs.cfm" name="doc_received" method="POST" target="blank">
				<Table class="nav_bar" cellpadding=6 cellspacing="0" align="left" width="100%">
					<tr><th colspan="2" bgcolor="e2efc7">Missing Compliance Supervision Documents</th></tr>
					<tr align="left">
						<TD>Program :</td>
						<TD><cfselect name="programid" query="get_program" value="ProgramID" display="programname" multiple size="5" required="yes" message="You must select at least one program."></cfselect></td>
					</tr>
					<tr>
						<TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
					</tr>
				</table>
				</cfform>
			</td>
		</tr>
		</table>

		<!--- Row 5 - 2 boxes --->
		<table cellpadding=6 cellspacing="0" align="center" width="95%">
		<tr>
			<td width="50%" align="left" valign="top">
				<cfform action="compliance/missing_double_docs.cfm" name="doc_received" method="POST" target="blank">
				<Table class="nav_bar" cellpadding=6 cellspacing="0" align="left" width="100%">
					<tr><th colspan="2" bgcolor="e2efc7">Missing Compliance Double Placement Documents</th></tr>
					<tr align="left">
						<TD>Program :</td>
						<TD><cfselect name="programid" query="get_program" value="ProgramID" display="programname" multiple size="5" required="yes" message="You must select at least one program."></cfselect></td>
					</tr>
					<tr>
						<TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
					</tr>
				</table>
				</cfform>
			</td>
			<td width="50%" align="right" valign="top">
				<cfform action="compliance/missing_area_rep_paperwork.cfm" name="area_rep" method="POST" target="blank">
				<Table class="nav_bar" cellpadding=6 cellspacing="0" align="left" width="100%">
					<tr><th colspan="2" bgcolor="e2efc7">Missing Area Representative Paperwork</th></tr>
					<tr align="left">
						<TD>Season :</td>
						<TD><cfselect name="seasonid" query="get_seasons" display="season" value="seasonid" queryPosition="below">			
							<option value=0>Contract AYP</option>
							</cfselect>
						</td>
					</tr>
					<tr align="left">
						<TD>Region :</td>
						<td><cfselect name="regionid" query="get_regions" value="regionid" display="regionname" multiple="yes" size="5" required="yes" message="You must select a region" queryPosition="below">
								<option value=0>All Regions</option>
							</cfselect>						
						</td>
					</tr>
					<tr align="left">
						<TD>Status :</td>
						<td><cfselect name="status">
								<option value="All">All</option>
								<option value="1">Active</option>
								<option value="0">Inactive</option>
							</cfselect>						
						</td>
					</tr>															
					<tr><TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
				</table>
				</cfform>
			</td>
		</tr>
		</table>
</td></tr>
</table>

<cfinclude template="../table_footer.cfm">

</body>
</html>